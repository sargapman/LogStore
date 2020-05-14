//
//  LogTrigger.swift
//  LogStore Package
//
//  Created by Monty Boyer on 5/13/20.
//

import UIKit
import CoreMotion

public class LogTrigger {
    let window: UIWindow?
    let motionManager = CMMotionManager()
    
    public init(in window: UIWindow?) {
        
        // init the log, getting existing log if possible
        LogStore.setupLog()

        self.window = window
        
        // activate the delivery of motion events
        motionManager.startAccelerometerUpdates(to: .main) {
            [weak self] data, error in
            
            // get the motion event data
            guard let data = data else { return }
            
            // device quickly stopped after moving left?
            if data.acceleration.x < -5 {
                printLog("x acceleration: \(data.acceleration.x)")
                self?.presentLog()
            }
        }
    }
    
    func presentLog() {
        // get the currently visible VC
        let visibleVC = visibleViewController(from: window?.rootViewController)
        
        // create an instance of LogView and present it on top of the visible view
        let logViewController = LogViewController()
        visibleVC?.present(logViewController, animated: true)
    }
    
    // Use recursion to find the top most view controller.
    // We walk the view hierarchy from the bottom up to the top,
    // to the view controller of the visible view.
    func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        // guard let viewController = viewController else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return visibleViewController(from: navigationController.topViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }
        
        if let presentedViewController = viewController?.presentingViewController {
            return visibleViewController(from: presentedViewController)
        }
        
        return viewController
    }

    
}
