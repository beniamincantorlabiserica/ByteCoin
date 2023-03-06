//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(price : CoinModel)
    func didFailWithError(error : Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey="
    let apiKey = "BCF707E5-6AE5-416E-8822-EBA03E398444"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency : String) {
        let url = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=\(apiKey)"
        performTask(url)
    }
    
    
    func performTask(_ urlString : String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create a url session
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coinPrice = self.parseJSON(safeData){
                        print("PERFORM TASK: \(coinPrice.roundDouble())")
                       self.delegate?.didUpdateCoinPrice(price : coinPrice)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)

            let price = decodedData.rate
            let currency = decodedData.asset_id_quote
            let coinModel = CoinModel(price: price, currency: currency)
            print(coinModel.roundDouble())
            return coinModel
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
