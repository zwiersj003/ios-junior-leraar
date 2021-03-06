//
//  CollegialeSamenwerkingTableViewController.swift
//  JuniorLeraar
//
//  Created by Jasper Zwiers on 08-03-18.
//  Copyright © 2018 Jasper Zwiers. All rights reserved.
//

import UIKit

class CollegialeSamenwerkingTableViewController: UITableViewController {

    var cardsArray = [Card]()
    var startbekwaamCards = [Card]()
    var selectedCard: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardsArray()
        setupStyling()
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Constants.yellow20
    }
    
    func setupStyling() {
        navigationItem.title = Constants.themeC
        navigationController?.navigationBar.barTintColor = Constants.yellow
        navigationController?.navigationBar.tintColor = Constants.purpleblue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Constants.purpleblue]
    }
    
    func getCardsArray() {
        cardsArray = JsonController.parseJson()
        getCards()
    }
    
    func getCards() {
        var count = 0
        startbekwaamCards.removeAll()
        for card in cardsArray {
            if (card.level.lowercased() == Constants.levelS.lowercased() && card.theme.lowercased() == Constants.themeC.lowercased()) {
                startbekwaamCards.append(card)
                count = count + 1
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startbekwaamCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = startbekwaamCards[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = startbekwaamCards[indexPath.row].title
        performSegue(withIdentifier: Constants.openCompetenceCardCS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.openCompetenceCardCS) {
            let yourNextViewController = segue.destination as! CardViewController
            yourNextViewController.selectedCard = selectedCard
            
            let backItem = UIBarButtonItem()
            backItem.title = Constants.back
            navigationItem.backBarButtonItem = backItem
        }
    }
}
