import Foundation
import CoreData

final class CoreDataSingleton {
    static let shared = CoreDataSingleton()
    private init() {  }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewDemoApp")
        
        if let databaseDirectory = SharedMethods.getSharedDatabaseDirectory(databaseName: "NewDemoAppDB") {
            let persistentStoreDescription = NSPersistentStoreDescription(url: databaseDirectory)
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        
        container.loadPersistentStores() { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    func configure(notification: NotificationObject, content: UNNotificationContent, attachmentData: NSData?, attachmentType: String?) {
        notification.id = UUID().uuidString
        notification.date = Date()
        notification.title = content.title
        notification.body = content.body
        notification.attachmentType = attachmentType
        
        if let attachmentData = attachmentData {
            notification.attachmentData = Data(referencing: attachmentData)
        } else {
            notification.attachmentData = nil
        }
        
        saveDatabase()
    }
    
    func saveDatabase() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print("CoreData failed to save changes.\nError: \(error)")
            }
        }
    }
}
