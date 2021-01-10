//
//  MainViewModel.swift
//  ReactiveProgramming
//
//  Created by Enoxus on 27.10.2020.
//

import RxRelay
import Moya
import Models
import Providers

typealias Users = [UserViewData]

struct MainViewModel {
    let users = BehaviorRelay<Users>(value: [])
    
    private let provider: UserProviderProtocol = UserProvider()
    
    func loadUsers() {
        provider.getUsers { response in
            guard let response = response else { return }
            users.accept(UserViewData.transform(response))
        }
    }
}
