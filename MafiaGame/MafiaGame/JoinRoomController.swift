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
        return ClientManager.shared.foundRooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        
        cell.textLabel?.text = ClientManager.shared.foundRooms[indexPath.row]
        cell.detailTextLabel?.text = "Status"
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ClientManager.shared.startBrowsing(player: thisPlayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ClientManager delegate functions
    
    func foundPeer() {
        
        roomTable.reloadData()
        
    }
    
    func lostPeer() {
        roomTable.reloadData()
    }
    
    // MARK: Properties (IBOutlet) table of lists of available rooms
    @IBOutlet weak var roomTable: UITableView!
    
    
    
}
