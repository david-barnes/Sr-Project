//
//  ViewController.swift
//  LogBook
//
//  Created by David Barnes on 11/26/17.
//  Copyright © 2017 David Barnes. All rights reserved.
//

import Cocoa
import SQLite

class ViewController: NSViewController {

    let DispatchName = Expression<String>("DispatchName")
    let DriverName = Expression<String>("DriverName")
    let MileID = Expression<Int64>("MileID")
    let Miles = Expression<Double>("Miles")
    let DeadHead = Expression<Double>("DeadHead")
    let TotalMiles = Expression<Double>("TotalMiles")
    let Standby = Expression<Double>("Standby")
    let JobID = Expression<Int64>("JobID")
    let JobNum = Expression<String>("JobNum")
    let NoteID = Expression<Int64>("NoteID")
    let Notes = Expression<String>("Notes")
    let PaidID = Expression<Int64>("PaidID")
    let BeenPaid = Expression<String>("BeenPaid")
    let MileRate = Expression<Double>("MileRate")
    let StandbyRate = Expression<Double>("StandbyRate")
    let DeadHeadRate = Expression<Double>("DeadHeadRate")
    let TotalOwed = Expression<Double>("TotalOwed")
    let CheckAmount = Expression<Double>("CheckAmount")
    let RouteID = Expression<Int64>("RouteID")
    let Start = Expression<String>("Start")
    let End = Expression<String>("End")
    let TruckCoName = Expression<String>("TruckCoName")
    let TruckID = Expression<String>("TruckID")
    let DateFrom = Expression<String>("DateFrom")
    let DateTo = Expression<String>("DateTo")
    
    let Dispatch = Table("Dispatch")
    let Driver = Table("Driver")
    let Mileage = Table("Mileage")
    let Notations = Table("Notations")
    let Paid = Table("Paid")
    let Route = Table("Route")
    let TruckCo = Table("TruckCo")
    let Job = Table("Job")
    
    @IBOutlet var JobIDField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var SetYearField: NSTextField!
    var tableViewData = [Dictionary<String,String>]()
    var year = ""
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .applicationSupportDirectory, .userDomainMask, true
        ).first! + "/" + Bundle.main.bundleIdentifier!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        getCurrentDate()
    }
    
    func getCurrentDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        year = formatter.string(from: Date())
    }
    
    @IBAction func showAllButtonClicked(_ sender: Any) {
        if SetYearField.stringValue != "" {year = SetYearField.stringValue}
        do {
            year += "%"
            
            let db = try Connection("\(path)/LogData.db")
            
            let query = Job.join(Mileage, on: Job[JobID] == Mileage[MileID])
                .join(Paid, on: Job[JobID] == Paid[PaidID])
                .join(Route, on: Job[JobID] == Route[RouteID])
                .join(Notations, on:Job[JobID] == Notations[NoteID])
                .filter(DateFrom.like(year))
            
            var dbData = [Dictionary<String,String>]()
            
            for job in try db.prepare(query) {
                dbData.append(["JobID" : "\(job[JobID])", "BeenPaid" : "\(job[BeenPaid])", "Job#" : "\(job[JobNum])", "Dispatcher" : "\(job[DispatchName])", "DateFrom" : "\(job[DateFrom].toDateString(inputDateFormat: "yyyy-MM-dd", outputDateFormat: "MMMM/d/yyyy"))", "DateTo" : "\(job[DateTo].toDateString(inputDateFormat: "yyyy-MM-dd", outputDateFormat: "MMMM/d/yyyy"))", "TruckCo" : "\(job[TruckCoName])" , "TruckID" : "\(job[TruckID])", "Driver" : "\(job[DriverName])", "Start" : "\(job[Start])", "End" : "\(job[End])", "Miles" : "\(job[Miles])", "TotalMiles" : "\(job[TotalMiles])", "TotalOwed" : "\(job[TotalOwed])", "CheckAmount" : "\(job[CheckAmount])", "Notes" : "\(job[Notes])"])
            }
            
            tableViewData = dbData
            
            self.tableView.reloadData()
            
        } catch {
            print("\(error)")
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier!.rawValue == "updateView" {
            
            let updateJobViewController = segue.destinationController as! UpdateViewController
            
            updateJobViewController.jobNumber = Int64(JobIDField.stringValue)!
            
            do {
                let db = try Connection("\(path)/LogData.db")
                
                let query = Job.join(Mileage, on: Job[JobID] == Mileage[MileID])
                    .join(Paid, on: Job[JobID] == Paid[PaidID])
                    .join(Route, on: Job[JobID] == Route[RouteID])
                    .join(Notations, on:Job[JobID] == Notations[NoteID])
                    .filter(Job[JobID] == Int64(JobIDField.stringValue)!)
                
                for job in try db.prepare(query) {
                    
                    updateJobViewController.beenPaid = "\(job[BeenPaid])"
                    updateJobViewController.checkAmount = "\(job[CheckAmount])"
                    updateJobViewController.jobNum = "\(job[JobNum])"
                    updateJobViewController.dispatcherName = "\(job[DispatchName])"
                    updateJobViewController.dateFrom = "\(job[DateFrom].toDateString(inputDateFormat: "yyyy-MM-dd", outputDateFormat: "MMMM/d/yyyy"))"
                    updateJobViewController.dateTo = "\(job[DateTo].toDateString(inputDateFormat: "yyyy-MM-dd", outputDateFormat: "MMMM/d/yyyy"))"
                    updateJobViewController.truckCo = "\(job[TruckCoName])"
                    updateJobViewController.truckNum = "\(job[TruckID])"
                    updateJobViewController.driverName = "\(job[DriverName])"
                    updateJobViewController.startingLocation = "\(job[Start])"
                    updateJobViewController.endingLocation = "\(job[End])"
                    updateJobViewController.rate = "\(job[MileRate])"
                    updateJobViewController.miles = "\(job[Miles])"
                    updateJobViewController.deadHeadRate = "\(job[DeadHeadRate])"
                    updateJobViewController.deadHeadMiles = "\(job[DeadHead])"
                    updateJobViewController.standbyRate = "\(job[StandbyRate])"
                    updateJobViewController.hours = "\(job[Standby])"
                    updateJobViewController.notes = "\(job[Notes])"
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    @IBAction func updateJobButtonClicked(_ sender: Any) {
  
        
    }
    
    @IBAction func addJobButtonClicked(_ sender: Any) {
        
    }

    @IBAction func createReportButtonClicked(_ sender: Any) {
        
        let fileName = "Summary Report " + SetYearField.stringValue + ".csv"
        //let fileManager = FileManager.default
        if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                //let filePath = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                
                let fileURL = filePath.appendingPathComponent(fileName)
            
                //let file = try FileHandle(forWritingTo: fileURL)
                //defer { file.closeFile() }
            
                let db = try Connection("\(path)/LogData.db")
            
                let query = Job.join(Mileage, on: Job[JobID] == Mileage[MileID])
                    .join(Paid, on: Job[JobID] == Paid[PaidID])
                    .filter(BeenPaid == "yes")
                    .filter(DateFrom.like(SetYearField.stringValue + "%"))
                    .order(DispatchName, DateFrom)
            
                var contents = "Dispatcher, DateFrom, DateTo, Total Miles, Check Amount\n"
                //file.write(Headers.data(using: .utf8)!)
                
                for job in try db.prepare(query) {
                    contents += "\(job[DispatchName]), \(job[DateFrom]), \(job[DateTo]), \(job[TotalMiles]), \(job[CheckAmount])\n"
                }
                
                try contents.write(to:fileURL, atomically: false, encoding: .utf8)
            }catch{
                print("\(error)")
            }
        }
    }
}
extension ViewController:NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
}

extension ViewController: NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var result:NSTableCellView
        
        result = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        result.textField?.stringValue = tableViewData[row][(tableColumn?.identifier.rawValue)!]!
        
        return result
    }
}

extension String
{
    func toDateString(inputDateFormat inputFormat : String, outputDateFormat outputFormat : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
