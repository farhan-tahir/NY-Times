//
//  ArticleDetailViewController.swift
//  NY Times
//
//  Created by Farhan Tahir on 1/16/23.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var publishedDateLabel: UILabel!
    
    //MARK: Properties
    var viewModel: ArticleDetailViewModel?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let vm = viewModel else { return }
        
        titleLabel.text = vm.article?.title
        descriptionLabel.text = vm.article?.abstract
        authorNameLabel.text = vm.article?.author
        publishedDateLabel.text = vm.article?.publishedDate
    }
    
}
