//
//  PortfolioDetailContainerView.swift
//  Dividend App
//
//  Created by Kevin Li on 12/23/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import SwiftUI
import Combine

struct PortfolioDetailContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State var selectedPeriod: String
    @State var attributeNames: [String]
    @State var selectedAttributeIndex: Int? = nil
    
    let portfolioStock: PortfolioStock
    
    init(portfolioStock: PortfolioStock, selectedPeriod: String, attributeNames: [String]) {
        self.portfolioStock = portfolioStock
        _selectedPeriod = State(initialValue: selectedPeriod)
        _attributeNames = State(initialValue: attributeNames)
    }
    
    var body: some View {
        PortfolioDetailView(selectedPeriod: $selectedPeriod, selectedAttributeIndex: $selectedAttributeIndex, attributeNames: $attributeNames, portfolioStock: portfolioStock, records: getRecords(), sharePriceRecords: getSharePriceRecords(), attributeValues: getAttributeValues(), onPeriodChange: loadDetailStock)
        .onAppear(perform: loadDetailStock)
    }
    
    private func loadDetailStock() {
        store.send(.setDetailStock(detail: nil))
        store.send(.setSelectedPeriod(period: selectedPeriod))
        store.send(setCurrentDetailStock(identifier: portfolioStock.ticker, period: selectedPeriod))
    }
    
    private func getRecords() -> [Record] {
        if let detailStock = store.state.currentDetailStock {
            return detailStock.records
        } else {
            return []
        }
    }
    
    private func getSharePriceRecords() -> [Record] {
        if let detailStock = store.state.currentDetailStock {
            return detailStock.sharePriceRecords
        } else {
            return []
        }
    }
    
    private func getAttributeValues() -> [[Double]] {
        if let detailStock = store.state.currentDetailStock {
            return attributeNames.compactMap {
                detailStock.details[$0]!
            }
        } else {
            return []
        }
    }
}