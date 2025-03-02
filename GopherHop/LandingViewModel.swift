import SwiftUI

enum OverlayView: Equatable {
    case settings, bookmarks, address, search, message(String, String), none
}

@MainActor
final class LandingViewModel: ObservableObject {
    
    @Published var cache = [Gopher]() { didSet { navigationEnabled = !cache.isEmpty }}
    @Published var current = Gopher()
    var currentAddress: GopherLine?
    
    @Published var isLoading = false {
        didSet {
            print(isLoading)
        }
    }
    
    private var scrollToLine: GopherLine.ID?
    private var scrollToLineOffset: CGFloat?
    private var messageOkAction: (() -> Void)?
    
    @Published var visibleOverlayView: OverlayView = .none
    
    @Published var navigationEnabled = false
    @Published var offset: CGFloat = 0.0
    @Published var gopherPosition: GopherHelperPosition = .bottom
    
    private var searchLine: GopherLine?
    private var refreshDataTask: Task<Void, Never>?
    
    private let client: GopherClient
    let storage: any StorageType
    
    init(client: GopherClient = GopherClient(), storage: any StorageType = SwiftDataStorage(model: Bookmark.self)) {
        self.client = client
        self.storage = storage
    }
    
    func scrollViewMovedUp(_ directionUp: Bool) {
        let newPosition: GopherHelperPosition = directionUp ? .top : .bottom
        if gopherPosition != newPosition { gopherPosition = newPosition }
    }
    
    func screenTapped(at location: CGPoint) {
        scrollToLineOffset = location.y
    }
    
    func lineTapped(line: GopherLine) {
        scrollToLine = line.id
        
        switch line.lineType {
        case .search:
            initiateSearch(from: line)
        case .html:
            openURL(from: line)
        default:
            makeRequest(line: line)
        }
    }
    
    func searchTapped(query: String) {
        guard let searchLine else { return }
        let path = searchLine.path + "\t\(query)"
        makeRequest(line: GopherLine(host: searchLine.host, path: path, port: searchLine.port))
    }
    
    func homepage() {
        visibleOverlayView = .none
        let provider = BookmarkProvider(storage: BookmarkStorage(storage: storage))
        if let home = provider.loadHome() {
            makeRequest(line: GopherLine(host: home.host, path: home.path, port: home.port))
        } else {
            provider.addToBookmarks(GopherLine(host: "gopher.black"), isHome: true)
            makeRequest(line: GopherLine(host: "gopher.black"))
        }
    }
    
    func goBack() {
        guard let destination = cache.popLast() else { return }
        current = destination
        currentAddress = destination.address
    }
    
    func messageOkTapped() {
        messageOkAction?()
        messageOkAction = nil
    }
    
    func settingsTapped() { visibleOverlayView = .settings }
    
    func bookmarkTapped() { visibleOverlayView = .bookmarks }
    
    func globeTapped() { visibleOverlayView = .address }
    
    func dismissTapped() { visibleOverlayView = .none; messageOkAction = nil }
    
    func reload() {
        visibleOverlayView = .none
        guard let currentAddress else { return }
        makeRequest(line: currentAddress, writeToHistory: false)
    }
    
    private func initiateSearch(from line: GopherLine) {
        visibleOverlayView = .search
        searchLine = line
    }
    
    private func openURL(from line: GopherLine) {
        guard line.path.hasPrefix("URL:") else { return }
        guard line.path.count > 4, let url = URL(string: String(line.path[line.path.index(line.path.startIndex, offsetBy: 4)...])) else { return }
        messageOkAction = {
            UIApplication.shared.open(url)
        }
        visibleOverlayView = .message("External Link", "Link opens in your http web browser, proceed?")
    }
    
    private func makeRequest(line: GopherLine, writeToHistory: Bool = true) {
        refreshDataTask?.cancel()
        
        isLoading = true
        refreshDataTask = Task {
            do {
                let newHole = try await client.request(item: line)
                self.isLoading = false
                
                //append to history unless its an empty lines hole
                if writeToHistory, case let .lines(lines) = self.current.hole { if !lines.isEmpty {
                    let gopherToSave = Gopher(hole: current.hole, address: currentAddress, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: scrollToLineOffset))
                    self.cache.append(gopherToSave)
                }}
                
                if case let .lines(lines) = newHole { scrollToLine = lines.first?.id } else { scrollToLine = nil }
                
                let newGopher = Gopher(hole: newHole, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: 0))
                
                scrollToLine = nil
                scrollToLineOffset = nil
                
                self.currentAddress = line
                self.current = newGopher
            } catch let error {
                self.isLoading = false
                if error as! GopherProtocolHandlerError != GopherProtocolHandlerError.connectionCancelled {
                    messageOkAction = { self.makeRequest(line: line) }
                    visibleOverlayView = .message("Something went wrong", "We couldn't reach the server. Try again?")
                } else {
                    print("\(error), action done by user")
                }
            }
        }
    }
}
