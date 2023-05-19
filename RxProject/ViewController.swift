//
//  ViewController.swift
//  RxProject
//
//  Created by isoftstone on 2023/5/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxFDNetwork

class ViewController: UIViewController {
    
    let viewModel = SearchViewModel()

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SongsCell")
        
        viewModel.songs.bind(to: tableView.rx.items(cellIdentifier: "SongsCell", cellType: SearchCell.self)) { (rows, songs, cell) in
            cell.textLabel?.text = "\(songs.name ?? "") - \(songs.artists.first?.name ?? "")"
        }.disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        RxFDNetwork.getSongs(key: "千里之外").subscribe(onNext: { model in
            debugPrint("当前歌曲数量:\(model.result?.songs.count)")
        }).disposed(by: disposeBag)
    }


}

