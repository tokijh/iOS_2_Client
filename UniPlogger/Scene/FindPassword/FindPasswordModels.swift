//
//  FindPasswordModels.swift
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

enum FindPassword {
    // MARK: Use cases
    
    enum UseCase {
        case FindPassword(FindPassword.Request)
    }
    
    enum FindPassword {
        struct Request {
            var email: String
        }
        
        struct Response {
            var request: Request
            var data: FindPasswordResponse?
            var error: Common.CommonError?
        }
        
        struct ViewModel {
            var data: String
        }
    }
}
