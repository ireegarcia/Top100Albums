//
//  AlbumDetailViewController.swift
//  Top100Albums
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class AlbumDetailViewController: UIViewController {
   let model: AlbumViewModel
   
   init(model: AlbumViewModel) {
      self.model = model
      super.init(nibName: nil, bundle: nil)
   }
   
   // no IB instantiation
   @available(*, unavailable) required init?(coder: NSCoder) {
      nil
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      reload()
   }
   
   func reload() {
      // TODO:
   }
   
   @objc func iTunesButtonHit() {
      if UIApplication.shared.canOpenURL(model.iTunesUrl) {
         UIApplication.shared.open(model.iTunesUrl)
      }
   }
}
