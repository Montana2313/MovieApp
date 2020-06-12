//
//  SimilarMoviesCell.swift
//  MovieApp
//
//  Created by Mac on 8.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class SimilarMoviesCell: UICollectionViewCell {
    private let movieImageView = UIImageView(image: UIImage(named: "cinema.png"))
    private let movieTitle = UILabel()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = ColorConfigration.lightmodeBackgrounColor
        self.setImageView()
        self.setMovieTitle()
        if traitCollection.userInterfaceStyle == .dark{
            self.movieTitle.textColor = .white
            self.backgroundColor = ColorConfigration.darkmodeBackgroundColor
        }
    }
    private func setImageView(){
        self.movieImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 150)
        self.addSubview(self.movieImageView)
    }
    private func setMovieTitle(){
        self.movieTitle.text = "Unspecifed"
        self.movieTitle.font = UIFont(name: "Helvetica", size: 15.0)
        self.movieTitle.frame = CGRect(x: 0, y: 160, width: self.frame.size.width, height: 30)
        self.movieTitle.textAlignment = .center
        self.movieTitle.textColor = .black
        self.addSubview(self.movieTitle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setMovie(_ movie : MovieDetail)  {
        DispatchQueue.main.async {
            let image_url = "https://image.tmdb.org/t/p/w500/"
                   self.movieTitle.text = movie.originalTitle
                   if let postPath = movie.posterPath{
                       if let url = URL(string: image_url + postPath){
                           self.movieImageView.sd_setImage(with: url, completed: nil)
                       }
                   }
        }
    }
    
}
