//
//  myCustomButton.swift
//  MovieApp
//
//  Created by Mac on 31.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class myCustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(color:UIColor , title:String , titleColor : UIColor? = nil) {
        self.init(frame:.zero)
        self.backgroundColor = color
        self.setTitleColor(titleColor, for: .normal)
        self.setTitle(title,for: .normal)
    }
    convenience init(image:UIImage){
        self.init(frame:.zero)
        self.setImage(image, for: .normal)
    }
    func roundedButton(value : Int){
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / CGFloat(value)
    }

}
