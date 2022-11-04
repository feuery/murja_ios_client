//
//  Murja_Title.swift
//  Murja Client
//
//  Created by Ilpo Lehtinen on 23.9.2022.
//

import Foundation

class Murja_Title : Codable, Identifiable
{
    var id: ObjectIdentifier?
    
    let Month: Float
    let Id: Int
    let Tags: [String]
    let Year: Float
    let Title: String
    
    enum CodingKeys: String, CodingKey
    {
        case Month = "Month"
        case Id = "Id"
        case Tags = "Tags"
        case Year = "Year"
        case Title = "Title"
    } 
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Month, forKey: .Month)
        try container.encode(Id, forKey: .Id)
        try container.encode(Tags, forKey: .Tags)
        try container.encode(Year, forKey: .Year)
        try container.encode(Title, forKey: .Title)
    }

    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        Id = try values.decode(Int.self, forKey: .Id)
        Month = try values.decode(Float.self, forKey: .Month)
        Tags = try values.decode([String].self, forKey: .Tags)
        Year = try values.decode(Float.self, forKey: .Year)
        Title = try values.decode(String.self, forKey: .Title)
        
        id = ObjectIdentifier(self)
    }
}
