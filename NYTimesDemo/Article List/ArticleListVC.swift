//
//  ArticleListVC.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import SafariServices
import UIKit

final class ArticleListVC: UIViewController, StoryboardableInitProtocol {
    var viewModel: ArticleListVMProtocol! = ArticleListVM()

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ArticleListTVC.self,
                               fromNib: true)
            tableView.tableFooterView = UIView()
        }
    }

    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = UIColor.gray
        loader.center = view.center
        view.addSubview(loader)
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        assert(viewModel != nil, "Viewmodel should not be nil")
        title = "Popular Articles"
        addViewModelObserver()
        viewModel.loadArticles()
    }

    fileprivate func addViewModelObserver() {
        viewModel.state.valueChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.loader.startAnimating()

            case .loadingComplete:
                self.tableView.reloadData()
                self.loader.stopAnimating()

            case let .loadingError(error):
                self.showMessage(error?.localizedDescription ?? "Something went wrong")
                self.loader.stopAnimating()

            default:
                break
            }
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension ArticleListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(with: ArticleListTVC.self,
                                                          for: indexPath)
        if let tvcViewModel = viewModel.viewModelForCellAt(section: indexPath.section,
                                                           index: indexPath.row) {
            tableViewCell.configureSubviewsContentWith(viewModel: tvcViewModel)
        }
        return tableViewCell
    }
}

extension ArticleListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        let conf = SFSafariViewController.Configuration()
        guard let articleURLStr = viewModel.articles[indexPath.row].url,
              let articleURL = URL(string: articleURLStr) else {
            return
        }
        conf.barCollapsingEnabled = false
        let webVC = SFSafariViewController(url: articleURL,
                                           configuration: conf)
        present(webVC,
                animated: true,
                completion: nil)
    }
}
