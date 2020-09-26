//
//  FeedViewController.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

class FeedViewController: UIViewController {
   var tableView = UITableView()
   
   var model: FeedViewModel? {
      didSet { reload() }
   }
   var rows = [Row]()
   
   override func loadView() {
      view = UIView()
      view.backgroundColor = .appBackground
      
      tableView.dataSource = self
      tableView.delegate = self
      tableView.cellLayoutMarginsFollowReadableWidth = true
      tableView.register(AlbumRow.self)
      tableView.separatorStyle = .none
      tableView.backgroundColor = view.backgroundColor
      tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 5))
      tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
      
      view.addSubview(tableView, pinTo: .safeArea)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let bar = navigationController?.navigationBar {
         navigationItem.title = "💯💽"
         bar.barTintColor = view.backgroundColor
         bar.shadowImage = UIImage()
         bar.isTranslucent = false
         bar.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title1)
         ]
      }
      
      // get posts
      RssAPI.topAlbums { [weak self] response in
         guard let self = self else { return }
         do {
            let feed = try response.decode(as: Feed.Response.self).feed
            self.model = FeedViewModel(feed: feed)
         } catch {
            // TODO: show error
         }
      }
   }
   
   func reload() {
      // generate rows
      rows = model?.albums.map { .album($0) } ?? []
      tableView.reloadData()
   }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
   enum Row {
      case album(AlbumViewModel)
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      rows.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      switch rows[indexPath.row] {
      case .album(let album):
         return tableView.dequeue(AlbumRow.self, at: indexPath) { row in
            row.model = album
         }
      }
   }
   
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if case .album(let album) = rows[indexPath.row] {
         RssAPI.artwork(url: album.artworkUrl) { image in
            // `imageView` forwards to the actual artworkImageView to avoid casting
            cell.imageView?.image = image
         }
      }
   }
   
   func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      // NOTE: cancel requests so the images don't end up in a wrong cell
      if case .album(let album) = rows[indexPath.row] {
         RssAPI.cancel(url: album.artworkUrl)
      }
   }
}
