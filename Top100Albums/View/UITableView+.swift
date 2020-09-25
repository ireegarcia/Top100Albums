//
//  UITableView+.swift
//  Top100Albums
//
//  Created by Iree García on 24/09/20.
//

import UIKit

protocol Reusable {
   static var reuseID: String { get }
}

extension UITableViewCell: Reusable {
   static var reuseID: String { String(describing: self) }
}

extension UITableView {
   func register(_ row: UITableViewCell.Type) {
      register(row, forCellReuseIdentifier: row.reuseID)
   }

   /// Dequeues a cel of the specified class, using its `reuseID`
   func dequeue<Row: UITableViewCell>(_ row: Row.Type,
                                      at indexPath: IndexPath,
                                      configure: (Row)->Void) -> UITableViewCell {
      let row = dequeueReusableCell(withIdentifier: Row.reuseID, for: indexPath)
      if let expectedRow = row as? Row {
         configure(expectedRow)
      } else {
         print("ERROR: Dequeued row \(row) not the expected type: \(Row.self)")
      }
      return row
   }
}
