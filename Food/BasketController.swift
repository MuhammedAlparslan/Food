//
//  BasketController.swift
//  Food
//
//  Created by Alparslan Cafer on 18.03.2023.
//

import UIKit

class BasketController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var orderCollectionView: UICollectionView!

    var basket = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()

        readDataFromFile()
        let item = UIBarButtonItem(image: UIImage(named: "basket"),
                                   style: .plain, target: self, action: #selector(checkOut))
        navigationItem.rightBarButtonItem = item
     }
    
    @objc func checkOut() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderController") as! OrderController
        navigationController?.show(controller, sender: nil)
    }
    
    func getFilePath() -> URL {
        let paths        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let path         = docDirectory.appendingPathComponent("Basket.json")
        print(path)
        return path
    }
    
    func readDataFromFile() {
        if let data = try? Data(contentsOf: getFilePath()) {
            do {
                basket = try JSONDecoder().decode([Order].self, from: data)
                orderCollectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("File not exist")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        basket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orderCollectionView.dequeueReusableCell(withReuseIdentifier: "OrdersViewCell", for: indexPath) as! OrdersViewCell
        let item = basket[indexPath.item]
        cell.orderNameLabel.text   = item.name
        cell.orderPriceLabel.text  = item.price
        cell.orderPiecesLabel.text = item.pieces
        cell.orderImageView.image  = UIImage(named: item.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: orderCollectionView.frame.width, height: 250)
    }
    
    
}
