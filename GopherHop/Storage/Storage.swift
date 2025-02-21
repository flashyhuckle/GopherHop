import Foundation
import SwiftData

protocol StorageType<T> {
    associatedtype T
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

final class Storage: StorageType {
    typealias T = PersistentModel
    
    private var context: ModelContext?
    
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
    
    func loadData<T: PersistentModel>() throws -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            let data = try context?.fetch(descriptor) ?? []
            return data
        } catch {
            throw StorageError.loadError
        }
    }
    
    func insertModel<T: PersistentModel>(_ model: T) {
        context?.insert(model)
    }
    
    func removeModelWithPrecidate<T: PersistentModel>(_ model: T.Type, predicate: Predicate<T>) throws {
        do {
            try context?.delete(model: T.self, where: predicate)
        } catch {
            throw StorageError.deleteError
        }
    }
    
    func removeAllModels<T: PersistentModel>(_ model: T.Type) throws {
        do {
            try context?.delete(model: T.self)
        } catch {
            throw StorageError.deleteError
        }
    }
}

final class BookmarkStorage: BookmarkStorageType {
    private let storage: any StorageType
    
    init(storage: any StorageType = Storage(model: Bookmark.self)) {
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


final class HistoryStorage: HistoryStorageType {
    private let storage: StorageType
    
    init(storage: StorageType = Storage(model: HistoryEntry.self)) {
        self.storage = storage
    }
    
    func loadObjects() -> [HistoryEntry] {
        do {
            let data = (try storage.loadData() as [HistoryEntry])
                .sorted { $0.dateVisited < $1.dateVisited }
            return data
        } catch {
            assertionFailure("Load objects error: \(error)")
            return []
        }
    }
    
    func saveObject(_ object: HistoryEntry) {
        storage.insertModel(object)
    }
    
    func removeObject(for key: Date) {
        do {
            let predicate = #Predicate<HistoryEntry> { mark in
                mark.dateVisited == key
            }
            try storage.removeModelWithPrecidate(HistoryEntry.self, predicate: predicate)
        } catch {
            assertionFailure("No Model to remove for key: \(key).")
        }
    }
    
    func removeAllObjects() {
        do {
            try storage.removeAllModels(HistoryEntry.self)
        } catch {
            assertionFailure("No Model to remove.")
        }
    }
}

