//
//  ViewController.swift
//  Calculator Calculates Tips
//
//  Created by Jason Ven on 5/21/19.
//  Copyright © 2019 Jason Ven. All rights reserved.
//

import UIKit

enum modes {
  case noMode
  case addition
  case subtraction
  case multiplcation
  case division
}

class ViewController: UIViewController {
  @IBOutlet weak var window: UILabel!
  var windowString:String = "0"
  var currentMode:modes = .noMode
  var savedData:Float64 = 0
  var lastActionWasMode:Bool = false
  var lastActionWasDecimal:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func didPressDivide(_ sender: Any) {
    changeModes(newMode: .division)
  }
  
  @IBAction func didPressMultiply(_ sender: Any) {
    changeModes(newMode: .multiplcation)
  }
  
  @IBAction func didPressSubtract(_ sender: Any) {
    changeModes(newMode: .subtraction)
  }
  
  @IBAction func didPressPlus(_ sender: Any) {
    changeModes(newMode: .addition)
  }
  
  @IBAction func didPressEqual(_ sender: Any) {
    guard let windowInt:Float64 = Float64(windowString) else {
      return
    }
    if (currentMode == .noMode || lastActionWasMode) {
      return
    }
    if (currentMode == .addition) {
      savedData += windowInt
    }
    else if (currentMode == .subtraction) {
      savedData -= windowInt
    }
    else if (currentMode == .multiplcation) {
      savedData *= windowInt
    }
    else if (currentMode == .division) {
      savedData /= windowInt
    }
    currentMode = .noMode
    windowString = "\(savedData)"
    updateWindow()
    lastActionWasMode = true
  }
  
  // Resets all of the fields in calculator
  @IBAction func didPressClear(_ sender: Any) {
    windowString = "0"
    currentMode = .noMode
    savedData = 0
    lastActionWasMode = false
    window.text = "0"
    lastActionWasDecimal = false
  }
  
  // Calculates fifteen percent of the value in window screen
  @IBAction func didPressFifteenTip(_ sender: Any) {
    let fifteenPercent:Float64 = 15
    savedData = (savedData * fifteenPercent) / 100
    windowString = "\(savedData)"
    updateWindow()
  }
  
  // Calculates twenty percent of the value in window screen
  @IBAction func didPressTwentyTip(_ sender: Any) {
    let twentyPercent:Float64 = 20
    savedData = (savedData * twentyPercent) / 100
    windowString = "\(savedData)"
    updateWindow()
  }
  
  @IBAction func didPressNumber(_ sender: UIButton) {
    // Converts the label on number button to a string
    let stringValue:String? = sender.titleLabel?.text
    if (lastActionWasMode) {
      lastActionWasMode = false
      windowString = "0"
    }
    // Adds the string value of number button to existing value
    windowString = windowString.appending(stringValue!)
    updateWindow()
    lastActionWasDecimal = false

  }
  
  @IBAction func didPressDecimal(_ sender: UIButton) {
    let stringValue:String? = sender.titleLabel?.text
    if (lastActionWasDecimal) {
      return
    }
    lastActionWasDecimal = true
    if (lastActionWasMode) {
      lastActionWasMode = false
      windowString = "0".appending(stringValue!)
    } else {
      windowString = windowString.appending(stringValue!)
    }
    updateWindow()
  }
  
  func updateWindow() {
    // String conversion to Int gets rid of preceding zeroes
    guard let windowInt:Float64 = Float64(windowString) else {
      return
    }
    if (currentMode == .noMode) {
      savedData = windowInt
    }
    let formatter:NumberFormatter = NumberFormatter()
    formatter.numberStyle = .decimal
    let num:NSNumber = NSNumber(value: windowInt)
    window.text = formatter.string(from: num)
    // This adjusts the numbers to fit within the window's width
    window.adjustsFontSizeToFitWidth = true
    window.minimumScaleFactor = 0.05
  }

  func changeModes(newMode:modes) {
    if (savedData == 0) {
      return
    }
    currentMode = newMode
    lastActionWasMode = true
    lastActionWasDecimal = false
  }
}

