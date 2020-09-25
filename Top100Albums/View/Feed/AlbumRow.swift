//
//  AlbumRow.swift
//  Top100Albums
//
//  Created by Iree García on 25/09/20.
//

import UIKit

class AlbumRow: UITableViewCell {
   var model: AlbumViewModel? {
      didSet {
         // TODO:
         textLabel?.text = model?.name
      }
   }
}
