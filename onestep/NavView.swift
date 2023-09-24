//
//  NavView.swift
//  onestep
//
//  Created by admin on 2023/9/9.
//

import SwiftUI

struct NavView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("主页")
                        }
                        .tag(0)
                    
                    ContentView()
                        .tabItem {
                            Image(systemName: "person.fill")
                                .frame(width: 100,height: 100)
                                .foregroundColor(.red)
                            Text("个人资料")
                        }
                        .tag(1)
                }
        .accentColor(Color("Navbar"))
    }
}
struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
