//
//  AppDelegate.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var treeWindows: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .statusBar - 0.1
        return window
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension UIViewController {
    
    func startViewTree() {
        guard let w = (UIApplication.shared.delegate as? AppDelegate)?.treeWindows else { return }
        w.rootViewController = UINavigationController()
        w.rootViewController?.view.backgroundColor = UIColor.clear
        w.isHidden = false
        w.makeKeyAndVisible()
        
        w.rootViewController?.present(UINavigationController(rootViewController: self), animated: true, completion: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target:self, action: #selector(endViewTree))
    }
    
    @objc func endViewTree() {
        guard let w = (UIApplication.shared.delegate as? AppDelegate)?.treeWindows else { return }
        self.dismiss(animated: true) {
            w.isHidden = true
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        }
    }
}
