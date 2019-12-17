
import CoreData
import UIKit

class SaveData {
    static func getSearchData() -> [SearchStruct] {
        var arr = [SearchStruct]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let searchStruct = SearchStruct(barcodeString: data.value(forKey: "barcodeString") as! String, itemN: data.value(forKey: "itemN") as! String, keywordString: data.value(forKey: "keywordString") as! [String], priceArray: data.value(forKey: "priceArray") as! [String])
                arr.append(searchStruct)
            }
        } catch {
            print("Failed getting data")
        }
        return arr
    }
    
    static func getChartsData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ChartStats")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                set_scanned(data.value(forKey: "productsScanned") as! Double)
                set_searched(data.value(forKey: "productsSearched") as! Double)
                set_added(data.value(forKey: "productsAdded") as! Double)
            }
        } catch {
            print("Failed getting data")
        }
    }
    
    static func saveSearchData(_ items: [SearchStruct]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Items", in: context)
        
        for item in items {
            let newItem = NSManagedObject(entity: entity!, insertInto: context)
            
            newItem.setValue(item.itemN, forKey: "itemN")
            newItem.setValue(item.barcodeString, forKey: "barcodeString")
            newItem.setValue(item.priceArray, forKey: "priceArray")
            newItem.setValue(item.keywordString, forKey: "keywordString")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func saveChartsData(productsSearched: Double, productsScanned: Double, productsAdded: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ChartStats", in: context)
        
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        
        newItem.setValue(productsSearched, forKey: "productsSearched")
        newItem.setValue(productsScanned, forKey: "productsScanned")
        newItem.setValue(productsAdded, forKey: "productsAdded")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func deleteSearchData(_ barcodeString: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Items")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if(data.value(forKey: "barcodeString") as! String == barcodeString) {
                    context.delete(data)
                }
            }
        }catch {
            print("Delete data failed")
        }
    }
    
    static func deleteAllData(_ entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        let context = appDelegate.persistentContainer.viewContext
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
}
