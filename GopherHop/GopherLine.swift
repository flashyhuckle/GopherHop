import Foundation

class Gopher {
    let date: Date
    let lines: [GopherLine]
    
    init(lines: [GopherLine] = []) {
        self.date = Date.now
        self.lines = lines
    }
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

public enum GopherLineType {
    case text
    case directory
    case nameserver
    case error
    case binhex
    case bindos
    case uuencoded
    case search
    case telnet
    case binary
    case mirror
    case gif
    case image
    case tn3270Session
    case bitmap
    case movie
    case sound
    case doc
    case html
    case info
}

public func getGopherFileType(item: String) -> GopherLineType {
    switch item {
    case "0":
        return .text
    case "1":
        return .directory
    case "2":
        return .nameserver
    case "3":
        return .error
    case "4":
        return .binhex
    case "5":
        return .bindos
    case "6":
        return .uuencoded
    case "7":
        return .search
    case "8":
        return .telnet
    case "9":
        return .binary
    case "+":
        return .mirror
    case "g":
        return .gif
    case "I":
        return .image
    case "T":
        return .tn3270Session
    case ":":
        return .bitmap
    case ";":
        return .movie
    case "<":
        return .sound
    case "d":
        return .doc
    case "h":
        return .html
    case "i":
        return .info
    case "p":
        return .image
    case "r":
        return .doc
    case "s":
        return .doc
    case "P":
        return .doc
    case "X":
        return .doc
    default:
        return .info
    }
}

public func getFileType(fileExtension: String) -> GopherLineType {
    switch fileExtension {
    case "txt":
        return .text
    case "md":
        return .text
    case "html":
        return .html
    case "pdf":
        return .doc
    case "png":
        return .image
    case "gif":
        return .gif
    case "jpg":
        return .image
    case "jpeg":
        return .image
    case "mp3":
        return .sound
    case "wav":
        return .sound
    case "mp4":
        return .movie
    case "mov":
        return .movie
    case "avi":
        return .movie
    case "rtf":
        return .doc
    case "xml":
        return .doc
    default:
        return .binary
    }
}
