//
//  AddTextForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 26.10.2020.
//

import UIKit

final class AddTextForAffairViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var affairTitleTextField: UITextField!
    @IBOutlet weak var affairDescriptionTextView: UITextView!
    
    // MARK: - Acction
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddDateForAffairSegue", sender: self)
    }
    
    // MARK: - Segue Action
    
    @IBSegueAction func segueAddDateForAffairViewController(_ coder: NSCoder) -> AddDateForAffairViewController? {
        let controller = AddDateForAffairViewController(coder: coder)
        controller?.affairTitleText = affairTitleTextField.text ?? "Title"
        controller?.affairDescriptionText = affairDescriptionTextView.text ?? "Description"
        return controller
    }
}
