//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    //管理オブジェクトコンテキスト
    var contextClub:NSManagedObjectContext!
    var contextStudent:NSManagedObjectContext!
    
    //テキストフィールド
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var studentTextField: UITextField!
    @IBOutlet weak var activityTextField: UITextField!
    
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            //部活動用と生徒用の管理オブジェクトコンテキストを取得する。
            let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            contextClub = applicationDelegate.contextClub
            contextStudent = applicationDelegate.contextStudent
            
            
            //Studentオブジェクトをフェッチしてラベルに設定する。
            let fetchStudent = NSFetchRequest(entityName: "Student")
            let studentList = try contextStudent.executeFetchRequest(fetchStudent) as! [Student]
            for student in studentList {
                studentTextField.text = student.name
                if (student.club != nil) {
                    activityTextField.text = student.club!.clubName
                    clubTextField.text = student.club!.clubName
                    teacherTextField.text = student.club!.teacher
                }
            }
            
            //デリゲート先に自分を設定する。
            clubTextField.delegate = self
            teacherTextField.delegate = self
            studentTextField.delegate = self
            activityTextField.delegate = self
            
        } catch {
            print(error)
        }
    }
    
    
    
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //キーボードをしまう。
        clubTextField.endEditing(true)
        teacherTextField.endEditing(true)
        studentTextField.endEditing(true)
        activityTextField.endEditing(true)
        
        return true
    }
    
    
    
    //生徒の追加ボタン押下時の呼び出しメソッド
    @IBAction func pushAddStudent(sender: UIButton) {
        do {
        
            //生徒用オブジェクトをフェッチする。
            let fetchStudent = NSFetchRequest(entityName: "Student")
            fetchStudent.predicate = NSPredicate(format:"name = %@", studentTextField.text!)
            let studentList = try contextStudent.executeFetchRequest(fetchStudent) as! [Student]
            
            let student:Student
            if(studentList.count == 0) {
                //フェッチできなかった場合は生徒用の管理オブジェクトコンテキストに新規追加する。
                student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: contextStudent) as! Student
            } else {
                //フェッチできた場合はそのオブジェクトを編集する。
                student = studentList[0]
            }
            
            //生徒オブジェクトの属性値を変更する。
            student.name = studentTextField.text!

            //部活オブジェクトを生徒用の管理オブジェクトコンテキストにフェッチする。
            let fetchRequest = NSFetchRequest(entityName: "Club")
            fetchRequest.predicate = NSPredicate(format:"clubName = %@", activityTextField.text!)
            let clubList = try contextStudent.executeFetchRequest(fetchRequest) as! [Club]


            if(clubList.count == 0) {
                //フェッチできなかった場合、部活オブジェクトを作ってリレーションシップに設定する。
                let club = NSEntityDescription.insertNewObjectForEntityForName("Club", inManagedObjectContext: contextStudent) as! Club
                club.clubName = "所属無し"
                club.teacher = "所属無し"
                student.club = club

            } else {
                //部活オブジェクトがフェッチできた場合、リレーションシップに設定する。
                student.club = clubList[0]
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    //生徒の保存ボタン押下時の呼び出しメソッド
    @IBAction func pushStudentButton(sender: UIButton) {
        do {
            //管理オブジェクトコンテキストの中身を保存する。
            try contextStudent.save()

        } catch {
            print(error)

        }
    }
    
    
    
    //部活動の追加ボタン押下時の呼び出しメソッド
    @IBAction func pushAddClub(sender: UIButton) {
        do {
            //部活オブジェクトをフェッチする。
            let fetchClub = NSFetchRequest(entityName: "Club")
            fetchClub.predicate = NSPredicate(format:"clubName = %@", clubTextField.text!)
            let studentList = try contextClub.executeFetchRequest(fetchClub) as! [Club]
            
            let club:Club
            if(studentList.count == 0) {
                //フェッチできなかった場合は部活用の管理オブジェクトコンテキストに新規追加する。
                club = NSEntityDescription.insertNewObjectForEntityForName("Club", inManagedObjectContext: contextClub) as! Club
            } else {
                //フェッチできた場合はそのオブジェクトを編集する。
                club = studentList[0]
            }
            
            //属性値を変更する。
            club.clubName = clubTextField.text
            club.teacher = teacherTextField.text

        } catch {
            print(error)
        }
    }
    
    
    
    //部活動の保存ボタン押下時の呼び出しメソッド
    @IBAction func pushClubButton(sender: UIButton) {
        do {
            //管理オブジェクトコンテキストの中身を保存する。
            try contextClub.save()
            
        } catch {
            print(error)
        }
    }
    
    
    
    //生徒一覧表示メソッド
    @IBAction func displayStudent(sender: UIButton) {
        //生徒オブジェクトをフェッチする。
        let fetchRequest2 = NSFetchRequest(entityName: "Student")
        let studentList = try! contextStudent.executeFetchRequest(fetchRequest2) as! [Student]
        print("生徒総数 \(studentList.count)")
        for aaa in studentList {
            print("=====================")
            print("名前　\(aaa.name!)")
            if let clubData = aaa.club {
                print("所属部　\(clubData.clubName!)")
                print("顧問　\(clubData.teacher!)")
            } else {
                print("所属部無し")
            }
        }
        print("\n\n")
    }

    

    //部活一覧表示メソッド
    @IBAction func displayClub(sender: UIButton) {
        //部活オブジェクトをフェッチする。
        let fetchRequest = NSFetchRequest(entityName: "Club")
        let clubList = try! contextClub.executeFetchRequest(fetchRequest) as! [Club]
        print("部活総数　\(clubList.count)")
        for data in clubList {
            print("=====================")
            print("部活名 \(data.clubName!)")
            print("顧問 \(data.teacher!)")
        }
        print("\n\n")
    }

}
