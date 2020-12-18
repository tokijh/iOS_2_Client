//
//  LogWorker.swift
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

class LogWorker {
    func updateRank(completion: @escaping () -> Void) {
        LogAPI.shared.updateRank { _ in
            completion()
        }
    }
    func getUser(uid: Int, completion: @escaping(Log.GetUser.Response) -> Void) {
        AuthAPI.shared.getUser(uid: uid) { (response) in
            switch response {
            case let .success(value):
                if value.success, let user = value.data {
                    let response = Log.GetUser.Response(response: user)
                    completion(response)
                } else {
                    let res = Log.GetUser.Response(error: .server(value.message))
                    completion(res)
                }
            case let .failure(error):
                let response = Log.GetUser.Response(error: .error(error))
                completion(response)
            }
        }
    }
    
    func updateLevel(completion: @escaping (Log.GetUser.Response) -> Void) {
        LogAPI.shared.updateLevel { response in
            switch response {
            case let .success(value):
                if value.success, let user = value.data {
                    let response = Log.GetUser.Response(response: user)
                    completion(response)
                } else {
                    let res = Log.GetUser.Response(error: .server(value.message))
                    completion(res)
                }
            case let .failure(error):
                let response = Log.GetUser.Response(error: .error(error))
                completion(response)
            }
        }
    }
    
    func getFeed(uid: Int, completion: @escaping(Log.GetFeed.Response) -> Void){
        LogAPI.shared.getFeed(uid: uid) { (response) in
            switch response{
            case let .success(value):
                if value.success, let feedList = value.data {
                    let response = Log.GetFeed.Response(feedList: feedList)
                    completion(response)
                } else {
                    let response = Log.GetFeed.Response(error: .server(value.message))
                    completion(response)
                }
                
            case let .failure(error):
                let response = Log.GetFeed.Response(error: .error(error))
                completion(response)
            }
        }
    }
}
