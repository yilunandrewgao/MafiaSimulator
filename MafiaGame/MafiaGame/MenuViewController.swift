//
//  MenuViewController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/17/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class MenuViewController: UIViewController {
    
    var thisPlayer:Player! = GameService.shared.thisPlayer
    
    @IBOutlet weak var playerNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerNameLbl.text  = "Logged in as: \(self.thisPlayer.name)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: Properties (IBOutlet) collection of avatars
    @IBOutlet weak var avatarCollection: UICollectionView!
    
    @IBAction func unwindToMenu(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        SocketIOManager.shared.closeConnection()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        }
    }
}

