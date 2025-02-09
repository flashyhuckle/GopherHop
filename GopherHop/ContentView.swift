import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var history = [Gopher]()
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    
    @ObservedObject var client = GopherClient()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                        ForEach(current.lines, id: \.id) { item in
                        GopherLineView(line: item, onTap: lineTapped)
                    }
                }
            }
            Button {
                goBack()
            } label: {
                Image(systemName: "arrow.left")
            }
            .position(x: 20, y: 0)
            .disabled(history.isEmpty)
        }
        .onAppear {
            homepage()
        }
        
        .onChange(of: client.items) { oldValue, newValue in
            if !oldValue.isEmpty {
                history.append(current)
            }
            current = Gopher(lines: newValue)
        }
    }
    
    private func lineTapped(line: GopherLine, type: GopherLineType? = nil) {
        future = []
        client.request(item: line)
    }
    
    private func homepage() {
        client.request(item: GopherLine(host: "sdf.org"))
    }
    
    private func goBack() {
        guard let destination = history.popLast() else { return }
        future.insert(current, at: 0)
        print(future.count)
        current = destination
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
