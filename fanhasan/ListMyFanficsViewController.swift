//
//  ListMyFanficsViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit
import Firebase

class ListMyFanficsViewController: UIViewController {
    
    @IBOutlet weak var listMyFanficsTableView: UITableView!
    var fanficsList = [Fanfic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Получение списка фанфиков текущего пользователя из базы данных
        let userID = Auth.auth().currentUser?.uid
        let fanficsRef = Database.database(url: "https://fanhasan-16c49-default-rtdb.firebaseio.com/").reference().child("fanfics")
        let query = fanficsRef.queryOrdered(byChild: "authorID").queryEqual(toValue: userID)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            guard let fanficsData = snapshot.value as? [String: Any] else {
                return
            }
            
            let fanfics = fanficsData.compactMap { (key, value) -> Fanfic? in
                if let fanficDict = value as? [String: Any],
                    let title = fanficDict["title"] as? String,
                    let description = fanficDict["description"] as? String,
                    let category = fanficDict["category"] as? String,
                    let text = fanficDict["text"] as? String,
                    let timestamp = fanficDict["data_published"] as? TimeInterval {
                    
                    // создаем объект Fanfic, предварительно преобразовав данные из словаря
                    let fanfic = Fanfic(id: key,
                                        title: title,
                                        description: description,
                                        category: category,
                                        image: nil,
                                        authorID: userID ?? "",
                                        likes: [:],
                                        comments: [],
                                        timestamp: timestamp)
                    
                    return fanfic
                }
                
                return nil
            }
            
            // обновляем таблицу с данными о полученных фанфиках
            self.fanficsList = fanfics
            self.listMyFanficsTableView.reloadData()
        })
    }
    
    @IBAction func toCreateNewFanfic(_ sender: Any) {
        performSegue(withIdentifier: "ToCreate", sender: nil)
    }
}

extension ListMyFanficsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // количество элементов для отображения в таблице
        return fanficsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListMyFanficsTableViewCell") as! ListMyFanficsTableViewCell
        
        // настройка ячейки согласно данных, которые нужно отобразить
        let fanfic = fanficsList[indexPath.row]
        cell.titleFanfic.text = fanfic.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.datePublished.text = dateFormatter.string(from: Date(timeIntervalSince1970: fanfic.timestamp))
        
        // загрузка изображения фанфика из Firebase Storage, если оно есть
        if let imageData = fanfic.image {
            let storageRef = Storage.storage(url: "gs://fanhasan-16c49.appspot.com").reference(forURL: String(data: imageData, encoding: .utf8)!)
            storageRef.getData(maxSize: 1024 * 1024) { data, error in
                if let error = error {
                    print("Ошибка при загрузке изображения фанфика \(fanfic.id ?? ""): \(error.localizedDescription)")
                    return
                }
                
                if let imageData = data {
                    cell.imageFanfic.image = UIImage(data: imageData)
                }
            }
        } else {
            // скрыть изображение, если его нет
            cell.imageFanfic.isHidden = true
        }
        
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
