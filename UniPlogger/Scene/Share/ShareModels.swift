//
//  ShareModels.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/09/29.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Share
{
  // MARK: Use cases
  
    enum FetchRecord{
        struct Response{
            var distance: Measurement<UnitLength>
            var seconds: Int
            var minutes: Int
        }
        
        struct ViewModel{
            var distance: String
            var time: String
        }
    }
    enum Something {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
}
