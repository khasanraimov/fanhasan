//
//  RegistrationViewController.swift
//  fanhasan
//
//  Created by mac on 11.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self as? UITextFieldDelegate
        passwordTextField.delegate = self as? UITextFieldDelegate
        nicknameTextField.delegate = self as? UITextFieldDelegate

    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showAlert(withTitle: "Ошибка", message: "Введите корректный адрес электронной почты")
            return
        }
        guard let password = passwordTextField.text, password.count >= 8 else {
            showAlert(withTitle: "Ошибка", message: "Пароль должен содержать минимум 8 символов")
            return
        }
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(withTitle: "Ошибка", message: "Введите nickname")
            return
        }
        
        // Проверка наличия email и nickname в базе данных
        let usersRef = Database.database(url: "https://fanhasan-16c49-default-rtdb.firebaseio.com/").reference(withPath: "users")
        usersRef.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                self.showAlert(withTitle: "Ошибка", message: "Данный email уже зарегистрирован")
            } else {
                usersRef.queryOrdered(byChild: "nickname").queryEqual(toValue: nickname).observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        self.showAlert(withTitle: "Ошибка", message: "Данный nickname уже зарегистрирован")
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                            guard error == nil, let result = authResult else {
                                self.showAlert(withTitle: "Ошибка", message: error?.localizedDescription ?? "Неизвестная ошибка")
                                return
                            }
                            
                            let userObject = [
                                "email": email,
                                "nickname": nickname,
                                "follows": 0
                                ] as [String: Any]
                            
                            guard let userId = authResult?.user.uid else { return }
                            let databaseRef = Database.database(url: "https://fanhasan-16c49-default-rtdb.firebaseio.com/").reference(withPath: "users").child(userId)
                            databaseRef.setValue(userObject) { error, _ in
                                if error != nil {
                                    self.showAlert(withTitle: "Ошибка", message: error?.localizedDescription ?? "Неизвестная ошибка")
                                } else {
                                    self.showAlert(withTitle: "Успешно", message: "Вы успешно зарегистрировались")
                                    self.performSegue(withIdentifier: "ToMain", sender: nil)
                                }
                                
                            }
                        }
                    }
                })
            }
        })
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ToLogin", sender: nil)
        
    }
    
    //Функция для отображения сообщения с помощью UIAlertController
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    // Функция для проверки корректности адреса электронной почты
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
