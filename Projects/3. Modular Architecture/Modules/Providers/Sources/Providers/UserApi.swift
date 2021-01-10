//
//  UserApi.swift
//  ReactiveProgramming
//
//  Created by Enoxus on 27.10.2020.
//

import Moya
import Foundation

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
    
    var method: Moya.Method {
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
