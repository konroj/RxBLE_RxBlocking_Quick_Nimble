//
//  BloodPressureListViewController.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

final class BloodPressureListViewController: UIViewController {
    private let bag = DisposeBag()
    private let viewModel: BloodPressureListViewModel
    
    private lazy var tableView = makeTableView()
    private lazy var readBarButton: UIBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: nil, action: nil) // should use localization keys
    
    init(viewModel: BloodPressureListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupData()
        setupUI()
        setupRxEvents()
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = readBarButton
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupData() {
        viewModel.connect()
        .subscribe(onNext: { [weak self] _ in
            //self?.readBloodPressureAction() should initially fetch data?
        })
        .disposed(by: bag)
    }
    
    private func setupRxEvents() {
        readBarButton.rx.tap.asDriver()
        .throttle(1, latest: false)
        .drive(onNext: { [weak self] (_) in
            self?.readBloodPressureAction()
        })
        .disposed(by: bag)
        
        viewModel.observePeripherialStatus()
        .subscribe(onNext: { [weak self] (status) in
            self?.navigationItem.setTitle(title: status?.0 ?? "Searching for...", subtitle: status?.1 ?? "")
        })
        .disposed(by: bag)
        
        viewModel.observeBloodPressureValues()
        .subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData() // should be some nice insertion here.
        })
        .disposed(by: bag)
    }
    
    private func readBloodPressureAction() {
        viewModel.read()
        .subscribe()
        .disposed(by: bag)
    }

}

extension BloodPressureListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BloodPressureListTableViewCell.identifier, for: indexPath) as! BloodPressureListTableViewCell
        cell.setup(model: viewModel.model[indexPath.row])
        return cell
    }
    
}

private extension BloodPressureListViewController {
    
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BloodPressureListTableViewCell.self, forCellReuseIdentifier: BloodPressureListTableViewCell.identifier)
        return tableView
    }
    
}
