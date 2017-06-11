//
//  ChatViewController.swift
//  talkRoom
//
//  Created by 東原与生 on 2017/06/04.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var decodedImage = UIImage()
    var decodedImage2 = UIImage()
    
    var cellNumber:Int = 0
    var roomName = String()
    var messages:[JSQMessage]! = [JSQMessage]()
    
    var incomingBubble:JSQMessagesBubbleImage!
    var outgoingBubble:JSQMessagesBubbleImage!
    var incomingAvatar:JSQMessagesAvatarImage!
    var outgoingAvatar:JSQMessagesAvatarImage!
    
    var backgroundImageView = UIImageView()
    
    @IBOutlet weak var roomLabel: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "hi"
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        print("hi")
        if UserDefaults.standard.object(forKey: "backImage") != nil {
//            print("hi image")
            let decodeData = UserDefaults.standard.object(forKey: "backImage")
            let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData as! Data)
            backgroundImageView.image = decodedImage
            self.collectionView.backgroundView = backgroundImageView
        }
        
        roomLabel.title = roomName
        
        chatStart()
        getInfo()
        
        self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

    }
    
    func chatStart(){
        inputToolbar.contentView.leftBarButtonItem = nil
        
        automaticallyAdjustsScrollViewInsets = true
        
        if UserDefaults.standard.object(forKey: "name") != nil{
            
            
            self.senderId = FIRAuth.auth()?.currentUser?.uid
            self.senderDisplayName = UserDefaults.standard.object(forKey: "name") as? String
            
        }
        
        //吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage2, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: decodedImage, diameter: 64)
        
        //メッセージの配列の初期化
        self.messages = []
        
        
    }
    
    func getInfo(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let firebase = FIRDatabase.database().reference(fromURL: "https://talkroom-76b16.firebaseio.com/").child(String(cellNumber)).child("message")
        firebase.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let snapshotValue = snapshot.value as! NSDictionary
                snapshotValue.setValuesForKeys(dictionary)//ここプリントして確認したい
                let text = snapshotValue["text"] as! String
                let senderId = snapshotValue["from"] as! String
                let name = snapshotValue["name"] as! String
                let message = JSQMessage(senderId: senderId, displayName: name, text: text)
                self.messages.append(message!)
                self.finishReceivingMessage()
            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        
        if messages[indexPath.row].senderId == senderId {
            cell?.textView.textColor = UIColor.white
        } else {
            cell?.textView.textColor = UIColor.darkGray
        }
        
        return cell!
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let rootRef = FIRDatabase.database().reference(fromURL: "https://talkroom-76b16.firebaseio.com/").child(String(cellNumber)).child("message")
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let post: Dictionary<String,Any>? = ["from": senderId, "name": senderDisplayName, "text": text, "timeStamp": timeStamp]
        
        let postRef = rootRef.childByAutoId()
        postRef.setValue(post)
        
        self.inputToolbar.contentView.textView.text = ""
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]//indexpath.item てなんぞや　row でええやん
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = self.messages[indexPath.row]
        
        if message.senderId == senderId {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = self.messages[indexPath.row]
        
        if message.senderId == senderId {
            return self.outgoingAvatar
        } else {
            return self.incomingAvatar
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.messages.count
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
