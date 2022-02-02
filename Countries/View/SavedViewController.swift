//
//  SavedViewController.swift
//  Countries
//
//  Created by Sezgin Çiftci on 7.01.2022.
//

import UIKit
import CoreData


class SavedViewController: UITabBarController {
          
    var savedCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SaveCell.self, forCellWithReuseIdentifier: Cell_ID.saveCell.rawValue)
        return cv
    }()
    
    private var coreVm: CoreDataViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCV.delegate = self
        savedCV.dataSource = self
        
        setupUI()
        configureCV()
        loadSavedData()
        notificationForCV()
    }
    
    private func notificationForCV() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadSavedData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadSavedData), name: NSNotification.Name(rawValue: "deletedData"), object: nil)
    }
 
    @objc private func loadSavedData() {
        
            CoreDataManager.shared.loadData { viewModel in
                DispatchQueue.main.async {
                    self.coreVm = viewModel
                    self.savedCV.reloadData()
                }
            }
    }
    
    
    private func setupUI() {
        
        title = "Countries"
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 20)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        view.backgroundColor = .secondarySystemBackground
        
    }
    
    private func configureCV() {
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(savedCV)
        savedCV.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        savedCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        savedCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        savedCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        savedCV.backgroundColor = .secondarySystemBackground
    }
    
}

//MARK: - CollectionView Delegate Methods

extension SavedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/13)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.coreVm?.nameArray != nil {
            return  (self.coreVm?.nameArray.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID.saveCell.rawValue, for: indexPath) as! SaveCell
        
        cell.setCell()
        cell.countryLabel.text = self.coreVm?.nameArray[indexPath.row]
        cell.buttonIsSelected = true
        cell.row = indexPath.row
        cell.selectedId =  (self.coreVm?.idArray[indexPath.row])!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailCardViewController()
        
        detailVC.title = coreVm?.nameArray[indexPath.row]
        detailVC.code = (coreVm?.codeArray[indexPath.row])!
        detailVC.wikiCode = (coreVm?.urlArray[indexPath.row])!
        detailVC.selectedId = (coreVm?.idArray[indexPath.row])!
        detailVC.row = indexPath.row
        detailVC.currentImage = UIImage(systemName: "star.fill")!
        detailVC.countryImageView.image = UIImage(named: "placeholder")
        
        let navVC = UINavigationController(rootViewController: detailVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
}
