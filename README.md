# InfinitePageView
A simple infinite page scroll view, writen in Swift 3.0
### Get started
Clone this git and run the demo, you'll see how to use InfinitPageView!

 1. confirm your class to protocol *UIInfinitePageViewDelegate*
 
    ```
        
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

    ```
    
  2. create an InfinitePageView instance, and customize some features
  
    ```
        let customVerticalView = UIInfinitePageView()
        customVerticalView.delegate = self
        customVerticalView.scrollDirection = .vertical
        customVerticalView.duringTime = 3.0

    ```

  3. add this view to your wrapper view's subviews, and set the frame or the constaints of it
  
    ```
        self.view.addSubview(customVerticalView)
        customVerticalView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(320)
        }

    ```
    
   4. reload data to inform InfinitePageView that you are ready to show the view
    
    ```
    customVerticalView.reloadData()
    ```
    
### GIF Demo

[demo](https://cloud.githubusercontent.com/assets/10272065/23032367/1422b9b0-f4af-11e6-8923-4ae5fd9324c3.gif)

### Custom Features
// TODO 




