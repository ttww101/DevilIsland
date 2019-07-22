//
//  BuyStarVC.swift
//  DevilIsland
//
//  Created by Apple on 7/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import StoreKit

class BuyStarVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var transactionInProgress = false // 是否交易中
    
    var buySuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buyClick(_ sender: UIButton) {
        if self.transactionInProgress { return }
        self.requestProductInfo()
        self.transactionInProgress = true
    }
    @IBAction func cancelClick(_ sender: UIButton) {
        self.remove()
    }
    
    // get product
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: ["gamestar908430985"])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
            self.transactionInProgress = false
        }
    }
    // SKProductsRequestDelegate - get products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            let payment = SKPayment(product: response.products[0])
            SKPaymentQueue.default().add(payment)
        }
        else {
            print("There are no products.")
            self.transactionInProgress = false
        }
    }
    
    // SKPaymentTransactionObserver - get transaction state
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("Transaction completed successfully.")
                    alertMessage("购买成功")
                    GameData.shared.star = 5
                    GameData.shared.saveStar()
                    self.transactionInProgress = false
                    buySuccess?()
                    self.remove()
                case .purchasing:
                    print("purchasing")
                case .failed:
                    print("Transaction Failed")
                    alertMessage("购买失败")
                    self.transactionInProgress = false
                default:
                    print(transaction.transactionState.rawValue)
                }
            }
    }
    
    func alertMessage(_ content: String) {
        let alert = UIAlertController(title: nil, message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
