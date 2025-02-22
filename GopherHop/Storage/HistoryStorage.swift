import Foundation
import SwiftData

protocol HistoryStorageType {
    func loadObjects() -> [HistoryEntry]
    func saveObject(_ object: HistoryEntry)
    func removeObject(for key: Date)
    func removeAllObjects()
}

final class HistoryStorage: HistoryStorageType {
    private typealias H = HistoryEntry
    private let storage: any StorageType
    
    init<H>(storage: any StorageType<H> = Storage(model: HistoryEntry.self)) {
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
