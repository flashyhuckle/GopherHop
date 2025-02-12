import Foundation

extension String {
    func getGopherLineForRequest() -> GopherLine {
        if let components = URLComponents(string: self), let host = components.host {
            let path = components.path
            let port = components.port ?? 70
            print("\(host), \(port), \(path)")
            return GopherLine(host: host, path: path, port: port)
        } else {
            let host: String
            let port: Int
            let path: String
            
            var split = self.split(separator: ":")
            host = String.init(split.removeFirst())
            
            let rest = String.init(split.removeFirst())
            if let slashIndex = rest.firstIndex(of: "/") {
                port = Int(rest[..<slashIndex]) ?? 70
                path = String(rest[slashIndex...])
            } else {
                port = Int(rest) ?? 70
                path = ""
            }
            
            return GopherLine(host: host, path: path, port: port)
        }
    }
}
