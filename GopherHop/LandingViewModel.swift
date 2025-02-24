import SwiftUI

enum OverlayView {
    case settings, bookmarks, address, none
}

@MainActor
final class LandingViewModel: ObservableObject {
    
    @Published var cache = [Gopher]() { didSet { navigationEnabled = !cache.isEmpty }}
    @Published var current = Gopher()
    var currentAddress: GopherLine?
    
    private var scrollToLine: GopherLine.ID?
    private var scrollToLineOffset: CGFloat?
    
    @Published var visibleOverlayView: OverlayView = .none
    
    @Published var navigationEnabled = false
    @Published var offset: CGFloat = 0.0
    @Published var gopherPosition: GopherHelperPosition = .bottom
    
    private var refreshDataTask: Task<Void, Never>?
    
    private let client: GopherClient
    let storage: any StorageType
    
    init(client: GopherClient = GopherClient(), storage: any StorageType = SwiftDataStorage(model: Bookmark.self)) {
        self.client = client
        self.storage = storage
    }
    
    func scrollViewMovedUp(_ directionUp: Bool) {
        gopherPosition = directionUp ? .top : .bottom
    }
    
    func screenTapped(at location: CGPoint) {
        scrollToLineOffset = location.y
    }
    
    func lineTapped(line: GopherLine) {
        scrollToLine = line.id
        makeRequest(line: line)
    }
    
#warning("set home hole")
    func homepage() {
        makeRequest(line: GopherLine(host: "gopher.black"))
    }
    
    func goBack() {
        guard let destination = cache.popLast() else { return }
        current = destination
        currentAddress = destination.address
    }
    
    func settingsTapped() { visibleOverlayView = .settings }
    
    func bookmarkTapped() { visibleOverlayView = .bookmarks }
    
    func globeTapped() { visibleOverlayView = .address }
    
    func dismissTapped() { visibleOverlayView = .none }
    
    func reload() {
        guard let currentAddress else { return }
        makeRequest(line: currentAddress, writeToHistory: false)
    }
    
    private func makeRequest(line: GopherLine, writeToHistory: Bool = true) {
        refreshDataTask?.cancel()
        
        refreshDataTask = Task {
            do {
                let newHole = try await client.request(item: line)
                let newGopher = Gopher(hole: newHole)
                //append to history unless its an empty lines hole
                if writeToHistory, case let .lines(lines) = self.current.hole { if !lines.isEmpty {
                    let gopherToSave = Gopher(hole: current.hole, address: currentAddress, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: scrollToLineOffset))
                    self.cache.append(gopherToSave)
                }}
                scrollToLine = nil
                scrollToLineOffset = nil
                
                self.currentAddress = line
                self.current = newGopher
            } catch {
                print(error.localizedDescription)
#warning("present error")
            }
        }
    }
}
