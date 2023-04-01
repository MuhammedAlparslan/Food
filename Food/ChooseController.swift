//
//  ChooseController.swift
//  Food
//
//  Created by Alparslan Cafer on 17.03.2023.
//

import UIKit
import Lottie

class ChooseController: UIViewController {
    @IBOutlet weak var chooseImageView      : UIImageView!
    @IBOutlet weak var chooseNameLabel      : UILabel!
    @IBOutlet weak var choosePriceLabel     : UILabel!
    @IBOutlet weak var numLabel             : UILabel!
    @IBOutlet weak var chooseAnimationView  : LottieAnimationView!
    
    var list = ProductList(name: "", image: "", price: "")

    var basket = [Order]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ProductName"
        chooseNameLabel.text  = list.name
        choosePriceLabel.text = list.price
        chooseImageView.image = UIImage(named: list.image)
        
        
        animationMove()
        readDataFromFile()
    }
    
    func animationMove() {
        chooseAnimationView.contentMode =    .scaleAspectFill
        chooseAnimationView.loopMode    =    .loop
        chooseAnimationView.play()
    }
    
    func getFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path  = docDirectory.appendingPathComponent("Basket.json")
        return path
    }
    
    func writeToJsonFile() {
        do {
            let data       = try JSONEncoder().encode(basket)
            try data.write(to: getFilePath())
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasketController") as! BasketController
            navigationController?.show(controller, sender: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readDataFromFile() {
        if let data = try? Data(contentsOf: getFilePath()) {
            do {
                basket = try JSONDecoder().decode([Order].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            } else {
                print("File not found ")
        }
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        guard let presentValue = Int(numLabel.text!) else { return }
            let newValue       = presentValue + 1
                numLabel!.text = String(newValue)
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        guard let presentValue = Int(numLabel.text!) else { return }
            let newValue       = presentValue - 1
            if newValue > 0 {
            numLabel!.text = String(newValue)
        }
    }
    @IBAction func addOrderClicked(_ sender: Any) {
        
        self.basket.append(Order(name: chooseNameLabel.text          ?? "",
                                 price: choosePriceLabel.text        ?? "",
                                 pieces: numLabel.text               ?? "",
                                 image: list.image))
        self.writeToJsonFile()
    }
    
}


