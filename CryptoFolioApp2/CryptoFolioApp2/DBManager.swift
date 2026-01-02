//
//  DBManager.swift
//  CryptoFolio
//
//  Created by David Alexis De La Torre Rios on 14/12/25.
//

import Foundation
import SQLite //Importamos la libreria de SQL Lite

//El objetivo es guardar los datos de los precios de las criptomonedas
//Para cuando no haya conexion a internet muestre los ultimos datos
//guardados en la cache

class DBManager {
    // Singleton: Usaremos la misma conexion siempre a la base de datos
    static let shared = DBManager()
    
    // Variables de configuracion de SQLite
    private var db: Connection?
    private let coinsTable = Table("coins")
    
    // Definimos las columnas de la tabla segun el modelo de los datos de
    // las criptomonedas (id, symbol, name, image, currentPrice)
    private let id = SQLite.Expression<String>("id")
    private let symbol = SQLite.Expression<String>("symbol")
    private let name = SQLite.Expression<String>("name")
    private let image = SQLite.Expression<String>("image")
    private let currentPrice = SQLite.Expression<Double>("currentPrice")
    private let priceChange24h = SQLite.Expression<Double>("priceChange24h")
    
    // Al iniciar, conectamos y creamos la tabla
    private init(){
        do {
            // Buscamos donde guardar el archivo en el iPhone
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentDirectory.appendingPathComponent("crypto.sqlite3").path
            
            //Conectamos
            db = try Connection(dbPath)
            
            //Creamos la tabla si no existe
            createTable()
            
            
        } catch {
            print("Error conectando a BD: \(error)")
        }
    }
    
    //Funcion para crear la tabla
    private func createTable() {
        do {
            try db?.run(coinsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(symbol)
                t.column(name)
                t.column(image)
                t.column(currentPrice)
                t.column(priceChange24h) 
            })
        } catch {
            print("Error creando tabla: \(error)")
        }
    }
    
    // Funcion para guardar las monedas actuales y borrando lo anterior en la cache
    func saveCoins(_ coins: [CryptoCoin]) {
        do {
            try db?.run(coinsTable.delete())
            
            for coin in coins {
                let insert = coinsTable.insert(
                    id <- coin.id,
                    symbol <- coin.symbol,
                    name <- coin.name,
                    image <- coin.image,
                    currentPrice <- coin.currentPrice,
                    priceChange24h <- coin.priceChange24h // <--- AGREGAR AQUÍ
                )
                try db?.run(insert)
            }
            print("Base de datos actualizada con \(coins.count) monedas.")
        } catch {
            print("Error guardando en SQLite: \(error)")
        }
    }
    
    // Obtenemos las monedas que estan en la lista de monedas guardadas
    func getCoins() -> [CryptoCoin] {
        //Lista de las criptomonedas guardadas en SQLite
        var result: [CryptoCoin] = []
        
        do{
            //Hacemos una consulta y obtenemos todos los datos
            //de las monedas guardadas
            for coin in try db!.prepare(coinsTable) {
                let newCoin = CryptoCoin(
                    id: coin[id],
                    symbol: coin[symbol],
                    name: coin[name],
                    image: coin[image],
                    currentPrice: coin[currentPrice],
                    priceChange24h: coin[priceChange24h]
                )
                result.append(newCoin)
            }
        } catch {
            print("Error leyendo de SQLite: \(error)")
        }
        
        return result
    }
}
