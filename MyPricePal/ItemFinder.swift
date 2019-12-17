

import BarcodeScanner
import FirebaseDatabase


class ItemFinder {
    
    public weak var mainViewController: MainViewController?
    
    func getItemName(_ barcodeString: String){
        
        let ref = Database.database().reference().child("Barcodes")
        
        DispatchQueue.main.async {
            
            ref.child(barcodeString).observeSingleEvent(of: .value, with: {(snapShot) in
                if let val = snapShot.value as? String{
                    
                    self.mainViewController?.itemFound(barcodeString: barcodeString, itemN: val)
                    
                }else{
                    let urlBase = "https://api.upcitemdb.com/prod/trial/lookup?upc=" //barcodeString and urlBase combine to create the url
                    let url = URL(string: urlBase + barcodeString)!
                    let task = URLSession.shared.dataTask(with: url){(data, resp, error) in //Creates the url connection to the API
                        guard let data = data else{
                            print("data was nil")
                            return
                        }
                        guard let htmlString = String(data: data, encoding: String.Encoding.utf8)else{//Saves the html with the JSON into a string
                            print("cannot cast data into string")
                            return
                            
                        }
                        let leftSideOfTheValue = """
                title":"
                """
                        //Left side before the desired value in the JSON portion of the HTML
                        let rightSideOfTheValue = """
                ","description
                """
                        //right side after the desired value in the JSON portion of the HTML
                        guard let leftRange = htmlString.range(of: leftSideOfTheValue)else{
                            self.mainViewController?.alertCantFindItem(barcodeString)
                            print("cannot find left range")
                            return
                        }//Creates left side range
                        guard let rightRange = htmlString.range(of: rightSideOfTheValue)else{
                            print("cannot find right range")
                            return
                        }//Creates right side range
                        let rangeOfTheValue = leftRange.upperBound..<rightRange.lowerBound //Appends the ranges together
                        //   self.showAlertButtonTapped(String(htmlString[rangeOfTheValue]), barcodeString,barcodeVC) //Displays the product name
                        
                        self.mainViewController?.itemFound(barcodeString: barcodeString, itemN: String(htmlString[rangeOfTheValue]))
                       
                        
                        let ref2 = Database.database().reference()
                        ref2.child("Barcodes").child(barcodeString).setValue(String(htmlString[rangeOfTheValue]))
                    }
                    
                    task.resume()
                }
            })
        }
    }
}
