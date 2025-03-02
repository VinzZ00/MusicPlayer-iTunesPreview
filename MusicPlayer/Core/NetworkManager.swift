//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                if let decodingError = error as? DecodingError {
                    if #available(iOS 15.0, *) {
                        print("\(Date().formatted(date: .abbreviated, time: .standard)) ==> Decoding Error: \(decodingError.detailedDescription)")
                    } else {
                        print("\(Date().description) ==> Decoding Error: \(decodingError.detailedDescription)")
                    }
                    completion(.failure(decodingError))
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

// MARK: Error Extension for JSON Decoding
extension DecodingError {
    var detailedDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            return "Type Mismatch: Expected type \(type) at \(context.codingPath.map(\.stringValue).joined(separator: " → "))\nDebug Info: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "Value Not Found: Expected value of type \(type) at \(context.codingPath.map(\.stringValue).joined(separator: " → "))\nDebug Info: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "Key Not Found: Missing key '\(key.stringValue)' at \(context.codingPath.map(\.stringValue).joined(separator: " → "))\nDebug Info: \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data Corrupted at \(context.codingPath.map(\.stringValue).joined(separator: " → "))\nDebug Info: \(context.debugDescription)"
        @unknown default:
            return "Unknown Decoding Error"
        }
    }
}

