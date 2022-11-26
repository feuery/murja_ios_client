import SwiftUI
import Foundation

// This class is supposed to contain global app state
// Views can contain their own state for all I care
class Murja_Client_Controller: ObservableObject {


    // let contentview = ContentView(Ctrl: self)
    // @Published var selected_post:Murja_Post_Ui = Murja_Post_Ui.empty
    @Published var base_path:String = ""
    @Published var selected_post: Murja_Post = Murja_Post()
    @Published var titles: [Murja_Title] = []
    @Published var logged_in_user: Logged_in_Murja_User? = nil
    @Published var user_logged_in = false

    func loadPost(title: Murja_Title)
    {
        Murja_Backend.loadPost(self, title: title)
    }

    func loadTitles ()
    {
        print("Loading titles")
        Murja_Backend.loadTitles(Ctrl: self)
    }

    // func pass_titles(titles) {
    //     contentview.titles = titles
    // }
}
