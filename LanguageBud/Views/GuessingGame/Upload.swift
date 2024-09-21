//
//  routes.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/20/24.
//

import Foundation
import UIKit

func uploadImage(image: UIImage, completion: @escaping (Result<[(name: String, imagePath: String)], Error>) -> Void) {
    let url = URL(string: "\(Config.baseURL)/upload")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
        completion(.failure(NSError(domain: "Invalid image data", code: 0, userInfo: nil)))
        return
    }
    
    var body = Data()
    let fieldName = "file"
    let fileName = "image.jpg"
    let mimeType = "image/jpeg"
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    
    let language = "EN"
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(language)\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
        }
        
        // Print the raw response data for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response: \(jsonString)")
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let objects = json["objects"] as? [[String: String]] {
                let extractedObjects = objects.map { (name: $0["name"] ?? "", imagePath: $0["image_path"] ?? "") }
                completion(.success(extractedObjects))
            } else {
                completion(.failure(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
