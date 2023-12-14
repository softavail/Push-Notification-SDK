import UIKit
import AVFoundation

class NotificationCell: UITableViewCell {
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var receivedLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    var notificationModel: NotificationModel?
    var contentURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont.appFont(ofSize: 16)
        bodyLabel.font = UIFont.appFont(ofSize: 14)
        receivedLabel.font = UIFont.appFont(ofSize: 10)
        dateLabel.font = UIFont.appFont(ofSize: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let notificationModel = self.notificationModel else { return }
        guard let sharedDirectory = SharedMethods.getSharedDirectory() else { return }
        
        titleLabel.text = notificationModel.titleLabel
        bodyLabel.text = notificationModel.bodyLabel
        receivedLabel.text = notificationModel.receivedLabel
        dateLabel.text = notificationModel.dateLabel
        
        accessoryType = .none
        selectionStyle = .none
        
        guard let attachmentData = notificationModel.attachmentData else {
            cellImageView.image = nil
            contentURL = nil
            return
        }
        guard let attachmentType = notificationModel.attachmentType else {
            cellImageView.image = nil
            contentURL = nil
            return
        }
        
        accessoryType = .disclosureIndicator
        selectionStyle = .default
        
        let name = UUID().uuidString + "." + attachmentType
        let fileURL = sharedDirectory.appendingPathComponent(name)
        
        do {
            try attachmentData.write(to: fileURL)
        } catch {
            print("Failed writing to path.")
        }
        
        contentURL = fileURL
        
        switch attachmentType {
        case "aiff", "aif", "aifc", "wav", "mp3", "m4a":
            cellImageView.image = UIImage(named: "mp3")
        case "jpg", "jpeg", "jpe", "jif", "jfif", "pjpeg", "pjp", "gif", "png":
            cellImageView.image = UIImage(contentsOfFile: fileURL.relativePath)
        case "mpg", "mp2", "mpeg", "mpe", "mpv", "m2v", "mp4", "m4p", "m4v", "avi":
            if let contentURL = self.contentURL {
                cellImageView.image = getThumbnail(from: contentURL)
            }
        case "doc", "docx":
            cellImageView.image = UIImage(named: "doc")
        case "xls", "xlsx":
            cellImageView.image = UIImage(named: "xls")
        case "ppt", "pptx":
            cellImageView.image = UIImage(named: "ppt")
        case "pdf":
            cellImageView.image = UIImage(named: "pdf")
        default:
            cellImageView.image = UIImage(named: "defaultDoc")
        }
    }
    
    func getThumbnail(from videoURL: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let thumbnail = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: thumbnail)
        }
        catch {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}
