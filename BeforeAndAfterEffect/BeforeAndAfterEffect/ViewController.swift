//
//  ViewController.swift
//  BeforeAndAfterEffect
//
//  Created by 김정민 on 7/13/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var revealImageView: RevealImageView = {
        let imageView = RevealImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.setup()        
    }

    private func setup() {
        guard let beforeImage = UIImage(named: "before"),
              let afterImage = UIImage(named: "after")
        else { return }
        
        revealImageView.beforeImage = beforeImage
        revealImageView.afterImage = afterImage
        
        self.view.addSubview(self.revealImageView)
        
        NSLayoutConstraint.activate([
            self.revealImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            self.revealImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            self.revealImageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.revealImageView.heightAnchor.constraint(equalTo: revealImageView.widthAnchor, multiplier: beforeImage.size.height / beforeImage.size.width)
        ])
    }
}

class RevealImageView: UIImageView {
    
    private let leftImageLayer = CALayer()
    private let maskLayer = CALayer()
    private let lineView = UIView()
    
    private var percentage: CGFloat = 0.5 {
        didSet {
            self.updateView()
        }
    }
    
    public var beforeImage: UIImage? {
        didSet {
            if let beforeImage {
                self.leftImageLayer.contents = beforeImage.cgImage
            }
        }
    }
    
    public var afterImage: UIImage? {
        didSet {
            if let afterImage {
                self.image = afterImage
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.leftImageLayer.frame = self.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let location = firstTouch.location(in: self)
        self.percentage = location.x / bounds.width
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        let location = firstTouch.location(in: self)
        self.percentage = location.x / bounds.width
    }
    
    private func commonInit() {
        // any opaque color
        self.maskLayer.backgroundColor = UIColor.black.cgColor
        self.leftImageLayer.mask = self.maskLayer
        
        // the "reveal" image layer
        self.layer.addSublayer(self.leftImageLayer)
        
        // the vertical line
        self.lineView.backgroundColor = .lightGray
        self.addSubview(self.lineView)
        
        self.isUserInteractionEnabled = true
    }
    
    private func updateView() {
        // move the vertical line to the touch point
        self.lineView.frame = CGRect(
            x: self.bounds.width * percentage,
            y: self.bounds.minY,
            width: 1,
            height: self.bounds.height
        )
        
        // update the "before image" mask to the touch point
        var rectangle = self.bounds
        rectangle.size.width = self.bounds.width * self.percentage
        
        // disable layer animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.maskLayer.frame = rectangle
        CATransaction.commit()
    }
}
