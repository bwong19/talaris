//
//  CheckViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
    var result: Double?
    var sit2stand: Double?
    
    public init(result: Double, sit2stand: Double) {
        super.init(nibName: nil, bundle: nil)
        self.result = result
        self.sit2stand = sit2stand
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        // display TUG time
        let statusText = UILabel()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.text = String(format: "Your TUG time was %.1lf seconds. Your sit-to-stand duration is %.1lf seconds", result ?? 0.0, sit2stand ?? 0.0)
        statusText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        statusText.numberOfLines = 3
        statusText.textAlignment = .center
        statusText.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(statusText)
        statusText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        statusText.centerYAnchor.constraint(equalTo:self.view.topAnchor, constant: 150).isActive = true
        statusText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        statusText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let yesNoStackView = UIStackView()
        yesNoStackView.translatesAutoresizingMaskIntoConstraints = false
        yesNoStackView.axis = .vertical
        yesNoStackView.spacing = 10
        yesNoStackView.distribution = .fillEqually
        self.view.addSubview(yesNoStackView)
        yesNoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        yesNoStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        yesNoStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        yesNoStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        // yes button
        let yesButton = CustomButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        yesButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        yesButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(yesButton)
        
        // no button
        let noButton = CustomButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        noButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        noButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(noButton)
        
        //
        let questionText = UILabel()
        questionText.translatesAutoresizingMaskIntoConstraints = false
        questionText.text = String(format: "Was the test completed properly?", result ?? 0.0)
        questionText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        questionText.numberOfLines = 0
        questionText.textAlignment = .center
        questionText.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(questionText)
        questionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        questionText.topAnchor.constraint(equalTo: yesNoStackView.topAnchor, constant: -80).isActive = true
        questionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        questionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
    }
    
    @objc func backToHome() {
        self.navigationController!.pushViewController(WelcomeViewController(), animated: true)
    }
    
    @objc func restart() {
        self.navigationController!.pushViewController(TestViewController(), animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
