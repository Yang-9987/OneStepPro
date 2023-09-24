// 数据操作
import Foundation
import UserNotifications //导入通知框架
var enCoder = JSONEncoder() //编码为JSON格式
var deCoder = JSONDecoder() //将Json解码回来

//ObservableObject协议需要符合可观察的对象、该发布者在对象更改之前发出。接受方使用@ObservedObject单词不一样！！！
class ToDo: ObservableObject {
    @Published var todolist:[SingleToDo]//Published发布带有属性的属性。
    var count = 0
    init(_ data:[SingleToDo]) {
        self.todolist = []
        for item in data{
            self.todolist.append(SingleToDo(id: count, title: item.title, myData: item.myData, isChecked: item.isChecked, isFavorite: item.isFavorite, sendNotifications: item.sendNotifications))
            count += 1
        }
    }
    //修改事项状态
    func check(_ i:Int) {
        self.todolist[i].isChecked.toggle()
        self.save()//保存到数据
    }
    //增加一个事项
    func add(_ data:SingleToDo)  {
        self.todolist.append(SingleToDo(id: count, title: data.title, myData: data.myData, isChecked: data.isChecked, isFavorite: data.isFavorite, sendNotifications: data.sendNotifications))
        count += 1
        self.sort()//排序
        self.save()//保存到数据
        //数据需要保存后才能发布通知
        if data.sendNotifications{
            if sendNoNotification(count - 1){
                print("新增发送通知成功")
            }
        }
    }
    //编辑一个事项
    func edit(id:Int,data:SingleToDo) {
        WithdrawalNoNotification(self.todolist[id].id)//编辑前撤回消息
        self.todolist[id].title = data.title
        self.todolist[id].myData = data.myData
        self.todolist[id].isChecked = data.isChecked //完成状态
        self.todolist[id].isFavorite = data.isFavorite //收藏状态
        self.todolist[id].sendNotifications = data.sendNotifications //发送通知开关
        self.sort()//排序
        self.save()//保存到数据
        //数据需要保存后才能发布通知
        if data.sendNotifications{
            if sendNoNotification(self.todolist[id].id){
                print("编辑发送通知成功")
            }
        }
    }
    //对事项按时间排序
    func sort() {
        self.todolist.sort(by:{$0.myData.timeIntervalSince1970 > $1.myData.timeIntervalSince1970})
        for i in 0 ..< self.todolist.count{
            self.todolist[i].id = i
        }
        print("改了排序")
    }
    
    //增加一个删除标志
    func delete(id:Int)  {
        WithdrawalNoNotification(id) //撤回消息
        self.todolist[id].isDelete = true
        print("删除了")
        self.sort()
        self.save()//保存u数据
    }
    //将数据编码后保存到本机
    func save() {
        let dataStored = try! enCoder.encode(todolist) //encode是可能抛出错误的，使用try!强制忽略错误
        UserDefaults.standard.set(dataStored, forKey: "myTests") //将编码为JSON格式的数据存到Key= myTest_文件里
        print("保存成功")//打印日志
    }
    //发送通知
    func sendNoNotification(_ id:Int) -> Bool{
        var isOk = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success && self.todolist[id].myData.timeIntervalSinceNow > 10{ //推送时间大于10秒才发送通知
                print("(self.todolist[id].myData.timeIntervalSinceNow)秒后将发送通知：" + self.todolist[id].title)
                isOk = true
                let content = UNMutableNotificationContent()//定义通知内容格式
                content.title = self.todolist[id].title
                content.subtitle = "这是副标题"
                content.sound = UNNotificationSound.default //提示音
                //触发时间
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.todolist[id].myData.timeIntervalSinceNow , repeats: false)
                //触发器
                let request = UNNotificationRequest(identifier: self.todolist[id].title + self.todolist[id].myData.description , content: content, trigger: trigger)
                //添加通知请求
                UNUserNotificationCenter.current().add(request)
            } else if let error = error {
                print(error.localizedDescription)//用户可能关闭了通知
            }else{
                print("通知发送失败，可能时间不对："+self.todolist[id].myData.description,self.todolist[id].myData.timeIntervalSinceNow)
            }
        }
        return isOk
    }
    
    //撤回一条通知
    func WithdrawalNoNotification(_ id:Int){
        let identifier:String = self.todolist[id].title + self.todolist[id].myData.description
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])//撤回已发出的消息
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])//撤回还没有发出的消息
        print("尝试撤回一条消息",id)
    }
}
