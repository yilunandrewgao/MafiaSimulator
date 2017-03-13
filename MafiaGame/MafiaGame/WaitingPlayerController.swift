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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayerTable), name: .updateRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
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
            let MenuVC = self.storyboard?.instantiateViewController(withIdentifier: "JoinOrCreateRoomMenu") as? MenuViewController
            self.present(MenuVC!, animated: true, completion: nil)
        }
    }
    
    @IBAction func startGame(_ sender: Any) {
        let mafiaNightController = storyboard?.instantiateViewController(withIdentifier: "MafiaNight") as? MafiaNightController
        
        self.present(mafiaNightController!, animated: true, completion: nil)
    }
    
    @IBAction func quitRoom(_ sender: Any) {
        SocketIOManager.shared.sendUserExitRoomEvent()
    }
  
    @IBOutlet weak var playerTable: UITableView!
}
