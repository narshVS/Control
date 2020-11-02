//
//  AffairCell.swift
//  ControlApp
//
//  Created by Влад Овсюк on 24.10.2020.
//

import UIKit

final class AffairCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var affairTimeLabel: UILabel!
    @IBOutlet weak var affairDescriptionLable: UILabel!
    @IBOutlet weak var cheBoxButton: UIButton!
    
    static let reusableId = "AffairCell"
    
    func configure(with affair: AffairModel) {
        affairTitleLabel.text = affair.affairTitle
        affairDescriptionLable.text = affair.affairDescription
        affairTimeLabel.text = affair.affairTime
        
        configureView()
        setCheckBox(squareButtonIsEnable: affair.affaitIsDone)
    }
    
    private func setCheckBox(squareButtonIsEnable: Bool) {
        if squareButtonIsEnable == true {
            cheBoxButton.setBackgroundImage(UIImage(named: "checkBoxOn"), for: .normal)
            affairTitleLabel.alpha = 0.3
            affairTimeLabel.alpha = 0.3
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        } else {
            cheBoxButton.setBackgroundImage(UIImage(named: "checkBoxOff"), for: .normal)
            affairTitleLabel.alpha = 1
            affairTimeLabel.alpha = 1
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        }
    }
    
    private func configureView() {
//        backgroundCellView.layer.cornerRadius = 10
        affairDescriptionLable.alpha = 0.7
    }
}
