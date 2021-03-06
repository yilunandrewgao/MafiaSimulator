//
//  MafiaVoteController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import AudioToolbox

class MafiaVoteController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playerCount = GameService.shared.inRoom!.alivePlayerList?.count ?? 0
        return playerCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlivePlayerNightCell", for: indexPath)
        
        let alivePlayer = GameService.shared.inRoom?.alivePlayerList?[indexPath.row]
        cell.textLabel?.text = alivePlayer?.name
        let voteCountDic = GameService.shared.inRoom?.voteCountDic

        for playerVote in voteCountDic! {
            if alivePlayer?.sid == playerVote.key {
                cell.detailTextLabel?.text = String(playerVote.value)
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = GameService.shared.inRoom?.alivePlayerList?[indexPath.row]
        
        if (GameService.shared.thisPlayer.isAlive)!{
            let alertController = UIAlertController(title: "Confirm Vote", message: "You sure you want to choose this player?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                SocketIOManager.shared.votedFor(chosenPlayerSid: (selectedPlayer?.sid)!, time: "night")
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Dead", message: "Sorry, you are currently dead", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerTable.reloadData()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voteCompletion), name: .updateVoteCountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRoundCompletion), name: .updateAlivePlayersNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(killedCompletion), name: .updateKilledNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRoundCompletion), name: .whoWonNotification, object: nil)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
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
    
    func voteCompletion() {
        DispatchQueue.main.async {
            self.playerTable.reloadData()
        }
    }
    
    func killedCompletion() {
            
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
                GameService.shared.inRoom?.killedPlayer = killedPlayerName
                //get out of for loop
                break
            }
        }
        if GameService.shared.thisPlayer.sid == GameService.shared.inRoom?.owner.sid {
            SocketIOManager.shared.startRound()
        }
        
    }
    
    func startRoundCompletion() {
        
        DispatchQueue.main.async {
            //make phone vibrate to alert players in case they aren't paying attention
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if let killedplayer:String = (GameService.shared.inRoom?.killedPlayer) {
                let alertController = UIAlertController(title: "Killed", message: "\(killedplayer) was found dead.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                    if GameService.shared.inRoom?.whoWon != nil {
                        self.whoWonCompletion()
                    }
                    else {
                        self.transitionToMorning()
                    }
                    
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func whoWonCompletion(){
       
        var viewControllers = self.navigationController?.viewControllers
        
        let endGameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameOver") as! GameOverController
        
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        viewControllers?.append(endGameViewController)
        
        self.navigationController?.setViewControllers(viewControllers!, animated: false)
        
    }

    // MARK: Properties (IBOutlet) table of lists of available rooms
    @IBOutlet weak var playerTable: UITableView!
    
    
    
}
