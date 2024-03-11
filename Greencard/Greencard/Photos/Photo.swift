//
//  Photo.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import UIKit
import CoreData

@objc(Photo)
class Photo: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var content: UIImage?
    @NSManaged public var time: Date?
}

extension Photo : Identifiable {

}
