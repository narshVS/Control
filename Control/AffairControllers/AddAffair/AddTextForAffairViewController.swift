//
//  AddTextForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 26.10.2020.
//

import UIKit

final class AddTextForAffairViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var affairTitleTextField: UITextField!
    @IBOutlet weak var affairDescriptionTextView: UITextView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddDateForAffairViewController", sender: self)
    }
    
    
    @IBSegueAction func segueAddDateForAffairViewController(_ coder: NSCoder) -> AddDateForAffairViewController? {
        let controller = AddDateForAffairViewController(coder: coder)
        controller?.titleText = affairTitleTextField.text ?? "Title"
        controller?.descriptionText = affairDescriptionTextView.text
        return controller
    }
}
