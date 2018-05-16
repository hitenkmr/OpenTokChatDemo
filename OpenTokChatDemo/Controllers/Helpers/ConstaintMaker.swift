//
//  ConstaintMaker.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 19/06/17.
//  Copyright © 2017 Hitender kumar. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

//http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically

extension UIView
{
    private struct Keys {
        static var TopSpaceConstraint = "TopSpaceConstraint"
        static var BottomSpaceConstraint = "BottomSpaceConstraint"
        static var LeadingSpaceConstraint = "LeadingSpaceConstraint"
        static var TrailingSpaceConstraint = "TrailingSpaceConstraint"
        static var HeightConstraint = "HeightConstraint"
        static var WidthConstraint = "WidthConstraint"
        static var verticalSpaceConstraint = "verticalSpaceConstraint"

    }
    
    var topSpaceConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.TopSpaceConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.TopSpaceConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.TopSpaceConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bottomSpaceConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.BottomSpaceConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.BottomSpaceConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.BottomSpaceConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var leadingSpaceConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.LeadingSpaceConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.LeadingSpaceConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.LeadingSpaceConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var trailingSpaceConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.TrailingSpaceConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.TrailingSpaceConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.TrailingSpaceConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.HeightConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.HeightConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.HeightConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.WidthConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.WidthConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.WidthConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var verticalSpaceConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &Keys.verticalSpaceConstraint) as? NSLayoutConstraint
        }
        set (newValue) {
            objc_setAssociatedObject(self, &Keys.verticalSpaceConstraint, nil,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            objc_setAssociatedObject(self, &Keys.verticalSpaceConstraint, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func prepareForNewConstraints(block : ((UIView?) -> ())!)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        block(self)
    }
    
    //MARK:- Auto Center
    
    func autoCenterInSuperView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pinHeightConstraint(constant: self.frame.size.height)
        self.pinHeightConstraint(constant: self.frame.size.width)
        self.superview?.addConstraints([self.horizontalCenterToView(view: self.superview! , multiplier: 1),self.verticalCenterToView(view: self.superview!
            , multiplier: 1)])
    }
    
    func autoCenterToView(view:UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pinHeightConstraint(constant: self.frame.size.height)
        self.pinHeightConstraint(constant: self.frame.size.width)
        self.superview?.addConstraints([self.horizontalCenterToView(view: view , multiplier: 1),self.verticalCenterToView(view: view
            , multiplier: 1)])
    }
    
    func centerHorizontallyInSuperView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraints([self.horizontalCenterToView(view: self.superview! , multiplier: 1)])
    }
    
    func centerHorizontallyInSuperViewWithMultiplier(multiplier:CGFloat)
    {
         self.translatesAutoresizingMaskIntoConstraints = false
         self.superview?.addConstraints([self.horizontalCenterToView(view: self.superview! , multiplier: multiplier)])
    }
   //////check this method 
    
    func centerHorizontallyWithView(view:UIView)
    {
         self.translatesAutoresizingMaskIntoConstraints = false
         view.addConstraints([self.horizontalCenterToView(view: view, multiplier: 1)])
    }
    
    func centerHorizontallyWithViewAndMultiplier(view:UIView, multiplier:CGFloat)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([self.horizontalCenterToView(view: view, multiplier: multiplier)])
    }
    
    func centerVerticallyInSuperView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraints([self.verticalCenterToView(view: self.superview! , multiplier: 1)])
    }
    
    func centerVerticallyWithView(view:UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([self.verticalCenterToView(view: view, multiplier: 1)])
    }
    
    func centerVerticallyInSuperViewWithMultiplier(multiplier:CGFloat)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraints([self.verticalCenterToView(view: self.superview! , multiplier: multiplier)])
    }
    
    func centerVerticallyWithViewAndMultiplier(view:UIView, multiplier:CGFloat)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([self.verticalCenterToView(view: view, multiplier: multiplier)])
    }
    
    //MARK:- Set Auto Pin Edges
    
    func autoPinEdgesToSuperView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraints([self.topSpaceToSuperView(constant: 0, multiplier: 1),
                                        self.bottomSpaceToSuperView(constant: 0, multiplier: 1),
                                        self.leadingSpaceToSuperView(constant: 0, multiplier: 1),
                                        self.trailingSpaceToSuperView(constant: 0, multiplier: 1)])
    }
    
    func autoPinEdgesToSuperViewWithEdgeInsets(edgeInsets:UIEdgeInsets) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addConstraints([self.topSpaceToSuperView(constant: edgeInsets.top, multiplier: 1),
                                        self.bottomSpaceToSuperView(constant: edgeInsets.bottom, multiplier: 1),
                                        self.leadingSpaceToSuperView(constant: edgeInsets.left, multiplier: 1),
                                        self.trailingSpaceToSuperView(constant: edgeInsets.right, multiplier: 1)])
    }
    
    
    //MARK:- Set Leading Space Constraint
    
    func setLeadingSpaceFromSuperView(leadingSpace:CGFloat)
    {
        self.leadingSpaceConstraint = self.leadingSpaceToSuperView(constant: leadingSpace, multiplier: 1)
        self.superview?.addConstraint(self.leadingSpaceConstraint!)
    }
    
    func setLeadingSpaceFromSuperViewWithMultiplier(leadingSpace:CGFloat,multiplier:CGFloat)
    {
        self.leadingSpaceConstraint = self.leadingSpaceToSuperView(constant: leadingSpace, multiplier: 1)
        self.superview?.addConstraint(self.leadingSpaceConstraint!)
    }
    
    func setLeadingSpaceFromNearestNeighbour(leadingSpace:CGFloat,nearestNeighbour:UIView)
    {
        self.leadingSpaceConstraint = self.leadingSpace(constant: leadingSpace, nearestNeighbour: nearestNeighbour, multiplier: 1)
        self.superview?.addConstraint(self.leadingSpaceConstraint!)
    }
    
    func setLeadingSpaceFromNearestNeighbourWithMultiplier(leadingSpace:CGFloat,nearestNeighbour:UIView,multiplier:CGFloat)
    {
        self.leadingSpaceConstraint = self.leadingSpace(constant:leadingSpace, nearestNeighbour: nearestNeighbour, multiplier:multiplier)
        self.superview?.addConstraint(self.leadingSpaceConstraint!)
    }
    
    //MARK:- Set Trailing Space Constraint
    
    func setTrailingSpaceFromSuperView(trailingSpace:CGFloat)
    {
        self.trailingSpaceConstraint = self.trailingSpaceToSuperView(constant: trailingSpace, multiplier: 1)
        self.superview?.addConstraint(self.trailingSpaceConstraint!)
    }
    
    func setTrailingSpaceFromSuperViewWithMultiplier(trailingSpace:CGFloat,multiplier:CGFloat)
    {
        self.trailingSpaceConstraint = self.trailingSpaceToSuperView(constant: trailingSpace, multiplier: 1)
        self.superview?.addConstraint(self.trailingSpaceConstraint!)
    }
    
    func setTrailingSpaceFromNearestNeighbour(trailingSpace:CGFloat,nearestNeighbour:UIView)
    {
        self.trailingSpaceConstraint = self.trailingSpace(constant: trailingSpace, nearestNeighbour: nearestNeighbour, multiplier: 1)
        self.superview?.addConstraint(self.trailingSpaceConstraint!)
    }
    
    func setTrailingSpaceFromNearestNeighbourWithMultiplier(trailingSpace:CGFloat,nearestNeighbour:UIView,multiplier:CGFloat)
    {
        self.trailingSpaceConstraint = self.trailingSpace(constant:trailingSpace, nearestNeighbour: nearestNeighbour, multiplier:multiplier)
        self.superview?.addConstraint(self.trailingSpaceConstraint!)
    }
    
    
    //MARK:- Set Top Space Constraint
    
    func setTopSpaceFromSuperView(topSpace:CGFloat)
    {
        self.topSpaceConstraint = self.topSpaceToSuperView(constant: topSpace, multiplier: 1)
        self.superview?.addConstraint(self.topSpaceConstraint!)
    }
    
    func setTopSpaceFromSuperViewWithMultiplier(topSpace:CGFloat,multiplier:CGFloat)
    {
        self.topSpaceConstraint = self.topSpaceToSuperView(constant: topSpace, multiplier: 1)
        self.superview?.addConstraint(self.topSpaceConstraint!)
    }
    
    func setTopSpaceFromNearestNeighbour(topSpace:CGFloat,nearestNeighbour:UIView)
    {
        self.topSpaceConstraint = self.topSpace(constant: topSpace, nearestNeighbour: nearestNeighbour, multiplier: 1)
        self.superview?.addConstraint(self.topSpaceConstraint!)
    }
    
    func setTopSpaceFromNearestNeighbourWithMultiplier(topSpace:CGFloat,nearestNeighbour:UIView,
                                                          multiplier:CGFloat)
    {
        self.topSpaceConstraint = self.topSpace(constant: topSpace, nearestNeighbour: nearestNeighbour, multiplier:multiplier)
        self.superview?.addConstraint(self.topSpaceConstraint!)
    }
    
    
    //MARK:- Set Bottom Space Constraint
    
    func setBottomSpaceFromSuperView(bottomSpace:CGFloat)
    {
        self.bottomSpaceConstraint = self.bottomSpaceToSuperView(constant: bottomSpace, multiplier: 1)
        self.superview?.addConstraint(self.bottomSpaceConstraint!)
    }
    
    func setBottomSpaceFromSuperViewWithMultiplier(bottomSpace:CGFloat,multiplier:CGFloat)
    {
        self.bottomSpaceConstraint = self.bottomSpaceToSuperView(constant: bottomSpace, multiplier: 1)
        self.superview?.addConstraint(self.bottomSpaceConstraint!)
    }
    
    func setbottomSpaceFromNearestNeighbour(bottomSpace:CGFloat,nearestNeighbour:UIView)
    {
        self.bottomSpaceConstraint = self.bottomSpace(constant: bottomSpace, nearestNeighbour: nearestNeighbour, multiplier: 1)
        self.superview?.addConstraint(self.bottomSpaceConstraint!)
    }
    
    func setbottomSpaceFromNearestNeighbourWithMultiplier(bottomSpace:CGFloat,nearestNeighbour:UIView,
                                                          multiplier:CGFloat)
    {
        self.bottomSpaceConstraint = self.bottomSpace(constant: bottomSpace, nearestNeighbour: nearestNeighbour, multiplier:multiplier)
        self.superview?.addConstraint(self.bottomSpaceConstraint!)
    }
    
    //MARK:- Set Width Constraints
    
    func pinWidthConstraint(constant:CGFloat)
    {
        self.widthConstraint = self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView:nil, relatedAttribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant:constant)
        self.superview?.addConstraint(self.widthConstraint!)
    }
    
    func setEqualWidthToSuperView()
    {
        self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
    }
    
    func setEqualWidthToSuperViewWithConstant(constant:CGFloat)
    {
        self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: 1, constant: constant))
    }
    
    func setEqualWidthToSuperViewWithMultiplier(multiplier:CGFloat)
    {
        self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: multiplier, constant: 0))
    }
    
    func setEqualWidthToView(view:UIView)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
    }
    
    func setEqualWidthToViewWithMultiplier(view:UIView, multiplier:CGFloat)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: multiplier, constant: 0))
    }
    
    func setEqualWidthToViewWithConstant(view:UIView, constant:CGFloat)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.width, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.width, multiplier: 1, constant: constant))
    }
    
    
    
    //MARK:- Set Height Constraints
    
    func pinHeightConstraint(constant:CGFloat)
    {
        self.heightConstraint = self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView:nil, relatedAttribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant:constant)
        self.superview?.addConstraint(self.heightConstraint!)
    }
    
    func setEqualHeightToSuperView()
    {
        self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
    }
    
    func setEqualHeightToSuperViewWithConstant(constant:CGFloat)
    {
         self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: 1, constant: constant))
    }
    
    func setEqualHeightToSuperViewWithMultiplier(multiplier:CGFloat)
    {
         self.superview?.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: multiplier, constant: 0))
    }
    
    func setEqualHeightToView(view:UIView)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
    }
    
    func setEqualHeightToViewWithMultiplier(view:UIView, multiplier:CGFloat)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: multiplier, constant: 0))
    }
    
    func setEqualHeightToViewWithConstant(view:UIView, constant:CGFloat)
    {
        view.addConstraint(self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.height, relatedView: self.superview, relatedAttribute: NSLayoutAttribute.height, multiplier: 1, constant: constant))
    }
    
    //MARK:- Top Space
    
    func topSpace(constant:CGFloat, nearestNeighbour:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.top, relatedView: nearestNeighbour, relatedAttribute: NSLayoutAttribute.bottom, multiplier: multiplier, constant:constant)
    }
    
    func topSpaceToSuperView(constant:CGFloat, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.top, relatedView: self.superview!, relatedAttribute: NSLayoutAttribute.top, multiplier: multiplier, constant:constant)
    }
    
    
    //MARK:- Bottom Space
    
    func bottomSpace(constant:CGFloat, nearestNeighbour:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.bottom, relatedView: nearestNeighbour, relatedAttribute: NSLayoutAttribute.top, multiplier: multiplier, constant:constant)
    }
    
    func bottomSpaceToSuperView(constant:CGFloat, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.bottom, relatedView: self.superview!, relatedAttribute: NSLayoutAttribute.bottom, multiplier: multiplier, constant:constant)
    }
    
    //MARK:- Leading Space
    
    func leadingSpace(constant:CGFloat, nearestNeighbour:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.leading, relatedView: nearestNeighbour, relatedAttribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant:constant)
    }
    
    func leadingSpaceToSuperView(constant:CGFloat, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.leading, relatedView: self.superview!, relatedAttribute: NSLayoutAttribute.leading, multiplier: multiplier, constant:constant)
    }
    
    //MARK:- Trailing Space
    
    func trailingSpace(constant:CGFloat, nearestNeighbour:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.trailing, relatedView: nearestNeighbour, relatedAttribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant:constant)
    }
    
    func trailingSpaceToSuperView(constant:CGFloat, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.trailing, relatedView: self.superview!, relatedAttribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant:constant)
    }
    
    //MARK:- Set Vertical constraint
    
    func setVerticalSpaceFrom(toView : UIView, constant : CGFloat)
    {
        let verticalSpaceConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .bottom, multiplier: 1, constant: constant)
        
        // activate the constraints
        NSLayoutConstraint.activate([verticalSpaceConstraint])
        self.verticalSpaceConstraint = verticalSpaceConstraint
    }
    
     //MARK:- Horizontal/Vertical Center
    
    func horizontalCenterToView(view:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.centerX, relatedView: view, relatedAttribute: NSLayoutAttribute.centerX, multiplier: multiplier, constant:0)
    }
    
    func verticalCenterToView(view:UIView, multiplier:CGFloat) -> NSLayoutConstraint {
        return self.equalToRelationWithLayoutAttribute(attribute: NSLayoutAttribute.centerY, relatedView: view, relatedAttribute: NSLayoutAttribute.centerY, multiplier: multiplier, constant:0)
    }
    

    //MARK:- Equal To Relation
    
    func equalToRelationWithLayoutAttribute(attribute:NSLayoutAttribute, relatedView:UIView?, relatedAttribute:NSLayoutAttribute, multiplier:CGFloat,
                                    constant:CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: relatedView, attribute: relatedAttribute, multiplier: multiplier, constant: constant);
    
    }
   
}
