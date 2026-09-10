//
//  ollamaCall.swift
//  aimicus
//
//  Created by Thomas on 09.06.26.
//

import Foundation

@Observable
class OllamaAPIService {
    
    struct ChatMessage: Codable {
        let role: String
        let content: String
    }

    static private var chatHistory: [ChatMessage] = []
        
    static func sendToOllama(text: String, model: String) async -> AttributedString{
        
        var req = URLRequest(url: URL(string: "http://127.0.0.1:11434/api/chat")!)
        req.httpMethod = "POST"
        
        chatHistory.append(ChatMessage(role: "user", content: text))
        
        if chatHistory.count > 4{
            chatHistory.removeFirst()
        }

        let messagesJson = chatHistory.map { ["role": $0.role, "content": $0.content] }
        
        req.httpBody = try? JSONSerialization.data(withJSONObject: [
            "model": model,
            "messages": messagesJson,
            "stream": false
        ])
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        guard let (data, _) = try? await URLSession.shared.data(for: req) else { return ""}
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let message = (json["message"] as? [String: Any])?["content"] as? String {
            var options = AttributedString.MarkdownParsingOptions()
            options.interpretedSyntax = .inlineOnlyPreservingWhitespace
            let md = (try? AttributedString(markdown: message, options: options)) ?? AttributedString("")
            chatHistory.append(ChatMessage(role: "assistant", content: String(md.characters)))
            return md
        }
        
        return ""
    }

}
