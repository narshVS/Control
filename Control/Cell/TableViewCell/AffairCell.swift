//
//  AffairCell.swift
//  ControlApp
//
//  Created by Влад Овсюк on 24.10.2020.
//

import UIKit

// MARK: - Protocol

protocol AffairCellDelegate: class {
    func didSelect(affair: Affair)
}

final class AffairCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var affairTimeLabel: UILabel!
    @IBOutlet weak var affairDescriptionLable: UILabel!
    @IBOutlet weak var cheBoxButton: UIButton!
    
    // MARK: - Link Properties
    
    weak var delegate: AffairCellDelegate?
    
    // MARK: - Private Propertes
    
    private var selectedAffair: Affair?
    
    // MARK: - Static Properties
    
    static let reusableId = "AffairCell"
    
    // MARK: - Public Metod
    
    func configure(with affair: Affair) {
        selectedAffair = affair
        
        affairTitleLabel.text = affair.title
        affairDescriptionLable.text = affair.descript
        
        setTimeLabelText()
        configureView()
        setCheckBox(squareButtonIsEnable: affair.isDone)
    }
    
    // MARK: - Private Metod
    
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
    
    private func setTimeLabelText() {
        let hour = "\(ChangeTypeHelper.changeType.hourShortToLong(date: (selectedAffair?.dateAffair)!))"
        let minute = "\(ChangeTypeHelper.changeType.minuteShortToLong(date: (selectedAffair?.dateAffair)!))"
        
        affairTimeLabel.text = "\(hour):\(minute)"
    }
    
    // MARK: - Action
    
    @IBAction func settingAffairTapped(_ sender: Any) {
        delegate?.didSelect(affair: selectedAffair!)
    }
}
