//
//  ChatBoxViewController.swift
//  MultipeerConnectivityDemo
//
//  Created by Yilun Gao on 2/15/17.
//  Copyright © 2017 Yilun Gao. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatBoxViewController: UIViewController, UITextViewDelegate{
    
    
    var messagesArray: [Dictionary<String, String>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatBoxViewController.handleMPCReceivedDataWithNotification(notification:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        let stringToDisplay = notification.object
        
        
        // update text field
        DispatchQueue.main.async {
            self.txtViewChat.text! += stringToDisplay as! String
        }
        
    }
    

    // IBOutlets

    @IBOutlet weak var txtMessage: UITextField!

    @IBOutlet weak var txtViewChat: UITextView!
    
    // IBActions
    
    @IBAction func sendMessage(_ sender: Any) {
        let sender = MPCManager.shared.peer
        let message = txtMessage.text
        let MessageToSend = "\(sender!): \(message!)\n"
        
        if let data = MessageToSend.data(using: .utf8) {
            do {
                try MPCManager.shared.session.send(data, toPeers: MPCManager.shared.session.connectedPeers, with: .reliable)
            } catch {
                print("[Error] \(error)")
            }
        }
        
        // also print your own message
        txtViewChat.text! += "\(MPCManager.shared.peer!): \(message!)\n"
        
        // Hide Keyboard
        view.endEditing(true)
    }
    
    @IBAction func cancelMessage(_ sender: Any) {
        // clear text field
        txtMessage.text = ""
        
        // Hide Keyboard
        view.endEditing(true)
        
    }
    
    @IBAction func leaveSession(_ sender: Any) {
    }
    
}
