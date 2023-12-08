import UIKit

class LoggedViewController: MainViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    lazy var loggedDataSource = LoggedViewControllerData()
    var dataSource = [BaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = loggedDataSource.getLoggedDataSource()
    }
    
    // MARK: UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        guard let cellIdentifier = model.cellIdentifier else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TripleLabelCell {
            cell.tripleLabelModel = model as? TripleLabelModel
            cell.updateCell()
            return cell
        }
        
        return UITableViewCell()
    }
}
