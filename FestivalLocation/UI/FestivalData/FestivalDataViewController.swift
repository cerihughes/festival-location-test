import Madog
import UIKit

class FestivalDataViewController: UIViewController {
    private weak var context: AnyContext<Navigation>?
    private let viewModel: FestivalDataViewModel
    private let festivalDataView = FestivalDataView()

    init(context: AnyContext<Navigation>, viewModel: FestivalDataViewModel) {
        self.context = context
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = festivalDataView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Line-up"
    }
}
