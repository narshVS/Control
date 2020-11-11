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
            descript = "Хорошего дня"
        case 12...14:
            descript = "Не забудьте про обед"
        case 15...16:
            descript = "Удачи в ваших начинаниях"
        case 17...19:
            descript = "Вы поужинали?"
        case 20...22:
            descript = "Советую готовится ко сну"
        case 23...24:
            descript = "Добрых снов"
        case 00...05:
            descript = "Отлижите на потом, сон важнее"
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
