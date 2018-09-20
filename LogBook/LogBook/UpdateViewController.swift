//
//  UpdateViewController.swift
//  LogBook
//
//  Created by Guest on 5/2/18.
//  Copyright © 2018 David Barnes. All rights reserved.
//

import Cocoa
import SQLite

class UpdateViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    @IBOutlet var JobNumField: NSTextField!
    @IBOutlet var DispatcherNameField: NSTextField!
    @IBOutlet var PaidField: NSTextField!
    @IBOutlet var DateFromField: NSTextField!
    @IBOutlet var DateToField: NSTextField!
    @IBOutlet var CheckAmountField: NSTextField!
    @IBOutlet var TruckCoField: NSTextField!
    @IBOutlet var TruckNumField: NSTextField!
    @IBOutlet var DriverNameField: NSTextField!
    @IBOutlet var StartingLocationField: NSTextField!
    @IBOutlet var EndingLocationField: NSTextField!
    @IBOutlet var RateField: NSTextField!
    @IBOutlet var MilesField: NSTextField!
    @IBOutlet var IsMini: NSButton!
    @IBOutlet var DeadHeadRateField: NSTextField!
    @IBOutlet var DeadHeadMilesField: NSTextField!
    @IBOutlet var StandbyRateField: NSTextField!
    @IBOutlet var HoursField: NSTextField!
    @IBOutlet var NotesField: NSTextField!
    
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
    
    var jobNumber: Int64 = 0
    @objc dynamic var jobNum = ""
    @objc dynamic var dispatcherName = ""
    @objc dynamic var beenPaid = ""
    @objc dynamic var dateFrom = ""
    @objc dynamic var dateTo = ""
    @objc dynamic var checkAmount = ""
    @objc dynamic var truckCo = ""
    @objc dynamic var truckNum = ""
    @objc dynamic var driverName = ""
    @objc dynamic var startingLocation = ""
    @objc dynamic var endingLocation = ""
    @objc dynamic var rate = ""
    @objc dynamic var miles = ""
    @objc dynamic var deadHeadRate = ""
    @objc dynamic var deadHeadMiles = ""
    @objc dynamic var standbyRate = ""
    @objc dynamic var hours = ""
    @objc dynamic var notes = ""
    
    let path = NSSearchPathForDirectoriesInDomains(
        .applicationSupportDirectory, .userDomainMask, true
        ).first! + "/" + Bundle.main.bundleIdentifier!
    
    
    @IBAction func UpdateJob(_ sender: Any) {

        if (PaidField.stringValue == ""){ PaidField.stringValue = "no"}
        if (TruckNumField.stringValue == ""){ TruckNumField.stringValue = " "}
        if (NotesField.stringValue == ""){ NotesField.stringValue = " "}
        if (DeadHeadRateField.stringValue == ""){ DeadHeadRateField.stringValue = "0"}
        if (DeadHeadMilesField.stringValue == ""){ DeadHeadMilesField.stringValue = "0"}
        if (RateField.stringValue == ""){ RateField.stringValue = "0"}
        if (MilesField.stringValue == ""){ MilesField.stringValue = "0"}
        if (StandbyRateField.stringValue == ""){ StandbyRateField.stringValue = "0"}
        if (HoursField.stringValue == ""){ HoursField.stringValue = "0"}
        if (CheckAmountField.stringValue == ""){ CheckAmountField.stringValue = "0"}
        if (DateToField.stringValue == ""){ DateToField.stringValue = DateFromField.stringValue}
        let Rate: Double? = Double(RateField.stringValue)
        let MilesDub: Double? = Double(MilesField.stringValue)
        let DeadHeadRateDub: Double? = Double(DeadHeadRateField.stringValue)
        let DeadHeadMiles: Double? = Double(DeadHeadMilesField.stringValue)
        let StandbyRateDub: Double? = Double(StandbyRateField.stringValue)
        let Hours: Double? = Double(HoursField.stringValue)
        var Total = Double()
        let Check: Double? = Double(CheckAmountField.stringValue)
        let from = DateFromField.stringValue.capitalizingFirstLetter()
        let From = from.toDateString(inputDateFormat: "MMMM/d/yyyy", outputDateFormat: "yyyy-MM-dd")
        let to = DateToField.stringValue.capitalizingFirstLetter()
        let To = to.toDateString(inputDateFormat: "MMMM/d/yyyy", outputDateFormat: "yyyy-MM-dd")
        
        if Rate == nil { RateField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Rate Field")
            return
        }
        if MilesDub == nil { MilesField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Miles Field")
            return
        }
        if DeadHeadRateDub == nil { DeadHeadRateField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Dead Head Rate Field")
            return
        }
        if DeadHeadMiles == nil { DeadHeadMilesField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Daed Head Miles Field")
            return
        }
        if StandbyRateDub == nil { StandbyRateField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Standby Rate Field")
            return
        }
        if Hours == nil { HoursField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Hours Field")
            return
        }
        if Check == nil { CheckAmountField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Non-number found in Check Amount Field")
            return
        }
        if From == "" { DateFromField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Wrong Format used in the Date From Field. Date must be in the form of month/day/year")
            return
        }
        if To == "" { DateToField.backgroundColor = NSColor.red
            dialogError(error: "Error",text: "Wrong Format used in the Date To Field. Date must be in the form of month/day/year")
            return
        }
        
        switch IsMini.state {
        case .on:
            Total = 85 + (DeadHeadRateDub! * DeadHeadMiles!) + (StandbyRateDub! * Hours!)
            NotesField.stringValue += "Mini"
        case .off:
            if (MilesDub! >= 200)
            {
                Total = (Rate! * MilesDub!) + (DeadHeadRateDub! * DeadHeadMiles!) + (StandbyRateDub! * Hours!)
            }
            else
            {
                Total = (Rate! * (MilesDub! - 25)) + (DeadHeadRateDub! * DeadHeadMiles!) + (StandbyRateDub! * Hours!) + 85
            }
        default:
            break
        }
        if (DispatcherNameField.stringValue != "self"){ Total *= 0.9 }
        
        do {
            let db = try Connection("\(path)/LogData.db")
            
            var job = Mileage.filter(MileID == jobNumber)
            try db.run(job.update(Miles <- MilesDub!, DeadHead <- DeadHeadMiles!, TotalMiles <- (MilesDub! + DeadHeadMiles!), Standby <- Hours!))
            
            job = Notations.filter(NoteID == jobNumber)
            try db.run(job.update(Notes <- NotesField.stringValue))
            
            job = Paid.filter(PaidID == jobNumber)
            try db.run(job.update(BeenPaid <- PaidField.stringValue, MileRate <- Rate!, StandbyRate <- StandbyRateDub!, DeadHeadRate <- DeadHeadRateDub!, TotalOwed <- Total, CheckAmount <- Check!))
            
            job = Route.filter(RouteID == jobNumber)
            try db.run(job.update(Start <- StartingLocationField.stringValue, End <- EndingLocationField.stringValue))
            
            job = Job.filter(JobID == jobNumber)
            try db.run(job.update(JobNum <- JobNumField.stringValue, DispatchName <- DispatcherNameField.stringValue, TruckCoName <- TruckCoField.stringValue, TruckID <- TruckNumField.stringValue, DriverName <- DriverNameField.stringValue, DateFrom <- From, DateTo <- To))
            
        }catch {
            print("\(error)")
        }
        
        self.view.window?.close()
        
    }
    
    func dialogError(error: String, text: String) {
        let alert = NSAlert()
        alert.messageText = error
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
