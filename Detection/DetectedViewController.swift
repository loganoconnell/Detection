//
//  DetectedViewController.swift
//  Detection
//
//  Created by Logan O'Connell on 7/2/17.
//  Copyright © 2017 Logan O'Connell. All rights reserved.
//

import UIKit
import CoreML

class DetectedViewController: UIViewController {
    @IBOutlet weak var detectedImageView: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var detectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.detectedImageView.image = self.detectedImage
        
        process()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func process() {
        let pixelBuffer = self.detectedImage.pixelBuffer
        let model = Inceptionv3()
        
        do {
            let output = try model.prediction(image: pixelBuffer!)
            let probs = output.classLabelProbs.sorted { $0.value > $1.value }
            
            if let prob = probs.first {
                let newKey: String! = prob.key.capitalized.components(separatedBy: ",")[0]
                objectLabel.text = newKey
                let newValue: String! = String(format: "%.3f%% positivity", prob.value * 100)
                percentageLabel.text = newValue
            }
        }
            
        catch {
            self.presentAlertController(withTitle: title, message: error.localizedDescription)
        }
    }
}
