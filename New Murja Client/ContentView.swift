//
//  ContentView.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 30.10.2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    var titles: [Murja_Title] = []
    var program_status = "Hello world!!!!"
    var selected_post:Murja_Post_Ui = Murja_Post_Ui.empty
    var base_path:String
    var logged_in_user: Logged_in_Murja_user_Ui = Logged_in_Murja_user_Ui.empty

    @Published var user_logged_in: Bool = false
    
    
    init(base_path:String) {
        self.base_path = base_path
    }

    init(titles: [Murja_Title],
         program_status: String,
         selected_post:Murja_Post_Ui,
         base_path:String)
    {
        self.titles = titles
        self.program_status = program_status
        self.selected_post = selected_post
        self.base_path = base_path
        // self.logged_in_user = logged_in_user
    }
}

struct ContentView: View {

    var viewmodel: ViewModel
        
    
    func addNewPost() {
        print("Adding a new post in backend and fetching new titles I guess")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewmodel.titles) { title in
                    Button(title.Title) {
                        Murja_Backend.loadPost(viewmodel, title: title)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .primaryAction)
                {
                    Button(action: addNewPost)
                    {
                        Image(systemName: "plus")
                    }}
            }
            Post_View(vm: viewmodel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var vm = ViewModel(base_path: "https://feuerx.net")
    static var previews: some View {
        ContentView(viewmodel: vm)
    }
}
