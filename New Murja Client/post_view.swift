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
    @State var new_tag = ""
    @State var valid_tags: [String] = []
    
    var body: some View {
        if ctrl.showTagSelector  {
            Form {
                Section (header: Text("Tags")) {
                    MultiSelector(items: $valid_tags,
                                  selections: $ctrl.selected_post.tags)
                }
                Section (header: Text("New tag")) {
                    HStack {
                        TextField("", text: $new_tag)
                          .textFieldStyle(.roundedBorder)
                        Button("Add tag") {
                            valid_tags.append(new_tag)
                            new_tag = ""
                        }
                    }
                }
            } .toolbar
            {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                               ctrl.showTagSelector = false
                               ctrl.status = "Tags: [" + ctrl.selected_post.tags.joined(separator: ", ") + "]"
                           })
                    {
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
              .onAppear {
                  valid_tags = ctrl.allTags(titles: ctrl.titles)
              }
        }
        else {
            VStack {
                TextField("Title: ", text: $ctrl.selected_post.title).font(Font.headline.weight(.bold)).textFieldStyle(.roundedBorder)

                CodeEditor(source: $ctrl.selected_post.content, language: .xml)
                TextField("", text: $ctrl.status).textFieldStyle(.roundedBorder)
            }.toolbar
            {
                ToolbarItem(placement: .secondaryAction) {
                    Button("Manage tags") {
                        ctrl.showTagSelector = true
                    }
                }
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
}

struct post_view_Previews: PreviewProvider {

    static var previews: some View {
        Post_View()
    }
}
