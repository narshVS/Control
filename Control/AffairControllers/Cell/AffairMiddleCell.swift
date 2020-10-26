//
//  AffairMiddleCell.swift
//  Control
//
//  Created by Влад Овсюк on 23.10.2020.
//

import UIKit

final class AffairMiddleCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var squareButton: UIButton!
    
    static let reusableId = "AffairMiddleCell"

    private var squareButtonIsEnable: Bool = false

    func configure(with affair: AffairModel) {
        affairTitleLabel.text = affair.affairTitle
        configureView()
    }
    
    @IBAction func squareTapped(_ sender: Any) {
        if squareButtonIsEnable == false {
            squareButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            squareButtonIsEnable = true
        } else {
            squareButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            squareButtonIsEnable = false
        }
    }
    
    private func configureView() {
        backgroundCellView.layer.cornerRadius = 10
    }
    
    private func configureSquare() {

    }
}