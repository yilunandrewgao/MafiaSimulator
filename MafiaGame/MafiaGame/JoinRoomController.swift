//
//  JoinRoomController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class JoinRoomController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var thisPlayer:Player! = nil
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let roomCount = GameService.shared.roomList.count
        print(roomCount)
        return roomCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)

        let simpleRoom = GameService.shared.roomList[indexPath.row]
        cell.textLabel?.text = simpleRoom.roomName
        cell.detailTextLabel?.text = "\(simpleRoom.owner): \(simpleRoom.numPlayers)/\(simpleRoom.maxPlayers)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = GameService.shared.roomList[indexPath.row]
        let alertController = UIAlertController(title: "Password", message: "Enter Password", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "password"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        alertController.view.setNeedsLayout()
        alertController.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action) in
            let enteredPassword = alertController.textFields?.first?.text ?? ""
            
            print(enteredPassword)
            print(selectedRoom.password)
            
            if enteredPassword == selectedRoom.password {
                
                SocketIOManager.shared.sendJoinRoomEvent(roomToJoin: selectedRoom, completionHandler: { (roomJSON) -> Void in
                    DispatchQueue.main.async { () -> Void in
                        GameService.shared.inRoom = try! Room(json: roomJSON)
                        self.performSegue(withIdentifier: "JoinRoomToWaitingRoom", sender: nil)
                    }
                    
                })
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func foundRoom() {
        
        DispatchQueue.main.async {
            self.roomTable.reloadData()
        }
        
        
    }
    
    func lostRoom() {
        DispatchQueue.main.async{
            self.roomTable.reloadData()
        }
        
    }
    
    // MARK: Properties (IBOutlet) table of lists of available rooms
    @IBOutlet weak var roomTable: UITableView!
    
    
    
}
