//
//  CoreDataViewModel.swift
//  Countries
//
//  Created by Sezgin Çiftci on 9.01.2022.
//

import UIKit

struct CoreDataViewModel {
    
    var nameArray = [String]()
    var urlArray = [String]()
    var codeArray = [String]()
    var idArray = [UUID]()
    var imageArray = [UIImage]()
 
    
}

struct CoreDetailViewModel {
    
    
    var name: String?
    var url: String?
    var code: String?
    var id: UUID?
    var countryImage: UIImage?
}


