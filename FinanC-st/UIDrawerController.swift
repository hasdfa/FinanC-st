//
//  UIDrawerController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 12.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class UIDrawerController: UIViewController {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            let fromEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipeFromEdge(_:)))
            fromEdge.edges = .left
            self.containerView.addGestureRecognizer(fromEdge)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    var selectedController: UIViewController? = nil {
        didSet {
            if let oldedValue = oldValue {
                hideContentController(oldedValue)
            }
            if let newValue = selectedController {
                displayContentController(newValue)
            }
        }
    }
    var selectedControllerId: String = "dashboard" {
        didSet {
            if !selectedControllerId.isEmpty,
                let controller = storyboard?.instantiateViewController(withIdentifier: selectedControllerId) {
                selectedController = controller
            }
        }
    }
    var selectedIndex: Int {
        return (controllersId.index(of: selectedControllerId) ?? -2) + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).drawerController = self
        // Что бы контейнер не мешал редактировать UITableView
        self.view.bringSubview(toFront: containerView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.backgroundColor = WalletBlueScheme.backgroundColor
        self.view.backgroundColor = WalletBlueScheme.backgroundColor
        
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedControllerId = controllers[0].storyboardId
    }
    
    let controllers: [ViewControllerModel] = [
        ViewControllerModel(id: "dashboard", title: "Dashboard", image: #imageLiteral(resourceName: "Dashboard")),
        ViewControllerModel(id: "", title: "Notifications", image: #imageLiteral(resourceName: "notifications-button")),
        ViewControllerModel(id: "", title: "Budget", image: #imageLiteral(resourceName: "pie-chart")),
        ViewControllerModel(id: "", title: "Schedudled payment", image: #imageLiteral(resourceName: "calendar")),
        ViewControllerModel(id: "", title: "Accounts", image: #imageLiteral(resourceName: "user")),
        ViewControllerModel(id: "", title: "Setting", image: #imageLiteral(resourceName: "settings")),
        ViewControllerModel(id: "", title: "Sign out", image: #imageLiteral(resourceName: "signout"))
    ]
    var controllersId: [String] {
        return controllers.flatMap { $0.storyboardId }
    }
    
    public var isOpen = false
    private var imageView: UIImageView? = nil {
        didSet {
            if imageView != nil {
                let tap = UITapGestureRecognizer(
                    target: self,
                    action: #selector(closeByTappingImage(_:))
                )
                imageView!.isUserInteractionEnabled = true
                imageView!.addGestureRecognizer(tap)
                
                let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToClose(_:)))
                swipe.direction = .left
                imageView!.addGestureRecognizer(swipe)
            }
        }
    }
    public func open(with time: Double = 0.5) {
        if imageView == nil {
            imageView = UIImageView(image: generateImage())
            
            self.view.addSubview(imageView!)
            self.view.backgroundColor = WalletBlueScheme.backgroundColor
            self.containerView.alpha = 0
        }
        
        let bounds = self.containerView.bounds
        UIView.animate(withDuration: time, animations: {
            self.imageView!.frame = CGRect(
                x: bounds.width * 0.8,
                y: bounds.height * 0.1,
                width: bounds.width * 0.8,
                height: bounds.height * 0.8
            )
        }, completion: { _ in
            self.isOpen = true
        })
    }
    @objc func closeByTappingImage(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .recognized {
            close()
        }
    }
    
    @objc func swipeToClose(_ gesture: UISwipeGestureRecognizer) {
        print("swipeToClose(_:\(gesture.direction)")
        if imageView == nil { return }
        let translation = gesture.location(in: imageView!).x / self.imageView!.bounds.width
        if gesture.state == .recognized || gesture.state == .ended {
            close(with: Double(0.5 * (1 - translation)))
            return
        } else if gesture.state == .cancelled || gesture.state == .failed {
            open(with: Double(0.5 * (1 - translation)))
            return
        }
        
        let bounds = self.containerView.bounds
        let frame = CGRect(
            x: bounds.width * 0.8 + bounds.width * 0.2 * translation,
            y: bounds.height * 0.1 - bounds.height * 0.1 * translation,
            width: bounds.width * 0.8 + (bounds.width * 0.2) * translation,
            height: bounds.height * 0.8 + (bounds.height * 0.2) * translation
        )
        self.imageView!.frame = frame
        print(frame)
    }
    
    @objc func swipeFromEdge(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if isOpen { return }
        let translation = gesture.translation(in: self.containerView).x / self.containerView.bounds.width
        if gesture.state == .recognized || gesture.state == .ended {
            open(with: Double(0.5 * (1 - translation)))
            return
        } else if gesture.state == .cancelled || gesture.state == .failed {
            close(with: Double(0.5 * (1 - translation)))
            return
        }
        
        if imageView == nil {
            imageView = UIImageView(image: generateImage())
            
            self.view.addSubview(imageView!)
            self.view.backgroundColor = WalletBlueScheme.backgroundColor
            self.containerView.alpha = 0
        }
        let bounds = self.containerView.bounds
        let frame = CGRect(
            x: 0 + bounds.width * 0.8 * translation,
            y: 0 + bounds.height * 0.1 * translation,
            width: bounds.width - (bounds.width * 0.2) * translation,
            height: bounds.height - (bounds.height * 0.2) * translation
        )
        self.imageView!.frame = frame
    }
    
    public func close(with time: Double = 0.5) {
        UIView.animate(withDuration: time, animations: {
            self.imageView?.frame = self.view.bounds
        }, completion: { _ in
            self.imageView?.removeFromSuperview()
            self.imageView = nil
            self.containerView.alpha = 1.0
            
            self.isOpen = false
            self.view.backgroundColor = UIColor.white
        })
    }
    
    func generateImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //To add child VC
    func displayContentController(_ content: UIViewController) {
        addChildViewController(content)
        content.view.frame = containerView.bounds
        containerView.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    //To remove child VC
    func hideContentController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }

}

extension UIViewController {
    var drawerViewController: UIDrawerController? {
        return (UIApplication.shared.delegate as! AppDelegate).drawerController
    }
}

extension UIDrawerController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderCell
            cell.backgroundColor = HCColors.colorPrimary
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! ItemCell
        let data = controllers[indexPath.row - 1]
        cell.itemImageView.image = data.itemImage.withRenderingMode(.alwaysTemplate)
        cell.itemImageView.tintColor = UIColor.white
        
        cell.itemLabel.text = data.itemTitle
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = HCColors.colorPrimaryDark
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.view.bounds.width,
            height: self.view.bounds.height * 0.3
        ))
        view.backgroundColor = self.tableView.backgroundColor
        return view
    }
    
}

extension UIDrawerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = controllers[indexPath.row - 1]
        if selectedControllerId != data.storyboardId {
            selectedControllerId = data.storyboardId
        }
        self.close()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64
        }
        return 48
    }
    
}

