import UIKit
import Foundation
import FSCalendar
import BIZPopupView

class SAMealCalender: UIViewController, FSCalendarDataSource, FSCalendarDelegate ,loadDataprotocal {
    
    @IBOutlet weak var txtTo: UILabel!
    @IBOutlet weak var txtFrom: UILabel!
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
    var TItems:NSArray = []
    var dates : NSArray = []
    var selectedDate : [Date] = []
    var selectedDateNew : [String:UIColor] = [:]
    var selectedDateNewS : [String:String] = [:]
   var palnId = 0
    var selectedDateString : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
    
        
        //        txtTime.addTarget(self, action:  #selector(DIYExampleViewController.myTargetFunction(textField:)), for: UIControlEvents.touchDown)
        
//        let dateString = "2018-08-31"
//        let dateStringConverter = MyTools.tools.convertDateFormater(date: dateString)
//        let dateFormatter = DateFormatter()
//        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        dateFormatter.locale = Locale(identifier: "en-us")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: dateStringConverter)
       
        //self.selectedDate.append(date ?? Date())
        
        self.loadDate()

        if(Language.currentLanguage().contains("ar"))
        {
            self.txtTo.textAlignment = .right
            self.txtFrom.textAlignment = .right
            self.calendar.locale = Locale(identifier: "ar")
            self.calendar.calendarHeaderView.calendar.locale = Locale(identifier: "ar")
        }
        else
        {
            self.txtTo.textAlignment = .left
            self.txtFrom.textAlignment = .left
            self.calendar.locale = Locale(identifier: "en_EN")
            self.calendar.calendarHeaderView.calendar.locale =  Locale(identifier: "en_EN")
        }
    }
    
    
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
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

        //self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let index = self.selectedDateString.index(of: self.formatter.string(from: date))
        if(index != nil)
        {
            let dayObj = self.dates.object(at: index!) as AnyObject
          //  let id = dayObj.value(forKey: "id") as! Int
            let date = dayObj.value(forKey: "date") as! String
            let pause = dayObj.value(forKey: "pause") as! String

            let vc:SAPopUp = AppDelegate.storyboard.instanceVC()
            vc.date = date
            
            vc.day = "Day # ".localized+String(index!+1)
            vc.id = palnId
            vc.pause = pause
            vc.delegate = self

            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
            popupViewController?.showDismissButton = true
            popupViewController?.enableBackgroundFade = true
            self.present(popupViewController!, animated: true, completion: nil)

        }
        DispatchQueue.main.async {
        self.calendar(calendar, didSelect: date, at: monthPosition)
        }
  //  self.calendar.reloadData()
         //self.configureVisibleCells()
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
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                selectionType = .single
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            
          
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            dateFormatter.locale = Locale(identifier: "en-us")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let stringDate = dateFormatter.string(from: date)
            if self.selectedDateNewS[stringDate] == "0" {
                diyCell.selectionLayer.fillColor = "9CC45D".color.cgColor

            }else{
                diyCell.selectionLayer.fillColor = "C0C0C0".color.cgColor

            }
            diyCell.selectionType = .single
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.getPlanMeals(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.TItems = JSON["items"] as! NSArray
                            let content = self.TItems.object(at: self.TItems.count-1) as AnyObject
                            
                            self.dates = content.value(forKey: "days") as! NSArray
                          
                            let plan_id = content.value(forKey: "id") as! Int
                            self.txtFrom.text = content.value(forKey: "start_date") as! String

                        
                            self.palnId = plan_id
                            
                            
                            let packageUnfo = content.value(forKey: "package") as! NSDictionary
                           // self.txtFrom.text = packageUnfo.value(forKey: "date") as! String
                            self.txtTo.text = (packageUnfo.value(forKey: "Duration") as! String)+" Days".localized

                            for index in 0..<self.dates.count
                            {
                                let content = self.dates.object(at: index) as AnyObject
                                let dateString = content.value(forKey: "date") as! String
                                 let pauseString = content.value(forKey: "pause") as! String
                                
                                
                                let dateStringConverter = MyTools.tools.convertDateFormater(date: dateString)
                                let dateFormatter = DateFormatter()
                                dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                                dateFormatter.locale = Locale(identifier: "en-us")
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let date = dateFormatter.date(from: dateStringConverter)
                            
                                self.selectedDate.append(date ?? Date())
                                self.selectedDateString.append(dateString)
                            
                                self.selectedDateNewS[dateString] = pauseString
                                

                            }
                            
                            
                            self.calendar.isHidden = false
                            self.calendar.dataSource = self
                            self.calendar.delegate = self
                            self.calendar.allowsMultipleSelection = true
                            
                            self.calendar.backgroundColor = UIColor.clear
                            self.calendar.calendarHeaderView.backgroundColor = UIColor.clear
                            
                            
                            self.calendar.calendarWeekdayView.backgroundColor = UIColor.clear
                            self.calendar.appearance.eventSelectionColor = UIColor.white
                            self.calendar.appearance.eventDefaultColor = UIColor.white
                            self.calendar.appearance.titleDefaultColor = UIColor.white
                            self.calendar.appearance.titleWeekendColor = UIColor.white
                            self.calendar.appearance.headerTitleColor = UIColor.white
                            self.calendar.appearance.weekdayTextColor = "9CC45D".color
                           
                            self.calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
                            self.calendar.swipeToChooseGesture.isEnabled = true
                            self.calendar.today = nil

                            self.selectedDate.forEach { (date) in
                                self.calendar.select(date, scrollToDate: true)
                            }
                            
                           
                           
                           
                            print(self.selectedDate)
                            self.calendar.reloadData()
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                    
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
   
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.formatter.string(from: date)
        if let color = self.selectedDateNew[key] {
            return color
        }
        return appearance.selectionColor
    }
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }
    
}

