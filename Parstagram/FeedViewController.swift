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
    var currentUser = PFUser.current()
    
    
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
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onUserNameClick(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.userNameButton.setTitle(user.username, for: .normal)
        cell.captionLabel.text = (post["caption"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToProfile" {
            let destVC = segue.destination as! ProfilesViewController
            destVC.currentUser = (currentUser?.username!)!
            destVC.followButton.title = ""
        }
        if segue.identifier == "segueToOtherProfile" {
            let destVC = segue.destination as! ProfilesViewController
            let button = sender as! UIButton
            let username = button.title(for: .normal)
            destVC.currentUser = username ?? ""
        }
    }
    

}
