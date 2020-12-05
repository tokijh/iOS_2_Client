//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/24.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol SplashRoutingLogic {
    func routeToMain()
    func routeToLogin()
}

protocol SplashDataPassing {
    var dataStore: SplashDataStore? { get }
}

class SplashRouter: NSObject, SplashRoutingLogic, SplashDataPassing {
    weak var viewController: SplashViewController?
    var dataStore: SplashDataStore?
    
    func routeToMain() {
        let destinationVC = MainTabBarController()
        navigateToMain(source: viewController!, destination: destinationVC)
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
    }
    
    func navigateToMain(source: SplashViewController, destination: MainTabBarController){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window{
            window.rootViewController = destination
            window.makeKeyAndVisible()
        }
    }
    
    func navigateToLogin(source: SplashViewController, destination: LoginViewController) {
        let nvc = UINavigationController(rootViewController: destination)
        nvc.modalPresentationStyle = .fullScreen
        source.present(nvc, animated: true, completion: nil)
    }
    
}
