//
//  CareKitTabsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CareKit
import Firebase
import FirebaseDatabase


class CareKitTabsViewController: UITabBarController, OCKSymptomTrackerViewControllerDelegate, UITabBarControllerDelegate, GaitTestDelegate
 {
    private let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager
    private let carePlanData: CarePlanData
    private let ref: DatabaseReference
    
    // used to access field 'lastSelectedAssessmentEvent' in CheckViewController in order to save that a test has been finished
    // TODO: refactor to avoid this 'hidden' dependency (As it's not explicitly passed into CheckViewController, but still required)
    static var gaitTrackerViewController : OCKSymptomTrackerViewController?
    
    private let user: User
    
    public init(user: User) {
        carePlanData = CarePlanData(carePlanStore: carePlanStoreManager.store)
        ref = Database.database().reference()
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true

        let userInfoRef = ref.child("users").child(user.uid)
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            let userNameInfo = snapshot.value as! Dictionary<String, String>
            let gaitTrackerStack = self.createGaitTrackerStack()
            let profileStack = self.createProfileStack()
            let connectStack = self.createConnectStack(userInfo: userNameInfo)
            let settingsStack = self.createSettingsStack()
            
            let tabBarList = [gaitTrackerStack, profileStack, connectStack, settingsStack]
            
            self.viewControllers = tabBarList.map {
                UINavigationController(rootViewController: $0)
            }
            
            self.title = self.selectedViewController?.tabBarItem.title
        })
    }
    
    private func createGaitTrackerStack() -> UIViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: carePlanStoreManager.store)
        CareKitTabsViewController.gaitTrackerViewController = viewController
        viewController.delegate = self
        viewController.glyphType = .custom
        viewController.customGlyphImageName = "tug"
        viewController.glyphTintColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        viewController.tabBarItem = UITabBarItem(title: "Gait Tracker", image: UIImage(named: "walking"), selectedImage: UIImage.init(named: "walking"))
        
        return viewController
    }
    
    private func createProfileStack() -> UIViewController {
        let viewController = MetricGraphsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage.init(named: "profile"))
        return viewController
    }
    
    private func createConnectStack(userInfo: Dictionary<String, Any>) -> UIViewController {
        let viewController = OCKConnectViewController(contacts: carePlanData.contacts)
        
        let firstName: String = userInfo["first-name"] as! String
        let lastName: String = userInfo["last-name"] as! String
        let fullName = "\(firstName) \(lastName)"
        let monogram = "\(firstName.prefix(1))\(lastName.prefix(1))"
        
        viewController.patient = OCKPatient(identifier: fullName, carePlanStore: carePlanStoreManager.store, name: fullName, detailInfo: nil, careTeamContacts: nil, tintColor: nil, monogram: monogram, image: nil, categories: nil, userInfo: nil)
        viewController.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "Connect-OFF"), selectedImage: UIImage.init(named: "Connect-ON"))
        return viewController
    }
    
    private func createSettingsStack() -> UIViewController {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings-1"), selectedImage: UIImage.init(named: "Settings-1"))
        return viewController
    }
    
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        switch assessmentEvent.activity.identifier {
            case GaitTestType.TUG.rawValue:
                self.navigationController!.pushViewController(InstructionViewController(gaitTestType: GaitTestType.TUG), animated: true)
            case GaitTestType.SixMWT.rawValue:
                self.navigationController!.pushViewController(InstructionViewController(gaitTestType: GaitTestType.SixMWT), animated: true)
            case GaitTestType.MCTSIB.rawValue:
                self.navigationController!.pushViewController(InstructionViewController(gaitTestType: GaitTestType.MCTSIB), animated: true)
            default:
                print(assessmentEvent.activity.identifier)
                print("error: could not find assesment")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        title = item.title
    }
    
    func onGaitTestComplete(resultsDict: Dictionary<String, Any>, resultsMessage: String, gaitTestType: GaitTestType, motionTracker: MotionTracker) {
        self.navigationController!.pushViewController(
            CheckViewController(
                message: resultsMessage,
                resultsDict: resultsDict,
                motionTracker: motionTracker,
                gaitTestType: gaitTestType
            ),
            animated: true
        )
    }
}
