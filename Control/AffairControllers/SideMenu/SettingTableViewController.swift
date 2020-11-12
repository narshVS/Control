//
//  SettingTableViewController.swift
//  Control
//
//  Created by Влад Овсюк on 11.11.2020.
//

import UIKit

class SettingTableViewController: UITableViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var clearDataSwitch: UISwitch!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwitchOn()
        configureTheme()
        configureLogo()
    }
    
    // MARK: - Private Metod
    
    private func setSwitchOn() {
        if self.traitCollection.userInterfaceStyle == .dark {
            darkModeSwitch.setOn(true, animated: false)
        } else {
            darkModeSwitch.setOn(false, animated: false)
        }
    }
    
    private func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
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
    
    private func setThemeSwitchWasPressed() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.setValue(false, forKey: "themeSwitchWasPressed")
            userDefaults.setValue(true, forKey: "themeIsReset")
        } else {
            userDefaults.setValue(true, forKey: "themeSwitchWasPressed")
            userDefaults.setValue(false, forKey: "themeIsReset")
        }
    }
    
    // MARK: - Action
    
    @IBAction func darkModeSwitchTapped(_ sender: Any) {
        setThemeSwitchWasPressed()
        
        if darkModeSwitch.isOn == true {
            userDefaults.set(true, forKey: "darkModeIsOn")
        } else {
            userDefaults.set(false, forKey: "darkModeIsOn")
        }
        userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        configureLogo()
    }
    
    @IBAction func deleteAllData(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Confirm action", comment: "Confirn select"), message: NSLocalizedString("Are you sure?", comment: "You sure?"),
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dalate all", comment: "Crear all affirs"),
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        AffairManager.manager.clearData()
                                        self.clearDataSwitch.isOn = false
                                      }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cansel", comment: "Cansel"),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.clearDataSwitch.isOn = false
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Override View Controller
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureLogo()
        }
    }
}
