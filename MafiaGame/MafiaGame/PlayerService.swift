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
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func rooms() -> NSFetchedResultsController<Rooms> {
        let fetchRequest: NSFetchRequest<Rooms> = Rooms.fetchRequest()
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func gameData() -> NSFetchedResultsController<GameData> {
        let fetchRequest: NSFetchRequest<GameData> = GameData.fetchRequest()
        
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
    
    
    // Mark: Private set PlayerInfo name
    private func nameSet(for username: String) {
        let playerInfo = self.playerCategory().object(at: IndexPath(row: 0, section: 0))
        playerInfo.setValue(username, forKey: "name")
        
    }
    
    // Mark: Private set Room hosted
    private func hostedSet(for hostedCount: Int) {
        let rooms = self.rooms().object(at: IndexPath(row: 0, section: 0))
        rooms.setValue(hostedCount, forKey: "hosted")
        
    }
    // Mark: Private set GameData won
    private func wonSet(for wonCount: Int) {
        let gameData = self.gameData().object(at: IndexPath(row: 0, section: 0))
        gameData.setValue(wonCount, forKey: "won")
    }
    
    // Mark: Private set GameData lost
    private func lostSet(for lostCount: Int) {
        let gameData = self.gameData().object(at: IndexPath(row: 0, section: 0))
        gameData.setValue(lostCount, forKey: "lost")
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
                rooms.hosted = 0
                
                //GameData NSManagedObject
                let gameData = GameData(context: context)
                gameData.won = 0
                gameData.lost = 0
                
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
