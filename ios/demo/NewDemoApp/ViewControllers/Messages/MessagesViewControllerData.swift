import UIKit

class MessagesViewControllerData: NSObject {
    static var formatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()

    static var todayFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()

    static var lastWeekFormatter: DateFormatter =
    {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    func getMessagesDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        let numberOfMessages = Int(SCGPush.sharedInstance().numberOfMessages())
        
        for i in 0...numberOfMessages {
            if let message:SCGPushMessage = SCGPush.sharedInstance().message(at: UInt(i)) {
                let model = MessageModel()
                
                if Calendar.current.isDateInToday(message.created) {
                    model.created = MessagesViewControllerData.todayFormatter.string(from: message.created)
                } else if (Date().timeIntervalSince(message.created) < (7 * 24 * 3600)) {
                    model.created = MessagesViewControllerData.lastWeekFormatter.string(from: message.created)
                } else {
                    model.created = MessagesViewControllerData.formatter.string(from: message.created)
                }
                
                model.cellIdentifier = String(describing: MessageTableViewCell.self)
                model.messagesCellType = .buttons
                model.title = message.body ?? ""
                model.hasAttachment = message.hasAttachment
                modelArray.append(model)
            }
        }

        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
