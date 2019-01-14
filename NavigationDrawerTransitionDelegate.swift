import UIKit

class NavigationDrawerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private let supportAnimation: Bool

    init(supportAnimation: Bool) {
        self.supportAnimation = supportAnimation
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return NavigationDrawerSwipeController(presentedViewController: presented, presenting: source)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NavigationDrawerPresentationAnimator(isBeingPresented: true, supportAnimation: supportAnimation)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NavigationDrawerPresentationAnimator(isBeingPresented: false, supportAnimation: supportAnimation)
    }
}
