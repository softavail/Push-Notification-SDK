import Foundation
import CoreData

extension NotificationObject {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<NotificationObject> {
        return NSFetchRequest<NotificationObject>(entityName: "NotificationObject")
    }
    
    @NSManaged public var attachmentData: Data?
    @NSManaged public var attachmentType: String?
    @NSManaged public var body: String
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var title: String
}
