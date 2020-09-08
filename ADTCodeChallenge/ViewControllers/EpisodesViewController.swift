//
//  EpisodesViewController.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import UIKit

class EpisodesViewController: UIViewController {

    // MARK: Internal Properties
    
    enum Action {
        case select(Episode)
    }
    
    var actionHandler: ((_ action: Action) -> Void)?
    
    static let reuseIdentifier = "ReuseIdentifier"
    
    // MARK: UIViewController Properties
    
    
    // MARK: IBOutlets

    // MARK: Private Properties
    
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, Episode>!
    
    enum Section {
        case main
    }
    
    private var episodes: [Episode] = []

    // MARK: Init / Deinit
    
    static func make() -> EpisodesViewController {
        let episodesViewController = EpisodesViewController()
        return episodesViewController
    }
    
    // MARK: Public Methods
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EpisodesViewController.reuseIdentifier)
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        view.addSubview(tableView)
        
        dataSource = UITableViewDiffableDataSource<Section, Episode>(tableView: tableView) { [weak self] (tableView: UITableView, indexPath: IndexPath, episode: Episode) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesViewController.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = episode.name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
                
        var constraints: [NSLayoutConstraint] = []
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
        
        getEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: IBActions
    
    // MARK: Private Methods
    
    private func updateUI(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
        snapshot.appendSections([.main])
        snapshot.appendItems(episodes)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    @objc private func refreshControlHandler() {
        getEpisodes()
    }
    
    private func getEpisodes() {
        tableView.refreshControl?.beginRefreshing()
        let cloud = Cloud()
        cloud.getEpisodes { [weak self] result in
            switch result {
            case .success(let getEpisodesResponse):
                self?.episodes = Episode.makeEpisodes(getEpisodesResponse)
                self?.updateUI(animated: true)
            case .failure(let error):
                switch error {
                case .noResponse(let error), .decodingResponseError(let error):
                    print(error)
                case .server(let httpStatusCode):
                    print("HTTP Status code: \(httpStatusCode)")
                }
            }
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

}

// MARK: - Extension for Protocol conformance

extension EpisodesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let episode = dataSource.itemIdentifier(for: indexPath), let actionHandler = self.actionHandler {
            actionHandler(.select(episode))
        }
    }
}
