//
//  WaitingPlayerController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class WaitingPlayerController: UIViewController {
    
    var tapCount : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapCount = 0.0
        self.playerProgress.progress = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var playerProgress: UIProgressView!
    
    @IBAction func tapButton(_ sender: Any) {
        guard self.playerProgress.progress < 1.0 else {
            return
        }
        self.tapCount += 0.1
        self.playerProgress.progress = tapCount
    }
   
}
