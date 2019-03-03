import UIKit

class DrawerViewController: UIViewController {
    let tableViewData = [
        "🙎🏽‍♂️ Profile",
        "📃 Receipts",
        "🌟 Rewards",
        "🗓 Bookings"
    ]
    
    lazy var headerView: DrawerTableViewHeader = {
        let header = DrawerTableViewHeader(profileImage: UIImage(named: "pic"))
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        var topConstraint: NSLayoutConstraint?
        if #available(iOS 11.0, *) {
            topConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        } else {
            topConstraint = headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor)
        }
        [headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        headerView.heightAnchor.constraint(equalToConstant: 150),
        topConstraint].compactMap{ $0 }.forEach { $0.isActive = true }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DrawerTableViewCell.self, forCellReuseIdentifier: DrawerTableViewCell.identifier)
    }
}

extension DrawerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrawerTableViewCell.identifier, for: indexPath) as? DrawerTableViewCell
            else { return UITableViewCell() }
        return cell
    }
}

extension DrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = tableViewData[indexPath.item]
    }
}

class DrawerTableViewHeader: UIView {
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(profileImage: UIImage?) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupProfileImage(with: profileImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProfileImage(with image: UIImage?) {
        addSubview(profileImageView)
        [profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -(bounds.width / 4)),
         profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
         profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
         profileImageView.widthAnchor.constraint(equalTo: profileImageView
            .heightAnchor)].forEach { $0.isActive = true }
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.clipsToBounds = true
    }
}

class DrawerTableViewCell: UITableViewCell {
    static let identifier = "cellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
