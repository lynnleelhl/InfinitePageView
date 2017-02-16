//
//  InfinitePageView.swift
//  InfinitePageView
//
//  Created by hli on 8/9/16.
//  Copyright © 2016 hli. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MSWeakTimer

public enum UIInfinitePageViewScrollDirection {
    case vertical
    case horizontal
}

public protocol UIInfinitePageViewDelegate {
    func numberOfViews() -> Int
    func InfinitePageView(viewForIndexAt index: Int) -> UIView
}

open class UIInfinitePageView: UIView, UIScrollViewDelegate {

    open var scrollDirection: UIInfinitePageViewScrollDirection = UIInfinitePageViewScrollDirection.horizontal
    fileprivate var viewList = [UIView]()
    open var delegate: UIInfinitePageViewDelegate?

    open var isAutoScroll: Bool = true {
        didSet {
            if isAutoScroll == false {
                self.timer = nil
            } else {
                self.initTimer()
            }
        }
    }
    
    open var duringTime: TimeInterval = 5.0 {
        didSet {
            self.timer = nil
            self.initTimer()
        }
    }
    
    fileprivate var timer: MSWeakTimer?
    open var animationTime: TimeInterval = 0.5

    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        self.addSubview(view)
        return view
    }()

    open lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.isUserInteractionEnabled = false
        pc.currentPageIndicatorTintColor = UIColor.white
        //pc.pageIndicatorTintColor = UIColor.color
        pc.autoresizingMask = .flexibleTopMargin
        self.addSubview(pc)
        return pc
    }()
    
    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0.0)
        }

        self.pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(-16.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(5.0)
        }

        self.initTimer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func reloadData() {
        
        self.setNeedsLayout()
        self.layoutIfNeeded()

        for view in self.viewList {
            view.removeFromSuperview()
        }
        self.viewList.removeAll()
        
        if let delegate = self.delegate {
            let num = delegate.numberOfViews()
            if num <= 1 {
                for i in 0..<num {
                    let view = delegate.InfinitePageView(viewForIndexAt: i)
                    self.viewList.append(view)
                    view.frame = CGRect(x: 0, y: 0,
                                        width: self.frame.width,
                                        height: self.frame.height)
                    self.scrollView.addSubview(view)
                }
                self.pageControl.isHidden = true
            } else {
                if self.scrollDirection == UIInfinitePageViewScrollDirection.horizontal {

                    let view0 = delegate.InfinitePageView(viewForIndexAt: num-1)
                    self.viewList.append(view0)
                    view0.frame = CGRect(x: 0, y: 0,
                                         width: self.frame.width, height: self.frame.height)
                    self.scrollView.addSubview(view0)
                    
                    for i in 0..<num {
                        let view = delegate.InfinitePageView(viewForIndexAt: i)
                        self.viewList.append(view)
                        view.frame = CGRect(x: CGFloat(i+1) * self.frame.width, y: 0,
                                            width: self.frame.width, height: self.frame.height)
                        self.scrollView.addSubview(view)
                    }
                    
                    let view1 = delegate.InfinitePageView(viewForIndexAt: 0)
                    self.viewList.append(view1)
                    view1.frame = CGRect(x: CGFloat(self.viewList.count - 1) * self.frame.width, y: 0,
                                         width: self.frame.width, height: self.frame.height)
                    self.scrollView.addSubview(view1)

                    self.scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(self.viewList.count), height: self.frame.height)
                    self.scrollView.contentOffset = CGPoint(x: self.frame.width * 1.0, y: 0);
                    
                    self.pageControl.isHidden = false
                } else {

                    let view0 = delegate.InfinitePageView(viewForIndexAt: num-1)
                    self.viewList.append(view0)
                    view0.frame = CGRect(x: 0, y: 0,
                                         width: self.frame.width, height: self.frame.height)
                    self.scrollView.addSubview(view0)

                    for i in 0..<num {
                        let view = delegate.InfinitePageView(viewForIndexAt: i)
                        self.viewList.append(view)
                        view.frame = CGRect(x: 0, y: CGFloat(i+1) * self.frame.height,
                                            width: self.frame.width, height: self.frame.height)
                        self.scrollView.addSubview(view)
                    }

                    let view1 = delegate.InfinitePageView(viewForIndexAt: 0)
                    self.viewList.append(view1)
                    view1.frame = CGRect(x: 0, y: CGFloat(self.viewList.count - 1) * self.frame.height,
                                         width: self.frame.width, height: self.frame.height)
                    self.scrollView.addSubview(view1)

                    self.scrollView.contentSize = CGSize(width: self.frame.width,
                                                         height: self.frame.height * CGFloat(self.viewList.count))
                    // hide page control when scroll vertically
                    self.pageControl.isHidden = true
                    self.scrollView.contentOffset = CGPoint(x: 0, y: self.frame.height * 1.0);
                }
                self.pageControl.numberOfPages = num
            }
        }
    }

    func initTimer() {
        self.timer = MSWeakTimer.scheduledTimer(withTimeInterval: self.duringTime, target: self, selector: #selector(viewScroll), userInfo: nil, repeats: true, dispatchQueue: DispatchQueue.main)
    }

    // MARK: scrollView delegate
    open func scrollViewDidScroll(_ scrollView : UIScrollView) {
        if self.scrollDirection == UIInfinitePageViewScrollDirection.horizontal {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.scrollDirection == UIInfinitePageViewScrollDirection.horizontal {
            guard scrollView.frame.width != 0 else {
                return
            }
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if index == 0 {
                scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(self.viewList.count - 2), y: 0);
            } else if index == self.viewList.count - 1 {
                scrollView.contentOffset = CGPoint(x: scrollView.frame.width * 1.0, y: 0);
            }
            if index == 0 {
                self.pageControl.currentPage = self.viewList.count - 2
            } else if index == self.viewList.count - 1 {
                self.pageControl.currentPage = 0
            } else {
                self.pageControl.currentPage = index - 1
            }
        } else {
            guard scrollView.frame.height != 0 else {
                return
            }
            let index = Int(scrollView.contentOffset.y / scrollView.frame.height)
            if index == 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.frame.height * CGFloat(self.viewList.count - 2));
            } else if index == self.viewList.count - 1 {
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.frame.height * 1.0);
            }
        }
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.tolerance = Double.infinity
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.timer?.tolerance = self.duringTime
    }

    open func viewScroll() {

        if self.viewList.count <= 3 {
            self.timer?.invalidate()
            self.timer = nil
            return
        }

        if self.scrollDirection == UIInfinitePageViewScrollDirection.horizontal {
            UIView.animate(withDuration: self.animationTime, animations: { [weak self] in
                self?.scrollView.contentOffset = CGPoint(x: (self?.scrollView.contentOffset.x ?? 0) + (self?.frame.width ?? 0), y: 0)
            })
        } else {
            UIView.animate(withDuration: self.animationTime, animations: { [weak self] in
                self?.scrollView.contentOffset = CGPoint(x: 0, y: (self?.scrollView.contentOffset.y ?? 0) + (self?.frame.height ?? 0))
            })
        }
        self.scrollViewDidEndDecelerating(self.scrollView)

    }
}
