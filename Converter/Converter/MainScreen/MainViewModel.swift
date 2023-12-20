//
//  Model.swift
//  Converter
//
//  Created by Наташа Яковчук on 10.12.2023.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var ratesDict: [String:Double] = [ : ]
    @Published var value1 = ""
    @Published var value2 = "00.00"
    @Published var selestedCurrency1 = "USD"
    @Published var selestedCurrency2 = "EUR"
    
    @Published var isTextBlack = false
    @Published var isFavEmpty = true
    
    @Published var titleAlert = "" { didSet { showAlert = true } }
    @Published var textAlert = "" { didSet { showAlert = true } }
    @Published var showAlert = false
    
    private var forReplacing = ""
    
    @Published var listFavourite = [String]()
    @Published var favPick = " " {didSet { ChooseFav() } }
    @AppStorage("favouritePairs") var favouritePairs: String = ""
    
    
    func fetchData(completion: @escaping (Result<Convert, Error>) -> Void) {
        let url: String = "https://v6.exchangerate-api.com/v6/350f9dfe6c93f5412d501256/latest/USD"
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Convert.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchResult(completion: @escaping (Result<Converting, Error>) -> Void) {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/350f9dfe6c93f5412d501256/pair/\(selestedCurrency1)/\(selestedCurrency2)/\(value1)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "com.yourapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Converting.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func ButtonConvert() {
        guard Int(value1) != 0 && !value1.isEmpty else { titleAlert = "Print in valid amount";
            textAlert = "Amount can't be 0."; return}
        guard !value1.contains(where: { $0.isLetter }) else { titleAlert = "Print in valid amount";
            textAlert = "Amount can't contain letters.";
            value1 = ""; return}
        fetchResult { result in
            switch result {
            case .success(let converting):
                self.value2 = String(converting.conversionResult)
                print(converting)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        isTextBlack = true
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func ReplaceSelested() {
        forReplacing = selestedCurrency2
        selestedCurrency2 = selestedCurrency1
        selestedCurrency1 = forReplacing
        forReplacing = ""
    }
    
    func addToFavourites() {
        guard !listFavourite.contains("\(selestedCurrency1) -> \(selestedCurrency2)") else {titleAlert = "Already in Favoutites";
            textAlert = "Pair is already added to favourites"; return}
        listFavourite.append("\(selestedCurrency1) -> \(selestedCurrency2)")
        UserDefaults.standard.set(listFavourite.joined(separator: "+"), forKey: "favouritePairs")
        isFavEmpty = false
        print(UserDefaults.standard.string(forKey: "favouritePairs") ?? "")
    }
    
    func ChooseFav() {
        let chosen = favPick.components(separatedBy: " -> ")
        selestedCurrency1 = chosen[0]
        selestedCurrency2 = chosen[1]
    }
    
    func Start() {
        fetchData { result in
            switch result {
            case .success(let list):
                self.ratesDict = list.conversionRates
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        if let userFav = UserDefaults.standard.string(forKey: "favouritePairs") {
            listFavourite = userFav.components(separatedBy: "+")
        }
    }
}

