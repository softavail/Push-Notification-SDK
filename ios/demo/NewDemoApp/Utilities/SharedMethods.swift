import Foundation

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

class SharedMethods {
    static func getBaseURL() -> String {
        var stringToReturn = ""
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let textToLoad = defaults.object(forKey: "baseURL") as? Data {
            do {
                stringToReturn = try jsonDecoder.decode(String.self, from: textToLoad)
            } catch let error {
                print("Error in loading baseURL: \(error.localizedDescription)")
            }
        }
        
        return stringToReturn
    }

    static func getDeviceToken() -> String? {
        var stringToReturn: String? = nil
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let textToLoad = defaults.object(forKey: "deviceToken") as? Data {
            do {
                stringToReturn = try jsonDecoder.decode(String.self, from: textToLoad)
            } catch let error {
                print("Error in loading deviceToken: \(error.localizedDescription)")
            }
        }
        
        return stringToReturn
    }
    
    static func getSharedDirectory() -> URL? {
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.syniverse.push.demo.app")
        return path
    }
    
    static func getSharedDatabaseDirectory(databaseName: String) -> URL? {
        guard let sharedDirectory = SharedMethods.getSharedDirectory() else { return nil }
        
        return sharedDirectory.appendingPathComponent("\(databaseName).sqlite")
    }
    
    static func downloadURLContent(from urlString: String, completionHandler: @escaping (URL, URLType, NSData) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var secureURLString = urlString
            if !urlString.hasPrefix("https") {
                secureURLString.insert("s", at: "https".firstIndex(of: "s")!)
            }
            
            guard let attachmentURL = URL(string: secureURLString) else { return }
            guard let urlData = NSData(contentsOf: attachmentURL) else { return }
            guard let sharedDirectory = SharedMethods.getSharedDirectory() else { return }
            
            let fileExtension = attachmentURL.pathExtension.lowercased()
            let name = UUID().uuidString + "." + fileExtension
            let path = sharedDirectory.appendingPathComponent(name)
            
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
                    completionHandler(path, urlType, urlData)
                } catch {
                    print("Failed writing to path.")
                }
            }
        }
    }
}
