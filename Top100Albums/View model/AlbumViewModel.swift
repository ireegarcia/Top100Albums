//
//  AlbumViewModel.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

class AlbumViewModel {
   let name: String
   let artistName: String
   let rank: String
   let isTop3: Bool
   let artworkUrl: URL

   init(album: Album, rank: Int) {
      name = album.name
      artistName = album.artistName
      self.rank = "\(rank)"
      isTop3 = 1...3 ~= rank
      artworkUrl = album.artworkUrl100
   }
}
