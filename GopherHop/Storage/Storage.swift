import Foundation
import SwiftData

protocol StorageType<T> {
    associatedtype T
    func loadData<T: PersistentModel>() throws -> [T]
    func insertModel<T: PersistentModel>(_ model: T)
    func removeModelWithPrecidate<T: PersistentModel>(_ model: T.Type, predicate: Predicate<T>) throws
    func removeAllModels<T: PersistentModel>(_ model: T.Type) throws
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
            let context = ModelContext(container)
            context.autosaveEnabled = true
            self.context = context
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
