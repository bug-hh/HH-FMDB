//
//  ViewController.swift
//  HH-FMDB
//
//  Created by 彭豪辉 on 2020/5/29.
//  Copyright © 2020 彭豪辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        demoInsert3(dict: ["name": "李四", "age": 18, "height": 1.8])
    }
    
    func demoInsert1() {
        // 准备 sql
        let sql = "INSERT INTO T_Person (name, age, height) VALUES('张三', 18, 1.8);"
        
        // 执行 sql
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            db.executeStatements(sql)
        }
    }
    
    func demoInsert2() {
        // 准备 sql
        let sql = "INSERT INTO T_Person (name, age, height) VALUES(?, ?, ?);"
        
        // 执行 sql
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            if db.executeUpdate(sql, withArgumentsIn: ["张三", 18, 1.9]) {
                print("执行成功，自增长 id 为： \(db.lastInsertRowId)")
            } else {
                print("插入失败")
            }
        }
        
    }
    
    func demoInsert3(dict: [String: Any]) {
        /*
         FMDB 特殊语法
         :key -> 与字典中的 key 相对应
         */
        let sql = "INSERT INTO T_Person (name, age, height) VALUES (:name, :age, :height);"
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            if db.executeUpdate(sql, withParameterDictionary: dict) {
                print("插入数据成功")
            } else {
                print("插入数据失败")
            }
        }
        
    }
    
    func demoUpdate(dict: [String: Any]) {
        // 准备 sql
        let sql = "UPDATE T_Person set name = :name, age = :age, height = :height \n" +
        "WHERE id = :id;"
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            if db.executeUpdate(sql, withParameterDictionary: dict) {
                print("更新数据成功")
            } else {
                print("更新数据失败")
            }
        }
    }

    func demoDelete(dict: [String: Any]) {
        // 准备 sql
        let sql = "DELETE FROM T_Person WHERE id = :id;"
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            if db.executeUpdate(sql, withParameterDictionary: dict){
                print("删除数据成功, 删除了 \(db.changes) 行")
            } else {
                print("删除数据失败")
            }
        }
    }
    
    // MARK: 数据查询
    func person1() {
        let sql = "select * from T_Person"
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            let rs = try! db.executeQuery(sql, values: nil)
            
            while rs.next() {
                let id = rs.int(forColumn: "id")
                let name = rs.string(forColumn: "name")
                let age = rs.int(forColumn: "age")
                let height = rs.double(forColumn: "height")
                
            }
        }
    }
    
    func person2() {
        let sql = "select * from T_Person"
        SQLiteManager.sharedManager.queue.inDatabase { (db) in
            let rs = try! db.executeQuery(sql, values: nil)
            
            while rs.next() {
                let cols = rs.columnCount
                var dict = [String: Any]()
                for col in 0..<cols {
                    let name = rs.columnName(for: col)
                    let obj = rs.object(forColumnIndex: col)
                    print("列数\(name) \(obj)")
                    dict[name!] = obj
                }
                
                
            }
        }
    }

}

