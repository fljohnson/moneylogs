//
//  DatePickingViewController.swift
//  IOS10DatePickerTutorial
//
//  Created by Arthur Knopper on 22/01/2017.
//  Copyright © 2017 Arthur Knopper. All rights reserved.
//

import UIKit

class DatePickingViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var curdate:String = ""
    
    @IBAction func datePickerChanged(_ sender: Any) {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            let strDate = dateFormatter.string(from: datePicker.date)
            dateLabel.text = strDate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(curdate != nil && !curdate.isEmpty)
        {
			dateLabel.text = curdate
			//set datePicker
			
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.none
            
            let possDate = dateFormatter.date(from: curdate)
            if(possDate != nil)
            {
				datePicker.setDate(possDate, animated:false)
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
    }
    /*
    if segue.identifier == "PickGame",
      let gamePickerViewController = segue.destination as? GamePickerViewController {
      gamePickerViewController.selectedGame = game
      
    }*/
  }
  
  
}

