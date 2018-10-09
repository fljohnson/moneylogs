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

class ItemDetailsViewController: UITableViewController {
  
  // MARK: - Properties
  var item: Shopitem?
  var goods: String?
  
  var game: String = "Chess" {
    didSet {
      detailLabel.text = game
    }
  }
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var detailLabel: UILabel!
  
  // MARK: - Initializers
  required init?(coder aDecoder: NSCoder) {
    //print("init PlayerDetailsViewController")
    super.init(coder: aDecoder)
  }
  
  deinit {
    //print("deinit PlayerDetailsViewController")
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
    /* TODO: figure this out
    if segue.identifier == "SaveItemDetail",
      let playerName = nameTextField.text {
      player = SampleData.generatePlayer(name: playerName, game: "Chess", rating: 1)
		do {
        	try SampleData.persistentContainer.viewContext.save() //this only works (maybe) because we know that much about SampleData
		} catch {
			fatalError("Error:Blew up trying to save in PlayerDetailsViewController::prepare(): \(error)")
		}
	
    }*/
    
    if segue.identifier == "PickGame",
      let gamePickerViewController = segue.destination as? GamePickerViewController {
      gamePickerViewController.selectedGame = game
    }
  }

  override func viewDidLoad() {
        super.viewDidLoad()

        // Used the text from the First View Controller to set the label
		if(item != nil)
		{
			nameTextField.text = item?.itemname
		}
		else
		{

				if(goods != nil)
				{	
					nameTextField.text = goods
				}
				else
				{
					nameTextField.text = "MISS!"
				}

		}
		

    }	
}

// MARK: - IBActions
extension ItemDetailsViewController {
  
  @IBAction func unwindWithSelectedGame(segue: UIStoryboardSegue) {
    if let gamePickerViewController = segue.source as? GamePickerViewController,
      let selectedGame = gamePickerViewController.selectedGame {
      game = selectedGame
    }
  }
}

// MARK: - UITableViewDelegate
extension ItemDetailsViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      nameTextField.becomeFirstResponder()
    }
  }
}




