//
//  VillageDayController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/14/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import AudioToolbox

class VillagerDayController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var chatTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameService.shared.inRoom?.chatHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! customChatCell
        
        cell.nameLbl.text = GameService.shared.inRoom?.chatHistory?[indexPath.row]["player"]
        cell.messageLbl.text = GameService.shared.inRoom?.chatHistory?[indexPath.row]["message"]
        
        
        //right align if it's you
        if GameService.shared.inRoom?.chatHistory?[indexPath.row]["sid"] == GameService.shared.thisPlayer.sid{
            cell.nameLbl.textAlignment = .right
            cell.messageLbl.textAlignment = .right
        }
        
        return cell
    }
    
    func reloadTable() {
        chatTable.reloadData()
    }
    
    @IBOutlet weak var messageTxt: UITextView!
    
    @IBAction func sendMessage(_ sender: Any) {
        if GameService.shared.thisPlayer.isAlive! {
            // send the message
            SocketIOManager.shared.chatUpdate(message: messageTxt.text)
            // clear the text
            messageTxt.text = ""
            //get rid of keyboard
            messageTxt.resignFirstResponder()
        }
        else {
            let alertController = UIAlertController(title: "Dead", message: "Sorry, you are currently dead", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
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
        
        messageTxt.delegate = self
        
        chatTable.estimatedRowHeight = 100.0
        chatTable.rowHeight = UITableViewAutomaticDimension
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateVoteCountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(killedCompletion), name: .updateKilledNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRoundCompletion), name: .updateAlivePlayersNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: .updateChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRoundCompletion), name: .whoWonNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // reset default chat text
        messageTxt.text = "...type a message"
        messageTxt.textColor = UIColor.lightGray
        
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
    
    func pass() {
        
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
            
            let alertController = UIAlertController(title: "Killed", message: "\(GameService.shared.inRoom?.killedPlayer) was found dead.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
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
    
    // MARK: Text Field delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
    // MARK: Keyboard methods
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
}
