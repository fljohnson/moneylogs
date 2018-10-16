import UIKit
import CoreData

class StatsViewController: UITableViewController {
//I smell refactoring on the horizon
	var itemlist:[Totalitem] = []
	var fired:Bool = false
	var dates:[String] = []
	var dbDates:[String] = []
	var dateIndex:Int = 0


	 @IBOutlet weak var fromDtBtn: UIButton!
	 @IBOutlet weak var toDtBtn: UIButton!
	 
	 
	 @IBAction func cancelToStatsViewController(_ segue: UIStoryboardSegue) {
	}
	
	@IBAction func saveChosenDate(_ segue: UIStoryboardSegue) {
	guard let datePickerController = segue.source as? DatePickingViewController
       else {
        return
    }
    
    let datestring = datePickerController.curdate
    
    //if we got here, we get to handle datestring
    //ditch the stupid stuff first
    if(datestring == nil || datestring.isEmpty)
    {
		//alert that we got a bad item from datePickerController
		/*
		var alertView = UIAlertView()
		alertView.addButton(withTitle:"OK")
		alertView.title = "UHOH"
		alertView.message = "datestring is not valid"
		alertView.show()
		*/
		return
    }
    if(dateIndex < 0)
    {
		//alert that dateIndex is out of bounds
		/*
		var alertView = UIAlertView()
		alertView.addButton(withTitle:"OK")
		alertView.title = "UHOH"
		alertView.message = "dateIndex is \(dateIndex)"
		alertView.show()
        */  
		return
    }
    
    dbDates[dateIndex]=datePickerController.curISODate
    dates[dateIndex]=datestring
    if(dateIndex == 0)
    {
		fromDtBtn.setTitle("From:" + datestring, for:.normal)
    }
    if(dateIndex == 1)
    {
		toDtBtn.setTitle("To:" + datestring, for:.normal)
    }
    
  }
  
	//handle the "change the date range" segues
	override func prepare(for segue: UIStoryboardSegue, 
      sender: Any?)
	{
		
		let boton = (sender as? UIButton)
		if(boton != nil)
		{
			dateIndex = -1
			if(boton?.currentTitle == fromDtBtn.currentTitle)
			{
				dateIndex = 0
			}
			else
			if(boton?.currentTitle == toDtBtn.currentTitle)
			{
				dateIndex = 1
			}
			if(dateIndex != -1)
			{
				let controller = segue.destination as? DatePickingViewController
				if(controller != nil)
				{
					controller?.curdate=dates[dateIndex]
				}
			}
		}

	}
  
	private func setupTableView() {
	if(!fired)
		{
			fromDtBtn.setTitle("From:" + dates[0], for:.normal)
			toDtBtn.setTitle("To:" + dates[1], for:.normal)
			
			tableView.rowHeight = UITableViewAutomaticDimension
			tableView.estimatedRowHeight = 44
			tableView.delegate = self
			populate()
			fired = true
		}
	}
	
	private func populate()
	{
		itemlist = []
		for categoryName in Totalitem.categories
		{
			itemlist.append(Totalitem(categoryName,fromDate:dbDates[0],
					toDate:dbDates[1]))
		}
	}
		
		
	override func viewWillAppear(_ animated: Bool) 
	{ 
	let today=Date()
	let monthstart = today
	//mangle it
	let monthend = today
	//mangle it
	
	//set up the date strings for querying - ISO8601 style
	let options: ISO8601DateFormatter.Options = [.withFullDate, .withDashSeparatorInDate]
	dbDates[0] = ISO8601DateFormatter.string(from: monthstart, timeZone: TimeZone.current, formatOptions: options)
	dbDates[1] = ISO8601DateFormatter.string(from: monthend, timeZone: TimeZone.current, formatOptions: options)
	
	//now for the UI
	
	let dateFormatter = DateFormatter()	
	dateFormatter.dateStyle = DateFormatter.Style.short
	dateFormatter.timeStyle = DateFormatter.Style.none
	
	dates[0] = dateFormatter.string(from: monthstart)
	dates[1] = dateFormatter.string(from: monthend)
	
		setupTableView()
	} 
	
	
//these are key to the built-in UITableView (self.tableView)
	override func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return itemlist.count
	  }
	  
	  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell",
												 for: indexPath) as! StatCell

		
		

		let item = itemlist[indexPath.row]
		cell.item = item
		return cell
	  }
	  
	
}
