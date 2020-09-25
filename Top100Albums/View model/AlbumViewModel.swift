//
//  AlbumViewModel.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

class AlbumViewModel {
   let name: String

   init(album: Album) {
      name = album.name
   }
}
