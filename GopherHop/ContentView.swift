import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    
    @ObservedObject var client = GopherClient2(server: "hngopher.com")
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(client.items, id: \.message) { item in
                    Text(item.message)
                }
            }
        }
        .onAppear {
            client.fetchFile(path: "/live/items/42976698/dump.txt")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
