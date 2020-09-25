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
      
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(AlbumRow.self)
      view.addSubview(tableView, pinTo: .safeArea)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
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
}
