//
//  NSAttributedString+HTML.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 20/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    convenience init?(htmlString html : String) {
        do {
            try self.init(
                data: Data(html.utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue,
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
}

extension String {
    
    var styleWrapped : String {
        
        let font = "OpenSans-Regular" // "-apple-system"
        let fontSize = 12
        let lineHeight = 25
        let margin = 20
        
        return """
        
        <style>
        p, li {
            font-family:\"\(font)\";
            font-size:\(fontSize)px;
            line-height:\(lineHeight)px
        }
        p {
            margin: \(margin)px 0;
        }
        #p {
            font-weight: bold;
            font-size: 24px;
            line-height: 130%;
            margin: 50px 20px;
        }
        ul li, ol li {
            margin: 20px 0;
            font-weight: bold;
        }
        </style>

        \(self)
        """
    }
}
