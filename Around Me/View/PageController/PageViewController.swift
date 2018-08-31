//
//  PageViewController.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-17.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedViewControllers : [UIViewController] = {
        
        return [self.newVC(viewController: "London"),
               self.newVC(viewController: "SF"),
               self.newVC(viewController: "Rome"),
               self.newVC(viewController: "NYC")]
    }()
    
    var pageControl : UIPageControl = UIPageControl()
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 150, y: 600, width: 100, height: 100))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.blue
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstviewcontroller = orderedViewControllers.first {
            setViewControllers([firstviewcontroller], direction: .forward, animated: false, completion: nil)
        
            
        }
        self.delegate = self
        configurePageControl()
        
    }
    
    func newVC(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewController)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        
    }
    
    
    
    

   

}
