import UIKit

public func gopherDecode(data: Data, as lineType: GopherLineType? = nil) -> GopherHole {
    switch lineType {
    case .image: return gopherdecodeImage(from: data)
    case .text: return gopherDecodeText(from: data)
    case .gif: return gopherdecodeGif(from: data)
    default: return gopherDecodeHole(from: data)
    }
}

public func gopherdecodeImage(from data: Data) -> GopherHole {
    if let image = UIImage(data: data) {
        return .image(image)
    } else {
        return .badFile
    }
}

public func gopherdecodeGif(from data: Data) -> GopherHole {
    if let image = UIImage.gifImageWithData(data) {
        return .gif(image)
    } else {
        return .badFile
    }
}

public func gopherDecodeText(from data: Data) -> GopherHole {
    if let textLines = gopherParse(data, type: .text) {
        return .text(textLines)
    } else {
        return .badFile
    }
}

public func gopherDecodeHole(from data: Data) -> GopherHole {
    if let lines = gopherParse(data) {
        return .lines(lines)
    } else {
        return .badFile
    }
}

public func gopherParse(_ data: Data, type: GopherLineType? = nil) -> [GopherLine]? {
    var dataString = ""
    if let response = String(data: data, encoding: .utf8) {
        //Proper encoding
        dataString = response
    } else if let response =  String(data: data, encoding: .init(rawValue: UInt(0))) {
        //for cases that utf8 fails
        dataString = response
    } else {
        return nil
    }
    var gopherElements: [GopherLine] = []
    for line in dataString.split(separator: "\r\n") {
//            let lineItemType = getGopherFileType(item: "\(line.first ?? " ")")
        if let item = createGopherLine(
            rawLine: String(line),
            itemType: type == .text ? .info : nil
        ) {
            gopherElements.append(item)
        }
        
    }
    return gopherElements
}

public func createGopherLine(rawLine: String, itemType: GopherLineType?) -> GopherLine? {
    guard !rawLine.isEmpty else { return nil }
    let components = rawLine.components(separatedBy: "\t")
    
    let message: String
    let type: GopherLineType
    
    switch itemType {
    case .info:
        type = .info
        message = String(components[0])
    default:
        type = getGopherFileType(item: String(components[0].first ?? "i"))
        message = String(components[0].dropFirst())
    }
    
    let path: String
    let host: String
    let port: Int

    if components.indices.contains(1) {
        path = String(components[1])
    } else { path = "" }
    
    if components.indices.contains(2) {
        host = String(components[2])
    } else { host = "" }
    
    if components.indices.contains(3) {
        port = Int(String(components[3])) ?? 70
    } else { port = 70 }
    
    let line = GopherLine(message: message, lineType: type, host: host, path: path, port: port)

    return line
}
