//
//  NSZoomImg.swift
//  EasyCollector
//
//  Created by Ramez Adnan on 6/28/17.
//  Copyright © 2017 Ramez Adnan Aish. All rights reserved.
//

import UIKit
import SDWebImage

class NSZoomImg: UIViewController , UIScrollViewDelegate {
 
    @IBOutlet weak var scrollView: UIScrollView!
    var objPass3 = ""
    
    @IBOutlet weak var showImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    let logo = objPass3.value(forKey: "logo") as? String ?? ""
//      let prefix = "http://scalenmore.com/"
     showImage.sd_setImage(with: URL(string: objPass3), placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        scrollView.contentSize = .init(width: 2000, height: 2000)
        updateZoomFor(size: view.bounds.size)
    }
    
    @IBAction func btnDis(_ sender: UIButton)
    {
self.dismiss(animated: true, completion: nil)
    }

    
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return showImage
        }
        
        func updateZoomFor(size: CGSize){
            let widthScale = size.width / showImage.bounds.width
            let heightScale = size.height / showImage.bounds.height
            let scale = min(widthScale,heightScale)
            scrollView.minimumZoomScale = scale
        }
        
 

}
