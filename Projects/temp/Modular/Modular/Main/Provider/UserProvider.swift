//
//  UserProvider.swift
//  Modular
//
//  Created by Enoxus on 16.01.2021.
//

import Moya

protocol UserProviderProtocol {
    func getUsers(completion: @escaping ([User]?) -> Void)
}

struct UserProvider: UserProviderProtocol {
    private let provider = MoyaProvider<UserApi>()
    
    func getUsers(completion: @escaping ([User]?) -> Void) {
        provider.request(.all) { result in
            if case let .success(response) = result {
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode([User].self, from: response.data)
                    completion(decoded)
                }
                catch {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
}
