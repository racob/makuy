//
//  FormVC.swift
//  makuy
//
//  Created by Eibiel Sardjanto on 18/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import Eureka
import BiometricAuthentication

class FormVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarSetup()
        
        form +++ Section("Detail")
            <<< TextRow("restaurantName"){ row in
                row.title = "Restoran"
                row.placeholder = "Masukan nama restoran"
            }
            <<< TextRow("description"){
                $0.title = "Deskripsi"
                $0.placeholder = "Masukan deskripsi"
            }
            +++ Section(footer: "Nama restoran tidak akan ditampilkan kalau kamu memilih kategori Bawa Sendiri")
            <<< PickerInlineRow<Int>("numOfPeople") {
                $0.title = "Jumlah orang"
                $0.options = Array(1...99)
                $0.value = $0.options[0]
            }
            <<< SegmentedRow<String>("category"){
                $0.title = "Kategori"
                $0.options = ["Delivery","Restoran","Bawa sendiri"]
                $0.value = $0.options![0]
            }
            <<< DecimalRow("price") {
                $0.hidden = "$category != 'Delivery'"
                $0.useFormatterDuringInput = true
                $0.title = "Estimasi Harga"
                $0.value = 20000
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }
        }
        // Do any additional setup after loading the view.
    
    func navBarSetup() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Ajak Makan"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postTapped))
    }
    
    @objc func postTapped() {
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "") { (result) in
            switch result {
            case .success( _):
                print("Authentication Successful")
                self.navigationController!.popViewController(animated: true)
                self.postEvent()
            case .failure(let error):
                print("Authentication Failed")
            }
        }
    }
    
    func postEvent() {
        var valuesDictionary = form.values()
        if valuesDictionary["category"]!! as! String == "Bawa sendiri" {
            valuesDictionary["restaurantName"] = "Bawa makan sendiri"
        }
        let defaults = UserDefaults.standard
        var postArray = defaults.object(forKey:"SavedPostArray") as? [[String:Any?]] ?? []
        
        let hour = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let timePosted: String = String(format:"%02i:%02i", hour, minutes)
        valuesDictionary["timePosted"] = timePosted
        
        postArray.append(valuesDictionary)
        defaults.set(postArray, forKey: "SavedPostArray")
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = String(str[..<str.index(before: str.endIndex)])
                    
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
