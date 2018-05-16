//
//  OTAppDelegate.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 05/05/2018.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import UIKit

@UIApplicationMain
class OTAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var AppThemeColor : UIColor = DarkGrayColor


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppThemeColor = UIColor.green
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    var orientationLock = IsPad ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func formattedLocalDateStringWith(dateStr : String, dateFormat : String, requiredDateFormat : String) ->  String {
        var locaLDateString = ""
        let components = dateStr.components(separatedBy: ".")
        let actualDateStr = components[0] + "Z"
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: actualDateStr)!
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = requiredDateFormat
        locaLDateString = dateFormatter.string(from: date)
        return locaLDateString
    }
    
    func attrubutedTextWithAttributes(_ letterSpacing : CGFloat, lineHeight : CGFloat, fontName : String, fontSize : CGFloat, underline : Int, textColor : UIColor, originalString : String) -> NSMutableAttributedString {
        
        let attributedStr = NSMutableAttributedString.init(string: originalString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.minimumLineHeight = lineHeight // Whatever line spacing you want in points
        attributedStr.addAttributes([NSAttributedStringKey.kern : CGFloat(letterSpacing), NSAttributedStringKey.foregroundColor : textColor, NSAttributedStringKey.paragraphStyle : paragraphStyle, NSAttributedStringKey.underlineStyle : underline ,NSAttributedStringKey.font : UIFont.init(name: fontName, size: fontSize) as Any], range: NSRange.init(location: 0, length: attributedStr.length))
        
        return attributedStr
    }
    
    func normalAttrubutedTextWithAttributes(_ fontName : String, fontSize : CGFloat, textColor : UIColor, originalString : String) -> NSMutableAttributedString {
        
        let attributedStr = NSMutableAttributedString.init(string: originalString)
        
        attributedStr.addAttributes([NSAttributedStringKey.foregroundColor : textColor, NSAttributedStringKey.font : UIFont.init(name: fontName, size: fontSize) as Any], range: NSRange.init(location: 0, length: attributedStr.length))
        
        return attributedStr
    }
    
    func heightFor(attributedStr : NSMutableAttributedString, boundingWidth : CGFloat) -> CGFloat {
        
        let rect = attributedStr.boundingRect(with: CGSize.init(width: boundingWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return rect.height
    }

}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? OTAppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}

