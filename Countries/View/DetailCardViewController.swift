//
//  DetailCardViewController.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import UIKit
import SVGKit


class DetailCardViewController: UIViewController {
  
    var countryImageView = UIImageView()
    var countryCodeLabel = UILabel()
    var infoButton = UIButton()
    
    lazy var code = ""
    lazy var wikiCode = ""
    lazy var row: Int = 0
    
    lazy var currentImage = UIImage()

    private var detailVM: DetailViewModel!
    private var coreDetailVM: CoreDetailViewModel?
    private var coreDataVM: CoreDataViewModel?
    
    var selectedId = UUID()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        loadDetailData()
    }

    
    private func loadDetailData() {
        
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(code)?rapidapi-key=7bbf24ae54msh0a092ad9943dd4bp1fb3f3jsn161191b539de"
        let url = URL(string: urlString)
        WebserviceForDetail().fetchDetailData(url: url!) { details in
            if let details = details {
                self.detailVM = DetailViewModel(detail: details)
                DispatchQueue.main.async {
                    self.updateDetail(image: self.detailVM.imageUrl, wikiId: self.detailVM.wikiId)
                }
            }
        }
    }
    
    private func updateDetail(image: String?, wikiId: String) {
        
        self.wikiCode = wikiId
        let imageUrl = image
        if let imageUrl = imageUrl {
            let url = URL(string: imageUrl)
            self.countryImageView.downloadedsvg(from: url!)
        }
    }
    
    private func setUI() {
        
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(countryImageView)
        countryImageView.translatesAutoresizingMaskIntoConstraints = false
        countryImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        countryImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countryImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        countryImageView.contentMode = .scaleAspectFit
        
        view.addSubview(countryCodeLabel)
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.topAnchor.constraint(equalTo: countryImageView.bottomAnchor, constant: 15).isActive = true
        countryCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        countryCodeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        countryCodeLabel.textColor = .black
        countryCodeLabel.backgroundColor = .clear
        countryCodeLabel.text = "Country Code: \(code)"
        countryCodeLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        view.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.topAnchor.constraint(equalTo: countryCodeLabel.bottomAnchor, constant: 15).isActive = true
        infoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        infoButton.setTitle("For More Information", for: .normal)
        infoButton.setTitleColor(.white, for: .normal)
        infoButton.backgroundColor = UIColor(red: 106/255, green: 90/255, blue: 205/255, alpha: 1)
        infoButton.setImage(UIImage(named: "arrow.right"), for: .normal)
        infoButton.imageView?.contentMode = .scaleAspectFill
        infoButton.imageView?.semanticContentAttribute = .forceRightToLeft
        infoButton.addTarget(self, action: #selector(goToUrl), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(exitPage))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: currentImage, style: .done, target: self, action: #selector(favorite))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func favorite() {
        let rightButton = navigationItem.rightBarButtonItem
        let star = UIImage(systemName: "star")
        let starFill = UIImage(systemName: "star.fill")
        
        if rightButton?.image == star {
            rightButton?.image = starFill
            
            CoreDataManager.shared.saveData(name: (navigationController?.title)!, url: wikiCode, code: code, id: UUID(), image: countryImageView.image)
            
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
        } else {

            rightButton?.image = star
            CoreDataManager.shared.deleteCountry(chosenId: selectedId) { viewModel in
                self.coreDetailVM = viewModel
                self.coreDataVM?.nameArray.remove(at: row)
                self.coreDataVM?.urlArray.remove(at: row)
                self.coreDataVM?.codeArray.remove(at: row)
                self.coreDataVM?.idArray.remove(at: row)
                self.coreDataVM?.imageArray.remove(at: row)
                
                NotificationCenter.default.post(name: NSNotification.Name("deletedData"), object: nil)
                self.navigationController?.popViewController(animated: true)
                
            }
        } 
    }
    
    
    @objc func goToUrl() {
        let urlString = "https://www.wikidata.org/wiki/\(wikiCode)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }
    
    @objc func exitPage() {
        self.dismiss(animated: true, completion: nil)
    }
}

