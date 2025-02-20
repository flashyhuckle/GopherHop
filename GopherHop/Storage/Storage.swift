import Foundation
import SwiftData

protocol StorageType {
    var context: ModelContext? { get }
    
    func loadData<T: PersistentModel>() throws -> [T]
    func insertModel<T: PersistentModel>(_ model: T)
    func removeModelWithPrecidate<T: PersistentModel>(_ model: T.Type, predicate: Predicate<T>) throws
    func removeAllModels<T: PersistentModel>(_ model: T.Type) throws
}

protocol BookmarkStorageType {
    func loadObjects() -> [Bookmark]
    func saveObject(_ object: Bookmark)
    func removeObject(for key: UUID)
    func removeAllObjects()
}

protocol HistoryStorageType {
    func loadObjects() -> [HistoryEntry]
    func saveObject(_ object: HistoryEntry)
    func removeObject(for key: Date)
    func removeAllObjects()
}

enum StorageError: Error {
    case modelContainerNotInitialized
    case loadError
    case deleteError
}

class Storage: StorageType {
    var context: ModelContext?
    
    init<T: PersistentModel>(
        model: T.Type
    ) {
        do {
            let container = try ModelContainer(for: T.self)
            self.context = ModelContext(container)
        } catch {
            assertionFailure(StorageError.modelContainerNotInitialized.localizedDescription)
        }
    }
    
    internal func loadData<T: PersistentModel>() throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            let data = try context?.fetch(descriptor) ?? []
            return data
        } catch {
            throw StorageError.loadError
        }
    }
    
    internal func insertModel<T: PersistentModel>(_ model: T) {
        context?.insert(model)
    }
    
    internal func removeModelWithPrecidate<T: PersistentModel>(_ model: T.Type, predicate: Predicate<T>) throws {
        do {
            try context?.delete(model: T.self, where: predicate)
        } catch {
            throw StorageError.deleteError
        }
    }
    
    internal func removeAllModels<T: PersistentModel>(_ model: T.Type) throws {
        do {
            try context?.delete(model: T.self)
        } catch {
            throw StorageError.deleteError
        }
    }
}

final class BookmarkStorage: Storage, BookmarkStorageType {
    init() {
        super.init(model: Bookmark.self)
    }
    
    func loadObjects() -> [Bookmark] {
        do {
            let data = (try loadData() as [Bookmark])
                .sorted { $0.dateAdded < $1.dateAdded }
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func saveObject(_ object: Bookmark) {
        insertModel(object)
    }
    
    func removeObject(for key: UUID) {
        do {
            let predicate = #Predicate<Bookmark> { mark in
                mark.id == key
            }
            try removeModelWithPrecidate(Bookmark.self, predicate: predicate)
        } catch {
            assertionFailure("No Model to remove for key: \(key).")
        }
    }
    
    func removeAllObjects() {
        do {
            try removeAllModels(Bookmark.self)
        } catch {
            assertionFailure("No Model to remove.")
        }
    }
}


final class HistoryStorage: Storage, HistoryStorageType {
    init() {
        super.init(model: HistoryEntry.self)
    }
    
    func loadObjects() -> [HistoryEntry] {
        do {
            let data = (try loadData() as [HistoryEntry])
                .sorted { $0.dateVisited < $1.dateVisited }
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func saveObject(_ object: HistoryEntry) {
        insertModel(object)
    }
    
    func removeObject(for key: Date) {
        do {
            let predicate = #Predicate<HistoryEntry> { mark in
                mark.dateVisited == key
            }
            try removeModelWithPrecidate(HistoryEntry.self, predicate: predicate)
        } catch {
            assertionFailure("No Model to remove for key: \(key).")
        }
    }
    
    func removeAllObjects() {
        do {
            try removeAllModels(HistoryEntry.self)
        } catch {
            assertionFailure("No Model to remove.")
        }
    }
}

