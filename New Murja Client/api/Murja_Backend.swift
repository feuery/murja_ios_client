//
//  Murja_Backend.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 11.11.2022.
//

import Foundation

class Murja_Backend {
    
    static func buildFeuerxPath(base_path: String, route:String) -> String
    {
        assert(base_path != "")
        return base_path + "/api" + route
    }

    static func loadTitles(viewmodel: ViewModel)
    {
        loadFromFeuerx(viewmodel,
                       route: "/posts/titles",
                       onSuccess: { titles in
            viewmodel.program_status = "Loaded!"
            viewmodel.titles = titles
        },
                       onError: {error in
            viewmodel.program_status = error
        }
        )
    }

    static func loadPost(_ viewmodel: ViewModel, title: Murja_Title) {
        loadFromFeuerx(viewmodel,
                       route: "/posts/post/" + String(title.Id),
                       onSuccess: {(post: Murja_Post) in
                           viewmodel.selected_post = Murja_Post_Ui.post(post: post)
                       },
                       onError: {error in
                           print("error loading post: " + error)
                       })
    }

    static func loadFromFeuerx<T:Decodable>(_ viewmodel: ViewModel, route:String, onSuccess: @escaping (T) -> Void, onError: @escaping (String) -> Void) {
        let url: URL = URL(string: Murja_Backend.buildFeuerxPath(base_path: viewmodel.base_path,
                                                   route: route))!
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
}
