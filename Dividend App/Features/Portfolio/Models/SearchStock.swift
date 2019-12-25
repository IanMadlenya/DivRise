//
//  SearchStock.swift
//  Dividend App
//
//  Created by Kevin Li on 12/24/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

struct SearchStock: Codable, Hashable {
    let ticker: String
    let fullName: String
    let image: String
    let marketCap: String
}

extension SearchStock {
    static let mock = SearchStock(ticker: "AAPL", fullName: "Apple Inc", image: "https://financialmodelingprep.com/images-New-jpg/AAPL.jpg", marketCap: "$1.3T")
}
