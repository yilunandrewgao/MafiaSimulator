//
//  VillagerNightController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/21/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class VillagerNightController: UIViewController {
    
    func transitionToMorning() {
        GameService.shared.inRoom?.killedPlayerSid = nil
        var viewControllers = navigationController?.viewControllers
        
        let dayViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DayChat") as! VillagerDayController
        // remove last view controller twice
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        viewControllers?.append(dayViewController)
        
        navigationController?.setViewControllers(viewControllers!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateVoteCountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateKilledNotification, object: nil)
    }
    
    func pass() {
        
    }
    
    func quitRoomCompletion() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToMenu", sender: nil)
        }
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
               
                self.transitionToMorning()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
}

