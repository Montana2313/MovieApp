//
//  UserDefaultsConfiguration.swift
//  MovieApp
//
//  Created by Mac on 3.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

struct UserDefaultsConfiguration  {
    static func setValue(key:String , value:Any){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func getBool(key:String)->Bool{
        return UserDefaults.standard.bool(forKey: key)
    }
}

