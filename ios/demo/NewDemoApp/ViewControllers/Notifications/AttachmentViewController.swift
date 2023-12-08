import UIKit
import QuickLook

class AttachmentViewController: MainViewController, QLPreviewControllerDataSource {
    var selectedContentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPreviewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .myPrimaryColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = selectedContentURL else { fatalError("Preview URL was nil.") }
        
        return url as QLPreviewItem
    }
    
    func setUpPreviewController() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        addChild(previewController)
        view.addSubview(previewController.view)
        previewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        previewController.didMove(toParent: self)
    }
}
