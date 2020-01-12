
import UIKit
import Firebase
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var backGroundLogo: UILabel!
    @IBOutlet weak var Logo: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)

        
        bannerLabel.text = ""
              var charIndex = 0.0
        let titleText = const.mainText
              for letter in titleText{
        
                  Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false) { (timer) in
                      self.bannerLabel.text?.append(letter)

                  }
                  charIndex += 1
              }
        
        backGroundLogo.text = ""
        Logo.text = ""
        let logoText = const.appName
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.backGroundLogo.text?.append(logoText)
            self.Logo.text?.append(logoText)
        }
        
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text{
               
                   Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                       if let e = error {
                           print(e)
                       }else{
                        print("로그인 성공")
                        
                        self?.performSegue(withIdentifier: const.toMainTableView, sender: self)
                        
                       }
               }
           }
        
    }
    
    
    
}
