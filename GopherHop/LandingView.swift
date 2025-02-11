import SwiftUI
import SwiftData

struct LandingView: View {
    @State var history = [Gopher]()
    @State var navigationEnabled = false
    
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    let client = GopherClient()
    
    @State var offset: CGFloat = 0.0
    
    @State var scrolledId: GopherLine.ID?
    
    @State var addressBarText = ""
    @FocusState private var addressBarFocused
    
    var body: some View {
        GeometryReader { reader in
            NavigationStack {
                ZStack {
                    if !history.isEmpty {
                        GopherView(gopher: $history.last!, lineTapped: lineTapped)
                            .withGopherBackGestureBottomView(offset: $offset, proxy: reader)
                    }
                    #warning("different offsets for different orientations, ZStack with background?")
                    ZStack {
                        Color(UIColor.systemBackground)
                            .ignoresSafeArea()
//                            .frame(width: reader.size.width, height: reader.size.height)
                        GopherView(gopher: $current, lineTapped: lineTapped)
                            .frame(width: reader.size.width, height: reader.size.height)
//                                   - reader.safeAreaInsets.top)
//                            .background(Color(UIColor.systemBackground))
                            
                    }
                    .withGopherBackGestureTopView(offset: $offset, proxy: reader, goBack: goBack, isOn: $navigationEnabled)
                    
                }
                
                .scrollPosition(id: $scrolledId)
                //Not yet functional
//                .toolbar {
//                    ToolbarItem(placement: .bottomBar) {
//                        TextField("gopher address", text: $addressBarText)
//                            .focused($addressBarFocused)
//                            .onSubmit {
//                                addressBarSearch(addressBarText)
//                            }
//                    }
//                }
            }
        }
        .onAppear {
            homepage()
        }
        .onChange(of: history) {_, new in
            if new.isEmpty { navigationEnabled = false
            } else { navigationEnabled = true }
        }
    }
    
    private func lineTapped(line: GopherLine) {
        future = []
        makeRequest(line: line)
    }
    
    private func addressBarSearch(_ string: String) {
        
    }
    
    private func homepage() {
        makeRequest(line: GopherLine(host: "sdf.org"))
    }
    
    private func goBack() {
        guard let destination = history.popLast() else { return }
//        future.insert(current, at: 0)
        current = destination
        scrolledId = destination.scrollToLine
    }
    
    private func goForward() {
//        guard let destination = future.removeFirst() else { return }
    }
    
    private func makeRequest(line: GopherLine) {
        addressBarText = line.host + ":" + String(line.port) + line.path
#warning("make task cancellable and avoid task spamming")
        Task {
            let new = try await client.request(item: line)
            //append to history unless its an empty lines hole
            current.scrollToLine = scrolledId
            if case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } } else { history.append(current) }
            current = new
            if case let .lines(lines) = current.hole, let first = lines.first { self.scrolledId = first.id }
        }
    }
    
    private func reload() {
#warning("add current path to gopher")
    }
}

#Preview {
    LandingView()
}
