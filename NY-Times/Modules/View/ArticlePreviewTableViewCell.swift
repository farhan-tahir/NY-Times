//
//  ArticlePreviewTableViewCell.swift
//  NY Times
//
//  Created by Farhan Tahir on 1/16/23.
//

import UIKit

class ArticlePreviewTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var publishedDateLabel: UILabel!
    @IBOutlet weak private var coverImageView: UIImageView!
    
    //MARK: Properties
    static let height: CGFloat = 120

    //MARK: Nib Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: Configuration
    func configureData(article: PopularArticleDataModel) {
        titleLabel.text = article.title
        descriptionLabel.text = article.abstract
        authorNameLabel.text = article.author
        publishedDateLabel.text = article.publishedDate
        
        if let media = article.media {
            if media.count > 0 {
                if let data = media[0].mediaMetadata {
                    if data.count > 0 {
                        let urlString = data[data.count - 1].url
                        coverImageView.loadImage(from: urlString)
                    }
                }
            }
        }
    }
    
}
