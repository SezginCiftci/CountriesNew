//
//  SaveCell.swift
//  Countries
//
//  Created by Sezgin Çiftci on 9.01.2022.
//

import UIKit

class SaveCell: UICollectionViewCell {
        
    var countryLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favoriteButton = UIButton()
    
    var buttonIsSelected: Bool? {
        didSet {
            favoriteButton.addTarget(self, action: #selector(deleteSavedItem), for: .touchUpInside)
            if buttonIsSelected == true {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
   
    var coreDataVM: CoreDataViewModel?
    var coreDetailVM: CoreDetailViewModel?
    
    var row: Int = 0
    var selectedId = UUID()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setCell()
    }
   
    @objc func deleteSavedItem() {
        buttonIsSelected = false
       
        CoreDataManager.shared.deleteCountry(chosenId: selectedId) { viewModel in
            self.coreDetailVM = viewModel
            self.coreDataVM?.nameArray.remove(at: row)
            self.coreDataVM?.urlArray.remove(at: row)
            self.coreDataVM?.codeArray.remove(at: row)
            self.coreDataVM?.idArray.remove(at: row)
            self.coreDataVM?.imageArray.remove(at: row)
                        
            NotificationCenter.default.post(name: NSNotification.Name("deletedData"), object: nil)
        }
        
    }
    
    
    func setCell() {
        
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
      
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

