//
//  RoomViewController.swift
//  talkRoom
//
//  Created by 東原与生 on 2017/06/04.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var roomImageview = UIImageView()
    var roomNameLabel = UILabel()
    var roomName = String()
    var cellNumber:Int = 0
    
    var roomImageArray = ["one.png","two.png","three.png","four.png","five.png","six.png","seven.png",]
    
    var roomNameArray = ["新入社員雑談場","助け合い広場","業務報告","はなそう会","東京都民憩いの場","関西人ちょっとあつまろか"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        roomImageview = cell.viewWithTag(1) as! UIImageView
        roomNameLabel = cell.viewWithTag(2) as! UILabel
        roomImageview.image = UIImage(named: roomImageArray[indexPath.row])
        roomNameLabel.text = roomNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        roomName = roomNameArray[indexPath.row]
        
        performSegue(withIdentifier: "chat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "chat"){
            
            let chatVC = segue.destination as! ChatViewController
            chatVC.cellNumber = cellNumber
            chatVC.roomName = roomName
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
