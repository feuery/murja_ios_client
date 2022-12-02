//
//  post_view.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 4.11.2022.
//

import SwiftUI
import CodeEditor

struct Post_View: View {
    @EnvironmentObject var ctrl: Murja_Client_Controller
    
    var body: some View {
        VStack {
            TextField("Title: ", text: $ctrl.selected_post.title).font(Font.headline.weight(.bold)).textFieldStyle(.roundedBorder)

            CodeEditor(source: $ctrl.selected_post.content, language: .xml)
        }.toolbar
        {
            ToolbarItem(placement: .primaryAction) {                
                Button("Save post") {
                    Task {
                        await ctrl.savePost(post: ctrl.selected_post)
                    }
                }
            }
        }
    }
}

struct post_view_Previews: PreviewProvider {

    static var previews: some View {
        Post_View()
    }
}
