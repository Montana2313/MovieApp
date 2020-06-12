//
//  ScreenConfigraion.swift
//  MovieApp
//
//  Created by Mac on 31.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

enum Phones {
    case iPhoneXR
    case iPhoneX
    case iPhoneXSMax
    case iPhone8Plus
    case iPhone8
    case iPhoneSE
    case Hata
}
struct ScreenConfigration {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let halfScreenWidth = UIScreen.main.bounds.size.width / 2
    static let halfScreenHeight = UIScreen.main.bounds.size.height / 2
    static func phoneType()->Phones{
            let screenWidth = ScreenConfigration.screenWidth
            let screenHeight = ScreenConfigration.screenHeight
            if screenWidth == 414.0 && screenHeight == 896.0{
                return .iPhoneXR
            }else if screenWidth == 375.0 && screenHeight == 812.0{
                return .iPhoneX
            }else if screenWidth == 414.0 && screenHeight == 896.0 {
                return .iPhoneXSMax
            }else if screenWidth == 414.0 && screenHeight == 736.0{
                return .iPhone8Plus
            }else if screenWidth == 375.0 && screenHeight == 667.0{
                return .iPhone8
            }else if screenWidth == 320.0 && screenHeight == 568.0{
                return .iPhoneSE
            }else {
                return .Hata
            }
    }
    static func height(text: String?, width: CGFloat) -> CGFloat {
        
        var currentHeight: CGFloat!
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        
        return currentHeight
    }
}
