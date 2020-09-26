//
//  Feed.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import Foundation

// NOTE: condensing related decodables for easy edition

struct Feed: Decodable {
   let id: String
   let title: String
   let results: [Album]
   // other info
   let author: Author?
   let links: Links?
   let copyright: String?
   let country: String?
   let icon: String?
   
   /// The response structure that wraps the feed
   struct Response: Decodable {
      let feed: Feed
   }
}

struct Author: Codable {
   let name: String?
   let uri: URL?
}

// NOTE: example of custom parsing logic

struct Links: Decodable {
   let primary: URL?
   let alternate: URL?
   
   /// Solution for weird JSON structure
   private struct Part: Decodable {
      enum CodingKeys: String, CodingKey {
         case primary = "self"
         case alternate
      }
      let primary: URL?
      let alternate: URL?
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      // tech note: joins separate instances for primary and alternate links from an array
      let aux = try container.decode([Part].self)
      primary = aux.compactMap { $0.primary }.first
      alternate = aux.compactMap { $0.alternate }.first
   }
}
