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
                       route: "/posts/all-titles",
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
        let url_as_string = Murja_Backend.buildFeuerxPath(base_path: ctrl.base_path,
                                                          route: route);
        let url: URL = URL(string: url_as_string)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if error != nil {
                    DispatchQueue.main.async {
                        onError(error.debugDescription)
                    }
                    return
                }
                if let httpResponse = response as? HTTPURLResponse
                {
                    if !((200...299).contains(httpResponse.statusCode))
                    {
                        DispatchQueue.main.async {
                            onError("Some http error, status " + String(httpResponse.statusCode) + " and url we're trying to retrieve is " + url_as_string)
                        }
                        return
                    }
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
