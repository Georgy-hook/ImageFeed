//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Georgy on 28.05.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
}
private extension ImagesListCell{
    private var gradient: CAGradientLayer{
        let gradient = CAGradientLayer()
        let blue = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0)
        let green = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        gradient.colors = [blue.cgColor, green.cgColor]
        gradient.locations = [0, 1]
        gradient.frame = CGRect(x: 0, y: 0, width: self.gradientView.frame.size.width, height: self.gradientView.frame.size.height)
        return gradient
    }
    private func configure(){
        likeButton.setTitle("", for: .normal)
        imageCell.layer.cornerRadius = 16
        imageCell.layer.masksToBounds = true
        gradientView.layer.addSublayer(gradient)
    }
}
