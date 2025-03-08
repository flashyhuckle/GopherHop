import Foundation

extension String {
    func getGopherLineForRequest() -> GopherLine {
//        if let components = URLComponents(string: self), let host = components.host {
//            let path = components.path
//            let port = components.port ?? 70
//            print("\(components.port)")
//            print("\(host), \(port), \(path)")
//            return GopherLine(host: host, path: path, port: port)
//        } else {
            let host: String
            let port: Int
            let path: String
            
            if contains(":") {
                var split = self.deletingPrefix("gopher://").split(separator: ":")
                host = String.init(split.removeFirst())
                guard !split.isEmpty else {
                    port = 70
                    path = ""
                    return GopherLine(host: host, path: path, port: port)
                }
                let rest = String.init(split.removeFirst())
                if let slashIndex = rest.firstIndex(of: "/") {
                    port = Int(rest[..<slashIndex]) ?? 70
                    path = String(rest[slashIndex...])
                } else {
                    port = Int(rest) ?? 70
                    path = ""
                }
            } else {
                port = 70
                if let slashIndex = firstIndex(of: "/") {
                    host = String.init(self[..<slashIndex])
                    path = String(self[slashIndex...])
                } else {
                    host = self
                    path = ""
                }
            }
            
            return GopherLine(host: host, path: path, port: port)
//        }
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
