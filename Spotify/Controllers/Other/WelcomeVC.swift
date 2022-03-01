//
//  WelcomeVC.swift
//  Spotify
//
//  Created by mohamedSliem on 1/29/22.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let SignInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In With Spotify", for:.normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Spotify"
        //self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(SignInButton)
        SignInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SignInButton.frame = CGRect(
            x: 20,
            y: view.height - 100 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 55
        )
        SignInButton.layer.cornerRadius = 25
    }
    
    @objc func signInPressed()
    {
        let vc = AuthVC()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    private func handleSignIn(success : Bool) {
        guard success else {
            let alert = view.presentAlert(title: "Oops"
                                          , message: "Something went wrong in signing in"
                                          , style: "cancel"
                                          , actionAlert: "OK"
                                          , compeltion : nil )
            
            self.present(alert , animated : true)
            return
        }
        
        let mainTabBarVC = TabBarVC()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(mainTabBarVC, animated: true)
    }
}
