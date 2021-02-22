//
//  StudentTableViewController.swift
//  lab
//
//  Created by Ilya Androsav on 2/21/21.
//

import UIKit
import Firebase


class Student {
    var firstName : String
    var lastName : String
    var secondName : String
    var imageUrl : String
    var birthday : Date
    
    init(firstName:String, lastName:String, secondName:String, imageUrl:String, birthday:Date) {
        self.birthday = birthday
        self.firstName = firstName
        self.secondName = secondName
        self.lastName = lastName
        self.imageUrl = imageUrl
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class StudentTableViewController: UITableViewController {
    //MARK: Properties
    
    var students = [Student]()
    
    //MARK: Private Methods
    
    private func loadStudents() {
        groupMates.getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let a = document.get("images")
                    var b: [String] = []
                    if (a != nil) {
                         b = a as! [String]
                    }
                    
                    let student = Student(firstName: document.get("firstName") as! String, lastName: document.get("lastName") as! String, secondName: document.get("secondName") as! String, imageUrl: b.isEmpty ? "" : b[0], birthday: Date())
                    self.students += [student]
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadStudents()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as? StudentTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        let student = students[indexPath.row]
        
        cell.nameLabel.text = student.firstName + " " + student.lastName + " " + student.secondName
        if let url = URL(string: student.imageUrl) {
            print(url)
            cell.imageView?.load(url: url)
//            self.tableView.reloadData()
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}