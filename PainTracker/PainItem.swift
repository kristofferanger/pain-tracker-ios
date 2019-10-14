//
//  PainItem.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-10-11.
//  Copyright © 2019 Kriang. All rights reserved.
//

import Foundation
import CoreData

class PainItem : NSManagedObject, Identifiable {
    
    @NSManaged var date: Date?
    @NSManaged var message: String?
    @NSManaged var medicine: String?
    @NSManaged var level: NSDecimalNumber?
    @NSManaged var duration: NSNumber?

}

extension PainItem {
    public static func painItemfetchRequest() -> NSFetchRequest<PainItem> {
        let request = PainItem.fetchRequest() as! NSFetchRequest<PainItem>
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
