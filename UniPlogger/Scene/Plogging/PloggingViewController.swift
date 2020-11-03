//
//  PloggingViewController.swift
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
import SnapKit
import Then
import MapKit
import CoreGraphics
import Toast_Swift

protocol PloggingDisplayLogic: class {
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase)
    func displayStart()
    func displayPause()
    func displaySetting(message: String, url: URL)
    func displayLocation(location: CLLocationCoordinate2D)
    func displayRun(viewModel: Plogging.StartRun.ViewModel)
    func displayLocationToast()
}

class PloggingViewController: BaseViewController {
    var interactor: PloggingBusinessLogic?
    var router: (NSObjectProtocol & PloggingRoutingLogic & PloggingDataPassing)?
    
    var state: Plogging.State = .ready
    var minutes = 0
    var seconds = 0
    
    var timer: Timer?
    
    var annotations: [TrashAnnotation] = []
    
    let startBottomContainerView = GradientView().then{
        $0.isHorizontal = true
        $0.colors = [.bottomGradientStart, .bottomGradientEnd]
        $0.locations = [0.0, 1.0]
    }
    
    let doingPauseBottomContainerView = GradientView().then{
        $0.isHorizontal = true
        $0.colors = [.bottomGradientStart, .bottomGradientEnd]
        $0.locations = [0.0, 1.0]
    }
    
    let distanceContainer = UIView().then{
        $0.backgroundColor = .clear
    }
    
    let distanceImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_plogging_distance")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }
    
    let distanceLabel = UILabel().then{
        $0.font = .roboto(ofSize: 30, weight: .bold)
        $0.text = "0.00 km"
        $0.textColor = .black
    }
    let timeContainer = UIView().then{
        $0.backgroundColor = .clear
    }
    
    let timeImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_plogging_time")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }
    
    let timeLabel = UILabel().then{
        $0.font = .roboto(ofSize: 30, weight: .bold)
        $0.text = "00:00"
        $0.textColor = .white
    }
    
    let ploggerImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_plogger.png")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var startButton = UIButton().then{
        $0.setTitle("START PLOGGING!", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    lazy var pauseButton = UIButton().then{
        $0.setTitle("잠시 멈춤", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    lazy var stopButton = UIButton().then{
        $0.setTitle("종료", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .init(red: 244, green: 95, blue: 95)
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(displayStop), for: .touchUpInside)
    }
    
    lazy var resumeButton = UIButton().then{
        $0.setTitle("이어달리기", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(displayResume), for: .touchUpInside)
    }
  
    let bubbleView = UIImageView().then{
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.layer.cornerRadius = 10
        let cock = UIImageView(image: UIImage(named: "bubbleCock"))
        $0.addSubview(cock)
        cock.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    let bubbleLabel = UILabel().then{
        $0.text = "준비물을 확인해주세요."
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var trashButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_trashcan")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.imageView?.contentMode = .center
        $0.backgroundColor = UIColor(red: 95/255, green: 116/255, blue: 244/255, alpha: 1)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
    }
    
    lazy var myLocationButton = UIButton().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }
    
    var myLocationBottomPriority: ConstraintMakerFinalizable? = nil
    
    lazy var mapView = MKMapView().then{
        $0.showsUserLocation = true
        $0.delegate = self
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PloggingInteractor()
        let presenter = PloggingPresenter()
        let router = PloggingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setupView()
        setupLayout()
        mapView.register(
        TrashAnnotationView.self,
        forAnnotationViewWithReuseIdentifier:
          MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.interactor?.setupLocationService()
        
        for trash in PloggingWorker.trashCanList {
            let coordinate = CLLocationCoordinate2D(
                latitude: trash.latitude,
                longitude: trash.longitude
            )
            let annotation = TrashAnnotation(coordinate: coordinate, title: "title", subtitle: "content")
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = self.presentedViewController as? StartCountingViewController{
            self.startPlogging()
        }
    }
    
    @objc func startButtonTapped(){
        let reqquest = Plogging.ChangeState.Request(state: self.state)
        interactor?.changeState(request: reqquest)
    }
    
    @objc func pauseButtonTapped(){
        let reqquest = Plogging.ChangeState.Request(state: self.state)
        interactor?.changeState(request: reqquest)
    }
    
    @objc func trashButtonTapped(){
        //Todo: 핀 추가 및 이동되도록함
        let annotation = TrashAnnotation(coordinate: mapView.centerCoordinate, title: "title", subtitle: "content")
        self.annotations.append(annotation)
        mapView.addAnnotation(annotation)
        if let av = mapView.view(for: annotation){
            print(av)
        }
    }
    
    @objc func myLocationButtonTapped(){
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @objc func UpdateTimer() {
        seconds = seconds + 1
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        timeLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
  
    func startPlogging(){
        self.startBottomContainerView.isHidden = true
        self.doingPauseBottomContainerView.isHidden = false
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        
        self.myLocationButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(self.doingPauseBottomContainerView.snp.top).offset(-16)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        self.interactor?.startRun()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
                // User Interface is Dark
                [distanceLabel,timeLabel].forEach {
                    $0.textColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
                }
                [distanceImageView, timeImageView].forEach{
                    $0.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
                }
        } else {
            [distanceLabel,timeLabel].forEach {
                $0.textColor = .black
            }
            [distanceImageView, timeImageView].forEach{
                $0.tintColor = .black
            }
        }
    }
    
    func removeTrashCan(annotation: TrashAnnotation){
        let alert = UIAlertController(title: "경고", message: "해당 쓰레기통을 제거하시겠습니까?", preferredStyle: .alert)
        alert.addAction(.init(title: "네", style: .default, handler: { _ in
            self.mapView.removeAnnotation(annotation)
        }))
        alert.addAction(.init(title: "아니오", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension PloggingViewController: PloggingDisplayLogic{
    func displayRun(viewModel: Plogging.StartRun.ViewModel) {
        
        mapView.setRegion(viewModel.region, animated: true)
        mapView.addOverlay(viewModel.polyLine)
        
        self.distanceLabel.text = viewModel.distance
    }
    func displayStart() {
        self.state = .doing
        self.router?.routeToStartCounting()
    }
    
    func displayPause() {
        self.pauseButton.isHidden = true
        self.stopButton.isHidden = false
        self.resumeButton.isHidden = false
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func displayStop() {
        self.seconds = 0
        self.minutes = 0
        timeLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        self.startBottomContainerView.isHidden = false
        self.doingPauseBottomContainerView.isHidden = true
        self.myLocationButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            $0.width.height.equalTo(40)
            $0.bottom.equalTo(self.startBottomContainerView.snp.top).offset(-16)
        }
        self.router?.routeToPloggingRecord()
    }
    
    @objc func displayResume() {
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func displaySetting(message: String, url: URL){
        let alert = UIAlertController(title: "위치 권한 필요", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "권한설정", style: .default, handler: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func displayLocation(location: CLLocationCoordinate2D) {
        let region: MKCoordinateRegion = .init(
            center: location,
            latitudinalMeters: 0.01,
            longitudinalMeters: 0.01)
        mapView.setRegion(region, animated: true)
    }
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase){
        //handle error with its usecase
    }
    
    func displayLocationToast(){
        DispatchQueue.main.async {
            self.view.makeToast("iPhone의 '설정 > 개인 정보 보호 > 위치 서비스'에 위치 서비스 항목을 허용해주시고 다시 시도해주세요")
        }
    }
}
extension PloggingViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "annotation_myLocation")
            return pin
        }else if annotation is TrashAnnotation {
            let pin = TrashAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            pin.longPressClosure = { [weak self] in
                self?.removeTrashCan(annotation: annotation as! TrashAnnotation)
            }
            return pin
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MultiColorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = polyLine.color
        renderer.lineWidth = 3
        renderer.lineJoin = .round
        renderer.lineCap = .round
        return renderer
    }
}
