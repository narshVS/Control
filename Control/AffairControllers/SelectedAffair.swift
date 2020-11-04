//
//  SelectedAffair.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class SelectedAffair: UIViewController {
    
    @IBOutlet weak var affairTimeLabel: UILabel!
    @IBOutlet weak var affairTitleTextField: UITextField!
    @IBOutlet weak var affairDescriptionTextView: UITextView!

    var affairModel: AffairModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueController()
        
        affairTimeLabel.layer.cornerRadius = 5
        affairTimeLabel.layer.masksToBounds = true
    }
    
    private func configueController() {
        affairTimeLabel.text = affairModel?.affairTime
        affairTitleTextField.text = affairModel?.affairTitle
        affairDescriptionTextView.text = affairModel?.affairDescription
    }
}
