

import UIKit
import Firebase

class NewsfeedTableViewController: UITableViewController
{
    var posts = [Post]()
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postHeaderCell = "PostHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchPosts()
        
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
    }
    
    func fetchPosts()
    {
//        self.posts = Post.fetchPosts()
//        self.tableView.reloadData()
        
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let post = Post()
                
                post.timestamp = dictionary["timestamp"] as? NSNumber
                post.createBy = dictionary["createBy"] as? String
                post.caption = dictionary["caption"] as? String
                post.image = dictionary["image"] as? String
                post.numberOfLikes = dictionary["numberOfLikes"] as? Int
                post.numberOfShares = dictionary["numberOfLikes"] as? Int
                post.numberOfComments = dictionary["numberOfLikes"] as? Int
                
                self.posts.append(post)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
}

extension NewsfeedTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        
//        if posts {
            return posts.count
//        }
//
//        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        if let postarray = posts {
//            return 1
//        } else {
//            return 0
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as! PostCell
        
        cell.post = self.posts[indexPath.section]
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postHeaderCell) as! PostHeaderCell
        
        cell.post = self.posts[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
    
    
}
















