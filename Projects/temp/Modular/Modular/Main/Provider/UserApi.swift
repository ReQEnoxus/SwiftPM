//
//  UserApi.swift
//  Modular
//
//  Created by Enoxus on 16.01.2021.
//

import Moya

enum UserApi {
    case all
}

extension UserApi: TargetType {
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .all:
            return "/users"
        }
    }
    
    var method: Method {
        switch self {
        case .all:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .all:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

