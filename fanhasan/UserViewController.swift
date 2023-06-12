//
//  UserViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var toSettings: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var folowers: UILabel!
    
    @IBOutlet weak var countFollowers: UILabel!
    @IBOutlet weak var fanficsUser: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func toSettings(_ sender: Any) {
        
        performSegue(withIdentifier: "ToSettings", sender: nil)
        
    }
    
}


