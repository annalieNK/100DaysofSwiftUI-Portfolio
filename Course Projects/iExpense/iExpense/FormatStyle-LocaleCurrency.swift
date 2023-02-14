//
//  FormatStyle-LocaleCurrency.swift
//  iExpense
//
//  Created by Annalie Kruseman on 9/27/22.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
}
