//
//  LoginViewController.swift
//  fanhasan
//
//  Created by mac on 11.06.2023.
//  Copyright © 2023 mac. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            isValidEmail(email) else {
                showAlert(withTitle: "Ошибка", message: "Введите корректный адрес электронной почты")
                return
        }
        guard let password = passwordTextField.text, password.count >= 8 else {
            showAlert(withTitle: "Ошибка", message: "Пароль должен содержать минимум 8 символов")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard error == nil, let _ = authResult else {
                self.showAlert(withTitle: "Ошибка", message: "Неверный email или пароль")
                return
            }
            
            // переход на экран приложения после успешной авторизации
            self.performSegue(withIdentifier: "ToMain", sender: nil)
        }
    }
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ToRegistration", sender: nil)
    }
    
    
    // Функция для отображения сообщения с помощью UIAlertController
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
