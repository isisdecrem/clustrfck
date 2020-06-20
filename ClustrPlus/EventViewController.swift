

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var datePosted: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel:
    UILabel!
    
    
    var event: Event?
    var update: Update?
    var club: Club?
    
    
  
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var des: UILabel!
    
    
    @IBOutlet weak var location: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        clubName.text = club?.name
        
        if event != nil{
            datePosted.isHidden = true
            name.text = event?.title
            date.text = event?.date
            time.text = event?.time
            des.text = event?.extra
            location.text = event?.location
        }
        
        else if update != nil{
            datePosted.isHidden = false
            datePosted.text = update?.datePosted
            name.text = update?.title
            des.text = update?.update
            time.isHidden = true
            date.isHidden = true
            location.isHidden = true
            timeLabel.isHidden = true
            dateLabel.isHidden = true
            locationLabel.isHidden = true
            
            
        }
        
    }
    
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "memberBackClubView", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "memberBackClubView"{
               let screen = segue.destination as? MemberClubViewerViewController
               screen?.club = club
           }
    }

}
