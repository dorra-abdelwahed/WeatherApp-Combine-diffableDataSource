//
//  ViewController.swift
//  WeatherApp
//
//  Created by dorra on 1/19/21.
//

import UIKit
import Combine


enum Section {
    case main
}



class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: Proprietes
   
    var diffableDataSource: UITableViewDiffableDataSource<Section, WeeklyWeather>?
    
    @Published private var searchQuery: String = ""
    
    
    let weatherFetcher = WeatherFetcher()
    
    private var weatherSubscribers = Set<AnyCancellable>()
    private var city = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViews()
       
        hideKeyboardWhenTappedAround()
        
        setupTableView()
        setupSearchController()
        listenerForSearchQuery()
    }
    

    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           
           tableView.layoutIfNeeded()
        }
    

    //MARK: - With Combine
    func listenerForSearchQuery(){
        
        $searchQuery
            .filter { $0.count > 2}
            .sink{ query in
                self.weatherFetchData(for: query)}
            .store(in: &weatherSubscribers)
                
            }
    
    func weatherFetchData(for city: String){
        
        weatherFetcher.weeklyWeatherForecast(forCity: searchQuery)
            .map {response in
                
                response.list.map { data in
                    WeeklyWeather.init(item: data)
                }
               
            }
            .map(Array.removeDuplicates)
            .sink(receiveCompletion: { (completion) in
                switch completion{
                
                case .finished:
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    break
                case .failure(_):
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    self.buildAndApplySnapshotWeekly(weeklyWeather: [])
                }
            }, receiveValue: { (weather) in
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                self.buildAndApplySnapshotWeekly(weeklyWeather: weather)
            })
            .store(in: &weatherSubscribers)

    }
       
    
    /// hide Keyboard When Tap in screen
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTableViews(){
        tableView.tableFooterView = UIView()
    }

  
}

extension ViewController {
    private func setupSearchController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        let searchTextField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.attributedPlaceholder = NSAttributedString(string: "Search for weekly weather", attributes: [.foregroundColor: UIColor.white])
        searchTextField?.textColor = .white

        navigationItem.searchController = searchController
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchQuery = searchController.searchBar.text ?? ""
    }
}




extension ViewController{
    
     func setupTableView() {
    
        tableView.register(UINib(nibName: "WeeklyCustomTableViewCell", bundle: nil), forCellReuseIdentifier: WeeklyCustomTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Section,WeeklyWeather>(tableView: tableView) { (tableView, indexPath, weather) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: WeeklyCustomTableViewCell.identifier, for: indexPath) as! WeeklyCustomTableViewCell
            cell.setup(with: weather)
            return cell
        }
        
    }
    
    func buildAndApplySnapshotWeekly(weeklyWeather : [WeeklyWeather]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeeklyWeather>()

        snapshot.appendSections([.main])
        snapshot.appendItems(weeklyWeather)

        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
    
    
    

}
