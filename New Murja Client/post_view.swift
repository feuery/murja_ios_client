//
//  post_view.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 4.11.2022.
//

import SwiftUI

struct post_view: View {
    let post : Murja_Post
    @State var content = ""
    
    init(post:Murja_Post)
    {
        self.post = post
        content = post.content
    }
    
    var body: some View {
        VStack {
            Text(post.title).font(Font.headline.weight(.bold));
            TextField( LocalizedStringKey(post.title), text: $content)
            
        }
    }
}

struct post_view_Previews: PreviewProvider {
    static var previews: some View {
        post_view(post: Murja_Post(tags: [],
                                   creator: Murja_User(username: "testikäyttäjä", nickname: "testinimimerkki", img_location: ""),
                                   content: "testi contentti",
                                  // comments: [],
                                   amount_of_comments: 0,
                                   title: "testi title",
                                   prev_post_id: 0,
                                   id: 0,
                                   versions: [1,2,3],
                                   version: 3,
                                   next_post_id: Optional.none,
                                   created_at: Date.now)
        )}
}
