//
//  PloggingInteractor.swift
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
import CoreLocation
protocol PloggingBusinessLogic {
    func startPlogging()
    func pausePlogging()
    func resumePlogging()
    func stopPlogging(request: Plogging.StopPlogging.Request)
    func setupLocationService()
    func fetchTrashCan()
    
    //TrashCan
    func addTrashCan(request: Plogging.AddTrashCan.Request)
    func addConfirmTrashCan(request: Plogging.AddConfirmTrashCan.Request)
    func removeTrashCan(request: Plogging.RemoveTrashCan.Request)
}

protocol PloggingDataStore {
    var distance: Measurement<UnitLength>? { get set }
    var seconds: Int? { get set }
    var minutes: Int? { get set }
}

class PloggingInteractor: NSObject, PloggingBusinessLogic, PloggingDataStore {
    var distance: Measurement<UnitLength>?
    var seconds: Int?
    var minutes: Int?
    
    var presenter: PloggingPresentationLogic?
    var worker = PloggingWorker()
    //var name: String = ""
    func startPlogging() {
        worker.delegate = self
        worker.startRun()
        self.presenter?.presentStartPlogging()
    }
    
    func pausePlogging() {
        worker.delegate = nil
        worker.pauseRun()
        self.presenter?.presentPausePlogging()
    }
    
    func resumePlogging() {
        worker.delegate = self
        worker.resumeRun()
        self.presenter?.presentResumePlogging()
    }
    
    func stopPlogging(request: Plogging.StopPlogging.Request) {
        worker.delegate = nil
        worker.stopRun { [weak self] distance in
            self?.seconds = request.seconds
            self?.minutes = request.minutes
            self?.distance = distance
            self?.presenter?.presentStopPlogging()
        }
    }
    
    func setupLocationService() {
        worker.updateAuthorization = { status in
            let response = Plogging.LocationAuth.Response(status: status)
            DispatchQueue.main.async { [weak self] in
              self?.presenter?.presentLocationService(response: response)
            }
        }
    }
    func fetchTrashCan() {
        self.worker.getTrashCanList { [weak self] (list) in
            let response = Plogging.FetchTrashCan.Response(list: list)
            self?.presenter?.presentFetchTrashCan(response: response)
        }
    }
    func addTrashCan(request: Plogging.AddTrashCan.Request) {
        let response = Plogging.AddTrashCan.Response(latitude: request.latitude, longitude: request.longitude)
        self.presenter?.presentAddTrashCan(response: response)
    }
    
    func removeTrashCan(request: Plogging.RemoveTrashCan.Request) {
        self.worker.deleteTrashCan(request: request)
    }
    
    func addConfirmTrashCan(request: Plogging.AddConfirmTrashCan.Request) {
        self.worker.addTrashCan(request: request)
        let response = Plogging.AddConfirmTrashCan.Response(latitude: request.latitude, longitude: request.longitude)
        self.presenter?.presentAddConfirmTrashCan(response: response)
    }
}

extension PloggingInteractor: PloggingWorkerDelegate{
    
    func updateRoute(distance: Measurement<UnitLength>, location: Location) {
        let response = Plogging.UpdatePloggingLocation.Response(
            distance: distance,
            location: location
        )
        
        self.presenter?.presentUpdatePloggingLocation(response: response)
    }
}
