//
//  MenüView.swift
//  MovieApp
//
//  Created by Mac on 31.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class MenuView: UIView {
     private var latestMoviesButton = myCustomButton(color: .clear, title: "Latest Movies", titleColor: .white)
    private var topRatedMoviesButton = myCustomButton(color: .clear, title: "Top Rated Movies", titleColor: .white)
    private var popularMoviesButton = myCustomButton(color: .clear, title: "Popular Movies", titleColor: .white)
    private var upcomingMoviesButton = myCustomButton(color: .clear, title: "Upcoming Movies", titleColor: .white)
    private var discoverButton = myCustomButton(color: .clear, title: "Discover", titleColor: .white)
    private var searchButton = myCustomButton(color: .clear, title: "Search", titleColor: .white)
    private var logo : UIImageView = UIImageView()
    private var poweredByLabel : UILabel = UILabel()
  // private var viewModeButton  = myCustomButton(color: .clear, title: "Dark Mode", titleColor:.white)
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupView()
        self.setButtons()
        self.setLogo()
        self.setPoweredBy()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        self.backgroundColor = ColorConfigration.darkmodeBackgroundColor
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.frame = CGRect(x: -1*(ScreenConfigration.halfScreenWidth), y: 0, width:ScreenConfigration.halfScreenWidth , height: ScreenConfigration.screenHeight)
    }
    private func setLogo(){
        self.logo.image = UIImage(named: "logoclear.png")
        self.logo.isUserInteractionEnabled = true
        self.logo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoTapped)))
    }
    private func setPoweredBy(){
        self.poweredByLabel.text = "Powered by themoviedb.org"
        self.poweredByLabel.textColor = .white
        self.poweredByLabel.font = UIFont(name: "Helvetica", size: 10.0)
        self.poweredByLabel.isUserInteractionEnabled = true
        self.poweredByLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(poweredLabelTapped)))
    }
    @objc func logoTapped(){
        if let url = URL(string: "http://www.benozgurelmasli.com"){
            UIApplication.shared.open(url)
        }
    }
    @objc func poweredLabelTapped(){
        if let url = URL(string: "https://www.themoviedb.org"){
            UIApplication.shared.open(url)
        }
    }
    private func setButtons(){
        self.latestMoviesButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
        self.latestMoviesButton.frame = CGRect(x: 10, y: ScreenConfigration.halfScreenHeight - 270, width: self.frame.size.width - 20, height: 40)
        
        self.topRatedMoviesButton.addTarget(self, action: #selector(topRatedButtonTapped), for: .touchUpInside)
        self.topRatedMoviesButton.frame = CGRect(x: 10, y: ScreenConfigration.halfScreenHeight - 200, width: self.frame.size.width - 20, height: 40)
        
         self.popularMoviesButton.addTarget(self, action: #selector(popularButtonTapped), for: .touchUpInside)
        self.popularMoviesButton.frame = CGRect(x: 10, y: ScreenConfigration.halfScreenHeight - 130, width: self.frame.size.width - 20, height: 40)
        
        self.upcomingMoviesButton.addTarget(self, action: #selector(upComingButtonTapped), for: .touchUpInside)
        self.upcomingMoviesButton.frame = CGRect(x: 10, y: ScreenConfigration.halfScreenHeight - 60, width: self.frame.size.width - 20, height: 40)
        
        self.discoverButton.addTarget(self, action: #selector(discoverButtonTapped), for: .touchUpInside)
        self.discoverButton.frame = CGRect(x: 10, y: Int(ScreenConfigration.halfScreenHeight) + 10, width: Int(self.frame.size.width) - 20, height: 40)
        
          self.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        self.searchButton.frame = CGRect(x: 10, y: ScreenConfigration.halfScreenHeight + 80, width: self.frame.size.width - 20, height: 40)
        
//        self.viewModeButton.frame = CGRect(x: 10, y: ScreenConfigration.screenHeight - 80, width: self.frame.size.width - 20, height: 40)
        
        self.logo.frame = CGRect(x: 5, y: ScreenConfigration.screenHeight - 60, width: 60, height: 70)
        self.poweredByLabel.frame = CGRect(x: 65, y: ScreenConfigration.screenHeight - 60, width: self.frame.size.width - 65, height: 40)
        
        self.addSubview(self.poweredByLabel)
        self.addSubview(self.logo)
        self.addSubview(self.latestMoviesButton)
        self.addSubview(self.topRatedMoviesButton)
         self.addSubview(self.popularMoviesButton)
         self.addSubview(self.upcomingMoviesButton)
         self.addSubview(self.discoverButton)
         self.addSubview(self.searchButton)
//        self.addSubview(self.viewModeButton)
    }
    @objc private func latestButtonTapped(){
        PathConfigration.seguePage(type: .LatestMovie, params: nil)
    }
     @objc private func topRatedButtonTapped(){
           PathConfigration.seguePage(type: .TopRatedMovies, params: nil)
       }
    @objc private func discoverButtonTapped(){
        PathConfigration.seguePage(type: .DiscoverMovies, params: nil)
    }
    @objc private func searchButtonTapped(){
        PathConfigration.seguePage(type: .Search, params: nil)
    }
    @objc private func popularButtonTapped(){
        PathConfigration.seguePage(type: .PopularMovies, params: nil)
    }
    @objc private func upComingButtonTapped(){
        PathConfigration.seguePage(type: .UpcomingMovies, params: nil)
    }
    // burada menu kısmı yazılacak
    func animate(position:Bool){
        var positionFrame = CGRect()
        if position == true{
            positionFrame = CGRect(x: -10, y: -10, width: ScreenConfigration.halfScreenWidth + 10, height: ScreenConfigration.screenHeight + 20)
        }else {
            positionFrame = CGRect(x: -1*(ScreenConfigration.halfScreenWidth ), y: 0, width:ScreenConfigration.halfScreenWidth , height: ScreenConfigration.screenHeight)
        }
        UIView.animate(withDuration: 1.0) {
            self.frame = positionFrame
        }
    }
    
    
}
