//
//  LogPresenter.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/21.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LogPresentationLogic {
    func presentGetUser(response: Log.GetUser.Response)
    func presentGetFeed(response: Log.GetFeed.Response)
}

class LogPresenter: LogPresentationLogic {
    weak var viewController: LogDisplayLogic?
    func presentGetUser(response: Log.GetUser.Response) {
        guard let user = response.response, response.error == nil else {
            viewController?.displayError(error: response.error!, useCase: .GetUser)
            return
        }
        
        let viewModel = Log.GetUser.ViewModel(user: user)
        viewController?.displayGetUser(viewModel: viewModel)
    }
    
    func presentGetFeed(response: Log.GetFeed.Response) {
        guard let list = response.feedList, response.error == nil else {
            viewController?.displayError(error: response.error!, useCase: .GetFeed)
            return
        }
        let viewModel = Log.GetFeed.ViewModel(feedList: list)
        self.viewController?.displayGetFeed(viewModel: viewModel)
    }
}
