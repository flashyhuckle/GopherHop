import Foundation

public enum GopherLineType: Codable, Sendable {
    case info
    case text
    case directory
    case gif
    case image
    case search
    case html
    
    //todo
    case sound
    case rtf
    case doc
    case pdf
    case xml
    
    case error
    
    //not supported yet
    case nameserver
    case binhex
    case dos
    case uuencoded
    case telnet
    case binary
    case mirror
    case telnet3270
    case bitmap
    case movie
}

public func getGopherLineType(item: String) -> GopherLineType {
    switch item {
    case "0": return .text
    case "1": return .directory
    case "2": return .nameserver
    case "3": return .error
    case "4": return .binhex
    case "5": return .dos
    case "6": return .uuencoded
    case "7": return .search
    case "8": return .telnet
    case "9": return .binary
    case "+": return .mirror
    case "g": return .gif
    case "I": return .image
    case "T": return .telnet3270
    case ":": return .bitmap
    case ";": return .movie
    case "<": return .sound
    case "d": return .doc
    case "h": return .html
    case "i": return .info
    case "p": return .image
    case "r": return .rtf
    case "s": return .sound
    case "P": return .pdf
    case "X": return .xml
    default:  return .info
    }
}
