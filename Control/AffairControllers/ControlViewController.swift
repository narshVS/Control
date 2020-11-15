//
//  ControlViewController.swift
//  ControlApp
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu
import SwiftyGif

final class ControlViewController: UIViewController {
    
    // MARK: - Outletx4
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet weak var titleSelectedDateLabel: UILabel!
    @IBOutlet weak var noAffairsLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Private properties
    
    private var selectedMonth: [DateModel] = []
    private var affairs: [Affair] = []
    private var selectedAffairs: [Affair] = []
    
    private var selectedAffair: Affair?
    private let pickerComponets: Int = 2
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Properties
    
    var sideMenu: SideMenuNavigationController?
    var selectedDay: DateModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSystemTheme()
        configureStartupView()
        configureSideMenu()
        configureDatePicker()
        configureGestureRecognizerForHidePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Public Metod
    
    func saveSelectAffairForSegue(affair: Affair) {
        selectedAffair = affair
        performSegue(withIdentifier: "SelectedAffairTapped", sender: self)
    }
    
    func configureAfterUnwind() {
        loadDataAffair()
        setAffairForSelectDate(selectDate: selectedDay)
        sortAffair()
        setTitleSelectedDateLabel(selectedDate: selectedDay)
        setCircleForSelectedDay(selectDay: selectedDay)
        scrollToTodayCollectionView(day: selectedDay)
        tableView.reloadData()
    }
    
    
    /// Сustomization theme by user setting
    func configureTheme() {
        if userDefaults.bool(forKey: "themeSwitchWasPressed") == true {
            userDefaults.bool(forKey: "darkModeIsOn") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
        
        if userDefaults.bool(forKey: "themeIsReset") == true {
            userDefaults.bool(forKey: "systemThemeIsDark") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
        }
    }
    
    /// Сustomization logo by user theme mode
    func configureLogo() {
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
    
    // MARK: - Private metod
    
    private func loadDataAffair() {
        AffairManager.manager.fetchAffairs { [weak self] affairs in
            self?.affairs = affairs
        }
    }
    
    private func configureStartupView() {
        configureTheme()
        configureLogo()
        loadDataAffair()
        setTitleSelectedDateLabel(selectedDate: DateHelper.date.getTodaysDate())
        getArrayDates(month: DateHelper.date.getTodaysDate().month, year: DateHelper.date.getTodaysDate().year)
        setAffairForSelectDate(selectDate: DateHelper.date.getTodaysDate())
        setCircleForSelectedDay(selectDay: DateHelper.date.getTodaysDate())
        scrollToTodayCollectionView(day: DateHelper.date.getTodaysDate())
        sortAffair()
        configureEmptyState()
    }
    
    private func setTitleSelectedDateLabel(selectedDate: DateModel) {
        let weekDayString: String = ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: selectedDate.weekdayInt)
        let monthString: String = ChangeTypeHelper.changeType.monthIntToStringLong(month: selectedDate.month)
        titleSelectedDateLabel.text = "\(weekDayString), \(monthString) \(selectedDate.day), \(selectedDate.year)"
    }
    
    /// Set array for collection view.
    private func getArrayDates(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        let dayInMonth = calendar.range(of: .day, in: .month, for: date)!
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        var weekday = firstWeekdayinMonth
        
        selectedMonth.removeAll()
        for day in dayInMonth {
            selectedMonth.append(DateModel(weekdayInt: weekday, day: day, month: month, year: year, hour: 0, minute: 0, dayIsSelected: false))
            
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    /// Collect array for selected date
    private func setAffairForSelectDate(selectDate: DateModel) {
        selectedDay = selectDate
        selectedAffairs.removeAll()
        affairs.forEach { affair in
            let date = affair.dateAffair?.getDateComponents(.day, .month, .year)
            let affairDay = (day: date?.day, month: date?.month, year: date?.year)
            let selectedDay = (day: selectDate.day, month: selectDate.month, year: selectDate.year)
            
            if affairDay == selectedDay {
                selectedAffairs.append(affair)
            }
        }
    }
    
    /// Hide/unhide emty state label
    private func configureEmptyState() {
        if selectedAffairs.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = NSLocalizedString("No affairs for today", comment: "Empty affair label")
        } else {
            noAffairsLabel.isHidden = true
        }
    }
    
    /// Sort affairs for time
    private func sortAffair() {
        selectedAffairs.sort{
            if $0.dateAffair?.getDateInt(.hour) == $1.dateAffair?.getDateInt(.hour) {
                return ($0.dateAffair?.getDateInt(.minute))! < ($1.dateAffair?.getDateInt(.minute))!
            }
            return ($0.dateAffair?.getDateInt(.hour))! < ($1.dateAffair?.getDateInt(.hour))!
        }
    }
    
    /// Save system theme for setting
    private func setSystemTheme() {
        self.traitCollection.userInterfaceStyle == .dark ? (userDefaults.setValue(true, forKey: "systemThemeIsDark")) : (userDefaults.setValue(false, forKey: "systemThemeIsDark"))
        userDefaults.setValue(false, forKey: "themeIsReset")
    }
    
    
    /// Gesture for hide picker
    private func configureGestureRecognizerForHidePicker() {
        let hidePickerGesture = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
        hidePickerGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(hidePickerGesture)
    }
    
    // MARK: - SideMenu Metods
    
    private func configureSideMenu() {
        let storybord = UIStoryboard(name: "Control", bundle: .main)
        let menuController = storybord.instantiateViewController(identifier: "MenuTableViewController") as! MenuTableViewController
        menuController.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    }
    
    func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingTableViewController") as! SettingTableViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func showForewordViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "ForewordViewController") as! ForewordViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func hideChildView() {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    // MARK: - Collection View Metod
    
    /// Set select circle
    private func setCircleForSelectedDay(selectDay: DateModel) {
        resetSelectCellCollectionView()
        
        selectedMonth[selectDay.day - 1] = .init(
            weekdayInt: selectedMonth[selectDay.day - 1].weekdayInt,
            day: selectedMonth[selectDay.day - 1].day,
            month: selectedMonth[selectDay.day - 1].month,
            year: selectedMonth[selectDay.day - 1].year,
            hour: selectedMonth[selectDay.day - 1].hour,
            minute: selectedMonth[selectDay.day - 1].minute,
            dayIsSelected: true)
    }
    
    /// Remove circle
    private func resetSelectCellCollectionView() {
        for date in selectedMonth {
            if date.dayIsSelected == true {
                selectedMonth[date.day - 1] = .init(weekdayInt: selectedMonth[date.day - 1].weekdayInt,
                                                    day: selectedMonth[date.day - 1].day,
                                                    month: selectedMonth[date.day - 1].month,
                                                    year: selectedMonth[date.day - 1].year,
                                                    hour: selectedMonth[date.day - 1].hour,
                                                    minute: selectedMonth[date.day - 1].minute,
                                                    dayIsSelected: false)
            }
        }
    }
    
    /// Scroll on selected day
    private func scrollToTodayCollectionView(day: DateModel) {
        let indexPath = IndexPath(item: day.day - 1, section: 0)
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    // MARK: - Picker Metod
    
    private func configureDatePicker() {
        datePicker.delegate = self
        datePicker.dataSource = self
        DateHelper.date.configue() // Set year array for picker
        setDafaultRowForPicker()
    }
    
    private func setDafaultRowForPicker() {
        datePicker.selectRow(selectedDay.month - 1, inComponent: 0, animated: false)
        datePicker.selectRow(1, inComponent: 1, animated: false)
    }
    
    // MARK: - Objc Metod
    
    /// Hide picker for gesture recognizer
    @objc func hidePicker() {
        datePicker.isHidden = true
    }
    
    // MARK: - Action
    
    /// Hide/unhide picker for tapped on button
    @IBAction func setDateTapped(_ sender: Any) {
        if datePicker.isHidden {
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
        }
    }
    
    /// Menu button tapped
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    /// New affair button tapped
    @IBAction func addAffairButton(_ sender: Any) {
        hidePicker()
    }
    
    @IBAction func unwindControlViewController(_ sender: UIStoryboardSegue) {  }
    
    // MARK: - Segue Action
    
    /// Setiing affair tapped
    @IBSegueAction func settingAffairTapped(_ coder: NSCoder) -> SelectedAffairTableViewController? {
        let controller = SelectedAffairTableViewController(coder: coder)
        controller?.affair = selectedAffair
        return controller
    }
    
    // MARK: - Override View Controller
    
    /// Chande theme mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureLogo()
        }
    }
}


// MARK: - UITableView

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedAffairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairCell.reusableId, for: indexPath) as! AffairCell
        cell.configure(with: selectedAffairs[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// set bool for done affair
        if selectedAffairs[indexPath.row].isDone == false {
            AffairManager.manager.exchangeAffair(object: selectedAffairs[indexPath.row], title: selectedAffairs[indexPath.row].title!, descript: selectedAffairs[indexPath.row].descript!, isDone: true, dayAffair: selectedAffairs[indexPath.row].dateAffair!)
        } else {
            AffairManager.manager.exchangeAffair(object: selectedAffairs[indexPath.row], title: selectedAffairs[indexPath.row].title!, descript: selectedAffairs[indexPath.row].descript!, isDone: false, dayAffair: selectedAffairs[indexPath.row].dateAffair!)
        }
        setAffairForSelectDate(selectDate: selectedDay)
        sortAffair()
        tableView.reloadData()
    }
}

// MARK: - UICollectionView

extension ControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffairCollectionViewCell.reusableId, for: indexPath) as! AffairCollectionViewCell
        cell.configure(with: selectedMonth[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hidePicker()
        selectedDay = selectedMonth[indexPath.row]
        setTitleSelectedDateLabel(selectedDate: selectedMonth[indexPath.row])
        setAffairForSelectDate(selectDate: selectedMonth[indexPath.row])
        setCircleForSelectedDay(selectDay: selectedMonth[indexPath.row])
        scrollToTodayCollectionView(day: selectedMonth[indexPath.row])
        sortAffair()
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UIPickerView

extension ControlViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return DateHelper.date.monthSourse.count
        }
        return DateHelper.date.yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        /// Date form picker
        let monthString: String = DateHelper.date.monthSourse[pickerView.selectedRow(inComponent: 0)]
        let yearInt: Int = DateHelper.date.yearSourse[pickerView.selectedRow(inComponent: 1)]
        
        /// Change type for metod
        let monthInt: Int = ChangeTypeHelper.changeType.monthStringToInd(month: monthString)
        let weekday: Int = DateHelper.date.firstWeekdayinMonth(month: monthInt, year: yearInt)

        let dateFromPicker = DateModel(weekdayInt: weekday, day: 1, month: monthInt, year: yearInt, hour: 0, minute: 0, dayIsSelected: true)
        
        setTitleSelectedDateLabel(selectedDate: dateFromPicker)
        getArrayDates(month: monthInt, year: yearInt)
        setAffairForSelectDate(selectDate: dateFromPicker)
        setCircleForSelectedDay(selectDay: dateFromPicker)
        scrollToTodayCollectionView(day: dateFromPicker)
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return DateHelper.date.monthSourse[row]
        }
        return "\(DateHelper.date.yearSourse[row])"
    }
}
