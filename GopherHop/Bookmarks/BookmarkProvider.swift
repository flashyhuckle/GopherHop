import Foundation


protocol BookmarkProviderType {
    
}

final class BookmarkProvider: BookmarkProviderType, ObservableObject {
    private let storage: BookmarkStorageType
    @Published var bookmarks = [Bookmark]()
    
    init(storage: BookmarkStorageType = BookmarkStorage()) {
        self.storage = storage
    }
    
    func loadBookmarks() {
        bookmarks = storage.loadObjects()
    }
    
    func deleteBookmark(at offset: IndexSet) {
        guard let index = offset.first else { return }
        let element = bookmarks.remove(at: index)
        storage.removeObject(for: element.id)
    }
    
    func addBookmarks() {
        storage.saveObject(Bookmark(host: "hngopher.com", port: 70, path: ""))
        storage.saveObject(Bookmark(host: "gopher.black", port: 70, path: ""))
        storage.saveObject(Bookmark(host: "infinitelyremote.com", port: 70, path: ""))
        loadBookmarks()
    }
}
