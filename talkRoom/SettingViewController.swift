//
//  SettingViewController.swift
//  talkRoom
//
//  Created by 東原与生 on 2017/06/04.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var backgroundImage = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "profileImage") != nil {
            
            let decodeData = UserDefaults.standard.object(forKey: "profileImage")
            let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData as! Data)
            profileImageView.image = decodedImage
            profileNameLabel.text = UserDefaults.standard.object(forKey: "name") as? String
            
        }

    }
    @IBAction func openAlbum(_ sender: Any) {
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    @IBAction func camera(_ sender: Any) {
        
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            backgroundImage = pickedImage
            
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: "backImage") != nil{
            let decodeData = UserDefaults.standard.object(forKey: "backImage")
            let dacodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data:dacodedData! as Data)
            backgroundImage = decodedImage!
        }
        
        var data:NSData = NSData()
        
        if backgroundImage.size.width != 0{
            data = UIImageJPEGRepresentation(backgroundImage, 0.1)! as NSData
            let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
            UserDefaults.standard.set(base64String, forKey: "backImage")
        }
        
        dismiss(animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}
