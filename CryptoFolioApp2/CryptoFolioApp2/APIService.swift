//
//  APIService.swift
//  CryptoFolio
//
//  Created by David Alexis De La Torre Rios on 14/12/25.
//

import Foundation
import Alamofire

class APIService {
    // Singleton para usarlo fácilmente en toda la app
    static let shared = APIService()
    
    // La URL de CoinGecko
    private let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false"
    
    // Función para descargar monedas
    func fetchCoins(completion: @escaping ([CryptoCoin]?) -> Void) {
        
        AF.request(url).responseDecodable(of: [CryptoCoin].self) { response in
            switch response.result {
            case .success(let coins):
                print("¡Éxito! Se descargaron \(coins.count) monedas.")
                completion(coins)
            case .failure(let error):
                print("Error descargando datos: \(error)")
                completion(nil)
            }
        }
    }
}
