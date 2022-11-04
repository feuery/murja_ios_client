//
//  ContentView.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 30.10.2022.
//

import SwiftUI

struct ViewModel {

}

struct ContentView: View {
    @State var titles: [Murja_Title] = []
//    @State var model = ViewModel(titles: [])
    @State var program_status = "Hello world!!!!"
    
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
                                        program_status = "Loaded!"
                                        self.titles = titles
                                    },
                                    onError: {error in
                                        program_status = error
                                    }
        )
    }


        
    @State var selected_post:Murja_Post?
    
    var body: some View {
        NavigationView {
            VStack {
                Text(program_status);
                List(self.titles) { title in
                    Button(title.Title,
                           action: { () in
                        loadFromFeuerx(route: "/posts/post/" + String(title.Id),
                                       onSuccess: {(post: Murja_Post) in
                            print("Loaded post " + post.title)
                        },
                                       onError: {error in
                            print("error loading post: " + error);
                        })})};
                
                
                Button("Load blog posts", action: { loadTitles() })
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
