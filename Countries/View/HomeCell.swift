//
//  SavedCell.swift
//  Countries
//
//  Created by Sezgin Çiftci on 8.01.2022.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    var countryLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favoriteButton = UIButton()
    
    var buttonIsSelected: Bool? {
        didSet {
            favoriteButton.addTarget(self, action: #selector(changeButtonFunc), for: .touchUpInside)
            if buttonIsSelected == true {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    private var countryImageView = UIImageView()
    var code = ""
    var wikiCode = ""
    var row: Int = 0
    var selectedId = UUID()
    
    private var countryVM: CountryViewModel?
    private var detailVM: DetailViewModel?
    private var coreVM: CoreDataViewModel?
    private var coreDetailVM: CoreDetailViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    @objc func changeButtonFunc() {
        if buttonIsSelected == false {
            loadDetailData()
            CoreDataManager.shared.saveData(name: self.countryLabel.text ?? "no country name", url: self.wikiCode, code: self.code, id: UUID(), image: self.countryImageView.image)
              
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            buttonIsSelected = true
        } else {
            CoreDataManager.shared.deleteCountry(chosenId: selectedId) { viewModel in
                self.coreDetailVM = viewModel
                
                self.coreVM?.nameArray.remove(at: row)
                self.coreVM?.urlArray.remove(at: row)
                self.coreVM?.codeArray.remove(at: row)
                self.coreVM?.idArray.remove(at: row)
                self.coreVM?.imageArray.remove(at: row)
                
                NotificationCenter.default.post(name: NSNotification.Name("deletedData"), object: nil)
                buttonIsSelected = false
            }
            
        }
    }
    
    private func loadDetailData() {
        
        let urlString = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(code)?rapidapi-key=7bbf24ae54msh0a092ad9943dd4bp1fb3f3jsn161191b539de"
        let url = URL(string: urlString)
        WebserviceForDetail().fetchDetailData(url: url!) { details in
            if let details = details {
                self.detailVM = DetailViewModel(detail: details)
                DispatchQueue.main.async {
                    self.updateDetail(image: self.detailVM?.imageUrl, wikiId: self.detailVM!.wikiId)
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
        
    func setCell(_ countryVM: CountryViewModel, completion: @escaping () -> ()) {
        
        self.countryVM = countryVM
        self.updateCell(name: countryVM.name)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(countryLabel)
        countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.alpha = 0.5
        favoriteButton.tintColor = .black

        completion()
    }
    
    private func updateCell(name: String) {
        self.countryLabel.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

