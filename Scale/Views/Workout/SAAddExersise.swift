//
//  SAAddExersise.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage

protocol ExcersiseProtocol {
    func Excersise(videoArr:NSArray , plan_id:String , day_id:String , editMode:Bool)
}
class SAAddExersise: UIViewController,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate 
{
    
    @IBOutlet weak var lblSelectMuscle: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var txtNubmer: UITextField!
    @IBOutlet weak var txtFrequanty: UITextField!
    
    var delegate : ExcersiseProtocol!
    var dayName = ""
    var dayid = 0
    var dayNote = ""
    var PlanName = ""
    var EditMode = false
    
    var planID = 0
    var planday_id = 0
    var vedio_id = 0
    var number = 0
    var frequent = 0
    var planVideo_id = 0
    var url = ""
    var VideoThumb = ""
    var isEdit = false
    var VideoName = ""
    var content: AnyObject? = nil
    var isSelectedVideo = false
    var index = 0
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if(self.isSelectedVideo)
        {
            self.vedio_id = self.content?.value(forKey: "id") as! Int
            let muscale_id = self.content?.value(forKey: "muscale_id") as! String
            let submuscale_id = self.content?.value(forKey: "submuscale_id") as! String
            let submuscale = self.content?.value(forKey: "submuscale") as! NSDictionary
            self.VideoName = submuscale.value(forKey: "title") as! String
            self.VideoThumb = self.content?.value(forKey: "img_vedio") as? String ?? ""
            self.url = self.content?.value(forKey: "video") as! String
            
            
            self.col.isHidden = false
            self.col.delegate = self
            self.col.dataSource = self
            self.col.reloadData()
        }
        
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtNubmer.textAlignment = .right
            self.txtFrequanty.textAlignment = .right
            self.lblSelectMuscle.textAlignment = .right

        }
        else
        {
            self.txtNubmer.textAlignment = .left
            self.txtFrequanty.textAlignment = .left
            
            self.lblSelectMuscle.textAlignment = .left
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.col.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.col.register(UINib(nibName: "ExcersiseCell", bundle: nil), forCellWithReuseIdentifier: "ExcersiseCell")
        
        if(self.vedio_id != 0)
        {
            self.isSelectedVideo = true
            self.col.isHidden = false
            self.txtNubmer.text = String(self.number)
            self.txtFrequanty.text = String(self.frequent)
            self.btn.setTitle("Edit", for: .normal)
        }
        else
        {
//            self.col.isHidden = false
//            self.txtNubmer.text = String(self.number)
//            self.txtFrequanty.text = String(self.frequent)
//            self.btn.setTitle("Edit", for: .normal)
//
            self.col.isHidden = true
        }
        
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExcersiseCell", for: indexPath) as! ExcersiseCell
        if(self.isEdit)
        {
            cell.lbl.text = "VideoName"
            cell.img.sd_setImage(with: URL(string: self.VideoThumb), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        }
        else
        {
//            if(self.vedio_id != 0)
//            {
                cell.lbl.text = self.VideoName
                let img = self.VideoThumb as? String ?? ""
                cell.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
//            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = UIScreen.main.bounds.width - 50
        return CGSize(width: screenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(self.isEdit)
        {
            let VideoLink = NSURL(string:self.url)!
            self.playVideoWithout(url: VideoLink)
        }
        if(self.isSelectedVideo)
        {
            let VideoLink = NSURL(string:self.url)!
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
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if(self.isEdit){
            self.Edit()
        }
        else{
            
            if MyTools.tools.connectedToNetwork()
            {
                //check video count
                
                if(!self.isSelectedVideo)
                {
                    self.showOkAlert(title: "Error".localized, message: "Please select one video at least".localized)
                }
                else if(txtNubmer.text?.count == 0 || txtFrequanty.text?.count == 0)
                {
                    self.showOkAlert(title: "Error".localized, message: "All fields are required".localized)
                }
                else if txtNubmer.text?.count == 0
                {
                    self.showOkAlert(title: "Error".localized, message: "Please enter the Number of training".localized)
                }
                else if txtFrequanty.text?.count == 0
                {
                    self.showOkAlert(title: "Error".localized, message: "Please enter repetitions number".localized)
                }
                else{
                    self.showIndicator()
                    MyApi.api.PostAddPlan(plan_name: self.PlanName, day_name: self.dayName, day_id: self.dayid, note: self.dayNote, vedio_id: self.vedio_id,number: Int( txtNubmer.text!)!, frequent: Int(self.txtFrequanty.text!)!, plan_id: self.planID, planday_id: self.planday_id)
                    { (response, error) in
                        if(response.result.value != nil)
                        {
                            if let JSON = response.result.value as? NSDictionary
                            {
                                let status = JSON["status"] as? Bool
                                if(status == true)
                                {
                                    self.hideIndicator()
                                    
                                    if(self.EditMode)
                                    {
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller.isKind(of: SAAddPlan.self)
                                            {
                                                let xcontroller = controller as! SAAddPlan
                                                
                                                self.navigationController?.popToViewController(xcontroller, animated: true)
                                                
                                            }
                                        }
                                    }
                                    else
                                    {
                                        let content =  JSON["items"] as! NSDictionary
                                        let plan_days = content.value(forKey: "plan_days") as! NSArray
                                        let plan_id = content.value(forKey: "id") as! Int
                                        
                                        self.navigationController?.popViewControllerWithHandler {
                                            self.delegate.Excersise(videoArr: plan_days , plan_id: String(plan_id), day_id: "0",editMode:self.EditMode)
                                        }
                                    }
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
            }
            else
            {
                self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
            }
        }
    }
    
    func Edit()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.postEditPlanVideo(plan_id: self.planID, plan_day_id: self.planday_id, vedio_id: self.vedio_id, number: Int(txtNubmer.text!)!, frequent: Int(txtFrequanty.text!)!, planVideo_id: self.planVideo_id)
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
                                    self.hideIndicator()
                                    
                                    let content =  JSON["items"] as! NSDictionary
                                    let plan_days = content.value(forKey: "plan_days") as! NSArray
                                    let plan_id = content.value(forKey: "id") as! Int
                                    
                                    self.navigationController?.popViewControllerWithHandler {
                                        self.delegate.Excersise(videoArr: plan_days , plan_id: String(plan_id), day_id: "0",editMode:self.EditMode)
                                        
                                    }
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
}
