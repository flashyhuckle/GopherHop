import Foundation
import Network

protocol GopherProtocolHandlerType {
    func performRequest(host: String, port: Int, path: String) async throws -> Data
    func cancelRequest(next: Bool) async
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
    
    private var lastConnection: NWConnection?
//    private var connectionsToCancel: [NWConnection] = []
    
    func cancelRequest(next: Bool = true) async {
        guard let lastConnection, lastConnection.state != .ready, lastConnection.state != .cancelled else { return }
        self.lastConnection = nil
        
        return await withCheckedContinuation { continuation in
            var cancelled = false
            lastConnection.cancel()
            while !cancelled {
                if lastConnection.state == .cancelled {
                    cancelled = true
                    continuation.resume()
                }
            }
        }
        
//        if next && lastConnection.state != .cancelled && lastConnection.state != .ready {
//            connectionsToCancel.append(lastConnection)
//            lastConnection.cancel()
//        } else {
//            connectionsToCancel.append(lastConnection)
//            lastConnection.cancel()
//        }
    }
    
    func performRequest(host: String, port: Int, path: String) async throws -> Data {
        await cancelRequest()
        let connection = try await createConnection(host: host, port: port)
        let requested = try await sendRequest(to: connection, path: path)
        let data = try await receiveData(from: requested)
        return data
    }
    
    private func createConnection(host: String, port: Int) async throws -> NWConnection {
        return try await withCheckedThrowingContinuation { continuation in
            let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
            lastConnection = connection
            
            connection.stateUpdateHandler = { [weak self] state in
                guard let self else { return }
                switch state {
                case .ready:
                    continuation.resume(returning: connection)
                case .failed(let error):
                    continuation.resume(throwing: GopherProtocolHandlerError.connectionFailed(error))
                case .waiting(let error):
                    continuation.resume(throwing: GopherProtocolHandlerError.connectionFailed(error))
                    connection.cancel()
                case .cancelled:
                    if lastConnection != connection {
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
