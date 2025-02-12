import SwiftUI

//This is an alternative to landing view, based on NavigationStack

struct TestView: View {
    
    @State private var position = GopherHelperPosition.down
    let client = GopherClient()
    
    var body: some View {
        ZStack {
            NavigationStack {
                TestGopherLineView(line: GopherLine(host: "gopher.black"), client: client)
            }
            .simultaneousGesture(DragGesture().onChanged { position = 0 > $0.translation.height ? .up : .down })
            
            GopherHelperView(helperPosition: $position)
        }
    }
    
    private func homepage() {
        makeRequest(line: GopherLine(host: "gopher.black"))
    }
    
    private func makeRequest(line: GopherLine) {
        Task {
            let new = try await client.request(item: line)
        }
    }
}

#Preview {
    TestView()
}

struct TestGopherLineView: View {
    let line: GopherLine
    let client: GopherClient
    @State private var current = Gopher()
    
    var body: some View {
        Group {
            switch current.hole {
            case .lines(let lines):
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(lines, id: \.id) { line in
                            NavigationLink {
                                TestGopherLineView(line: line, client: client)
                            } label: {
                                GopherLineSubView(line: line)
                            }
                        }
                    }
                }
            case .image, .gif, .text:
                GopherFileView(gopher: current)
            default:
                Text("unsupported gopher hole")
            }
        }
        .toolbar(.hidden)
        .onAppear {
            Task {
                current = try await client.request(item: line)
            }
        }
    }
}

//Extension that allows swipe to go back in navigation stack without stock "< back" button.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
