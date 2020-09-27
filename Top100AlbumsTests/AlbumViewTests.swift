//
//  AlbumAViewTests.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 24/09/20.
//

import XCTest

class AlbumViewTests: XCTestCase {
   var sut: AlbumViewModel?
   
   override func setUpWithError() throws {
      guard let data = sampleAlbum.data(using: .utf8) else {
         throw APIError.noData
      }
      let album = try Response.decoder.decode(Album.self, from: data)
      sut = AlbumViewModel(album: album, rank: 1)
   }
   
   var sampleAlbum: String { """
      {
        "artistName": "Led Zeppelin",
        "id": "1052497413",
        "releaseDate": "2007-11-09",
        "name": "Mothership (Remastered)",
        "kind": "album",
        "copyright": "℗ 2007 Atlantic Recording Corporation, a Warner Music Group Company.",
        "artistId": "994656",
        "artistUrl": "https://music.apple.com/us/artist/led-zeppelin/994656?app=itunes",
        "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music62/v4/7e/17/e3/7e17e33f-2efa-2a36-e916-7f808576cf6b/mzm.fyigqcbs.jpg/200x200bb.png",
        "genres": [
          {
            "genreId": "21",
            "name": "Rock",
            "url": "https://itunes.apple.com/us/genre/id21"
          },
          {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
          },
          {
            "genreId": "1152",
            "name": "Hard Rock",
            "url": "https://itunes.apple.com/us/genre/id1152"
          },
          {
            "genreId": "2",
            "name": "Blues",
            "url": "https://itunes.apple.com/us/genre/id2"
          },
          {
            "genreId": "1011",
            "name": "Country Blues",
            "url": "https://itunes.apple.com/us/genre/id1011"
          },
          {
            "genreId": "1147",
            "name": "Blues-Rock",
            "url": "https://itunes.apple.com/us/genre/id1147"
          },
          {
            "genreId": "1146",
            "name": "Arena Rock",
            "url": "https://itunes.apple.com/us/genre/id1146"
          },
          {
            "genreId": "1153",
            "name": "Metal",
            "url": "https://itunes.apple.com/us/genre/id1153"
          }
        ],
        "url": "https://music.apple.com/us/album/mothership-remastered/1052497413?app=itunes"
      }
      """ }

   func testAlbumName() throws {
      XCTAssertEqual(sut?.name, "Mothership (Remastered)", "Wrong album name")
   }

   func testArtistName() throws {
      XCTAssertEqual(sut?.artistName, "Led Zeppelin", "Wrong artist name")
   }

   func testGenresText() throws {
      XCTAssertEqual(sut?.compactGenresText, "Rock, Music, Hard Rock and 5 more.",
                     "Wrong genres text")
   }
   
   func textReleasedDateText() throws {
      XCTAssertEqual(sut?.releasedDateText, "2007", "Wrong releasedDate text")
   }

   func testCopyrightText() throws {
      XCTAssertEqual(sut?.copyright,
                     "℗ 2007 Atlantic Recording Corporation, a Warner Music Group Company.",
                     "Wrong releasedDate text")
   }
}
