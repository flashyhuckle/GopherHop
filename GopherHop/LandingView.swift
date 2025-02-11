import SwiftUI
import SwiftData

struct LandingView: View {
    @State var history = [Gopher]()
    @State var navigationEnabled = false
    
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    let client = GopherClient()
    
    @State var offset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { reader in
            NavigationStack {
                ZStack {
                    if !history.isEmpty {
                        GopherView(gopher: $history.last!, lineTapped: lineTapped)
                            .withGopherBackGestureBottomView(offset: $offset, proxy: reader)
                    }
                    
                    GopherView(gopher: $current, lineTapped: lineTapped)
                        .frame(width: reader.size.width, height: reader.size.height)
                        .background(Color(UIColor.systemBackground))
                        .withGopherBackGestureTopView(offset: $offset, proxy: reader, goBack: goBack, isOn: $navigationEnabled)
                    
                    Button {
                        goBack()
                    } label: {
                        //menu bar? icons?
                        Image(systemName: "arrow.left")
                            .padding()
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                            .foregroundStyle(history.isEmpty ? .gray : .red)
                    }
                    .position(x: 20, y: 0)
                    .disabled(history.isEmpty)
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
    
    private func homepage() {
        makeRequest(line: GopherLine(host: "sdf.org"))
    }
    
    private func goBack() {
        guard let destination = history.popLast() else { return }
        future.insert(current, at: 0)
        current = destination
    }
    
    private func goForward() {
//        guard let destination = future.removeFirst() else { return }
    }
    
    private func makeRequest(line: GopherLine) {
#warning("make task cancellable and avoid task spamming")
        Task {
            let new = try await client.request(item: line)
            //append to history unless its an empty lines hole
            if case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } } else { history.append(current) }
            current = new
        }
    }
}

#Preview {
    LandingView()
}
