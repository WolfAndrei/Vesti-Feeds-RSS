//
//  ViewController.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class FeedController: UIViewController {
    
    //external dependencies
    let feedParser = FeedParser()
    
    //viewModel
    var viewModel = FeedViewModel(feedItems: [:])
    
    //ui element
    let tableView = UITableView()
    
    //flag for filter
    var filtered = false
    
    //viewController lifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupFilterBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "Новости"
    }
    
    private func setupTableView() {
        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.cellId)
        setupRefreshBtn()
    }
    
    // settings for filter btn
    private func setupFilterBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(filter))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func filter() {
        filtered = !filtered
        tableView.reloadData()
    }
    
    //refresher
    func setupRefreshBtn() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        viewModel.feedItems.removeAll()
        fetchData()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    //fetching data
    func fetchData() {
        feedParser.getFeeds { [weak self] items in
            guard let self = self else { return }
            var newDictionary = [String: [FeedViewModel.Cell]]()
            for (key, value) in items {
                if newDictionary[key] == nil {
                    newDictionary[key] = self.viewModel.presentViewModel(from: value)
                } else {
                    newDictionary[key]!.append(contentsOf: self.viewModel.presentViewModel(from: value))
                }
            }
            self.viewModel.feedItems = newDictionary
            self.tableView.reloadData()
        }
    }
    
}

extension FeedController: UITableViewDelegate, UITableViewDataSource {
    
    //UITableViewDelegate && DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtered ? viewModel.numberOfSections() : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filtered ? viewModel.title(forSection: section) : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered ? viewModel.numberOfRows(in: section) : viewModel.numberOfRowsUnfiltered()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellId, for: indexPath) as! FeedCell
        let cellViewModel = filtered ?
            viewModel.viewModel(forIndexPath: indexPath) :
            viewModel.viewModelForUnfilteredFeeds(forIndexPath: indexPath)
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailController = DetailController()
        let cellViewModel = filtered ?
            viewModel.viewModel(forIndexPath: indexPath) :
            viewModel.viewModelForUnfilteredFeeds(forIndexPath: indexPath)
        detailController.detailView.set(viewModel: cellViewModel)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}

