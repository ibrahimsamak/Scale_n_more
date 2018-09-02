//
//  SAPlanDetailsNew.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/30/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import ActionCell
import SDWebImage
import AVFoundation
import AVKit

enum SAPlanDetailsType {
    case add
    case edit
}
class SAPlanDetailsNew: UIViewController ,UIScrollViewDelegate,ActionCellDelegate , ExcersiseProtocol
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnSaave: UIButton!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
    
    var PlanID = 0
    var planName = ""
    var selectededDayIndex = 0{
        didSet{
            self.col.reloadData()
            self.setCurrentDayObjectFromArray()
            if self.selectededDayIndex != Int(self.currentDayObject?.value(forKey: "day_id") as? String ?? "0") {
                self.resetUI()
            }
        }
    }
    var planDetailsType : SAPlanDetailsType = .add
    var Days:[Int:String] = [1:"Saturday" ,2:"Sunday" ,3:"Monday" ,4:"Tuesday" ,5:"Wednesday" ,6:"Thursday" ,7:"Friday"]
    var currentDayObject : AnyObject? = nil {
        didSet{
            self.fullViewData()
        }
    }
    var currentDayObjectTemp : AnyObject? = nil  
    var FilteredVideo:NSArray = [] {
        didSet{
            self.tableView.reloadData()
            self.updateTableViewHeight()
        }
    }
    var plan_days: NSArray = []{
        didSet{
            self.setCurrentDayObjectFromArray()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    func setupView()
    {
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "DayCollection", bundle: nil), forCellWithReuseIdentifier: "DayCollection")
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
        
        self.tableView.register(UINib(nibName: "MuscleCell", bundle: nil), forCellReuseIdentifier: "MuscleCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        if currentDayObjectTemp != nil {
            self.btnSaave.isHidden = false
            self.plan_days = [currentDayObjectTemp]
            self.selectededDayIndex = Int(currentDayObjectTemp?.value(forKey: "day_id") as! String)!
        }
        
    }
    func updateTableViewHeight(){
        self.tbl_height.constant =  CGFloat(self.FilteredVideo.count * 157)
    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.updateTableViewHeight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        //go to muscle
        if(txtName.text?.count == 0)
        {
            self.showOkAlert(title: "Error".localized, message: "Please enter day name".localized)
        }
        else  if(txtNote.text?.count == 0)
        {
            self.showOkAlert(title: "Error".localized, message: "Please enter note".localized)
        }
        else
        {
            let vc : SAAddExersise = AppDelegate.storyboard.instanceVC()
            vc.dayid = self.selectededDayIndex
            vc.dayName = txtName.text!
            vc.dayNote = txtNote.text
            vc.PlanName = self.planName
            vc.planID = self.PlanID
            if self.selectededDayIndex != Int(self.currentDayObject?.value(forKey: "day_id") as? String ?? "0")
            {
                vc.planday_id = 0
            }else{
                vc.planday_id = (self.currentDayObject?.value(forKey: "id") as? NSNumber ?? NSNumber(value:0)).intValue
            }
            //        vc.index = self.index
            vc.delegate = self
            vc.EditMode  = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
        //save
        if MyTools.tools.connectedToNetwork()
        {
            let DayName = txtName.text
            let DayNote = txtNote.text
            let DayID = self.selectededDayIndex
            let plan_day_id = (self.currentDayObject?.value(forKey: "id") as? NSNumber ?? NSNumber(value:0)).intValue
            
            self.showIndicator()
            MyApi.api.postEditPlanDay(plan_id: self.PlanID, day_name: DayName!, day_id: DayID, note: DayNote!, planDay_id: plan_day_id)
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
                                    self.navigationController?.pop(animated: true)
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
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
        
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    func resetUI(){
        self.txtName.text = ""
        self.txtNote.text = ""
        self.FilteredVideo = []
    }
    func setCurrentDayObjectFromArray(){
        for day in self.plan_days {
            let object = day as AnyObject
            let day_id = object.value(forKey: "day_id") as! String
            if day_id == String(self.selectededDayIndex) {
                self.currentDayObject = object
                break
            }
        }
    }
}
//Fill Data
extension SAPlanDetailsNew {
    func fullViewData()
    {
        self.col.reloadData()
        self.txtName.text = self.currentDayObject?.value(forKey: "day_name") as? String
        self.txtNote.text = self.currentDayObject?.value(forKey: "note") as! String
        self.FilteredVideo = self.currentDayObject?.value(forKey: "plan_vedios") as! NSArray
    }
}

//Days
extension SAPlanDetailsNew : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.Days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollection", for: indexPath) as! DayCollection
        
        let id = indexPath.row + 1
        let title = self.Days[indexPath.row + 1]
        cell.lbl.text = title
        
        if (self.selectededDayIndex == id)
        {
            cell.view.layer.cornerRadius = 22.5
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.white.cgColor
        }
        else
        {
            cell.view.layer.cornerRadius = 22.5
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = "9AC25B".color.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 120, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = indexPath.row + 1
        self.selectededDayIndex = id
    }
}

//Video
extension SAPlanDetailsNew : UITableViewDelegate,UITableViewDataSource {
    func Excersise(videoArr: NSArray, plan_id: String, day_id: String, editMode: Bool)
    {
        self.plan_days = videoArr
        self.PlanID = Int(plan_id)!
    }
    
    
    public func didActionTriggered(cell: UITableViewCell, action: String)
    {
        let xCell = cell as! MuscleCell
        let indexpath = self.tableView.indexPath(for: xCell)
        let content = self.FilteredVideo.object(at: ((indexpath?.row)!)) as AnyObject
        let number = content.value(forKey: "number") as! String
        let frequent = content.value(forKey: "frequent") as! String
        let vedio_id = content.value(forKey: "vedio_id") as! String
        let id = content.value(forKey: "id") as! Int
        let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary
        let video = vedio_obj.value(forKey: "video") as! String
        let img_vedio = vedio_obj.value(forKey: "img_vedio") as! String
        let videoName = vedio_obj.value(forKey: "submuscal_name") as! String
        let plan_day_id = (self.currentDayObject?.value(forKey: "id") as? NSNumber ?? NSNumber(value:0)).intValue
        
        if(action == "deleteAction")
        {
            print("delete")
            
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want to delete video?".localized, okTitle: "Delete".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    self.delete(ID:id,at:((indexpath?.row)!))
                }
            }
        }
        else
        {
            print("Edit")
            self.Edit(planID: self.PlanID, plan_day_id: plan_day_id, vedio_id: Int(vedio_id)!, number: Int(number)!, frequent: Int(frequent)!, planVideo_id: id, videoUrl: video, VideoThumb: img_vedio , VideoName:videoName)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FilteredVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleCell", for: indexPath) as! MuscleCell
        
        let content = self.FilteredVideo.object(at: indexPath.row) as AnyObject
        let fereq = content.value(forKey: "frequent") as? String
        let number = content.value(forKey: "number") as? String
        let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary
        let img = vedio_obj.value(forKey: "img_vedio") as! String
        let name = vedio_obj.value(forKey: "muscal_name") as! String
        let subName = vedio_obj.value(forKey: "submuscal_name") as! String
        let url = vedio_obj.value(forKey: "video") as! String
        
        cell.lblFreq.text = fereq
        cell.lblNumber.text = number
        cell.lblmuscle.text = name
        cell.lblSubmuscle.text = subName
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 157.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.FilteredVideo.object(at: indexPath.row) as AnyObject
        let vedio_obj = content.value(forKey: "vedio_obj") as! NSDictionary
        let url = vedio_obj.value(forKey: "video") as! String
        let VideoLink = NSURL(string:url)!
        self.playVideoWithout(url: VideoLink)
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
                                    let arrTemp = self.FilteredVideo.mutableCopy() as! NSMutableArray
                                    arrTemp.removeObject(at: at)
                                    self.FilteredVideo = arrTemp
                                    self.tableView.reloadData()
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
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    
    func Edit(planID:Int ,plan_day_id:Int,vedio_id:Int,number:Int , frequent:Int, planVideo_id:Int , videoUrl:String , VideoThumb:String , VideoName:String )
    {
        let vc :SAAddExersise = AppDelegate.storyboard.instanceVC()
        vc.planID = planID
        vc.VideoName = VideoName
        vc.planday_id = plan_day_id
        vc.vedio_id = vedio_id
        vc.number = number
        vc.frequent = frequent
        vc.url = videoUrl
        vc.VideoThumb = VideoThumb
        vc.planVideo_id = planVideo_id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
