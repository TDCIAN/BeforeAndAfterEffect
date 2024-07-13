//
//  BeforeAndAfterEffectViewController.swift
//  BeforeAndAfterEffect
//
//  Created by 김정민 on 7/13/24.
//

import UIKit

final class BeforeAndAfterEffectViewController: UIViewController {
    
    private lazy var beforeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var afterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fadeOutBeforeImageView()
    }
    
    private func setup() {
        
        guard let beforeImage = UIImage(named: "before"),
              let afterImage = UIImage(named: "after")
        else { return }
        
        self.beforeImageView.image = beforeImage
        self.afterImageView.image = afterImage
        
        self.view.addSubview(self.afterImageView)
        self.view.addSubview(self.beforeImageView)
        
        NSLayoutConstraint.activate([
            self.afterImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            self.afterImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            self.afterImageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.afterImageView.heightAnchor.constraint(equalTo: afterImageView.widthAnchor, multiplier: afterImage.size.height / afterImage.size.width),
            
            self.beforeImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            self.beforeImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            self.beforeImageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.beforeImageView.heightAnchor.constraint(equalTo: beforeImageView.widthAnchor, multiplier: beforeImage.size.height / beforeImage.size.width)
        ])
    }
    
    private func fadeOutBeforeImageView() {
        print("### Start fade out animation")
        UIView.animate(withDuration: 3.0, animations: {
            print("### End fade out animation")
            self.beforeImageView.alpha = 0
        })
    }
}
