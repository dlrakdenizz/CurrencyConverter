//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Dilara Akdeniz on 14.08.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRates(_ sender: Any) {
        
        //1) Request & Session  -> API'a istek atma kısmı
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=69b4446bda176a41b559bde11de7f628")
        
        let session = URLSession.shared
        
        //Closure
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                //2) Response & Data
                if data != nil {
                    
                    do{
                        // JSONSerialization JSON alıp objeleri tek tek oluşturabileceğimiz bir sınıftır.
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        //Verimiz string ve karşısında int, string hatta dict bile var. O yüzden dictionary olarak cast ettik.
                        
                        //ASYNC
                        //İnternetten veri çekme işleri ana threadde yapılmamalı. Eğer yapılırsa arayüz kitlenebilir o yüzden bu işlem asenkron olarak gerçekleşmelidir.
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD : \(cad)"
                                }
                                
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text = "CHF : \(chf)"
                                }
                                
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP : \(gbp)"
                                }
                                
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY : \(jpy)"
                                }
                                
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD : \(usd)"
                                }
                                
                                if let turkish = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY : \(turkish)"
                                }
                            }
                        }
                        
                        
                    }catch {
                        print("error")
                    }
                   
                    
                    
                }
            }
        }
        
        task.resume() //Task'in çalışabilmesi için bunun denmesi gerekiyor!
        //Bu kısımlar beraber verddiğimiz http url'ye erişmek için info plist kısmından App Transport Security Setting eklemeli ve bunun altından da Allow Arbitrary Loads'u YES olarak aktive etmeliyiz. Yoksa XCode http olan bir url'ye istek atmaz.
        
    }
    
}

