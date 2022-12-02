//
//  post.swift
//  Murja Client
//
//  Created by Ilpo Lehtinen on 23.9.2022.
//

import Foundation
import SwiftUI

enum post_source
{
    case server
    case app
}

final class Murja_Post: Encodable, Decodable, ObservableObject
{
    let source: post_source
    
    @Published var tags: [String]
    let creator: Murja_User?
    @Published var content: String 
                                                   
 //   @Published var comments: [String]
    let amount_of_comments: Int 
    @Published var title: String 
    let prev_post_id: Int 
    let id: Int?

    var new_post: Bool
    {
        get
        {
            id != nil
        }
    }
    
    let versions: [Int] 
    let version: Int? 
    let next_post_id: Int? 
   // let created_at: Date
    
    init(tags: [String], creator: Murja_User, content: String, /*comments: [String], */amount_of_comments: Int, title: String, prev_post_id: Int, id: Int, versions: [Int], version: Int?, next_post_id: Int?, src: post_source)
    {
        self.source = src
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

    init(creator: Murja_User?)
    {
        self.tags = []
        self.creator = creator
        self.amount_of_comments = -1
        self.title = ""
        self.prev_post_id = -1
        self.id = nil
        self.versions = []
        self.version = -1
        self.next_post_id = -1
        self.content = ""
        self.source = .app
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        source = .server
       
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

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tags, forKey: .tags)
        try container.encode(creator, forKey: .creator)
        try container.encode(content, forKey: .content)
        try container.encode(title, forKey: .title)
        try container.encode(prev_post_id, forKey: .prev_post_id)
        try container.encode(id, forKey: .id)
        try container.encode(versions, forKey: .versions)
        try container.encode(version, forKey: .version)
        try container.encode(next_post_id, forKey: .next_post_id)
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
    case empty
    case post (post:Murja_Post)
}
