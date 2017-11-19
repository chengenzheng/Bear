

import UIKit
import Firebase

class ChatMessage: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("chatMessage undefineKey:\(key)");
    }

}
