//
//  Student+CoreDataProperties.swift
//

import Foundation
import CoreData

extension Student {

    @NSManaged var name: String?
    @NSManaged var age: NSNumber?
    @NSManaged var club: Club?

}
