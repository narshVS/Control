//
//  SelectedAffair.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class SelectedAffair: UIViewController {
    
    @IBOutlet weak var affairTitleLabel: UILabel!
    @IBOutlet weak var affairDescriptionLabel: UILabel!
    @IBOutlet weak var affairTimeLabel: UILabel!
    
    var affairModel: AffairModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        affairTitleLabel.text = affairModel?.affairTitle
        affairDescriptionLabel.text = affairModel?.affairDescription
        affairTimeLabel.text = affairModel?.affairTime
    }
}
