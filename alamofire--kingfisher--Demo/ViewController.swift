//
//  ViewController.swift
//  alamofire--kingfisher--Demo
//
//  Created by kamal agarwal on 25/04/21.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionV: UICollectionView!
    
    @IBOutlet weak var actind: UIActivityIndicatorView!
    var brandArr = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchall()
    }
    
    func fetchall(){
        
        let param = ["request": "brand_listing","country":"india","device_type":"ios"]
        
        
        AF.request("https://www.kalyanmobile.com/apiv1_staging/brand_listing.php",method: .post,parameters: param).responseJSON { (resp) in
            
            print("Response Here")
            
            if let dict = resp.value as? NSDictionary{
                
                if let respCode = dict.value(forKey: "responseCode") as? String,let respMsg = dict.value(forKey: "responseMessage") as? String{
                    if respCode == "success" {
                        print("SUCCESS")
                        
                        print("Response Here \(dict)")
                        
                        self.brandArr = dict.value(forKey: "brand") as! [NSDictionary]
                        print(self.brandArr)
                        
                        self.collectionV.reloadData()
                        
                        self.actind.startAnimating()
                        self.actind.stopAnimating()
                        
                    }
                    else{
                        print("ERR \(respMsg)")
                    }
                }
                
            }
            
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCVC", for: indexPath) as! customCVC
        let dict = brandArr[indexPath.row].value(forKey: "brand_id") as? String ?? ""
        cell.brandidLbl.text = dict
        
        let dict1 = brandArr[indexPath.row].value(forKey: "brand_name") as? String ?? ""
        cell.brandnameLbl.text = dict1
        
        let image = brandArr[indexPath.row].value(forKey: "brand_image_path") as? String ?? ""
        if let imgurl = URL(string: image ){
            cell.imgV.kf.setImage(with: imgurl)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: collectionView.frame.size.width, height: 200)
    }
    
    
}

class customCVC: UICollectionViewCell{
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var brandnameLbl: UILabel!
    @IBOutlet weak var brandidLbl: UILabel!
}



