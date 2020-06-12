//
//  MenuViewController.swift
//  MovieApp//
//  Created by Mac on 31.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//
import UIKit

class MenuViewController: UIViewController {
    var menuButton = myCustomButton(image: UIImage(named: "menübutton")!)
    private let leftMenüView = MenuView()
    private var screenStatus = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuButton()
        self.view.addSubview(self.leftMenüView)
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController(title: "Information", message: "No internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
         }
    }
    private func setupMenuButton(){
        self.menuButton.frame = CGRect(x: 20, y: 50, width: 50, height: 50)
        self.menuButton.roundedButton(value: 2)
       self.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    func setChildren(_  vc : UIViewController){
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.addSubview(self.menuButton)
    }
    @objc private func menuButtonTapped(){
        guard let lastViewController = self.children.last  else {return}
        UIView.animate(withDuration: 1.0) {
           if self.screenStatus == false {
            lastViewController.view.frame = CGRect(x: (ScreenConfigration.halfScreenWidth), y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.height)
               self.screenStatus = true
           }else {
            lastViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.height)
               self.screenStatus = false
           }
        }
        self.leftMenüView.animate(position: self.screenStatus)
    }
}
