//
//  ProfileController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/22/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import CoreData

class ProfileController: UIViewController, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetched results
        playerInfoFetchedResultsController = PlayerService.shared.playerCategory()
        playerInfoFetchedResultsController.delegate = self
        
        roomsFetchedResultsController = PlayerService.shared.rooms()
        roomsFetchedResultsController.delegate = self
        
        gameDataFetchedResultsController = PlayerService.shared.gameData()
        gameDataFetchedResultsController.delegate = self
        
        nameLabel.text = PlayerService.shared.nameGet()
        roomCountLabel.text = String(PlayerService.shared.hostedGet())
        wonCountLabel.text = String(PlayerService.shared.wonGet())
        lostCountLabel.text = String(PlayerService.shared.lostGet())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Properties (Private)
    private var playerInfoFetchedResultsController: NSFetchedResultsController<PlayerInfo>!
    private var roomsFetchedResultsController: NSFetchedResultsController<Rooms>!
    private var gameDataFetchedResultsController: NSFetchedResultsController<GameData>!
    
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var roomCountLabel: UILabel!

    @IBOutlet weak var wonCountLabel: UILabel!

    @IBOutlet weak var lostCountLabel: UILabel!
    
    
    
}
