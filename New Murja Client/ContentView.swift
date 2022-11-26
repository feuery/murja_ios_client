//
//  ContentView.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 30.10.2022.
//

import Foundation
import SwiftUI

struct ContentView: View {

    @EnvironmentObject var Ctrl: Murja_Client_Controller

    func addNewPost() {
        print("Adding a new post in backend and fetching new titles I guess")
    }
    
    var body: some View {
        NavigationView{
            VStack {
                List(Ctrl.titles) { title in
                    Button(title.Title) {
                        Ctrl.loadPost(title: title)
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
            Post_View()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // @State static var vm = ViewModel(base_path: "https://feuerx.net")
    static var previews: some View {
        ContentView()
        
    }
}
