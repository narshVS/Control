//
//  DeedFirstCell.swift
//  Control
//
//  Created by Влад Овсюк on 24.10.2020.
//

import UIKit

final class AffairFirstCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var deedTitleLabel: UILabel!
    @IBOutlet weak var squareButton: UIButton!
    
    static let reusableId = "DeedFirstCell"
    
    private var squareButtonIsEnable: Bool = false

    func configure(with deed: AffairModel) {
        deedTitleLabel.text = deed.deedTitle
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