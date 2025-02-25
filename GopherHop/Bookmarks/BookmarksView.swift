import SwiftUI

struct BookmarksView: View {
    
    @State var currentSite: GopherLine?
    @StateObject var provider: BookmarkProvider
    
    let lineTapped: ((GopherLine) -> Void)?
    let dismissTapped: (() -> Void)?
    
    @AppStorage("Motive") private var motive: SettingsColorMotive?
    
    init(
        currentSite: GopherLine? = nil,
        bookmarkTapped: ((GopherLine) -> Void)? = nil,
        dismissTapped: (() -> Void)? = nil,
        modelStorage: any StorageType = SwiftDataStorage(model: Bookmark.self)
    ) {
        self.currentSite = currentSite
        _provider = StateObject(wrappedValue: BookmarkProvider(storage: BookmarkStorage(storage: modelStorage)))
        self.dismissTapped = dismissTapped
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
                        dismissTapped?()
                    }
                    .listRowBackground(Color.gopherBackground(for: motive))
                    
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
                dismissTapped?()
            } label: {
                Text("Dismiss")
            }
        }
        
        .scrollContentBackground(.hidden)
        .background(Color.gopherBackground(for: motive))
        .foregroundStyle(Color.gopherDocument(for: motive))
        
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
    @AppStorage("Motive") private var motive: SettingsColorMotive?
    
    var body: some View {
        Text(bookmark)
            .foregroundStyle(Color.gopherHole(for: motive))
    }
}

#Preview {
    BookmarksView()
}
