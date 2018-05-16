//
//  Data+Additions.swift
//  OpenTokChatDemo
//
//  Created by Hitender kumar on 15/03/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.
//

import Foundation

//https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift/28132610

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
