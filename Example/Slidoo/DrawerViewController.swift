import UIKit

class DrawerViewController: UIViewController {
    private let tableViewData = [
        "🙎🏽‍♂️ Profile",
        "📃 Receipts",
        "🌟 Rewards",
        "🗓 Bookings"
    ]
    
    private lazy var headerView: DrawerTableViewHeader = {
        let header = DrawerTableViewHeader(profileImage: UIImage(named: "pic"))
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
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
        tableView.backgroundColor = .darkGray
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
