//
//  ProfileController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/22/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var roomCountLabel: UILabel!
    
    @IBOutlet weak var wonCountLabel: UILabel!
    
    @IBOutlet weak var lostCountLabel: UILabel!
    
}
