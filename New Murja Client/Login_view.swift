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
    var body: some View {
        VStack(alignment: .center){
            
            
            TextField("Username",
                      text: $username)
            .frame(width: 200)
                      
            SecureField("Password",
                        text: $password)
            .frame(width:200)
            
            Button("Login") {
                
            }
            .padding()
/*            .background(Color(red: 0, green: 0, blue: 0))
            .foregroundColor(Color(red: 0, green: 1, blue: 0)) */
            .clipShape(Rectangle())
            
            Label {
                Text("Server we're logging into")
            } icon: {}
            
            TextField("Server we're logging in", text: $server_url)
                .frame(width: 200)
            
            
        }
    }
}

struct Login_view_Previews: PreviewProvider {
    static var previews: some View {
        Login_view()
    }
}
