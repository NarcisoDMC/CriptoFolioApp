import Foundation
import FirebaseFirestore // Importante: Debe estar instalado

class FirebaseManager {
    // Singleton para usarlo desde cualquier lado
    static let shared = FirebaseManager()
    
    // Referencia a la base de datos
    private let db = Firestore.firestore()
    
    // Función para guardar una compra simulada
    func savePurchase(coin: CryptoCoin) {
        // 1. Preparamos los datos en formato "Diccionario" (Clave: Valor)
        let data: [String: Any] = [
            "id_moneda": coin.id,
            "nombre": coin.name,
            "simbolo": coin.symbol,
            "precio_compra_usd": coin.currentPrice,
            "cambio_24h": coin.priceChange24h,
            "fecha_compra": Timestamp(date: Date()) // Fecha del servidor
        ]
        
        // 2. Guardamos en la colección "compras"
        db.collection("compras").addDocument(data: data) { error in
            if let error = error {
                print("❌ Error subiendo a Firebase: \(error.localizedDescription)")
            } else {
                print("✅ ¡Éxito! Se guardó la compra de \(coin.name) en Firebase.")
            }
        }
    }
}
