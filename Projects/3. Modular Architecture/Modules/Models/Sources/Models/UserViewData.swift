//
//  UserViewData.swift
//  ReactiveProgramming
//
//  Created by Enoxus on 27.10.2020.
//

public struct UserViewData {
    public let name: String
    public let username: String
    public let email: String
    public let address: String
    public let company: String
    
    public static func transform(_ user: User) -> UserViewData {
        return UserViewData(name: user.name,
                            username: "@\(user.username)",
                            email: user.email,
                            address: user.address.city,
                            company: user.company.name)
    }
    
    public static func transform(_ users: [User]) -> [UserViewData] {
        return users.map({ UserViewData.transform($0) })
    }
}
