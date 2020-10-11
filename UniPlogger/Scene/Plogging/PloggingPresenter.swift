//
//  PloggingPresenter.swift
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

protocol PloggingPresentationLogic {
    func presentDoing()
    func presentPause()
    func presentLocationService(response: Plogging.Location.Response)
}

class PloggingPresenter: PloggingPresentationLogic {
    weak var viewController: PloggingDisplayLogic?
    func presentDoing() {
        viewController?.displayStart()
    }
    func presentPause() {
        viewController?.displayPause()
    }
    
    func presentLocationService(response: Plogging.Location.Response) {
      switch response.status{
      case .denied:
        guard let url = LocationManager.shared.settingAppURL else { return }
        viewController?.displaySetting(message: "설정에서 위치 권한을 허용해주세요", url: url)
      case .notDetermined, .restricted:
        guard let url = LocationManager.shared.settingLocationURL else { return }
        viewController?.displaySetting(message: "설정에서 위치 권한을 허용해주세요", url: url)
      case .authorizedWhenInUse, .authorizedAlways:
        viewController?.displayLocation(location: LocationManager.shared.coordinate)
      default:
        break
      }
    }
}