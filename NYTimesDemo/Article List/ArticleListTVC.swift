//
//  ArticleListTVC.swift
//  NYTimesDemo
//
//  Created by mukesh on 20/9/21.
//

import UIKit

struct ArticleListTVCVM: UISubviewModelProtocol {
    var image: String?
    var title: String?
    var author: String?
    var publishedAt: String?

    init() {}
}

class ArticleListTVC: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAuthor: UILabel!
    @IBOutlet var lblPublished: UILabel!
    @IBOutlet var imgArticle: UIImageView!
    @IBOutlet var stackViewContainer: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
}

extension ArticleListTVC: UISubviewConfigureProtocol {
    func configureSubviewsContentWith(viewModel: UISubviewModelProtocol) {
        guard let viewModel = viewModel as? ArticleListTVCVM else { return }
        lblTitle.text = viewModel.title
        lblAuthor.text = viewModel.author
        lblPublished.text = viewModel.publishedAt
        if let imgURLStr = viewModel.image {
            imgArticle.isHidden = false
            imgArticle.downloadImageFromURL(imgURLStr)
        } else {
            imgArticle.isHidden = true
        }
    }
}
