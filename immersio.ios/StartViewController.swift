//
//  ViewController.swift
//  immersio.ios
//
//  Created by Rohan Garg on 2020-08-13.
//  Copyright © 2020 Immersio. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class StartViewController: UIViewController {

    let googleSignInButton = UIButton()
    
    @IBAction func googleSignInInside(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID =  "345344636247-s25kp327qu1ntjqgtotoph2o80a2762v.apps.googleusercontent.com"

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

        
        // GIDSignIn.sharedInstance()?.signIn() will throw an exception if not set.
        
        view.addSubview(googleSignInButton)
        googleSignInButton.setTitle("Google Sign In", for: .normal)
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInButtonTap), for: .touchUpInside)
        googleSignInButton.tintColor = UIColor.black
    }
    @objc private func onGoogleSignInButtonTap() {
           GIDSignIn.sharedInstance()?.signIn()
       }


}

extension StartViewController: GIDSignInDelegate {
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // A nil error indicates a successful login
        googleSignInButton.isHidden = error == nil
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        print(email)
        [self.performSegue(withIdentifier: "SigntoHome", sender: self)]
    }
    func signIn(_ signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
      self.present(viewController, animated: true, completion: nil)
    }
}
