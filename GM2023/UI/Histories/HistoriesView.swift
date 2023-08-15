import SnapKit
import UIKit

class HistoriesView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
