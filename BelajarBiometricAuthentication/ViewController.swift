//
//  ViewController.swift
//  BelajarBiometricAuthentication
//
//  Created by Muhammad Rajab Priharsanto on 17/09/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//

//Part 4
import UIKit
import LocalAuthentication

//Part 11
class ViewController: UIViewController
{
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var faceIDLabel: UILabel!
            
    // An authentication context stored at class scope so it's available for use during UI updates.
    var context = LAContext()
    
    //Part 12
    /// The current authentication state.
    var state = AuthenticationState.loggedout
    {
        // Update the UI on a change.
        didSet
        {
            //Part 6
            loginButton.isHighlighted = state == .loggedin  // The button text changes on highlight.
            stateView.backgroundColor = state == .loggedin ? .green : .red
            // FaceID runs right away on evaluation, so you might want to warn the user.
            //  In this app, show a special Face ID prompt if the user is logged out, but
            //  only if the device supports that kind of authentication.
            faceIDLabel.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
    }
    
    //Part 3
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // The biometryType, which affects this app's UI when state changes, is only meaningful
        //  after running canEvaluatePolicy. But make sure not to run this test from inside a
        //  policy evaluation callback (for example, don't put next line in the state's didSet
        //  method, which is triggered as a result of the state change made in the callback),
        //  because that might result in deadlock.
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
        //Part 7
        // Set the initial app state. This impacts the initial state of the UI as well.~
        state = .loggedout
    }
    
    //Part 8
    @IBAction func tapButton(_ sender: UIButton) 
    {
        //Part 1
        if state == .loggedin
        {
            // Log out immediately.
            state = .loggedout
        
        //Part 13
        }
        else
        {
            // Get a fresh context for each login. If you use the same context on multiple attempts
            //  (by commenting out the next line), then a previously successful authentication
            //  causes the next policy evaluation to succeed without testing biometry again.
            //  That's usually not what you want.
            context = LAContext()
            context.localizedCancelTitle = "Enter Username/Password"
        
        //Part 9
            // First check if we have the needed hardware support.
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
            {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                
                //Part 2
                if success
                {
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                    self.state = .loggedin
                    }
                //Part 14
                }
                else
                {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    // Fall back to a asking for username and password.
                    // ...
                }}
                //Part 10
                }
            else
            {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                // Fall back to a asking for username and password.
                // ...
            }
            }
        }
}

//Part 5
/// The available states of being logged in or not.
enum AuthenticationState
{
    case loggedin, loggedout
}
