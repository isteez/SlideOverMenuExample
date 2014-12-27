//
//  ContainerViewController.swift
//  SlideOverMenuExample
//
//  Created by Stephen Kyles on 12/5/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate, UIGestureRecognizerDelegate {
    var centerViewController: CenterViewController!
    var currentState: SlideOutState = .BothCollapsed
    var rightViewController: SidePanelViewController?
    var centerPanelExpandedOffset: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerPanelExpandedOffset = view.frame.width/5
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        centerViewController.centerPanelExpandedOffset = centerPanelExpandedOffset
        
        view.addSubview(centerViewController.view)
        addChildViewController(centerViewController)
        
        centerViewController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        setupRightPanel()
    }
    
    func setupRightPanel() {
        addRightPanelViewController()
        currentState = .RightPanelExpanded
        self.centerViewController.view.frame.origin.x = -CGRectGetWidth(centerViewController.view.frame)
    }
    
    // MARK: CenterViewController delegate methods
    
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .RightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .RightPanelExpanded:
            toggleRightPanel()
        default:
            break
        }
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            
            addChildSidePanelController(rightViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = centerViewController
        
        var nav = UINavigationController(rootViewController: sidePanelController)

        view.insertSubview(nav.view, atIndex: 0)
        
        addChildViewController(nav)
        nav.didMoveToParentViewController(self)
    }
    
    func animateRightPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .RightPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerViewController.view.frame))
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        } else {
            animateCenterPanelXPosition(targetPosition: -centerPanelExpandedOffset) { _ in
                self.currentState = .BothCollapsed
            }
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        // we can determine whether the user is revealing the left or right
        // panel by looking at the velocity of the gesture
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .BothCollapsed) {
                // If the user starts panning, and neither panel is visible
                // then show the correct panel based on the pan direction
                
                if (!gestureIsDraggingFromLeftToRight) {
                    collapseSidePanels()
                }
            }
        case .Changed:
            // If the user is already panning, translate the center view controller's
            // view by the amount that the user has panned
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            // When the pan ends, check whether the left or right view controller is visible
            let hasMovedGreaterThanHalfway = (recognizer.view!.center.x - centerPanelExpandedOffset) < 0
            animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
        default:
            break
        }
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
}