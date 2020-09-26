//
//  MockURLSession.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 26/09/20.
//

import Foundation

enum MockResponse {
   case success(String)
   case failure(Error)
   
   // NOTE: static vars mirroring cases give defaults to the associated values
   static var success: MockResponse { .success("") }
   static var failure: MockResponse { .failure(APIError.noData) }
}

enum MockError: Int, Error {
   case notFound = 404
}

class MockURLProtocol: URLProtocol {
   /// A session configured to point to the `MockURLProtocol` class to handle requests
   static let session: URLSession = {
      URLProtocol.registerClass(MockURLProtocol.self)
      
      let config = URLSessionConfiguration.ephemeral
      config.protocolClasses = [MockURLProtocol.self]
      return URLSession(configuration: config)
   }()
   
   static var cachedUrl: URL?
   static var nextResolvedValue: MockResponse?
   
   static func mockResolvedValueOnce(_ value: MockResponse) {
      nextResolvedValue = value
   }
   
   func handle(_ request: URLRequest) throws -> (HTTPURLResponse, Data)? {
      Self.cachedUrl = request.url
      defer {
         Self.nextResolvedValue = nil
      }
      guard let url = request.url else {
         throw APIError.badURL
      }
      
      switch Self.nextResolvedValue {
      case .success(let string):
         let data = string.data(using: .utf8) ?? Data()
         let response = HTTPURLResponse(url: url, mimeType: request.value(forHTTPHeaderField: "Content-Type"),
                                        expectedContentLength: data.count, textEncodingName: nil)
         return (response, data)
         
      case .failure(let error): throw error
         
      default: return nil
      }
   }
   
   // MARK: - Overrides
   
   override class func canInit(with _: URLRequest) -> Bool { true }
   
   override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
   
   override class func requestIsCacheEquivalent(_: URLRequest, to _: URLRequest) -> Bool { false }
   
   override func startLoading() {
      do {
         guard let (response, data) = try handle(request) else {
            super.startLoading()
            return
         }
         client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
         client?.urlProtocol(self, didLoad: data)
         client?.urlProtocolDidFinishLoading(self)
      } catch  {
         client?.urlProtocol(self, didFailWithError: error)
      }
   }
   
   override func stopLoading() {}
}
