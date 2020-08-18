//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Jonathan Singer on 8/3/20.
//  Copyright © 2020 Jonathan Singer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let userName = userNameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                self.userNameField.text = ""
                self.passwordField.text = ""
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
                let alert = UIAlertController(title: "Error", message: "Incorrect Password", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.passwordField.text = ""
            }
        }
    }
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.userNameField.text = ""
                self.passwordField.text = ""
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
                let alert = UIAlertController(title: "Account already exists for this username", message: "Please pick a new username", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.userNameField.text = ""
                self.passwordField.text = ""
            }
        }
    }
    
     @IBAction func unwindToLogin(_ sender: UIStoryboardSegue){}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
