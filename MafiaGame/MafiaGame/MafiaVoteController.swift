//
//  MafiaVoteController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class MafiaVoteController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playerCount = GameService.shared.inRoom?.alivePlayerList.count ?? 0
        print(playerCount)
        return playerCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlivePlayerCell", for: indexPath)
        
        let alivePlayer = GameService.shared.inRoom?.alivePlayerList[indexPath.row]
        cell.textLabel?.text = alivePlayer?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = GameService.shared.inRoom?.alivePlayerList[indexPath.row]
        
//        let alertController = UIAlertController(title: "Help: Private", message: "Room is password protected", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "Confirm Vote", message: "You sure you want to choose this player?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Properties (IBOutlet) table of lists of available rooms
    @IBOutlet weak var playerTable: UITableView!
}