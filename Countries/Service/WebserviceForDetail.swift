//
//  WebserviceForDetail.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import Foundation

struct WebserviceForDetail {
    
    func fetchDetailData(url: URL, completion: @escaping(DetailModel?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil)
            } else if let data = data {
                let detailData = try? JSONDecoder().decode(DetailModel.self, from: data)
                
                if let detailData = detailData {
                    completion(detailData)
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
