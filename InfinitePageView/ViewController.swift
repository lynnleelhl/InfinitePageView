//
//  ViewController.swift
//  InfinitePageView
//
//  Created by hli on 13/02/2017.
//  Copyright © 2017 hli. All rights reserved.
//

import UIKit

class CustomView: UIInfinitePageView, UIInfinitePageViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        
        self.delegate = self
        //self.isAutoScroll = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfViews() -> Int {
        return 3
    }
    
    func InfinitePageView(viewForIndexAt index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "\(index).jpg")
        return imageView
    }
}

class ViewController: UIViewController, UIInfinitePageViewDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let customView = CustomView()
        self.view.addSubview(customView)
        customView.reloadData()
        
        let customVerticalView = UIInfinitePageView()
        customVerticalView.delegate = self
        customVerticalView.scrollDirection = .vertical
        customVerticalView.duringTime = 3.0
        self.view.addSubview(customVerticalView)
        customVerticalView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(320)
        }
        customVerticalView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of pages you have
    func numberOfViews() -> Int {
        return 3
    }
    
    // returns every page in your infinite page view
    func InfinitePageView(viewForIndexAt index: Int) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Notice: This is vertical page \(index)"
        return label
    }


}

