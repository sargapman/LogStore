//
//  TriggerWindow.swift
//  
//
//  Created by Monty Boyer on 5/4/20.
//

import UIKit
import CoreMotion

public class TriggerWindow: UIWindow {
    let motionManager = CMMotionManager()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // init the log, getting existing log if possible
        LogStore.setupLog()
        
        // activate the delivery of motion events
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
            [unowned self] data, error in       // tell the compiler with [unowned self] that this closure                                       should not increase the reference count of self.
            
            // get the motion data
            guard let data = data else { return }
            
            // device quickly stopped after moving left?
            if data.acceleration.x < -5 {
                print("x acceleration: \(data.acceleration.x)")
                self.presentLog()
            }
        }
    }
    
    // this is required by UIView but it should never be called
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Use recursion to find the top most view controller.
    // We walk the view hierarchy from the bottom up to the top,
    // to the view controller of the visible view.
    func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        guard let viewController = viewController else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return visibleViewController(from: navigationController.topViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }
        
        if let presentedViewController = viewController.presentingViewController {
            return visibleViewController(from: presentedViewController)
        }
        
        return viewController
    }

    func presentLog() {
        let logViewController = LogViewController()
        
        // get the currently visible view controller
        // let visibleVC = self.visibleViewController(from: self.rootViewController)
        let visibleVC = visibleViewController(from: rootViewController)

        // present the log VC on top of it
        visibleVC?.present(logViewController, animated: true, completion: nil)
        
        // Note that the log is presented modally so it can be dismissed by swiping down from the top
    }
    
}

