import UIKit
import Anchors
import BarcodeScanner

class TutorialPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tutorial"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        let initialPage = 0
        
        let page1 = TutorialVC1()
        let page2 = TutorialVC1()
        let page3 = TutorialVC1()
        let page4 = TutorialVC1()
        let page5 = TutorialVC1()
        
        page1.imageView.image = UIImage(named: "tutorial1")
        page2.imageView.image = UIImage(named: "tutorial2")
        page3.imageView.image = UIImage(named: "tutorial3")
        page4.imageView.image = UIImage(named: "tutorial4")
        page5.imageView.image = UIImage(named: "tutorial5")
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        self.pages.append(page4)
        self.pages.append(page5)
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        navigationItem.titleView = titleLabel
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            
            guard viewControllerIndex > 0 else {
                return nil
            }
            // go to previous page in array
            return self.pages[viewControllerIndex - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            
            // This version will not allow pages to wrap around
            guard viewControllerIndex < pages.count - 1 else {
                return nil
            }
            return pages[viewControllerIndex + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    
    
}
