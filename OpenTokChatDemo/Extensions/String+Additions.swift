//
//  String+Additions.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 15/03/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import Foundation

//https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift/28132610

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func utf8Data() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
}
