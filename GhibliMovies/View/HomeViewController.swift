//
//  HomeViewController.swift
//  GhibliMovies
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterPickerView: UIPickerView!
    
    let viewModel = ApiViewModel()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPickerView()
        fetchData()
    }

    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupPickerView() {
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
    }
    
    func alertErrorSetup() {
        let alert = UIAlertController(title: "Data cannot be found", message: "Data cannot be found", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell
        
        let toplists = viewModel.filteredMovies[indexPath.row]
        cell?.titleLabel.text = toplists.director
        cell?.releaseDateLabel.text = toplists.release_date
        cell?.directorLabel.text = toplists.title
        cell?.descriptionLabel.text = toplists.description
        
        return cell ?? UITableViewCell()
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 1
        } else {
            return viewModel.listOfYear.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "Year"
        } else {
            return viewModel.listOfYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedYear = viewModel.listOfYear[row]
        fetchData()
    }
}

extension HomeViewController {
    func fetchData()
    {
        viewModel.getData
        { [weak self] result in
            switch result
            {
            case .failure(let error):
                DispatchQueue.main.async
                {
                    self?.alertErrorSetup()
                    print(error)
                    self?.refreshControl.endRefreshing()
                }
            case .success(let toplists):
                DispatchQueue.main.async
                {
                    self?.viewModel.listOfMovies = toplists
                    self?.filterPickerView.reloadAllComponents()
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
}
