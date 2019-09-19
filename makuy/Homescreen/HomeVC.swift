//
//  HomeVC.swift
//  makuy
//
//  Created by Eibiel Sardjanto on 18/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import Floaty
import OnboardKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floaty: Floaty!
    @IBOutlet var emptyLabels: [UILabel]!
    
    var postArray: [[String : Any?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        floatySetup()
        tableViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Kembali"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        onboardDisplay()
        navBarSetup()
        postArray = UserDefaults.standard.object(forKey:"SavedPostArray") as? [[String:Any?]] ?? []
        postArray = postArray.reversed()
        emptyLabelDisplay()
        tableView.reloadData()
    }
    
    func emptyLabelDisplay() {
        if postArray.count == 0 {
            for emptyLabel in emptyLabels {
                emptyLabel.layer.isHidden = false
            }
        } else {
            for emptyLabel in emptyLabels {
                emptyLabel.layer.isHidden = true
            }
        }
    }
    
    func onboardDisplay() {
        
        if !UserDefaults.standard.bool(forKey: "afterFirstUse") {
            let onboardingPages: [OnboardPage] = {
                let pageOne = OnboardPage(title: "Hi learner!",
                                          imageName: "onboard1",
                                          description: "Kamu mau makan bareng ya?\nKenalan dulu dong!",
                                          advanceButtonTitle: "",
                                          actionButtonTitle: "Masukan Nama",
                                          action: { [weak self] completion in
                                            self?.showAlert(completion)
                })
                
                let pageTwo = OnboardPage(title: "Ajak makan atau join?",
                                          imageName: "onboard2",
                                          description: "Kamu bisa ajak learner lain makan bareng, atau join sama yang sedang cari temen makan!",
                                          advanceButtonTitle: "Mulai")
                
                return [pageOne, pageTwo]
            }()
            
            let onboardingVC = OnboardViewController(pageItems: onboardingPages)
            onboardingVC.presentFrom(self, animated: true)
            
            UserDefaults.standard.set(true, forKey: "afterFirstUse")
        }
//        UserDefaults.standard.set(false, forKey: "afterFirstUse")
    }
    
    private func showAlert(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let alert = UIAlertController(title: "Kenalan yuk!",
                                      message: "Masukan nama kamu",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Misalnya Eibiel"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let name = alert.textFields?.first?.text
            UserDefaults.standard.set(name, forKey: "username")
            completion(true, nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false, nil)
        })
        presentedViewController?.present(alert, animated: true)
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    func floatySetup() {
        floaty.friendlyTap = true
        floaty.handleFirstItemDirectly = true
        floaty.addItem(title: "Ajak makan", handler: { item in
            self.performSegue(withIdentifier: "FormMakanBareng", sender: nil)
        })
    }
    
    func navBarSetup() {
        let name = UserDefaults.standard.string(forKey: "username")
        self.navigationItem.title = "Hi \(name ?? "Learner"), makan kuy!"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2374646366, green: 0.3458372951, blue: 0.4776223898, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.995991528, green: 0.9961341023, blue: 0.9959602952, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.2374646366, green: 0.3458372951, blue: 0.4776223898, alpha: 1)]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.2374646366, green: 0.3458372951, blue: 0.4776223898, alpha: 1)]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        let postDict = postArray[indexPath.row]
        let num = postDict["numOfPeople"]! as? Int
        let desc = postDict["description"] as? String
        let category = postDict["category"] as? String
        let price = postDict["price"] as? Int
        
        cell.restaurantName.text = postDict["restaurantName"] as? String
        cell.postDescription.text = "▶︎ \(desc!)"
        cell.category.text = "\(category!)  "
        cell.numOfPeople.text = "☺︎ 0 / \(num!)"
        cell.timePosted.text = postDict["timePosted"] as? String
        cell.host.text = "By Eibiel  "
        
        if category! == "Delivery" {
            cell.price.text = "Rp \(price!)"
        } else {
            cell.price.isHidden = true
        }
        
        cell.categoryImage.image = UIImage(named: category!)
        cell.categoryImage.alpha = 0.25
        return cell
    }
    
}
