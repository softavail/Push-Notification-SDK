import UIKit

class LoggedViewControllerData: NSObject {
    func getLoggedDataSource() -> [BaseModel] {
        var modelArray = [BaseModel]()
        
        let loggedVCCellModel = TripleLabelModel()
        loggedVCCellModel.topLabelTitle = LABEL
        loggedVCCellModel.bottomLeftLabelTitle = CREATED
        loggedVCCellModel.bottomRightLabelTitle = DATE_GOES_HERE
        loggedVCCellModel.cellIdentifier = String(describing: TripleLabelCell.self)
        modelArray.append(loggedVCCellModel)
        
        let immutableModelArray = modelArray
        return immutableModelArray
    }
}
