//
//  MainNavigationController.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    // MARK: Internal Properties
    
    // MARK: UIViewController Properties
    
    // MARK: IBOutlets

    // MARK: Private Properties
    
    // MARK: Init / Deinit
    
    static func make() -> MainNavigationController {
        let mainNavigationController = MainNavigationController()
        return mainNavigationController
    }
    
    // MARK: Public Methods
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushEpisodesViewController()
    }
    
    // MARK: IBActions
    
    // MARK: Private Methods
    
    private func pushEpisodesViewController() {
        let episodesViewController = EpisodesViewController.make()
        episodesViewController.actionHandler = { [weak self] action in
            switch action {
            case .select(let episode):
                self?.pushEpisodeDetailViewController(episode)
            }
            
        }
        pushViewController(episodesViewController, animated: true)
    }
    
    private func pushEpisodeDetailViewController(_ episode: Episode) {
        let episodeDetailsViewController = EpisodeDetailViewController.make(episode)
        pushViewController(episodeDetailsViewController, animated: true)
    }
}
