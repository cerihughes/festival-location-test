import Madog
import UIKit

class ExportStagesViewController: TypedViewController<ExportStagesView> {
    private let viewModel: ExportStagesViewModel

    init(viewModel: ExportStagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        typedView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateJSON()
    }

    private func updateJSON() {
        let jsonString = viewModel.areasJSONString
        typedView.textView.text = jsonString
        UIPasteboard.general.string = jsonString
    }

    @objc private func deleteTapped(_ button: UIButton) {
        viewModel.deleteAllStages()
        updateJSON()
    }
}
