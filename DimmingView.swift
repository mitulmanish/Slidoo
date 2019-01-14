import UIKit

class DimmingView: UIView {

    init(backgroundColor: UIColor, alpha: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.alpha = alpha
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIPresentationController {
    var dimmingView: UIView? {
        return containerView?.subviews.first(where: { $0 is DimmingView })
    }
}
