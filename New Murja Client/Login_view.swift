//
//  Login_view.swift
//  New Murja Client
//
//  Created by Ilpo Lehtinen on 11.11.2022.
//

import SwiftUI

struct Login_view: View {
    @State var username = "";
    @State var password = "";

    let userDefaults = UserDefaults()
    
    @State var server_url: String

    @StateObject var Ctrl: Murja_Client_Controller = Murja_Client_Controller()

    init() {
        if let username = userDefaults.string(forKey: "username") {
            self.username = username
        }
        else {
            self.username = ""
        }
        
        if let srv_url = userDefaults.string(forKey: "server_url") {
            server_url = srv_url
        }
        else {
            server_url = "http://localhost:3000" // "https://feuerx.net"
        }
    }
    
    func login(username: String, password: String, url:String) async
    {
        let login_path = Murja_Backend.buildFeuerxPath(base_path: url, route: "/login/login");
        
        let url = URL(string: login_path)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let json_parameter = "{\"username\": \"\(username)\", \"password\": \"\(password)\"}"
            let (data, _) = try await URLSession.shared.upload(for: request, from: Data(json_parameter.utf8))
            
            let decoder = JSONDecoder()
            
            
            let logged_in_user = try decoder.decode(Logged_in_Murja_User.self, from: data)
            
            Ctrl.logged_in_user = logged_in_user
            Ctrl.user_logged_in = true
            Ctrl.base_path = server_url.trimmingCharacters(in: .whitespacesAndNewlines)
            Ctrl.loadTitles();
            
            print("Login successful!")
            
        } catch {
            print("Login failed")
        }
        
    }
    
    var actual_loginview: some View {
        VStack(alignment: .center){
            
            
            TextField("Username",
                      text: $username)
              .frame(width: 200)
              .textFieldStyle(.roundedBorder)
            
            SecureField("Password",
                        text: $password)
              .frame(width:200)
              .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                Task {
                    await login(username: username, password: password, url: server_url.trimmingCharacters(in: .whitespacesAndNewlines))
                }

                userDefaults.set(server_url.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "server_url")
                userDefaults.set(username, forKey: "username")
            }
            .padding()
            .clipShape(Rectangle())
            
            Label {
                Text("Server we're logging into")
            } icon: {}
            
            TextField("Server we're logging in", text: $server_url)
              .frame(width: 200)
              .textFieldStyle(.roundedBorder)
        }
    }
    
    var body: some View {
        if Ctrl.logged_in_user != nil
        {
            ContentView().environmentObject(Ctrl)
        }
        else
        {
            actual_loginview.environmentObject(Ctrl)
        }
    }
    
}

struct Login_view_Previews: PreviewProvider {
    // @State static var vm = ViewModel(base_path: "https://feuerx.net")
    static var previews: some View {
        Login_view() // (viewmodel: $vm)
    }
}
