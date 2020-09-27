//
//  NavigationTests.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 24/09/20.
//

import XCTest
import UIKit

// NOTE: controllers are added to the target and not @testable imported,
// to avoid depending on a host application. See MockUIApplication.swift

class NavigationTests: XCTestCase {
   
   func testFeedToAlbumNavigation() throws {
      let url = urlFor(fileName: "artwork.png")
      let feed = Feed(title: "TEST FEED", albums: [
         Album(name: "ALBUM TEST", artist: "ARTIST", url: url)
      ])
      
      let from = FeedViewController()
      from.model = FeedViewModel(feed: feed)
      
      let nav = MockNavigationController(rootViewController: from)
      from.tableView(from.tableView, didSelectRowAt: [0, 0])
      
      XCTAssert(nav.fakePushedController is AlbumDetailViewController,
                "Album detail not displayed")
      if let detail = nav.fakePushedController as? AlbumDetailViewController {
         XCTAssertEqual(detail.model.name, feed.results.first?.name,
                        "Passed model not correct")
      }
   }
   
   func testAlbumToiTunesNavigation() throws {
      let url = urlFor(fileName: "iTunesStore")
      let album = Album(name: "ALBUM TEST", artist: "ARTIST", url: url)
      
      let intent = UIApplication.mockOpenURLOnce(success: true)
      
      let from = AlbumDetailViewController(model: AlbumViewModel(album: album, rank: 0))
      from.iTunesButtonHit()
      
      XCTAssertEqual(url, intent.url, "iTunes URL not opened")
   }
}
