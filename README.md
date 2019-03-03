# Slidoo

[![CI Status](https://img.shields.io/travis/mitul_manish/Slidoo.svg?style=flat)](https://travis-ci.org/mitul_manish/Slidoo)
[![Version](https://img.shields.io/cocoapods/v/Slidoo.svg?style=flat)](https://cocoapods.org/pods/Slidoo)
[![License](https://img.shields.io/cocoapods/l/Slidoo.svg?style=flat)](https://cocoapods.org/pods/Slidoo)
[![Platform](https://img.shields.io/cocoapods/p/Slidoo.svg?style=flat)](https://cocoapods.org/pods/Slidoo)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Xcode 10.0+
- iOS 9.0+
- Swift 4.2+

## Setup

### GIF

|Left to Right|Right to Left|
|---|---|
|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/LTR-gif2.gif?alt=media&token=fbf0cc5b-27b2-4ba8-883b-37d8fab79642)|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/RTL_gif.gif?alt=media&token=383c301c-87ce-421a-836b-81848f6fdc8e)|

### Screenshots

Left to Right

|Portrait|Landscape|
|---|---|
|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/LTR-P.png?alt=media&token=526191d7-ef06-4524-a64b-701d219bddcb)|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/LTR-L.png?alt=media&token=4bf85324-08b6-4607-b077-1cec73979d81)|

Right to Left

|Portrait|Landscape|
|---|---|
|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/RTL-P.png?alt=media&token=2b7c3597-0e4c-4ee3-bca7-8872d6040ce5)|![Screenshot](https://firebasestorage.googleapis.com/v0/b/instafire-8f7b1.appspot.com/o/RTL-L.png?alt=media&token=7326f1a4-6fcb-4233-9159-b99e751cca35)|

### Adding the `Transition Delegate`
This class provides the custom presentation controller and animator classes responsible for presenting and dismissing the view controller

```
import UIKit
import Slidoo

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
```

### Using the `Transition Delegate`

```
        let presentedVC = DrawerViewController()
        presentedViewControllerTransitionAnimator = nil
        presentedViewControllerTransitionAnimator = NavigationDrawerTransitionDelegate(supportAnimation: supportAnimation)
        presentedVC.transitioningDelegate = presentedViewControllerTransitionAnimator
        presentedVC.modalPresentationStyle = .custom
        present(presentedVC, animated: true)
```

When user perform a certain action like a button tap, we would like to open the Sliding View or the Drawer with an animation. Use the code above to set the up the transition delegate on the presented view controller.

### Open the Sliding View or Drawer on screen swipe

1. Set up the screen gesture recognizer

```
        let screenEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan(panRecognizer:)))
        screenEdgeGesture.edges = view.isRTL ? .right : .left
        view.addGestureRecognizer(screenEdgeGesture)
```

2. Detect the swipe

```
@objc func didPan(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            presentMenu(supportAnimation: false)
        default:
            forwardPanGesture(panRecognizer)
        }
}
```

3. Pass the Gesture Recognizer object to the custom presentation controller

```
func forwardPanGesture(_ panRecognizer: UIPanGestureRecognizer) {
        if let presentedVC = presentedViewController as? DrawerViewController, let presentationController = presentedVC.presentationController as? NavigationDrawerSwipeController {
            presentationController.didPan(panRecognizer: panRecognizer, screenGestureEnabled: true)
        }
    }
```


## Installation

Slidoo is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Slidoo'
```

## Author

mitul_manish, mitul.manish@gmail.com

## License

Slidoo is available under the MIT license. See the LICENSE file for more info.
