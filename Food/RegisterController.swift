//
//  RegisterController.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import UIKit
import ProgressHUD
import Lottie

protocol DelegateAccount {
    func setText(email: String, password: String)
}

class RegisterController: UIViewController {
    @IBOutlet weak var registerAnimationView    : LottieAnimationView!
    @IBOutlet weak var registerFullnameText     : UITextField!
    @IBOutlet weak var registerBirthdateText    : UITextField!
    @IBOutlet weak var registerEmailText        : UITextField!
    @IBOutlet weak var registerPasswordText     : UITextField!
    
    var loginAccount = [Account]()
    
    var delegate : DelegateAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readDataFromFile()
        animationMove()
    }
    
    func animationMove() {
        registerAnimationView.contentMode =    .scaleAspectFill
        registerAnimationView.loopMode    =    .loop
        registerAnimationView.play()
    }
    
    func getFilePath() -> URL {
        let paths           = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory    = paths[0]
        let path            = docDirectory.appendingPathComponent("Users.json")
        return path
    }
    
    func writeToJsonFile() {
        do {
            let data = try JSONEncoder().encode(loginAccount)
            try data.write(to: getFilePath())
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
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
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil )
    }
    
    @IBAction func secondRegisterClicked(_ sender: Any) {
        if registerFullnameText.text         == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Ad və soyadınızı girməlisiniz !!")
        } else if registerBirthdateText.text == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Doğum tarixinizi girməlisiniz !!")
        } else if registerEmailText.text     == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Email adresinizi  girməlisiniz!!")
        } else if registerPasswordText.text  == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Şifrənizi girməlisiniz !! ")
        } else {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleSpinFade
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                ProgressHUD.dismiss()
                self.loginAccount.append(Account( fullname:    self.registerFullnameText.text ?? "",                                                         emailadress:  self.registerEmailText.text ?? "",                                                           password:       self.registerPasswordText.text ?? "",                                                      birthdate:      self.registerBirthdateText.text ?? ""))
                self.writeToJsonFile()
                
                self.delegate?.setText(email: self.registerEmailText.text ?? "", password: self.registerPasswordText.text ?? "")
            }
        }
    }
}
