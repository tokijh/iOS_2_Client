//
//  FindPasswordInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/11.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FindPasswordBusinessLogic {
    func findPassword(request: FindPassword.FindPassword.Request)
}

protocol FindPasswordDataStore {
    //var name: String { get set }
}

class FindPasswordInteractor: FindPasswordBusinessLogic, FindPasswordDataStore {
    var presenter: FindPasswordPresentationLogic?
    var worker = FindPasswordWorker()
    
    func findPassword(request: FindPassword.FindPassword.Request) {
        worker.findPassword(request: request) { response in
            self.presenter?.presentFindPassword(response: response)
        }
    }
}
