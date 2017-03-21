//
//  VillageDayController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import AudioToolbox

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
            //send start round message
            if GameService.shared.thisPlayer.sid == GameService.shared.inRoom?.owner.sid {
                SocketIOManager.shared.startRound()
            }
            
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
            
            //make phone vibrate to alert players in case they aren't paying attention
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let alertController = UIAlertController(title: "Killed", message: "\(killedPlayerName) was found dead.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                //                self.performSegue(withIdentifier: "VoteToDaySegue", sender: nil)
                if GameService.shared.inRoom?.whoWon != nil {
                    self.whoWonCompletion()
                }
                else {
                    self.transitionToNight()
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func whoWonCompletion(){
        var viewControllers = self.navigationController?.viewControllers
        let endGameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameOver") as! GameOverController
        
        viewControllers?.removeLast()
        viewControllers?.append(endGameViewController)
        
        self.navigationController?.setViewControllers(viewControllers!, animated: false)
        
    }
    
    
}
