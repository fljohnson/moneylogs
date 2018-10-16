import Foundation

final class Totalitem:NSObject {

static var categories: [String] = [
								"Savings",
								"Living Expenses",
								"Transportation",
								"Debts"
								]
  // MARK: - Properties
  var category: String
  var amount:Float
  
  init(_ categoryName:String){
	category = categoryName
	amount = 0.0
	//now for the messy stuff: select all Logitems where category = categoryName
	let request = Logitem.fetchRequest()
	let predicate: NSPredicate = NSPredicate(format:"category == %@",categoryName)
	request.predicate = predicate
	
	do {
			var fetched: [Logitem]? = nil
			try fetched = SampleData.persistentContainer.viewContext.fetch(request) as? [Logitem]
			if(fetched == nil)
			{
				//SampleData.mensaje="fetched is nil"
				return

			}
			
			for subject in fetched!
			{
				amount += subject.amount
			}
			
		}
		catch {
			SampleData.mensaje="Failed to fetch entities: \(error)"
			//fatalError("Failed to fetch entities: \(error)")
		}
  }
}
