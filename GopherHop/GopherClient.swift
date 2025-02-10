import Foundation
import Network
import UIKit

enum GopherClientError: Error {
    case connectionFailed(Error)
    case requestFailed(Error)
    case receivingData(Error)
//    case encodingData
}

final class GopherClient: ObservableObject {
    
    func request(item: GopherLine, type: GopherLineType? = nil) async throws -> Gopher {
        let host = item.host
        let port = item.port
        let path = item.path
        
        let connection = try await createConnection(host: host, port: port)
        let requested = try await sendRequest(connection: connection, path: path)
        let data = try await receive(connection: requested)
        let gopher = Gopher(data: data, as: type)
        return gopher
    }
    
    private func createConnection(host: String, port: Int) async throws -> NWConnection {
        return try await withUnsafeThrowingContinuation { continuation in
            let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    continuation.resume(returning: connection)
                case .failed(let error):
                    continuation.resume(throwing: GopherClientError.connectionFailed(error))
                default:
                    break
                }
            }
            connection.start(queue: .global())
        }
    }
    
    private func sendRequest(connection: NWConnection, path: String) async throws -> NWConnection {
        return try await withUnsafeThrowingContinuation { continuation in
            let requestData = Data((path + "\r\n").utf8)
            connection.send(content: requestData, completion: .contentProcessed { error in
                if let error {
                    continuation.resume(throwing: GopherClientError.requestFailed(error))
                } else {
                    continuation.resume(returning: connection)
                }
            })
        }
    }
    
    private func receive(connection: NWConnection) async throws -> Data {
        return try await withUnsafeThrowingContinuation { continuation in
            connection.receiveMessage { data, _, _, error in
                if let error {
                    continuation.resume(throwing: GopherClientError.receivingData(error))
                }
                if let data {
                    continuation.resume(returning: data)
                }
                connection.cancel()
            }
        }
    }
}
