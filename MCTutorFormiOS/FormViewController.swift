//
//  FormViewController.swift
//  MCTutorFormiOS
//
//  Created by Jay Early on 7/20/18.
//  Copyright © 2018 Dexterasoft Research. All rights reserved.
//

import UIKit
import Foundation

protocol FormViewProtocol {
    func getData(data: [String : String])
}

class FormViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    public let DEBUG_MODE = true
    
    //MARK: Properties
    @IBOutlet weak var studentIDTextField2: UITextField!
    @IBOutlet weak var studentFNameTextField: UITextField!
    @IBOutlet weak var studentLNameTextField: UITextField!
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var courseSectionTextField: UITextField!
    @IBOutlet weak var professorNameTextField: UITextField!
    //@IBOutlet var myRadioYesButton:DownStateButton?
    //@IBOutlet var myRadioNoButton:DownStateButton?
    @IBOutlet var label: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tutorNameTextField: UITextField!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var timeCalledTextField: UITextField!
    @IBOutlet weak var timeFinishedTextField: UITextField!
    
    @IBOutlet weak var btnCoursesDropDownToggle: UIButton!
    @IBOutlet weak var tbvCourses: UITableView!
    
    private var m_delegate: FormViewProtocol?

    private var m_queryResults: [KeyData] = []
    
    private var m_tutorData: String = ""
    
    var data: Data?
    
    let datePicker = UIDatePicker()
    
   /* let button = RadioButton(frame: CGRect(x: 20, y: 170, width: 50, height: 50))
    let label2 = UILabel(frame: CGRect(x: 90, y: 160, width: 200, height: 70))
    */
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func backButton(_ sender: UIButton) {
        // To pass back data:
        // Create dictionary containing any data (key-value pairs) to be sent back to the initial view controller
        
        // Pass back the data (invoke m_delegate?.getData(data: [String : String])
        
        // Go back to initial view controller
        dismiss(animated: true, completion: nil)
    }
    
    // Navigate to the SecondFormViewController
    @IBAction func next(_ sender: UIButton) {
        let secondFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondFormViewController") as! SecondFormViewController
        
        self.present(secondFormViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnCoursesDropDownToggle.setTitle(m_queryResults[0].course as String, for: .normal)
        
        // Initialy load data based on the first row in the query results
        loadFields(forQueryRow: 0)
        
        //Will restrict user interaction
        studentIDTextField2.isUserInteractionEnabled = false
        
        dateTextField.isUserInteractionEnabled = false
        dateTextField.text = convertDateFormatter()
        
      /*  button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        button.innerCircleCircleColor = UIColor.red
        self.view.addSubview(button)
        label2.text = "Not Selected"
        self.view.addSubview(label2)
        */
        
        btnCheckBox.setImage(UIImage(named:"CheckMarkEmpty"), for: .normal)
        btnCheckBox.setImage(UIImage(named:"CheckMark"), for: .selected)
        
        // Make sure the course text field cannot be edited so it can remain a silhouette
        courseNameTextField.isUserInteractionEnabled = false
        
        tutorNameTextField.text = m_tutorData
        tutorNameTextField.isUserInteractionEnabled = false
        
        //Will set current time that view loads
        timeCalledTextField.text = getCurrTime()
        timeCalledTextField.isUserInteractionEnabled = false
        
        showDatePicker()
        
    }
    
    func getCurrTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let str = formatter.string(from: Date())
        return str
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    /**
     Load all respective fields with query results data at a specified query row.
     
     @param forQueryRow the row in the query results list to extract data from
     */
    func loadFields(forQueryRow: Int) {
        // Use first row in query results as a start
        studentFNameTextField.text = m_queryResults[forQueryRow].stuFName as String
        studentLNameTextField.text = m_queryResults[forQueryRow].stuLName as String
        studentIDTextField2.text = m_queryResults[forQueryRow].stuID as String
        courseSectionTextField.text = m_queryResults[forQueryRow].section as String
        professorNameTextField.text = m_queryResults[forQueryRow].profName as String
        
        if DEBUG_MODE {
            print("Using query results from ViewController in FormViewController")
            
            // Display all results
            for result in self.m_queryResults {
                print("Student's First Name: \(result.stuFName) \tLast Name: \(result.stuLName)")
                print("MC# M\(result.stuID)")
                print("Course (E.g., ENGL101A): \(result.course) \tSection: \(result.section)")
                print("Professor (LAST NAME, First name): \(result.profName)")
                print("Campus: \(result.mcCampus)")
                print()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Toggle the drop-down view options when the course button is clicked
     The course button is designed to give the look and feel of a text box
     */
    @IBAction func changeCourse(_ sender: Any) {
        self.tbvCourses.isHidden = !self.tbvCourses.isHidden
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_queryResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course_cell", for: indexPath)
        cell.textLabel?.text = m_queryResults[indexPath.row].course as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // Load all data from query results with respect to the selected course
        btnCoursesDropDownToggle.setTitle(cell?.textLabel?.text, for: .normal)
        loadFields(forQueryRow: indexPath.row)
        
        self.tbvCourses.isHidden = true
    }
    
    /**
     Set the query results returned in the ViewController to the query results of the FormViewController
     
     @param queryResults the returned query results in the ViewController
     */
    public func setQueryResults(queryResults: [KeyData]) {
        self.m_queryResults = queryResults
    }
    
    public func setTutor(tutorName: String){
        m_tutorData = tutorName
    }
    
    public func setDelegate(delegate: FormViewProtocol) {
        m_delegate = delegate
    }
    
    //MARK:- checkMarkTapped
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
        
    }
    
   /* @objc func manualAction (sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            label2.text = "Selected"
        } else{
            label2.text = "Not Selected"
        }
    }
    */
    @IBAction func didPressButton(_ sender: RadioButton) {
        
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            label.text = "Selected"
        } else{
            label.text = "Not Selected"
        }
    }
    
    //MARK: Date Format (Foundations library)
    func convertDateFormatter() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy" // change format as per needs
        let result = formatter.string(from: date)
        return result
    }

func showDatePicker(){
    //let datePicker = UIDatePicker()
    //Formate Date
    datePicker.datePickerMode = .time
    
    //ToolBar
    let toolbar = UIToolbar();
    toolbar.sizeToFit()
    
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(FormViewController.donedatePicker))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(FormViewController.cancelDatePicker))
    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
    
    timeFinishedTextField.inputAccessoryView = toolbar
    timeFinishedTextField.inputView = datePicker
    
}

    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeFinishedTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

