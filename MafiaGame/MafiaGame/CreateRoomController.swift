//
//  CreateRoomController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class CreateRoomController: UIViewController {
    
    var thisPlayer:Player! = nil
    var thisRoomName: String!
    var maxPeopleForRoom: Int!
    var roomPassword: String?
    
    @IBOutlet weak var nameOfRoom_tf: UITextField!
    
    @IBOutlet weak var numOfPeople_tf: UITextField!
    
    
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
            let alertController = UIAlertController(title: "Set Password", message: "Enter Room Password", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "password"
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action) in
                if let password = alertController.textFields?.first?.text {
                    self.roomPassword = password
                }
            }))
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    // MARK: Properties (IBOutlet) private room: true/false
    @IBOutlet weak var privateSwitch: UISwitch!
    
    @IBAction func createRoom(_ sender: Any) {
        
        // if all conditions are met, initialize the HostManager and start advertising
        
        if Int(numOfPeople_tf.text!) != nil && String(nameOfRoom_tf.text!) != nil {
            
            if privateSwitch.isOn {
                HostManager.initHostManager(player: thisPlayer, roomName: thisRoomName, maxPeople: maxPeopleForRoom, password: roomPassword!)
            }
            else{
                HostManager.initHostManager(player: thisPlayer, roomName: thisRoomName, maxPeople: maxPeopleForRoom, password: nil)
            }
            
            HostManager.shared.advertiser.startAdvertisingPeer()
            
        }
        
        
    }
    
}


