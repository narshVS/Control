//
//  AddTextForAffairViewController.swift
//  Control
//
//  Created by Влад Овсюк on 26.10.2020.
//

import UIKit

final class AddTextForAffairViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var affairTitleTextField: UITextField!
    @IBOutlet weak var affairDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureTextView()
    }
    
    // MARK: - Private Metod
    
    private func configureTextField() {
        affairTitleTextField.layer.borderWidth = 1.0
        affairTitleTextField.layer.cornerRadius = 5
        affairTitleTextField.layer.borderColor = UIColor.placeholderText.cgColor

    }
    
    private func configureTextView() {
        affairDescriptionTextView.delegate = self
        affairDescriptionTextView.layer.borderWidth = 1
        affairDescriptionTextView.layer.borderColor = UIColor.placeholderText.cgColor
        affairDescriptionTextView.layer.cornerRadius = 7
        affairDescriptionTextView.text = "Описание"
        affairDescriptionTextView.textColor = UIColor.placeholderText
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Поле не заполнено", message: "Пожалуйста введите действие",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Выход",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if affairDescriptionTextView.textColor == UIColor.placeholderText {
            affairDescriptionTextView.text = nil
            affairDescriptionTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if affairDescriptionTextView.text.isEmpty {
            affairDescriptionTextView.text = "Описание"
            affairDescriptionTextView.textColor = UIColor.placeholderText
        }
    }
    
    // MARK: - Acction
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTextButtonTapped(_ sender: Any) {
        affairTitleTextField.text!.isEmpty ? (showAlert()) : (performSegue(withIdentifier: "AddDateForAffairSegue", sender: self))
    }
    
    // MARK: - Segue Action
    
    @IBSegueAction func segueAddDateForAffairViewController(_ coder: NSCoder) -> AddDateForAffairViewController? {
        let controller = AddDateForAffairViewController(coder: coder)
        controller?.affairTitleText = affairTitleTextField.text ?? "Title"
        if affairDescriptionTextView.text == "Описание" {
            affairDescriptionTextView.text = ""
        } else {
            controller?.affairDescriptionText = affairDescriptionTextView.text ?? "Description"
        }
        return controller
    }
}
