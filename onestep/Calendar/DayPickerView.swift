//
//  DayPickerView.swift
//  onestep
//
//  Created by admin on 2023/9/9.
//

import SwiftUI
//判定日期与选中日期是否相同
func areDatesEqualIgnoringTime(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
    
    return components1.year == components2.year &&
    components1.month == components2.month &&
    components1.day == components2.day
}
func formatDateWithWeekday1(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: date)
}
func formatDateWithWeekday2(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter.string(from: date)
}

struct DayPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    let calendar = Calendar.current
    @ObservedObject var toDoList:ToDo = ToDo(initUserData())
    @State private var selectedDate = Date()
    @State var goSetting:Bool = false //是否进入设置/多选模式
    @State var multiSelectArr:[Int] = [] //编辑、多选模式下的选中的ID数组
    @State var favoriteOnly = false
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("返回首页")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                })
                VStack {
                    DatePicker("日期选择", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .accentColor(Color("picked"))
                        .environment(\.locale, .init(identifier: "zh_CN"))
                }
                HStack(spacing: 40) {
                    VStack {
                        Text(formatDateWithWeekday1(date: selectedDate))
                            .font(.system(size: 28))
                        Text(formatDateWithWeekday2(date: selectedDate))
                            .font(.system(size: 11))
                    }
                    VStack(alignment: .leading,spacing: 15) {
                        Text("今天")
                            .font(.system(size: 16))
                        Text("2个计划三个任务")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.leading,20)
                ScrollView{
                    ForEach(toDoList.todolist){ item in
                        if !item.isDelete{
                            if areDatesEqualIgnoringTime(date1: item.myData, date2: selectedDate) {
                                CardView(i:item.id,goSetting:$goSetting,setChecked:$multiSelectArr)
                                    .environmentObject(toDoList)
                            }
                        }
                    }
                }
                
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddNewCard() //右下角增加按钮
                        .environmentObject(toDoList) //向子视图发送数据
                }
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct DayPickerView_Previews: PreviewProvider {
    static var previews: some View {
//        DayPickerView(toDoList: ToDo(
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
        DayPickerView()
    }
}
