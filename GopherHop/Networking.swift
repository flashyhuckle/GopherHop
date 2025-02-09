import Foundation
import Network

class GopherClient: ObservableObject {
    
    @Published var items = [GopherLine]()
    
    var server: String
    var path: String
    var port: Int
    
    init(server: String = "", port: Int = 70) {
        self.server = server
        self.port = port
        self.path = ""
    }
    
    func request(item: GopherLine) {
        self.port = item.port
        self.server = item.host
        self.path = item.path
        
        fetchFile(path: path, from: item.lineType)
    }
    
    private func fetchFile(path: String, from type: GopherLineType? = nil) {
        let host = server
        let port = self.port
        self.path = path
        
        // Create a connection to the Gopher server
        let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
//                print("Connected to \(host) on port \(port)")
                self.sendRequest(connection: connection, path: path, type: type)
            case .failed(let error):
                print("Connection failed: \(error)")
            default:
                break
            }
        }
        
        // Start the connection
        connection.start(queue: .global())
    }
    
    private func sendRequest(connection: NWConnection, path: String, type: GopherLineType? = nil) {
        // Prepare the Gopher request (path + \r\n)
        let request = path + "\r\n"
        let requestData = Data(request.utf8)
        
        // Send the request to the server
        connection.send(content: requestData, completion: .contentProcessed { sendError in
            if let error = sendError {
                print("Failed to send request: \(error)")
            } else {
//                print("Request sent: \(request)")
//                self.receiveResponse(connection: connection)
                self.receive(connection: connection, type: type)
            }
        })
    }
    
    private func receive(connection: NWConnection, type: GopherLineType? = nil) {
        connection.receiveMessage { data, context, isComplete, error in
            if let error = error {
                print("Error receiving data: \(error)")
                return
            }
            if let data = data {
                if let response = String(data: data, encoding: .utf8) {
                    print("utf8")
                    self.parse(response, type: type)
                        //It throws an 'error', but then encodes incorrect data
                } else if let response =  String(data: data, encoding: .init(rawValue: UInt(0))) {
                    print("custom")
                    self.parse(response, type: type)
                } else {
                    print("error encoding data")
                }
                print(data)
            }
            connection.cancel()
        }
    }
    
    func parse(_ response: String, type: GopherLineType? = nil) {
        var gopherElements: [GopherLine] = []
        for line in response.split(separator: "\r\n") {
//            let lineItemType = getGopherFileType(item: "\(line.first ?? " ")")
            if let item = createGopherLine(
                rawLine: String(line),
                itemType: type == .text ? .info : nil
            ) {
                gopherElements.append(item)
            }
            
        }
        DispatchQueue.main.async {
            self.items = gopherElements
        }
    }
    
    func createGopherLine(rawLine: String, itemType: GopherLineType?) -> GopherLine? {
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
}
