//
//  WelcomeView.swift
//  onestep
//
//  Created by admin on 2023/9/8.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var contentData: [(img: String, txt1: String, txt2: String, txt3: String)] = [
        ("intro1", "极简页面", "快速规划你的日常", "继续"),
        ("intro2", "贴纸联动", "快人一步进入任何状态", "继续"),
        ("intro3", "打卡有奖励", "让你自律上瘾", "立即开始")
        // 添加更多数据
    ]
    @State var nextpage:Bool = true
    @State  var offx = UIScreen.main.bounds.width
    @State var n = 0
    @State var a = 0
    @State private var isRectangle = [true, false, false]
    @State private var timercloud = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        if(isFirstLaunch && nextpage == true) {
            VStack {
                VStack(spacing: 30) {
                    HStack {
                        Spacer()
                        ForEach(contentData.indices, id: \.self) { index in
                            content(
                                img: $contentData[index].img,
                                txt1: $contentData[index].txt1,
                                txt2: $contentData[index].txt2                    )
                            .offset(x:offx)
                        }
                        Spacer()
                    }
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            if isRectangle[index] {
                                Rectangle()
                                    .frame(width: 28, height: 8)
                                    .foregroundColor(Color("continue"))
                                    .cornerRadius(5)
                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            } else {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.gray)
                                    .transition(.asymmetric(insertion: .opacity, removal: .scale))
                            }
                        }
                    }
                    
                    Button(action: {
                        a += 1
                        withAnimation{
                            if(n < 2) {
                                n += 1
                                if n == 1 {
                                    isRectangle[0] = false
                                    isRectangle[1] = true
                                    offx = 0
                                } else if n == 2 {
                                    isRectangle[0] = false
                                    isRectangle[1] = false
                                    isRectangle[2] = true
                                    offx = -UIScreen.main.bounds.width
                                   n = 2
                                }
                            }
                        }
                    }, label: {
                        Text(contentData[n].txt3)
                            .font(.system(size: 16))
                            .frame(width: 347,height: 53)
                            .foregroundColor(.white)
                            .background(Color("continue"))
                            .cornerRadius(30)
                    })
                    
                }
            }
            .onReceive(timercloud) {_ in
                if(a >= 2) {
                    nextpage = false
                }
            }
        }else if (isFirstLaunch && nextpage == false) {
            HomeView()
        }
           
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

struct content: View {
    @Binding var img:String
    @Binding var txt1:String
    @Binding var txt2:String
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Image(img)
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(txt1)
                Text(txt2)
            }
            .frame(width: 307,height: 119)
            .font(.system(size: 30))
            .bold()
        }
        .padding(-11)
    }
}
