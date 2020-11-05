//
//  ControlViewController.swift
//  ControlApp
//
//  Created by Влад Овсюк on 25.10.2020.
//

import UIKit
import SideMenu

final class ControlViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet weak var titleSelectedDateLabel: UILabel!
    @IBOutlet weak var noAffairsLabel: UILabel!
    
    // MARK: - Helpers
    
    private let changeType = ChangeTypeHelper()
    
    // MARK: - Private properties
    
    private let monthSourse: Array<String> = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private var yearSourse: Array<Int> = []
    private let pickerComponets = 2
    
    private var affairManager = AffairManager()
    private var affairs: [Affair] = []
    
    private var affairDateManager = DateAffairManager()
    private var datesAffair: [DateAffair] = []
    
    private var selectedDate: [DateModel] = []
    
    private var selectedAffair: Affair?
    
    private var dateAffair: DateAffair?
    
    // MARK: - Properties
    
    var sideMenu: SideMenuNavigationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataAffairDate()
        configureSideMenu()
        configureStartupView()
        configureDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDafaultRowForPicker()
        scrollToTodayCollectionView()
    }
    
    // MARK: - Metods for Side Menu
    
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
    
    func showAddAffairViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "AddAffairViewController") as! AddTextForAffairViewController
        addChild(addAffairViewController)
        view.addSubview(addAffairViewController.view)
        addAffairViewController.didMove(toParent: self)
    }
    
    func showSettingViewController() {
        let storybord = UIStoryboard(name: "SideMenu", bundle: .main)
        let addAffairViewController = storybord.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
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
    
    // MARK: - Picker metod
    
    private func configureDatePicker() {
        let todayDate = getTodaysDate()
        datePicker.delegate = self
        datePicker.dataSource = self
        setYearSourseForPicker(year: todayDate.year)
    }
    
    private func setYearSourseForPicker(year: Int) {
        yearSourse.append(year - 1)
        yearSourse.append(year)
        yearSourse.append(year + 1)
    }
    
    private func setDafaultRowForPicker() {
        let todayDate = getTodaysDate()
        datePicker.selectRow(todayDate.monthInt - 1, inComponent: 0, animated: true)
        datePicker.selectRow(1, inComponent: 1, animated: true)
    }
    
    // MARK: - Public metod
    
    func saveSelectAffairSegue(affair: Affair) {
        selectedAffair = affair
    }
    
    // MARK: - Private metod
    
    private func loadDataAffair() {
        affairManager.fetchAffairs(from: dateAffair) { [weak self] affairs in
            self?.affairs = affairs
        }
    }
    
    private func loadDataAffairDate() {
        affairDateManager.fetchAffairDate { [weak self] dates in
            self?.datesAffair = dates
        }
    }
    
    private func getTodaysDate() -> DateModel {
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let retunrDate = DateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: true)
        return retunrDate
    }
    
    private func configureStartupView() {
        setTitleSelectedDateLabel(selectedDate: getTodaysDate())
        getArrayDates(month: getTodaysDate().monthInt, year: getTodaysDate().year)
        setAffairForSelectDate(selectDate: getTodaysDate())
        setSelectedDayInCollectionView(selectDay: getTodaysDate())
        configureEmptyState()
    }
    
    private func setTitleSelectedDateLabel(selectedDate: DateModel) {
        titleSelectedDateLabel.text = "\(changeType.weekdayStringLong(weekday: selectedDate.weekdayInt)), \(changeType.monthStringLong(month: selectedDate.monthInt)) \(selectedDate.day), \(selectedDate.year)"
    }
    
    private func getArrayDates(month: Int, year: Int) {
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let dayInMonth = calendar.range(of: .day, in: .month, for: date)!
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        
        var weekday = firstWeekdayinMonth
        
        selectedDate.removeAll()
        for day in dayInMonth {
            selectedDate.append(DateModel(weekdayInt: weekday, day: day, monthInt: month, year: year, dayIsSelected: false))
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    private func setAffairForSelectDate(selectDate: DateModel) {
        for dateFromData in datesAffair {
                if dateFromData.day == selectDate.day && dateFromData.month == selectDate.monthInt && dateFromData.year == selectDate.year {
                    dateAffair = dateFromData
                    loadDataAffair()
                }
        }
    }
    
    private func firstWeekdayinMonth(month: Int, year: Int) -> Int{
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)!
        
        let firstWeekdayinMonth = calendar.component(.weekday, from: date)
        return firstWeekdayinMonth
    }
    
    private func configureEmptyState() {
        if affairs.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = "На сегодня дел нет"
        } else {
            noAffairsLabel.isHidden = true
        }
    }
    
    private func setSelectedDayInCollectionView(selectDay: DateModel) {
        resetSelectCellCollectionView()
        
        selectedDate[selectDay.day - 1] = .init(
            weekdayInt: selectedDate[selectDay.day - 1].weekdayInt,
            day: selectedDate[selectDay.day - 1].day,
            monthInt: selectedDate[selectDay.day - 1].monthInt,
            year: selectedDate[selectDay.day - 1].year,
            dayIsSelected: true)
    }
    
    private func resetSelectCellCollectionView() {
        for date in selectedDate {
            if date.dayIsSelected == true {
                selectedDate[date.day - 1] = .init(weekdayInt: selectedDate[date.day - 1].weekdayInt, day: selectedDate[date.day - 1].day, monthInt: selectedDate[date.day - 1].monthInt, year: selectedDate[date.day - 1].year, dayIsSelected: false)
            }
        }
    }
    
    private func scrollToTodayCollectionView() {
        let todayDate = getTodaysDate()
        let indexPath = IndexPath(item: todayDate.day - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func setDateTapped(_ sender: Any) {
        datePicker.isHidden ? (datePicker.isHidden = false) : (datePicker.isHidden = true)
    }
    
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    // MARK: - Segue Action
    
    @IBSegueAction func settingAffairTapped(_ coder: NSCoder) -> SelectedAffair? {
        let controller = SelectedAffair(coder: coder)
        controller?.affair = selectedAffair
        return controller
    }
}


// MARK: - UITableView

extension ControlViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        affairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairCell.reusableId, for: indexPath) as! AffairCell
        cell.configure(with: affairs[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            affairs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                tableView.reloadData()
            })
        }
        configureEmptyState()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if affairs[indexPath.row].affaitIsDone == false {
//            affairs[indexPath.row] = .init(
//                affairTitle: affairs[indexPath.row].affairTitle,
//                affairDescription: affairs[indexPath.row].affairDescription,
//                affairDate: affairs[indexPath.row].affairDate,
//                affairTime: affairs[indexPath.row].affairTime, affaitIsDone: true)
//        } else {
//            affairs[indexPath.row] = .init(
//                affairTitle: affairs[indexPath.row].affairTitle,
//                affairDescription: affairs[indexPath.row].affairDescription,
//                affairDate: affairs[indexPath.row].affairDate,
//                affairTime: affairs[indexPath.row].affairTime,
//                affaitIsDone: false)
//        }
//        tableView.reloadData()
    }
}

// MARK: - UICollectionView

extension ControlViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffairCollectionViewCell.reusableId, for: indexPath) as! AffairCollectionViewCell
        cell.configure(with: selectedDate[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setTitleSelectedDateLabel(selectedDate: selectedDate[indexPath.row])
        setAffairForSelectDate(selectDate: selectedDate[indexPath.row])
        setSelectedDayInCollectionView(selectDay: selectedDate[indexPath.row])
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UIPickerView

extension ControlViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthSourse.count
        }
        return yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = monthSourse[pickerView.selectedRow(inComponent: 0)]
        let year = yearSourse[pickerView.selectedRow(inComponent: 1)]
        
        let dateFromPicker = DateModel(weekdayInt: firstWeekdayinMonth(month: changeType.monthStringToInd(month: month), year: year),
                                       day: 1,
                                       monthInt: changeType.monthStringToInd(month: month),
                                       year: year,
                                       dayIsSelected: true)
        
        setTitleSelectedDateLabel(selectedDate: dateFromPicker)
        getArrayDates(month: changeType.monthStringToInd(month: month), year: year)
        setAffairForSelectDate(selectDate: dateFromPicker)
        setSelectedDayInCollectionView(selectDay: dateFromPicker)
        configureEmptyState()
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return monthSourse[row]
        }
        return "\(yearSourse[row])"
    }
}
