//
//  CreateRoomController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class CreateRoomController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // MARK: Properties (IBAction) set password for room
    @IBAction func setPassword(_ sender: Any) {
        if privateSwitch.isOn {
            
        }
        
        let alertController = UIAlertController(title: "Set Password", message: "Enter Room Password", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "password"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Properties (IBOutlet) private room: true/false
    @IBOutlet weak var privateSwitch: UISwitch!
    
    
}


