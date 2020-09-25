//
//  UIView+AutoLayout.swift
//  Top100Albums
//
//  Created by Iree García on 25/09/20.
//

import UIKit

enum LayoutGuideOption {
   case layoutMargins
   case readableContent
   case safeArea
}

extension UIView {
   func pin(to view: UIView, guide: LayoutGuideOption) {
      translatesAutoresizingMaskIntoConstraints = false
      
      let layoutGuide: UILayoutGuide
      switch guide {
      case .layoutMargins: layoutGuide = view.layoutMarginsGuide
      case .readableContent: layoutGuide = view.readableContentGuide
      case .safeArea: layoutGuide = view.safeAreaLayoutGuide
      }
      NSLayoutConstraint.activate([
         topAnchor.constraint(equalTo: layoutGuide.topAnchor),
         leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
         trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
         bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      ])
   }
   
   func addSubview(_ subview: UIView, pinTo guide: LayoutGuideOption) {
      addSubview(subview)
      subview.pin(to: self, guide: guide)
   }
}

