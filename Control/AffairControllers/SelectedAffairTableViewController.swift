//
//  SelectedAffairTableViewController.swift
//  Control
//
//  Created by Влад Овсюк on 11.11.2020.
//

import UIKit

class SelectedAffairTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var affair: Affair?
    
    // MARK: - Public Properties
    
    private var darkModeIsOn: Bool = UserDefaults.standard.bool(forKey: "darkModeIsOn")
    private var themeSwitchWasPressed: Bool = UserDefaults.standard.bool(forKey: "themeSwitchWasPressed")
    private var checkBoxState: Bool?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        configureDatePicker()
        setDafaultDateForPicker()
        configureCheckBoxButton()
        configureGestureRecognizerForHideKeyboard()
    }
    
    // MARK: - Private Metod
    
    private func configueView() {
        configureTextField()
        configureTextView()
        configureTheme()
        configureLogo()
        setDateOnLabel()
        setTimeOnLabel()
    }
    
    private func setDateOnLabel() {
        let day = affair?.dateAffair?.getDateInt(.day)
        let monthInt = affair?.dateAffair?.getDateInt(.month)
        let monthString = "\(ChangeTypeHelper.changeType.monthIntToStringLong(month: monthInt!))"
        let year = affair?.dateAffair?.getDateInt(.year)
        let weedayInt = affair?.dateAffair?.getDateInt(.weekday)
        let weekdayString = "\(ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: weedayInt!))"
        dateLabel.text = "\(weekdayString), \(monthString) \(day!), \(year!)"
    }
    
    private func setTimeOnLabel() {
        let hour = "\(ChangeTypeHelper.changeType.hourShortToLong(date: (affair?.dateAffair)!))"
        let minute = "\(ChangeTypeHelper.changeType.minuteShortToLong(date: (affair?.dateAffair)!))"
        timeLabel.text = "\(hour):\(minute)"
        timeLabel.layer.borderWidth = 1.0
        timeLabel.layer.cornerRadius = 5
        timeLabel.layer.borderColor = UIColor.placeholderText.cgColor    }
    
    private func configureTextField() {
        titleTextField.text = affair?.title
    }
    
    private func configureTextView() {
        descriptionTextView.text = affair?.descript
        descriptionTextView.delegate = self
        textViewDidEndEditing(descriptionTextView)
    }
    
    private func configureCheckBoxButton() {
        checkBoxState = affair?.isDone
        setCheckBox()
    }
    
    private func configureDatePicker() {
        picker.locale = NSLocale(localeIdentifier: NSLocalizedString("en_US", comment: "Picker locale")) as Locale
    }
    
    private func setCheckBox() {
        if checkBoxState == true {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOn"), for: .normal)
        } else {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOff"), for: .normal)
        }
    }
    
    private func setDafaultDateForPicker() {
        picker.date = (affair?.dateAffair)!
    }
    
    private func configureTheme() {
        if themeSwitchWasPressed == true {
            darkModeIsOn == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    private func configureLogo() {
        if self.traitCollection.userInterfaceStyle == .light  {
            do {
            let gif = try UIImage(gifName: "controlLogoWhite.gif")
                self.logoImageView.setGifImage(gif, loopCount: -1) }
            catch {
                print("Ooops, loading error!")
            }
        } else {
            do {
            let gif = try UIImage(gifName: "controlLogoClear.gif")
                self.logoImageView.setGifImage(gif, loopCount: -1) }
            catch {
                print("Ooops, loading error!")
            }
        }
    }
    
    private func configureGestureRecognizerForHideKeyboard() {
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Select an action", comment: "Select action"), message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cansel", comment: "Exit from alert"),
                                      style: UIAlertAction.Style.cancel,
                                      handler: {(_: UIAlertAction!) in
                                      }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "Save change"),
                                      style: UIAlertAction.Style.default,
                                      handler: { [self](_: UIAlertAction!) in
                                        AffairManager.manager.exchangeAffair(object: affair!,
                                                                             title: titleTextField.text!,
                                                                             descript: descriptionTextView.text,
                                                                             isDone: checkBoxState!,
                                                                             dayAffair: (affair?.dateAffair)!)
                                        performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
                                      }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete affir"),
                                      style: UIAlertAction.Style.destructive,
                                      handler: { [self](_: UIAlertAction!) in
                                        AffairManager.manager.deleteAffair(object: affair!)
                                        self.performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Objc Metod
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Action
    @IBAction func checkBoxTapped(_ sender: Any) {
        if checkBoxState == true {
            checkBoxState = false
        } else {
            checkBoxState = true
        }
        setCheckBox()
    }
    
    @IBAction func changeAffair(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func pickerViewDidSelectRow(_ sender: Any) {
        affair?.dateAffair = picker.date
        setDateOnLabel()
        setTimeOnLabel()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.placeholderText {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = NSLocalizedString("Descriptios", comment: "Placehorder for text view")
            descriptionTextView.textColor = UIColor.placeholderText
        }
    }
    
    // MARK: - Override View Controller
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureLogo()
            setTimeOnLabel()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        controlViewController.configureAfterUnwind()
    }
}
