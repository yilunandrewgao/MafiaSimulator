//
//  CreateRoomController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class CreateRoomController: UIViewController{
    
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
            
            thisRoomName = nameOfRoom_tf.text
            maxPeopleForRoom = Int(numOfPeople_tf.text!)
            
            
            if privateSwitch.isOn {
                roomPassword = roomPassword ?? ""
                
            }
            else{
                roomPassword = ""
            }
            
            let owner = GameService.shared.thisPlayer!
            
            let newRoom = Room(playerList: [owner], roomName: thisRoomName, password: roomPassword!, maxPlayers: maxPeopleForRoom, owner: owner)
            
            
            SocketIOManager.shared.sendCreateRoomEvent(newRoom: newRoom)
            
            performSegue(withIdentifier: "GotoWaitingRoom", sender: nil)
            
        }
        else {
            let alertController = UIAlertController(title: "Invalid Inputs", message: "Please enter in valid room name and number of people.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        
    }

    func requestWasReceived(fromPlayer: Player, callback: (Bool) -> Void) {
        // Present alert controller to ask player about invitation
        // In alert action invoke the callback with true or false as appropriate
        callback(true)
    }
    
    // MARK: Properties (IBAction) help message for turns
    @IBAction func turnHelp(_ sender: Any) {
        let alertController = UIAlertController(title: "Help: Turns", message: "Each Villager has a minute to speak", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Properties (IBAction) help message for private
    
    @IBAction func privateHelp(_ sender: Any) {
        let alertController = UIAlertController(title: "Help: Private", message: "Room is password protected", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


