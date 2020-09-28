//
//  Response.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

class Response {
   let data: Data?
   let response: URLResponse?
   let error: Error?

   init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
      self.data = data
      self.response = response
      self.error = error
   }

   var statusCode: Int {
      (response as? HTTPURLResponse)?.statusCode ?? 999
   }

   /// `statusCode` is 2xx
   var isSuccessful: Bool {
      error == nil && 200 ... 299 ~= statusCode
   }
   
   /// The size of the response `data`.
   var byteCount: Int {
      data?.count ?? 0
   }
}

// MARK: - Decoding

extension Response {
   static let decoder: JSONDecoder = {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      decoder.dateDecodingStrategy = .custom(decodeDate)
      return decoder
   }()

   func decode<R: Decodable>(as _: R.Type? = nil) throws -> R {
      if let error = error { throw error }
      guard let data = data else { throw APIError.noData }
      return try Self.decoder.decode(R.self, from: data)
   }

   /// The UTF8 string value of `data`.
   var string: String? {
      if let data = data {
         return String(data: data, encoding: .utf8)
      }
      return nil
   }

   var image: UIImage? {
      if let data = data {
         return UIImage(data: data)
      }
      return nil
   }
   
   private static func decodeDate(decoder: Decoder) throws -> Date {
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)
      guard let date = DateFormatter.knownFormatDate(from: string) else {
         throw DecodingError.dataCorruptedError(
            in: container, debugDescription: "Unrecognized date format: \(string)")
      }
      return date
   }
}
