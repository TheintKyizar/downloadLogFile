//
//  ViewController.swift
//  DownloadLogFile
//
//  Created by Theint Kyizar on 27/10/17.
//  Copyright © 2017 Theint Kyizar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        /*let label = UILabel(frame: CGRect(x:scrollView.contentOffset.x, y:scrollView.contentOffset.y, width:scrollView.frame.size.width, height:scrollView.frame.size.height))*/
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.988, green: 0.431, blue: 0.318, alpha: 1.0)
        label.textColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        label.backgroundColor = UIColor(red: 0.988, green: 0.431, blue: 0.318, alpha: 1.0)
        let fullscreen = UIScreen.main.bounds
        self.scrollView.contentSize = CGSize(width:fullscreen.width, height:fullscreen.height*2.0)
        self.scrollView.addSubview(label)
        let maxSize = CGSize(width: 150, height: 1000)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: size)
        label.text = " Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

