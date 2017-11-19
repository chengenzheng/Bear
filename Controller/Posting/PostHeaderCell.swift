import UIKit
import Firebase

class PostHeaderCell: UITableViewCell
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        
//        profileImageView.image = post.createBy.profileImage
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
//        usernameLabel.text = post.createdBy.username
        
        followButton.layer.borderWidth = 1.0
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
        
        
        let userID = post.createBy
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? "noName"
            if let profileImgUrl = value?["profileImageURL"] as? String{ self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImgUrl)
            }
            
            self.usernameLabel.text = username
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}











