//
//  SelectedAffairTableViewController.swift
//  Control
//
//  Created by Влад Овсюк on 11.11.2020.
//

import UIKit

final class SelectedAffairTableViewController: UITableViewController, UITextViewDelegate {
    
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
    
    // MARK: - Private Properties
    
    private var checkBoxState: Bool?
    private var affairDate: Date?
    private let userDefaults = UserDefaults.standard
    
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
        configureDateForLabel()
    }
    
    private func configureDateForLabel() {
        affairDate = affair?.dateAffair
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
        timeLabel.layer.borderColor = UIColor.placeholderText.cgColor
    }
    
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
        picker.locale = NSLocale(localeIdentifier: NSLocalizedString("en_GB", comment: "Picker locale")) as Locale
    }
    
    /// Change image by is done
    private func setCheckBox() {
        if checkBoxState == true {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOn"), for: .normal)
        } else {
            checkBoxButton.setBackgroundImage(UIImage(named: "checkBoxOff"), for: .normal)
        }
    }
    
    private func setDafaultDateForPicker() {
        picker.date = affair?.dateAffair ?? Date()
    }
    
    /// Сustomization theme by user setting
    private func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
        
        if userDefaults.bool(forKey: "themeIsReset") == true {
            userDefaults.bool(forKey: "systemThemeIsDark") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    /// Сustomization logo by user theme mode
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
    
    /// Gesture for hide keyboard
    private func configureGestureRecognizerForHideKeyboard() {
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    /// Alert for emty title
    private func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("The affair is not filled", comment: "Title alert"), message: NSLocalizedString("Please enter event", comment: ""),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Exit", comment: "Exit fror aler"),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Objc Metod
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        if checkBoxState == true {
            checkBoxState = false
        } else {
            checkBoxState = true
        }
        setCheckBox()
    }
    
    @IBAction func saveAffair(_ sender: Any) {
        if titleTextField.text!.isEmpty {
            showAlert()
        } else {
            AffairManager.manager.exchangeAffair(object: affair!, title: titleTextField.text!, descript: descriptionTextView.text, isDone: checkBoxState!, dayAffair: picker.date)
            performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
        }
    }
    
    @IBAction func deleteAffair(_ sender: Any) {
        AffairManager.manager.deleteAffair(object: affair!)
        performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
    }
    
    @IBAction func pickerViewDidSelectRow(_ sender: Any) {
        affairDate = picker.date
        setDateOnLabel()
        setTimeOnLabel()
    }
    
    // MARK: - UITextViewDelegate
    /// Placeholder for text view
    
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
    
    /// Chande theme mode
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
