import Foundation
import Network

class GPT {
    let gopherClient = GopherClient2(server: "hngopher.com") // Example Gopher server

    // Fetch a file (provide the path you want, such as "/1/gopher/Welcome")
    func get() {
        gopherClient.fetchFile(path: "/live/items/42970412")
    }
}

class GopherClient2: ObservableObject {
    
    @Published var items = [GopherLine]()
    
    let server: String
    let port: Int
    
    init(server: String, port: Int = 70) {
        self.server = server
        self.port = port
    }
    
    func fetchFile(path: String) {
        let host = server
        let port = self.port
        
        // Create a connection to the Gopher server
        let connection = NWConnection(host: .init(host), port: .init(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)), using: .tcp)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Connected to \(host) on port \(port)")
                self.sendRequest(connection: connection, path: path)
            case .failed(let error):
                print("Connection failed: \(error)")
            default:
                break
            }
        }
        
        // Start the connection
        connection.start(queue: .global())
    }
    
    private func sendRequest(connection: NWConnection, path: String) {
        // Prepare the Gopher request (path + \r\n)
        let request = path + "\r\n"
        let requestData = Data(request.utf8)
        
        // Send the request to the server
        connection.send(content: requestData, completion: .contentProcessed { sendError in
            if let error = sendError {
                print("Failed to send request: \(error)")
            } else {
                print("Request sent: \(request)")
//                self.receiveResponse(connection: connection)
                self.receive(connection: connection)
            }
        })
    }
    
    private func receiveResponse(connection: NWConnection) {
        // Read the response from the server
        connection.receive(minimumIncompleteLength: 1_000_000, maximumLength: 1_000_000) { data, context, isComplete, error in
            if let error = error {
                print("Error receiving data: \(error)")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from server:")
                print(responseString)
                print(data)
            }
            
            // Close the connection after receiving the response
            connection.cancel()
        }
    }
    
    private func receive(connection: NWConnection) {
        connection.receiveMessage { data, context, isComplete, error in
            if let error = error {
                print("Error receiving data: \(error)")
                return
            }
            
            if let data = data, let response = String(data: data, encoding: .utf8) {
                print(response)
//                print(data)
                self.parse(response)
            } else {
                print("error encoding data")
            }
            connection.cancel()
        }
    }
    
    func parse(_ response: String) {
        var gopherServerResponse: [GopherLine] = []
//
//        print("parsing")
//        let carriageReturnCount = response.filter({ $0 == "\r" }).count
//        let newlineCarriageReturnCount = response.filter({ $0 == "\r\n" }).count
//        print(
//            "Carriage Returns: \(carriageReturnCount), Newline + Carriage Returns: \(newlineCarriageReturnCount)"
//        )
//
//        if newlineCarriageReturnCount == 0 {
//            for line in response.split(separator: "\n") {
//                let lineItemType = getGopherFileType(item: "\(line.first ?? " ")")
//                let item = createGopherItem(
//                    rawLine: String(line), itemType: lineItemType)
//                gopherServerResponse.append(item)
//
//            }
//        } else {
            for line in response.split(separator: "\r\n") {
                let lineItemType = getGopherFileType(item: "\(line.first ?? " ")")
                if let item = createGopherItem(
                    rawLine: String(line), itemType: lineItemType) {
                    gopherServerResponse.append(item)
                }

            }
//        }
        
        
        DispatchQueue.main.async {
            self.items = gopherServerResponse
        }
        print(gopherServerResponse)
    }
    
    func createGopherItem(rawLine: String, itemType: GopherLineType = .info) -> GopherLine? {
        guard !rawLine.isEmpty else { return nil }
        let components = rawLine.components(separatedBy: "\t")
        
        let message = String(components[0].dropFirst())
        
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
         
        let type = itemType
        
        let line = GopherLine(message: message, lineType: type, host: host, path: path)

        return line
    }
}

