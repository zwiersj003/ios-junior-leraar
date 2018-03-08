//
//  CompetenceTableViewController.swift
//  JuniorLeraar
//
//  Created by Jasper Zwiers on 15-02-18.
//  Copyright © 2018 Jasper Zwiers. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation

class DidactischBekwaamTableViewController: UITableViewController {

    private var dialoguecardRef: DatabaseReference?
    var cardsArray = [Card]()
    var startbekwaamCards = [Card]()
    var tableHeaders = [String]()
    var tableValues = [[String]]()
    
    var groupA = [String]()
    var groupB = [String]()
    var groupC = [String]()
    var groupD = [String]()
    var groupE = [String]()
    var groupF = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReferences()
        setupStyling()
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Constants.purpleblue20
    }
    
    func setupStyling() {
        navigationItem.title = "Didactisch Bekwaam"
        navigationController?.navigationBar.barTintColor = Constants.purpleblue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        navigationController?.navigationItem.backBarButtonItem = Cons
//        tableView.backgroundColor = Constants.purpleblue50
//        self.tableView.backgroundColor = Constants.lightblue20
        
    }
    
    func setupReferences() {
        dialoguecardRef = Constants.getRootRef()
        dialoguecardRef?.keepSynced(true)
        observeCards()
    }
    
    func observeCards() {
        dialoguecardRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let cardSnapshot = item as? DataSnapshot {
                    let card = Card(snapshot: cardSnapshot)
                    self.cardsArray.append(card)
                }
            }
            self.getCards()
        })
    }

    // MARK: - Table view data source
    
    func getCards() {
        var count = 0
        for card in cardsArray {
            if (card.level.lowercased() == "startbekwaam" && card.theme.lowercased() == "didactisch bekwaam") {
                startbekwaamCards.append(card)
                count = count + 1
            }
        }
        getTableHeaders()
    }
    
    func getTableHeaders() {
        for card in startbekwaamCards {
            let competence = card.competence
            if (tableHeaders.contains(competence) == false) {
                tableHeaders.append(competence)
            }
        }
        getTableValues()
    }
    
    func getTableValues () {
        for card in startbekwaamCards {
            if (card.competence == tableHeaders[0]) {
                groupA.append(card.title)
            } else if (card.competence == tableHeaders[1]) {
                groupB.append(card.title)
            } else if (card.competence == tableHeaders[2]) {
                groupC.append(card.title)
            } else if (card.competence == tableHeaders[3]) {
                groupD.append(card.title)
            } else if (card.competence == tableHeaders[4]) {
                groupE.append(card.title)
            } else if (card.competence == tableHeaders[5]) {
                groupF.append(card.title)
            }
        }
        tableValues.append(groupA)
        tableValues.append(groupB)
        tableValues.append(groupC)
        tableValues.append(groupD)
        tableValues.append(groupE)
        tableValues.append(groupF)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return groupA.count
        } else if (section == 1) {
            return groupB.count
        } else if (section == 2){
            return groupC.count
        } else if (section == 3){
            return groupD.count
        } else if (section == 4){
            return groupE.count
        } else if (section == 5){
            return groupF.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = tableValues[indexPath.section][indexPath.row]
//        cell.backgroundColor = Constants.lightblue20
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openCompetenceCard", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaders[section]
    }
}
