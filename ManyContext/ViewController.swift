//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    //管理オブジェクトコンテキスト
    var contextClub:NSManagedObjectContext!
    
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var studentTextField: UITextField!
    @IBOutlet weak var activityTextField: UITextField!
    

    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            //部活動登録用の管理オブジェクトコンテキストを取得する。
            let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            contextClub = applicationDelegate.managedObjectContext

            //Clubオブジェクトをフェッチしてラベルに設定する。
            let fetchRequest = NSFetchRequest(entityName: "Club")
            let clubList = try contextClub.executeFetchRequest(fetchRequest) as! [Club]
            for club in clubList {
              clubTextField.text = club.clubName
              teacherTextField.text = club.teacher
            }

            //Studentオブジェクトをフェッチしてラベルに設定する。
            let fetchStudent = NSFetchRequest(entityName: "Student")
            let studentList = try contextClub.executeFetchRequest(fetchStudent) as! [Student]
            for student in studentList {
                studentTextField.text = student.name
                activityTextField.text = student.activity
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

        do {
            //Clubオブジェクトを取得する。
            let fetchRequest = NSFetchRequest(entityName: "Club")
            fetchRequest.predicate = NSPredicate(format:"clubName = %@", clubTextField.text!)
            let clubList = try contextClub.executeFetchRequest(fetchRequest) as! [Club]

            //Clubオブジェクトが取得できた場合はそのオブジェクトを使い、取得できなかった場合は新規追加する。
            var club:Club
            if(clubList.count > 0) {
                club = clubList[0]
            } else {
                club = NSEntityDescription.insertNewObjectForEntityForName("Club", inManagedObjectContext: contextClub) as! Club
            }

            //属性値を変更する。
            club.clubName = clubTextField.text
            club.teacher = teacherTextField.text

            //Studentオブジェクトを取得する。
            let fetchStudent = NSFetchRequest(entityName: "Student")
            fetchStudent.predicate = NSPredicate(format:" name = %@", clubTextField.text!)
            let studentList = try contextClub.executeFetchRequest(fetchStudent) as! [Student]
            
            //Studentオブジェクトが取得できた場合はそのオブジェクトを使い、取得できなかった場合は新規追加する。
            var student:Student
            if(studentList.count > 0) {
                student = studentList[0]
            } else {
                student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: contextClub) as! Student
            }
            
            //属性値を変更する。
            student.name = studentTextField.text
            student.activity = activityTextField.text


        } catch {
            print(error)
        }
        return true
    }



    //部活動の登録ボタン押下時の呼び出しメソッド
    @IBAction func pushClubButton(sender: UIButton) {
        do {
            //管理オブジェクトコンテキストの中身を保存する。
            try contextClub.save()
            
        } catch {
            print(error)
        }
    }



    //生徒の登録ボタン押下時の呼び出しメソッド
    @IBAction func pushStudentButton(sender: UIButton) {
        do {
            //管理オブジェクトコンテキストの中身を保存する。
            try contextClub.save()

        } catch {
            print(error)
        }
    }
}

