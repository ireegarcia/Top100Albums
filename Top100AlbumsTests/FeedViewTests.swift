//
//  FeedViewTests.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 24/09/20.
//

import XCTest

class FeedViewTests: XCTestCase {
   var sut: FeedViewModel?
   
   override func setUpWithError() throws {
      let url = urlFor(fileName: "artwork.png")
      let albums = (1...6).map { i in
         Album(name: "ALBUM\(i)", artist: "ARTIST\(i)", url: url)
      }
      let feed = Feed(title: "TEST FEED", albums: albums)
      sut = FeedViewModel(feed: feed)
   }
   
   func testFeedTitle() throws {
      XCTAssertEqual(sut?.title, "TEST FEED", "Wrong feed title")
   }
   
   func testAlbumsCount() throws {
      XCTAssertEqual(sut?.albums.count, 6, "Wrong album models count")
   }
   
   func testAlbumName() throws {
      XCTAssertEqual(sut?.albums.first?.name, "ALBUM1", "Wrong album name")
      XCTAssertEqual(sut?.albums.last?.name, "ALBUM6", "Wrong album name")
   }
   
   func testRankText() throws {
      XCTAssertEqual(sut?.albums.first?.rank, "1", "Wrong rank text")
      XCTAssertEqual(sut?.albums.last?.rank, "6", "Wrong rank text")
   }
}
