
import UIKit

class FormsTextField: UITextField {

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 15
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView = paddingView
        leftViewMode = .always
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum LayoutMetrics {
        static let textFieldHorizontalPadding: CGFloat = 20
        static let textFieldHeight: CGFloat = 50
    }
}
