//
//  SharePresenter.swift
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

protocol SharePresentationLogic {
    func presentFetchRecord(response: Share.FetchRecord.Response)
}

class SharePresenter: SharePresentationLogic {
    weak var viewController: ShareDisplayLogic?
  
    // MARK: Do something
  
    func presentFetchRecord(response: Share.FetchRecord.Response) {
        let data = response.ploggingData
        let timeSet = data.timeSet()
        let distance = FormatDisplay.distance(data.distance)
        let time = "\(String(format: "%02d", timeSet.minutes)):\(String(format: "%02d", timeSet.seconds))"
        
        let viewModel = Share.FetchRecord.ViewModel(distance: distance, time: time, image: response.image)
        
        self.viewController?.displayFetchRecord(viewModel: viewModel)
    }
}
