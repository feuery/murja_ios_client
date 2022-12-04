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

    @State private var columnVisibility = NavigationSplitViewVisibility.all 

    func addNewPost() {
        if let usr = Ctrl.logged_in_user {
            Ctrl.selected_post = Murja_Post(creator: usr.toPostUser())
            
        }
        else {
            print("User is not logged in")
        }
    }
    
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisibility) 
          {
              VStack {
                  List(Ctrl.titles) { title in
                      Button(title.Title) {
                          Ctrl.loadPost(title: title)
                          columnVisibility = .detailOnly
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
          }  detail: { Post_View() }
    }
}

struct ContentView_Previews: PreviewProvider {
    // @State static var vm = ViewModel(base_path: "https://feuerx.net")
    static var previews: some View {
        ContentView()
        
    }
}
