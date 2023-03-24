//
//  OrderController.swift
//  Food
//
//  Created by Alparslan Cafer on 19.03.2023.
//

import UIKit
import ProgressHUD
import Lottie

class OrderController: UIViewController, CardDelegate {
    @IBOutlet weak var orderAnimationView   : LottieAnimationView!
    @IBOutlet weak var orderName            : UITextField!
    @IBOutlet weak var orderCardN           : UITextField!
    @IBOutlet weak var orderCardD           : UITextField!
    @IBOutlet weak var orderCVC             : UITextField!
    
    var cardsData = [Card]()
    var basketOrder = [Order]()
    var isComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationMove()
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        readDataFromFile()
    }
    
    func setText(bankName: String, cardNumber: String, cardDate: String, cardCVC: String) {
        orderName.text  = bankName
        orderCardN.text = cardNumber
        orderCardD.text = cardDate
        orderCVC.text   = cardCVC
    }
    
    
    func getFilePath() -> URL {
        let paths        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path         = docDirectory.appendingPathComponent("Card.json")
        return path
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
    
    func getBasketFilePath() -> URL {
        let paths        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path         = docDirectory.appendingPathComponent("Basket.json")
        return path
    }
    
    func deleteAllFromBasketFile() {
        do {
            basketOrder.removeAll()
            let data = try JSONEncoder().encode(basketOrder)
            try data.write(to: getBasketFilePath())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert    = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            if self.isComplete {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil )
    }
    
    
    func animationMove() {
        orderAnimationView.contentMode =    .scaleAspectFill
        orderAnimationView.loopMode    =    .loop
        orderAnimationView.play()
    }
    
    @IBAction func orderCompleteClicked(_ sender: Any) {
        if orderName.text         == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Bank adını daxil edin !!")
        } else if orderCardN.text == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard nömrəsini daxil edin !!")
        } else if orderCardD.text == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard tarixini daxil edın !!")
        } else if orderCVC.text   == "" {
            makeAlert(titleInput: "ERROR", messageInput: "Kard CVC ni daxil edin !!")
        } else {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleSpinFade
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                ProgressHUD.dismiss()
                
                if self.cardsData.contains(where: { $0.cardNumber  == self.orderCardN.text &&
                                                    $0.cardDate    == self.orderCardD.text &&
                                                    $0.cardCVC     == self.orderCVC.text}) {
                    
                    self.isComplete = true
                    self.deleteAllFromBasketFile()
                    self.makeAlert(titleInput: "SuccessFully", messageInput: "Sifarişiniz tamamlandı")
                }
            }
        }
    }
    
    
    @IBAction func cardRegisterClicked(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardAddController") as! CardAddController
        controller.delegate = self
        self.navigationController?.show(controller, sender: nil)
    }
}
