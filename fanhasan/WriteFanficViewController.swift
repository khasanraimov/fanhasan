//
//  WriteFanficViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit

class WriteFanficViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func publishButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
