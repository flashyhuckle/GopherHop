import Foundation
import Network

func makeGeminiRequest(host: String, port: Int = 1965) {
    // Create a connection using NWConnection (network stack)
    let connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: UInt16(port))!, using: .tcp)

    // Start the connection
    connection.start(queue: .global())

    // Send the Gemini request
    let request = "gemini://\(host)\r\n" // Gemini protocol request (just the URL with a newline)
    connection.send(content: request.data(using: .utf8), completion: .contentProcessed({ error in
        if let error = error {
            print("Error sending request: \(error.localizedDescription)")
            return
        }
    }))

    // Receive the response from the server
    connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, _, error in
        if let error = error {
            print("Error receiving data: \(error.localizedDescription)")
            return
        }

        if let data = data, let response = String(data: data, encoding: .utf8) {
            // Print the response from the Gemini server
            print("Gemini Response: \(response)")
        }
    }

    // Wait for the connection to finish before exiting
    connection.stateUpdateHandler = { state in
        if case .failed(let error) = state {
            print("Connection failed with error: \(error.localizedDescription)")
        }
    }
}

// Example usage with a Gemini server
//makeGeminiRequest(host: "gemini.circumlunar.space")
