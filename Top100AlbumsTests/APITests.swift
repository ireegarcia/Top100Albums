//
//  APITests.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 26/09/20.
//

import XCTest

// NOTE: representative tests mocking the url request
class APITests: XCTestCase {
   var sessionToRestore: URLSession?
   
   override func setUpWithError() throws {
      sessionToRestore = RssAPI.api.session
      RssAPI.api.session = MockURLProtocol.session
   }
   
   override func tearDownWithError() throws {
      sessionToRestore.map { RssAPI.api.session = $0 }
   }
   
   func testResponseDelivery() throws {
      MockURLProtocol.mockResolvedValueOnce(.success(sampleFeed))
      
      let exp = expectation(description: "Response should finish")
      RssAPI.topAlbums { response in
         XCTAssertNotNil(response.string, "Response should hold data")
         XCTAssertEqual(response.string, self.sampleFeed, "API should not modify the response data")
         
         exp.fulfill()
      }
      waitForExpectations(timeout: 0.1) { _ in }
   }
   
   func testResponseDecoding() throws {
      MockURLProtocol.mockResolvedValueOnce(.success(sampleFeed))
      
      let exp = expectation(description: "Response should finish")
      RssAPI.topAlbums { response in
         defer { exp.fulfill() }
         
         let feedResponse: Feed.Response
         do { feedResponse = try response.decode() }
         catch {
            XCTFail("Decoding should not throw: \(error)")
            return
         }
         
         XCTAssertEqual(feedResponse.feed.title, "Top Albums", "Feed should have title")
         XCTAssertEqual(feedResponse.feed.results.count, 1, "Feed should have one album")
         if let album = feedResponse.feed.results.first {
            XCTAssertNotNil(album.url, "Album should have a URL")
            
            XCTAssertNotNil(album.releaseDate, "Album should have a releaseDate")
            let formatter = DateFormatter(format: "yyyy-MM-dd")
            XCTAssertEqual(album.releaseDate, formatter.date(from: "2020-09-25"),
                           "Album releaseDate should be correct")
         }
      }
      waitForExpectations(timeout: 0.1) { _ in }
   }
   
   func testResponseFailure() throws {
      MockURLProtocol.mockResolvedValueOnce(.failure(MockError.notFound))
      
      let exp = expectation(description: "Response should finish")
      RssAPI.topAlbums { response in
         do {
            _ = try response.decode(as: Feed.Response.self)
            XCTFail("Decoding failed response should throw")
            
         } catch {
            XCTAssertEqual(error._code, MockError.notFound.rawValue,
                           "Error code should be preserved")
         }
         exp.fulfill()
      }
      waitForExpectations(timeout: 0.1) { _ in }
   }
   
   func testDecodingMissingsAlbums() throws {
      MockURLProtocol.mockResolvedValueOnce(.success(noAlbums))
      
      let exp = expectation(description: "Response should finish")
      RssAPI.topAlbums { response in
         do {
            _ = try response.decode(as: Feed.Response.self)
            XCTFail("Decoding incomplete response should throw")
            
         } catch {
            if case DecodingError.keyNotFound(let key, _) = error {
               XCTAssertEqual(key.stringValue, "results",
                              "Missing key `results` should be identified")
            } else {
               XCTFail("DecodingError should be reflected: \(error)")
            }
         }
         exp.fulfill()
      }
      waitForExpectations(timeout: 0.1) { _ in }
   }
   
   func testDecodingInvalidReleaseDate() throws {
      MockURLProtocol.mockResolvedValueOnce(.success(albumInvalidReleaseDate))
      
      let exp = expectation(description: "Response should finish")
      RssAPI.topAlbums { response in
         do {
            _ = try response.decode(as: Album.self)
            XCTFail("Decoding invalid response should throw")
            
         } catch {
            if case DecodingError.dataCorrupted(let context) = error {
               XCTAssertEqual(context.codingPath.last?.stringValue, "releaseDate",
                              "Invalid `releaseDate` should be identified")
            } else {
               XCTFail("DecodingError should be reflected: \(error)")
            }
         }
         exp.fulfill()
      }
      waitForExpectations(timeout: 0.1) { _ in }
   }
   
   // NOTE: calculated value for code folding
   var sampleFeed: String { """
   {
     "feed": {
       "title": "Top Albums",
       "id": "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json",
       "author": {
         "name": "iTunes Store",
         "uri": "http://wwww.apple.com/us/itunes/"
       },
       "links": [
         {
           "self": "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json"
         },
         {
           "alternate": "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&popId=11&app=itunes"
         }
       ],
       "copyright": "Copyright © 2018 Apple Inc. Todos los derechos reservados.",
       "country": "us",
       "icon": "http://itunes.apple.com/favicon.ico",
       "updated": "2020-09-25T02:10:59.000-07:00",
       "results": [
         {
           "artistName": "Machine Gun Kelly",
           "id": "1526411768",
           "releaseDate": "2020-09-25",
           "name": "Tickets To My Downfall",
           "kind": "album",
           "copyright": "℗ 2020 Bad Boy/Interscope Records",
           "artistId": "465954501",
           "contentAdvisoryRating": "Explicit",
           "artistUrl": "https://music.apple.com/us/artist/machine-gun-kelly/465954501?app=itunes",
           "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/5e/e6/7c/5ee67cc6-4ea9-cbc4-251f-8ac9d7e1862f/20UMGIM66015.rgb.jpg/200x200bb.png",
           "genres": [
             {
               "genreId": "20",
               "name": "Alternative",
               "url": "https://itunes.apple.com/us/genre/id20"
             },
             {
               "genreId": "34",
               "name": "Music",
               "url": "https://itunes.apple.com/us/genre/id34"
             }
           ],
           "url": "https://music.apple.com/us/album/tickets-to-my-downfall/1526411768?app=itunes"
         }
      ]
   }}
   """ }
   
   var noAlbums: String { """
   {
     "feed": {
       "title": "Top Albums",
       "id": "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json",
       "author": {
         "name": "iTunes Store",
         "uri": "http://wwww.apple.com/us/itunes/"
       },
       "copyright": "Copyright © 2018 Apple Inc. Todos los derechos reservados.",
       "country": "us",
       "icon": "http://itunes.apple.com/favicon.ico",
       "updated": "2020-09-25T02:10:59.000-07:00",
   }}
   """ }
   
   var albumInvalidReleaseDate: String { """
   {
     "artistName": "Machine Gun Kelly",
     "id": "1526411768",
     "releaseDate": "2020-09-2",
     "name": "Tickets To My Downfall",
     "kind": "album",
     "copyright": "℗ 2020 Bad Boy/Interscope Records",
     "artistId": "465954501",
     "contentAdvisoryRating": "Explicit",
     "artistUrl": "https://music.apple.com/us/artist/machine-gun-kelly/465954501?app=itunes",
     "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/5e/e6/7c/5ee67cc6-4ea9-cbc4-251f-8ac9d7e1862f/20UMGIM66015.rgb.jpg/200x200bb.png",
     "genres": [
       {
         "genreId": "20",
         "name": "Alternative",
         "url": "https://itunes.apple.com/us/genre/id20"
       },
       {
         "genreId": "34",
         "name": "Music",
         "url": "https://itunes.apple.com/us/genre/id34"
       }
     ],
     "url": "https://music.apple.com/us/album/tickets-to-my-downfall/1526411768?app=itunes"
   }
   """ }
   
}

