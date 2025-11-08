//
//  SceneDelegate.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 25.10.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var enviironment: AppEnvironment = .default
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = enviironment.presentation.rootModuleFactory.makeRootViewController()
        window.makeKeyAndVisible()
        self.window = window
    }


}

