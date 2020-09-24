//
//  RssAPI.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

extension URL {
   static let topAlbums = URL(string: "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json")
}

// enum so it's final and not instantiable at the same time
enum RssAPI {
   static let api = API()
   
   static func topAlbums(completion: @escaping (Response)->Void) {
      api.request(.topAlbums, method: .get, completion: completion)
   }
}
