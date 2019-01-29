//
//  SAPackages.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView
import DLRadioButton
import SafariServices
import MessageUI

class SAPackages: UIViewController,CodeProtocol , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate ,MFMailComposeViewControllerDelegate  {
    func SendCode(Code: String) {
        self.code = Code
    }
    
    @IBOutlet weak var LayoutConstraintStackHeight: NSLayoutConstraint!
    @IBOutlet weak var cash: DLRadioButton!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    var code = ""
    let emailcontact = MyTools.tools.getConfigString("info_email")

    var paymentType = "Cash"
    var selectedPackage = 0
    var TItems :NSArray = []
    var selectedCategory : NSMutableArray = []
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.col.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.col.register(UINib(nibName: "PackageCell", bundle: nil), forCellWithReuseIdentifier: "PackageCell")
        
        self.cash.isSelected = true
        self.loadDate()
    }
    @objc func sendEmail()
    {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.emailcontact])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        }
        else {
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        }
        else
        {
            print(String(format: "%@ is selecteddd.\n", radioButton.selected()!.titleLabel!.text!));
            self.paymentType = radioButton.selected()!.titleLabel!.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.TItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCell", for: indexPath) as! PackageCell
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        let price = content.value(forKey: "price") as! String

        cell.lblPrice.text = price+" K.D"
        cell.lblPackage.text = name
        
        
        if (self.selectedCategory.contains(id))
        {
            cell.view.layer.cornerRadius = 10.0
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = "6C9C35".color.cgColor
            cell.view.backgroundColor = "6C9C35".color
            
        }
        else
        {
            cell.view.layer.cornerRadius = 10.0
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = "6C9C35".color.cgColor
            cell.view.backgroundColor = UIColor.clear
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 145, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! PackageCell

        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let id = content.value(forKey: "id") as! Int
//        let price = content.value(forKey: "price") as! String

        self.selectedCategory.removeAllObjects()
        if cell.isSelected
        {
            cell.isSelected = false
            if (!selectedCategory.contains(id))
            {
                self.selectedCategory.add(id)
                cell.view.layer.cornerRadius = 10.0
                cell.view.layer.masksToBounds = true
                cell.view.layer.borderWidth = 1
                cell.view.layer.borderColor = "6C9C35".color.cgColor
                cell.view.backgroundColor = UIColor.clear
          
            }
            else
            {
                self.selectedCategory.remove(id)
                self.selectedCategory.add(id)
                
                cell.view.layer.cornerRadius = 10.0
                cell.view.layer.masksToBounds = true
                cell.view.layer.borderWidth = 1
                cell.view.layer.borderColor = "6C9C35".color.cgColor
                cell.view.backgroundColor = "6C9C35".color
                
                
            }
        }
        self.col.reloadData()
        self.selectedPackage = id
    }
    
    
    @IBAction func btnCall(_ sender: UIButton)
    {
        self.sendEmail()

        
//        let number = MyTools.tools.getConfigString("mobile")
//        if let url = URL(string: "tel://\([number)")
//        {
//            UIApplication.shared.openURL(url)
//        }
    }
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetPackages(ID:1){(response, err) in
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
                            
                            self.col.delegate = self
                            self.col.dataSource = self
                            self.col.reloadData()
                            
                            self.col.collectionViewLayout.invalidateLayout()
                            self.LayoutConstraintStackHeight.constant = self.col.collectionViewLayout.collectionViewContentSize.height
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
    
    @IBAction func btnPay(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if self.selectedPackage == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please select one of packages".localized)
            }
            else
            {
                if(self.paymentType == "Cash"){
                    self.type = 0
                }
                else{
                    self.type = 1
                }
                self.showIndicator()
                MyApi.api.postPurshase(package_id: self.selectedPackage, coupon_code: self.code , payment:self.type)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                if(self.type == 0)
                                {
                                    self.hideIndicator()
                  //  self.showOkAlert(title: "Success".localized, message: JSON["message"] as? String ?? "")
                               
                  //  self.navigationController?.pop(animated: true)
            let vc: VCformassege = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)

                                }
                                else{
                                    //online link
                                    self.hideIndicator()
                                    let items = JSON["items"] as! NSDictionary

                                        let link = items["link"] as? String ?? ""
                                        guard let url = URL(string: link) else {
                                            return
                                        }
                                        if #available(iOS 10.0, *) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        } else {
                                            UIApplication.shared.openURL(url)
                                        }
                                  
                                }
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
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
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
    @IBAction func btnHomev(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }

    
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }
    
    
}
