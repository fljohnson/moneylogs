/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class LoggingViewController: UITableViewController {
  
  // MARK: - Properties

  
var itemlist:[Logitem] = []
var fired:Bool = false
var dates:[String] = ["9/1/2018","9/30/2018"]
var dbDates:[String] = ["2018-08-01","2018-09-02"]
var dateIndex:Int = 0


 @IBOutlet weak var fromDtBtn: UIButton!
 @IBOutlet weak var toDtBtn: UIButton!

	 @IBAction func saveButtonTouchUpInside(_ sender: AnyObject) {

			
            var alertView = UIAlertView()
            alertView.addButton(withTitle:"OK")
            alertView.title = "Button hit"
            if(sender.currentTitle != nil)
            {
				alertView.message = "It was the save key"
			}
			else
			{
				alertView.message = "Drew a blank"
			}
            alertView.show()
	}
 
}

  
// MARK: - IBActions
extension LoggingViewController {
  @IBAction func pressed(sender: UIButton!) {
            var alertView = UIAlertView()
            alertView.addButton(withTitle:"OK")
            alertView.title = "Button hit"
            if(sender.currentTitle != nil)
            {
				alertView.message = "It was \(sender.currentTitle!)"
			}
			else
			{
				alertView.message = "Drew a blank"
			}
            alertView.show()
        }
        
  @IBAction func cancelToLoggingViewController(_ segue: UIStoryboardSegue) {
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
		var alertView = UIAlertView()
		alertView.addButton(withTitle:"OK")
		alertView.title = "UHOH"
		alertView.message = "datestring is not valid"
		alertView.show()
		return
    }
    if(dateIndex < 0)
    {
		//alert that dateIndex is out of bounds
		
		var alertView = UIAlertView()
		alertView.addButton(withTitle:"OK")
		alertView.title = "UHOH"
		alertView.message = "dateIndex is \(dateIndex)"
		alertView.show()
            
		return
    }
    dbDates[dateIndex]=datePickerController.curISODate
    dates[dateIndex]=datestring
    if(dateIndex == 0)
    {
		fromDtBtn.setTitle("From:" + dates[dateIndex], for:.normal)
    }
    if(dateIndex == 1)
    {
		toDtBtn.setTitle("To:" + dates[dateIndex], for:.normal)
    }
    setupDataSource()
    tableView.reloadData() //harsh, but effective
  }
  
  @IBAction func saveItemDetail(_ segue: UIStoryboardSegue) {
    //TODO:figure all this out
    /*
    guard let itemDetailsViewController = segue.source as? ItemDetailsViewController,
      let item = itemDetailsViewController.item else {
        return
    }
    */
    
    /*
    // add the new player to the players array
    players.append(player)
    
    // update the tableView
    let indexPath = IndexPath(row: players.count - 1, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic) 
    */
  }


// MARK: - UITableViewDataSource


private func setupTableView() {
		if(!fired)
		{
			fromDtBtn.setTitle("From:" + dates[0], for:.normal)
			toDtBtn.setTitle("To:" + dates[1], for:.normal)
			
			tableView.rowHeight = UITableViewAutomaticDimension
			tableView.estimatedRowHeight = 44
			tableView.delegate = self
			setupDataSource()
			fired = true
		}
}

private func setupDataSource() {

		
        //let regionType = filterSegmentedControl.regionType
		
        let request = Logitem.fetchRequest()
		let weher: String = "List B" 
		//nonlethal, but does not match what it should 
		
		//this "argumentArray:" form seems to work more reliably than the VarArg version
		let aha: NSPredicate = NSPredicate(
				format:"(thedate >= %@) AND (thedate <= %@)",
				argumentArray:[
					dbDates[0],
					dbDates[1]
					]
							)
							
		request.predicate = aha
		
		
		SampleData.mensaje = ""

        do {
			var fetched: [Logitem]? = nil
			try fetched = SampleData.persistentContainer.viewContext.fetch(request) as? [Logitem]
			if(fetched == nil)
			{
				SampleData.mensaje="fetched is nil"
				return

			}
			
			if(fetched!.count == 0)
			{
				SampleData.mensaje="fetched has no records"
				return
			}
			itemlist = fetched!.sorted {
				return ($0.thedate > $1.thedate)
			}
			
		}
		catch {
			SampleData.mensaje="Failed to fetch entities: \(error)"
			//fatalError("Failed to fetch entities: \(error)")
		}
		


}

}

extension LoggingViewController {



	override func viewDidLoad() {
		super.viewDidLoad();
//		fromDtBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
//		toDtBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
	}
	
	func showMessage(msg:String)
	{
		if(!msg.isEmpty)
		{
			let alertController = UIAlertController(title: "Heads up", message: msg, preferredStyle: UIAlertControllerStyle.alert)
			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
			present(alertController, animated: true, completion: nil)
        }
		
	}

	override func viewDidAppear(_ animated:Bool)
	{
		showMessage(msg:SampleData.mensaje)
		
		super.viewDidAppear(animated)
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
 //getData() tableView.reloadData() 
} 

override func numberOfSections(in tableView: UITableView) -> Int {
	
    return 1
}
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

	return itemlist.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                                             for: indexPath) as! ItemCell

	
	

    let item = itemlist[indexPath.row]
    cell.item = item
    return cell
  }
/*
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
	let player = players[indexPath.row]
	//performSegue(withIdentifier:"Zsg-bI-zZp",sender:self);
  }
*/
// "?." is for optional chaining, and fails gracefully on nil dereference; "!." is for forced unwrapping, and would cause a crash on nil dereference

/* TODO: figure out the detail part this will take us to */
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
					controller?.eatmyshorts(dates[dateIndex])
				}
			}
		}
		else
		{
			let controller = segue.destination as? ItemDetailsViewController
			let thePath = tableView.indexPathForSelectedRow
			if(thePath != nil && controller != nil)
			{
		//		controller?.player = players[thePath!.row] //there is nothing there
			}
			controller?.goods = "HIT!";
		}

	}
	
}
