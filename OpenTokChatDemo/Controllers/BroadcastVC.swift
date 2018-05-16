//
//  BroadcastVC.swift
//  OpenTokChatDemo
//
//  Created by Hitender Kumar on 09/05/2018.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//


import UIKit
import OpenTok

class BroadcastVC: UIViewController {
    
    @IBOutlet weak var instructorNotHereContainer : UIView!
    @IBOutlet weak var instructorNotHereActivityIndicator : UIActivityIndicatorView!

    @IBOutlet weak var participantsCollectionView : UICollectionView!
 
    @IBOutlet weak var dismissBtn : UIButton!
    @IBOutlet weak var muteUnMuteBtn : UIButton!
    @IBOutlet weak var screenShareBtn : UIButton!
    @IBOutlet weak var enableDisableVideoBtn : UIButton!
    @IBOutlet weak var publisherView : UIView!
    @IBOutlet var publisherViewContainer: UIView!
    @IBOutlet weak var instructorScreenShareViewOrMainView : UIView! // show instructor main view when he so not share screen
    @IBOutlet weak var instructorViewWhileScreenShareContainer : UIView!
    @IBOutlet weak var instructorViewWhileScreenShare : UIView! //(round)show instructor main view in this view when instructor share screen and show his screen share view in instructorScreenShareViewOrHisMainView
    @IBOutlet weak var instructorNoImageViewWhileScreenShare : UIView! //(round)show instructor main view in this view when instructor share screen and show his screen share view in instructorScreenShareViewOrHisMainView

    @IBOutlet weak var instructorVideoDisabledImageView : UIImageView!
     @IBOutlet weak var subscriberViewHeightConstraint : NSLayoutConstraint!
 
    @IBOutlet weak var enlargeBtn : UIButton!
    @IBOutlet weak var activityIndicatorView : UIActivityIndicatorView!
    @IBOutlet weak var teacherLeftStackView: UIView!
    @IBOutlet var instructorFloatingHeadXConstraint: NSLayoutConstraint!
    @IBOutlet var instructorFloatingHeadYConstraint: NSLayoutConstraint!
    @IBOutlet var publisherFloatingHeadYConstraint: NSLayoutConstraint!
    @IBOutlet var publisherFloatingHeadXConstraint: NSLayoutConstraint!
    @IBOutlet var noPublisherVideoImageView: UIImageView!
    
    var publisherViewLastLocation : CGPoint = CGPoint.zero
    var instructorViewLastLocation : CGPoint = CGPoint.zero
    
    var isKeyboardHidden = true
    var isGroupCall = false
    var subscribers = [OTSubscriber]()
    var subscribersInfo = [String : [String : Any]]()
    
    var isPanningPublisher = false
    var isUserRotatingDevice = true
    
    //  var isPublishingScreenShare = false
    //MARK: Opentok variables
    
    var kSessionId = ""
     var kToken = ""
 
    lazy var otSession: OTSession = {
        return OTSession(apiKey: TOKBOXApiKey, sessionId: kSessionId, delegate: self)!
    }()
    
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        //settings.setValue(false, forKey: "isSupplier")
        //  settings.setValue(false, forKey: "userid")
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
    var mainSubscriber: OTSubscriber?
    var screenShareSubscriber: OTSubscriber?
 
    //MARK: View Life Cycle
    
    override var prefersStatusBarHidden: Bool {
        return self.enlargeBtn.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoHideKeybordOnTappingAnyWhere()
        self.applyFinishingTouchToUIElements()
        self.doConnect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.orientationLock = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.orientationLock =  IsPad ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if isUserRotatingDevice {
            self.enlargeBtn.isSelected = !self.enlargeBtn.isSelected
        }
        self.setUpElementsOnRotation()
        if self.participantsCollectionView != nil {
            coordinator.animate(alongsideTransition: { (context) in
                self.participantsCollectionView.performBatchUpdates({
                    self.participantsCollectionView.setCollectionViewLayout(self.participantsCollectionView.collectionViewLayout, animated: true)
                }, completion: nil)
            }, completion: nil)
        }
        self.isUserRotatingDevice = true
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if self.isPanningPublisher {
    //            self.view.bringSubview(toFront: self.publisherView)
    //            self.publisherViewLastLocation = self.publisherView.center
    //        } else {
    //            self.view.bringSubview(toFront: self.instructorViewWhileScreenShare)
    //            self.instructorViewLastLocation = self.instructorViewWhileScreenShare.center
    //        }
    //    }
    
    //MARK: Interface Builder Actions
    
    @IBAction func showChatBtnAction(_ sender : UIButton) {
        self.participantsCollectionView.isHidden = true
    }
    
    @IBAction func dismissChatBtnAction(_ sender : UIButton) {
        self.view.endEditing(true)
        self.participantsCollectionView.isHidden = false
     }
    
    @IBAction func dismissBtnAction(_ sender : UIButton) {
        if !IsPad {
            AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
        self.otSession.disconnect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func muteUnMuteBtnAction(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage( #imageLiteral(resourceName: "mute").withRenderingMode(.alwaysTemplate), for: .normal)
            self.muteUnMuteBtn.tintColor = AppDelegate.AppThemeColor
            self.publisher.publishAudio = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "unmute").withRenderingMode(.alwaysTemplate), for: .normal)
            self.muteUnMuteBtn.tintColor = WhiteColor
            self.publisher.publishAudio = true
        }
    }
    
    @IBAction func enableDisableVideoBtnAction(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.publisher.publishVideo = false
            self.enableDisableVideoBtn.setImage( #imageLiteral(resourceName: "disableVideo").withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
            self.enableDisableVideoBtn.tintColor = AppDelegate.AppThemeColor
            self.publisherViewContainer.bringSubview(toFront: self.noPublisherVideoImageView)
        } else {
            self.publisher.publishVideo = true
            self.enableDisableVideoBtn.setImage(#imageLiteral(resourceName: "enableVideo").withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
            self.enableDisableVideoBtn.tintColor = WhiteColor
            self.publisherViewContainer.sendSubview(toBack: self.noPublisherVideoImageView)
        }
    }
    
    @IBAction func enlargeBtnAction(_ sender : UIButton) {
        self.isUserRotatingDevice = false
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.landscapeRight)
        } else {
            AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
            
        }
    }
    
    func setUpElementsOnRotation() {
        if self.enlargeBtn.isSelected {
            AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.landscapeRight)
            if !self.isGroupCall {
                 self.instructorFloatingHeadYConstraint.constant = 20
                self.instructorFloatingHeadXConstraint.constant = 20
                self.publisherFloatingHeadYConstraint.constant = 20
                self.publisherFloatingHeadXConstraint.constant = 20
            }
        } else {
            AppUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.portrait)
            if !self.isGroupCall {
                self.instructorFloatingHeadYConstraint.constant = 20
                self.instructorFloatingHeadXConstraint.constant = 20
                self.publisherFloatingHeadYConstraint.constant = 20
                self.publisherFloatingHeadXConstraint.constant = 20
            }
        }
        self.setNeedsStatusBarAppearanceUpdate()
        UIView.animate(withDuration: 0.3, animations: {
            self.subscriberViewHeightConstraint.constant = self.enlargeBtn.isSelected ? self.view.frame.size.height :  self.view.frame.size.height * 0.4
             self.view.layoutIfNeeded()
        })
     }
 
    //MARK: Helpers
    
    func applyFinishingTouchToUIElements() {
        
        enlargeBtn.isHidden = self.isGroupCall
        
        self.view.bringSubview(toFront: self.publisherView)
        self.instructorNotHereContainer.isHidden = false
        self.instructorNotHereActivityIndicator.color = AppDelegate.AppThemeColor
        self.instructorNotHereActivityIndicator.startAnimating()
        self.screenShareBtn.isHidden = true
        self.enableDisableVideoBtn.setImage( #imageLiteral(resourceName: "enableVideo").withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        self.enableDisableVideoBtn.tintColor = WhiteColor
        self.enableDisableVideoBtn.addShadowWith(shadowOffset: CGSize(width: 0, height: 4), shadowOpacity: 1, shadowRadius: 6)
        self.muteUnMuteBtn.tintColor = WhiteColor
        self.teacherLeftStackView.isHidden = true
        instructorVideoDisabledImageView.isHidden = true
        publisherView.layer.cornerRadius = publisherView.frame.size.height / 2
        publisherView.clipsToBounds = true
        instructorViewWhileScreenShare.layer.cornerRadius = instructorViewWhileScreenShare.frame.size.height / 2
        instructorViewWhileScreenShare.clipsToBounds = true
        self.instructorNoImageViewWhileScreenShare.isHidden = true
        instructorViewWhileScreenShare.isHidden = true
        self.enlargeBtn.setImage( #imageLiteral(resourceName: "expand").withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        self.enlargeBtn.tintColor = WhiteColor
        self.muteUnMuteBtn.addShadowWith(shadowOffset: CGSize(width: 0, height: 4), shadowOpacity: 1, shadowRadius: 6)
        self.enlargeBtn.addShadowWith(shadowOffset: CGSize(width: 0, height: 4), shadowOpacity: 1, shadowRadius: 6)
        self.participantsCollectionView.isHidden = false
        self.enableDisableVideoBtn.isHidden = false
        self.muteUnMuteBtn.isHidden = false
        self.publisherViewContainer.isHidden = false
        self.activityIndicatorView.startAnimating()
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGestureAction(_:)))
        self.publisherViewContainer.addGestureRecognizer(panGesture)
        self.publisherViewLastLocation = self.publisherView.center
        
        let instructorMainViewPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.instructorViewWhileScreenSharePanGestureAction(_:)))
        self.instructorViewWhileScreenShareContainer.addGestureRecognizer(instructorMainViewPanGesture)
        self.instructorViewLastLocation = self.instructorViewWhileScreenShare.center
        
        if self.isGroupCall {
            self.subscriberViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        } else {
            self.subscriberViewHeightConstraint.constant = self.view.frame.size.height * 0.4
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func panGestureAction(_ sender:UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: sender.view!)
        let translation: CGPoint = sender.translation(in: view)
        //Update the constraint's constant
        publisherFloatingHeadXConstraint.constant -= translation.x
        publisherFloatingHeadYConstraint.constant += translation.y
        // Assign the frame's position only for checking it's fully on the screen
        var recognizerFrame: CGRect = sender.view!.frame
        recognizerFrame.origin.x = publisherFloatingHeadXConstraint.constant
        recognizerFrame.origin.y = publisherFloatingHeadYConstraint.constant
        if !view.bounds.contains(recognizerFrame) {
            if publisherFloatingHeadYConstraint.constant < view.bounds.minY {
                publisherFloatingHeadYConstraint.constant = 0
            } else if publisherFloatingHeadYConstraint.constant + recognizerFrame.height > view.bounds.height {
                publisherFloatingHeadYConstraint.constant = view.bounds.height - recognizerFrame.height
            }
            if publisherFloatingHeadXConstraint.constant < view.bounds.minX {
                publisherFloatingHeadXConstraint.constant = 0
            } else if publisherFloatingHeadXConstraint.constant + recognizerFrame.width > view.bounds.width {
                publisherFloatingHeadXConstraint.constant = view.bounds.width - recognizerFrame.width
            }
        }
        //Layout the View
        view.layoutIfNeeded()
        sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
    }
    
    @objc func instructorViewWhileScreenSharePanGestureAction(_ sender : UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: sender.view!)
        self.view.bringSubview(toFront: sender.view!)
        let translation: CGPoint = sender.translation(in: view)
        //Update the constraint's constant
        instructorFloatingHeadXConstraint.constant += translation.x
        instructorFloatingHeadYConstraint.constant += translation.y
        // Assign the frame's position only for checking it's fully on the screen
        var recognizerFrame: CGRect = sender.view!.frame
        recognizerFrame.origin.x = instructorFloatingHeadXConstraint.constant
        recognizerFrame.origin.y = instructorFloatingHeadYConstraint.constant
        if !view.bounds.contains(recognizerFrame) {
            if instructorFloatingHeadYConstraint.constant < view.bounds.minY {
                instructorFloatingHeadYConstraint.constant = 0
            } else if instructorFloatingHeadYConstraint.constant + recognizerFrame.height > view.bounds.height {
                instructorFloatingHeadYConstraint.constant = view.bounds.height - recognizerFrame.height
            }
            if instructorFloatingHeadXConstraint.constant < view.bounds.minX {
                instructorFloatingHeadXConstraint.constant = 0
            } else if instructorFloatingHeadXConstraint.constant + recognizerFrame.width > view.bounds.width {
                instructorFloatingHeadXConstraint.constant = view.bounds.width - recognizerFrame.width
            }
        }
        //Layout the View
        view.layoutIfNeeded()
        sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
    }
    
    /**
     * Asynchronously begins the session connect process. Some time later, we will
     * expect a delegate method to call us back with the results of this action.
     */
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        otSession.connect(withToken: kToken, error: &error)
    }
    
    /**
     * Sets up an instance of OTPublisher to use with this session. OTPubilsher
     * binds to the device camera and microphone, and will provide A/V streams
     * to the OpenTok session.
     */
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        otSession.publish(publisher, error: &error)
        if let pubView = publisher.view {
            pubView.frame = self.publisherView.frame
            self.publisherView.addSubview(pubView)
            pubView.prepareForNewConstraints(block: { (v) in
                v?.setLeadingSpaceFromSuperView(leadingSpace: 0)
                v?.setTrailingSpaceFromSuperView(trailingSpace: 0)
                v?.setTopSpaceFromSuperView(topSpace: 0)
                v?.setBottomSpaceFromSuperView(bottomSpace: 0)
            })
        }
        
        self.participantsCollectionView.reloadData()
    }
    
    fileprivate func doPublishScreenShare() {
        
    }
    
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        var error: OTError?
        
        defer {
            processError(error)
        }
        guard let subscriber = OTSubscriber(stream: stream, delegate: self)
            else {
                print("Error while subscribing")
                return
        }
        
        if isGroupCall {
            otSession.subscribe(subscriber, error: &error)
            subscribers.append(subscriber)
            participantsCollectionView?.reloadData()
        }
        else {
            self.instructorNotHereContainer.isHidden = true
            self.teacherLeftStackView.isHidden = true
            otSession.subscribe(subscriber, error: &error)
            self.mainSubscriber = subscriber
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.instructorVideoDisabledImageView.isHidden = stream.hasVideo
            if let subView = self.mainSubscriber?.view {
                subView.frame = self.instructorScreenShareViewOrMainView.bounds
                self.instructorScreenShareViewOrMainView.addSubview(subView)
                self.instructorScreenShareViewOrMainView.clipsToBounds = true
                subView.prepareForNewConstraints(block: { (v) in
                    v?.setLeadingSpaceFromSuperView(leadingSpace: 0)
                    v?.setTrailingSpaceFromSuperView(trailingSpace: 0)
                    v?.setTopSpaceFromSuperView(topSpace: 0)
                    v?.setBottomSpaceFromSuperView(bottomSpace: 0)
                })
            }
        }
    }
    
    fileprivate func cleanupSubscriber() {
        self.mainSubscriber?.view?.removeFromSuperview()
        self.mainSubscriber = nil
    }
    
    
    fileprivate func cleanupPublisher() {
        publisher.view?.removeFromSuperview()
    }
    
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

extension BroadcastVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subscribers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantCell", for: indexPath)
        let videoSubscriberView = cell.contentView.viewWithTag(11111)
        let videoDisabledImageVw : UIImageView = cell.contentView.viewWithTag(22222) as! UIImageView
        videoDisabledImageVw.backgroundColor = WhiteColor
        videoDisabledImageVw.isHidden = true
        let sub = subscribers[indexPath.row]
        
        var videoDimensions : CGSize = CGSize.zero
        if let dimensions = sub.stream?.videoDimensions {
            videoDimensions = dimensions
        }
        
        var hasVideo = false
        
        if (sub.stream?.hasVideo)! {
            hasVideo = true
            if let id = sub.stream?.streamId{
                if let subInfo = self.subscribersInfo[id] {
                    if let showVideo = subInfo["hasVideo"] as? Bool{
                        hasVideo = showVideo
                    }
                }
            }
            
            if videoDimensions == CGSize.zero {
                hasVideo = false
            }
            
            if hasVideo {
                let videoView: UIView? = {
                    return sub.view
                }()
                if let viewToAdd = videoView {
                    viewToAdd.tag = 12345678
                    viewToAdd.frame = cell.bounds
                    videoSubscriberView?.addSubview(viewToAdd)
                }
            }
        }
        
        if !hasVideo {
            if let subviews = videoSubscriberView?.subviews {
                subviews.forEach { (v) in
                    if v.tag == 12345678 {
                        v.removeFromSuperview()
                    }
                }
            }
            cell.bringSubview(toFront: videoDisabledImageVw)
            videoDisabledImageVw.isHidden = false
        }
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        let numOfItems : CGFloat = IsPad ? 3 : 2
        let cellWidth = self.participantsCollectionView.frame.size.width / numOfItems
        size = CGSize.init(width: cellWidth, height: cellWidth)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - OTSession delegate callbacks
extension BroadcastVC: OTSessionDelegate {
    
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
       // if !isGroupCall {
            doPublish()
        //}
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
        self.showAlertWithOkCompletion(title: "Oops!", message: "There is some issue with the class. Please rejoin") { (compelted) in
            if !IsPad {
                AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        //if self.mainSubscriber == nil {
        doSubscribe(stream)
        //}
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        if let subStream = self.mainSubscriber?.stream, subStream.streamId == stream.streamId {
            //cleanupSubscriber()
            self.mainSubscriber?.view?.removeFromSuperview()
            self.mainSubscriber = nil
            if let _ = self.screenShareSubscriber {
                self.mainSubscriber = self.screenShareSubscriber
                self.screenShareSubscriber = nil
                self.instructorNoImageViewWhileScreenShare.isHidden = true
                self.instructorViewWhileScreenShare.isHidden = true
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                self.instructorVideoDisabledImageView.isHidden = true
                if let subView = self.mainSubscriber?.view {
                    subView.frame = self.instructorScreenShareViewOrMainView.bounds
                    self.instructorScreenShareViewOrMainView.addSubview(subView)
                    self.instructorScreenShareViewOrMainView.clipsToBounds = true
                    subView.prepareForNewConstraints(block: { (v) in
                        v?.setLeadingSpaceFromSuperView(leadingSpace: 0)
                        v?.setTrailingSpaceFromSuperView(trailingSpace: 0)
                        v?.setTopSpaceFromSuperView(topSpace: 0)
                        v?.setBottomSpaceFromSuperView(bottomSpace: 0)
                    })
                }
            } else {
                self.mainSubscriber = nil
                self.mainSubscriber?.view?.removeFromSuperview()
                self.teacherLeftStackView.isHidden = false
                instructorVideoDisabledImageView.isHidden = true
            }
        }
        if let screenSharesubscriberStream = self.screenShareSubscriber?.stream, screenSharesubscriberStream.streamId == stream.streamId {
            if screenSharesubscriberStream.videoType == .screen {
                self.screenShareSubscriber?.view?.removeFromSuperview()
                self.screenShareSubscriber = nil
            }//instructor view while screen share (round one)
            self.screenShareSubscriber?.view?.removeFromSuperview()
            self.mainSubscriber = self.screenShareSubscriber
            self.screenShareSubscriber = nil
            self.instructorNoImageViewWhileScreenShare.isHidden = true
            self.instructorViewWhileScreenShare.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.instructorVideoDisabledImageView.isHidden = true
            
            if screenSharesubscriberStream.videoType == .camera {
                self.mainSubscriber?.view?.removeFromSuperview()
                self.mainSubscriber = nil
                for v in self.instructorScreenShareViewOrMainView.subviews {
                    if !v.isKind(of: UIActivityIndicatorView.self) && !v.isKind(of: UIStackView.self) && !v.isKind(of: UILabel.self){
                        v.removeFromSuperview()
                    }
                }
                self.teacherLeftStackView.isHidden = false
                self.view.bringSubview(toFront: self.teacherLeftStackView)
            }  else {
                if let subView = self.mainSubscriber?.view {
                    subView.frame = self.instructorScreenShareViewOrMainView.bounds
                    self.instructorScreenShareViewOrMainView.addSubview(subView)
                    self.instructorScreenShareViewOrMainView.clipsToBounds = true
                    subView.prepareForNewConstraints(block: { (v) in
                        v?.setLeadingSpaceFromSuperView(leadingSpace: 0)
                        v?.setTrailingSpaceFromSuperView(trailingSpace: 0)
                        v?.setTopSpaceFromSuperView(topSpace: 0)
                        v?.setBottomSpaceFromSuperView(bottomSpace: 0)
                    })
                }//instructor view while screen share (round one)
            }
            
        }
        subscribers = subscribers.filter { $0.stream?.streamId != stream.streamId }
        self.subscribersInfo = self.subscribersInfo.filter({ (info) -> Bool in
            return info.key != stream.streamId
        })
        participantsCollectionView?.reloadData()
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
    //for message
    func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
        
    }
}

// MARK: - OTPublisher delegate callbacks
extension BroadcastVC: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        print("Publishing")
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        cleanupPublisher()
        //        if let subStream = self.publisher.stream, subStream.streamId == stream.streamId {
        //            self.publisher.view?.removeFromSuperview()
        //        }
        //        if let subStream = self.screenPublisher?.stream, subStream.streamId == stream.streamId {
        //            self.screenPublisher?.view?.removeFromSuperview()
        //            self.isPublishingScreenShare = false
        //            self.screenShareBtn.setImage(#imageLiteral(resourceName: "screenshare").withRenderingMode(.alwaysTemplate), for: .normal)
        //            self.screenShareBtn.tintColor = WhiteColor
        //        }
        if let subStream = self.mainSubscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension BroadcastVC: OTSubscriberDelegate {
    
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
    
    func subscriberVideoDisabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
        print("subscriberVideoDisabled")
        if subscriber == self.mainSubscriber {
            self.instructorVideoDisabledImageView.isHidden = false
        } else if subscriber == self.screenShareSubscriber {
            self.instructorViewWhileScreenShareContainer.bringSubview(toFront: instructorNoImageViewWhileScreenShare)
            self.instructorNoImageViewWhileScreenShare.isHidden = false
        } else {
            if let streamId = subscriber.stream?.streamId{
                self.subscribersInfo[streamId] = ["hasVideo" : false]
            }
            self.participantsCollectionView.reloadData()
        }
    }
    
    func subscriberVideoDisableWarning(_ subscriber: OTSubscriberKit) {
        print("subscriberVideoDisableWarning")
        if subscriber == self.mainSubscriber {
            self.instructorVideoDisabledImageView.isHidden = false
        } else {
            if let streamId = subscriber.stream?.streamId{
                self.subscribersInfo[streamId] = ["hasVideo" : false]
            }
            self.participantsCollectionView.reloadData()
        }
    }
    
    func subscriberVideoDisableWarningLifted(_ subscriber: OTSubscriberKit) {
        print("subscriberVideoDisableWarningLifted")
        if subscriber == self.mainSubscriber {
            self.instructorVideoDisabledImageView.isHidden = true
        } else {
            if let streamId = subscriber.stream?.streamId{
                self.subscribersInfo[streamId] = ["hasVideo" : true]
            }
            self.participantsCollectionView.reloadData()
        }
    }
    
    func subscriberVideoEnabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
        print("subscriberVideoEnabled")
        self.instructorNoImageViewWhileScreenShare.isHidden = true
        if subscriber == self.mainSubscriber {
            self.instructorVideoDisabledImageView.isHidden = true
        } else if subscriber == self.screenShareSubscriber {
            self.instructorNoImageViewWhileScreenShare.isHidden = true
        } else {
            if let streamId = subscriber.stream?.streamId{
                self.subscribersInfo[streamId] = ["hasVideo" : true]
            }
            self.participantsCollectionView.reloadData()
        }
    }
}


