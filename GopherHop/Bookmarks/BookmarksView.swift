import SwiftUI

struct BookmarksView: View {
    @State private var bookmarks: [String] = [
        "hngopher.com:70",
        "gopher.black:70",
        "infinitelyremote.com:70"
    ]
    
    @State var currentSite: String?
    
    @ObservedObject var provider = BookmarkProvider()
    @Binding var isBookmarksVisible: Bool
    
    /*
     List - better way to see bookmarks -> OnTap -> Go to site and dismiss
     
     Top left - go back
     
     top right - edit
     
     floating gopher - Add bookmark -> popup with current address and edit possibility (Ok, Cancel)
     
     */
    
    var body: some View {
        List {
            ForEach(provider.bookmarks, id: \.self) { mark in
                BookmarksSubView(bookmark: mark.fullAddress)
            }
            .onDelete { set in
                provider.deleteBookmark(at: set)
            }
            Button {
                provider.addBookmarks()
                guard let currentSite else { return }
                bookmarks.append(currentSite)
                self.currentSite = nil
            } label: {
                Text("Add current to bookmarks")
            }
        }
        .onAppear {
            provider.loadBookmarks()
        }
        .onTapGesture {
            isBookmarksVisible.toggle()
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
    
    @Previewable @State var visible = true
    let site = "gopher.web"
    BookmarksView(currentSite: site, isBookmarksVisible: $visible)
}
