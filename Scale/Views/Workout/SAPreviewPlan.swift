//
//  SAPreviewPlan.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/28/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class SAPreviewPlan: UIViewController,UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var tbl: UITableView!
    var plainId = 0
    var videos:NSArray = []
    var TItems : NSArray = []
    var daysArr :NSArray = []
    var isSelect = false
    var Days:[Int:String] = [1:"Saturday" ,2:"Sunday" ,3:"Monday" ,4:"Tuesday" ,5:"Wednesday" ,6:"Thursday" ,7:"Friday"]
    
    
    var selecteddDays:NSMutableDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbl.register(UINib(nibName: "PreviewDayCell", bundle: nil), forCellReuseIdentifier: "PreviewDayCell")
        
        self.tbl.register(UINib(nibName: "MuscleCell", bundle: nil), forCellReuseIdentifier: "MuscleCell")
        
        
        self.loadData()
        self.tbl.tableFooterView = UIView()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.isSelect)
        {
            return self.videos.count + 3
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewDayCell", for: indexPath) as! PreviewDayCell
            
            if(self.selecteddDays.count>0)
            {
                cell.daysObj = self.selecteddDays as! [Int : String]
                cell.config()
                cell.customVc = self
                cell.videos = self.videos
                cell.obj =  self.daysArr
                cell.tbl = self.tbl
            }
            
            return cell
        }
        else if (indexPath.row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewtxtDaycell", for: indexPath) as! PreviewtxtDaycell
            
            if(self.daysArr.count > 0 && !self.isSelect)
            {
                let content = self.daysArr.object(at: indexPath.row - 1) as AnyObject
                let day_name = content.value(forKey: "day_name") as! String
                cell.txtDay.text = day_name
            }
            
            return cell
        }
        else if (indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewtxtExcersise", for: indexPath) as! PreviewtxtExcersise
            if(self.daysArr.count > 0 && !self.isSelect)
            {
                let content = self.daysArr.object(at: indexPath.row - 2) as AnyObject
                let note = content.value(forKey: "note") as! String
                cell.txtMsg.text = note
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleCell", for: indexPath) as! MuscleCell
            
            
            if(self.isSelect){
                let content = self.videos.object(at: indexPath.row - 3) as AnyObject
                
                let fereq = content.value(forKey: "frequent") as! String
                let number = content.value(forKey: "number") as! String
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
            }
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
    
    
    func loadData(){
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetPlanDays(plan_id: self.plainId)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.daysArr = JSON["items"] as! NSArray
                            
                            for index in 0..<self.daysArr.count
                            {
                                let content = self.daysArr.object(at: index) as AnyObject
                                let videos = content.value(forKey: "plan_vedios") as! NSArray
                                let Selectedday_id = content.value(forKey: "day_id") as! String
                                
                                self.videos = videos
                                
                                self.Days.contains { (key, value) -> Bool in
                                    if(key == Int(Selectedday_id)!)
                                    {
                                        self.selecteddDays.addEntries(from: [key : value])
                                        return true
                                    }
                                    else{
                                        return false
                                        
                                    }
                                }
                                
                            }
                            
                            self.tbl.delegate = self
                            self.tbl.dataSource = self
                            self.tbl.reloadData()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
}
