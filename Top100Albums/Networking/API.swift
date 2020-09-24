//
//  API.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

enum APIError: Error {
   case badURL
   case noData
   case cannotDecode(DecodingError)
   case unknown(Error)
}

enum HTTPMethod: String {
   case get, post, put, delete
}

/// High level networking object, agnostic of any implementation.
class API {
   let session: URLSession = {
      let config = URLSessionConfiguration.default
      config.allowsCellularAccess = true
      if #available(iOS 11.0, *) {
         config.waitsForConnectivity = true
      }
      return URLSession(configuration: config)
   }()
   
   /// General method to make network requests, obtaining the response information and the raw `Data`.
   /// - Parameters:
   ///   - url: The `URL` for the request. If `nil`, an `APIError.badURL` error will come in the response.
   ///   - method: The method of the request.
   ///   - mimeType: Optional. The value for the `"Content-Type"` header. Default is `"application/json".`
   ///   - body: Optional. The data for the body. Default is `nil`.
   ///   - completion: The completion task.
   ///   - response: Contains all the response information, data, and error returned.
   ///  - SeeAlso: `Response` class.
   func request(_ url: URL?,
                method: HTTPMethod,
                mimeType: String = "application/json",
                body: Data? = nil,
                completion: @escaping (_ response: Response) -> Void) {
   
      guard let url = url else {
         return completion(.init(nil, nil, APIError.badURL))
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.addValue(mimeType, forHTTPHeaderField: "Content-Type")
      request.httpBody = body
      
      session.dataTask(with: request) { data, response, error in
         DispatchQueue.main.async {
            completion(.init(data, response, error))
         }
      }.resume()
   }
}
