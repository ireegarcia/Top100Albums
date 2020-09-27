//
//  AlbumDetailViewController.swift
//  Top100Albums
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class AlbumDetailViewController: UIViewController {
   let artworkImageView = UIImageView(image: .artworkPlaceholder)
   let nameLabel = UILabel()
   let artistLabel = UILabel()
   let rankLabel = UILabel()
   
   let model: AlbumViewModel
   
   init(model: AlbumViewModel) {
      self.model = model
      super.init(nibName: nil, bundle: nil)
   }
   
   // no IB instantiation
   @available(*, unavailable) required init?(coder: NSCoder) {
      nil
   }
   
   override func loadView() {
      view = UIView()
      view.backgroundColor = .appBackground
      
      artworkImageView.contentMode = .scaleAspectFill
      artworkImageView.clipsToBounds = true
      artworkImageView.tintColor = .separator
      artworkImageView.accessibilityIdentifier = "artwork"
      view.addSubview(artworkImageView)
      view.pin(artworkImageView, to: .bounds, bottom: nil)

      let ratio = artworkImageView.heightAnchor
         .constraint(equalTo: artworkImageView.widthAnchor)
      ratio.priority = .defaultHigh
      let maxHeight = artworkImageView.heightAnchor
         .constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5)
      
      NSLayoutConstraint.activate([ratio, maxHeight])
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      reload()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.navigationBar.barStyle = .black
   }
   
   func reload() {
      // TODO:

      RssAPI.artwork(url: model.artworkUrl) { [weak self] image in
         self?.artworkImageView.image = image
      }
   }
   
   @objc func iTunesButtonHit() {
      if UIApplication.shared.canOpenURL(model.iTunesUrl) {
         UIApplication.shared.open(model.iTunesUrl)
      }
   }
}
