//
//  PathConfigration.swift
//  MovieApp
//
//  Created by Mac on 3.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
enum Page{
    case LatestMovie
    case TopRatedMovies
    case PopularMovies
    case UpcomingMovies
    case DiscoverMovies
    case Search
}
struct PathConfigration {
    static func seguePage(type page:Page ,params :Any?){
        let menuViewController = MenuViewController()
        if page == .LatestMovie {
            menuViewController.setChildren(LatestViewController())
        }
        else if page == .TopRatedMovies {
            menuViewController.setChildren(TopRatedMovies())
        }
        else if page == .DiscoverMovies{
            menuViewController.setChildren(DiscoverMoviesVC())
        }
        else if page == .PopularMovies {
            menuViewController.setChildren(PopularMoviesVC())
        }
        else if page == .Search{
            menuViewController.setChildren(SearchVC())
        }
        else if page == .UpcomingMovies{
            menuViewController.setChildren(UpComingVC())
        }
        else{
            print("Something went wrong...")
        }
        self.animate(controller: menuViewController)
    }
   static private func animate(controller : UIViewController){
        guard let scene = UIApplication.shared.connectedScenes.first else{return}
        guard let sceneDelegate = scene.delegate as? SceneDelegate else{return}
        guard let window = sceneDelegate.window else{return}
    UIView.transition(with: window, duration: 0.9, options: .transitionFlipFromTop, animations: {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [controller]
            navigationController.navigationBar.isHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        })
    }
}
