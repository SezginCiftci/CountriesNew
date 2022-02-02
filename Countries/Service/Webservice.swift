//
//  Webservice.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import Foundation

struct Webservice {
    
    func fetchCountryData(url: URL, completion: @escaping([Datum]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil)
            } else if let data = data {
                let countryData = try? JSONDecoder().decode(CountryListModel.self, from: data)
               
                if let countryData = countryData {
                    completion(countryData.data)
                }
            }
            
            guard let response = response as? HTTPURLResponse  else {
                print("Empty response")
                return
            }
            print("Response status code: \(response.statusCode)")

            
        }.resume()
    }
    
}

