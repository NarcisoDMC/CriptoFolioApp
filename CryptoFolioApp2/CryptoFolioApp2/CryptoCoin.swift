//
//  CryptoCoin.swift
//  CryptoFolio
//
//  Created by David Alexis De La Torre Rios on 14/12/25.
//

import Foundation

struct CryptoCoin: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChange24h: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChange24h = "price_change_percentage_24h" // <--- Mapeo
    }
}
