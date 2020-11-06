//
//  PloggingRecordViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/10/22.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Then

protocol PloggingRecordDisplayLogic: class {
    func displayError(error: Common.CommonError, useCase: PloggingRecord.UseCase)
}

class PloggingRecordViewController: UIViewController, PloggingRecordDisplayLogic {
    var interactor: PloggingRecordBusinessLogic?
    var router: (NSObjectProtocol & PloggingRecordRoutingLogic & PloggingRecordDataPassing)?
    
    
    // MARK: - Views
    var scrollView = ScrollStackView()
    
    lazy var skipButton = UIButton().then{
        $0.setTitle("SKIP", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
        $0.setTitleColor(.init(red: 196, green: 196, blue: 196), for: .normal)
    }
    
    let recordContainer = UIView()
    let distanceContainer = UIView().then{
        $0.backgroundColor = .clear
    }
    
    let distanceImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_plogging_distance")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }
    
    let distanceLabel = UILabel().then{
        $0.font = .roboto(ofSize: 30, weight: .bold)
        $0.text = "0.00"
        $0.textColor = .black
    }
    
    let distanceUnitLabel = UILabel().then{
        $0.font = .roboto(ofSize: 20, weight: .bold)
        $0.text = "km"
        $0.textColor = .white
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
    let titleLabel = UILabel().then{
        $0.text = "오늘 무엇을 플로깅했나요?"
        $0.font = .notoSans(ofSize: 22, weight: .bold)
        $0.textAlignment = .center
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: PloggingRecordCollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        $0.register(PloggingRecordCollectionViewCell.self, forCellWithReuseIdentifier: "PloggingRecordCollectionViewCell")
    }
    
    let nextButtonView = UIView().then{
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 26
        $0.layer.masksToBounds = true
    }
    
    let nextLabel = UILabel().then{
        $0.text = "NEXT"
        $0.textColor = .white
        $0.font = .roboto(ofSize: 15, weight: .bold)
    }
    
    let nextImageView = UIImageView().then{
        $0.contentMode = .center
        $0.image = UIImage(named: "ic_BtnNextRight")
    }
    
    lazy var nextButton = UIButton()
    
    var itemList = [
        "플라스틱",
        "담배",
        "캔",
        "비닐",
        "일반쓰레기",
        "유리",
        "스트로폼",
        "빨대",
        "종이"
    ]
    
    var selectedItems: [Int] = []
    
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
        let interactor = PloggingRecordInteractor()
        let presenter = PloggingRecordPresenter()
        let router = PloggingRecordRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        self.setupView()
        self.setupLayout()
    }
    
    func displayError(error: Common.CommonError, useCase: PloggingRecord.UseCase){
        //handle error with its usecase
    }
}

extension PloggingRecordViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "PloggingRecordCollectionViewCell", for: indexPath) as? PloggingRecordCollectionViewCell else { fatalError() }
        let item = self.itemList[indexPath.item]
        let isSelected = self.selectedItems.contains(indexPath.item)
        cell.viewModel = .init(title: item, isSelected: isSelected)
        return cell
    }
}

extension PloggingRecordViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedItems.contains(indexPath.item), let index = selectedItems.firstIndex(of: indexPath.item){
            selectedItems.remove(at: index)
        }else{
            selectedItems.append(indexPath.item)
        }
        self.collectionView.reloadData()
    }
}
