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
    
    var searchworkItem : DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        self.navigationController?.isNavigationBarHidden = true
        peopleViewModel.delegate = self
        
        handleNetworkCall()
        setupSearchbar()
    }
    
    private func handleNetworkCall(){
        NetWorkManager.shared.reachabilityManager?.startListening(onUpdatePerforming: { [weak self]_ in
            if self?.peopleViewModel.peoples == nil {
                if let isNetworkReachable = NetWorkManager.shared.reachabilityManager?.isReachable,
                   isNetworkReachable == true {
                    self?.peopleViewModel.fetchPeoples(withUrlString: Constant.peopleApi)
                } else {
                    let tmp = DatabaseHelper.sharedInstance.getPeoplesInfo()
                    self?.peopleViewModel.peoples = tmp.0
                    self?.peopleViewModel.singlePeoplesInfo = tmp.1
                }
            }
        })
    }
    
    private func setupSearchbar(){
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
    
    fileprivate func gotoSinglePage(with info : PeopleResult){
        let vc = SinglePeopleViewController(info: info)
        vc.delegate = self
        vc.singleInfos = peopleViewModel.singlePeoplesInfo[info.url]
        navigationController?.pushViewController(vc, animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info : PeopleResult?
        if isSearching {
            info = peopleViewModel.searchedPeoples?.results[indexPath.row]
        }else {
            info = peopleViewModel.peoples?.results[indexPath.row]
        }
        if let info {
            gotoSinglePage(with: info)
        }
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PeopleTableViewCell {
            cell.contentView.backgroundColor = UIColor.white
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
    func failedSearch(errr: DataError) {
        hideSpinner()
    }
    
    func failedWith(error: DataError) {
        // show Error maessage
        openAlert(title: "Error", message: "Server Error plese try again later!", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], action: [{ _ in
           
       }])
        
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
        searchworkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.peopleViewModel.fetchSearchedPeoples(withUrlString: Constant.peopleSerchApi+with)
        }
        
        searchworkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension PeopleViewController : PeopleInfoProtocol {
    func sinlgePeopleinfo(with: FinalSinglePeopleInfoModel, url : String) {
        peopleViewModel.singlePeoplesInfo[url] = with
    }
}
