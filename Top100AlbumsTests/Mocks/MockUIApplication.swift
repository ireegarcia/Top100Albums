//
//  MockUIApplication.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class OpenURLIntent: NSObject {
   var success: Bool
   var url: URL?
   
   internal init(success: Bool) {
      self.success = success
   }
}

// MARK: Open URL

extension UIApplication {

   static var nextOpenURLIntent: OpenURLIntent?

   static func mockOpenURLOnce(success: Bool) -> OpenURLIntent {
      let intent = OpenURLIntent(success: success)
      nextOpenURLIntent = intent
      return intent
   }

   func canOpenURL(_ url: URL) -> Bool { true }

   func open(_ url: URL,
             options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
             completionHandler completion: ((Bool) -> Void)? = nil) {
      UIApplication.nextOpenURLIntent?.url = url
      completion?(UIApplication.nextOpenURLIntent?.success ?? true)
      UIApplication.nextOpenURLIntent = nil
   }
}

