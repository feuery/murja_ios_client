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
            Text(ctrl.selected_post.title).font(Font.headline.weight(.bold));
            CodeEditor(source: $ctrl.selected_post.content, language: .xml)
        }
        
    }
}

struct post_view_Previews: PreviewProvider {

    static var previews: some View {
        Post_View()// vm: ViewModel(titles: [],
                  //               program_status: "Preview", selected_post: Murja_Post_Ui.empty, base_path:"https://feuerx.net"))
    }
}
