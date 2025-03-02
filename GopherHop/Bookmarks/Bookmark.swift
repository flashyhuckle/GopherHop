import Foundation
import SwiftData

@Model
final class Bookmark {
    var host: String
    var port: Int
    var path: String
    
    var type: GopherLineType
    
    var dateAdded: Date
    var id: UUID
    var isHome: Bool
    
    var fullAddress: String {
        host + ":" + String(port) + path
    }
    
    init(host: String, port: Int, path: String, type: GopherLineType, isHome: Bool = false) {
        self.host = host
        self.port = port
        self.path = path
        self.type = type
        self.dateAdded = Date.now
        self.id = UUID()
        self.isHome = isHome
    }
}
