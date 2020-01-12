import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
        
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {

             Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                 if let e = error {
                     print(e.localizedDescription)
                 } else {
                    print("회원가입 성공")
                    self.dismiss(animated: true, completion: nil)
                 }
             }
             
         }
        self.view.makeToast("가입되었습니다.", duration: 2.0, position: .bottom)
    }
    
}
