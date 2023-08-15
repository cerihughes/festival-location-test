import Madog
import UIKit

class ReloadDataViewController: TypedViewController<ReloadDataView> {
    private let viewModel: ReloadDataViewModel

    init(viewModel: ReloadDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typedView.importButton.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
        typedView.exportButton.addTarget(self, action: #selector(exportTapped), for: .touchUpInside)

        let jsonString = viewModel.jsonString
        typedView.textView.text = jsonString
    }

    @objc private func importTapped(_ button: UIButton) {
        Task { @MainActor in
            await viewModel.importAreas()
        }
    }

    @objc private func exportTapped(_ button: UIButton) {
        let jsonString = viewModel.jsonString
        UIPasteboard.general.string = jsonString
    }
}
