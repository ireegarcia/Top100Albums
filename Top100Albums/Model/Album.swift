//
//  Album.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

struct Album: Codable {
   let id: String
   let name: String
   let artistName: String
   let url: URL
   let artworkUrl100: URL
   let genres: [Genre]
   let releaseDate: Date?
   // other info
   let copyright: String?
   let artistId: String?
   let artistUrl: URL?
}

struct Genre: Codable {
   let genreId: String
   let name: String
   let url: URL?
}
