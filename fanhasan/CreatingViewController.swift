//
//  CreatingViewController.swift
//  fanhasan
//
//  Created by mac on 12.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit

class CreatingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageFanfic: UIImageView!
    @IBOutlet weak var addPictureLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dexcriptionText: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    let categories = ["Фэнтези", "Романтика", "Драма", "Приключения", "Научная Фантастика"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryButton.setTitle(categories.first, for: .normal)
        // Добавляем жест UITapGestureRecognizer к imageFanfic
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        imageFanfic.isUserInteractionEnabled = true
        imageFanfic.addGestureRecognizer(tapGesture)


    }
    
    @objc func selectPicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let galleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cameraAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageFanfic.contentMode = .scaleAspectFit
            imageFanfic.image = pickedImage
            addPictureLabel.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Выберите категорию", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            let categoryAction = UIAlertAction(title: category, style: .default) { (action) in
                self.categoryButton.setTitle(category, for: .normal)
            }
            actionSheet.addAction(categoryAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func toWriteFanficButtonTapped(_ sender: Any) {
        guard let title = titleText.text, !title.isEmpty,
            let description = dexcriptionText.text, !description.isEmpty,
            let category = categoryButton.titleLabel?.text,
            let image = imageFanfic.image else {
                showAlert(withTitle: "Ошибка", message: "Пожалуйста, заполните все поля формы и выберите категорию")
                return
        }
        
        let fanficData = Fanfic(id: nil, title: title, description: description, category: category, image: image.pngData(), authorID: "", likes: [:], comments: [], timestamp: Date().timeIntervalSince1970)

        performSegue(withIdentifier: "toWriteFanfic", sender: fanficData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWriteFanfic" {
            let writeFanficVC = segue.destination as! WriteFanficViewController
            writeFanficVC.fanficData = sender as? Fanfic
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

struct Fanfic: Codable {
    let id: Int?
    let title: String
    let description: String
    let category: String
    let image: Data
    let authorID: String?
    var authorNickname: String?
    var likes: [String: Bool]
    var comments: [Comment]
    let timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case image
        case authorID = "author_id"
        case authorNickname = "author_nickname"
        case likes
        case comments
        case timestamp
    }
    
    init(title: String, description: String, category: String, image: Data, authorID: String?, authorNickname: String?, likes: [String: Bool], comments: [Comment], timestamp: TimeInterval) {
        self.id = nil
        self.title = title
        self.description = description
        self.category = category
        self.image = image
        self.authorID = authorID
        self.authorNickname = authorNickname
        self.likes = likes
        self.comments = comments
        self.timestamp = timestamp
    }
}

struct Comment {
    var id: String?
    var text: String
    var authorID: String
    var timestamp: TimeInterval
}

