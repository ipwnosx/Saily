//
//  Saily_UI_Manage.swift
//  
//
//  Created by Lakr Aream on 2019/4/21.
//

import UIKit

import FloatingPanel

class Saily_UI_Manage: UIViewController, FloatingPanelControllerDelegate {

    var fpc: FloatingPanelController!
    var setting_plane: Saily_UI_Settings!
    
    private let image_button = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
    
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    private func setup_setting() {
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(image_button)
        image_button.setImage(#imageLiteral(resourceName: "setting_blue.png"), for: .normal)
        image_button.setImage(#imageLiteral(resourceName: "setting_gary.png"), for: .focused)
        image_button.addTarget(self, action: #selector(push_setting), for: .touchUpInside)
        // setup constraints
        image_button.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        image_button.clipsToBounds = true
        image_button.translatesAutoresizingMaskIntoConstraints = false
        
        image_button.snp.makeConstraints { (x) in
            x.right.equalTo(navigationBar.snp.right).offset(-22)
            x.bottom.equalTo(navigationBar.snp.bottom).offset(-4)
            x.height.equalTo(38)
            x.width.equalTo(38)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup_setting()
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        // Initialize FloatingPanelController and add the view
        fpc.surfaceView.backgroundColor = .clear
        fpc.surfaceView.shadowHidden = false
        
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        setting_plane = sb.instantiateViewController(withIdentifier: "Saily_UI_Settings_ID") as? Saily_UI_Settings
        
        // Set a content view controller
        fpc.set(contentViewController: setting_plane)
        fpc.track(scrollView: setting_plane?.container)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //  Add FloatingPanel to a view with animation.
            self.fpc.addPanel(toParent: self, animated: true)
            self.fpc.move(to: .tip, animated: true)
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @objc func push_setting() {
        fpc.move(to: .full, animated: true)
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return (newCollection.verticalSizeClass == .compact) ? FloatingPanelLandscapeLayout() : nil // Returning nil indicates to use the default layout
    }

}

class FloatingPanelLandscapeLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 69.0
        default: return nil
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
            surfaceView.widthAnchor.constraint(equalToConstant: 291),
        ]
    }
}
