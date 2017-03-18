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
            ownerStartButton.isEnabled = true
            
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerTable), name: .updateRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startGameCompletion), name: .gameStartedNotification, object: nil)
        
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
    
    func startGameCompletion(){
        DispatchQueue.main.async {
            let playerRole = GameService.shared.thisPlayer.role
            if playerRole == "mafia" {
                self.performSegue(withIdentifier: "MafiaNightSegue", sender: self)
            }
            else {
                self.performSegue(withIdentifier: "VillagerNightSegue", sender: self)
            }
        }
    }
    
    @IBAction func startGame(_ sender: Any) {
        
        SocketIOManager.shared.startGame()
        SocketIOManager.shared.startRound()

    }
    
    @IBAction func quitRoom(_ sender: Any) {
        SocketIOManager.shared.sendUserExitRoomEvent()
    }
  
    @IBAction func ownerDeleteRoom(_ sender: Any) {
        
        SocketIOManager.shared.deleteRoomEvent()
            
    }
   
    // MARK: Properties (IBOutlet) joined player list
    @IBOutlet weak var playerTable: UITableView!
    // MARK: Properties (IBOutlet) delete room
    @IBOutlet weak var ownerDeleteButton: UIButton!
    // MARK: Properties (IBOutlet) start game
    @IBOutlet weak var ownerStartButton: UIButton!
}
