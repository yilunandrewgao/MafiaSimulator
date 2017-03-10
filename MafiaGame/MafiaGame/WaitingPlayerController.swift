//
//  WaitingPlayerController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import Foundation
import UIKit

class WaitingPlayerController: UIViewController {
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return HostManager.shared.room.currentPlayers.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell", for: indexPath)
//        
//        cell.textLabel?.text = HostManager.shared.room.currentPlayers[indexPath.row].getName()
//        return cell
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //generate the roles that should be assigned to players in one particular session
    func generateRoles(for numMafia: Int, in maxPeople: Int) -> [String] {
        //because numMafia and maxPeople are constants
        var numM = numMafia
        var maxP = maxPeople
        
        //empty array for players
        var roleList : [String] = []
        while maxPeople > 0 {
            
            if numMafia > 0 {
                roleList.append("mafia")
                numM -= 1
            }
            
            maxP -= 1
        }
        
        return roleList
        
        
    }
    
//    //number of mafia a particular session should contain
//    func numMafia() -> Int {
//        
//        let mafia = sqrt(Float(HostManager.shared.room.maxPlayers))
//        return Int(mafia)
//        
//    }
    
    @IBAction func startGame(_ sender: Any) {
//        let mafiaNightController = storyboard?.instantiateViewController(withIdentifier: "MafiaNight") as? MafiaNightController
//        
//        self.present(mafiaNightController!, animated: true, completion: nil)
    }
  
    @IBOutlet weak var playerTable: UITableView!
}
