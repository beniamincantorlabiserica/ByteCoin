//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Beniamin on 01/09/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let price : Double
    let currency : String
    
    func roundDouble() -> Double{
        return price.round(2)
    }
}

extension Double {
    func round(_ decimals : Int) -> Double {
        var n = self
        let customRound = pow(10, Double(decimals))
        n = n * customRound
        n.round()
        n = n / customRound
        return n
    }
}
