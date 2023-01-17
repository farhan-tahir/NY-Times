//
//  PopularArticlesViewController.swift
//  NY Times
//
//  Created by Farhan Tahir on 1/16/23.
//

import UIKit

class PopularArticlesViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: Properties
    var viewModel = PopularArticlesViewModel()

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: Update UI
    private func updateUI() {
        viewModel.registerTableViewCell(for: tableView)
        viewModel.getData() { self.tableView.reloadData() }
    }
    
}

//MARK: - UITable View Delegate & Data Sourece Implementation
extension PopularArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticlePreviewTableViewCell.identifier, for: indexPath) as? ArticlePreviewTableViewCell else { return UITableViewCell() }

        let article = viewModel.articles[indexPath.row]
        cell.configureData(article: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let nextVM = ArticleDetailViewModel(article: article)
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: ArticleDetailViewController.identifier) as? ArticleDetailViewController else { return }
        nextVC.viewModel = nextVM
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticlePreviewTableViewCell.height
    }
}
