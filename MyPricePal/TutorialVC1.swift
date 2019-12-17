//
//  TutorialVC1.swift
//  MyPricePal
//
//  Created by Brice Redmond on 5/18/19.
//  Copyright © 2019 CS48. All rights reserved.
//
import UIKit
import Anchors

class TutorialVC1: UIViewController, UIPageViewControllerDelegate {
    
    var imageView = UIImageView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        
        activate(
            imageView.anchor.right.equal.to(view.anchor.right),
            imageView.anchor.left.equal.to(view.anchor.left),
            imageView.anchor.bottom.equal.to(view.anchor.bottom)
        )
        if #available (iOS 11.0, *){
            activate(
                imageView.anchor.top.equal.to(view.safeAreaLayoutGuide.anchor.top))
        }else{
            activate(
                imageView.anchor.top.equal.to(view.anchor.top))
        }
    }
}
