import SwiftUI
import SwiftData

struct LandingView: View {
    @State var history = [Gopher]()
    @State var navigationEnabled = false
    
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    let client = GopherClient()
    
    @State var offset: CGFloat = 0.0
    
    @State var addressBarText = ""
    @FocusState private var addressBarFocused
    
    @State var gopherPosition: GopherHelperPosition = .down
    
    var body: some View {
        GeometryReader { reader in
            NavigationStack {
                ZStack {
                    if !history.isEmpty {
                        GopherView(gopher: $history.last!, lineTapped: lineTapped)
                            .withGopherBackGestureBottomView(offset: $offset, proxy: reader)
                    }
                    ZStack {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
                        GopherView(gopher: $current, lineTapped: lineTapped)
                            .frame(width: reader.size.width, height: reader.size.height)
                            .simultaneousGesture(SpatialTapGesture().onEnded { current.scrollToLineOffset = $0.location.y })
                    }
                    .withGopherBackGestureTopView(offset: $offset, proxy: reader, goBack: goBack, isOn: $navigationEnabled)
                    .simultaneousGesture(DragGesture().onChanged { gopherPosition = 0 > $0.translation.height ? .up : .down })
                    
                    GopherHelperView(
                        helperPosition: $gopherPosition,
                        settingsTapped: settingsTapped,
                        reloadTapped: reload,
                        homeTapped: homepage,
                        globeTapped: showAddressBar
                    )
                }
            }
        }
//        .animation(.bouncy, value: gopherPosition)
        .refreshable {
            reload()
        }
        
        .onAppear {
            homepage()
        }
        
        .onChange(of: history) { _, new in
            if new.isEmpty { navigationEnabled = false
            } else { navigationEnabled = true }
        }
    }
    
    private func settingsTapped() {
        
    }
    
    private func lineTapped(line: GopherLine) {
        current.scrollToLine = line.id
        makeRequest(line: line)
    }
    
    private func addressBarSearch(_ string: String) {
        
    }
    
    private func homepage() {
        makeRequest(line: GopherLine(host: "gopher.black"))
    }
    
    private func goBack() {
        guard let destination = history.popLast() else { return }
        current = destination
    }
    
    private func goForward() {
//        guard let destination = future.removeFirst() else { return }
    }
    
    private func makeRequest(line: GopherLine, writeToHistory: Bool = true) {
        addressBarText = line.host + ":" + String(line.port) + line.path
#warning("make task cancellable and avoid task spamming")
        Task {
            let new = try await client.request(item: line)
            //append to history unless its an empty lines hole
            if writeToHistory, case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } }
            current = new
            if case let .lines(lines) = current.hole, let first = lines.first {
                current.scrollToLine = first.id
                current.scrollToLineOffset = 0
            }
        }
    }
    
    private func reload() {
        #warning("reloading after going back creates a bug - manage current gopherhole")
        makeRequest(line: addressBarText.getGopherLineForRequest(), writeToHistory: false)
    }
    
    private func showAddressBar() {
        
    }
}

#Preview {
    LandingView()
}
