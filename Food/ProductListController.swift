//
//  ProductListController.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import UIKit

class ProductListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var productListController: UICollectionView!
    @IBOutlet weak var productSearchText    : UISearchBar!
    
    var productLists        = [ProductList]()
    var copyproductLists    = [ProductList]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Product"
        copyproductLists = productLists
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productListController.dequeueReusableCell(withReuseIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
        cell.productNameLabel.text  = productLists[indexPath.item].name
        cell.productPriceLabel.text = productLists[indexPath.row].price
        cell.productImageView.image = UIImage(named: productLists[indexPath.item].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseController") as! ChooseController
        controller.list = productLists[indexPath.row]
        navigationController?.show(controller, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: productListController.frame.width * 0.9, height: 120)
    }
}

extension ProductListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            productLists = copyproductLists
        } else {
            productLists = copyproductLists.filter({ $0.name.contains(searchText) })
        }
        productListController.reloadData()
    }
}

    

