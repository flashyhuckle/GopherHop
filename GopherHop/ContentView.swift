import SwiftUI
import SwiftData

struct ContentView: View {
    @State var history = [Gopher]()
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    let client = GopherClient()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch current.hole {
                case .lines(let lines):
                    //wrapper around gopherlineview
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(lines, id: \.id) { item in
                                GopherLineView(line: item, onTap: lineTapped)
                            }
                        }
                    }
                case .image, .text:
                    FileView(gopher: current)
                default:
                    Text("loading?")
                }
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
        .onAppear {
            homepage()
        }
    }
    
    private func lineTapped(line: GopherLine, type: GopherLineType? = nil) {
        future = []
        makeRequest(line: line, type: type)
    }
    
    private func homepage() {
        makeRequest(line: GopherLine(host: "sdf.org"))
    }
    
    private func goBack() {
        guard let destination = history.popLast() else { return }
        future.insert(current, at: 0)
        current = destination
    }
    
    private func makeRequest(line: GopherLine, type: GopherLineType? = nil) {
        Task {
            let new = try await client.request(item: line, type: type)
            if let type {
                //if going to file
                history.append(current)
            } else {
                //create inapp homepage instead of checking?
                if case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } }
            }
            current = new
        }
        // collapse into one
//        if let type {
//            Task {
//                let file = try await client.request(item: line, type: type)
//                history.append(current)
//                current = file
//            }
//        } else {
//            Task {
//                let new = try await client.request(item: line)
//                switch current.hole {
//                case .lines(let lines):
//                    if !lines.isEmpty {
//                        history.append(current)
//                    }
//                default:
//                    break
//                }
//                
//                current = new
//            }
//        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
