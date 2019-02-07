//  Copyright © 2019 Frulwinn. All rights reserved.

import UIKit

class ActivitiesDetailVC: UIViewController {
    
    //MARK: - Properties
    var journalController: JournalController?
    var activity: Activity? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var activityTextField: UITextField!
    //rating
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    //engagement
    @IBOutlet weak var engagementView: UIView!
    @IBOutlet weak var engagementLabel: UILabel!
    @IBOutlet weak var engagementTextField: UITextField!
    //enjoyment
    @IBOutlet weak var enjoymentView: UIView!
    @IBOutlet weak var enjoymentLabel: UILabel!
    @IBOutlet weak var enjoymentTextField: UITextField!
    //energy
    @IBOutlet weak var energyView: UIView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var energyTextField: UITextField!
    
    //save
    @IBAction func save(_ sender: Any) {
        guard let name = activityTextField.text, !name.isEmpty,
            let engagement = engagementTextField.text, !engagement.isEmpty,
            let engagementInt = Int(engagement),
            let enjoymentRating = enjoymentTextField.text, !enjoymentRating.isEmpty,
            let enjoymentRatingInt = Int(enjoymentRating),
            let energyLevel = energyTextField.text, !energyLevel.isEmpty,
            let energyLevelInt = Int(energyLevel) else { return }

        if let activity = activity {
            journalController?.updateActivity(activity: activity, name: name, engagement: engagementInt, enjoymentRating: enjoymentRatingInt, energyLevel: energyLevelInt, fk: 1, completion: { (error) in
                if let error = error {
                    NSLog("Could not update activity: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            //get default fk and place it here
            journalController?.createActivity(name: name, engagement: engagementInt, enjoymentRating: enjoymentRatingInt, energyLevel: energyLevelInt, fk: 1, completion: { (error) in
                if let error = error {
                    NSLog("Could not create activity: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setTheme()
    }
    
    func updateViews() {
        if isViewLoaded {
            guard let activity = activity else {
                title = "create activity log"
                return
            }
            title = activity.name
            activityTextField.text = activity.name
            engagementTextField.text = String(activity.engagement)
            enjoymentTextField.text = String(activity.enjoymentRating)
            energyTextField.text = String(activity.energyLevel)
        }
    }
    
    func setTheme() {
        //textfield
        engagementView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        engagementLabel.textColor = .darkBlue
        engagementTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        engagementTextField.textColor = .skyBlue
        engagementTextField.font = Appearance.montserratRegularFont(with: .body, pointSize: 15)
        
        enjoymentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        enjoymentLabel.textColor = .darkBlue
        enjoymentTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        enjoymentTextField.textColor = .skyBlue
        enjoymentTextField.font = Appearance.montserratRegularFont(with: .body, pointSize: 15)
        
        energyView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        energyLabel.textColor = .darkBlue
        energyTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        energyTextField.textColor = .skyBlue
        energyTextField.font = Appearance.montserratRegularFont(with: .body, pointSize: 15)
        
        activityTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        activityTextField.textColor = .skyBlue
        activityTextField.font = Appearance.montserratRegularFont(with: .body, pointSize: 15)
        
        ratingView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        ratingLabel.textColor = .darkBlue
        ratingLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        
        oneLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        oneLabel.textColor = .darkBlue
        
        twoLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        twoLabel.textColor = .darkBlue
        
        threeLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        threeLabel.textColor = .darkBlue
        
        fourLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        fourLabel.textColor = .darkBlue
        
        fiveLabel.font = Appearance.montserratRegularFont(with: .body, pointSize: 10)
        fiveLabel.textColor = .darkBlue
        
        view.backgroundColor = .white
    }
}
