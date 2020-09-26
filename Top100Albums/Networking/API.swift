//
//  API.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

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
   
   /// Only the latest task for a URL. Mostly used for images, which avoid repeated requests.
   private var tasks = [URL: URLSessionDataTask]()
   
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
                mimeType: String? = "application/json",
                body: Data? = nil,
                completion: @escaping (_ response: Response) -> Void) {
   
      guard let url = url else {
         return completion(.init(nil, nil, APIError.badURL))
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      if let mimeType = mimeType {
         request.addValue(mimeType, forHTTPHeaderField: "Content-Type")
      }
      request.httpBody = body
      
      let task = session.dataTask(with: request) { data, response, error in
         DispatchQueue.main.async {
            completion(.init(data, response, error))
         }
      }
      tasks[url] = task
      task.resume()
   }
   
   // MARK: - Images
   
   let imageCache = NSCache<NSURL, UIImage>()
   private var loadingImageResponses = [URL: [(UIImage?) -> Void]]()
   
   /// Specific method for fetching images, with cache and optimized for repeated requests fro the same image.
   func image(_ url: URL?, completion: @escaping (_ image: UIImage?) -> Void) {
      guard let url = url else {
         return completion(nil)
      }
      // check for a cached image
      if let cachedImage = imageCache.object(forKey: url as NSURL) {
          return completion(cachedImage)
      }
      // enqueue requests for the same image
      guard loadingImageResponses[url] == nil else {
         loadingImageResponses[url]?.append(completion)
         return
      }
      loadingImageResponses[url] = [completion]
      
      // NOTE: nil mimeType to let URLSession infer it from URL
      request(url, method: .get, mimeType: nil) { response in
         // get image from response
         guard response.isSuccessful, let image = response.image,
               let blocks = self.loadingImageResponses[url] else {
            return completion(nil)
         }
         // cache the image and serve enqueued requests
         self.imageCache.setObject(image, forKey: url as NSURL, cost: response.byteCount)
         for block in blocks {
            block(image)
         }
      }
   }

   /// Cancels the latest request associated with the given `url`.
   func cancel(_ url: URL?) {
      if let url = url {
         print(#function, url)
         tasks[url]?.cancel()
         tasks.removeValue(forKey: url)
         loadingImageResponses.removeValue(forKey: url)
      }
   }
}
