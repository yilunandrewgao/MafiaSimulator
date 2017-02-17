//
//  ConnectionsViewController.swift
//  MultipeerConnectivityDemo
//
//  Created by Yilun Gao on 2/13/17.
//  Copyright © 2017 Yilun Gao. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate{
    
    
    
    override func viewDidLoad() {
        
        // set delegate
        MPCManager.shared.delegate = self
        
//        // start browsing
//        MPCManager.shared.browser.startBrowsingForPeers()
        
        // start advertising
        MPCManager.shared.advertiser.startAdvertisingPeer()
        
    }
    
    
    // MPCManager delegate functions
    
    func foundPeer() {
        
        tblConnectedDevices.reloadData()
        
    }
    
    
    func lostPeer() {
        tblConnectedDevices.reloadData()
    }
    
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            MPCManager.shared.invitationHandler(true, MPCManager.shared.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            MPCManager.shared.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
//        OperationQueue.main.addOperation { () -> Void in
//            self.performSegue(withIdentifier: "idSegueChat", sender: self)
//        }
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    // Table View methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (MPCManager.shared.foundPeers.count)
        return MPCManager.shared.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectedDeviceCell", for: indexPath)
        
        cell.textLabel?.text = MPCManager.shared.foundPeers[indexPath.row].displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = MPCManager.shared.foundPeers[indexPath.row] as MCPeerID
        
        MPCManager.shared.browser?.invitePeer(selectedPeer, to: MPCManager.shared.session, withContext: nil, timeout: 20)
    }
    
    
    // IBOutlets
    
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var swVisible: UISwitch!
    
    @IBOutlet weak var tblConnectedDevices: UITableView!
    
    @IBOutlet weak var btnDisconnect: UIButton!
    
    
    // IBActions

    @IBAction func toggleVisibility(_ sender: Any) {
        
        if swVisible.isOn {
            // if switch is on and switched off, stop advertising
            MPCManager.shared.advertiser.stopAdvertisingPeer()
            
            swVisible.setOn(false, animated: true)
        }
        else {
            // if switch is off and switched on, start advertising
            MPCManager.shared.advertiser.startAdvertisingPeer()
            
            swVisible.setOn(true, animated: true)
        }
    }
    
    @IBAction func browseForDevices(_ sender: Any) {
        
        MPCManager.shared.browser?.startBrowsingForPeers()
        
    }
    
    @IBAction func disconnect(_ sender: Any) {
        
//        MPCManager.shared.browser?.stopBrowsingForPeers()
//        MPCManager.shared.foundPeers.removeAll()
//        
//        tblConnectedDevices.reloadData()
        
        // Disconnect from selected peer
        
        
        
    }
}
