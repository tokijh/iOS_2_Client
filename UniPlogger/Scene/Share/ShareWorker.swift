//
//  ShareWorker.swift
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

class ShareWorker {
    func uploadPloggingRecord(data: PloggingData, image: UIImage) {
        guard let uid = AuthManager.shared.user?.id else { return }
        let title = dateFormatter.string(from: Date())
        
        PloggingAPI.shared.uploadRecord(uid: uid, title: title, distance: data.distance.value, time: data.time, image: image) { (result) in
            switch result{
            case let .success(feed):
                print(feed)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // helper
    let dateFormatter = DateFormatter().then{
        $0.dateFormat = "yyyy.MM.dd"
        $0.locale = Locale.init(identifier: "Ko_kr")
    }
}
