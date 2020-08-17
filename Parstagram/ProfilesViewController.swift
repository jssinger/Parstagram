//
//  ProfilesViewController.swift
//  Parstagram
//
//  Created by Jonathan Singer on 8/4/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followButton: UIBarButtonItem!
    
    var posts = [PFObject]()
    var currentUser = ""
    var user = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = currentUser
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userQuery = PFUser.query()
        userQuery?.whereKey("username", equalTo: currentUser)
        do {
            user = try userQuery?.findObjects() as! [PFObject]
        } catch {
            print("Nope")
        }
        
        let query = PFQuery(className:"Posts")
        query.whereKey("author", equalTo: user[0])
        query.includeKey("author")
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        cell.captionLabel.text = (post["caption"] as! String)
        //self.title = user.username
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    
}
