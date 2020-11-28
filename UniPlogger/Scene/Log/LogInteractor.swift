//
//  LogInteractor.swift
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

protocol LogBusinessLogic {
    func getFeed()
}

protocol LogDataStore {
  //var name: String { get set }
}

class LogInteractor: LogBusinessLogic, LogDataStore {
  var presenter: LogPresentationLogic?
  var worker: LogWorker?
  //var name: String = ""
    func getFeed() {
        worker = LogWorker()
        worker?.getFeed { [weak self] response in
            self?.presenter?.presentGetFeed(response: response)
        }
    }
}
