//
//  AffairCollectionViewCell.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class AffairCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dayButton: UIButton!
    
    // MARK: - Static Properties
    
    static let reusableId = "AffairCollectionViewCell"
    
    // MARK: - Private Properties
    
    private let metodsDate = ChangeTypeHelper()
    
    // MARK: - Public Metod
    
    func configure(with date: DateModel) {
        dayButton.setTitle("\(date.day)", for: .normal)
        weekdayLabel.text = metodsDate.weekdayIntToStringShort(weekday: date.weekdayInt)
        
        setSelect(dayIsSelect: date.dayIsSelected)
    }
    
    // MARK: - Privat Metod
    
    private func setSelect(dayIsSelect: Bool) {
        if dayIsSelect == true {
            dayButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        } else {
            dayButton.setBackgroundImage(nil, for: .normal)
        }
    }
}
