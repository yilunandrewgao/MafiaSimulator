//
//  PlayerInfo+CoreDataProperties.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/22/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PlayerInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerInfo> {
        return NSFetchRequest<PlayerInfo>(entityName: "PlayerInfo");
    }

    @NSManaged public var name: String?

}
