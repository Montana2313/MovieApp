//
//  SearchVC.swift
//  MovieApp
//
//  Created by Mac on 7.06.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import RxSwift

private class searchViewModel{
    var searchedMovies = Variable([MovieDetail]())
    var disposeBag = DisposeBag()
    func fetchData(text: String){
        let movieApi = MovieApiClass()
        
        movieApi.moviesObject.asObserver().map { (movies)  in
            self.searchedMovies.value = movies.results
        }.subscribe().disposed(by: self.disposeBag)
        
        DispatchQueue.global(qos: .background).async {
            movieApi.searchMoview(name: text)
        }
    }
}

class SearchVC: UIViewController {
    private let viewModel = searchViewModel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConfigration.lightmodeBackgrounColor
        self.setupTableView()
        self.setSearchBar()
        self.viewModel.searchedMovies.asObservable().map { (_)  in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.subscribe().disposed(by: self.viewModel.disposeBag)
        if traitCollection.userInterfaceStyle == .dark{
            self.view.backgroundColor = ColorConfigration.darkmodeBackgroundColor
        }
    }
    private func setSearchBar(){
        self.searchBar.backgroundColor = .clear
        self.searchBar.placeholder = "Movie name"
        self.searchBar.delegate = self
        self.searchBar.frame = CGRect(x: 20, y: 110, width: ScreenConfigration.screenWidth - 40, height: 40)
        self.view.addSubview(self.searchBar)
    }
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
        self.tableView.frame = CGRect(x: 0, y: 160, width: ScreenConfigration.screenWidth, height: ScreenConfigration.screenHeight - 150)
        self.view.addSubview(self.tableView)
    }
}
extension SearchVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedMovies.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell else {fatalError()}
        cell.setMovie(self.viewModel.searchedMovies.value[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let latestViewController = LatestViewController()
        latestViewController.setMovieId(self.viewModel.searchedMovies.value[indexPath.row].id)
        self.navigationController?.pushViewController(latestViewController, animated: true)
    }
}
extension SearchVC : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 1 {
            self.viewModel.searchedMovies.value.removeAll(keepingCapacity: false)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped")
        self.viewModel.fetchData(text: searchBar.text!)
    }
}
extension SearchVC {
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
