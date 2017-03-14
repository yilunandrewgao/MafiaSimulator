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
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateRoomController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(performSegueToWaitingRoom), name: .updateRoomNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performSegueToWaitingRoom() {
        performSegue(withIdentifier: "GotoWaitingRoom", sender: nil)
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
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    // MARK: Properties (IBOutlet) private room: true/false
    @IBOutlet weak var privateSwitch: UISwitch!
    
    @IBAction func createRoom(_ sender: Any) {
        var sameRoomName = false
       
        let roomList = GameService.shared.roomList ?? []
        
        for room in roomList{
            if room.roomName == nameOfRoom_tf.text!{
                sameRoomName = true
                
                let alertController = UIAlertController(title: "Room Name", message: "Same room name, please change the name.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            }
        }
        
        if Int(numOfPeople_tf.text!) != nil && String(nameOfRoom_tf.text!) != nil && sameRoomName == false{
            
            
            
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
            
            
            
        }
        else {
            let alertController = UIAlertController(title: "Invalid Inputs", message: "Please enter in valid room name and number of people.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        
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


