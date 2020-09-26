//
//  UIView+AutoLayout.swift
//  Top100Albums
//
//  Created by Iree García on 25/09/20.
//

import UIKit

enum LayoutPinOption {
   case layoutMargins
   case readableContent
   case safeArea
   case bounds
}

extension UIView {
   func pin(_ view: UIView, to option: LayoutPinOption,
            top: CGFloat? = 0, leading: CGFloat? = 0, trailing: CGFloat? = 0, bottom: CGFloat? = 0) {
      
      view.translatesAutoresizingMaskIntoConstraints = false
      
      let anchors: LayoutAnchors
      switch option {
      case .layoutMargins: anchors = layoutMarginsGuide
      case .readableContent: anchors = readableContentGuide
      case .safeArea: anchors = safeAreaLayoutGuide
      case .bounds: anchors = self
      }
      let constraints: [NSLayoutConstraint?] = [
         top.map { view.topAnchor.constraint(equalTo: anchors.topAnchor, constant: $0) },
         leading.map { view.leadingAnchor.constraint(equalTo: anchors.leadingAnchor, constant: $0) },
         trailing.map { anchors.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: $0) },
         bottom.map { anchors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: $0) }
      ]
      // activate resulting constraints
      NSLayoutConstraint.activate(constraints.compactMap { $0 })
   }
   
   func addSubview(_ subview: UIView, pinTo guide: LayoutPinOption) {
      addSubview(subview)
      pin(subview, to: guide)
   }
}

// MARK: - Anchors interoperability

protocol LayoutAnchors {
   var leadingAnchor: NSLayoutXAxisAnchor { get }
   var trailingAnchor: NSLayoutXAxisAnchor { get }
   var leftAnchor: NSLayoutXAxisAnchor { get }
   var rightAnchor: NSLayoutXAxisAnchor { get }
   var topAnchor: NSLayoutYAxisAnchor { get }
   var bottomAnchor: NSLayoutYAxisAnchor { get }
   var widthAnchor: NSLayoutDimension { get }
   var heightAnchor: NSLayoutDimension { get }
   var centerXAnchor: NSLayoutXAxisAnchor { get }
   var centerYAnchor: NSLayoutYAxisAnchor { get }
   var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
   var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutAnchors {}
extension UILayoutGuide: LayoutAnchors {
   var firstBaselineAnchor: NSLayoutYAxisAnchor { bottomAnchor }
   var lastBaselineAnchor: NSLayoutYAxisAnchor { bottomAnchor }
}
