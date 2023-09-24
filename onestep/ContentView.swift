import SwiftUI
//首屏主视图
struct ContentView: View {
    //ObservedObject 用于修改了数据后刷新视图
    @ObservedObject var toDoList:ToDo = ToDo(initUserData()) //通过initUserData从本地读取数据
    @State var goSetting:Bool = false //是否进入设置/多选模式
    @State var multiSelectArr:[Int] = [] //编辑、多选模式下的选中的ID数组
    @State var favoriteOnly = false
    @State private var currentDate = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack{
            VStack{
                ZStack {
                    Text("今日任务")
                        .font(.system(size: 16.87))
                        .bold()
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack(spacing: 0) {
                                Image(systemName: "chevron.backward")
                                Text("主页") // 自定义返回按钮的文本
                            }
                        })
                        Spacer()
                    }
                    .padding(.leading,20)
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                ScrollView{ //可滚动视图
                    ForEach(toDoList.todolist){ item in
                        if !item.isDelete{
                            if areDatesEqualIgnoringTime(date1: item.myData, date2: currentDate) {
                                CardView(i:item.id,goSetting:$goSetting,setChecked:$multiSelectArr)
                                    .environmentObject(toDoList)
                            }
                        }
                    }
                    .padding(.bottom,100) //防止“增加按钮”挡住点击框
                }
                .padding(.top,10)
            }
            Spacer()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    AddNewCard()
                        .environmentObject(toDoList) //向子视图发送数据
                }
            }
        }
        .transition(.move(edge: .trailing))
        .navigationBarBackButtonHidden(true) // 隐藏默认的返回按钮
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(toDoList: ToDo(
            [
                SingleToDo(title: "吃饭"),
                SingleToDo(title: "睡觉"),
                SingleToDo(title: "打豆豆"),
                SingleToDo(title: "做作业", isChecked: true),
                SingleToDo(title: "去广场", isChecked: true),
                SingleToDo(title: "跑步"),
                SingleToDo(title: "浇花",  isChecked: true),
                
            ]
        ))
    }
}
