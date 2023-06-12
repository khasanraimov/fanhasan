//
//  CreatingViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit

class CreatingViewController: UIViewController {
    
    
    @IBOutlet weak var imageFanfic: UIImageView!
    @IBOutlet weak var addPictureLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dexcriptionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func toWriteFanfic(_ sender: Any) {
        performSegue(withIdentifier: "ToWriteFanfic", sender: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
