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
        //call winner method
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func winner(){
//        //calculate points
//        whoWon.text = ""
//    }
    // MARK Properties (IBOutlet) label : winner
    @IBOutlet weak var whoWon: UILabel!
}

