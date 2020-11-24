//
//  AuthAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/24.
//  Copyright © 2020 손병근. All rights reserved.
//

import Moya
import RxSwift
final class AuthAPI{
    typealias Response<T: Codable> = T
    
    let disposeBag = DisposeBag()
    
    static let shared = AuthAPI()
    private let provider = MoyaProvider<AuthAPITarget>(
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func login(email: String, password: String, completionHandler: @escaping (Result<LoginResponse, Error>) -> Void){
        provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(LoginResponse.self)
            .subscribe {
                completionHandler(.success($0))
            } onError: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
}
