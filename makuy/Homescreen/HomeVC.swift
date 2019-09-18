//
//  HomeVC.swift
//  makuy
//
//  Created by Eibiel Sardjanto on 18/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit
import Floaty

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floaty: Floaty!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        navBarSetup()
        floatySetup()
        tableViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = "Kembali"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navBarSetup()
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
        self.navigationItem.title = "Makuy"
        self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        return cell
    }
    
}
