//
//  HomeViewController.swift
//  Countries
//
//  Created by Sezgin Çiftci on 7.01.2022.
//

import UIKit

class HomeViewController: UITabBarController {
    
    let homeCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HomeCell.self, forCellWithReuseIdentifier: Cell_ID.homeCell.rawValue)
        return cv
    }()
    
    private var countryListVM: CountryListViewModel!
    private var coreVM : CoreDataViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCV.delegate = self
        homeCV.dataSource = self
        setupUI()
        configureCV()
        loadCountryData()
        loadCoreData()
        notificationForCV()
    }
    
    private func notificationForCV() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadCoreData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadCoreData), name: NSNotification.Name(rawValue: "deletedData"), object: nil)
    }
  
 
    @objc private func loadCoreData() {
        CoreDataManager.shared.loadData { viewModel in
            DispatchQueue.main.async {
                self.coreVM = viewModel
                self.homeCV.reloadData()
            }
        }
    }
    
    private func loadCountryData() {
        
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/?rapidapi-key=7bbf24ae54msh0a092ad9943dd4bp1fb3f3jsn161191b539de&limit=10"
        let url = URL(string: urlString)
        Webservice().fetchCountryData(url: url!) { countries in
            if let countries = countries {
                self.countryListVM = CountryListViewModel(countryData: countries)
                DispatchQueue.main.async {
                    self.homeCV.reloadData()
                }
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
        view.addSubview(homeCV)
        homeCV.translatesAutoresizingMaskIntoConstraints = false
        homeCV.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeCV.backgroundColor = .secondarySystemBackground
    }
}

//MARK: - CollectionView Delegate Methods

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/13)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.countryListVM != nil {
            return self.countryListVM.numberOfRowsInSection()
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID.homeCell.rawValue, for: indexPath) as! HomeCell
        let countryVM = self.countryListVM.cellForRowAt(indexPath.row)
        cell.setCell(countryVM) {
            
            if let nameArray = self.coreVM?.nameArray {
                if let coreRow = nameArray.firstIndex(of: cell.countryLabel.text!) {
                    cell.row = coreRow
                    if let coreId = self.coreVM?.idArray {
                        cell.selectedId = coreId[coreRow]
                    } else {
                        print("no data")
                    }
                }
                if ((nameArray.contains(cell.countryLabel.text!))) {
                    cell.buttonIsSelected = true
                } else {
                    cell.buttonIsSelected = false
                }
            } else {
                cell.buttonIsSelected = false
            }
        }
        
        cell.code = countryVM.code
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailCardViewController()
        
        let countryVM = self.countryListVM.cellForRowAt(indexPath.row)
        detailVC.title = countryVM.name
        detailVC.code = countryVM.code
        detailVC.countryImageView.image = UIImage(named: "placeholder")
        
        if let nameArray = self.coreVM?.nameArray {
            if nameArray != [] {
                if let coreRow = coreVM?.nameArray.firstIndex(of: detailVC.title!) {
                    detailVC.row = coreRow
                    if let coreId = self.coreVM?.idArray {
                        detailVC.selectedId = coreId[coreRow]
                    } else {
                        print("no data")
                    }
                    if nameArray.contains(detailVC.title!) {
                        detailVC.currentImage = UIImage(systemName: "star.fill")!
                    } else {
                       detailVC.currentImage = UIImage(systemName: "star")!
                    }
                } else {
                    detailVC.currentImage = UIImage(systemName: "star")!
                }
            } else {
                detailVC.currentImage = UIImage(systemName: "star")!
            }
        } else {
            detailVC.currentImage = UIImage(systemName: "star")!
        }
        
        let navVC = UINavigationController(rootViewController: detailVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        
    }
    
}

