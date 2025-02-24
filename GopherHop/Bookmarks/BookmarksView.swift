import SwiftUI

struct BookmarksView: View {
//    @State private var bookmarks: [String] = [
//        "hngopher.com:70",
//        "gopher.black:70",
//        "infinitelyremote.com:70"
//    ]
    
    @State var currentSite: GopherLine?
    
    @StateObject var provider: BookmarkProvider
    @Binding var isBookmarksVisible: Bool
    
    let lineTapped: ((GopherLine) -> Void)?
    
    init(
        currentSite: GopherLine? = nil,
        isBookmarksVisible: Binding<Bool>,
        bookmarkTapped: ((GopherLine) -> Void)?,
        modelStorage: any StorageType = SwiftDataStorage(model: Bookmark.self)
    ) {
        self.currentSite = currentSite
        _provider = StateObject(wrappedValue: BookmarkProvider(storage: BookmarkStorage(storage: modelStorage)))
        _isBookmarksVisible = isBookmarksVisible
        self.lineTapped = bookmarkTapped
    }
    
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
                    .onTapGesture {
                        lineTapped?(GopherLine(host: mark.host, path: mark.path, port: mark.port))
                        isBookmarksVisible.toggle()
                    }
            }
            .onDelete { set in
                provider.deleteBookmark(at: set)
            }
            Button {
                provider.addToBookmarks(currentSite)
                currentSite = nil
            } label: {
                Text("Add current to bookmarks")
            }
            
            Button {
                isBookmarksVisible.toggle()
            } label: {
                Text("Dismiss")
            }
        }
        
        .onAppear {
            provider.loadBookmarks()
        }
        .refreshable {
            provider.loadBookmarks()
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
    BookmarksView(currentSite: nil, isBookmarksVisible: $visible, bookmarkTapped: nil)
}
