//
//  DatePickingViewController.swift
//  IOS10DatePickerTutorial
//
//  Created by Arthur Knopper on 22/01/2017.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import Foundation
import UIKit

class DatePickingViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var curdate:String = ""
    
    var facingdate:String? {
		didSet {
		  if let facingdate = facingdate
		  {
				curdate = facingdate!
				dateLabel.text = curdate
				//set datePicker
				
				let dateFormatter = DateFormatter()
				
				dateFormatter.dateStyle = DateFormatter.Style.short
				dateFormatter.timeStyle = DateFormatter.Style.none
				
				let possDate = dateFormatter.date(from: curdate)
				if(possDate != nil)
				{
					datePicker.setDate(possDate!, animated:false)
				}
			}
		}
  }
    
    
    var curISODate:String = ""
    
    @IBAction func datePickerChanged(_ sender: Any) {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            let strDate = dateFormatter.string(from: datePicker.date)
            dateLabel.text = strDate
            
			/*
			let isoFormatter = ISO8601DateFormatter()
			isoFormatter.formatOptions([.withFullDate, .withDashSeparatorInDate])
			
			curISODate = isoFormatter.string(datePicker.date)
			*/
			
			let options: ISO8601DateFormatter.Options = [.withFullDate, .withDashSeparatorInDate]
			curISODate = ISO8601DateFormatter.string(from: datePicker.date, timeZone: TimeZone.current, formatOptions: options)
    }

	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!curdate.isEmpty)
        {
			dateLabel.text = curdate
			//set datePicker
			
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            let possDate = dateFormatter.date(from: curdate)
            if(possDate != nil)
            {
				datePicker.setDate(possDate!, animated:false)
            }
        }
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
    
    if segue.identifier == "SaveChosenDate"
    {
		//return trip to Logging view
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateStyle = DateFormatter.Style.short
		dateFormatter.timeStyle = DateFormatter.Style.none
		
		let strDate = dateFormatter.string(from: datePicker.date)
		dateLabel.text = strDate
		curdate = strDate
		
		/*
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions([.withFullDate, .withDashSeparatorInDate])
		
		curISODate = isoFormatter.string(datePicker.date)
		*/
		
		
		let options: ISO8601DateFormatter.Options = [.withFullDate, .withDashSeparatorInDate]
		curISODate = ISO8601DateFormatter.string(from: datePicker.date, timeZone: TimeZone.current, formatOptions: options)

		
    }
    /*
    if segue.identifier == "PickGame",
      let gamePickerViewController = segue.destination as? GamePickerViewController {
      gamePickerViewController.selectedGame = game
      
    }*/
  }
  
  
}

