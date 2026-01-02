//
//  ContentView.swift
//  CryptoFolio
//
//  Created by David Alexis De La Torre Rios on 14/12/25.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var coins: [CryptoCoin] = []
    @State private var showPesos: Bool = false
    
    // Tasa de cambio (Ejemplo)
    let mxnRate: Double = 20.50
    
    // Timer para actualizar datos cada 15 segundos
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // --- HEADER ---
                VStack(spacing: 8) {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    Text("CryptoFolio")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("Mantén presionado para comprar") // Instrucción para el usuario
                        .font(.caption)
                        .italic()
                        .foregroundColor(.gray)
                    
                    Picker("Moneda", selection: $showPesos) {
                        Text("USD ($)").tag(false)
                        Text("MXN (MX$)").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
                
                // --- LISTA ---
                List(coins) { coin in
                    HStack {
                        KFImage(URL(string: coin.image))
                            .resizable()
                            .placeholder { Circle().fill(Color.gray.opacity(0.3)) }
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(coin.name).font(.headline)
                            Text(coin.symbol.uppercased()).font(.caption).foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(getPriceString(price: coin.currentPrice))
                                .bold()
                                .foregroundColor(coin.priceChange24h >= 0 ? .green : .red)
                            
                            Text("\(coin.priceChange24h >= 0 ? "+" : "")\(String(format: "%.2f", coin.priceChange24h))%")
                                .font(.caption2)
                                .foregroundColor(coin.priceChange24h >= 0 ? .green : .red)
                        }
                    }
                    // AQUÍ ESTÁ LA MAGIA DEL BOTÓN
                    .contextMenu {
                        Button(action: {
                            // Acción al presionar el botón
                            print("Comprando \(coin.name)...")
                            FirebaseManager.shared.savePurchase(coin: coin)
                            
                            // Opcional: Vibración de éxito
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }) {
                            // Diseño del botón
                            Label("Comprar (Guardar en Nube)", systemImage: "cart.fill")
                        }
                        
                        Button(action: {
                            print("Compartir...")
                        }) {
                            Label("Compartir precio", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
            .onAppear { loadData() }
            .onReceive(timer) { _ in loadData() }
        }
    }
    
    // Funciones Auxiliares
    func getPriceString(price: Double) -> String {
        if showPesos {
            return "$\(String(format: "%.2f", price * mxnRate))"
        } else {
            return "$\(String(format: "%.2f", price))"
        }
    }
    
    func loadData() {
        if coins.isEmpty {
            let localCoins = DBManager.shared.getCoins()
            if !localCoins.isEmpty { self.coins = localCoins }
        }
        APIService.shared.fetchCoins { downloadedCoins in
            if let downloadedCoins = downloadedCoins {
                withAnimation { self.coins = downloadedCoins }
                DBManager.shared.saveCoins(downloadedCoins)
            }
        }
    }
}
