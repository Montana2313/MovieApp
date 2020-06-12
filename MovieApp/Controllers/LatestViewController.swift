//
//  ViewController.swift
//  MovieApp
//
//  Created by Mac on 28.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import  RxSwift
import SDWebImage

private class latestViewModel {
    var movie_id : Int? = nil
    let image_url = "https://image.tmdb.org/t/p/w500/"
    var movieDetail = PublishSubject<MovieDetail>()
    let disposeBag = DisposeBag()
    func fetchLatestMovie(){
        let movieApi = MovieApiClass()
        movieApi.movieDetailObject.asObserver().map { (movie)  in
            self.movieDetail.onNext(movie)
        }.subscribe().disposed(by: disposeBag)
        DispatchQueue.global(qos: .background).async {
            movieApi.getMovieData(type: .MovieGetLatest)
        }
    }
    func fetchMovieDetail(){
        if let id = movie_id {
            let movieApi = MovieApiClass()
            movieApi.movieDetailObject.asObserver().map { (movie)  in
                self.movieDetail.onNext(movie)
            }.subscribe().disposed(by: disposeBag)
            DispatchQueue.global(qos: .background).async {
                movieApi.getMovieData(id: String(id), type: .MovieDetail)
            }
        }
    }
}

class LatestViewController: UIViewController {
    private let viewModel = latestViewModel()
    private lazy var movieImage = UIImageView()
    private lazy var backButton = UIButton()
    private var detailViewStatus = false
    private let detailVC = DetailViewController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
        if traitCollection.userInterfaceStyle == .dark{self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor}
        self.setImageView()
        self.setDetailMovie()
        self.setbackButton()     
        self.viewModel.movieDetail.asObserver().map { (movieDetail) in
            self.detailVC.setMovieDetail(movie: movieDetail)
            if let posterPath = movieDetail.posterPath{
                if let url = URL(string: self.viewModel.image_url + posterPath){
                    DispatchQueue.main.async {
                        self.movieImage.sd_setImage(with: url, completed: nil)
                        self.movieImage.contentMode = .scaleToFill
                    }
                }
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)
        if let _ = self.viewModel.movie_id {
            self.viewModel.fetchMovieDetail()
            self.view.addSubview(self.backButton)
        }else {
            self.viewModel.fetchLatestMovie()
        }
    }
    private func setDetailMovie(){
        detailVC.view.frame = CGRect(x: 0, y: ScreenConfigration.screenHeight - 85, width: ScreenConfigration.screenHeight, height: UIScreen.main.bounds.height)
        
        detailVC.gestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(detailViewTapped)))
        self.addChild(detailVC)
        self.view.addSubview(detailVC.view)
    }
    @objc func detailViewTapped(){
        UIView.animate(withDuration: 1.0) {
            if self.detailViewStatus == false{
                self.movieImage.frame = CGRect(x: 0, y: 0, width: ScreenConfigration.screenWidth, height: 200)
                self.detailVC.view.frame = CGRect(x: 0, y: 200, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight - 200)
                self.detailViewStatus = true
            }
            else if self.detailViewStatus == true{
                self.movieImage.frame = CGRect(x: 0, y: 0, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight - 85)
                self.detailVC.view.frame =  CGRect(x: 0, y: ScreenConfigration.screenHeight - 100, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight)
                self.detailViewStatus = false
                }
        }
    }
    private func setImageView(){
        self.movieImage.backgroundColor = .clear
        self.movieImage.image = UIImage(named: "cinema.png")
        self.movieImage.contentMode = .scaleAspectFit
        self.movieImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 75)
        self.view.addSubview(self.movieImage)
    }
    private func setbackButton(){
        self.backButton.setTitle("<", for: .normal)
        self.backButton.setTitleColor(.white, for: .normal)
        self.backButton.backgroundColor = ColorConfigration.darkmodeBackgroundColor
        self.backButton.layer.borderColor = UIColor.white.cgColor
        self.backButton.layer.borderWidth = 1.0
        self.backButton.frame = CGRect(x: 20, y: 50, width: 50, height: 50)
        self.backButton.layer.masksToBounds = true
        self.backButton.clipsToBounds = true
        self.backButton.layer.cornerRadius = self.backButton.frame.size.width / 2.0
        self.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    func setMovieId(_ id:Int){
        self.viewModel.movie_id = id
    }
}
extension LatestViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *){
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                if traitCollection.userInterfaceStyle == .dark{
                      self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor
                }else{
                    self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
                }
            }
        }
    }
}
