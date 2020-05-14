//
//  LogViewController.swift
//  LogStore Package
//
//  Created by Monty Boyer on 5/4/20.
//

import UIKit

public class LogViewController: UITableViewController {
    
    // assign the log array in the LogStore type to this property of the table view controller
    let logItems = Array(LogStore.log.reversed())       // most recent items at beginning of the log
    
    // conversion for the log entry time to a string
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_UK")
        return dateFormatter
    }()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a table view cell with an identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // remove the separator between cells
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table View Data Source
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logItems.count      // note this is an implicit return value
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a cell from the reusable pool
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // create the cell text from the date string and the log text
        let logEntry = logItems[indexPath.row]
        let cellText = "\(dateFormatter.string(from: logEntry.entryTime)) \(logEntry.entryText)"
                
        cell.textLabel?.text = cellText
        cell.textLabel?.numberOfLines = 0       // enable text wrapping for long log entries
        return cell
    }

}
