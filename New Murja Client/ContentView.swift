//
//  ContentView.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 30.10.2022.
//

import SwiftUI

struct ViewModel {
    var titles: [Murja_Title] = []
    var program_status = "Hello world!!!!"
    var selected_post:Murja_Post_Ui = Murja_Post_Ui.Empty
}

struct ContentView: View {
    
    @State var viewmodel = ViewModel()
    
    func buildFeuerxPath(route:String) -> String
    {
        "https://feuerx.net/api" + route
    }

    func loadFromFeuerx<T:Decodable>(route:String, onSuccess: @escaping (T) -> Void, onError: @escaping (String) -> Void) {
        let url: URL = URL(string: buildFeuerxPath(route: route))!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if error != nil {
                    DispatchQueue.main.async {
                        onError(error.debugDescription)
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        onError("Joku http virhe")
                    }
                    return
                }
                
                if let _: String = String(data: data!, encoding: .utf8) {
                    
                    let decoder = JSONDecoder()
                    let result: T = try decoder.decode(T.self, from: data!)
                    
                    DispatchQueue.main.async {
                        onSuccess(result)
                    }
                    
                }
                else
                {
                    print("Couldn't load feuerx.net")
                }
            }
            catch {
                print("Fail: \(error)")
            }
            
        }
        task.resume()
    }
        

    
    func loadTitles()
    {
        loadFromFeuerx(route: "/posts/titles",
                       onSuccess: { titles in
            viewmodel.program_status = "Loaded!"
            viewmodel.titles = titles
        },
                       onError: {error in
            viewmodel.program_status = error
        }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewmodel.program_status);
                List(viewmodel.titles) { title in
                    Button(title.Title,
                           action: { () in
                        loadFromFeuerx(route: "/posts/post/" + String(title.Id),
                                       onSuccess: {(post: Murja_Post) in
                            viewmodel.selected_post = Murja_Post_Ui.Post(post: post)
                        },
                                       onError: {error in
                            print("error loading post: " + error);
                        })})};
                
                
                Button("Load blog posts", action: { loadTitles() })
                    .padding()
            };
            post_view(vm: viewmodel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
