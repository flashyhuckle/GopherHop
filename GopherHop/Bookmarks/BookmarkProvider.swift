import Foundation


protocol BookmarkProviderType: ObservableObject {
    
}

final class BookmarkProvider: BookmarkProviderType {
    private let storage: any BookmarkStorageType
    @Published var bookmarks = [Bookmark]()
    
    init(storage: any BookmarkStorageType = BookmarkStorage()) {
        self.storage = storage
    }
    
    func loadBookmarks() {
        bookmarks = storage.loadObjects()
    }
    
    func loadHome() -> Bookmark? {
        storage.loadHomeObject()
    }
    
    func deleteBookmark(at offset: IndexSet) {
        guard let index = offset.first else { return }
        let element = bookmarks.remove(at: index)
        storage.removeObject(for: element.id)
    }
    
    func addToBookmarks(_ site: GopherLine?, isHome: Bool = false) {
        guard let site else { return }
        storage.saveObject(Bookmark(host: site.host, port: site.port, path: site.path, isHome: isHome))
        loadBookmarks()
    }
    
    func setAsHome(bookmark: Bookmark) {
        for bookmark in bookmarks {
            bookmark.isHome = false
        }
        bookmark.isHome = true
    }
}
