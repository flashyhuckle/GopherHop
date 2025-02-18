import SwiftUI

@MainActor
final class LandingViewModel: ObservableObject {
    
    @Published var cache = [Gopher]() { didSet { navigationEnabled = !cache.isEmpty }}
    
    private var currentAddress = ""
    @Published var current = Gopher()
    
    private var scrollToLine: GopherLine.ID?
    private var scrollToLineOffset: CGFloat?
    
    @Published var navigationEnabled = false
    @Published var offset: CGFloat = 0.0
    @Published var gopherPosition: GopherHelperPosition = .down
    
    private var refreshDataTask: Task<Void, Never>?
    
    private let client: GopherClient
    
    
    private var addressBarText = ""
//    @FocusState private var addressBarFocused
    
//    @Published var future = [Gopher]()
    
    init(client: GopherClient = GopherClient()) {
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
        makeRequest(line: GopherLine(host: "gopher.black"))
    }
    
    func goBack() {
        guard let destination = cache.popLast() else { return }
        current = destination
    }
    
    func settingsTapped() {
        
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
