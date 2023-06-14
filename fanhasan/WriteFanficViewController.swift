//
//  WriteFanficViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit
import Firebase

class WriteFanficViewController: UIViewController {
    
    var fanficData: Fanfic?
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = fanficData?.title {
            self.title = "Написать \(title)"
        }
        
        if let imageData = fanficData?.image {
            
        }

    }
    
    @IBAction func publishButtonTapped(_ sender: Any) {
        guard let fanficData = fanficData,
            let text = textView.text, !text.isEmpty else {
                showAlert(withTitle: "Ошибка", message: "Пожалуйста, заполните текст фанфика")
                return
        }
        
        let fanficRef = Database.database(url: "https://fanhasan-16c49-default-rtdb.firebaseio.com/").reference().child("fanfics").childByAutoId()
        let currentDate = Date()
        
        let fanficDict = ["title": fanficData.title,
                          "description": fanficData.description,
                          "category": fanficData.category,
                          "text": text,
                          "data_published": currentDate.timeIntervalSince1970] as [String : Any]
        
        
        fanficRef.setValue(fanficDict) { (error, ref) in
            if let error = error {
                self.showAlert(withTitle: "Ошибка", message: "Не удалось опубликовать фанфик: \(error.localizedDescription)")
                return
            }
            
            self.showAlert(withTitle: "Успех", message: "Фанфик успешно опубликован!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let listMyFanficsVC = storyboard.instantiateViewController(withIdentifier: "ListMyFanficsViewController") as? ListMyFanficsViewController else { return }
            listMyFanficsVC.modalPresentationStyle = .fullScreen
            self.present(listMyFanficsVC, animated: true, completion: nil)        }
        
        // Сохраняем обложку в Firebase Storage, если она есть
        if let imageData = fanficData.image {
            let storageRef = Storage.storage(url: "gs://fanhasan-16c49.appspot.com").reference().child("fanfics").child("\(fanficRef.key!).jpg")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    self.showAlert(withTitle: "Ошибка", message: "Не удалось загрузить обложку: \(error.localizedDescription)")
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self.showAlert(withTitle: "Ошибка", message: "Не удалось получить URL обложки: \(error.localizedDescription)")
                        return
                    }
                    fanficRef.updateChildValues(["imageURL": url?.absoluteString ?? ""]) // сохраняем ссылку на картинку в базу данных
                }
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    

}
