import SwiftUI
import Combine

protocol LandingViewModelType: ObservableObject {
    var current: Gopher { get set }
    var cache: [Gopher] { get set }
    var gopherViewOffset: CGFloat { get set }
    var cacheNavigationEnabled: Bool { get set }
    var gopherPosition: GopherHelperPosition { get set }
    var isSettingsVisible: Bool { get set }
    
    func scrollViewMovedUp(_ directionUp: Bool)
    func screenTapped(at location: CGPoint)
    func lineTapped(line: GopherLine)
    func homepage() 
    func goBack()
    func settingsTapped()
    func reload()
}

@MainActor
final class LandingViewModel: LandingViewModelType {
    
    @Published var cache = [Gopher]() { didSet { cacheNavigationEnabled = !cache.isEmpty }}
    
    private var currentAddress = ""
    @Published var current = Gopher()
    
    private var scrollToLine: GopherLine.ID?
    private var scrollToLineOffset: CGFloat?
    
    @Published var isSettingsVisible = false
    
    @Published var cacheNavigationEnabled = false
    @Published var gopherViewOffset: CGFloat = 0.0
    
    @Published var gopherPosition: GopherHelperPosition = .down
    
    private var refreshDataTask: Task<Void, Never>?
    
    private let client: GopherClientType
    
    private var addressBarText = ""
//    @FocusState private var addressBarFocused
    
//    @Published var future = [Gopher]()
    
    init(client: GopherClientType = GopherClient()) {
        self.client = client
    }
    
    func scrollViewMovedUp(_ directionUp: Bool) {
        gopherPosition = directionUp ? .up : .down
    }
    
    func screenTapped(at location: CGPoint) {
        scrollToLineOffset = location.y
    }
    
    func lineTapped(line: GopherLine) {
        scrollToLine = line.id
        makeRequest(line: line)
    }
    
    func homepage() {
        makeRequest(line: GopherLine(host: "hngopher.com"))
    }
    
    func goBack() {
        guard let destination = cache.popLast() else { return }
        current = destination
    }
    
    func settingsTapped() {
        isSettingsVisible = true
    }
    
    func reload() {
        #warning("reloading after going back creates a bug - manage current gopherhole")
        makeRequest(line: addressBarText.getGopherLineForRequest(), writeToHistory: false)
    }
    
    private func makeRequest(line: GopherLine, writeToHistory: Bool = true) {
        addressBarText = line.host + ":" + String(line.port) + line.path
        
        refreshDataTask?.cancel()
        
        refreshDataTask = Task {
            do {
                let newHole = try await client.request(item: line)
                let newGopher = Gopher(hole: newHole)
                //append to history unless its an empty lines hole
                if writeToHistory, case let .lines(lines) = self.current.hole { if !lines.isEmpty {
                    let gopherToSave = Gopher(hole: current.hole, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: scrollToLineOffset))
                    self.cache.append(gopherToSave)
                }}
                scrollToLine = nil
                scrollToLineOffset = nil
                
                self.current = newGopher
            } catch {
                print(error.localizedDescription)
#warning("present error")
            }
        }
    }
}
