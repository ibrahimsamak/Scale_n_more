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


class SATrainingVC: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tbl: UITableView!
    var SubmuscleId = 0
    var isFromLibrary = false
    var TItems:NSArray = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        let title = submuscale.value(forKey: "title") as! String
        let img = content.value(forKey: "img_vedio") as! String
        
        cell.playBtn.tag = indexPath.row
        cell.playBtn.addTarget(self, action: #selector(self.playVideo(_:)), for: .touchUpInside)
        cell.lbl.text = title
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
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
            MyApi.api.GetVideos(submuscale_id: self.SubmuscleId)
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
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
}
