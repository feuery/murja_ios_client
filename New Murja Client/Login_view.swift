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
    @State var server_url = "https://feuerx.net"
    
    @StateObject private var viewmodel = ViewModel(base_path: "")
    
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
            
            viewmodel.logged_in_user = .user(user: logged_in_user)
            viewmodel.user_logged_in = true
            viewmodel.base_path = server_url
            
            print("Login successful!")
            Murja_Backend.loadTitles(viewmodel: viewmodel)
            
        } catch {
            print("Login failed")
        }
        
    }
    
    var actual_loginview: some View {
        VStack(alignment: .center){
            
            
            TextField("Username",
                      text: $username)
            .frame(width: 200)
            
            SecureField("Password",
                        text: $password)
            .frame(width:200)
            
            Button("Login") {
                Task {
                    await login(username: username, password: password, url: server_url)
                }
            }
            .padding()
            .clipShape(Rectangle())
            
            Label {
                Text("Server we're logging into")
            } icon: {}
            
            TextField("Server we're logging in", text: $server_url)
                .frame(width: 200)
        }
    }
    
    var body: some View {
        
        switch (viewmodel.logged_in_user)  {
        case .empty: actual_loginview
        case .user:
            ContentView(viewmodel: viewmodel)
        }
    }
}

struct Login_view_Previews: PreviewProvider {
    // @State static var vm = ViewModel(base_path: "https://feuerx.net")
    static var previews: some View {
        Login_view() // (viewmodel: $vm)
    }
}
