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
        let fetchRequest: NSFetchRequest<PlayerInfo> = PlayerInfo.fetchRequest() as! NSFetchRequest<PlayerInfo>
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func rooms() -> NSFetchedResultsController<Rooms> {
        let fetchRequest: NSFetchRequest<Rooms> = Rooms.fetchRequest() as! NSFetchRequest<Rooms>
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func gameData() -> NSFetchedResultsController<GameData> {
        let fetchRequest: NSFetchRequest<GameData> = GameData.fetchRequest() as! NSFetchRequest<GameData>
        
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
    
    // MARK: Private init
    private init() {
        persistentContainer = NSPersistentContainer(name: "MafiaGame")
    }
    
    // MARK: Private
    private let persistentContainer: NSPersistentContainer
    
    // MARK: Properties (Static) shared
    static let shared = PlayerService()
}
