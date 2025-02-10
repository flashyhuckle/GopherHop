import SwiftUI
import SwiftData

struct ContentView: View {
    @State var history = [Gopher]()
    @State var future = [Gopher]()
    
    @State var current = Gopher()
    let client = GopherClient()
    
    @State var offset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                
                if !history.isEmpty {
                    GopherView(gopher: $history.last!, lineTapped: lineTapped)
                        .allowsTightening(false)
                        .offset(x: (offset - reader.size.width)/2)
                }
                
                GopherView(gopher: $current, lineTapped: lineTapped)
                    .frame(width: reader.size.width)
                    .background(Color(UIColor.systemBackground))
                    .offset(x: offset)
                    .gesture(
                        history.isEmpty ? DragGesture().onChanged{_ in }.onEnded{_ in } :
                            DragGesture()
                            .onChanged { gesture in
                                if gesture.startLocation.x < 50 {
                                    offset = gesture.translation.width
                                }
                            }
                            .onEnded { _ in
                                if abs(Int(offset)) > 200 {
                                    withAnimation {
                                        offset = reader.size.width
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        offset = 0
                                        goBack()
                                    }
                                    
                                } else {
                                    withAnimation {
                                        offset = 0
                                    }
                                }
                            }
                    )
                
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
        Task {
            let new = try await client.request(item: line)
            //append to history unless its an empty lines hole
            if case let .lines(lines) = current.hole { if !lines.isEmpty { history.append(current) } } else { history.append(current) }
            current = new
        }
    }
}

#Preview {
    ContentView()
}
