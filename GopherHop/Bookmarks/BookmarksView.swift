import SwiftUI

struct BookmarksView: View {
    @State private var bookmarks: [String] = [
        "hngopher.com:70",
        "gopher.black:70",
        "infinitelyremote.com:70"
    ]
    
    @State var currentSite: String?
    
    var body: some View {
        List {
            ForEach(bookmarks, id: \.self) { mark in
                BookmarksSubView(bookmark: mark)
            }
            .onDelete { set in
                bookmarks.remove(atOffsets: set)
            }
            Button {
                guard let currentSite else { return }
                bookmarks.append(currentSite)
                self.currentSite = nil
            } label: {
                Text("Add current to bookmarks")
            }
        }
        
    }
}

struct BookmarksSubView: View {
    let bookmark: String
    var body: some View {
        Text(bookmark)
    }
}

#Preview {
    let site = "gopher.web"
    BookmarksView(currentSite: site)
}
