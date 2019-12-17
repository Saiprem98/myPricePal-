//
//  MainViewController.swift
//  MyPricePal
//
//  Created by Brice Redmond on 4/15/19.
//  Copyright © 2019 CS48. All rights reserved.
//

import UIKit
import BarcodeScanner
import Anchors
import FirebaseDatabase
import Foundation
import AVFoundation
import SafariServices

//The MainViewController handles switching between the other view controllers. It does
//not have any views of its own as it is a UINavigationController.
class MainViewController: UINavigationController {
    
    //The controller where all the barcodes searched will show up
    var searchVC: SearchViewController?
    
    //The controller that handles scanning the barcode.
    var barcodeVC: BarcodeScannerViewController?
    
    var curPriceFinder: PriceFinder?
    var curKeywordFinder: KeywordFinder?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var curItem = SearchStruct(barcodeString: "", itemN: "", keywordString: [], priceArray: [])
    
    //Here we set up all of the view controllers and their delegates.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //initialize barcodeVC and send delegates.
        let barcodeVC = topViewController as! BarcodeScannerViewController
        barcodeVC.codeDelegate = self
        barcodeVC.errorDelegate = self
        barcodeVC.dismissalDelegate = self
        barcodeVC.navigationItem.title = "Scan Barcode" //Set the title of the BarcodeVC
        barcodeVC.isOneTimeSearch = true //So that the barcodeScanner doesnt keep scanning
        barcodeVC.messageViewController.view.backgroundColor = .black
        barcodeVC.messageViewController.textLabel.superview?.backgroundColor = .black
        barcodeVC.messageViewController.imageView.backgroundColor = .white
        barcodeVC.messageViewController.textLabel.textColor = .white
        barcodeVC.messageViewController.borderView.layer.borderColor = UIColor.white.cgColor
        barcodeVC.cameraViewController.showsCameraButton = true //for front facing camera
        
        //Give the barcodeVC the search button, tutorial button, and graph button
        setBarcodeVCButtons(barcodeVC)
        
        initializeSearchVC()
    }
    
    func setBarcodeVCButtons(_ controller: BarcodeScannerViewController) {
        DispatchQueue.main.async {
            let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchAction(sender:)))
            let analyticsBarButton = UIBarButtonItem(title: "Graph", style: .plain, target: self, action: #selector(self.analyticsAction(_:)))
            
            controller.navigationItem.leftBarButtonItems = [searchBarButton, analyticsBarButton]
            controller.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tutorial", style: .plain, target: self, action: #selector(self.tutorialAction(_:)))
        }
    }
    
    func resetBarcodeVC(_ barcodeVC: BarcodeScannerViewController) {
        DispatchQueue.main.async {
            self.curPriceFinder?.flag = false
            self.curKeywordFinder?.flag = false
            self.setBarcodeVCButtons(barcodeVC)
            barcodeVC.reset(animated: true)
        }
    }
    
    func initializeSearchVC() {
        //Initialize searchVC and set the delegates.
        searchVC = SearchViewController(style: .plain)
        searchVC?.searchRequestedDelegate = self
        
        let arr = SaveData.getSearchData()
        for s in arr {
            searchVC?.giveItemScanned(itemN: s.itemN, barcodeString: s.barcodeString, keywordString: s.keywordString, priceArray: s.priceArray)
        }
    }
    
    //Asks the user if the item is correct, and if so goes to the itemVC. If not goes back to scanning
    func alertItemFound(_ itemN: String, _ barcodeNum: String, _ barcodeVC: BarcodeScannerViewController, _ itemVC: ItemViewController){
        if topViewController is BarcodeScannerViewController {
            let alert = UIAlertController(title: "Item", message: "Is " + itemN + " your item?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {action in
                
                itemVC.createItems()
                self.pushViewController(itemVC, animated: true)
               
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {action in
                self.resetBarcodeVC(barcodeVC)
            
            }))
            
            barcodeVC.present(alert, animated: true)
        }
    }
        
        //Shows that the firebase could not find the barcodestring and sends the user back to scanning
    func alertCantFindItem(_ barcodeNum: String) {
        let barcodeVC = topViewController as! BarcodeScannerViewController
        
        let alert = UIAlertController(title: "Error", message: "Could not find " + barcodeNum, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Enter Item Yourself", style: UIAlertAction.Style.default, handler: {action in
            self.alertAddItem(barcodeNum, barcodeVC)
        }))
        
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: {action in
            self.resetBarcodeVC(barcodeVC)
        }))
        
        barcodeVC.present(alert, animated: true)
    }
    
    //If the user chooses to add in the item, this alert is called that asks for user input.
    func alertAddItem(_ barcode: String, _ barcodeVC: BarcodeScannerViewController) {
        let alert = UIAlertController(title: "Item", message: "Enter item name:", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if let text = textField!.text {
                if(text != "") {
                    self.setPriceFinder(text, barcode)
                    self.setKeywordFinder(text)
                }else{
                    self.resetBarcodeVC(barcodeVC)
                }
            }
            let ref3 = Database.database().reference()
            ref3.child("Barcodes").child(barcode).setValue(textField?.text)
            update_products_added()
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertAction.Style.default, handler: {action in
            self.resetBarcodeVC(barcodeVC)
        }))
        barcodeVC.present(alert, animated: true)
    }
    
    //If the user is not connected to the internet this alert is called that tells them to
    //try again.
    func alertNoInternet(_ barcodeVC: BarcodeScannerViewController) {
        let alert = UIAlertController(title: "Error", message: "No internet", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: {action in
            self.resetBarcodeVC(barcodeVC)
        }))
        
        barcodeVC.present(alert, animated: true)
    }
    
    func alertGeneralError(_ barcodeVC: BarcodeScannerViewController) {
          let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: {action in
            self.resetBarcodeVC(barcodeVC)
        }))
        
        barcodeVC.present(alert, animated: true)
    }
    
    func generalError() {
        DispatchQueue.main.async {
            self.curKeywordFinder?.flag = false
            self.curPriceFinder?.flag = false
            
            self.alertGeneralError(self.topViewController as! BarcodeScannerViewController)
        }
    }
    
    //Function for if the user presses the search button on the barcodeVC
    @objc func searchAction(sender: Any) {
        pushViewController(searchVC!, animated: true)
    }
    
    @objc func analyticsAction(_ sender: Any) {     
       let swiftcharts = SwiftsChartsViewController()
        pushViewController(swiftcharts, animated: true)
    }
    
    @objc func tutorialAction(_ sender: Any) {
        let tutorialVC = TutorialPageController()
        pushViewController(tutorialVC, animated: true)
    }
  
    @objc func stopScanningAction(_ sender: Any) {
        resetBarcodeVC(topViewController as! BarcodeScannerViewController)
    }
    
    func getItemName(_ barcodeString: String,  _ barcodeVC: BarcodeScannerViewController) {
        let itemFinder = ItemFinder()
        itemFinder.mainViewController = self
        itemFinder.getItemName(barcodeString)
    }
    
    func itemFound(barcodeString: String, itemN: String) {
        curItem.barcodeString = barcodeString
        curItem.itemN = itemN
        
        setKeywordFinder(itemN)
        setPriceFinder(itemN, barcodeString)
    }
    
    func setPriceFinder(_ itemN: String, _ barcodeString: String) {
        let priceFinder = PriceFinder()
        priceFinder.mainVC = self
        priceFinder.getBestPrices(barcodeString: barcodeString, itemName: itemN)
        curPriceFinder = priceFinder
    }
    
    func setKeywordFinder(_ itemN: String) {
        let keywordFinder = KeywordFinder()
        keywordFinder.mainVC = self
        keywordFinder.truncateName(itemN)
        curKeywordFinder = keywordFinder
    }
    
    func returnPrices(_ prices: [String]) {
        DispatchQueue.main.async {
            self.curItem.priceArray = prices
            if(self.curItem.filled()) {
                self.fullItemFound(shouldPush: false)
            }
        }
    }
    
    func returnKeywords(_ keywords: [String]) {
        DispatchQueue.main.async {
            self.curItem.keywordString = keywords
            if(self.curItem.filled()) {
                self.fullItemFound(shouldPush: false)
            }
        }
    }
    
    func fullItemFound(shouldPush: Bool) {
        let itemVC = initializeItemVC(shouldPush: shouldPush)
        
        searchVC?.giveItemScanned(itemN: curItem.itemN, barcodeString: curItem.barcodeString, keywordString: curItem.keywordString, priceArray: curItem.priceArray)
        
        if(!shouldPush) {
            self.alertItemFound(curItem.itemN, curItem.barcodeString, self.viewControllers[0] as! BarcodeScannerViewController, itemVC)
        }
        
        curItem = SearchStruct(barcodeString: "", itemN: "", keywordString: [], priceArray: [])
    }
    
    //In order to update the name of the item for the itemVC, we have to reset the itemVC.
    //This function initializes everything needed, and if wanted will also push the itemVC
    //controller to the navigation stack. You wouldnt want to push it if you are doing a call
    //to get the prices because you have to wait for pricefinder to return.
    func initializeItemVC(shouldPush: Bool) -> ItemViewController {
        let itemVC = ItemViewController()
        itemVC.itemN = self.curItem.itemN
        itemVC.barcodeNum = self.curItem.barcodeString
        itemVC.priceArray = self.curItem.priceArray
        itemVC.keywordString = self.curItem.keywordString
        itemVC.dismissalDelegate = self
        itemVC.urlDelegate = self
        
        if(shouldPush) {
            itemVC.createItems()
            self.pushViewController(itemVC, animated: true)
        }
        return itemVC
    }
}

//MARK: Extensions for Delegates

//Function for getting the barcode from the BarcodeScannerViewController
extension MainViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        update_products_scanned()

        NetworkManager.isReachable { networkManagerInstance in
           self.barcodeVC = controller
            
            controller.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopScanningAction(_:)))
            controller.navigationItem.leftBarButtonItems = nil
            
            self.getItemName(code, controller)
        }
        
        NetworkManager.isUnreachable { networkManagerInstance in
            self.alertNoInternet(controller)
        }
    }
}

//Function for if the BarcodeScannerViewController encounters an error scanning.
extension MainViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        DispatchQueue.main.async {
            controller.resetWithError(message: error.localizedDescription)
        }
    }
}

//Function for if the BarcodeScannerViewController dismisses itself
extension MainViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        DispatchQueue.main.async {
            self.popViewController(animated: true)
        }
    }
}

//Function for if the ItemViewController dismisses itself.
extension MainViewController: ItemViewDismissalDelegate {
    func itemViewDidDismiss(_ controller: ItemViewController, _ barcodeString: String, _ keywordString: [String]) {
        DispatchQueue.main.async {
            self.popViewController(animated: true)
            
            self.searchVC?.changeKeywordString(barcodeString, keywordString)
            
            //Either the BarcodeVC or the searchVC can send an item to the ItemVC, so
            //we have to check if the barcodeVC sent it and if so reset the barcodeVC
            if self.topViewController is BarcodeScannerViewController
            {
                self.resetBarcodeVC(self.topViewController as! BarcodeScannerViewController)
            }
        }
    }
}

//Function for handling when the barcodeVC presses the search button in the top right.
extension MainViewController: SearchRequestedDelegate {
    @objc func searchRequested(_ barcodeString: String, _ itemN: String, _ keywordString: [String], _ priceArray: [String]) {
        //gonna need to do something different here to just search by ID.
        curItem.barcodeString = barcodeString
        curItem.itemN = itemN
        curItem.keywordString = keywordString
        curItem.priceArray = priceArray
        
        fullItemFound(shouldPush: true)
    }
}

extension MainViewController: ItemViewURLDelegate {
    func showSafariVC(_ url: String) {
        DispatchQueue.main.async {
            update_url()
            guard let url = URL(string: url)else{
                return
            }
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.isNavigationBarHidden = true
            self.pushViewController(safariVC, animated: true)
        }
    }
}

extension MainViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // pop safari view controller and display navigation bar again
        DispatchQueue.main.async {
            self.popViewController(animated: true)
            self.isNavigationBarHidden = false
        }
    }
}
