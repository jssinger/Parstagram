//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Jonathan Singer on 8/3/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var feed = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                for post in self.posts {
                    self.feed.insert(post, at: 0)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = feed[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        cell.captionLabel.text = (post["caption"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }

    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    

}
