//
//  AlbumViewModel.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

class AlbumViewModel {
   static let maxGenreDisplayCount = 3
   
   let name: String
   let artistName: String
   let rank: String
   let isTop3: Bool
   let releasedDateText: String?
   let genresLabel = "Genres"
   let compactGenresText: String
   let copyright: String?
   let artworkUrl: URL
   let largeArtworkUrl: URL
   let iTunesButtonTitle = "See on iTunes"
   let iTunesUrl: URL

   init(album: Album, rank: Int) {
      name = album.name
      artistName = album.artistName
      self.rank = "\(rank)"
      isTop3 = 1...3 ~= rank
      releasedDateText = album.releaseDate.map { date in
         DateFormatter.year.string(from: date)
      }
      
      // compact genres list
      let visibleGenres = album.genres.prefix(Self.maxGenreDisplayCount)
      var genresText = visibleGenres.map { $0.name }.joined(separator: ", ")
      if album.genres.count > visibleGenres.count {
         genresText += " and \(album.genres.count - visibleGenres.count) more."
      }
      compactGenresText = genresText
      
      copyright = album.copyright
      artworkUrl = album.artworkUrl100
      // infer larger version of the artwork
      // NOTE: it's a hack, but one normally has these endpoints available
      let string = artworkUrl.absoluteString.replacingOccurrences(of: "200x200", with: "900x900")
      largeArtworkUrl = URL(string: string) ?? album.artworkUrl100
      iTunesUrl = album.url
   }
}
