import Foundation
import Network

protocol GopherProtocolHandlerType {
    func performRequest(host: String, port: Int, path: String) async throws -> Data
    func cancelRequest(next: Bool)
}

enum GopherProtocolHandlerError: Error, Equatable {
    static func == (lhs: GopherProtocolHandlerError, rhs: GopherProtocolHandlerError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case connectionFailed(Error)
    case requestFailed(Error)
    case receivingData(Error?)
    case connectionCancelled
}

extension NWConnection: @retroactive Equatable {
    public static func == (lhs: NWConnection, rhs: NWConnection) -> Bool {
        lhs.endpoint == rhs.endpoint
    }
}

final class GopherProtocolHandler: GopherProtocolHandlerType {
    
    private var currentConnection: NWConnection?
    private var currentID: UUID?
    
    func cancelRequest(next: Bool = true) {
#warning("cleanup logic")
        guard let currentConnection else { return }
        if next { if currentConnection.state != .cancelled { currentConnection.cancel() }
        } else { self.currentID = nil; currentConnection.cancel() }
    }
    
    func performRequest(host: String, port: Int, path: String) async throws -> Data {
        cancelRequest()
        let connection = try await createConnection(host: host, port: port)
        let requested = try await sendRequest(to: connection, path: path)
        let data = try await receiveData(from: requested)
        return data
    }
    
    private func createConnection(host: String, port: Int) async throws -> NWConnection {
        return try await withCheckedThrowingContinuation { continuation in
            let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
            currentConnection = connection
            
            let id = UUID()
            currentID = id
            
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    continuation.resume(returning: connection)
                case .failed(let error):
                    continuation.resume(throwing: GopherProtocolHandlerError.connectionFailed(error))
                case .waiting(let error):
                    continuation.resume(throwing: GopherProtocolHandlerError.connectionFailed(error))
                    connection.cancel()
                case .cancelled:
                    if self.currentID != id {
                        continuation.resume(throwing: GopherProtocolHandlerError.connectionCancelled)
                    }
                default:
                    break
                }
            }
            connection.start(queue: .global())
        }
    }
    
    private func sendRequest(to connection: NWConnection, path: String) async throws -> NWConnection {
        return try await withCheckedThrowingContinuation { continuation in
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
        return try await withCheckedThrowingContinuation { continuation in
            connection.receiveMessage { data, _, _, error in
                if let error {
                    continuation.resume(throwing: GopherProtocolHandlerError.receivingData(error))
                } else if let data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: GopherProtocolHandlerError.receivingData(nil))
                }
                connection.cancel()
            }
        }
    }
}
