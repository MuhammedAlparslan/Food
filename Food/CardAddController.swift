//
//  CardAddController.swift
//  Food
//
//  Created by Alparslan Cafer on 19.03.2023.
//

import UIKit
import ProgressHUD
import Lottie

protocol CardDelegate {
    func setText(bankName: String, cardNumber: String, cardDate: String, cardCVC: String)
}

class CardAddController: UIViewController {
    @IBOutlet weak var cardAddAnimationView     : LottieAnimationView!
    @IBOutlet weak var addName                  : UITextField!
    @IBOutlet weak var addCardN                 : UITextField!
    @IBOutlet weak var addCardD                 : UITextField!
    @IBOutlet weak var addCVC                   : UITextField!
    
    var cardsData = [Card]()
    
    var delegate : CardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationMove()
        readDataFromFile()
    }
    
    func getFilePath() -> URL {
        let paths        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path         = docDirectory.appendingPathComponent("Card.json")
        return path
    }
    
    func writetoJsonFile() {
        do {
            let data = try JSONEncoder().encode(cardsData)
            try data.write(to: getFilePath())
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readDataFromFile() {
        if let data       = try? Data(contentsOf: getFilePath()) {
            do {
                cardsData = try JSONDecoder().decode([Card].self, from: data)
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
    
    func animationMove() {
        cardAddAnimationView.contentMode =    .scaleAspectFill
        cardAddAnimationView.loopMode    =    .loop
        cardAddAnimationView.play()
    }

    @IBAction func cardAddClicked(_ sender: Any) {
        if addName.text          == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Bank adını daxil etməlisiniz !!")
        } else if addCardN.text  == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard nömrəsini daxil etmələsiniz !!")
        } else if addCardD.text  == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard bitiş tarixini daxil etməlisiniz !!")
        } else if addCVC.text    == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard CVC ni daxil etməlisiniz !!")
        } else {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleSpinFade
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                ProgressHUD.dismiss()
                
                self.cardsData.append(Card(name:        self.addName.text ?? "",
                                           cardNumber: self.addCardN.text ?? "",
                                           cardDate: self.addCardD.text ?? "",
                                           cardCVC: self.addCVC.text ?? ""))
                
                self.writetoJsonFile()
                self.delegate?.setText(bankName: self.addName.text ?? "",
                                       cardNumber: self.addCardN.text ?? "",
                                       cardDate: self.addCardD.text ?? "",
                                       cardCVC: self.addCVC.text ?? "")
                
                
                
            }
        }
    }
}
