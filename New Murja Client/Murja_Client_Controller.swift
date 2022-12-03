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
    @Published var status = ""

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

            let updating_post = (post.id != nil)
            
            request.httpMethod = updating_post ? "PUT": "POST"

            print("Sending request with method " + request.httpMethod!)

            do {
                let encoder = JSONEncoder()
                let decoder = JSONDecoder()
                let json_post = try encoder.encode(post)
                let (data, _) = try await URLSession.shared.upload(for: request, from: json_post)

                guard let updated_post_str = String(data: data, encoding: .utf8) else {
                    status = "Probably saved the post, but backend returned something rubbish we can't decipher"
                    return
                }

                guard let updated_post = try? decoder.decode(Murja_Post.self, from: data) else {
                    status = "Probably saved the post, but decoding the return value from the server (" + updated_post_str + ") failed"
                    return
                }


                selected_post = updated_post
                loadTitles()

                status = "Saved post!"
            } catch {
                status = "Saving post failed"
            }
        }
        else {
            status = "Path " + path + " seems to be wrong"
        }
    }
}
