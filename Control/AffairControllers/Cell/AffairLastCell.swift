//
//  AffairLastCell.swift
//  Control
//
//  Created by Влад Овсюк on 24.10.2020.
//

import UIKit

final class AffairLastCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var topLineView: UIView!
    
    
    static let reusableId = "AffairLastCell"
    
    func configure(with affair: AffairModel) {
        configureView()
        affairTitleLabel.text = affair.affairTitle
        setCheckBox(affair.affaitIsDone)
    }
    
    
    func setCheckBox(_ squareButtonIsEnable: Bool) {
        if squareButtonIsEnable == true {
            squareButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            affairTitleLabel.alpha = 0.5
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        } else {
            squareButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            affairTitleLabel.alpha = 1
            affairTitleLabel.strikeThrough(squareButtonIsEnable)
        }
    }
    
    private func configureView() {
        backgroundCellView.layer.cornerRadius = 10
    }
    
    private func configureSome() {
        
    }
}
