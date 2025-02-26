import Foundation
import SwiftData

protocol BookmarkStorageType {
//    associatedtype B: Bookmark
    func loadObjects() -> [Bookmark]
    func loadHomeObject() -> Bookmark?
    func saveObject(_ object: Bookmark)
    func removeObject(for key: UUID)
    func removeAllObjects()
}

final class BookmarkStorage: BookmarkStorageType {
    typealias B = Bookmark
    private let storage: any StorageType
    
    init(storage: any StorageType = SwiftDataStorage(model: Bookmark.self)) {
        self.storage = storage
    }
    
    func loadObjects() -> [Bookmark] {
        do {
            let data = (try storage.loadData() as [Bookmark])
                .sorted { $0.dateAdded < $1.dateAdded }
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func loadHomeObject() -> Bookmark? {
        do {
            let data = (try storage.loadData() as [Bookmark])
                .first(where: { $0.isHome })
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return nil
        }
    }
    
    func saveObject(_ object: Bookmark) {
        storage.insertModel(object)
    }
    
    func removeObject(for key: UUID) {
        do {
            let predicate = #Predicate<Bookmark> { mark in
                mark.id == key
            }
            try storage.removeModelWithPrecidate(Bookmark.self, predicate: predicate)
        } catch {
            assertionFailure("No Model to remove for key: \(key).")
        }
    }
    
    func removeAllObjects() {
        do {
            try storage.removeAllModels(Bookmark.self)
        } catch {
            assertionFailure("No Model to remove.")
        }
    }
}
