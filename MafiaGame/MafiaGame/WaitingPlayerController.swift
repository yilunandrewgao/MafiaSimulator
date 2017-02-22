//
//  WaitingPlayerController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import Foundation
import UIKit

class WaitingPlayerController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HostManager.shared.playersInGame.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameCell", for: indexPath)
        
        cell.textLabel?.text = HostManager.shared.playersInGame[indexPath.row].getName()
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateRoles(for numMafia: Int, in maxPeople: Int) -> [String] {
        var roleList = []
        
    }
    
    var numMafia: Int {
        get {
            let random = sqrt(Float(HostManager.shared.maxPeople))
            return Int(random)
        }
    }
    
    @IBAction func startGame(_ sender: Any) {
        let mafiaNightController = storyboard?.instantiateViewController(withIdentifier: "MafiaNight") as? MafiaNightController
        
        self.present(mafiaNightController!, animated: true, completion: nil)
    }
  
    @IBOutlet weak var playerTable: UITableView!
}
