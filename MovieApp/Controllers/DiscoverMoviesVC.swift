//
//  DiscoverMoviesVC.swift
//  MovieApp
//
//  Created by Mac on 7.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import RxSwift
private class discoverMovieViewModel{
    var discoverMovies = Variable([MovieDetail]())
    var disposeBag = DisposeBag()
    private let pageLimitation = 1000
    private var currentPageNumber = 0
    func fetchData(){
        let movieApi = MovieApiClass()
        movieApi.moviesObject.asObserver().map { (movies)  in
            for item in movies.results {self.discoverMovies.value.append(item)}
        }.subscribe().disposed(by: self.disposeBag)
        DispatchQueue.global(qos: .background).async {
            movieApi.getMovieData(type: .DiscoverMovies,pageNumber:self.currentPageNumber)
        }
        if self.pageLimitation > self.currentPageNumber {
            self.currentPageNumber += 1
        }
    }
}
class DiscoverMoviesVC: UIViewController {
    private let viewModel = discoverMovieViewModel()
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        
        self.viewModel.discoverMovies.asObservable().map { (movies) in
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.fetchData()
        
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor
        }
    }
    private func setupView(){
        self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
    }
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
        self.tableView.frame = CGRect(x: 0, y: 100, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight - 100)
        self.view.addSubview(self.tableView)
    }
}
extension DiscoverMoviesVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.discoverMovies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell else {fatalError()}
        cell.setMovie(self.viewModel.discoverMovies.value[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let latestViewController = LatestViewController()
        latestViewController.setMovieId(self.viewModel.discoverMovies.value[indexPath.row].id)
        self.navigationController?.pushViewController(latestViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.discoverMovies.value.count - 1 {
            self.viewModel.fetchData()
        }
    }
    
    
}
extension DiscoverMoviesVC {
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
