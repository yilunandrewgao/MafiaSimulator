//
//  JoinRoomController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class JoinRoomController: UIViewController, UITableViewDataSource, UITableViewDelegate, ClientManagerDelegate {
    
    var thisPlayer:Player! = nil
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let roomCount = ClientManager.shared.foundRooms.count
        print(roomCount)
        return roomCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)

        let room = ClientManager.shared.foundRooms[indexPath.row]
        cell.textLabel?.text = room.roomName
        cell.detailTextLabel?.text = "\(room.owner): \(room.currentPlayers.count)/\(room.maxPlayers)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = ClientManager.shared.foundRooms[indexPath.row]
        let alertController = UIAlertController(title: "Password", message: "Enter Password", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "password"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        alertController.view.setNeedsLayout()
        alertController.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action) in
            let enteredPassword = alertController.textFields?.first?.text ?? ""
            
            if enteredPassword == selectedRoom.password {
                ClientManager.shared.browser?.invitePeer(HostManager.shared.room.owner.getPeerID(), to: ClientManager.shared.session, withContext: nil, timeout: 0)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ClientManager.shared.startBrowsing(player: thisPlayer)
        
        // set delegate
        ClientManager.shared.clientDelegate = self
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ClientManager delegate functions
    
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
