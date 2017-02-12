//
//  ViewController.swift
//  SocketExample
//
//  Created by Yilun Gao on 2/11/17.
//  Copyright © 2017 Yilun Gao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StreamDelegate, UITextViewDelegate{
    
    
    var input: InputStream?
    var output: OutputStream?
    var mystring: String?
    
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var messageText: UITextView!
    
    func connect(serverPort: UInt32, serverAddress: CFString) {
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // connect to the host
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        
        self.input = readStream!.takeRetainedValue()
        self.output = writeStream!.takeRetainedValue()
        
        self.input!.delegate = self
        self.output!.delegate = self
        
        self.input!.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.output!.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        //open the connections!
        self.input!.open()
        self.output!.open()
    }
    
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            //write data
            self.mystring = self.messageText.text
            let encodedDataArray = [UInt8](self.mystring!.utf8)
            self.output!.write(encodedDataArray, maxLength: encodedDataArray.count)
            
            
//            // read data
//            var buffer = [UInt8](repeating: 0, count: 50)
//            
//            if (self.input?.hasBytesAvailable)! {
//                let result :Int = self.input!.read(&buffer, maxLength: buffer.count)
//            }
//            let str = String(bytes: buffer, encoding: String.Encoding.utf8)
//            
//            
//            self.outputText.text! += str!
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //connect to port
        // Home address: 192.168.1.15
        // UO address: 10.111.192.234
        connect(serverPort: 80, serverAddress: "10.111.192.234" as CFString)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (eventCode){
        case Stream.Event.errorOccurred:
            NSLog("ErrorOccurred")
            break
        case Stream.Event.endEncountered:
            NSLog("EndEncountered")
            break
//        case Stream.Event.none:
//            NSLog("None")
//            break
        case Stream.Event.hasBytesAvailable:
            NSLog("HasBytesAvaible")
            var buffer = [UInt8](repeating: 0, count: 4096)
            if ( aStream == input){
                
                while (input!.hasBytesAvailable)
                {
                    let len = input!.read(&buffer, maxLength: buffer.count)
                    if(len > 0){
                        let str = String(bytes: buffer, encoding: String.Encoding.utf8)
                        self.outputText.text! += str!
                    }
                }
            }
            break
//        case Stream.Event.allZeros:
//            NSLog("allZeros")
//            break
        case Stream.Event.openCompleted:
            NSLog("OpenCompleted")
            break
        case Stream.Event.hasSpaceAvailable:
            NSLog("HasSpaceAvailable")
            break
        default:
            break
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.input!.close()
        self.output!.close()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

