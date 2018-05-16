//
//  StoryboardInstantiation.swift
//  OpenTokChatDemo
//
//  Created by Hitender Kumar on 08/05/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import UIKit

enum AppStoryboard : String{
    case  SB_Main = "Main"
}

class StoryboardInstantiation: NSObject {
    
    class func storyboardWithType(appStoryboard:AppStoryboard) -> UIStoryboard {
        var storyboard:UIStoryboard? = nil
        
        switch appStoryboard {
        case .SB_Main:
            let infoDict:NSDictionary = NSDictionary.init(dictionary: Bundle.main.infoDictionary!)
            let mainStoryboardName:NSString? = infoDict.object(forKey:"UIMainStoryboardFile") as? NSString
            if (mainStoryboardName == nil) {
                NSException(name:NSExceptionName(rawValue: "Couldn't find Main storyboard file."), reason:nil, userInfo:nil).raise()
            }
            storyboard = UIStoryboard.init(name: mainStoryboardName! as String, bundle: nil)
            break
         default:
            NSException(name:NSExceptionName(rawValue: "Couldn't find requested Storyboard file."), reason:nil, userInfo:nil).raise()
            break
        }
        return storyboard!
    }
}

extension UIViewController{
    class func instantiateWithStoryboard(appStoryboard:AppStoryboard) -> UIViewController {
        
        let storyboard:UIStoryboard = StoryboardInstantiation.storyboardWithType(appStoryboard: appStoryboard)
        let viewControllerName:String = "\(self)"
        return storyboard.instantiateViewController(withIdentifier: viewControllerName);
        
    }
}
