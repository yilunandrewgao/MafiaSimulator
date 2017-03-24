//
//  MenuViewController.swift
//  MafiaGame
//
//  Created by Yufang Lin on 2/17/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var thisPlayer:Player! = GameService.shared.thisPlayer
    
    @IBOutlet weak var playerNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerNameLbl.text  = "Logged in as: \(self.thisPlayer.name)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: Properties (IBOutlet) collection of avatars
    @IBOutlet weak var avatarCollection: UICollectionView!
    
    @IBAction func unwindToMenu(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        SocketIOManager.shared.closeConnection()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        }
    }
    
    
    
    // MARK: avatar stuff
    
    var avatarImages: [UIImage] = [
        UIImage(named: "maid.png")!,
        UIImage(named: "noble_lady.png")!,
        UIImage(named: "village_boy.png")!,
        UIImage(named: "village_girl.png")!,
        UIImage(named: "village_man.png")!
    ]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarImageCell
        
        // Configure the cell
        let image = avatarImages[indexPath.row]
        cell.avatarImage.image = image
        return cell
    }
    
}

