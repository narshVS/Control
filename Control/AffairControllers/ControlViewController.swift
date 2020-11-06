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
    
    // MARK: - Private properties
    
    private var selectedDate: [DateModel] = []
    private let pickerComponets: Int = 2
    
    private var affairManager: AffairManager = AffairManager()
    private var affairs: [Affair] = []
    private var selectedAffairs: [Affair] = []
    
    private var selectedAffair: Affair?
    
    // MARK: - Properties
    
    var sideMenu: SideMenuNavigationController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSideMenu()
        configureDateHelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureStartupView()
        configureDatePicker()
        scrollToTodayCollectionView()
    }
    
    // MARK: - Public Metod
    
    func saveSelectAffairSegue(affair: Affair) {
        selectedAffair = affair
    }
    
    func configureAfterUnwind() {
        loadDataAffair()
        setAffairForSelectDate(selectDate: DateHelper.date.getTodaysDate())
        tableView.reloadData()
    }
    
    // MARK: - Private metod
    
    private func loadDataAffair() {
        affairManager.fetchAffairs { [weak self] affairs in
            self?.affairs = affairs
        }
    }
    
    private func configureStartupView() {
        loadDataAffair()
        setTitleSelectedDateLabel(selectedDate: DateHelper.date.getTodaysDate())
        getArrayDates(month: DateHelper.date.getTodaysDate().month, year: DateHelper.date.getTodaysDate().year)
        setAffairForSelectDate(selectDate: DateHelper.date.getTodaysDate())
        setSelectedDayInCollectionView(selectDay: DateHelper.date.getTodaysDate())
        configureEmptyState()
    }
    
    private func setTitleSelectedDateLabel(selectedDate: DateModel) {
        titleSelectedDateLabel.text = "\(ChangeTypeHelper.changeType.weekdayIntToStringLong(weekday: selectedDate.weekdayInt)), \(ChangeTypeHelper.changeType.monthIntToStringLong(month: selectedDate.month)) \(selectedDate.day), \(selectedDate.year)"
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
            selectedDate.append(DateModel(weekdayInt: weekday, day: day, month: month, year: year, dayIsSelected: false))
            if weekday >= 7 {
                weekday = 1
            } else {
                weekday += 1
            }
        }
    }
    
    private func setAffairForSelectDate(selectDate: DateModel) {
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
    
    private func configureEmptyState() {
        if selectedAffairs.isEmpty {
            noAffairsLabel.isHidden = false
            noAffairsLabel.text = "На сегодня дел нет"
        } else {
            noAffairsLabel.isHidden = true
        }
    }
    
    private func configureDateHelper() {
        DateHelper.date.configue()
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
       
    // MARK: - Collection View Metod
    
    private func setSelectedDayInCollectionView(selectDay: DateModel) {
        resetSelectCellCollectionView()
        
        selectedDate[selectDay.day - 1] = .init(
            weekdayInt: selectedDate[selectDay.day - 1].weekdayInt,
            day: selectedDate[selectDay.day - 1].day,
            month: selectedDate[selectDay.day - 1].month,
            year: selectedDate[selectDay.day - 1].year,
            dayIsSelected: true)
    }
    
    private func resetSelectCellCollectionView() {
        for date in selectedDate {
            if date.dayIsSelected == true {
                selectedDate[date.day - 1] = .init(weekdayInt: selectedDate[date.day - 1].weekdayInt, day: selectedDate[date.day - 1].day, month: selectedDate[date.day - 1].month, year: selectedDate[date.day - 1].year, dayIsSelected: false)
            }
        }
    }
    
    private func scrollToTodayCollectionView() {
        let todayDate = DateHelper.date.getTodaysDate()
        let indexPath = IndexPath(item: todayDate.day - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    // MARK: - Picker Metod
    
    private func configureDatePicker() {
        datePicker.delegate = self
        datePicker.dataSource = self
        setDafaultRowForPicker()
    }

    private func setDafaultRowForPicker() {
        let todayDate = DateHelper.date.getTodaysDate()
        datePicker.selectRow(todayDate.month - 1, inComponent: 0, animated: true)
        datePicker.selectRow(1, inComponent: 1, animated: true)
    }
    
    // MARK: - Action
    
    @IBAction func setDateTapped(_ sender: Any) {
        datePicker.isHidden ? (datePicker.isHidden = false) : (datePicker.isHidden = true)
    }
    
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    @IBAction func unwindControlViewController(_ sender: UIStoryboardSegue) {  }
    
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
        selectedAffairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffairCell.reusableId, for: indexPath) as! AffairCell
        cell.configure(with: selectedAffairs[indexPath.row])
        cell.delegate = self
        return cell
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
            return DateHelper.date.monthSourse.count
        }
        return DateHelper.date.yearSourse.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = DateHelper.date.monthSourse[pickerView.selectedRow(inComponent: 0)]
        let year = DateHelper.date.yearSourse[pickerView.selectedRow(inComponent: 1)]
        
        let dateFromPicker = DateModel(weekdayInt: DateHelper.date.firstWeekdayinMonth(month: ChangeTypeHelper.changeType.monthStringToInd(month: month),
                                              year: year),
                                              day: 1,
                                              month: ChangeTypeHelper.changeType.monthStringToInd(month: month),
                                              year: year,
                                              dayIsSelected: true)
        
        setTitleSelectedDateLabel(selectedDate: dateFromPicker)
        getArrayDates(month: ChangeTypeHelper.changeType.monthStringToInd(month: month), year: year)
        setAffairForSelectDate(selectDate: dateFromPicker)
        setSelectedDayInCollectionView(selectDay: dateFromPicker)
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
