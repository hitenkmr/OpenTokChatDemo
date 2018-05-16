//
//  Constants.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 05/05/2018.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import Foundation
import UIKit

//MARK: SINGLETONS

let Application                  = UIApplication.shared
let AppDelegate                  = Application.delegate as! OTAppDelegate
let NotificationCntr             = NotificationCenter.default
let Calendar                     =  NSCalendar.current
let MainBundle                   =  Bundle.main

//MARK: TOKBOX

let TOKBOXApiKey = ""
let TOKBOXAPISecretKey = ""

//MARK: Device

let IsPad   = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
let isiPadPro = IsPad && (UIScreen.main.bounds.size.height == 1024)

//MARK: Device Width & Heights

let CurrentDevice = UIDevice.current
let iOSVersion   = CurrentDevice.systemVersion

let WindowFrame = UIScreen.main.bounds
var ScreenWidth = WindowFrame.size.width
var ScreenHeight = WindowFrame.size.height

let DeviceWidth  = min(ScreenWidth, ScreenHeight)
let DeviceHeight = max(ScreenWidth,ScreenHeight)

let NavBarHeight   =          (20+44)
let SideBarWidth    =         IsPad ? 320 : 240
let MasterWidthForSplitVC =    320

let IsiPhone4SOr5S = ScreenHeight == 480 || ScreenHeight == 568
let IsIphoneSize35Inch = ScreenHeight == 480
let IsIphoneSize40Inch = ScreenHeight == 568
let IsIphoneSize47Inch = ScreenHeight == 667
let IsIphoneSize55Inch = ScreenHeight == 736
let IsIphoneX = ScreenHeight == 812

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}

//MARK: FONTS SIZE

let FontSizeDescription : CGFloat = IsPad ? 15.0 : 13.0
let FontSizeHeading : CGFloat = IsPad ? 18.0 : 16.0
let FontSizeHeadingTypeTwo : CGFloat = IsPad ? 20.0 : 18.0
let FontSizeReadMore : CGFloat = IsPad ? 15.0 : 13.0

//MARK: Colors

extension UIColor{
    class  func UIColorWithRGBA(r: CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat (r/255.0),
            green: CGFloat (g/255.0),
            blue: CGFloat (b/255.0),
            alpha: CGFloat(a)
        )
    }
}

let ColorMainBackground: UIColor = UIColor.UIColorWithRGBA(r: 247, g: 248, b: 249, a: 1.0)

let ColorSelectedPaymentCardBackgroundColor: UIColor   = UIColor.UIColorWithRGBA(r: 209, g: 242, b: 235, a: 1.0)
let ColorDeSelectedPaymentCardBackgroundColor: UIColor   = UIColor.UIColorWithRGBA(r: 236, g: 240, b: 241, a: 1.0)
let ColorSelectedPaymentCardContainerBorderColor: UIColor   = UIColor.UIColorWithRGBA(r: 112, g: 215, b: 195, a: 1.0)
let ColorDeSelectedPaymentCardContainerBorderColor: UIColor   = UIColor.UIColorWithRGBA(r: 220, g: 222, b: 222, a: 1.0)


let RatingViewTintColor : UIColor   = UIColor.UIColorWithRGBA(r: 241, g: 196, b: 13, a: 1.0)

let ColorTheme : UIColor = UIColor.UIColorWithRGBA(r: 46, g: 186, b: 157, a: 1.0)
//let ColorThemeHwNw : UIColor   = UIColor.UIColorWithRGBA(r: 46, g: 186, b: 157, a: 1.0)

let ColorWithCode_12_121_192 : UIColor   = UIColor.UIColorWithRGBA(r: 12, g: 121, b: 192, a: 1.0)
let ColorWithCode_44_44_44 : UIColor   = UIColor.UIColorWithRGBA(r: 44, g:44, b: 44, a: 1.0)
let ColorWithCode_74_74_74 : UIColor   = UIColor.UIColorWithRGBA(r: 74, g:74, b: 74, a: 1.0)
let ColorWithCode_8_92_147 : UIColor   = UIColor.UIColorWithRGBA(r: 8, g: 92, b: 147, a: 1.0)

let ColorBadge: UIColor   = UIColor.UIColorWithRGBA(r: 229, g: 99, b: 83, a: 1.0)
let ColorCertificate: UIColor   = UIColor.UIColorWithRGBA(r: 135, g: 166, b: 254, a: 1.0)

let LightGrayColor = UIColor.lightGray
let DarkGrayColor  = UIColor.darkGray
let ClearColor     = UIColor.clear
let WhiteColor     = UIColor.white
let BlackColor     = UIColor.black
let GreenColor     = UIColor.green
let RedColor       = UIColor.red

// MARK: Inline Helpers

func search(name: NSString, _ limits: Int) -> NSString {
    let urlEncodedName = name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    return "https://someURL.com/search?term=\(urlEncodedName)&limit=\(limits)" as NSString
}

func ReplaceOccurances(s : NSString, o : NSString,r : NSString) -> NSString{
    return (s.replacingOccurrences(of: o as String, with: r as String) as NSString)
}

func RemoveCommas(s : NSString) ->String{
    return (s.replacingOccurrences(of: "," as String, with:"" as String))
}

func RemoveSpaces(s : NSString) ->String{
    return (s.replacingOccurrences(of: " " as String, with:"" as String))
}

//func AttributedStringMutable(s: NSString, a: NSDictionary) -> NSMutableAttributedString{
//    return (NSMutableAttributedString.init(string: s as String, attributes: a as? [String : AnyObject]))
//}
//
//func AttributedString(s: NSString, a: NSDictionary) -> NSAttributedString{
//    return (NSAttributedString.init(string: s as String, attributes: a as? [String : AnyObject]))
//}

func Image(i: NSString) -> UIImage{
    return UIImage(named: i as String)!
}

func TemplateImage(imageNamed : String?) -> UIImage?{
    if imageNamed != nil {
        return (UIImage(named: imageNamed!))!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }else{
        return nil
    }
}

enum TabbarIcon: String {
    case tabbarIcon_courses
    case tabbarIcon_progress
    case tabbarIcon_messages
    case tabbarIcon_replay
    case tabbarIcon_settings
    func image(selected: Bool = false) -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

func Format(fmt : String) -> String {
    
    return String.init(fmt)
    
    //use
    // let floatVal: Float = 3.00
    
    //  let str : String =  Format(fmt: "\("this is : ")\(floatVal)")
}


//MARK: Custom Fonts

struct CustomFonts {
    struct ProximaNova {
        static let bold = "ProximaNova-Bold"
        static let regular = "ProximaNova-Regular"
    }
    
    struct Montserrat {
        static let bold = "Montserrat-Bold"
        static let medium = "Montserrat-Medium"
        static let regular = "Montserrat-Regular"
    }
}

