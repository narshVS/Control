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
    
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var affairTimeLabel: UILabel!
    @IBOutlet weak var affairDescriptionLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
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
        
        setAffairDescriptionLable()
        setTimeLabelText()
        configureView()
        setCheckBox(squareButtonIsEnable: affair.isDone)
    }
    
    // MARK: - Private Metod
    
    private func setCheckBox(squareButtonIsEnable: Bool) {
        if squareButtonIsEnable == true {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOn"), for: .normal)
            affairTitleLabel.alpha = 0.3
            affairTimeLabel.alpha = 0.3
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        } else {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOff"), for: .normal)
            affairTitleLabel.alpha = 1
            affairTimeLabel.alpha = 1
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        }
    }
    
    private func configureView() {
        affairDescriptionLabel.alpha = 0.7
    }
    
    private func setAffairDescriptionLable() {
        let descript = descriptIsEmoty(hour: selectedAffair!.dateAffair!.getDateInt(.hour))
        selectedAffair!.descript! == "" ? (affairDescriptionLabel.text = descript) :(affairDescriptionLabel.text = selectedAffair?.descript)
    }
    
    private func descriptIsEmoty(hour: Int) -> String {
        var descript: String = ""
        switch hour {
            case 6...11:
                descript = NSLocalizedString("Have a nice day", comment: "")
        case 12...14:
            descript = NSLocalizedString("Don't forget about lunch", comment: "")
        case 15...16:
            descript = NSLocalizedString("Good luck in your endeavors", comment: "")
        case 17...19:
            descript = NSLocalizedString("You had dinner?", comment: "")
        case 20...22:
            descript = NSLocalizedString("I advise getting ready for bed", comment: "")
        case 23...24:
            descript = NSLocalizedString("Good night", comment: "")
        case 00...05:
            descript = NSLocalizedString("Save for later, sleep is more important", comment: "")
        default:
            break
        }
        return descript
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
