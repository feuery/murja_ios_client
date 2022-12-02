import SwiftUI
import Foundation

// This class is supposed to contain global app state
// Views can contain their own state for all I care
class Murja_Client_Controller: ObservableObject {


    // let contentview = ContentView(Ctrl: self)
    // @Published var selected_post:Murja_Post_Ui = Murja_Post_Ui.empty
    @Published var base_path:String = ""
    @Published var selected_post: Murja_Post = Murja_Post(creator: nil)
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

    func savePost (post:Murja_Post) async {
        let path = Murja_Backend.buildFeuerxPath(base_path: base_path,
                                                 route: "/posts/post")
        let url_opt = URL(string: path)

        if let url = url_opt {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = (post.id != nil) ? "PUT": "POST"

            do {
                let encoder = JSONEncoder()
                let json_post = try encoder.encode(post)
                let (data, _) = try await URLSession.shared.upload(for: request, from: json_post)

                print("Saved post: " + String(data: data, encoding: .utf8)!)
            } catch {
                print("Saving post failed")
            }
        }
        else {
            print ("Path " + path + " seems to be wrong")
        }
    }
}
