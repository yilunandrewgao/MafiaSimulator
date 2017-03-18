//
//  MafiaNightController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/20/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class MafiaNightController: UIViewController {
    func transitionToMorning() {
        var viewControllers = navigationController?.viewControllers
        
        let dayViewController = VillagerDayController()
        viewControllers?.removeLast()
        viewControllers?.append(dayViewController)
        
        navigationController?.setViewControllers(viewControllers!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocketIOManager.shared.startRound()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


