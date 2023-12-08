import UIKit
import CoreData

class NotificationsViewControllerData: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    var notifications = [NotificationObject]()
    var modelArray = [BaseModel]()
    
    func getNotificationsDataSource(completionHandler: @escaping ([BaseModel]) -> Void) {
        loadDatabase { [weak self] in
            guard let notifications = self?.notifications else { return }
            
            for notification in notifications {
                let notificationModel = NotificationModel()
                notificationModel.titleLabel = notification.title == "" ? "Missing Title" : notification.title
                notificationModel.bodyLabel = notification.body == "" ? "Missing Body" : notification.body
                notificationModel.attachmentURL = notification.attachmentURL
                notificationModel.receivedLabel = "Received:"
                notificationModel.dateLabel = notification.date.customDescription()
                notificationModel.cellIdentifier = String(describing: NotificationCell.self)
                self?.modelArray.append(notificationModel)
            }
            
            if let immutableModelArray = self?.modelArray {
                completionHandler(immutableModelArray)
            }
        }
    }
    
    func loadDatabase(completionHandler: @escaping () -> Void) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            guard let context = self?.context else { return }
//            
//            let request = NotificationObject.createFetchRequest()
//            let sort = NSSortDescriptor(key: "date", ascending: false)
//            request.sortDescriptors = [sort]
//            
//            do {
//                self?.notifications = try context.fetch(request)
//                completionHandler()
//            } catch {
//                print("CoreData failed to load notifications.")
//            }
//        }
        let request = NotificationObject.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            notifications = try context.fetch(request)
            completionHandler()
        } catch {
            print("CoreData failed to load notifications.")
        }
    }
}
