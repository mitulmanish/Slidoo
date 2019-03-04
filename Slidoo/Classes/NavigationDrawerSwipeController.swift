//
//  NavigationDrawerSwipeController.swift
//  Slidoo
//
//  Created by Mitul Manish on 14/1/19.
//

public class NavigationDrawerSwipeController: UIPresentationController {

    private var originX: CGFloat?

    private var isRTL: Bool {
        return presentedView?.isRTL ?? false
    }

    private var presentedViewWidth: CGFloat {
        return presentedView?.bounds.width ?? 0
    }

    override public func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        let presentedViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        let containerViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        presentedView?.addGestureRecognizer(presentedViewPanGesture)
        containerView?.addGestureRecognizer(containerViewPanGesture)
        containerView?.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Helpers

extension NavigationDrawerSwipeController {
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

    private func shouldPan(screenGestureEnabled: Bool, translationPoint: CGFloat) -> Bool {
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

    private func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: Panning

extension NavigationDrawerSwipeController {
    @objc private func didTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let touchPointInPresentedView = tapGestureRecognizer.location(in: presentedView)
        guard presentedView?.bounds.contains(touchPointInPresentedView) == false else { return }
        dismiss()
    }

    @objc public func didPan(panRecognizer: UIPanGestureRecognizer, screenGestureEnabled: Bool = false) {
        containerView?.isHidden = false
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
}

// MARK: - Animation

extension NavigationDrawerSwipeController {
    private func animate(to dragDirection: DragDirection) {
        var offset: CGFloat = 0

        switch dragDirection {
        case .left:
            offset = isRTL ? (originX ?? 0) : (-1 * presentedViewWidth)
        case .right:
            offset = isRTL ? ((originX ?? 0) + presentedViewWidth) : 0
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.presentedView?.frame.origin.x = offset
            self.dimmingView?.alpha = self.shouldDismiss(dragDirection: dragDirection) ? 0 : 0.5
        }) { [weak self] _ in
            self?.originX = nil
        }
    }

    private func animate(to offset: CGFloat) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.presentedView?.frame.origin.x = offset
            self.dimmingView?.alpha = 0.5
        }) { [weak self] _ in
            self?.originX = nil
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
}
