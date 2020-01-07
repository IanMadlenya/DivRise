//
//  Data+Json.swift
//  Dividend App
//
//  Created by Kevin Li on 12/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

// Purpose: Helps with debugging JSON

import Foundation

extension Data {
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}
