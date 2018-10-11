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

import CoreData

final class SampleData:NSObject {

static var mensaje: String = "Hello World"
/**
     Persistent container: use NSPersistentContainer to create the Core Data stack
    */
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MoneyLogs")
        
        /**
         fatalError() causes the application to generate a crash log and terminate.
         You should not use this function in a shipping application.
        */
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
			mensaje = "WHOOPS:"
            fatalError("Unresolved error \(error), \(error.userInfo)")
        })
        
		/*
		if(container.viewContext == nil) //supposedly, container.viewContext is never nil
		{
			mensaje = "IMPLOSION 1"
		}
		else
		{
	        mensaje = "SUCCESS!"
		}
		*/
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil // We don't need undo so set it to nil.
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        /**
         Merge the changes from other contexts automatically.
         You can also choose to merge the changes by observing NSManagedObjectContextDidSave
         notification and calling mergeChanges(fromContextDidSave notification: Notification)
        */
        container.viewContext.automaticallyMergesChangesFromParent = true

		if(container.viewContext == nil)
		{
			mensaje += "IMPLOSION 2"
		}
		else
		{
	        mensaje += "SUCCESS!"
		}
        return container
    }()

  
  static func generateSampleData()  {
	let taskContext = persistentContainer.viewContext
	var rv: [Logitem?] = []

	if(taskContext != nil)
{

		rv=[ 
				generatePrimaryEntity(context:taskContext, name:"Rent",
						category:"Living Expenses",
						amount:826.85,
						date:"2018-08-31"),
				generatePrimaryEntity(context:taskContext, name:"Transit card",
						category:"Transportation",
						amount:10.00,
						date:"2018-09-03",
						details:"Travel to\\/from jury duty"),		
				generatePrimaryEntity(context:taskContext, name:"Comcast",
						category:"Living Expenses",
						amount:86.83,
						date:"2018-09-04",
						details:"Home internet")		
			]
			/*
//add item(s) to "List B"
		addToList(context:taskContext,list:rv[1]!,name:"Gala apples",qty:3,rowtotal:1.89)
		addToList(context:taskContext,list:rv[1]!,name:"Orange juice",qty:1,rowtotal:2.25)
		*/
		do {
		    try taskContext.save() //that's counterintuitive
		} catch {
			
			//fatalError("Error:Blew up trying to save in SampleData::generatePlayersData(): \(error)")
			//mensaje=("Error:Blew up trying to save in SampleData::generateListData(): \(error)")

		}
		
	}

  }

/*
	static func generatePlayer(context:NSManagedObjectContext,name:String?,game:String?,rating:Int) -> Player {
	
		guard let rv = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context) as? Player else {
		                fatalError("Error: Failed to create a new Player object!")
		            }
		rv.update(name:name,game:game,rating:rating)
		return rv
		
	}

	static func generatePlayer(name:String?,game:String?,rating:Int) -> Player {
	
		let taskContext = persistentContainer.viewContext
		guard let rv = generatePlayer(context:taskContext, name: name, game: game, rating: rating) as? Player else {
		                fatalError("Error: Failed to create a new Player object!")
		            }
		return rv
		
	}
	*/
	
	static func generatePrimaryEntity(context:NSManagedObjectContext,name:String,
			category:String,amount:Float,date:String,details: String? = nil
			) -> Logitem? {

		do{
			var rv: Logitem? = nil
			rv = NSEntityDescription.insertNewObject(forEntityName: "Logitem", into: context) as? Logitem
			if(rv != nil)
			{
				rv?.update(name:name,amt:amount,date:date, cat:category,details:details)   
			}
			else
			{
				mensaje = ("Error: Failed to create a new Logitem object for other reasons")
			}
			return rv			         
		}
		catch {
		        mensaje = ("Error: Failed to create a new Logitem object: \(error)")
		         
		}
		return nil	
	}
	
	/* deactivated for new model
	static func addToList(context:NSManagedObjectContext,
				list:Shoplist,
				name:String,
				qty:Float, 
				detail:String = "",
				rowtotal:Float){
				
		guard let rv = NSEntityDescription.insertNewObject(forEntityName: "Shopitem", into: context) as? Shopitem else {
				fatalError("Error: Failed to create a new List Item object!")
			}
		rv.update(name:name,qty:qty,detail:detail,rowtotal:rowtotal)
		list.items.insert(rv)	
				
    }
    */

}
