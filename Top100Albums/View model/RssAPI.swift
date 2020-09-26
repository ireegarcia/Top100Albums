//
//  RssAPI.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

extension URL {
   static let topAlbums = URL(string: "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json")
}

// enum so it's final and not instantiable at the same time
enum RssAPI {
   static let api = API()
   
   static func topAlbums(completion: @escaping (Response)->Void) {
      api.request(.topAlbums, method: .get, completion: completion)
   }
   
   static func artwork(url: URL, completion: @escaping (UIImage?)->Void) {
      api.image(url, completion: completion)
   }
   
   static func cancel(url: URL) {
      api.cancel(url)
   }
}
