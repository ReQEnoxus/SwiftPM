//
//  UserProvider.swift
//  ReactiveProgramming
//
//  Created by Enoxus on 27.10.2020.
//

import Moya
import Models
import Foundation

public protocol UserProviderProtocol {
    func getUsers(completion: @escaping ([User]?) -> Void)
}

public struct UserProvider: UserProviderProtocol {
    private let provider = MoyaProvider<UserApi>()
    
    public init() {}
    
    public func getUsers(completion: @escaping ([User]?) -> Void) {
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
