//
//  ClientManager.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/21/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ClientManagerDelegate {
    func foundHost()
    
    func lostHost()

}

//class ClientManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
//    
//    var clientDelegate: ClientManagerDelegate?
//    
//    var session: MCSession!
//}
