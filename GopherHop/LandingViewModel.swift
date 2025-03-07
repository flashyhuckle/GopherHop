import SwiftUI

enum OverlayView: Equatable {
    case settings, bookmarks, address, search, message(String, String), none
}

@MainActor
final class LandingViewModel: ObservableObject {
    
    @Published var cache = [Gopher]() { didSet { navigationEnabled = !cache.isEmpty }}
    @Published var current = Gopher()
    var currentAddress: GopherLine?
    
    @Published var isLoading = false
    
    private var scrollToLine: GopherLine.ID?
    private var scrollToLineOffset: CGFloat?
    private var messageOkAction: (() -> Void)?
    
    @Published var visibleOverlayView: OverlayView = .none {
        
        didSet {
#if os(macOS)
            sheetVisible = visibleOverlayView != .none
#endif
        }
    }
    
    #if os(macOS)
    @Published var sheetVisible = false
    #endif
    
    @Published var navigationEnabled = false
    @Published var offset: CGFloat = 0.0
    @Published var gopherPosition: GopherHelperPosition = .bottom
    
    private var searchLine: GopherLine?
    private var requestDataTask: Task<Void, Never>?
    
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
#warning("redo homepage checking - use first bookmark if possible?")
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
        
        requestDataTask?.cancel()
        client.cancelRequest()
        isLoading = false
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
        makeRequest(line: currentAddress)
    }
    
    private func initiateSearch(from line: GopherLine) {
        visibleOverlayView = .search
        searchLine = line
    }
    
    private func openURL(from line: GopherLine) {
        guard line.path.hasPrefix("URL:") else { return }
        guard line.path.count > 4, let url = URL(string: String(line.path[line.path.index(line.path.startIndex, offsetBy: 4)...])) else { return }
        messageOkAction = {
            #if os(macOS)
            NSWorkspace.shared.open(url)
            #else
            UIApplication.shared.open(url)
            #endif
        }
        visibleOverlayView = .message("External Link", "Link opens in your http web browser, proceed?")
    }
    
    private func makeRequest(line: GopherLine) {
        requestDataTask?.cancel()
        
        isLoading = true
        requestDataTask = Task {
            do {
                let newHole = try await client.request(item: line)
                self.isLoading = false
                
                //append to history if its not the same address and its not empty lines hole,
                if self.current.address?.fullAddress != line.fullAddress, case let .lines(lines) = self.current.hole { if !lines.isEmpty {
                    let gopherToSave = Gopher(hole: current.hole, address: currentAddress, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: scrollToLineOffset))
                    self.cache.append(gopherToSave)
                }}
                
                if case let .lines(lines) = newHole { scrollToLine = lines.first?.id } else { scrollToLine = nil }
                
                let newGopher = Gopher(hole: newHole, address: line, scrollTo: ScrollToGopher(scrollToID: scrollToLine, scrollToOffset: 0))
                
                scrollToLine = nil
                scrollToLineOffset = nil
                
                self.currentAddress = line
                self.current = newGopher
            } catch GopherProtocolHandlerError.connectionCancelled {
                print("connection cancelled by user")
            } catch {
                print(error.localizedDescription)
                print(error)
                self.isLoading = false
                messageOkAction = { self.makeRequest(line: line) }
                visibleOverlayView = .message("Something went wrong", "We couldn't reach the server. Try again?")
            }
        }
    }
}
