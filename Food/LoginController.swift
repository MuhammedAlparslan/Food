//
//  ViewController.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import UIKit
import Lottie
import ProgressHUD

class LoginController: UIViewController, DelegateAccount {
    
    @IBOutlet weak var loginAnimationView   : LottieAnimationView!
    @IBOutlet weak var emailadressText      : UITextField!
    @IBOutlet weak var passwordText         : UITextField!
    
    var loginAccount = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationMove()
        passwordText.isSecureTextEntry = true
    }
    
    func animationMove() {
        loginAnimationView.contentMode =    .scaleAspectFill
        loginAnimationView.loopMode    =    .loop
        loginAnimationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readDataFromFile()
    }
    
    func setText(email: String, password: String) {
        emailadressText.text = email
        passwordText.text = password
    }
    
    func getFilePath() -> URL {
        let paths        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path         = docDirectory.appendingPathComponent("Users.json")
        return path
    }
    
    func readDataFromFile() {
        if let data = try? Data(contentsOf: getFilePath()) {
            do {
                loginAccount = try JSONDecoder().decode([Account].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert     = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton  = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil )
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if emailadressText.text      == "" {
            makeAlert(titleInput: "ERROR", messageInput: "E - mail adresini düzgün girməlisiniz !!")
        } else if passwordText.text  == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Şifrəni düzgün girməlisiniz !!")
        } else {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleSpinFade
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                ProgressHUD.dismiss()
                if self.loginAccount.contains(where: { $0.emailadress == self.emailadressText.text &&
                    $0.password    == self.passwordText.text }) {
   
                    if let scene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = scene.delegate as? SceneDelegate {
                        UserDefaults.standard.set(false, forKey: "loggedIn")
                        sceneDelegate.setRootRestaurantController(windowScene: scene)
                    }
                }
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            ProgressHUD.dismiss()
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
            controller.delegate = self
            self.navigationController?.show(controller, sender: nil)
        }
        
    }
}
