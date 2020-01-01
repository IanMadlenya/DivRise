//
//  App.swift
//  Dividend App
//
//  Created by Kevin Li on 12/23/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation

enum AppAction {
    case toggleNotifications(enabled: Bool)
    case addToPortfolio(stock: PortfolioStock)
    case removeFromPortfolio(offsets: IndexSet)
    case updatePortfolio(stocks: [PortfolioStock])
    case setSearchResults(results: [SearchStock])
    case addMonthlyDividend(record: Record, amount: Double)
    case setDetailStock(detail: DetailStock?)
    case setSelectedPeriod(period: String)
    case setAttributeNames(attributeNames: [String])
}

