import Foundation
import SwiftData

@Model
final class HistoryEntry {
    var host: String
    var port: Int
    var path: String
    
    var dateVisited: Date
    
    var fullAddress: String {
        host + ":" + String(port) + path
    }
    
    init(host: String, port: Int, path: String) {
        self.host = host
        self.port = port
        self.path = path
        self.dateVisited = Date.now
    }
}
