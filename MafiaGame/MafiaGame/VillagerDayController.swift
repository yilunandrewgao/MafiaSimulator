//
//  VillageDayController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class VillagerDayController: UIViewController {
    
    func transitionToNight() {
        GameService.shared.inRoom?.killedPlayerSid = nil
        var viewControllers = navigationController?.viewControllers
        
        var nightViewController : UIViewController!
        
        if GameService.shared.thisPlayer.role == "mafia" {
            nightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MafiaNight") as! MafiaNightController
        }
        else{
            nightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VillagerNight") as! VillagerNightController
        }
        
        viewControllers?.removeLast()
        viewControllers?.append(nightViewController)
        
        navigationController?.setViewControllers(viewControllers!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateVoteCountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(killedCompletion), name: .updateKilledNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateAlivePlayersNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func quitRoomCompletion() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToMenu", sender: nil)
        }
    }
    
    func pass() {
        
    }

    func killedCompletion() {
        DispatchQueue.main.async {
            //create variable for killed player
            var killedPlayerName : String = "player name"
            //get killed player sid (which was sent from the server)
            let killedPlayerSid = GameService.shared.inRoom?.killedPlayerSid
            //get inRoom playerList
            let playerList = GameService.shared.inRoom?.playerList ?? []
            for player in playerList {
                //match killed player and player in playerList sid
                if player.sid == killedPlayerSid {
                    killedPlayerName = player.name
                    //get out of for loop
                    break
                }
            }
            let alertController = UIAlertController(title: "Killed", message: "\(killedPlayerName) was found dead.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                //                self.performSegue(withIdentifier: "VoteToDaySegue", sender: nil)
                self.transitionToNight()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
