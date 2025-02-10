import Foundation
import UIKit

class Gopher: Equatable {
    static func == (lhs: Gopher, rhs: Gopher) -> Bool {
        lhs.date == rhs.date && lhs.hole == rhs.hole
    }
    
    let date: Date
    let lines: [GopherLine]
    let hole: GopherHole
    
    init(lines: [GopherLine] = [], hole: GopherHole = .lines([])) {
        self.date = Date.now
        self.lines = lines
        self.hole = hole
    }
    
    init(data: Data, as lineType: GopherLineType? = nil) {
        self.date = Date.now
        self.lines = []
        self.hole = gopherDecode(data: data, as: lineType)
    }
}

public enum GopherHole: Equatable {
    case lines([GopherLine])
    case image(UIImage)
    case text([GopherLine])
    case badFile
}

public struct GopherLine: Equatable {
    let message: String
    let lineType: GopherLineType
    let host: String
    let path: String
    let port: Int
    let id: UUID
    
    public init(
        message: String = "",
        lineType: GopherLineType = .info,
        host: String = "",
        path: String = "",
        port: Int = 70
    ) {
        self.message = message
        self.lineType = lineType
        self.host = host
        self.path = path
        self.port = port
        self.id = UUID()
    }
}

