//
//  DetailViewModel.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import Foundation

struct DetailViewModel {
    
    let detailCountry: DetailModel?
    
    init(detail: DetailModel) {
        detailCountry = detail
    }
    
    var imageUrl: String {
        return self.detailCountry?.data.flagImageURI ?? "imageUrl is not exist"
    }
    
    var wikiId: String {
        return self.detailCountry?.data.wikiDataID ?? "wikiId is not exist"
    }
    
    var name: String {
        return self.detailCountry?.data.name ?? "name is not exist"
    }
}

