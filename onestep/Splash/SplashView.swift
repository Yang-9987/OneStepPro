//
//  SplashView.swift
//  onestep
//
//  Created by admin on 2023/9/8.
//

import SwiftUI

struct SplashView: View {
    @State var typewirte:Bool  = false
    @State var neirong1 = "记录就"
    @State var neirong2 = "一步"
    @State var neirong3 = "生活快一步"
    @State var a1 = 0
    @State var a2 = 0
    @State var a3 = 0
    @State var color1:Color = .black
    @State var color2:Color = Color("text")
    @State var n1 = 0.0
    @State var n2 = 0.6
    @State var n3 = 1.0
    @State var move:Bool = false
    @State var move1:Bool = false
    @State var showpoints:Bool = false
    @State var nextpage:Bool = false
    @State private var timercloud = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        GeometryReader { geo in
            VStack {
                if typewirte == false {
                    LogoView()
                } else {
                    VStack {
                        HStack {
                            VStack(alignment: .leading,spacing: 10) {
                                HStack {
                                    TypewriterEffect(text: neirong1, delay: 0.2, currentIndex: $a1, color: $color1, n: $n1)
                                    Image("points")
                                        .opacity(showpoints ? 1 : 0)
                                        .background(.clear)
                                        .offset(y:-20)
                                }
                                TypewriterEffect(text: neirong2, delay: 0.2, currentIndex: $a2, color: $color2, n: $n2)
                                TypewriterEffect(text: neirong3, delay: 0.2, currentIndex: $a3, color: $color1, n: $n3)
                                Image("wave")
                                    .opacity(move1 ? 1 : 0)
                                    .overlay(
                                        Text("")
                                            .frame(width: 300,height:55).background(.white)
                                            .offset(x:move ? 1000 : 0)
                                            .animation(.default.speed(move ? 0.3 : 2))
                                            .opacity(move1 ? 1 : 0)
                                    )
                                    .onReceive(timercloud) {_ in
                                        if a3 != 0 {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                move1 = true
                                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    move = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        nextpage = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .animation(.none)
                            }
                            .padding(.leading,10)
                            .animation(.none)
                            Spacer()
                        }
                        Spacer()
                        Image("bubble")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.8)
                    }
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            showpoints = true
                        }
                    })
                }
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                typewirte = true
            }
        })
        .opacity(nextpage ? 0 : 1)
        .overlay(nextpage ? WelcomeView() : nil)
        .animation(.default)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
//打字机动画
struct TypewriterEffect: View {
    let text: String
    let delay: Double
    @Binding var currentIndex:Int
    @Binding var color:Color
    @Binding var n:Double
    var body: some View {
        Text(text.prefix(currentIndex))
            .multilineTextAlignment(.leading)
            .font(.system(size: 66))
            .bold()
            .foregroundColor(color)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + n) {
                    Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
                        if currentIndex < text.count {
                            currentIndex += 1
                        } else {
                            timer.invalidate()
                        }
                    }
                }
            }
    }
}


struct LogoView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("logopic")
                    .scaleEffect(0.5)
                Spacer()
            }
            Spacer()
        }
    }
}
