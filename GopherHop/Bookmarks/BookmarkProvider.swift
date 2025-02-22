import Foundation


protocol BookmarkProviderType {
    
}

final class BookmarkProvider: BookmarkProviderType, ObservableObject {
    private let storage: any BookmarkStorageType
    @Published var bookmarks = [Bookmark]()
    
    init(storage: any BookmarkStorageType = BookmarkStorage()) {
        self.storage = storage
    }
    
    func loadBookmarks() {
        bookmarks = storage.loadObjects()
//        storage = BookmarkStorage(storage: Storage(model: HistoryEntry.self))
    }
    
    func deleteBookmark(at offset: IndexSet) {
        guard let index = offset.first else { return }
        let element = bookmarks.remove(at: index)
        storage.removeObject(for: element.id)
    }
    
    func addToBookmarks(_ site: GopherLine?) {
        guard let site else { return }
        storage.saveObject(Bookmark(host: site.host, port: site.port, path: site.path))
        loadBookmarks()
    }
}
