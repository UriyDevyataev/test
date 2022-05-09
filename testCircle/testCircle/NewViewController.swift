//
//  NewViewController.swift
//  testCircle
//
//  Created by Юрий Девятаев on 09.05.2022.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var inputText: UITextField!
    let dataManager = DataManagerImp.instanse
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionShow(_ sender: UIButton) {
        let users = dataManager.users
        print("users.count - \(users.count)")
        print("---------")
        users.forEach { user in
            print("id - \(user.id)")
            print("name - \(user.name ?? "qqqq")")
            print("task count - \(user.task?.count ?? 999)")
            if let array = user.task as? Set<Task> {
                array.forEach{ task in
                    print("id - \(task.id)")
                    print("name - \(task.name ?? "qqqq")")
                    print("user?.name - \(task.user?.name ?? "qqqq")")
                    print("///////")
                }
            }
            print("__________________")
        }
        
//        let user = getUser(id: Int(inputText.text!)!)
//        print(user?.name ?? "qqqq")
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
//        createUser(name: inputText.text!)
//        createTask(id: Int(inputText.text!)!)
//        changeNameUser(id: Int(inputText.text!)!)
        changeTaskName(id: Int(inputText.text!)!)
    }
    
    func createUser(name: String) {
        dataManager.addUser(name: name)
    }
    
    func createTask(id: Int) {
        let name = "task \(Int.random(in: 1..<100))"
        let user = dataManager.users[id - 1]
        dataManager.addTask(name: name, user: user)
    }
    
    func getUser(id: Int) -> User? {
        return dataManager.getUser(id: id)
    }
    
    func changeNameUser(id: Int) {
        let user = dataManager.users[id]
        user.name = "other name"
        dataManager.updateData()
    }
    
    func changeTaskName(id: Int) {
        
        let user = dataManager.users[id]
        
    
        var arrayTask = [Task]()
        guard let tasksSet = user.task as? Set<Task>
        else {return}
        
        tasksSet.forEach{ task in
            arrayTask.append(task)
        }
        
        let task = arrayTask[0]
        task.user = dataManager.users[1]
        dataManager.updateData()
    }
}
