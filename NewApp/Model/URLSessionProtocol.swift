import Foundation

// Protocol to mock URLSession
public protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Conform URLSession to the protocol
extension URLSession: URLSessionProtocol {}
