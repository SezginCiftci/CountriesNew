//
//  CountryViewModel.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import Foundation

struct CountryListViewModel {
    
    let countryData: [Datum]
    
    func numberOfRowsInSection() -> Int {
        return self.countryData.count
    }
    
    func cellForRowAt(_ index: Int) -> CountryViewModel {
        let country = self.countryData[index]
        return CountryViewModel(countryData: country)
    }
}


struct CountryViewModel {

    let countryData: Datum
    
    var name: String {
        return self.countryData.name
    }
    var code: String {
        return self.countryData.code
    }
}
