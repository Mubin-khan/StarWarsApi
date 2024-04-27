//
//  APIManager.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation

enum DataError : Error {
    case invalidUrl
    case invalidResponse
}

class APIManager {
    
    func request<T : Decodable>(urlString : String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw DataError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
