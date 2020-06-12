//
//  MovieCell.swift
//  MovieApp
//
//  Created by Mac on 6.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    private let movieImage : UIImageView = UIImageView()
    private let movieTitle : UILabel = UILabel()
    private let movieYear : UILabel = UILabel()
    private let vote : UILabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
               super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.setupMovieTitle()
        self.setupMovieImage()
        self.setupMovieYear()
        self.setupVote()
        if traitCollection.userInterfaceStyle == .dark{
            self.movieTitle.textColor = .white
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupMovieTitle(){
        self.movieTitle.text = "Unspecified"
        self.movieTitle.textColor = .black
        self.movieTitle.font = UIFont(name: "Helvetica", size: 20.0)
        self.movieTitle.frame = CGRect(x: 100, y: 20, width: ScreenConfigration.screenWidth - 200, height: 40)
        self.addSubview(self.movieTitle)
    }
    private func setupMovieYear(){
           self.movieYear.text = "Unspecified"
           self.movieYear.textColor = .lightGray
           self.movieYear.font = UIFont(name: "Helvetica", size: 15.0)
           self.movieYear.frame = CGRect(x: 100, y: 75, width: ScreenConfigration.screenWidth - 200, height: 20)
           self.addSubview(self.movieYear)
    }
    private func setupVote(){
        self.vote.text = "0.0"
        self.vote.textColor = ColorConfigration.chartColor
        self.vote.font = UIFont(name: "Helvetica", size: 20.0)
        self.vote.frame = CGRect(x: ScreenConfigration.screenWidth - 80, y: 35, width: ScreenConfigration.screenWidth - 200, height: 40)
        self.addSubview(self.vote)
    }
    private func setupMovieImage(){
        self.movieImage.image = UIImage(named: "cinema.png")
        self.movieImage.frame  = CGRect(x: 20, y: 20, width: 75, height: 75)
        self.addSubview(self.movieImage)
    }
    func setMovie(_ movie : MovieDetail){
        let image_url = "https://image.tmdb.org/t/p/w500/"
        self.movieTitle.text = movie.originalTitle
        self.movieYear.text = movie.releaseDate
        if let voteCont = movie.voteAverage{self.vote.text = "\(voteCont)"}
        if let posterPath = movie.posterPath{
            if let url = URL(string: image_url + posterPath){
                self.movieImage.sd_setImage(with: url, completed: nil)
            }
        }
    }
}
