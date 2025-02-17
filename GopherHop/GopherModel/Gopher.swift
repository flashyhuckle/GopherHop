import Foundation
import UIKit

struct Gopher: Equatable, Sendable {
    static func == (lhs: Gopher, rhs: Gopher) -> Bool {
        lhs.date == rhs.date && lhs.hole == rhs.hole
    }
    
    let date: Date
    let hole: GopherHole
    let scrollTo: ScrollToGopher?
    
    init(hole: GopherHole = .lines([]), scrollTo: ScrollToGopher? = nil) {
        self.date = Date.now
        self.hole = hole
        self.scrollTo = scrollTo
    }
}

struct ScrollToGopher: Sendable {
    let scrollToID: GopherLine.ID?
    let scrollToOffset: CGFloat?
}

public enum GopherHole: Equatable, Sendable {
    case lines([GopherLine])
    case image(UIImage)
    case gif(UIImage)
    case text(String)
    case badFile
}

public struct GopherLine: Equatable, Hashable, Identifiable, Sendable {
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

