//
//  File.swift
//  testCircle
//
//  Created by Юрий Девятаев on 09.05.2022.
//

import Foundation

protocol DataManager {
    var users: [User] { get }
    
    func addUser(name: String)
    func deleteUser(user: User)
    func updateData()
    
    func getUser(id: Int) -> User?
    func addTask(name: String, user: User)
}

class DataManagerImp: DataManager {
    
    static let instanse: DataManager = DataManagerImp()
    private let coreDataManager = CoreDataManager.instanse
    
    var users = [User]()
    
    private init() {
        loadData()
    }
    
    private func saveData() {
        coreDataManager.saveContext()
        loadData()
    }
    
    private func loadData() {
        users = coreDataManager.loadContext()
    }
    
    // MARK: User
    
    func addUser(name: String) {
        let user = User(context: coreDataManager.context)
        user.name = name
        user.id = Int32(coreDataManager.loadContext().count)
        saveData()
    }
    
    func deleteUser(user: User) {
        coreDataManager.remove(user)
        saveData()
    }
    
    func updateData() {
        saveData()
    }
    
    func getUser(id: Int) -> User? {
        return coreDataManager.getUser(id: id)
    }
    
    // MARK: Task
    
    func addTask(name: String, user: User) {
        let task = Task(context: coreDataManager.context)
        task.name = name
        task.id = user.id
        task.user  = user
        saveData()
    }
}
