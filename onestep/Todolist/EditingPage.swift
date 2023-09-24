//编辑事项页
import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var userData:ToDo //接收上层页面传输过来的数据
    @State var title:String = "" //默认的标题为空
    @State var myDate:Date = Date()//默认时间为当前时间 + 60秒
    @State var showAlert:Bool = false //是否显示警告
    @State var isFavorite:Bool = false //默认为不收藏
    @State var isChecked:Bool = false //是否已完成(编辑后不改变其状态，新增默认为否)
    @State var sendNotifications:Bool = true //是否发送通知
    @Environment(\.presentationMode) var presentation //定义一个从视图环境读取值的属性包装器。presentationMode绑定到与此环境关联的视图的当前表示模式。
    
    @State var alertMessage = ""
    var id:Int? = nil //定义一个接收ID
    var body: some View {
        NavigationView{
            Form{ //表单视图、用于对用于数据输入的控件进行分组，例如在设置或检查器中。
                Section{//创建层次化视图内容。
                    TextField("输入事项", text: $title)//显示可编辑文本界面的控件。
                        .frame(height: 60)//增高一点
                    Toggle(isOn: $isFavorite) {
                        Text("收藏此事项")
                    }
                    Toggle(isOn: $sendNotifications) {
                        Text("发送通知")
                    }
                }
                Section{//创建层次化视图内容。
                    //用于选择绝对日期的控件。
                    Text("请选择一个截至时间：")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    DatePicker(
                        "时间：",
                        selection: $myDate,
                        in: Date().addingTimeInterval(60.0)... //限制时间范围为最少60秒后
                    )
                    .datePickerStyle(GraphicalDatePickerStyle()) //日期样式
                    .labelsHidden() //隐藏“时间”label,部分样子会自动把label的文字隐藏
                }
                Section{
                    Button(action: {
                        if title.count < 1{
                            showAlert = true //显示警告
                            alertMessage = "请输入一个事项~"
                        }else{
                            if self.myDate.timeIntervalSinceNow < 0{
                                showAlert = true //显示警告
                                alertMessage = "请修改一个大于当前时间的“提醒时间”~"
                            }else{
                                print("传入的时间：" + self.myDate.description)
                                if let hasID = id{
                                    userData.edit(id: hasID, data: SingleToDo(title: self.title,myData:self.myDate,isChecked:self.isChecked, isFavorite: self.isFavorite, sendNotifications: self.sendNotifications)) //编辑
                                }else{
                                    userData.add(SingleToDo(title: self.title,myData:self.myDate,isChecked:false, isFavorite: self.isFavorite, sendNotifications: self.sendNotifications))//新增
                                }
                                presentation.wrappedValue.dismiss()//关闭当前页面
                            }
                        }
                    }) {
                        Text("确定")
                    }
                    //弹出一个警告
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("提示信息"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    Button(action: {
                        presentation.wrappedValue.dismiss()//关闭当前页面(如果视图是当前显示的，则解散视图)
                    }) {
                        Text("取消")
                    }
                }
            }
            .navigationTitle(id == nil ? "增加一个事项" : "编辑一个事项")
        }
        
    }
}










struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}

