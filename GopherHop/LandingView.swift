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
                .overlay(alignment: .bottom) {
                    Text("Scrolled ID: \(String(describing: scrolledId))").background()
                        }
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
                .onChange(of: current) { _, _ in
                    print("old should scroll to \(history.last?.scrollToLine)")
                    print("new should scroll to \(scrolledId)")
                }
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
    }
    
    private func goForward() {
//        guard let destination = future.removeFirst() else { return }
    }
    
#warning("scroll to top on new links, scroll to previous position on history views")
    
    private func makeRequest(line: GopherLine) {
        addressBarText = line.host + ":" + String(line.port) + line.path
#warning("make task cancellable and avoid task spamming")
        Task {
            let new = try await client.request(item: line)
            //append to history unless its an empty lines hole
            current.scrollToLine = scrolledId
            if case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } } else { history.append(current) }
            current = new
            print(current.scrollToLine)
            scrolledId = nil
        }
    }
    
    private func reload() {
#warning("add current path to gopher")
    }
}

#Preview {
    LandingView()
}
