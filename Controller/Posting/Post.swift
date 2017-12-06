






import UIKit
class Post: NSObject {
    
    var id: String?
    var createBy:String?
    var timestamp: NSNumber?
    var caption: String?
    var image: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var numberOfShares: Int?
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("Post undefineKey:\(key)");
    }
}

