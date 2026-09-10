//
//  OllamaModelService.swift
//  aimicus
//
//  Created by Thomas on 10.09.26.
//

import Foundation

@Observable

class OllamaModelService {
    
    struct OllamaModelsResponse: Codable {
        let models: [OllamaModel]
    }

    struct OllamaModel: Codable, Identifiable {
        let name: String
        let model: String
        let size: Int64

        var id: String { name }
    }
    
    static func fetchOllamaModels() async throws -> [String] {
        let url = URL(string: "http://127.0.0.1:11434/api/tags")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(
            OllamaModelsResponse.self,
            from: data
        )

        return result.models.map {$0.name}
    }
    
}
