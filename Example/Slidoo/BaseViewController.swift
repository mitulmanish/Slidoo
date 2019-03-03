import UIKit
import Slidoo

class BaseViewController: UIViewController {
    private var presentedViewControllerTransitionAnimator: NavigationDrawerTransitionDelegate?
    
    @IBOutlet weak var handButton: UIButton!
    
    @IBOutlet weak var swipeIndicatorButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func animateIndicators() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
                        self.handButton.center.y += 15.0
                        self.swipeIndicatorButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let screenEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan(panRecognizer:)))
        screenEdgeGesture.edges = view.isRTL ? .right : .left
        view.addGestureRecognizer(screenEdgeGesture)
        
        animateIndicators()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        animateIndicators()
    }
    // MARK: - Actions
    
    @objc func didPan(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            presentMenu(supportAnimation: false)
        case .changed, .ended:
            forwardPanGesture(panRecognizer)
        default:
            break
        }
    }
    
    @IBAction func buttonTouched(_ sender: UIBarButtonItem) {
        presentMenu(supportAnimation: true)
    }
}

// MARK: - Helpers

extension BaseViewController {
    private func forwardPanGesture(_ panRecognizer: UIPanGestureRecognizer) {
        if let presentedVC = presentedViewController as? DrawerViewController, let presentationController = presentedVC.presentationController as? NavigationDrawerSwipeController {
            presentationController.didPan(panRecognizer: panRecognizer, screenGestureEnabled: true)
        }
    }
    
    private func presentMenu(supportAnimation: Bool) {
        guard let presentedVC = getDrawerViewController() else { return }
        presentedViewControllerTransitionAnimator = nil
        presentedViewControllerTransitionAnimator = NavigationDrawerTransitionDelegate(supportAnimation: supportAnimation)
        presentedVC.transitioningDelegate = presentedViewControllerTransitionAnimator
        presentedVC.modalPresentationStyle = .custom
        present(presentedVC, animated: true)
    }
    
    private func getDrawerViewController() -> UIViewController? {
        return DrawerViewController()
    }
}
