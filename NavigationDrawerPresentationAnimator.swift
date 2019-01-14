import Foundation
import UIKit

private enum OperationType {
    case leftToRight(offset: CGFloat), rightToLeft(offset: CGFloat)
}

class NavigationDrawerPresentationAnimator: NSObject {

    static let phoneViewWidth: CGFloat = 270
    static let tabletViewWidth: CGFloat = 360
    static let leadingConstraintIdentifier = "leadingConstraint"

    private let isBeingPresented: Bool
    private let supportAnimation: Bool

    init(isBeingPresented: Bool, supportAnimation: Bool) {
        self.isBeingPresented = isBeingPresented
        self.supportAnimation = supportAnimation
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension NavigationDrawerPresentationAnimator: UIViewControllerAnimatedTransitioning {

    private func setupviews(_ containerView: UIView, _ concernedView: UIView) {
        if isBeingPresented {
            let dimmingView = DimmingView(backgroundColor: .black, alpha: 0.2)
            setupDimmingView(dimmingView, containerView)
            setupPresentedView(presentedView: concernedView, containerView: containerView)
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let concernedVC = transitionContext.viewController(forKey: isBeingPresented
            ? .to
            : .from),
            let concernedView = concernedVC.view else { return }

        let containerView = transitionContext.containerView

        setupviews(containerView, concernedView)
        containerView.layoutIfNeeded()

        let operation = getOperationType(isBeingPresented: isBeingPresented, concernedView: concernedView)
        let dimmingView = containerView.subviews.first { $0 is DimmingView }

        let leadingConstraint = containerView.constraints.first { $0.identifier == "leadingConstraint" }

        if supportAnimation || isBeingPresented == false {
            switch (operation, isBeingPresented) {
            case (.rightToLeft(let offset), true),
                 (.leftToRight(let offset), true):
                leadingConstraint?.constant = offset
            case (.rightToLeft(let offset), false):
                leadingConstraint?.constant = -offset
            case (.leftToRight(let offset), false):
                leadingConstraint?.constant = offset
            }

            let animationBlock = { [weak self] in
                guard let self = self else { return }
                dimmingView?.alpha = self.isBeingPresented ? 0.5 : 0
                containerView.layoutIfNeeded()
            }

            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: animationBlock) { finished in
                    transitionContext.completeTransition(finished)
            }
        } else {
            leadingConstraint?.constant = -concernedView.bounds.width
            UIView.animate(withDuration: TimeInterval.leastNormalMagnitude
                , animations: {
                    dimmingView?.alpha = 0.5
                    containerView.layoutIfNeeded()
            }) { finished in
                leadingConstraint?.constant = 0
                transitionContext.completeTransition(finished)
            }
        }
    }

    private func getOperationType(isBeingPresented: Bool, concernedView: UIView) -> OperationType {
        let width = concernedView.bounds.width
        let isRTL = concernedView.isRTL

        guard isBeingPresented else {
            let direction: DragDirection = isRTL ? .right : .left
            let offset: CGFloat = direction == .left ? -width : width
            return concernedView.isRTL
                ? .rightToLeft(offset: offset)
                : .leftToRight(offset: offset)
        }
        return concernedView.isRTL
            ? .rightToLeft(offset: 0)
            : .leftToRight(offset: 0)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    private func setupDimmingView(_ dimmingView: DimmingView, _ containerView: UIView) {
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        containerView.insertSubview(dimmingView, at: 0)

        [dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
         dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
         dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ].forEach { $0.isActive = true }
    }

    private func setupPresentedView(presentedView: UIView, containerView: UIView) {
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(presentedView)
        var widthConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?
        let traitCollection = presentedView.traitCollection
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.regular, .compact), (.compact, .compact), (.compact, .regular):
            let presentedViewWidth: CGFloat = NavigationDrawerPresentationAnimator.phoneViewWidth
            widthConstraint = presentedView.widthAnchor.constraint(equalToConstant: presentedViewWidth)
            leadingConstraint = presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -presentedViewWidth)
        case (.regular, .regular):
            let presentedViewWidth: CGFloat = NavigationDrawerPresentationAnimator.tabletViewWidth
            widthConstraint = presentedView.widthAnchor.constraint(equalToConstant: presentedViewWidth)
            leadingConstraint = presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -presentedViewWidth)
        case (.unspecified, .unspecified),
             (.unspecified, .compact),
             (.unspecified, .regular),
             (.compact, .unspecified),
             (.regular, .unspecified):
            break
        }

        [leadingConstraint,
         presentedView.topAnchor.constraint(equalTo: containerView.topAnchor),
         presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
         widthConstraint
            ].forEach { $0?.isActive = true }
        leadingConstraint?.identifier = NavigationDrawerPresentationAnimator.leadingConstraintIdentifier
    }
}
