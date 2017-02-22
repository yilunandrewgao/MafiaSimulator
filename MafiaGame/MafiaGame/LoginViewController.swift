//
//  LoginViewController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/17/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties (IBOutlet) username output
    @IBOutlet weak var usernameOutput: UILabel!
    
    // MARK: Properties (Private Static Constant) username
    private var username = "Username"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let username = UserDefaults.standard.object(forKey: self.username) as? String
        {
            usernameOutput.text = username
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
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

