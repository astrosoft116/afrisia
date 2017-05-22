//
//  AfrisiaImage.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import Foundation
import UIKit

enum AfrisiaImage: String {

    
    // Research View
    case greenButtonIcon = "green_circle.png"
    case blackButtonIcon = "black_circle.png"
    case uncheckButtonIcon = "uncheck.png"
    case checkButtonIcon = "check.png"
    
    // Home View
    case favoritIcon = "favorit.png"
    case unfavoritIcon = "unfavorit.png"
    
    // Side View
    case defaultAvatar = "profile-pic-default.png"
    
    // Map View
    case favoritMapIcon = "favorit_map.png"
    case unfavoritMapIcon = "unfavorit_map.png"
    
    // Profile View
    case publicIcon = "public.png"
    case privateIcon = "secret.png"
  
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}

