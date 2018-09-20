//
//  InputViewController.swift
//  LogBook
//
//  Created by Guest on 2/6/18.
//  Copyright © 2018 David Barnes. All rights reserved.
//

import Cocoa
import SQLite

class InputViewController: NSViewController {

    @IBOutlet weak var TruckCoField: NSTextField!
    @IBOutlet weak var DateFromField: NSTextField!
    @IBOutlet weak var DateToField: NSTextField!
    @IBOutlet weak var TruckNumField: NSTextField!
    @IBOutlet weak var DriverNameField: NSTextField!
    @IBOutlet weak var DispatcherNameField: NSTextField!
    @IBOutlet weak var JobNumField: NSTextField!
    @IBOutlet weak var StartingLocationField: NSTextField!
    @IBOutlet weak var EndingLocationField: NSTextField!
    @IBOutlet weak var RateField: NSTextField!
    @IBOutlet weak var MilesField: NSTextField!
    @IBOutlet weak var DeadHeadRateField: NSTextField!
    @IBOutlet weak var DeadHeadMilesField: NSTextField!
    @IBOutlet weak var StandbyRateField: NSTextField!
    @IBOutlet weak var HoursField: NSTextField!
    @IBOutlet weak var PaidField: NSTextField!
    @IBOutlet weak var NotesField: NSTextField!
    @IBOutlet var CheckAmountField: NSTextField!
    @IBOutlet var IsMini: NSButton!
    
    let DispatchName = Expression<String>("DispatchName")
    let DriverName = Expression<String>("DriverName")
    let Miles = Expression<Double>("Miles")
    let DeadHead = Expression<Double>("DeadHead")
    let TotalMiles = Expression<Double>("TotalMiles")
    let Standby = Expression<Double>("Standby")
    let JobNum = Expression<String>("JobNum")
    let Notes = Expression<String>("Notes")
    let BeenPaid = Expression<String>("BeenPaid")
    let MileRate = Expression<Double>("MileRate")
    let StandbyRate = Expression<Double>("StandbyRate")
    let DeadHeadRate = Expression<Double>("DeadHeadRate")
    let TotalOwed = Expression<Double>("TotalOwed")
    let CheckAmount = Expression<Double>("CheckAmount")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func SubmitJob(_ sender: Any) {
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
        
        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory, .userDomainMask, true
            ).first! + "/" + Bundle.main.bundleIdentifier!

        do {
            let db = try Connection("\(path)/LogData.db")
            
            var count = try db.scalar(Dispatch.filter(DispatchName == DispatcherNameField.stringValue).count)
            if (count < 1)
            {
                try db.run(Dispatch.insert(DispatchName <- DispatcherNameField.stringValue.capitalizingFirstLetter()))
            }
            
            count = try db.scalar(Driver.filter(DriverName == DriverNameField.stringValue).count)
            if (count < 1)
            {
                try db.run(Driver.insert(DriverName <- DriverNameField.stringValue.capitalizingFirstLetter()))
            }
            
            try db.run(Mileage.insert(Miles <- MilesDub!, DeadHead <- DeadHeadMiles!, TotalMiles <- (MilesDub! + DeadHeadMiles!), Standby <- Hours!))
            
            try db.run(Notations.insert(Notes <- NotesField.stringValue))
            
            try db.run(Paid.insert(BeenPaid <- PaidField.stringValue, MileRate <- Rate!, StandbyRate <- StandbyRateDub!, DeadHeadRate <- DeadHeadRateDub!, TotalOwed <- Total, CheckAmount <- Check!))
            
            try db.run(Route.insert(Start <- StartingLocationField.stringValue, End <- EndingLocationField.stringValue))
            
            count = try db.scalar(TruckCo.filter(TruckCoName == TruckCoField.stringValue).count)
            if (count < 1)
            {
                try db.run(TruckCo.insert(TruckCoName <- TruckCoField.stringValue.capitalizingFirstLetter()))
            }
            
            try db.run(Job.insert(JobNum <- JobNumField.stringValue, DispatchName <- DispatcherNameField.stringValue.capitalizingFirstLetter(), TruckCoName <- TruckCoField.stringValue.capitalizingFirstLetter(), TruckID <- TruckNumField.stringValue, DriverName <- DriverNameField.stringValue.capitalizingFirstLetter(), DateFrom <- From, DateTo <- To))
            
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
