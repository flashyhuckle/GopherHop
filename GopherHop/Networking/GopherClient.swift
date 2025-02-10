import Foundation
import Network
import UIKit

protocol GopherClientType {
    func request(item: GopherLine) async throws -> Gopher
}

final class GopherClient: ObservableObject, GopherClientType {
    private let handler: GopherProtocolHandlerType
    
    init(handler: GopherProtocolHandlerType = GopherProtocolHandler()) {
        self.handler = handler
    }
    
    func request(item: GopherLine) async throws -> Gopher {
        let host = item.host
        let port = item.port
        let path = item.path
        
        var expectedType: GopherLineType? {
            switch item.lineType {
            case .text, .image:
                return item.lineType
            default:
                return nil
            }
        }
        let data = try await handler.performRequest(host: host, port: port, path: path)
        let gopher = Gopher(data: data, as: expectedType)
        return gopher
    }
}
