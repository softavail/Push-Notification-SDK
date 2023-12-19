import UIKit
import CoreData

class NotificationsViewControllerData: NSObject {
    let persistentContainer = CoreDataSingleton.shared.persistentContainer
    var notifications = [NotificationObject]()
    var modelArray = [BaseModel]()

    func getNotificationsDataSource(completionHandler: @escaping ([BaseModel]) -> Void) {
        loadDatabase { [weak self] in
            guard let notifications = self?.notifications else { return }

            for notification in notifications {
                let notificationModel = NotificationModel()
                notificationModel.titleLabel = notification.title == "" ? MISSING_TITLE : notification.title
                notificationModel.bodyLabel = notification.body == "" ? MISSING_BODY : notification.body
                notificationModel.attachmentType = notification.attachmentType
                notificationModel.receivedLabel = RECEIVED
                notificationModel.dateLabel = notification.date.customDescription()
                notificationModel.cellIdentifier = String(describing: NotificationCell.self)
                
                if let attachmentData = notification.attachmentData {
                    notificationModel.attachmentData = NSData(data: attachmentData)
                } else {
                    notificationModel.attachmentData = nil
                }
                
                self?.modelArray.append(notificationModel)
            }

            if let immutableModelArray = self?.modelArray {
                completionHandler(immutableModelArray)
            }
        }
    }

    func loadDatabase(completionHandler: @escaping () -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        
        context.perform { [weak self] in
            do {
                let request = NotificationObject.createFetchRequest()
                let sort = NSSortDescriptor(key: "date", ascending: false)
                request.sortDescriptors = [sort]

                self?.notifications = try context.fetch(request)
                completionHandler()
            } catch {
                print("CoreData failed to load notifications.")
            }
        }
    }
}
