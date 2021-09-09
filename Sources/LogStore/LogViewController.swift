//
//  LogViewController.swift
//  LogStore Package
//
//  Created by Monty Boyer on 5/4/20.
//  Extended by Ned Hogan on 8/2/20 for the ability to email the log
//


import UIKit
import MessageUI

public class LogViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // assign the log array in the LogStore type to this property of the table view controller
    let logItems = Array(LogStore.log.reversed())       // most recent items at beginning of the log
    
    // conversion for the log entry time to a string
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_UK")  // "dd/mm/yyyy"
        return dateFormatter
    }()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a table view cell with an identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LogEntryCell")
        
        // remove the separator between cells
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table View Data Source
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logItems.count      // note this is an implicit return value
    }
    
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a cell from the reusable pool
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogEntryCell", for: indexPath)

        // create the cell text from the date string and the log text
        let logEntry = logItems[indexPath.row]
        let cellText = "\(dateFormatter.string(from: logEntry.entryTime)) \(logEntry.entryText)"
                
        cell.textLabel?.text = cellText
        cell.textLabel?.numberOfLines = 0       // enable text wrapping for long log entries
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
      // setup the footer view to include the Email Log & Clear Log buttons
        let footerView = UIView()
        footerView.backgroundColor = UIColor.red
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        
        // setup the Email button
        let emailButton = UIButton()
        emailButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50)
        emailButton.setTitle("Email Log", for: .normal)
        emailButton.setTitleColor( UIColor.green, for: .normal)
        emailButton.backgroundColor = UIColor.black
        emailButton.addTarget(self, action: #selector(sendLog), for: .touchUpInside)

        // setup the Clear button
        let clearButton = UIButton()
        clearButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50)
        clearButton.setTitle("Clear Log", for: .normal)
        clearButton.setTitleColor( UIColor.green, for: .normal)
        clearButton.backgroundColor = UIColor.black
        clearButton.addTarget(self, action: #selector(clearLog), for: .touchUpInside)
     
        // place the buttons in a horizontal stack
        let buttonStackView = UIStackView(arrangedSubviews: [clearButton, emailButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        buttonStackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        // add the button stack to the footer
        footerView.addSubview(buttonStackView)
            
        // center the stack in the footer
        footerView.addConstraint(NSLayoutConstraint(item: buttonStackView, attribute: .centerX, relatedBy: .equal, toItem: footerView, attribute: .centerX, multiplier: 1, constant: 0))
        footerView.addConstraint(NSLayoutConstraint(item: buttonStackView, attribute: .centerY, relatedBy: .equal, toItem: footerView, attribute: .centerY, multiplier: 1, constant: 0))
           
        return footerView
    }
    
    @objc func sendLog(sender: UIButton!) {
        // print("Email log button tapped")
        sendEmail()
    }
    
   @objc func clearLog(sender: UIButton!) {
       // print("Clear Log button tapped")
      
       // clear the log data & file
       LogStore.clearLog()
      
       // load the table with the cleared log
       tableView.reloadData()
      
       // dismiss this view
       self.dismiss(animated: true, completion: nil)
    }
   
    func sendEmail() {
        // ensure we can send an email
        if MFMailComposeViewController.canSendMail() {
            
            // setup for the mail view
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
         mailVC.setSubject("LogStore Log")
         mailVC.setMessageBody("<p>Here is your debug log from \(LogStore.appName)</p>", isHTML: true)
            
            // add log data as an attachment
            if let data = try? Data(contentsOf: FileManager.logFileURL) {
               mailVC.addAttachmentData(data as Data, mimeType: "application/json" , fileName: "LogStore log.json")
            }
            
            // display the email dialog
            present(mailVC, animated: true)
            
        } else {
            print("Email Compose Failed")
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        // mail view done, dismiss it
        controller.dismiss(animated: true)
        
        guard let error = error else {
            return
        }
        printLog("Error from Mail view: \(error.localizedDescription)")
    }
    
}
