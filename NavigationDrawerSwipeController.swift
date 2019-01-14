import UIKit

class NavigationDrawerSwipeController: UIPresentationController {

    private var isRTL: Bool {
        return presentedView?.isRTL ?? false
    }

    private var presentedViewWidth: CGFloat {
        return presentedView?.bounds.width ?? 0
    }

    private func shouldDismiss(dragDirection: DragDirection) -> Bool {
        switch (dragDirection, self.isRTL) {
        case (.left, false):
            return true
        case (.right, true):
            return true
        default:
            return false
        }
    }

    private var originX: CGFloat?

    override func presentationTransitionDidEnd(_ completed: Bool) {
        let presentedViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        let containerViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGestureRecognizer.delegate = self
        presentedView?.addGestureRecognizer(presentedViewPanGesture)
        containerView?.addGestureRecognizer(containerViewPanGesture)
        containerView?.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTap(panRecognizer: UIPanGestureRecognizer) {
        dismiss()
    }

    @objc func didPan(panRecognizer: UIPanGestureRecognizer, screenGestureEnabled: Bool = false) {
        guard let presentedView = self.presentedView else { return }
        let translationPoint = panRecognizer.translation(in: presentedView)

        guard shouldPan(screenGestureEnabled: screenGestureEnabled, translationPoint: translationPoint.x) else {
            return
        }

        switch panRecognizer.state {
        case .began, .changed:
            if originX == nil {
                originX = presentedView.frame.origin.x
            }
            if screenGestureEnabled {
                presentedView.frame.origin.x = isRTL ? (containerView?.bounds.width ?? 0) + translationPoint.x :
                    (-presentedViewWidth + translationPoint.x)
                let translationX = presentedViewWidth - abs(translationPoint.x)
                configureDimmingViewAlpha(for: translationX)
            } else {
                presentedView.frame.origin.x = translationPoint.x + (originX ?? 0)
                configureDimmingViewAlpha(for: translationPoint.x)
            }
        case .ended:
            if screenGestureEnabled {
                animateForScreenGesture(translationPoint)
            } else {
                let dragDirection = DragDirection(viewWidth: presentedView.bounds.width, translationX: translationPoint.x, isRTL: isRTL)
                shouldDismiss(dragDirection: dragDirection)
                    ? dismiss()
                    : animate(to: dragDirection)
            }
        case .possible, .cancelled, .failed:
            break
        }
    }

    private func animateForScreenGesture(_ translationPoint: CGPoint) {
        let absoluteTranslationPointInXAxis = abs(translationPoint.x)
        let halfPresentedViewWidth = abs(presentedViewWidth / 2.0)
        if isRTL == false {
            absoluteTranslationPointInXAxis >= halfPresentedViewWidth
                ? animate(to: .right)
                : dismiss()
        } else {
            let originX: CGFloat = (containerView?.bounds.width ?? 0) - presentedViewWidth
            absoluteTranslationPointInXAxis >= halfPresentedViewWidth
                ? animate(to: originX)
                : dismiss()
        }
    }

    func shouldPan(screenGestureEnabled: Bool, translationPoint: CGFloat) -> Bool {
        switch (isRTL, screenGestureEnabled) {
        case (false, true) where translationPoint >= presentedViewWidth:
            return false
        case (false, false) where translationPoint >= 0:
            return false
        case (true, true) where translationPoint <= -presentedViewWidth:
            return false
        case (true, false) where translationPoint <= 0:
            return false
        default:
            return true
        }
    }

    private func configureDimmingViewAlpha(for translationPoint: CGFloat) {
        let ratio = (abs(presentedViewWidth) - abs(translationPoint)) / abs(presentedViewWidth)
        dimmingView?.alpha = min(max((ratio / 2), 0), 1)
    }

    private func animate(to dragDirection: DragDirection) {
        var offset: CGFloat = 0

        switch dragDirection {
        case .left:
            offset = isRTL ? (originX ?? 0) : (-1 * presentedViewWidth)
        case .right:
            offset = isRTL ? ((originX ?? 0) + presentedViewWidth) : 0
        }
        originX = nil

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.presentedView?.frame.origin.x = offset
            self.dimmingView?.alpha = self.shouldDismiss(dragDirection: dragDirection) ? 0 : 0.5
            })
    }

    private func animate(to offset: CGFloat) {
        originX = nil

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.presentedView?.frame.origin.x = offset
            self.dimmingView?.alpha = 0.5
        })
    }

    private func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension NavigationDrawerSwipeController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: presentedView)
        return presentedView?.bounds.contains(touchPoint) == false
    }
}

