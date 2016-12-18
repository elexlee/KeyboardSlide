//
//  ViewController.swift
//  KeyboardSlide
//
//  Created by Elex Lee on 12/18/16.
//  Copyright © 2016 Elex Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var textField: UITextField?
    
    
    private enum CellType: String
    {
        case Info = "info"
    }
    
    private enum SectionType: Int
    {
        case Info = 0
    }
    
    var infoArray: [String]? = ["Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Black", "Red", "Blue", "Green"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let section = SectionType.init(rawValue: section)
        {
            switch section
            {
            case .Info:
                guard let count = infoArray?.count else { return 0 }
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = SectionType.init(rawValue: section)
        {
            switch section
            {
            case .Info:
                let view = UINib(nibName: "UserInputHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UserInputHeader
                self.textField = view?.textField
                view?.button.addTarget(self, action: #selector(self.buttonClick(sender:)), for: .touchUpInside)
                view?.backgroundColor = UIColor.black
                return view!
            }
        }
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let section = SectionType.init(rawValue: section)
        {
            switch section
            {
            case .Info:
                return 250
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let section = SectionType.init(rawValue: indexPath.section)
        {
            switch section
            {
                case .Info:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Info.rawValue) as? InfoCell
                cell?.textField.text = infoArray?[indexPath.row]
                cell?.backgroundColor = UIColor.red
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = SectionType.init(rawValue: indexPath.section)
        {
            switch section
            {
            case .Info:
                return 44
            }
        }
        return 0

    }
    
    func buttonClick(sender: UIButton)
    {
        guard
            let field = textField,
            let text = field.text
        else
        {
            return
        }
        
        infoArray?.append(text)
        field.text = ""
        tableView.reloadData()
        scrollToBottomOfTableView()
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.bottomConstraint.constant += keyboardSize.height
            }, completion: {
                (finished: Bool) -> Void in
                self.scrollToBottomOfTableView()
            })

        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                () -> Void in
                self.bottomConstraint.constant -= keyboardSize.height
            }, completion: {
                (finished: Bool) -> Void in
                self.scrollToBottomOfTableView()
            })
        }
    }
    
    func scrollToBottomOfTableView()
    {
        let indexPath = NSIndexPath(row: self.infoArray!.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

