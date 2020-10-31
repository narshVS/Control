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
    
    var affairModel: [AffairModel] = []
    
    override func viewDidLoad() {
        affairTitleLabel.text = affairModel[0].affairTitle
        affairDescriptionLabel.text = affairModel[0].affairDescription
        affairTimeLabel.text = affairModel[0].affairTime
        super.viewDidLoad()
        
    }
}
