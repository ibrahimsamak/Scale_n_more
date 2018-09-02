//
//  SAResturantMeeting.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/28/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import Foundation
import FSCalendar
import BIZPopupView

class SAResturantMeeting: UIViewController, FSCalendarDataSource, FSCalendarDelegate,SCPopDatePickerDelegate ,CodeProtocol {
    func SendCode(Code: String) {
        self.code = Code
    }
    
    func scPopDatePickerDidSelectDate(_ date: Date)
    {
        let inputDateAsString = MyTools.tools.ConvertToTime(date: date)
        var formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        if let date = formatter.date(from: inputDateAsString)
        {
            formatter.dateFormat = "hh:mm"
            let outputDate = formatter.string(from: date)
            
            
            print(outputDate)
            self.txtTime.text = outputDate
        }
    }
    
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var calendar: FSCalendar!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    let datePicker = SCPopDatePicker()
    let date = Date()
    var code = ""
    var selectedDay = ""
    var type = 1
    @objc func myTargetFunction(textField: UITextField)
    {
        textField.text = ""
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerType = SCDatePickerType.date
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = "8FB952".color
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        self.datePicker.show(attachToView: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment this to perform an 'initial-week-scope'
        // self.calendar.scope = FSCalendarScopeWeek;
        
        
        //        // For UITest
        //        self.calendar.accessibilityIdentifier = "calendar"
        
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerType = SCDatePickerType.time
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = "8FB952".color
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        
        self.selectedDay = self.formatter.string(from: self.date)
        print(selectedDay)
        if(self.type == 1){
            self.lblFees.text = MyTools.tools.getConfigString("price_trainer")+" K.D".localized
        }
        else{
            self.lblFees.text = MyTools.tools.getConfigString("price_dietitian")+" K.D".localized

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        //        txtTime.addTarget(self, action:  #selector(DIYExampleViewController.myTargetFunction(textField:)), for: UIControlEvents.touchDown)
        
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.reloadData()
        
        calendar.backgroundColor = UIColor.clear
        calendar.calendarHeaderView.backgroundColor = UIColor.clear
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventDefaultColor = UIColor.white
        calendar.appearance.titleDefaultColor = UIColor.white
        calendar.appearance.titleWeekendColor = UIColor.white
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.weekdayTextColor = "9CC45D".color
        
        
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = self.date // Hide the today circle
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        
        //        let dates = [
        //            self.gregorian.date(byAdding: .day, value: -1, to: Date()),
        //            Date(),
        //            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        //        ]
        let dates = [Any]()
        //        dates.forEach { (date) in
        //            self.calendar.select(date, scrollToDate: false)
        //        }
        
        
    }
    
    @IBAction func btnSelectTime(_ sender: UIButton)
    {
        self.datePicker.show(attachToView: self.view)
        
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    @IBAction func btnCall(_ sender: UIButton)
    {
        let number = MyTools.tools.getConfigString("mobile")
        if let url = URL(string: "tel://\([number)")
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func btnPay(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if self.txtTime.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please fill time field".localized)
            }
            else if (self.selectedDay == "")
            {
                self.showOkAlert(title: "Error".localized, message: "Please select meeting date".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.postAppointment(type: self.type, date: self.selectedDay, time: self.txtTime.text!, coupon_code: self.code)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Success".localized, message: JSON["message"] as? String ?? "")
                            }
                            else
                            {
                                self.hideIndicator()
                                self.code = ""
                                self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                            }
                            self.hideIndicator()
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    @IBAction func discountCode(_ sender: UIButton)
    {
        let vc:SADiscount = AppDelegate.storyboard.instanceVC()
        vc.delegate = self
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
    
    // MARK:- FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        //        if self.gregorian.isDateInToday(date) {
        //            return "今"
        //        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    
    // MARK:- FSCalendarDelegate
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        self.selectedDay = self.formatter.string(from: date)
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    // MARK: - Private functions
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
}

