//
//  FeedViewModel.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

class FeedViewModel {
   let title: String
   let albums: [AlbumViewModel]
   
   init(feed: Feed) {
      title = feed.title
      albums = feed.results.enumerated().map { i, album in
         AlbumViewModel(album: album, rank: i + 1)
      }
   }
}
