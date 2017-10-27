//
//  ViewController.swift
//  DownloadLogFile
//
//  Created by Theint Kyizar on 27/10/17.
//  Copyright © 2017 Theint Kyizar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var nextbutton: UIButton!
    
    @IBAction func donebutton(_ sender: UIButton) {
        self.scrollView.scrollToTop(animated: true)
    }
    @IBOutlet weak var donebutton: UIButton!
    @IBAction func nextbutton(_ sender: UIButton) {
    }
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    let textview  = UITextView()
    let alertController = UIAlertController(title: "Searching", message: "Please wait...\n\n", preferredStyle: .alert)
    let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        scrollView.delegate = self
        textfield.delegate = self
        textfield.backgroundColor = UIColor.lightGray
        searchBar.returnKeyType = UIReturnKeyType.go
        hideKeyboardWhenTappedAround()
        scrollView.isScrollEnabled = true
        /*let label = UILabel(frame: CGRect(x:scrollView.contentOffset.x, y:scrollView.contentOffset.y, width:scrollView.frame.size.width, height:scrollView.frame.size.height))*/
        textview.textColor = UIColor.black
        
        textview.isEditable = false
        textview.text = ""
        refreshTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(fail), name: NSNotification.Name(rawValue: "failed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(success), name: NSNotification.Name(rawValue: "success"), object: nil)
    }
    func refreshTextView() {
        textview.font = UIFont.boldSystemFont(ofSize: 16)
        let fixedWidth = scrollView.frame.size.width
        let size = textview.sizeThatFits(CGSize(width:fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var frame = textview.frame
        frame.size = CGSize(width: max(size.width, fixedWidth), height: size.height)
        textview.frame = frame
        textview.isScrollEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        //textview.backgroundColor = UIColor.lightGray
        let fullscreen = UIScreen.main.bounds
        self.scrollView.contentSize = CGSize(width:fullscreen.width, height:textview.frame.height+2)
        self.scrollView.addSubview(textview)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        spinnerIndicator.center = CGPoint(x: 135.0, y: 80.0)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        let filename = searchBar.text
        downloadLogFile(filename: filename!)
        self.present(alertController, animated: false, completion: nil)
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let searchString = self.textfield.text
        let baseString = self.textview.text
        let attributed = NSMutableAttributedString(string: baseString!)
        //let error: NSError?
        do {
            let regex = try NSRegularExpression(pattern: searchString!, options: .caseInsensitive)
            for match in regex.matches(in: baseString!, options: [], range: NSRange(location: 0, length: (baseString?.utf16.count)!)) as [NSTextCheckingResult] {
                attributed.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.yellow, range: match.range)
            }
        }
        catch{
            print(error)
        }
                textview.attributedText = attributed
                self.refreshTextView()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate) {
           
        }
        else {
       
        }
    }
    @objc func fail() {
        self.alertController.dismiss(animated: false, completion: nil)
        self.displayAlert(title: "Failed", message: "Filename incorrect or download error")
        
    }
    @objc func success() {
        self.alertController.dismiss(animated: false, completion: nil)
        //self.displayAlert(title: "LOGIN FAILED", message: "Username or password incorrect!")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func downloadLogFile(filename: String){
        let parameters: [String: Any] = [
            "filename": filename
        ]
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("haha.txt")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let URLDownLogFile = "http://188.166.247.154/atk-ble//api/web/index.php/v1/site/download"
        
        Alamofire.download(URLDownLogFile, method: .post, parameters: parameters, to: destination).response {
            response in
            let cacheDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileurl = cacheDirURL.appendingPathComponent("haha").appendingPathExtension("txt")
            //let pathString = fileurl.path
            let filename = fileurl.lastPathComponent
            print("File Path: \(fileurl.path)")
            print("File name: \(filename)")
            var readString = ""
            do{
                readString = try String(contentsOf: fileurl)
            }
            catch let error as NSError {
                print("Failed to read file")
                print(error)
              
            }
            if(response.response?.statusCode == 200) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "success"), object: nil)
                self.textview.text = readString
                self.refreshTextView()
            }
            else {
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "failed"), object: nil)
                self.textview.text = ""
                self.refreshTextView()
            }
            print("~~~~~~~~~~~~~~~`Contents of file \(readString)")
            
            /////////////////////////////////////
            print("Response\(response)")
            if let path = response.destinationURL?.path {
                
                let data = FileManager.default.contents(atPath: path)
                print("Data\(String(describing: data))")
            }
            
        }
    }

}
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
}
    func displayAlert(title:String,message:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
}
