//
//  ViewController2.swift
//  MovieApp
//
//  Created by Mac on 31.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import  RxSwift
import TinyConstraints
import RKPieChart

private class DetailViewModel {
    var movieDetail  = PublishSubject<MovieDetail>()
    var similarMovies = Variable([MovieDetail]())
    let disposeBag = DisposeBag()
    
    func getSimilarMovies(id: Int){
        let movieApi = MovieApiClass()
        DispatchQueue.global(qos: .background).async {
            movieApi.getMovieData(id: String(id), type: .SimilarMovies)
        }
        movieApi.moviesObject.asObserver().map { (movies) in
            self.similarMovies.value = movies.results
        }.subscribe().disposed(by: self.disposeBag)
        // buradan collection view i güncelleyecek
    }
}

class DetailViewController: UIViewController {
    private var chartView = RKPieChartView()
    private let movieTitle : UILabel = UILabel()
    private let movieYear : UILabel = UILabel()
    private let viewModel = DetailViewModel()
    private let scrollView = UIScrollView()
    private let vote = UILabel()
    private let movieDescription = UILabel()
    private let starImage = UIImageView(image: UIImage(named: "star"))
    private lazy var collectionView = UICollectionView()
    private let noResultSimilarMovieLabel = UILabel()
    let gestureView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        self.setScrollView()
        self.setMovieYear()
        self.setMovieTitleLabel()
        self.setStarImageView()
        self.setVoteLabel()
        self.setMovieDescription()
        self.setGestureView()
        self.viewModel.movieDetail.asObserver().map { (movie) in
            self.viewModel.getSimilarMovies(id: movie.id)
            DispatchQueue.main.async {
                    if movie.title != ""{self.movieTitle.text = movie.title}
                    if movie.releaseDate != ""{self.movieYear.text = movie.releaseDate}
                    if let average = movie.voteAverage {self.vote.text = "\(average)"}
                    if movie.overview != ""{self.movieDescription.text = movie.overview}
                    self.setChart(voteAvarage: movie.voteAverage ?? 0.0 ,voteCount:movie.voteCount ?? 0)
                    self.setDetailViews(budget: movie.budget, orginalLabel: movie.originalLanguage, genre: movie.genres?.first?.name)
                    self.setNoResultLabel()
                    let new_height = ScreenConfigration.height(text: self.movieDescription.text, width: ScreenConfigration.screenWidth - 20) + 320 + 100  + 150 + 300
                   self.scrollView.contentSize = CGSize(width: ScreenConfigration.screenWidth, height: new_height)
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)
        self.viewModel.similarMovies.asObservable().map { (movies)  in
            DispatchQueue.main.async {
                if movies.count > 0 {
                    self.noResultSimilarMovieLabel.isHidden = true
                    self.setCollectionView()
                    let new_height = ScreenConfigration.height(text: self.movieDescription.text, width: ScreenConfigration.screenWidth - 20) + 320 + 100  + 150 + 420
                    self.scrollView.contentSize = CGSize(width: ScreenConfigration.screenWidth, height: new_height)
                }
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor
            self.movieTitle.textColor = .white
            self.movieYear.textColor = .white
            self.movieDescription.textColor = .white
        }
    }
    private func setGestureView(){
         self.gestureView.backgroundColor = .clear
         self.gestureView.frame = CGRect(x: 0, y: 0, width: ScreenConfigration.screenWidth, height: 100)
         self.view.addSubview(self.gestureView)
     }
    private func setDetailViews(budget : Int? , orginalLabel:String? , genre:String?){
        let detailMovieView = UIView()
        let budgetLabel = UILabel()
        let orginalLangLabel = UILabel()
        let genresLabel = UILabel()
        
        budgetLabel.textColor = .black
        orginalLangLabel.textColor = .black
        genresLabel.textColor = .black
        
        if traitCollection.userInterfaceStyle == .dark{
            budgetLabel.textColor = .white
            orginalLangLabel.textColor = .white
            genresLabel.textColor = .white
        }
        
        budgetLabel.text = "Budget : Unspecified"
         orginalLangLabel.text = "Original languge : Unspecified"
         genresLabel.text = "Genre: Unspecified"
        if let budget = budget{budgetLabel.text = "Budget : \(budget)$"}
        if let lang = orginalLabel{orginalLangLabel.text = "Original language : \(lang)"}
        if let genre = genre{genresLabel.text = "Genre : \(genre)"}
        
        budgetLabel.frame = CGRect(x: 10, y: 20, width: ScreenConfigration.screenWidth - 20, height: 30)
        orginalLangLabel.frame = CGRect(x: 10, y: 60, width: ScreenConfigration.screenWidth - 20, height: 30)
        genresLabel.frame = CGRect(x: 10, y: 100, width: ScreenConfigration.screenWidth - 20, height: 30)
 
        detailMovieView.addSubview(budgetLabel)
        detailMovieView.addSubview(orginalLangLabel)
        detailMovieView.addSubview(genresLabel)
        self.scrollView.addSubview(detailMovieView)
        
        detailMovieView.topToBottom(of: self.chartView, offset: 20)
        detailMovieView.height(150)
        detailMovieView.width(ScreenConfigration.screenWidth)
    }
    private func setNoResultLabel(){
        self.noResultSimilarMovieLabel.textColor = .red
        self.noResultSimilarMovieLabel.text = "We could not found any similar movies"
        self.noResultSimilarMovieLabel.font = UIFont(name: "Helvetica", size: 20.0)
        let height = ScreenConfigration.height(text: self.movieDescription.text, width: ScreenConfigration.screenWidth - 20) + 320 + 100  + 150
        self.noResultSimilarMovieLabel.textAlignment = .center
        self.noResultSimilarMovieLabel.frame = CGRect(x: 0, y: height + 10, width: ScreenConfigration.screenWidth, height: 30)
        self.scrollView.addSubview(self.noResultSimilarMovieLabel)
    }
    private func setView(){
        self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
        self.view.layer.borderWidth = 0.4
        self.view.layer.borderColor = UIColor.lightGray.cgColor
    }
    private func setStarImageView(){
        self.starImage.frame = CGRect(x: ScreenConfigration.screenWidth - 55, y: 15, width: 30, height:30)
        self.scrollView.addSubview(self.starImage)
    }
    private func setVoteLabel(){
        self.vote.text = "0.0"
        self.vote.font = UIFont(name: "Helvetica", size: 20.0)
        self.vote.textColor = ColorConfigration.voteLabelColor
        self.vote.textAlignment = .center
        self.vote.frame = CGRect(x: ScreenConfigration.screenWidth - 80, y: 50, width: 80, height: 20)
        self.scrollView.addSubview(self.vote)
    }
    private func setScrollView(){
        self.scrollView.frame = CGRect(x: 0, y: 0, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight + 10)
        self.scrollView.contentSize = CGSize(width: ScreenConfigration.screenWidth , height: ScreenConfigration.screenHeight + 300)
        // buranın  da dinamik olması gerekiyor
        if ScreenConfigration.phoneType() == .iPhone8{
             self.scrollView.contentSize = CGSize(width: ScreenConfigration.screenWidth , height: ScreenConfigration.screenHeight + 420)
        }
        self.scrollView.backgroundColor = .clear
        self.view.addSubview(self.scrollView)
    }
    private func setMovieTitleLabel(){
        self.movieTitle.text = "Unspecified"
        self.movieTitle.textAlignment = .left
        self.movieTitle.font = UIFont(name: "Helvetica", size: 25.0)
        self.movieTitle.numberOfLines = 0
        self.movieTitle.textColor = .black
        self.movieTitle.frame = CGRect(x: 10, y: 10, width: ScreenConfigration.screenWidth - 80, height: 35)
        self.scrollView.addSubview(self.movieTitle)
    }
    private func setMovieYear(){
        self.movieYear.text = "Unspecified"
        self.movieYear.textAlignment = .left
        self.movieYear.font = UIFont(name: "Helvetica", size: 15.0)
        self.movieYear.textColor = .lightGray
        self.movieYear.frame = CGRect(x: 10, y: 50, width: ScreenConfigration.screenWidth - 120, height: 15.0)
        self.scrollView.addSubview(self.movieYear)
    }
    private func setMovieDescription(){
        self.scrollView.addSubview(self.movieDescription)
        self.movieDescription.text = "Unspecified Movie Desciption"
        self.movieDescription.font = UIFont(name: "Helvetica", size: 20.0)
        self.movieDescription.numberOfLines = 0
        self.movieDescription.textColor = .black
        self.movieDescription.topToBottom(of: self.movieYear , offset: 20)
        self.movieDescription.leftToSuperview(offset: 10, usingSafeArea: true)
        self.movieDescription.rightToSuperview(offset: 3, usingSafeArea: true)
    }
    private func setChart(voteAvarage:Double , voteCount:Int){
        let ratio = uint((voteAvarage * 200) / 10)
        let firstItem = RKPieChartItem(ratio: ratio, color: ColorConfigration.voteLabelColor,title: "Vote")
        self.chartView = RKPieChartView(items: [firstItem], centerTitle:"People count : \(voteCount)")
         self.scrollView.addSubview(chartView)
        chartView.circleColor = ColorConfigration.chartColor
        chartView.arcWidth = 45
        chartView.isIntensityActivated = true
        chartView.style = .butt
        chartView.isAnimationActivated = true

        chartView.topToBottom(of: self.movieDescription , offset: 10)
        chartView.width(ScreenConfigration.screenWidth)
        chartView.height(250)
    }
    private func setCollectionView(){
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.itemSize = CGSize(width: 100, height: 200)
        collectionFlowLayout.scrollDirection = .horizontal
        let height = ScreenConfigration.height(text: self.movieDescription.text, width: ScreenConfigration.screenWidth - 20) + 320 + 100  + 150
        self.collectionView = UICollectionView(frame: CGRect(x: 20, y: height, width: ScreenConfigration.screenWidth - 40 , height: 200), collectionViewLayout: collectionFlowLayout)
        
        self.collectionView.register(SimilarMoviesCell.self, forCellWithReuseIdentifier: "similarMovieCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        self.scrollView.addSubview(self.collectionView)
    }
    func setMovieDetail(movie : MovieDetail){
        self.viewModel.movieDetail.onNext(movie)
    }
}
extension  DetailViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.similarMovies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarMovieCell", for: indexPath)  as? SimilarMoviesCell else {
            fatalError()
        }
        cell.setMovie(self.viewModel.similarMovies.value[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailPage = LatestViewController()
        movieDetailPage.setMovieId(self.viewModel.similarMovies.value[indexPath.row].id)
        self.navigationController?.pushViewController(movieDetailPage, animated: true)
    }
}
extension DetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *){
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                if traitCollection.userInterfaceStyle == .dark{
                        self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor
                        self.movieTitle.textColor = .white
                        self.movieYear.textColor = .white
                        self.movieDescription.textColor = .white
                }else{
                    self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
                    self.movieTitle.textColor = .black
                    self.movieYear.textColor = .lightGray
                    self.movieDescription.textColor = .black
                }
            }
        }
    }
}

