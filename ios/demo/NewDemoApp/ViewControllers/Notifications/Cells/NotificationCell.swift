import UIKit
import AVFoundation

enum URLType {
    case audio
    case image
    case video
    case word
    case excel
    case powerPoint
    case pdf
    case defaultDocument
}

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        guard let notificationModel = self.notificationModel else { return }
        guard let attachmentURL = notificationModel.attachmentURL else { return }
        
        titleLabel.text = notificationModel.titleLabel
        bodyLabel.text = notificationModel.bodyLabel
        receivedLabel.text = notificationModel.receivedLabel
        dateLabel.text = notificationModel.dateLabel
        
        if !attachmentURL.isEmpty {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
            
            downloadURLContent(from: attachmentURL) { [weak self] localURL, urlType in
                self?.contentURL = localURL
                switch urlType {
                case .audio:
                    self?.cellImageView.image = UIImage(named: "mp3")
                case .image:
                    self?.cellImageView.image = UIImage(contentsOfFile: localURL.relativePath)
                case .video:
                    self?.cellImageView.image = self?.getThumbnail(from: localURL)
                case .word:
                    self?.cellImageView.image = UIImage(named: "doc")
                case .excel:
                    self?.cellImageView.image = UIImage(named: "xls")
                case .powerPoint:
                    self?.cellImageView.image = UIImage(named: "ppt")
                case .pdf:
                    self?.cellImageView.image = UIImage(named: "pdf")
                case .defaultDocument:
                    self?.cellImageView.image = UIImage(named: "defaultDoc")
                }
            }
        }
    }
    
    // MARK: Helping methods
    
    func downloadURLContent(from urlString: String, completionHandler: @escaping (URL, URLType) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            var secureURLString = urlString
            if !urlString.hasPrefix("https") {
                secureURLString.insert("s", at: "https".firstIndex(of: "s")!)
            }
            
            guard let attachmentURL = URL(string: secureURLString) else { return }
            guard let urlData = NSData(contentsOf: attachmentURL) else { return }
            
            let fileExtension = attachmentURL.pathExtension.lowercased()
            let name = UUID().uuidString + "." + fileExtension
            guard let path = self?.getDocumentsDirectory().appendingPathComponent(name) else { return }
            
            let urlType: URLType
            
            switch fileExtension {
            case "aiff", "aif", "aifc", "wav", "mp3", "m4a":
                urlType = .audio
            case "jpg", "jpeg", "jpe", "jif", "jfif", "pjpeg", "pjp", "gif", "png":
                urlType = .image
            case "mpg", "mp2", "mpeg", "mpe", "mpv", "m2v", "mp4", "m4p", "m4v", "avi":
                urlType = .video
            case "doc", "docx":
                urlType = .word
            case "xls", "xlsx":
                urlType = .excel
            case "ppt", "pptx":
                urlType = .powerPoint
            case "pdf":
                urlType = .pdf
            default:
                urlType = .defaultDocument
            }
            
            DispatchQueue.main.async {
                do {
                    try urlData.write(to: path)
                    completionHandler(path, urlType)
                } catch {
                    print("Failed writing to path.")
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
