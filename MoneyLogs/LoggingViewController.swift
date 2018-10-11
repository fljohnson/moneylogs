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


 @IBOutlet weak var fromDtBtn: UIButton!
 @IBOutlet weak var toDtBtn: UIButton!
 
 
}

  
// MARK: - IBActions
extension LoggingViewController {
  @IBAction func pressed(sender: UIButton!) {
            var alertView = UIAlertView()
            alertView.addButton(withTitle:"OK")
            alertView.title = "Button hit"
            if(sender.currentTitle != nil)
            {
				alertView.message = "It was \(sender.currentTitle)"
			}
			else
			{
				alertView.message = "Drew a blank"
			}
            alertView.show()
        }
        
  @IBAction func cancelToLoggingViewController(_ segue: UIStoryboardSegue) {
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
		//let aha: NSPredicate = NSPredicate(format:"listname == %@",weher as CVarArg) 
		//sanity check with literal - this time with @NSManaged on attribute
		let aha: NSPredicate = NSPredicate(format:"listname == 'List B'") 
	/*	
        do {
			request.predicate = aha //allegedly, no error would be thrown here
		}
		catch {
			SampleData.mensaje="Predicate failure: \(error)"
			return
		}
*/
		//request.predicate = aha
		
		


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


/*
	override func viewDidLoad() {
		super.viewDidLoad();
		fromDtBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
		toDtBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
	}*/
	
	func showMessage(msg:String)
	{
		let alertController = UIAlertController(title: "Heads up", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
		
	}

	override func viewDidAppear(_ animated:Bool)
	{
		showMessage(msg:SampleData.mensaje)
		
		super.viewDidAppear(animated)
	}  

override func viewWillAppear(_ animated: Bool) 
{ 
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

/* TODO: figure out the detail part this will take us to
	override func prepare(for segue: UIStoryboardSegue, 
      sender: Any?)
	{
		let controller = segue.destination as? ItemsDetailsViewController
		let thePath = tableView.indexPathForSelectedRow
		if(thePath != nil && controller != nil)
		{
			controller?.player = players[thePath!.row]
		}
		controller?.goods = "HIT!";

	}
	*/
}
