//  数据结构
import Foundation
struct SingleToDo:Identifiable,Codable {
    var id:Int = 0
    var title:String
    var myData:Date = Date()
    var isChecked:Bool = false{
        willSet{
            print(id,newValue)//打印改变
        }
    }
    var isDelete = false //删除标志
    var isFavorite:Bool = false //是否收藏
    var sendNotifications:Bool = true //默认发送通知
}
