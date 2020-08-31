//
//  HomeViewController.swift
//  immersio.ios
//
//  Created by Rohan Garg on 2020-08-13.
//  Copyright © 2020 Immersio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    let cellReuseIdentifier = "cell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.languageList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)!
       print(cell.textLabel?.text)
    [self.performSegue(withIdentifier: "goToChat", sender: self)]
    
   }
    

    @IBOutlet weak var languageList: UITableView!
    var items: [String] = ["Latin", "Ancient Greek"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellReuseIdentifier = "cell"

        self.languageList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
               
               // (optional) include this line if you want to remove the extra empty cell divider lines
               // self.tableView.tableFooterView = UIView()

               // This view controller itself will provide the delegate methods and row data for the table view.
       languageList.delegate = self
       languageList.dataSource = self
        // Do any additional setup after loading the view.
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
