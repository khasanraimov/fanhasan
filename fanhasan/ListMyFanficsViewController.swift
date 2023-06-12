//
//  ListMyFanficsViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit

class ListMyFanficsViewController: UIViewController {
    
    
    @IBOutlet weak var listMyFanfic: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func toCreateNewFanfic(_ sender: Any) {
        
        performSegue(withIdentifier: "ToCreate", sender: nil)
        
    }
    
    
    
}

extension ListMyFanficsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // возвращаем количество элементов для отображения в таблице
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListMyFanficsTableViewCell") as! ListMyFanficsTableViewCell
        
        // настраиваем ячейку согласно данных, которые нужно отобразить
        cell.titleFanfic.text = "Название фанфика"
        cell.datePublished.text = "Дата публикации"
        
        return cell
    }
}

extension ListMyFanficsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // обработка нажатия на ячейку
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // задание высоты ячейки
        return 80 // например, высота 80 точек
    }
}

class ListMyFanficsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageFanfic: UIImageView!
    @IBOutlet weak var titleFanfic: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    
    
}
