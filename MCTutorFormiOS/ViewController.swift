//
//  ViewController.swift
//  MCTutorFormiOS
//
//  Created by Jay Early on 6/28/18.
//  Copyright © 2018 Dexterasoft Research. All rights reserved.
//

import UIKit
import Foundation

//Global variables for testing and passing to other ViewControllers
var studentID = ""
var stuFName = ""
var stuLName = ""

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // Key values for dictionary
    let STUDENT_ID = "student_id"
    let COURSE = "course"
    let TUTOR_ID = "tutor_id"
    let TUTOR_NAME = "tutor_name"
    let STUDENT_NAME = "student_name"
    
    //MARK: Properties
    @IBOutlet weak var tutorNameTextField: UITextField!
    @IBOutlet weak var tutorNameLabel: UILabel!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var studentIDTextField: UITextField!
    
    
    /*@IBAction func submitButtonAction(_ sender: UIButton) {
        if (studentIDTextField.text != nil){
            studentID = studentIDTextField.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
    }*/
    
    /*@IBAction func confirmStudentID(_ sender: Any) {
        if (studentIDTextField.text != nil){
            studentID = studentIDTextField.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
    }*/
    
    //Should read in from text file 
    let tutors = ["", "John Smith", "Mary Washington", "Benjamin Early"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tutorPickerView = UIPickerView()
        tutorPickerView.delegate = self
    
        //let fileName = "vBanner1"
        //let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        //let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        tutorNameTextField.inputView = tutorPickerView
        
        //This will allow user to click and interact with dropdown
        tutorNameTextField.isUserInteractionEnabled = true
        
        //note: will need to revisit this later
        tutorNameTextField.allowsEditingTextAttributes = false
        
        //DATE FIELD
        //To set the current date
        dateField.text = convertDateFormatter()
        
        //to restrict user input
        dateField.isUserInteractionEnabled = false
        
        //Continue working: numberpad input
        self.studentIDTextField.delegate = self
        studentIDTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
        studentIDTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        //stuIDTextField2(studentIDTextField) = grabStudentID()
       /* var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed")
            print(error)
        }
        print("Contents in file include \(readString)")
        */
        
        //To read in from file
        if let path = Bundle.main.path(forResource: "vBanner1", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
//                let rows = data.components(separatedBy: .newlines)
//                var result: [[String]] = []
//                //let columns = data.components(separatedBy: ",")
//                //studentIDTextField.text = rows.joined(separator: ", ")
//                
//                for row in rows {
//                    let columuns = row.components(separatedBy: ",")
//                    var tokens = row.split(separator: ",")
//                    
//                    if tokens.count > 0 {
//                        
//                        if tokens.count == 6{
//                            print(tokens)
//                        }
//                        
//                        let studentFName = tokens[5].replacingOccurrences(of: "\"", with: "")
//                        let studnetLName = tokens[6].replacingOccurrences(of: "\"", with: "")
//                        
//                        print("\(STUDENT_ID): \(tokens[0])")
//                        print("\(COURSE): \(tokens[1])")
//                        print("\(TUTOR_ID): \(tokens[2])")
//                        print("\(TUTOR_NAME): \(tokens[3]) \(tokens[4])")
//                        print("\(STUDENT_NAME): \(studentFName) \(studnetLName)")
//                        print()
//                    }
//                    
//                    result.append(columuns)
//                }
//                //print(rows[0])
//                print(result[8][4])
//                print(result[8][3])
//               // print(columns[2])
            } catch {
                print(error)
            }
        }

        //print(getDocumentsDirectory())
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func numberOfComponents(in tutorPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tutors.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tutors[row]
        
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tutorNameTextField.text = tutors[row]
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //To hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Date Format (Foundations library)
    func convertDateFormatter() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy" // change format as per needs
        let result = formatter.string(from: date)
        return result
    }
    
    //MARK: Actions
    @IBAction func submitAction(_ sender: Any) {
        if (studentIDTextField.text != nil){
            studentID = studentIDTextField.text!
            performSegue(withIdentifier: "segue", sender: self)
        }
        
    }
    
    
    //MARK: Data import
    func readData(file:String) ->String! {
        if let path = Bundle.main.path(forResource: "vBanner1", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let rows = data.components(separatedBy: .newlines)
                var result: [[String]] = []
                //let columns = data.components(separatedBy: ",")
                //studentIDTextField.text = rows.joined(separator: ", ")
                
                for row in rows {
                    let columuns = row.components(separatedBy: ",")
                    result.append(columuns)
                }
                //print(rows[0])
                print(result[8][4])
                print(result[8][3])
                return result[9][0]
                
                // print(columns[2])
            } catch {
                print(error)
            }
            
        }
        return nil
    }
    
    //Read from file
    


}

