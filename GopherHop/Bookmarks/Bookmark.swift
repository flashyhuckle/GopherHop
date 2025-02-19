import Foundation
import SwiftData

@Model
final class Bookmark {
    var host: String
    var port: Int
    var path: String
    
    var dateAdded: Date
    
    var id: UUID
    
    var fullAddress: String {
        host + ":" + String(port) + path
    }
    
    init(host: String, port: Int, path: String) {
        self.host = host
        self.port = port
        self.path = path
        self.dateAdded = Date.now
        self.id = UUID()
    }
}
