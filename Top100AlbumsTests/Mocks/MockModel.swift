//
//  MockModel.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 24/09/20.
//

import XCTest

extension Album {
   init(name: String, artist: String, url: URL) {
      self.init(id: "ID", name: name, artistName: artist, url: url, artworkUrl100: url,
                genres: [], releaseDate: nil, copyright: nil, artistId: nil, artistUrl: nil)
   }
}

extension Feed {
   init(title: String, albums: [Album]) {
      self.init(id: "ID", title: title, results: albums,
                author: nil, links: nil, copyright: nil, country: nil, icon: nil)
   }
}

extension XCTestCase {
   func urlFor(fileName: String) -> URL {
      URL(fileURLWithPath: fileName, relativeTo: Bundle(for: Self.self).bundleURL)
   }
}
