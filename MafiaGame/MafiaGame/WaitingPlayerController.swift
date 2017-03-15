//
//  WaitingPlayerController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import Foundation
import UIKit

class WaitingPlayerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let thisPlayer = GameService.shared.thisPlayer.sid
    let roomOwnerSid = GameService.shared.inRoom?.owner.sid
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (GameService.shared.inRoom?.playerList.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell", for: indexPath)
        
        cell.textLabel?.text = GameService.shared.inRoom?.playerList[indexPath.row].name
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if thisPlayer == roomOwnerSid{
            ownerDeleteButton.isEnabled = true
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerTable), name: .updateRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updatePlayerTable() {
        DispatchQueue.main.async {
            self.playerTable.reloadData()
        }
    }
    
    func quitRoomCompletion() {
        DispatchQueue.main.async {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func startGame(_ sender: Any) {
        
        SocketIOManager.shared.startGame()

        let isVillager = true
        if isVillager {
            performSegue(withIdentifier: "MafiaNightSegue", sender: self)
        }
        else {
            performSegue(withIdentifier: "VillagerNightSegue", sender: self)
        }
    }
    
    @IBAction func quitRoom(_ sender: Any) {
        SocketIOManager.shared.sendUserExitRoomEvent()
    }
  
    @IBAction func ownerDeleteRoom(_ sender: Any) {
        
        SocketIOManager.shared.deleteRoomEvent()
            
    }
   
    @IBOutlet weak var playerTable: UITableView!
    @IBOutlet weak var ownerDeleteButton: UIButton!
}
