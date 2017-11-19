

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageURL: String?
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("User undefineKey:\(key)");
    }
}
