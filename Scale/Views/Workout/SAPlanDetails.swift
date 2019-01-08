//
//  SAPlanDetails.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import ActionCell
import SDWebImage
import AVFoundation
import AVKit

class SAPlanDetails: UIViewController, UITableViewDelegate , UITableViewDataSource , ActionCellDelegate , ExcersiseProtocol {
    func Excersise(videoArr: NSArray, plan_id: String, day_id: String ,editMode:Bool)
    {
        if(self.isEdit == false)
        {
            let cont = videoArr.object(at: videoArr.count-1) as! AnyObject
            let plan_vedios = cont.value(forKey: "plan_vedios") as! NSArray
            let plan_dayId = cont.value(forKey: "id") as! Int
            let day_id = cont.value(forKey: "day_id") as! String
            self.videos = plan_vedios.mutableCopy() as! NSMutableArray
            self.plan_day_id = plan_dayId
            self.daysarr.removeAll()
            self.daysarr.append(Int(day_id)!)
            self.obj = videoArr
            self.PlanID = Int(plan_id)!
            self.addineditmode = editMode
            self.tableView.reloadData()
            
        }
        else
        {
            self.daysarr.removeAll()
            for index in 0..<videoArr.count
            {
                let cont = videoArr.object(at: index) as! AnyObject
                let plan_vedios = cont.value(forKey: "plan_vedios") as! NSArray
                let plan_dayId = cont.value(forKey: "id") as! Int
                let day_id = cont.value(forKey: "day_id") as! String
                self.videos = plan_vedios.mutableCopy() as! NSMutableArray
                self.plan_day_id = plan_dayId
                self.daysarr.removeAll()
                self.daysarr.append(Int(day_id)!)
            }
            self.obj = videoArr
            self.PlanID = Int(plan_id)!
            self.addineditmode = editMode
            self.tableView.reloadData()
        }
    }
    
    
    public func didActionTriggered(cell: UITableViewCell, action: String)
    {
        
        let xCell = cell as! MuscleCell
        let indexpath = self.tableView.indexPath(for: xCell)
        let content = self.videos.object(at: ((indexpath?.row)! - 3)) as AnyObject
        let number = content.value(forKey: "number") as! String
        let frequent = content.value(forKey: "frequent") as! String
        let vedio_id = content.value(forKey: "vedio_id") as! String
        let id = content.value(forKey: "id") as! Int
        let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary
        let video = vedio_obj.value(forKey: "video") as! String
        let img_vedio = vedio_obj.value(forKey: "img_vedio") as? String ?? ""
        
        if(action == "deleteAction")
        {
            print("delete")
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want to delete video?".localized, okTitle: "Delete".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    self.delete(ID:id,at:((indexpath?.row)!-3))
                }
            }
        }
        else
        {
            print("Edit")
            
            self.Edit(planID: self.PlanID, plan_day_id: self.plan_day_id, vedio_id: Int(vedio_id)!, number: Int(number)!, frequent: Int(frequent)!, planVideo_id: id, videoUrl: video, VideoThumb: img_vedio)
        }
    }
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var planName = ""
    var dayid = 0
    var videos:NSMutableArray = []
    var PlanID = 0
    var plan_day_id = 0
    var planDayName = ""
    var note = ""
    var isEdit = false
    var addineditmode = false
    var obj:NSArray = []
    var daysarr: [Int] = []
    var Days:[Int:String] = [1:"Saturday" ,2:"Sunday" ,3:"Monday" ,4:"Tuesday" ,5:"Wednesday" ,6:"Thursday" ,7:"Friday"]
    var isSelectedDay = false
    var index = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "DayCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        
        self.tableView.register(UINib(nibName: "MuscleCell", bundle: nil), forCellReuseIdentifier: "MuscleCell")
        
        if(isEdit){
            self.btnSave.isHidden = false
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.videos.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
            if(self.isEdit)
            {
                cell.isEdit = true
                cell.daysObj = self.Days
                cell.dayId = dayid
                cell.config()
                cell.customVc = self
                cell.tbl = self.tableView
                cell.obj = self.obj
                cell.videos = self.videos
                cell.daysarr = self.daysarr
                cell.index = self.index
                cell.localplan_day_id = self.plan_day_id
            }
            else
            {
                cell.daysObj = self.Days
                cell.config()
                cell.customVc = self
                cell.obj = self.obj
                cell.tbl = self.tableView
                cell.daysarr = self.daysarr
                cell.localplan_day_id = self.plan_day_id
            }
            return cell
        }
        else if (indexPath.row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "txtDaycell", for: indexPath) as! txtDaycell
            if(self.isEdit && !self.isSelectedDay)
            {
                cell.isEdit = true
                cell.dayname = self.planDayName
                cell.config()
            }
            else
            {
                cell.dayname = ""
                cell.config()
            }
            return cell
        }
        else if (indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "txtExcersise", for: indexPath) as! txtExcersise
            if(self.isEdit && !self.isSelectedDay)
            {
                cell.isEdit = true
                cell.note = self.note
                cell.config()
            }
            else if (self.addineditmode)
            {
                cell.config()
            }
            else
            {
                cell.note = ""
                cell.config()
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleCell", for: indexPath) as! MuscleCell
            let content = self.videos.object(at: indexPath.row - 3) as AnyObject
            let fereq = content.value(forKey: "frequent") as! String
            let number = content.value(forKey: "number") as! String
            let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary
            let img = vedio_obj.value(forKey: "img_vedio") as? String ?? ""
            
            let name = vedio_obj.value(forKey: "muscal_name") as! String
            let subName = vedio_obj.value(forKey: "submuscal_name") as! String
            let url = vedio_obj.value(forKey: "video") as! String
            
            cell.lblFreq.text = fereq
            cell.lblNumber.text = number
            cell.lblmuscle.text = name
            cell.lblSubmuscle.text = subName
            cell.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
           
            let wrapper = ActionCell()
            wrapper.delegate = self
            wrapper.animationStyle = .concurrent
            wrapper.wrap(cell: cell,
                         actionsLeft: [],
                         actionsRight:[
                            {
                                let action = IconAction.init(action: "deleteAction", height: CGFloat(80.0), width: CGFloat(80.0), iconSize: CGSize.init(width: 80.0, height: 157.0))
                                action.icon.image  = #imageLiteral(resourceName: "DeleteCell")
                                action.icon.contentMode = .scaleAspectFit
                                action.icon.tintColor = UIColor.white
                                action.backgroundColor = UIColor.clear
                                return action
                            }(),
                            {
                                let action = IconAction.init(action: "editAction", height: CGFloat(80.0), width: CGFloat(80.0), iconSize: CGSize.init(width: 80.0, height: 157.0))
                                action.icon.image = #imageLiteral(resourceName: "EditCell")
                                action.icon.contentMode = .scaleAspectFit
                                action.icon.tintColor = UIColor.white
                                action.backgroundColor = UIColor.clear
                                return action
                            }(),
                            ])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 2)
        {
            let content = self.videos.object(at: indexPath.row - 3) as AnyObject
            let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary

            let url = vedio_obj.value(forKey: "video") as! String
            let VideoLink = NSURL(string:url)!
            self.playVideoWithout(url: VideoLink)
        }
    }
    
    
    func playVideoWithout(url: NSURL)
    {
        let player = AVPlayer(url: url as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {() -> Void in
            playerViewController.player!.play()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            return 100.0
        }
        else if(indexPath.row == 1)
        {
            return 60.0
        }
        else if(indexPath.row == 2)
        {
            return 115.0
        }
        else
        {
            return 157.0
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnAddDay(_ sender: UIButton)
    {
        let vc : SAAddExersise = AppDelegate.storyboard.instanceVC()
        vc.dayid = UserDefaults.standard.value(forKey: "LastDayChoose") as! Int
        vc.dayName = UserDefaults.standard.value(forKey: "DayName") as! String
        vc.dayNote = UserDefaults.standard.value(forKey: "DayNote") as! String
        vc.PlanName = self.planName
        vc.planID = self.PlanID
        vc.planday_id = self.plan_day_id
        vc.index = self.index
        vc.delegate = self
     
        if(self.isEdit && self.isSelectedDay)
        {
            vc.EditMode = true
        }
        else
        {
             vc.EditMode  = false
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func EditDay(){
        if MyTools.tools.connectedToNetwork()
        {
            let DayName = UserDefaults.standard.value(forKey: "DayName") as! String
            let DayNote = UserDefaults.standard.value(forKey: "DayNote") as! String
            let DayID = UserDefaults.standard.value(forKey: "LastDayChoose") as! Int
            
            self.showIndicator()
            MyApi.api.postEditPlanDay(plan_id: self.PlanID, day_name: DayName, day_id: DayID, note: DayNote, planDay_id: self.plan_day_id)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (suc) in
                                if(suc)
                                {
                                    // self.loadDate()
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
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
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
    func delete(ID:Int,at:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.DeletePlanVideo(ID: ID)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (suc) in
                                if(suc)
                                {
                                    self.videos.removeObject(at:at)
                                    self.tableView.reloadData()
                                    //self.loadData()
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
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
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    func Edit(planID:Int ,plan_day_id:Int,vedio_id:Int,number:Int , frequent:Int, planVideo_id:Int , videoUrl:String , VideoThumb:String)
    {
        
        
        let vc :SAAddExersise = AppDelegate.storyboard.instanceVC()
        vc.planID = planID
        vc.planday_id = plan_day_id
        vc.vedio_id = vedio_id
        vc.number = number
        vc.frequent = frequent
        vc.url = videoUrl
        vc.VideoThumb = VideoThumb
        vc.isEdit = true
        vc.EditMode = true
        vc.planVideo_id = planVideo_id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
         self.EditDay()
    }
}
