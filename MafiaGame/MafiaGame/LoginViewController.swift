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
    
    // MARK: Properties (Private) username
    private(set) var username = "Username"

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
        NotificationCenter.default.addObserver(self, selector: #selector(LoginToMenu), name: .connectedToServerNotification, object: nil)
    }
    
    func storeUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: self.username)
        UserDefaults.standard.synchronize()
        
        //PlayerService.shared.nameSet(for: username)
        
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
    
    func timeoutHandler() {
        let alertController = UIAlertController(title: "Cannot Connect", message: "Please check your network settings", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func LoginToMenu(){
        GameService.shared.loggedIn = true
        
        performSegue(withIdentifier: "LoginToMenu", sender: nil)
    }
    
    // activate segue only if default username is changed
    @IBAction func gotoMenu(_ sender: Any) {
        if self.username != "Username" {
            
            GameService.shared.thisPlayer = Player(name: self.username, sid: "0")
            
            SocketIOManager.shared.establishConnection(timeOutHandler: timeoutHandler)
            
        }
        else {
            
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

