//
//  ViewController.swift
//  Flashcards1
//
//  Created by Andrew Pisano on 3/18/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 25.0
        card.layer.shadowOpacity = 0.3
        
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.layer.shadowOpacity = 0.2
        frontLabel.layer.shadowRadius = 15.0
        frontLabel.clipsToBounds = true
        
        backLabel.layer.cornerRadius = 20.0
        backLabel.layer.shadowOpacity = 0.2
        backLabel.layer.shadowRadius = 15.0
        backLabel.clipsToBounds = true
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the state motto of New York?", answer: "Empire State")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = !frontLabel.isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        flashcards.append(flashcard)
        print("Added new flashcard")
        print("There are now \(flashcards.count) flashcards")
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else{
            prevButton.isEnabled = true
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = !frontLabel.isHidden
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex += 1
        updateLabels()
        updateNextPrevButtons()
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        updateLabels()
        updateNextPrevButtons()
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    
    
}

