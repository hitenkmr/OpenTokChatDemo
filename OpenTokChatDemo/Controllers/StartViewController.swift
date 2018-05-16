//
//  StartViewController.swift
//  OpenTokChatDemo
//
//  Created by Hitender Kumar on 08/05/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var oneToOneCallBtn : UIButton!
    @IBOutlet weak var groupCallBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func oneToOneCallBtnAction(_ sender : UIButton) {
        let brodcastVC : BroadcastVC = BroadcastVC.instantiateWithStoryboard(appStoryboard: .SB_Main) as! BroadcastVC
        brodcastVC.isGroupCall = false
        self.present(brodcastVC, animated: true, completion: nil)
    }

    @IBAction func groupCallBtnBtn(_ sender : UIButton) {
        let brodcastVC : BroadcastVC = BroadcastVC.instantiateWithStoryboard(appStoryboard: .SB_Main) as! BroadcastVC
        brodcastVC.isGroupCall = true
        self.present(brodcastVC, animated: true, completion: nil)
    }

}
