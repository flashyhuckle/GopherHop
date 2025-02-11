import Foundation
import UIKit

class Gopher: Equatable {
    static func == (lhs: Gopher, rhs: Gopher) -> Bool {
        lhs.date == rhs.date && lhs.hole == rhs.hole
    }
    
    let date: Date
    let hole: GopherHole
    
    var scrollToLine: GopherLine.ID?
    
    init(hole: GopherHole = .lines([])) {
        self.date = Date.now
        self.hole = hole
    }
    
    init(data: Data, as lineType: GopherLineType? = nil) {
        self.date = Date.now
        self.hole = gopherDecode(data: data, as: lineType)
    }
}

public enum GopherHole: Equatable {
    case lines([GopherLine])
    case image(UIImage)
    case gif(UIImage)
//    case text([GopherLine])
    case text(String)
    case badFile
}

public struct GopherLine: Equatable, Hashable, Identifiable {
    let message: String
    let lineType: GopherLineType
    let host: String
    let path: String
    let port: Int
    public let id: UUID
    
    public init(
        message: String = "",
        lineType: GopherLineType = .info,
        host: String = "",
        path: String = "",
        port: Int = 70,
        id: UUID = UUID()
    ) {
        self.message = message
        self.lineType = lineType
        self.host = host
        self.path = path
        self.port = port
        self.id = id
    }
}

