//
//  PopularArticlesViewModel.swift
//  NY Times
//
//  Created by Farhan on 17/01/2023.
//

import Foundation
import UIKit

class PopularArticlesViewModel {
    
    var articles = [PopularArticleDataModel]()
    
    func registerTableViewCell(for tableView: UITableView) {
        tableView.register(ArticlePreviewTableViewCell.nib,
                           forCellReuseIdentifier: ArticlePreviewTableViewCell.identifier)
    }
    
    func getData(completion: @escaping () -> ()) {
        NetworkManager.shared.fetchGenericData(endPoint: .popularArticle) { [weak self] (response: RootPopularArticleDataModel?, error) in
            guard let self = self,
                  let articles = response?.results else { return }
            
            self.articles = articles
            
            completion()
        }
    }
}
