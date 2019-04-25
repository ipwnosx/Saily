//
//  Saily_UI_Manage.swift
//  
//
//  Created by Lakr Aream on 2019/4/21.
//

import UIKit

import FloatingPanel

class Saily_UI_Manage: UIViewController, FloatingPanelControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var data_source = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_source.count + 2
    }
    
    var cells_identify_index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (indexPath.row > data_source.count - 1) {
            return cell
        }
        
        cell.textLabel?.text = "         " + data_source[indexPath.row].split(separator: " ")[1].description
        if (data_source[indexPath.row].split(separator: " ").count >= 3) {
            var index = 0
            var read = ""
            for item in data_source[indexPath.row].split(separator: " ") {
                if (index < 3) {
                    index += 1
                }else{
                    read = read + " " + item.description
                }
            }
            cell.detailTextLabel?.text = "            " + read.dropFirst().description
        }else{
            cell.detailTextLabel?.text = "No description"
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(14)
            c.right.equalTo(cell.textLabel!.snp.left).offset(26)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        let next = UIImageView()
        next.image = #imageLiteral(resourceName: "next.png")
        cell.addSubview(next)
        next.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(23)
            c.right.equalTo(cell.snp.right).offset(-16)
            c.width.equalTo(14)
            c.height.equalTo(14)
        }
        
        return cell
    }
    

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
        
        if (Saily.daemon_online) {
            if let dpkgread = Saily_FileU.simple_read(Saily.files.queue_root + "/dpkgl.out") {
                let splited = dpkgread.split(separator: "\n").dropFirst(5)
                for item in splited {
                    if (item.description.uppercased().contains("iphoneos-arm virtual GraphicsServices dependency".uppercased())) {
                        // DANGEROUS PACKAGE
                    }else{
                        self.data_source.append(item.description)
                    }
                }
            }
        }else{
            self.tableView.separatorColor = .clear
            let image = UIImageView.init(image: #imageLiteral(resourceName: "mafumafu_dead_rul.png"))
            image.contentMode = .scaleAspectFit
            self.view.addSubview(image)
            image.snp.makeConstraints { (x) in
                x.center.equalTo(self.view)
                x.width.equalTo(128)
                x.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: - 0xbadacce44dae880\nBAD LAUNCH DAEMON STATUS")
            non_connection.textColor = .gray
            non_connection.numberOfLines = 2
            non_connection.textAlignment = .center
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.view.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.view.snp.centerX)
                x.top.equalTo(image.snp.bottom).offset(28)
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
