//
//  PeopleViewController.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var nameSearchBar: UISearchBar!
    @IBOutlet weak var peopleTableView: UITableView!
    let peopleViewModel = PeopleViewModel()
    let nibNameString : String = "PeopleTableViewCell"
    var isPaginating : Bool = false
    var isSearching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        self.navigationController?.isNavigationBarHidden = true
        peopleViewModel.delegate = self
        
        if NetWorkManager.shared.isNetworkReachable() {
            peopleViewModel.fetchPeoples(withUrlString: Constant.peopleApi)
        }else {
            peopleViewModel.peoples = DatabaseHelper.sharedInstance.getPeoplesInfo()
        }
       
        
        nameSearchBar.searchTextField.delegate = self
        nameSearchBar.backgroundImage = UIImage()
        nameSearchBar.delegate = self
        nameSearchBar.searchTextField.textColor = .black
        nameSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }


    private func configureTableView(){
        let nib = UINib(nibName: nibNameString, bundle: nil)
        peopleTableView.register(nib, forCellReuseIdentifier: nibNameString)
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
    }
}

extension PeopleViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
          return  peopleViewModel.searchedPeoples?.results.count ?? 0
        }
        return peopleViewModel.peoples?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: nibNameString, for: indexPath) as? PeopleTableViewCell {
            if isSearching {
                cell.setup(data: peopleViewModel.searchedPeoples?.results[indexPath.row])
            }else {
                cell.setup(data: peopleViewModel.peoples?.results[indexPath.row])
            }
                
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !NetWorkManager.shared.isNetworkReachable() {
            // show no network error
            return
        }
        if isPaginating {return}
        let position = scrollView.contentOffset.y
        if position > scrollView.contentSize.height - 100 - scrollView.frame.size.height {
            if !isSearching, let data = peopleViewModel.peoples, let next = data.next {
                self.peopleTableView.tableFooterView = createSpinnerFooter()
                isPaginating = true
                peopleViewModel.fetchPeoples(withUrlString: next)
            }else if let data = peopleViewModel.searchedPeoples, let next = data.next {
                self.peopleTableView.tableFooterView = createSpinnerFooter()
                isPaginating = true
                peopleViewModel.fetchPeoples(withUrlString: next)
            }
        }
    }
    
    fileprivate func createSpinnerFooter() -> UIView {
        let vw = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 100)))
        let spinner = UIActivityIndicatorView()
        spinner.center = vw.center
        spinner.startAnimating()
        spinner.color = .black
        spinner.style = .medium
        vw.addSubview(spinner)
        return vw
    }
}

extension PeopleViewController : PeopleProtocol {
    func failedWith(error: any Error) {
        // show Error maessage
        hideSpinner()
    }
    
    func reloadData() {
        hideSpinner()
        self.peopleTableView.reloadData()
    }
    
    func hideSpinner(){
        isPaginating = false
        self.peopleTableView.tableFooterView = nil
    }
}


extension PeopleViewController : UISearchBarDelegate, UITextFieldDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            peopleViewModel.searchedPeoples = nil
            searchResult(with: trimmed.lowercased())
        }else {
            isSearching = false
            reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        reloadData()
    }
    
    func searchResult(with : String){
        isSearching = true
        peopleViewModel.fetchSearchedPeoples(withUrlString: Constant.peopleSerchApi+with)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
