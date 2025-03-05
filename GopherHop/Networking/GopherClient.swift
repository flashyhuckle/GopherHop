import Foundation
import Network
#if os(iOS)
import UIKit
#endif

protocol GopherClientType {
    func request(item: GopherLine) async throws -> GopherHole
    func cancelRequest()
}

final class GopherClient: ObservableObject, GopherClientType {
    private let handler: GopherProtocolHandlerType
    
    init(handler: GopherProtocolHandlerType = GopherProtocolHandler()) {
        self.handler = handler
    }
    
    func cancelRequest() {
        Task {
            await handler.cancelRequest(next: false)
        }
    }
    
    func request(item: GopherLine) async throws -> GopherHole {
        let host = item.host
        let port = item.port
        let path = item.path
        
        var expectedType: GopherLineType? {
            switch item.lineType {
            case .text, .image, .gif, .doc, .rtf, .html, .pdf, .xml:
                return item.lineType
            default:
                return nil
            }
        }
        let data = try await handler.performRequest(host: host, port: port, path: path)
        let hole = gopherDecode(from: data, as: expectedType)
        return hole
    }
}
