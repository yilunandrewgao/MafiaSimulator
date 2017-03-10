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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // send player data to MenuViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoCreateRoom" {
            
            let createRoomVC = segue.destination as! CreateRoomController
            createRoomVC.thisPlayer = self.thisPlayer
            
        }
        
        if segue.identifier == "GotoJoinRoom" {
            
            
            
            let joinRoomVC = segue.destination as! JoinRoomController
            joinRoomVC.thisPlayer = self.thisPlayer
        }
            
    }
    
    //MARK: Properties (IBOutlet) collection of avatars
    @IBOutlet weak var avatarCollection: UICollectionView!
    
}

