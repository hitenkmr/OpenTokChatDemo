//
//  UIViewController+Loading.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 19/06/17.
//  Copyright © 2017 Hitender kumar. All rights reserved.
//

import Foundation
import UIKit

typealias OkClickedCompletion = ((_ finished : Bool) -> ())?
typealias CancelClickedCompletion = ((_ finished : Bool) -> ())?
typealias CameraClickedCompletion = ((_ finished : Bool) -> ())?
typealias ChoosePhotoClickedCompletion = ((_ finished : Bool) -> ())?


extension UIViewController {
    
    //MARK: Show/Hide Keyboard
    
    func autoHideKeybordOnTappingAnyWhere() {
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: Alerts
    
    func showAlertWith(title : String?, message : String?) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default) { (alertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        okAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithOkCompletion(title : String?, message : String?, okClickedCompletion : OkClickedCompletion) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default) { (alertAction) in
            alertController.dismiss(animated: true, completion: nil)
            if okClickedCompletion != nil{
                okClickedCompletion!(true)
            }
        }
        
        okAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWith(title : String?, message : String?, okActionTitle : String?, cancelActionTitle : String?, okClickedCompletion : OkClickedCompletion,  cancelClickedCompletion : CancelClickedCompletion) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction.init(title: okActionTitle, style: UIAlertActionStyle.default, handler: { (okAlert) in
            if okClickedCompletion != nil{
                okClickedCompletion!(true)
            }
        })
        
        okAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction.init(title: cancelActionTitle, style: UIAlertActionStyle.default, handler: { (okAlert) in
            if cancelClickedCompletion != nil{
                cancelClickedCompletion!(true)
            }
        })
        
        cancelAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        if cancelActionTitle != nil {
            alertController.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showActionSheetForPhotosAccessWith(sourceRect : CGRect, showDeleteButton : Bool, title : String?, message : String?, cancelActionTitle : String?,  cameraClickedCompletion : ((_ finished : Bool) -> ())?, deletePhotoCompletion : ((_ finished : Bool) -> ())?, choosePhotoClickedCompletion : ((_ finished : Bool) -> ())?,  cancelClickedCompletion : ((_ finished : Bool) -> ())?) -> UIAlertController? {
        
        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //titleTextColor
        
        if showDeleteButton {
            let deletePhotoAction = UIAlertAction.init(title: "Delete Photo", style: .default) { (deleteAlertAction) in
                if deletePhotoCompletion != nil{
                    deletePhotoCompletion!(true)
                }
            }
            deletePhotoAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
            actionSheetController.addAction(deletePhotoAction)
        }
        
        let takePhotoAction = UIAlertAction.init(title: "Take Photo", style: .default) { (takePhotoAlertAction) in
            if cameraClickedCompletion != nil{
                cameraClickedCompletion!(true)
            }
        }
        takePhotoAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        let choosePhotoAction = UIAlertAction.init(title: "Choose Photo", style: .default) { (choosePhotoAlertAction) in
            if choosePhotoClickedCompletion != nil{
                choosePhotoClickedCompletion!(true)
            }
        }
        choosePhotoAction.setValue(ColorWithCode_12_121_192, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction.init(title: cancelActionTitle, style: .cancel) { (cancelAlertAction) in
            if cancelClickedCompletion != nil{
                cancelClickedCompletion!(true)
            }
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(choosePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            if IsPad {
                actionSheetController.popoverPresentationController?.sourceView = self.view
                actionSheetController.popoverPresentationController?.sourceRect = sourceRect
            }
            self.present(actionSheetController, animated: true, completion: nil)
        }
        return actionSheetController
    }
}

