//
//  post.swift
//  Murja Client
//
//  Created by Ilpo Lehtinen on 23.9.2022.
//

import Foundation
import SwiftUI

final class Murja_Post: Decodable, ObservableObject
{
    @Published var tags: [String]
    let creator: Murja_User
    @Published var content: String
                                                   
 //   @Published var comments: [String]
    let amount_of_comments: Int
    @Published var title: String
    let prev_post_id: Int
    let id: Int
    let versions: [Int]
    let version: Int?
    let next_post_id: Int?
   // let created_at: Date
    
    init(tags: [String], creator: Murja_User, content: String, /*comments: [String], */amount_of_comments: Int, title: String, prev_post_id: Int, id: Int, versions: [Int], version: Int?, next_post_id: Int?, created_at: Date)
    {
        self.tags = tags
        self.creator = creator
//        self.content = content
//        self.comments = comments
        self.amount_of_comments = amount_of_comments
        self.title = title
        self.prev_post_id = prev_post_id
        self.id = id
        self.versions = versions
        self.version = version
        self.next_post_id = next_post_id
      // self.created_at = created_at
        self.content = content
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        tags = try values.decode(Array<String>.self, forKey: .tags)
        creator = try values.decode(Murja_User.self, forKey: .creator)
        content = try values.decode(String.self, forKey: .content)
      //  comments = try values.decode(Array<String>.self, forKey: .comments)
        amount_of_comments = 0
        title = try values.decode(String.self, forKey: .title)
        prev_post_id = try values.decode(Int.self, forKey: .prev_post_id)
        id = try values.decode(Int.self, forKey: .id)
        versions = try values.decode(Array<Int>.self, forKey: .versions)
        version = try values.decode(Int?.self, forKey: .version)
        next_post_id = try values.decode(Int?.self, forKey: .next_post_id)
       // created_at = try values.decode(Date.self, forKey: .created_at)
        
    }


    
    enum CodingKeys: String, CodingKey
    {
        case tags = "tags"
        case creator = "creator"
        case content = "content"
       // case comments = "comments"
        case amountofcomments = "amount-of-comments"
        case title = "title"
        case prev_post_id = "prev-post-id"
        case id = "id"
        case versions = "versions"
        case version = "version"
        case next_post_id = "next-post-id"
        case created_at = "created-at"
    }
}

enum Murja_Post_Ui
{
    case Empty
    case Post (post:Murja_Post)
}
