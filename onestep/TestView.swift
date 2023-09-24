////单个卡片
//import SwiftUI
//struct CardView:View {
//    @EnvironmentObject var userData:ToDo //EnvironmentObject协议 接收父视图提供的可观察对象的属性包装类型。
//    var i:Int //数据的ID
//    @State var showEditingPage:Bool = false
//    @Binding var goSetting:Bool //从父视图获取绑定数据
//    @Binding var setChecked:[Int] //父视图的编辑选中的ID追加
//    //定义一个时间格式化器
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //初始化日期格式
//        //formatter.dateStyle = .long
//        return formatter
//    }()
//
//    var body: some View {
//
//        HStack {//在水平线上排列其子视图。
//            Rectangle() //在包含它的视图框架内对齐的矩形形状。
//                .frame(width:6)
//                .padding(.trailing)
//                .foregroundColor(userData.todolist[i].isChecked ? .purple :.green)
//
//            //编辑模式下能显示删除按钮
//            if goSetting{
//                //删除按钮
//                Button(action: {
//                    self.userData.delete(id: i) //标记为删除状态
//                }) {
//                    Image(systemName: "trash")
//                        .imageScale(.large)
//                        .padding(.trailing)
//                }
//            }
//
//            //点击标题及空白编辑
//            Button(action: {
//                //非批量模式下有效
//                if !goSetting{
//                    showEditingPage = true //sheet为真向上拉页面
//                }
//            }) {
//                //Group将文字与留白合并为一个可点击修改的组
//                Group {
//                    VStack(alignment:.leading, spacing: 8.0){
//                        Text(userData.todolist[i].title)
//                            .font(.headline)
//                            .fontWeight(.bold)
//                            .foregroundColor(.black)
//                        Text(self.dateFormatter.string(from: userData.todolist[i].myData)) //对时间格式化后显示
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//
//                    }
//                    Spacer()
//                }
//
//            }
//            //MARK sheet里的第一个参数isPresented经常会被搞成item，这里要注意一下s
//            .sheet(isPresented: $showEditingPage, content: {
//                EditingPage(
//                    title:userData.todolist[i].title,
//                    myDate:userData.todolist[i].myData,
//                    isFavorite: userData.todolist[i].isFavorite,
//                    isChecked: userData.todolist[i].isChecked,
//                    sendNotifications: userData.todolist[i].sendNotifications,
//                    id:i
//                )
//                .environmentObject(userData)//将数据传入EditingPage页面
//            })
//
//            //单个切换收藏的图标
//            Image(systemName: userData.todolist[i].isFavorite ? "star.fill" : "star")
//                .imageScale(.large)
//                .foregroundColor(userData.todolist[i].isFavorite ? .yellow : .gray)
//                .onTapGesture {
//                    userData.todolist[i].isFavorite.toggle() //切换是否收藏
//                    userData.save()//调用保存
//                }
//
//            //卡片选择框
//            if goSetting {
//                //进入批量编辑模式
//                Image(systemName: setChecked.firstIndex(where: {$0 == i}) == nil ? "circle" : "checkmark.circle.fill")
//                    .imageScale(.large)
//                    .padding(.horizontal)
//                    .onTapGesture {
//                        if setChecked.firstIndex(where: {$0 == i}) == nil{
//                            setChecked.append(i)//没有找到就增加
//                        }else{
//                            setChecked.remove(at: i)//否则就移除
//                        }
//                    }
//
//            }else{
//                //下面是完成情况的点击监听
//                Image(systemName: self.userData.todolist[i].isChecked ? "checkmark.square.fill"  : "square")
//                    .imageScale(.large) //在视图中缩放图像
//                    .padding(.horizontal)
//                //在视图识别点击手势时执行的操作
//                    .onTapGesture {
//                        self.userData.check(i)//使用ToDo的方法修改
//                    }
//            }
//        }
//        .frame(height:90) //定义矢量的框架值
//        .background(Color.white) //背影颜色
//        .cornerRadius(6) //圆角
//        .shadow(radius: 10,x:0,y:10 ) //阴影
//        .padding(.horizontal) //填充
//        .animation(.spring()) //弹簧动画效果
//        .transition(.slide) //过度效果
//    }
//}
//






//import SwiftUI
////首屏主视图
//struct ContentView: View {
//    //ObservedObject 用于修改了数据后刷新视图(及容易与ObservableObject混淆)
//    @ObservedObject var toDoList:ToDo = ToDo(initUserData()) //通过initUserData从本地读取数据
//    @State var goSetting:Bool = false //是否进入设置/多选模式
//    @State var multiSelectArr:[Int] = [] //编辑、多选模式下的选中的ID数组
//    @State var favoriteOnly = false
//    @State private var currentDate = Date()
//    var body: some View {
//        ZStack{
//            VStack{
//                NavigationView{//导航视图 导航层次结构中一个可见路径的视图堆栈
//                    ScrollView{ //可滚动视图
//                        ForEach(toDoList.todolist){ item in
//                            if !item.isDelete{
//                                if areDatesEqualIgnoringTime(date1: item.myData, date2: currentDate) {
//                                    CardView(i:item.id,goSetting:$goSetting,setChecked:$multiSelectArr)
//                                        .environmentObject(toDoList)
//                                }
//                            }
//                        }
//                        .padding(.bottom,100) //防止“增加按钮”挡住点击框
//                    }
//                    .padding(.top) //与导航拉开距离
//                    .navigationTitle("今日任务") //页面标题
//                    //在标题右上角显示按钮
//                    .navigationBarItems(trailing:
//                                            HStack{
//                        if goSetting{//编辑模式下显示回收按钮
//                            SelecAall(multiSelectArr: $multiSelectArr) //全选
//                                .environmentObject(toDoList)//将toDoList数据传送给子视图SelecAall
//                            trashAll(multiSelectArr: $multiSelectArr,goSetting:$goSetting) //传入toDoList 调用方法，绑定$multiSelectArr 读取选中的ID
//                                .environmentObject(toDoList)//将toDoList数据传送给子视图trashAll
//                            FavoriteToggle(multiSelectArr: $multiSelectArr,goSetting:$goSetting) //传入toDoList
//                                .environmentObject(toDoList)//将toDoList数据传送给子视图trashAll
//                        }else{ //非编辑模式显示收藏按钮
//                            Favorite(favoriteOnly: $favoriteOnly) //传入绑定数据
//                        }
//                        SetButton(goSetting: $goSetting,multiSelectArr:$multiSelectArr) //将绑定的goSetting传给子视图
//                    })
//                    
//                    
//                }
//            }
//            Spacer()
//            VStack{
//                Spacer()
//                HStack{
//                    Spacer()
//                    AddNewCard()
//                        .environmentObject(toDoList) //向子视图发送数据
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true) // 隐藏默认的返回按钮
//        .navigationBarItems(leading: CustomBackButton()) // 添加自定义的返回按钮
//    }
//}
//
//
//struct CustomBackButton: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    var body: some View {
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.backward")
//            Text("主页") // 自定义返回按钮的文本
//        }
//    }
//}
//
////下面代码作用是显示右侧的实时预览
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(toDoList: ToDo(
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
//    }
//}
