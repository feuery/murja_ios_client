//
//  murja_user.swift
//  Murja Client
//
//  Created by Ilpo Lehtinen on 23.9.2022.
//

import Foundation

struct Murja_User: Codable {
    let username: String 
    let nickname: String 
    let img_location: String 
}

final class Logged_in_Murja_User: Codable, ObservableObject{

    let nickname: String
    let username: String
    let img_location: String
    let primary_group_name: String
    let permissions: [String]

    func toPostUser() -> Murja_User
    {
        Murja_User(username: username,
                   nickname: nickname,
                   img_location: img_location)
    }

    enum CodingKeys: String, CodingKey
    {
        case nickname = "nickname"
        case username = "username"
        case img_location = "img_location"
        case primary_group_name = "primary-group-name"
        case permissions = "permissions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        


        self.nickname = try values.decode(String.self, forKey: .nickname)
        self.username = try values.decode(String.self, forKey: .username)
        self.img_location = try values.decode(String.self, forKey: .img_location)
        self.primary_group_name = try values.decode(String.self, forKey: .primary_group_name)
        self.permissions = try values.decode([String].self, forKey: .permissions)
    }
}

enum Logged_in_Murja_user_Ui
{
    case empty
    case user(user:Logged_in_Murja_User)
}
