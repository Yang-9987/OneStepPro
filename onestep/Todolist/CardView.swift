//单个卡片
import SwiftUI
struct CardView:View {
    @EnvironmentObject var userData:ToDo //EnvironmentObject协议 接收父视图提供的可观察对象的属性包装类型。
    var i:Int //数据的ID
    @State var showEditingPage:Bool = false
    @Binding var goSetting:Bool //从父视图获取绑定数据
    @Binding var setChecked:[Int] //父视图的编辑选中的ID追加
    //定义一个时间格式化器
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //初始化日期格式
        //formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        HStack {
            HStack {//在水平线上排列其子视图。
                //编辑模式下能显示删除按钮
                if goSetting{
                    //删除按钮
                    Button(action: {
                        self.userData.delete(id: i) //标记为删除状态
                    }) {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                }else {
                    Image("pet")
                        .resizable()
                        .frame(width: 55,height:55)
                }
                VStack(alignment:.leading, spacing: 8.0){
                    Text(userData.todolist[i].title)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                //点击标题及空白编辑
                Button(action: {
                    //非批量模式下有效
                    if !goSetting{
                        showEditingPage = true //sheet为真向上拉页面
                    }
                }) {
                    Group {
                        Spacer()
                        Image("detail")
                            .resizable()
                            .frame(width: 42,height: 42)
                        
                    }
                    
                }
                .sheet(isPresented: $showEditingPage, content: {
                    EditingPage(
                        title:userData.todolist[i].title,
                        myDate:userData.todolist[i].myData,
                        isFavorite: userData.todolist[i].isFavorite,
                        isChecked: userData.todolist[i].isChecked,
                        sendNotifications: userData.todolist[i].sendNotifications,
                        id:i
                    )
                    .environmentObject(userData)//将数据传入EditingPage页面
                })
            }
            .padding(10)
        }
        .frame(width: 345,height:90)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10,x:0,y:10 )
        .padding(.horizontal)
        .animation(.spring())
        .transition(.slide)
    }
}

