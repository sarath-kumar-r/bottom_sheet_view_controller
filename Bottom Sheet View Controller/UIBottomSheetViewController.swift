//
//  UIBottomSheetViewController.swift
//  Bottom Sheet View Controller
//
//  Created by Sarath Kumar Rajendran on 28/02/20.
//  Copyright © 2020 Sarath Christiano. All rights reserved.
//

import UIKit

class UIBottomSheetController: UIViewController, UIBottomSheetPresentable {
    
    var swipeInteractionController: UISwipeToDismissInteractionController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.swipeInteractionController = UISwipeToDismissInteractionController(viewController: self)
    }
}


protocol UIBottomSheetPresentable {
    
    var swipeInteractionController: UISwipeToDismissInteractionController! { get set }
}

class UISwipeToDismissInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    private let cancellationVelocity: CGFloat = 0.3
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        super.init()
        self.wantsInteractiveStart = true
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        guard let view = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: view)
        var progress = (translation.y / UIScreen.main.bounds.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > cancellationVelocity
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

extension UIViewController {
    
    func presentBottomSheet(_ vc: UIViewController, animated: Bool) {
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: animated, completion: nil)
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIBottomSheetPresenter()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let modalVc = dismissed as? UIBottomSheetPresentable {
            return UIBottomSheetDimisser(interactor: modalVc.swipeInteractionController)
        }
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? UIBottomSheetDimisser,
            let interactionController = animator.swipeIntractor
            else {
                return nil
        }
        if interactionController.interactionInProgress {
            return interactionController
        }
        return nil
    }
}

final class UIBottomSheetPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    
    var cornerRadius: CGFloat = 20
    var duration: TimeInterval = 1
    var heightRatio: CGFloat = 0.6
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to), let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        toView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(toView)
        
        let preferredContentSizeHeight = toViewController.preferredContentSize.height > 0 ? toViewController.preferredContentSize.height + cornerRadius: container.frame.height * heightRatio + cornerRadius
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[toView]|", options: [], metrics: nil, views: ["toView": toView])
        constraints.append(.init(item: toView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: cornerRadius))
        let heightConstraint = NSLayoutConstraint(item: toView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        constraints.append(heightConstraint)
        NSLayoutConstraint.activate(constraints)
        
        toView.layer.masksToBounds = true
        toView.layer.cornerRadius = cornerRadius
        
        container.layoutIfNeeded()
        heightConstraint.constant = preferredContentSizeHeight
        toView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            container.layoutIfNeeded()
            toView.alpha = 1
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

final class UIBottomSheetDimisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval = 1
    var swipeIntractor: UISwipeToDismissInteractionController!
    
    init(interactor: UISwipeToDismissInteractionController) {
        self.swipeIntractor = interactor
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame.origin.y += container.frame.height
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
