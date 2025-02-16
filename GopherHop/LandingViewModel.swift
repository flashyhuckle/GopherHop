import SwiftUI

final class LandingViewModel: ObservableObject, Sendable {
    
    @Published var history = [Gopher]() {
        didSet {
            navigationEnabled = !history.isEmpty
        }
    }
    @Published var current = Gopher()
    
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
        current.scrollToLineOffset = location.y
    }
    
    func lineTapped(line: GopherLine) {
        current.scrollToLine = line.id
        makeRequest(line: line)
    }
    
    func homepage() {
        makeRequest(line: GopherLine(host: "gopher.black"))
    }
    
    func goBack() {
        guard let destination = history.popLast() else { return }
        current = destination
    }
    
    func settingsTapped() {
        
    }
    
    func reload() {
        #warning("reloading after going back creates a bug - manage current gopherhole")
        makeRequest(line: addressBarText.getGopherLineForRequest(), writeToHistory: false)
    }
    
    @Sendable
    private func makeRequest(line: GopherLine, writeToHistory: Bool = true) {
        addressBarText = line.host + ":" + String(line.port) + line.path
        
        refreshDataTask?.cancel()
        
        refreshDataTask = Task {
            do {
                let new = try await client.request(item: line)
                //append to history unless its an empty lines hole
                DispatchQueue.main.async {
                    if writeToHistory, case let .lines(lines) = self.current.hole { if !lines.isEmpty { self.history.append(self.current) } }
                    
                    self.current = new
                    if case let .lines(lines) = self.current.hole, let first = lines.first {
                        self.current.scrollToLine = first.id
                        self.current.scrollToLineOffset = 0
                    }
                }
            } catch {
                print(error.localizedDescription)
#warning("present error")
            }
        }
    }
}
