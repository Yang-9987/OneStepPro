//
//  SwiftUIView.swift
//  onestep
//
//  Created by admin on 2023/9/8.
//

import SwiftUI
func initUserData() -> [SingleToDo] {
    var outPut:[SingleToDo] = [] //定义一个空SingleToDo数组
    //从用户存储位置读取数据
    if let dataStored = UserDefaults.standard.object(forKey: "myTests") as? Data{
        let myData = try! deCoder.decode([SingleToDo].self, from: dataStored) //将读取到的数据转码为[SingleToDo]数组
        for item in myData{
            //如果没有删除就追加数据
            if !item.isDelete{
                outPut.append(SingleToDo(id: outPut.count, title: item.title, myData: item.myData, isChecked: item.isChecked, isFavorite: item.isFavorite, sendNotifications: item.sendNotifications))
            }
        }
    }
    return outPut //返回格式化后的数据
}
struct HomeView: View {
    @ObservedObject var toDoList:ToDo = ToDo(initUserData())
    @State var goSetting:Bool = false //是否进入设置/多选模式
    @State var multiSelectArr:[Int] = [] //编辑、多选模式下的选中的ID数组
    @State var favoriteOnly = false
    @State private var username = "小曹"
    @State private var currentDate = Date()
    @State private var progress:CGFloat = 0.68
    @State private var ToCalendar = false
    @State private var isShowingSecondView = false
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    HStack{
                        Button(action: {
                            ToCalendar = true
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 57,height: 35)
                                    .cornerRadius(24)
                                    .foregroundColor(Color("calender"))
                                Image("calender")
                                    .resizable()
                                    .frame(width: 22, height: 20)
                                
                            }
                        })
                        .padding(10)
                        Text("今天")
                            .font(.system(size: 14))
                            .foregroundColor(Color("calender"))
                        Text(formatDateWithWeekday(date: currentDate))
                            .font(.system(size: 14))
                        Spacer()
                        Button(action: {}, label: {
                            Image("notice")
                                .resizable()
                                .frame(width: 25,height: 26)
                                .padding(.trailing, 10)
                        })
                    }
                    VStack(alignment: .leading) {
                        ZStack{
                            HStack {
                                Rectangle()
                                    .frame(width: 283,height: 16)
                                    .foregroundColor(Color("txt"))
                                    .cornerRadius(15)
                                Spacer()
                            }
                            HStack {
                                Text("早上好")
                                    .font(.system(size: 30))
                                    .bold()
                                Text(username)
                                    .font(.system(size: 30))
                                Spacer()
                            }
                            .padding(.leading,10)
                        }
                        Text("你已完成今日计划的")
                            .padding(.leading,10)
                    }
                    .padding(.leading,10)
                    HStack {
                        ZStack {
                            Circle()
                                .trim(from: 1.0 - progress, to: 1.0) // 逆时针方向的进度
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color("circle")) // 圆环的颜色
                                .rotationEffect(.degrees(-90)) // 逆时针方向的旋转
                                .animation(.linear) // 添加动画效果
                            Image("bubble")
                                .resizable()
                                .frame(width: 95,height: 85)
                        }
                        .frame(width: 160, height: 160)
                        HStack(alignment: .bottom){
                            Text("\(Int(progress * 100))")
                                .font(.system(size: 96))
                                .foregroundColor(Color("progress"))
                                .bold()
                            Text("%")
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom,10)
                        }
                    }
                    HStack {
                        Text("今日计划")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                        NavigationLink(destination: ContentView()) {
                            Text("查看全部")
                                .foregroundColor(Color("picked"))
                                .font(.system(size: 16))
                        }
                    }
                    .padding(.horizontal,30)
                    ScrollView {
                        ForEach(toDoList.todolist){ item in
                            if !item.isDelete{
                                if areDatesEqualIgnoringTime(date1: item.myData, date2: currentDate) {
                                    CardView(i:item.id,goSetting:$goSetting,setChecked:$multiSelectArr)
                                        .environmentObject(toDoList)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("主页", displayMode: .large)
        }
        .background(.white)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                currentDate = Date()
                refreshData()
            }
        }
        .fullScreenCover(isPresented: $isShowingSecondView) {
                            ContentView()
                        }
        .fullScreenCover(isPresented: $ToCalendar) {
            DayPickerView()
        }
    }
    func refreshData() {
        toDoList.todolist = initUserData()
    }
    func formatDateWithWeekday(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MM月dd日"
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        //        HomeView(toDoList: ToDo(
        //            [
        //                SingleToDo(title: "吃饭"),
        //                SingleToDo(title: "睡觉"),
        //                SingleToDo(title: "打豆豆"),
        //                SingleToDo(title: "做作业", isChecked: true),
        //                SingleToDo(title: "去广场", isChecked: true),
        //                SingleToDo(title: "跑步"),
        //                SingleToDo(title: "浇花",  isChecked: true),
        //
        //            ]
        //        ))
        HomeView()
    }
}
