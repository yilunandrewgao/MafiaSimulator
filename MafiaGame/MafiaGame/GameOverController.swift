//
//  GameOverController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/22/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class GameOverController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winner()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(pass), name: .updateRoomNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(quitRoomCompletion), name: .quitRoomNotification, object: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pass() {
    
    }
    
    func quitRoomCompletion(){
        DispatchQueue.main.async {
            GameService.shared.resetData()
            self.performSegue(withIdentifier: "unwindToMenu", sender: nil)
        }
    }
    func winner(){
        //calculate points
        if let won = GameService.shared.inRoom?.whoWon {
            whoWon.text = "\(won) won!!"
        }
        else {
            whoWon.text = "no one won yet"
        }
    }
    
    // MARK Properties (IBAction) button exit to menu
    @IBAction func gameOverExit(_ sender: Any) {
        SocketIOManager.shared.sendUserExitRoomEvent()
        
    }
    // MARK Properties (IBOutlet) label : winner
    @IBOutlet weak var whoWon: UILabel!
}

