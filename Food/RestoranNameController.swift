//
//  RestoranNameController.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import UIKit

class RestoranNameController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var restoranNameTableView: UITableView!
    
    var restaurantList = [RestaurantName]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Restaurants"
        jsonFileRead()
        
        let item = UIBarButtonItem(image: UIImage(named: "basket"),
                                   style: .plain, target: self, action: #selector(basket))
        navigationItem.rightBarButtonItem = item

     }
    
    @objc func basket() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasketController") as! BasketController
        navigationController?.show(controller, sender: nil)
    }
    
    func jsonFileRead() {
        if let jsonFile = Bundle.main.url(forResource: "Restorans", withExtension: "json"),
           let data     = try? Data(contentsOf: jsonFile) {
            do {
                restaurantList = try JSONDecoder().decode([RestaurantName].self, from: data)
                 restoranNameTableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            print("sadas")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restoranNameTableView.dequeueReusableCell(withIdentifier: "RestoranNameViewCell", for: indexPath) as! RestoranNameViewCell
        cell.restoranNameLabel.text     = restaurantList[indexPath.row].name
        cell.restoranNameImage.image    = UIImage(named: restaurantList[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListController") as! ProductListController
        controller.productLists = restaurantList[indexPath.row].restorans
            navigationController?.show(controller, sender: nil)
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        85
    }
}

