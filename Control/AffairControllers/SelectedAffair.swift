//
//  SelectedAffair.swift
//  ControlApp
//
//  Created by Влад Овсюк on 31.10.2020.
//

import UIKit

final class SelectedAffair: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Public Properties

    var affair: Affair?
    var weekday: Int?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        
        timeLabel.layer.cornerRadius = 5
        timeLabel.layer.masksToBounds = true
    }
    
    // MARK: - Private Metod
    
    private func configueView() {
        titleTextField.text = affair?.title
        descriptionTextView.text = affair?.descript
        setTimeLabel()
        setDateLabel()
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.layer.cornerRadius = 5
    }
    
    private func setTimeLabel() {
        let hour = "\(ChangeTypeHelper.changeType.hourShortToLong(date: (affair?.dateAffair)!))"
        let minute = "\(ChangeTypeHelper.changeType.minuteShortToLong(date: (affair?.dateAffair)!))"
        timeLabel.text = "\(hour):\(minute)"
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 20
    }
    
    private func setDateLabel() {
        let weekdayString = "\(ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: weekday!))"
        let day = affair?.dateAffair?.getDateInt(.day)
        let monthInt = affair?.dateAffair?.getDateInt(.month)
        let monthString = "\(ChangeTypeHelper.changeType.monthIntToStringLong(month: monthInt!))"
        let year = affair?.dateAffair?.getDateInt(.year)
        dateLabel.text = "\(weekdayString), \(monthString) \(day ?? 0), \(year ?? 0000)"
    }
    
    // MARK: - Action
    
    @IBAction func savaAffair(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAffair(_ sender: Any) {
        performSegue(withIdentifier: "SelectedAffairUnwindSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controlViewController = segue.destination as? ControlViewController else { return }
        controlViewController.affairManager.deleteAffair(object: affair!)
        controlViewController.configureAfterUnwind()
    }
}
