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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let jsonString = viewModel.areasJSONString
        typedView.textView.text = jsonString
        UIPasteboard.general.string = jsonString
    }
}
