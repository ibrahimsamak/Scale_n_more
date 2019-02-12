//
//  SATrainingVC.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit


class SATrainingVC: UIViewController, UITableViewDelegate , UITableViewDataSource  , UITextFieldDelegate{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var SearchView: UIView!
    
    @IBOutlet weak var ConentSearch: UIView!
    @IBOutlet weak var tbl: UITableView!
    var SubmuscleId = 0
    var isFromLibrary = false
    var TItems:NSArray = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(isFromLibrary)
        {
            txtSearch.delegate = self
            txtSearch.returnKeyType = .search
            
            SearchView.layer.borderWidth = 1
            SearchView.layer.borderColor = "979797".color.cgColor
        }
        else
        {
            ConentSearch.isHidden = true
        }
       
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtSearch.textAlignment = .right
        }
        else
        {
            self.txtSearch.textAlignment = .left
        }
        
        
        self.tbl.register(UINib(nibName: "ExcersiseCell2", bundle: nil), forCellReuseIdentifier: "ExcersiseCell2")
        self.loadDate()
        self.tbl.tableFooterView = UIView()
        
        
     
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.TItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcersiseCell2", for: indexPath) as! ExcersiseCell2
        
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let submuscale = content.value(forKey: "submuscale") as! NSDictionary
        let title = content.value(forKey: "name") as! String
        let img = content.value(forKey: "img_vedio") as? String ?? ""
        
        cell.playBtn.tag = indexPath.row
        cell.playBtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
        cell.lbl.text = title
        cell.img.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        if(self.isFromLibrary == false)
        {
            cell.btn.tag = indexPath.row
            cell.btn.isHidden = false
            cell.btn.addTarget(self, action: #selector(self.SelectVideo(_:)), for: .touchUpInside)
        }
        else{
            cell.btn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(self.isFromLibrary == true)
        {
            let content = self.TItems.object(at: indexPath.row) as AnyObject
            let video = content.value(forKey: "video") as! String
            
            let VideoLink = NSURL(string:video)!
            let player = AVPlayer(url: VideoLink as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true)
            {() -> Void in
                playerViewController.player!.play()
            }
        }
    }
    
    @objc func playVideo(_ sender: UIButton)
    {
        let index = sender.tag
        let content = self.TItems.object(at: index) as AnyObject
        let video = content.value(forKey: "video") as! String
        
        let VideoLink = NSURL(string:video)!
        let player = AVPlayer(url: VideoLink as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {() -> Void in
            playerViewController.player!.play()
        }
    }
    
    @objc func SelectVideo(_ sender: UIButton)
    {
        if(self.isFromLibrary == false)
        {
            let index = sender.tag
            let content = self.TItems.object(at: index) as AnyObject
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: SAAddExersise.self)
                {
                    let xcontroller = controller as! SAAddExersise
                    xcontroller.isSelectedVideo = true
                    xcontroller.content = content
                    self.navigationController?.popToViewController(xcontroller, animated: true)
                  
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetVideos(submuscale_id: self.SubmuscleId, name: "")
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            
                            let items = JSON["items"] as! NSArray
                          
                            if(items.count > 0){
                                let title = items[0] as! NSDictionary
                                self.lblTitle.text = title.value(forKey: "submuscal_name") as? String ?? ""
                            }
                            
                            self.TItems = items
                            
                            self.tbl.delegate = self
                            self.tbl.dataSource = self
                            self.tbl.reloadData()
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
    
    
    func Search()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetVideos(submuscale_id: self.SubmuscleId, name: self.txtSearch.text!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            
                            let items = JSON["items"] as! NSArray
                            
                            if(items.count > 0){
                                let title = items[0] as! NSDictionary
                                self.lblTitle.text = title.value(forKey: "submuscal_name") as? String ?? ""
                            }
                            
                            self.TItems = items
                            
                            self.tbl.delegate = self
                            self.tbl.dataSource = self
                            self.tbl.reloadData()
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if((textField.text?.count)! > 0)
        {
            self.Search()
        }
        else
        {
            self.loadDate()
        }
        
        self.txtSearch.resignFirstResponder()
        return true
    }
    
    
}
