//
//  ViewController.swift
//  InfinitePageView
//
//  Created by hli on 13/02/2017.
//  Copyright © 2017 hli. All rights reserved.
//

import UIKit

class CustomView: InfinitePageView, InfinitePageViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        
        self.delegate = self
        
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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let customView = CustomView()
        self.view.addSubview(customView)
        
        customView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

