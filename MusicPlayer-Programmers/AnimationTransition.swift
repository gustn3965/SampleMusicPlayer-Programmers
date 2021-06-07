//
//  AnimationTransition.swift
//  MusicPlayer-Programmers
//
//  Created by hyunsu on 2021/06/05.
//

import UIKit

class AnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isMusicView = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isMusicView {
            guard let toView = transitionContext.viewController(forKey: .to)?.view
            else  { return }
            toView.alpha = 0.0
            let container = transitionContext.containerView
            container.addSubview(toView)
            
            UIView.animate(withDuration: 0.2) {
                toView.alpha = 1.0
            } completion: { complete in
                transitionContext.completeTransition(complete)
            }
        } else {
            guard let fromView = transitionContext.viewController(forKey: .from)?.view
            else  { return }
            
            UIView.animate(withDuration: 0.2) {
                fromView.alpha = 0.0
            } completion: { complete in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(complete)
            }
        }
    }
}
