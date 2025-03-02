import SwiftUI

struct BookmarksView: View {
    @State var currentSite: GopherLine?
    @StateObject var provider: BookmarkProvider
    
    let lineTapped: ((GopherLine) -> Void)?
    let dismissTapped: (() -> Void)?
    
    @AppStorage(GopherConstants.Settings.motive) private var motive: SettingsColorMotive?
    
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
            Section {
                ForEach(provider.bookmarks, id: \.self) { mark in
                    Button {
                        lineTapped?(GopherLine(lineType: mark.type, host: mark.host, path: mark.path, port: mark.port))
                        dismissTapped?()
                    } label: {
                        BookmarksSubView(bookmark: mark)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            provider.setAsHome(bookmark: mark)
                        } label: {
                            Image(systemName: GopherConstants.BookmarksView.home)
                        }
                    }
                    .listRowBackground(Color.gopherBackground(for: motive))
                }
                .onDelete { set in
                    provider.deleteBookmark(at: set)
                }
            }
            
            Section {
                Button {
                    provider.addToBookmarks(currentSite)
                    currentSite = nil
                } label: {
                    Text(GopherConstants.BookmarksView.addCurrent)
                        .foregroundStyle(Color.gopherBackground(for: motive))
                        .gopherFont(size: .large)
                }
                .disabled(currentSite == nil)
                .listRowBackground(Color.gopherHole(for: motive))
                
            }
            
            Section {
                Button {
                    dismissTapped?()
                } label: {
                    Text(GopherConstants.Buttons.dismiss)
                        .foregroundStyle(Color.gopherBackground(for: motive))
                        .gopherFont(size: .large)
                }
                .listRowBackground(Color.gopherHole(for: motive))
            }
        }
        
        .scrollContentBackground(.hidden)
        .background(Color.gopherBackground(for: motive))
        .foregroundStyle(Color.gopherDocument(for: motive))
        
        .onAppear {
            provider.loadBookmarks()
            if provider.bookmarks.contains(where: {$0.fullAddress == currentSite?.fullAddress}) { currentSite = nil }
        }
        .refreshable {
            provider.loadBookmarks()
        }
    }
}

struct BookmarksSubView: View {
    let bookmark: Bookmark
    @AppStorage(GopherConstants.Settings.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        HStack {
            if bookmark.isHome {
                Image(systemName: GopherConstants.BookmarksView.home)
            }
            Text(bookmark.fullAddress)
                .gopherFont(size: .large)
                .foregroundStyle(Color.gopherHole(for: motive))
        }
    }
}

#Preview {
    BookmarksView()
}
