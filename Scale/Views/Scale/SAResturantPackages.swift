//
//  SAResturantPackages.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView
import DLRadioButton

class SAResturantPackages: UIViewController,CodeProtocol , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate {
    func SendCode(Code: String) {
        self.code = Code
    }
    
    @IBOutlet weak var LayoutConstraintStackHeight: NSLayoutConstraint!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtFood: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtHealthCondition: UITextView!
   
    var code = ""
    var paymentType = "Cash"
    var selectedPackage = 0
    var TItems :NSArray = []
    var selectedCategory : NSMutableArray = []
    var type = 0
    var selectedPackageId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.col.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.col.register(UINib(nibName: "RPackageCell", bundle: nil), forCellWithReuseIdentifier: "RPackageCell")
        
        self.txtHealthCondition.placeholder = "Health Conditions ".localized
        self.txtHealthCondition.placeholderColor = "FFFFFF".color
        
        self.txtNote.placeholder = "Notes ".localized
        self.txtNote.placeholderColor = "FFFFFF".color
        
        self.loadDate()
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtNote.textAlignment = .right
            self.txtFood.textAlignment = .right
            self.txtHeight.textAlignment = .right
            self.txtWeight.textAlignment = .right
            self.txtHealthCondition.textAlignment = .right
        }
        else
        {
            self.txtNote.textAlignment = .left
            self.txtFood.textAlignment = .left
            self.txtHeight.textAlignment = .left
            self.txtWeight.textAlignment = .left
            self.txtHealthCondition.textAlignment = .left
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RPackageCell", for: indexPath) as! RPackageCell
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        let price = content.value(forKey: "price") as! String
        
        cell.lblPrice.text = price+" K.D".localized
        cell.lblPackage.text = name
     
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.Details(_:)), for: .touchUpInside)
       
        if (self.selectedCategory.contains(id))
        {
            cell.view.layer.cornerRadius = 10.0
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = "9DC55E".color.cgColor
            cell.view.backgroundColor = UIColor.clear
            cell.btn.isHidden = false
            cell.img.isHidden = false
        }
        else
        {
            cell.view.layer.cornerRadius = 10.0
            cell.view.layer.masksToBounds = true
            cell.view.layer.borderWidth = 1
            cell.view.layer.borderColor = UIColor.white.cgColor
            cell.view.backgroundColor = UIColor.clear
            
            cell.btn.isHidden = true
            cell.img.isHidden = true
        }
        return cell
    }
    
    @objc func Details(_ sender: UIButton)
    {
        let index = sender.tag
//        let vc: SAResturantPackageDetails = AppDelegate.storyboard.instanceVC()
//        self.present(vc, animated: true, completion: nil)
//
        
        let content = self.TItems.object(at: index) as AnyObject
        let descriptions = content.value(forKey: "descriptions") as! String
        
        let vc:SAResturantPackageDetails = AppDelegate.storyboard.instanceVC()
        vc.details = descriptions
        let screenSize = UIScreen.main.bounds
        let screenWidth = 300
        let screenHeight = 400
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 145, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! RPackageCell
        
        let content = self.TItems.object(at: indexPath.row) as AnyObject
        let id = content.value(forKey: "id") as! Int
        let descriptions = content.value(forKey: "descriptions") as! String
        
        self.selectedPackageId = id
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
                cell.view.layer.borderColor = UIColor.white.cgColor
                cell.view.backgroundColor = UIColor.clear
                
                cell.btn.isHidden = false
                cell.img.isHidden = false
            }
            else
            {
                self.selectedCategory.remove(id)
                self.selectedCategory.add(id)
                cell.view.layer.cornerRadius = 10.0
                cell.view.layer.masksToBounds = true
                cell.view.layer.borderWidth = 1
                cell.view.layer.borderColor = "9DC55E".color.cgColor
                cell.view.backgroundColor = UIColor.clear
                
                cell.btn.isHidden = false
                cell.img.isHidden = false
            }
        }
        self.col.reloadData()
        self.selectedPackage = id
        
//        let vc: SAResturantPackageDetails = AppDelegate.storyboard.instanceVC()
//        self.present(vc, animated: true, completion: nil)
        
        
        let vc:SAResturantPackageDetails = AppDelegate.storyboard.instanceVC()
        vc.details = descriptions
        let screenSize = UIScreen.main.bounds
        let screenWidth = 300
        let screenHeight = 400
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)
  
    }
    
    
    @IBAction func btnCall(_ sender: UIButton)
    {
        let number = MyTools.tools.getConfigString("mobile")
        if let url = URL(string: "tel://\([number)")
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetPackages(ID: 2){(response, err) in
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
            if self.selectedPackageId == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please select one of packages".localized)
            }
            else if self.txtWeight.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your weight".localized)
            }
            else if self.txtHeight.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your height".localized)
            }
            
//            else if self.txtHealthCondition.text?.count == 0
//            {
//                self.showOkAlert(title: "Error".localized, message: "Please enter health condition".localized)
//            }
//            else if self.txtNote.text?.count == 0
//            {
//                self.showOkAlert(title: "Error".localized, message: "Please select one of packages".localized)
//            }
//            else if self.txtFood.text?.count == 0
//            {
//                self.showOkAlert(title: "Error".localized, message: "Please select one of packages".localized)
//            }
            else
            {
                if(self.paymentType == "Cash")
                {
                    self.type = 0
                }
                else{
                    self.type = 1
                }
                self.showIndicator()
                MyApi.api.addPlanMeals(package_id: self.selectedPackageId, weight: Int(txtWeight.text!)!, height: Int(txtHeight.text!)!, health_conditions: txtHealthCondition.text, notes: txtNote.text, allergies: txtFood.text!, coupon_code: self.code)
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
                                    let ns = UserDefaults.standard
                                    let CurrentUser:NSDictionary =
                                        [
                                            "id":Int(MyTools.tools.getMyId()),
                                            "access_token":MyTools.tools.getMyToken(),
                                            "check_meal": 1,
                                            "name":MyTools.tools.getMyname(),
                                        ]
                                    
                                    ns.setValue(CurrentUser, forKey: "CurrentUser")
                                    ns.synchronize()
                                    self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (suc) in
                                        if(suc){
                                            self.navigationController?.pop(animated: true)
                                        }
                                    })
                                }
                                else{
                                    //online link
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
    
    @IBAction func btnMeeting(_ sender: UIButton)
    {
        let vc: DIYExampleViewController = AppDelegate.storyboard.instanceVC()
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }
    
    
}
