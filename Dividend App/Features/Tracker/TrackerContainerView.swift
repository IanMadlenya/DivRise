//
//  TrackerContainerView.swift
//  Dividend App
//
//  Created by Kevin Li on 1/12/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct TrackerContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Binding var show: Bool
    
    private var portfolioStocks: [PortfolioStock] {
        store.state.portfolioStocks.compactMap {
            store.state.allPortfolioStocks[$0]
        }
    }
    
    private var holdingsInfo: [HoldingInfo?] {
        store.state.portfolioStocks.map {
            store.state.allHoldingsInfo[$0]
        }
    }
    
    var body: some View {
        NavigationView {
            TrackerView(portfolioStocks: portfolioStocks, holdingsInfo: holdingsInfo, currentSharePrices: store.state.currentSharePrices)
            .navigationBarTitle("Dividend Tracker")
            .navigationBarItems(trailing: ExitButton(show: $show))
            .onAppear(perform: getCurrentSharePrices)
        }
    }
    
    private func getCurrentSharePrices() {
        store.send(setCurrentSharePrices(portfolioStocks: portfolioStocks))
    }
}
