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
    if let text = String(data: data, encoding: .utf8) {
        return .text(text)
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

public func gopherParse(_ data: Data) -> [GopherLine]? {
    var dataString = ""
    if let response = String(data: data, encoding: .utf8) { dataString = response
    } else if let response =  String(data: data, encoding: .init(rawValue: UInt(0))) { dataString = response
    } else { return nil }
    
    var gopherElements: [GopherLine] = []
    for line in dataString.split(separator: "\r\n") {
        if let item = createGopherLine(rawLine: String(line)) {
            gopherElements.append(item)
        }
    }
    return gopherElements
}

public func createGopherLine(rawLine: String) -> GopherLine? {
    guard !rawLine.isEmpty else { return nil }
    let components = rawLine.components(separatedBy: "\t")
    
    let type: GopherLineType = getGopherLineType(item: String(components[0].first ?? "i"))
    let message: String = String(components[0].dropFirst())
    let path: String = components.indices.contains(1) ? String(components[1]) : ""
    let host: String = components.indices.contains(2) ? String(components[2]) : ""
    let port: Int = components.indices.contains(3) ? Int(String(components[3])) ?? 70 : 70
    
    return GopherLine(message: message, lineType: type, host: host, path: path, port: port)
}
