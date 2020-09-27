//
//  MockNavigationController.swift
//  Top100AlbumsTests
//
//  Created by Iree García on 26/09/20.
//

import UIKit

class MockNavigationController: UINavigationController {
   var fakePushedController: UIViewController?

   override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      fakePushedController = viewController
      super.pushViewController(viewController, animated: animated)
   }
}
