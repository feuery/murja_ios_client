//
//  post_view.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 4.11.2022.
//

import SwiftUI
import CodeEditor

struct post_view: View {
    var vm : ViewModel
    
    var body: some View {
        switch(vm.selected_post)
        {
        case .Empty: Text("No post selected")
        case var .Post(real_post):
            let binding = Binding(
                get: {
                    real_post.content
                },
                set: {
                    real_post.content = $0
                }
            )

            VStack {
                Text(real_post.title).font(Font.headline.weight(.bold));
                CodeEditor(source: binding, language: .xml)
            }
            
        }
    }
}

struct post_view_Previews: PreviewProvider {

    static var previews: some View {
        post_view(vm: ViewModel(titles: [],
                                program_status: "Preview",
                                selected_post: Murja_Post_Ui.Empty))
    }
}
