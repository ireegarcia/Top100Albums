//
//  UIConstants.swift
//  Top100Albums
//
//  Created by Iree García on 25/09/20.
//

import UIKit

extension CGFloat {
   /// Vertical space between two labels
   static let interlineSpacing: CGFloat = 5
   /// Horizontal space betweein two views
   static let itemSpacing: CGFloat = 8
   /// Recommended `minimumScaleFactor` for text.
   static let minimumFontScale: CGFloat = 0.85

   static let marginCompact: CGFloat = 12
   static let marginMedium: CGFloat = 25
   static let marginWide: CGFloat = 40
}

extension UIColor {
   static let appBackground = UIColor(white: 0.985, alpha: 1)
   static let appTint = UIColor.red
   static let text = UIColor.black
   static let textOverlay = UIColor.white.withAlphaComponent(0.9)
   static let separator = UIColor(white: 0.95, alpha: 1)
}

extension UIImage {
   static let artworkPlaceholder = #imageLiteral(resourceName: "artwork-placeholder")
}

extension UIEdgeInsets {
   /// Visually correct margin outside text elements
   static let visualTextMargins = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
}
