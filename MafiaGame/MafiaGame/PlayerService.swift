//
//  PlayerService.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/22/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import CoreData

class PlayerService{
    
    func playerCategory() -> NSFetchedResultsController<PlayerInfo> {
        let fetchRequest: NSFetchRequest<PlayerInfo> = PlayerInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func rooms() -> NSFetchedResultsController<Rooms> {
        let fetchRequest: NSFetchRequest<Rooms> = Rooms.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "hosted", ascending: false)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func gameData() -> NSFetchedResultsController<GameData> {
        let fetchRequest: NSFetchRequest<GameData> = GameData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "won", ascending: false)]
        return createFetchedResultsController(for: fetchRequest)
    }

    
    // MARK: Private return fetched results
    private func createFetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error {
            fatalError("Could not perform fetch for fetched results controller: \(error)")
        }
        
        return fetchedResultsController
    }
    
    
    // Mark: set PlayerInfo name
    func nameSet(for username: String) {
        let playerInfo = self.playerCategory().object(at: IndexPath(row: 0, section: 0))
        playerInfo.setValue(username, forKey: "name")
        
    }
    
    // Mark: set Room hosted
    func hostedSet() {
        let rooms = self.rooms().object(at: IndexPath(row: 0, section: 0))
        let originalCount = rooms.value(forKey: "hosted")
        if let roomCount = originalCount {
            let count = roomCount as! Int
            let newCount = count + 1
            rooms.setValue(newCount, forKey: "hosted")
        }
        
        
    }
    // Mark: set GameData won
    func wonSet() {
        let gameData = self.gameData().object(at: IndexPath(row: 0, section: 0))
        let originalCount = gameData.value(forKey: "won")
        if let wonCount = originalCount {
            let count = wonCount as! Int
            let newCount = count + 1
            gameData.setValue(newCount, forKey: "won")
        }
        
    }
    
    // Mark: set GameData lost
    func lostSet() {
        let gameData = self.gameData().object(at: IndexPath(row: 0, section: 0))
        let originalCount = gameData.value(forKey: "lost")
        if let lostCount = originalCount {
            let count = lostCount as! Int
            let newCount = count + 1
            gameData.setValue(newCount, forKey: "lost")
        }
        
    }
    
    
    // MARK: Private init
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "MafiaGame")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let context = self.persistentContainer.viewContext
            
            context.perform {
                //guard statement to check if any player Info objects have already been created
                let fetchRequest: NSFetchRequest<PlayerInfo> = PlayerInfo.fetchRequest()
                let count = (try? context.count(for: fetchRequest)) ?? 0
                
                guard count == 0 else {
                    return
                }
                
                //If there is no core data of player than below is inital data
                
                //PlayerInfo NSManagedObject
                let playerInfo = PlayerInfo(context: context)
                playerInfo.name = ""
                
                //Rooms NSManagedObject
                let rooms = Rooms(context: context)
                rooms.hosted = Int32(0)
                
                //GameData NSManagedObject
                let gameData = GameData(context: context)
                gameData.won = Int32(0)
                gameData.lost = Int32(0)
                
                do {
                    try context.save()
                }
                
                catch _ {
                    fatalError("Failed to save context after inserting initial player info data")
                }
                
            }
        })
    }
    
    
    // MARK: Private
    private let persistentContainer: NSPersistentContainer
    
    // MARK: Properties (Static) shared
    static let shared = PlayerService()
}
