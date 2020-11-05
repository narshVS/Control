//
//  AffairCell.swift
//  ControlApp
//
//  Created by Влад Овсюк on 24.10.2020.
//

import UIKit

protocol AffairCellDelegate: class {
    func didSelect(affair: Affair)
}

final class AffairCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var affairTimeLabel: UILabel!
    @IBOutlet weak var affairDescriptionLable: UILabel!
    @IBOutlet weak var cheBoxButton: UIButton!
    
    weak var delegate: AffairCellDelegate?
    
    private var selectedAffait: Affair?
    
    static let reusableId = "AffairCell"
    
    func configure(with affair: Affair) {
        affairTitleLabel.text = affair.title
        affairDescriptionLable.text = affair.descript
        affairTimeLabel.text = affair.time
        selectedAffait = affair
        
        configureView()
        setCheckBox(squareButtonIsEnable: affair.isDone)
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
        affairDescriptionLable.alpha = 0.7
    }
    
    @IBAction func settingAffairTapped(_ sender: Any) {
        delegate?.didSelect(affair: selectedAffait!)
    }
}
