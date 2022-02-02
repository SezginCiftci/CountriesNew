//
//  CoreDataManager.swift
//  Countries
//
//  Created by Sezgin Çiftci on 9.01.2022.
//

import UIKit
import CoreData

struct CoreDataManager {
    static var shared = CoreDataManager()
    
    func saveData(name: String, url: String, code: String, id: UUID, image: UIImage?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let selectedCountry = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: context)
        
        selectedCountry.setValue(name, forKey: "name")
        selectedCountry.setValue(url, forKey: "url")
        selectedCountry.setValue(code, forKey: "code")
        selectedCountry.setValue(id, forKey: "id")
        
        
        if let imageData = image?.jpegData(compressionQuality: 0.5) {
            selectedCountry.setValue(imageData, forKey: "image")
        }
        
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
    }
    
    func loadData(completion: ((_ viewModel: CoreDataViewModel) -> ())) {
        
        var viewModel = CoreDataViewModel()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                viewModel.nameArray.removeAll(keepingCapacity: false)
                viewModel.idArray.removeAll(keepingCapacity: false)
                viewModel.imageArray.removeAll(keepingCapacity: false)
                viewModel.urlArray.removeAll(keepingCapacity: false)
                viewModel.codeArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        viewModel.nameArray.append(name)
                    }
                    if let url = result.value(forKey: "url") as? String {
                        viewModel.urlArray.append(url)
                    }
                    if let code = result.value(forKey: "code") as? String {
                        viewModel.codeArray.append(code)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        viewModel.idArray.append(id)
                    }
                    if let imageData = result.value(forKey: "image") as? Data {
                        if let image = UIImage(data: imageData) {
                            viewModel.imageArray.append(image)
                        } else  {
                            viewModel.imageArray.append(UIImage(named: "placeholder")!)
                        }
                    }
                    completion(viewModel)
                }
            }
            
        } catch {
            
        }
        
    }
    
    func deleteCountry(chosenId: UUID, completion: ((_ viewModel: CoreDetailViewModel) -> ())) {
        
        var viewModel = CoreDetailViewModel()
        viewModel.id = chosenId
        
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
        let idString = chosenId.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count >= 0 {
               
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        if id == chosenId {
                            context.delete(result)
                            completion(viewModel)
                            do {
                                try context.save()
                            } catch {
                                print("error")
                            }

                            break
                        }
                    }
                }
            }
            
        } catch {
            
        }
    }
 
}


