//
//  LogViewController.swift
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

protocol LogDisplayLogic: class {
    func displayGetUser(viewModel: Log.GetUser.ViewModel)
    func displayGetFeed(viewModel: Log.GetFeed.ViewModel)
    func displayError(error: Common.CommonError, useCase: Log.UseCase)
}

class LogViewController: UIViewController {
    var interactor: LogBusinessLogic?
    var router: (NSObjectProtocol & LogRoutingLogic & LogDataPassing)?
    
    var feedList: [Feed] = []
    
    var scrollView = ScrollStackView().then {
        $0.alwaysBounceVertical = true
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    let ploggerContainer = UIImageView().then{
        $0.image = UIImage(named: "mypage_background")
        $0.contentMode = .scaleToFill
    }
    
    let ploggerImageView = UIImageView().then{
        $0.image = UIImage(named: "character")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let yellowStarImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_logStarYellow")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let levelTitleLabel = UILabel().then{
        $0.text = "레벨"
        $0.textColor = .black
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let levelLabel = UILabel().then{
        $0.text = "2"
        $0.textColor = .black
        $0.font = .notoSans(ofSize: 20, weight: .bold)
    }
    
    let rankTItleLabel = UILabel().then{
        $0.text = "상위"
        $0.textColor = .black
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let rankLabel = UILabel().then{
        $0.text = "5%"
        $0.textColor = .black
        $0.font = .notoSans(ofSize: 20, weight: .bold)
    }
    
    let pinkStarImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_logStarPink")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let statContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "color_logBackground")
    }
    
    let statTitleLabel = UILabel().then {
        $0.text = "통계"
        $0.font = .notoSans(ofSize: 18, weight: .medium)
    }
    
    let statInnerContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let weeklyTitleLabel = UILabel().then {
        $0.text = "주간"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let weeklyCircleView = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 41
    }
    let weeklyContentLabel = UILabel().then{
        $0.text = "매주\n월"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = .notoSans(ofSize: 16, weight: .regular)
    }
    let monthlyTitleLabel = UILabel().then {
        $0.text = "월간"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let monthlyCircleView = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 41
    }
    let monthlyContentLabel = UILabel().then{
        $0.text = "평균\n10회"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = .notoSans(ofSize: 16, weight: .regular)
    }
    
    lazy var collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: LogCollectionViewLayout()).then {
        $0.backgroundColor = UIColor(named: "color_logBackground")
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(LogCollectionViewCell.self, forCellWithReuseIdentifier: "LogCollectionViewCell")
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
        let interactor = LogInteractor()
        let presenter = LogPresenter()
        let router = LogRouter()
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
        configuration()
        setupView()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getUser()
    }
    
    
    
    func getFeed(){
        self.interactor?.getFeed()
    }
    
    @objc func handleRefreshControl(){
        self.interactor?.getUser()
        
    }
}

extension LogViewController: LogDisplayLogic{
    func displayGetUser(viewModel: Log.GetUser.ViewModel) {
        let user = viewModel.user
        self.levelLabel.text = "\(user.level)"
        self.rankLabel.text = "\(Int(user.rank))%"
        self.weeklyContentLabel.text = user.weeklyStat
        self.monthlyContentLabel.text = "\(user.monthlyStat)"
        self.navigationItem.title = "\(user.nickname) 로그"
        
        self.interactor?.getFeed()
    }
    func displayGetFeed(viewModel: Log.GetFeed.ViewModel) {
        UPLoader.shared.hidden()
        self.feedList = viewModel.feedList
        if let layout = self.collectionView.collectionViewLayout as? LogCollectionViewLayout {
            layout.resetCache()
        }
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    func displayError(error: Common.CommonError, useCase: Log.UseCase){
        UPLoader.shared.hidden()
        self.scrollView.refreshControl?.endRefreshing()
        switch error {
        case .server(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .local(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .error(let error):
            if let error = error as? URLError {
                NetworkErrorManager.alert(error) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                        guard let self = self else { return }
                        switch useCase{
                        case .GetUser:
                            self.interactor?.getUser()
                        case .GetFeed:
                            self.interactor?.getFeed()
                        }
                    }
                }
            } else if let error = error as? MoyaError {
                NetworkErrorManager.alert(error)
            }
            
        }
    }
}

extension LogViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogCollectionViewCell", for: indexPath) as? LogCollectionViewCell else { fatalError() }
        let feed = feedList[indexPath.item]
        
        cell.viewModel = .init(image: feed.photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.router?.routeToDetail()
    }
}
