//
//  VillagerVoteController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class VillagerVoteController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        viewControllers?.removeLast()
        viewControllers?.append(nightViewController)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlivePlayerDayCell", for: indexPath)
        
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
        
        if (GameService.shared.thisPlayer.isAlive)! {
            let alertController = UIAlertController(title: "Confirm Vote", message: "You sure you want to choose this player?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                SocketIOManager.shared.votedFor(chosenPlayerSid: (selectedPlayer?.sid)!, time: "day")
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Dead", message: "Sorry, you are currently dead", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if GameService.shared.inRoom?.whoWon != nil {
            self.whoWonCompletion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GameService.shared.inRoom?.whoWon != nil {
            self.whoWonCompletion()
        }
        
        playerTable.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voteCompletion), name: .updateVoteCountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(killedCompletion), name: .updateKilledNotification, object: nil)
        
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
        DispatchQueue.main.async {
            //send start round message
            SocketIOManager.shared.startRound()
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
                if GameService.shared.inRoom?.whoWon != nil {
                    self.whoWonCompletion()
                }
                else{
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
        viewControllers?.removeLast()
        viewControllers?.append(endGameViewController)
        
        self.navigationController?.setViewControllers(viewControllers!, animated: false)
        
    }
    
    
    @IBOutlet weak var playerTable: UITableView!
}
