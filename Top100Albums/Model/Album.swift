//
//  Album.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

struct Album: Codable {
   let id: String
   let artistName: String
   let url: URL
   let artworkUrl100: URL
   let genres: [Genres]
   // other info
   let releaseDate: String?
   let name: String?
   let copyright: String?
   let artistId: String?
   let artistUrl: URL?
}

struct Genres: Codable {
   let genreId: String
   let name: String
   let url: URL?
}
