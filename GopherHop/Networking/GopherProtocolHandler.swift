import Foundation
import Network

protocol GopherProtocolHandlerType {
    func performRequest(host: String, port: Int, path: String) async throws -> Data
}

enum GopherProtocolHandlerError: Error {
    case connectionFailed(Error)
    case requestFailed(Error)
    case receivingData(Error)
}

final class GopherProtocolHandler: GopherProtocolHandlerType {
    
    func performRequest(host: String, port: Int, path: String) async throws -> Data {
        let connection = try await createConnection(host: host, port: port)
        let requested = try await sendRequest(to: connection, path: path)
        let data = try await receiveData(from: requested)
        return data
    }
    
    private func createConnection(host: String, port: Int) async throws -> NWConnection {
        return try await withUnsafeThrowingContinuation { continuation in
            let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    continuation.resume(returning: connection)
                case .failed(let error):
                    continuation.resume(throwing: GopherProtocolHandlerError.connectionFailed(error))
                default:
                    break
                }
            }
            connection.start(queue: .global())
        }
    }
    
    private func sendRequest(to connection: NWConnection, path: String) async throws -> NWConnection {
        return try await withUnsafeThrowingContinuation { continuation in
            let requestData = Data((path + "\r\n").utf8)
            connection.send(content: requestData, completion: .contentProcessed { error in
                if let error {
                    continuation.resume(throwing: GopherProtocolHandlerError.requestFailed(error))
                } else {
                    continuation.resume(returning: connection)
                }
            })
        }
    }
    
    private func receiveData(from connection: NWConnection) async throws -> Data {
        return try await withUnsafeThrowingContinuation { continuation in
            connection.receiveMessage { data, _, _, error in
                if let error {
                    continuation.resume(throwing: GopherProtocolHandlerError.receivingData(error))
                }
                if let data {
                    continuation.resume(returning: data)
                }
                connection.cancel()
            }
        }
    }
}
