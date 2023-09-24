
import SwiftUI
//右下角的增加按钮
struct AddNewCard:View {
    @State var showEditingPage:Bool = false//是否显示编辑页面
    @EnvironmentObject var toDoList:ToDo //接收父视图传过来的数据
    var buttonSize:CGFloat = 48.0 //定义按钮尺寸
    var body: some View{
        Button(action: {
            showEditingPage = true //显示编辑页面
        }) {
            ZStack {
                Circle()
                    .foregroundColor(Color("add"))
                    .frame(width: 48,height: 48)
                Image(systemName: "plus")
                    .foregroundColor(Color.white)
            }
            .padding(10)
        }
        
        .sheet(isPresented: $showEditingPage, content: {
            EditingPage()
                .environmentObject(toDoList)
        })
    }
}
//设置及多选按钮
struct SetButton:View {
    @Binding var goSetting:Bool //与父视图的数据绑定
    @Binding var multiSelectArr:[Int]
    var body: some View{
        Button(action: {
            goSetting.toggle()//切换编辑模式
            print("切换编辑模式:(goSetting)")
        }) {
            Image(systemName: "gear")
                .imageScale(.large)
        }
    }
}

//批量删除按钮
struct trashAll:View {
    @EnvironmentObject var toDoList:ToDo //需要从父视图接收调用删除方法（ .environmentObject）
    @Binding var multiSelectArr:[Int] //从父视图接收
    @State var showAlert = false //弹出开关
    @Binding var goSetting:Bool
    var body:some View{
        Button(action: {
            if multiSelectArr.isEmpty{
                showAlert = true
            }else{
                for i in multiSelectArr{
                    toDoList.delete(id: i) //循环删除ID
                    print("删除ID:(i)")
                }
                multiSelectArr.removeAll() //清空已选择
                goSetting = false //关闭批量模式
            }
        }) {
            Image(systemName: "trash")
                .imageScale(.large)
        }
        //弹出一个提示
        .alert(isPresented: $showAlert){
            Alert(title: Text("提示："), message: Text("请选择您要指删除的事项~"), dismissButton: .default(Text("OK")))
        }
    }
}
//只显示收藏事项的按钮
struct Favorite:View {
    @Binding var favoriteOnly:Bool
    var body: some View{
        Button(action: {
            favoriteOnly.toggle() //切换显示收藏
            print("只显示收藏事项")
            
        }) {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}
//收藏取反按钮
struct FavoriteToggle:View {
    @EnvironmentObject var toDoList:ToDo //需要从父视图接收要处理的数据
    @Binding var multiSelectArr:[Int] //从父视图接收
    @State var showAlert = false //弹出开关
    @Binding var goSetting:Bool
    var body: some View{
        Image(systemName: "star.leadinghalf.fill")
            .imageScale(.large)
            .foregroundColor(.yellow)
            .onTapGesture {
                if multiSelectArr.isEmpty{
                    showAlert = true
                }else{
                    for i in multiSelectArr{
                        toDoList.todolist[i].isFavorite.toggle() //切换选中项的收藏状态
                    }
                    multiSelectArr.removeAll() //清空已选择，单个删除容易 Index out of range
                    goSetting = false //关闭批量模式
                }
            }
            //弹出一个提示
            .alert(isPresented: $showAlert){
                Alert(title: Text("提示："), message: Text("请选择您要反转收藏的事项~"), dismissButton: .default(Text("OK")))
            }
    }
}

//全选按钮
struct SelecAall:View {
    @EnvironmentObject var toDoList:ToDo //需要从父视图接收要处理的数据
    @Binding var multiSelectArr:[Int] //父视图的编辑选中的ID追加
    @State var allChecked = false
    var body: some View{
        Image(systemName: allChecked ? "circlebadge.2.fill" :"circlebadge.2")
            .imageScale(.large)
            .foregroundColor(.green)
            .onTapGesture{
            allChecked.toggle()//切换选择状态
                if allChecked{
                    for item in toDoList.todolist{
                        multiSelectArr.append(item.id)
                    }
                }else{
                    multiSelectArr.removeAll()
                }
        }
    }
}
