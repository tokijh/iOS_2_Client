//
//  PloggingRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PloggingRoutingLogic {
    func routeToStartCounting()
}

protocol PloggingDataPassing {
    var dataStore: PloggingDataStore? { get }
}

class PloggingRouter: NSObject, PloggingRoutingLogic, PloggingDataPassing {
    weak var viewController: PloggingViewController?
    var dataStore: PloggingDataStore?
    
    func routeToStartCounting() {
        let destinationVC = StartCountingViewController()
        navigateToStartCounting(source: viewController!, destination: destinationVC)
    }
    
    func navigateToStartCounting(source: PloggingViewController, destination: StartCountingViewController){
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .overFullScreen
        source.present(destination, animated: true)
    }
}
