//
//  LoginViewController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/17/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit
import Foundation

class LoginViewController: UIViewController {

    //MARK: Properties (private) which image 
    var imageVersion = 1
    
    // MARK: Properties (IBOutlet) username output
    @IBOutlet weak var usernameOutput: UILabel!
    
    // MARK: Properties (Private Static Constant) username
    private var username = "Username"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var timer = Timer.scheduledTimer(timeInterval: 1,target:self, selector: Selector("loadImage"), userInfo:nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let username = UserDefaults.standard.object(forKey: self.username) as? String
        {
            usernameOutput.text = username
            self.username = username
        }
    }
    
    func storeUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: self.username)
        UserDefaults.standard.synchronize()
        
        usernameOutput.text = username
    }
    
   
    @IBAction func loginButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Login", message: "Enter username", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "username"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        
        alertController.view.setNeedsLayout()
        alertController.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action) in
            if let username = alertController.textFields?.first?.text, !username.isEmpty {
                self.storeUsername(username)
                self.username = username
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // send player data to MenuViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToMenu" {
            
            
            
        }
    }
    
    // activate segue only if default username is changed
    @IBAction func gotoMenu(_ sender: Any) {
        if self.username != "Username" {
            
            GameService.shared.thisPlayer = Player(name: self.username, sid: "0")
            
            SocketIOManager.shared.establishConnection()
            
            GameService.shared.loggedIn = true
            
            performSegue(withIdentifier: "LoginToMenu", sender: nil)
        }
        else {
            let alertController = UIAlertController(title: "Login", message: "Please login", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: Properties (IBOutlet) login screen image
    @IBOutlet weak var loginScreen: UIImageView!
    
    func loadImage(){
        if imageVersion == 2 {
            loginScreen.image = UIImage(named:"loginLightVersion6:7+")
            imageVersion = 1
        }
        else {
            loginScreen.image = UIImage(named:"loginDarkVersion6:7+")
            imageVersion = 2
        }
    }
}

