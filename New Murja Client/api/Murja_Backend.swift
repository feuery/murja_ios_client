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

    static func loadTitles(Ctrl: Murja_Client_Controller)
    {
        loadFromFeuerx(Ctrl,
                       route: "/posts/titles",
                       onSuccess: { titles in
                           print("Loaded titles")
                           Ctrl.titles = titles
                       },
                       onError: {error in
                           print("error: " + error)
                       }
        )
    }

    static func loadPost(_ Ctrl: Murja_Client_Controller, title: Murja_Title) {
        loadFromFeuerx(Ctrl,
                       route: "/posts/post/" + String(title.Id),
                       onSuccess: {(post: Murja_Post) in
                           Ctrl.selected_post = post
                       },
                       onError: {error in
                           print("error loading post: " + error)
                       })
    }

    static func loadFromFeuerx<T:Decodable>(_ ctrl: Murja_Client_Controller, route:String, onSuccess: @escaping (T) -> Void, onError: @escaping (String) -> Void) {
        let url: URL = URL(string: Murja_Backend.buildFeuerxPath(base_path: ctrl.base_path,
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
