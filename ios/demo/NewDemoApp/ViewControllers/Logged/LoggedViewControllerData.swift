import UIKit

class LoggedViewControllerData: NSObject {
    func getLoggedDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let loggedVCCellModel = TripleLabelModel()
        loggedVCCellModel.topLabelTitle = "Label"
        loggedVCCellModel.bottomLeftLabelTitle = "Created:"
        loggedVCCellModel.bottomRightLabelTitle = "Date goes here"
        loggedVCCellModel.cellIdentifier = String(describing: TripleLabelCell.self)
        modelArray.append(loggedVCCellModel)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
