//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Georgy on 24.07.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
