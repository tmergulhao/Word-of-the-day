//
//  NSAttributedString+HTML.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 20/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

extension NSAttributedString {
    convenience init?(htmlString html : String) {
        do {
            try self.init(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
}
