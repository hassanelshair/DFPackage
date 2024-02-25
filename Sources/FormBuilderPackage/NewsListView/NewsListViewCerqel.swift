//
//  NewsListViewCerqel.swift
//  CERQEL
//
//  Created by HassanElshair on 12/12/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit
import CRRefresh

import UIKit
import CRRefresh

class NewsListViewCerqel: CerqelBaseWireFrame<NewsViewModelCerqel> {
    
    weak var delegate: SearchDelegate?

    enum Section {
        case pinned
        case sort
        case news
    }

    @IBOutlet weak var emptyViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var headerView: CerqelReusableHeader!
    @IBOutlet weak var emptyImg: UIImageView!
    @IBOutlet weak var emptyTitle: UILabel!
    @IBOutlet weak var emptySearchLbl: LocalizedLabel!
    
    var sections: [Section] = [.sort, .news]
    
    override func configure(with viewModel: NewsViewModelCerqel) {
        
        viewModel.newsList.subscribe(onNext: { [unowned self]  (list) in
//            DispatchQueue.main.async {
                self.itemsTV.isHidden = false
                self.emptyStateView.isHidden = true
                self.itemsTV.cr.endHeaderRefresh()
                if let newsList = list {
                    if newsList.count > 0 { } else {
                        if viewModel.isSearch == true || viewModel.isFilter == true{
                            emptyTitle.text = "No Search Results Yet!".localized
                            emptySearchLbl.text = "Whoops ... this information is not available for a moment".localized
                            emptyImg.image = UIImage(named: "search_empty")
                        } else {
                            emptySearchLbl.text = ""
                            emptyImg.image = UIImage(named: "news_empty")
                            if viewModel.isFavFlag {// is Favourite News
                                self.emptyTitle.text = "No Favourite News Yet!".localized
                                self.emptyTitle.isHidden = false
                            } else {
                                self.emptyTitle.text = "No Latest News Yet!".localized
                                self.emptyTitle.isHidden = false
                            }
                        }
                        self.emptyStateView.isHidden = false
                    }
                    self.itemsTV.reloadData()
                    print("News List: \(newsList)")

                }else{
                    self.itemsTV.isHidden = false
                    self.emptyStateView.isHidden = true
                }

//            }
        }).disposed(by: self.disposeBag)
        
        
        viewModel.pinnedNewsList.subscribe(onNext: { [unowned self] pinnedNews in
            self.itemsTV.reloadData()
//            DispatchQueue.main.async {
                if let pinnedNews = pinnedNews, !pinnedNews.isEmpty {
                    if !self.sections.contains(where: { $0 == .pinned} ) {
                        self.sections.insert(.pinned, at: 0)
                        emptyViewCenterConstraint.constant = 150
                    }
                    self.itemsTV.reloadData()
                } else {
                    self.sections.removeAll(where: { $0 == .pinned })
                    emptyViewCenterConstraint.constant = 0
                    self.itemsTV.reloadData()
                }
//            }
            
        }).disposed(by: self.disposeBag)

        
        viewModel.isFilterApplied.subscribe(onNext: { [unowned self] isFilterApplied in
            headerView.showRedDot(show: isFilterApplied)
        }).disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        title = "News".localized
        setupTableView()
        setupHeaderView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.isNewsSearchFilter.accept(false)
        if self.viewModel.isFavFlag{
            self.favBtnTapped()
        }else{
            self.latestBtnTapped()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }

    private func updateUI(){
        self.view.layoutIfNeeded()
    }
    
    private func setupTableView() {
        itemsTV.register(PinnedNewsTVCellCerqel.cerqel_nib, forCellReuseIdentifier: PinnedNewsTVCellCerqel.cerqel_identifier)
        itemsTV.register(SortNewsTVCellCerqel.cerqel_nib, forCellReuseIdentifier: SortNewsTVCellCerqel.cerqel_identifier)
        itemsTV.register(NewsListTVcellCerqel.cerqel_nib, forCellReuseIdentifier: NewsListTVcellCerqel.cerqel_identifier)
        setupPullToRefresh()
    }
    
    private func setupHeaderView() {
        
        headerView.disableSearch()
        
        headerView.didSearchNewViewButton = { [weak self] in
            guard let self = self else { return }
            if let vc = CERQELShared_Router.goTo(viewName: .searchModule(module: .news, filterModel: self.viewModel.filterModel, text: self.viewModel.searchText, selectedSort: self.viewModel.selectedSort, isDismiss: true)) as? SearchScreenVC {
                vc.delegate = self
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
        }

        headerView.didTapFirstRadioButton = { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.isFavFlag else { return }
//            self.viewModel.filterModel = nil
            self.viewModel.selectedSort = "Newest"
            self.viewModel.searchText = nil
            self.viewModel.isSearch = false
            self.viewModel.isFilter = false
            self.latestBtnTapped()
        }
        
        headerView.didTapSecondRadioButton = { [weak self] in
            guard let self = self else { return }
            guard !self.viewModel.isFavFlag else { return }
//            self.viewModel.filterModel = nil
            self.viewModel.selectedSort = "Newest"
            self.viewModel.searchText = nil
            self.viewModel.isSearch = false
            self.viewModel.isFilter = false
            self.favBtnTapped()
        }
        
        headerView.didTapFilterButton = { [weak self] in
            guard let self = self else { return }
            if let vc = CERQELShared_Router.goTo(viewName: .filter(sections: [FilterSection(sectionTitle: "Date", filterType: .dateRangeFilter, filterCategoriesType: nil, items: [], api: nil)], filterModel: self.viewModel.filterModel ?? CerqelFilterModelCerqel(dateRangeFilter: CerqelDateRangeFilterCerqel()), searchTxt: self.viewModel.searchText, selectedSort: self.viewModel.selectedSort)) as? FilterVC {
                vc.delegate = self
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
        }
        
        headerView.didChangeSearchText = { [weak self] query in
            guard let self = self else { return }
            if (query?.count ?? 0) < 3 && (query?.count ?? 0) > 0{
               
                return
            }
            self.viewModel.isSearch = true
            self.viewModel.searchText = query
            if self.viewModel.isFavFlag{
                self.favBtnTapped()
            }else{
                self.latestBtnTapped()
            }
        }
    }

    
    private func setupPullToRefresh(){
        itemsTV.cr.addHeadRefresh(animator: FastAnimator()) { [self] in
            if viewModel.isFavFlag{
                self.favBtnTapped()
            }else{
                self.latestBtnTapped()
            }
        }
    }
    
    func latestBtnTapped(){
        self.viewModel.isFavFlag = false
        self.sections = [.sort,.news]
        self.viewModel.fetchNewsList(refresh: true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.fetchPinnedNews()
//        }
    }
    
    func favBtnTapped(){
        self.viewModel.isFavFlag = true
        self.sections = [.news]
        self.viewModel.pinnedNewsList.accept([])
        self.viewModel.fetchFavNews(refresh: true)
    }
    
    func handleSortAction() {
        CerqelBaseSortVC.presentSheet(sortData: viewModel.sortModel, sortType: .radioBtnTV, sortSelectedName: viewModel.selectedSort, sortTitle: "Sort By".localized, selectedAction: { [weak self] selectedSort in
            self?.viewModel.selectedSort = selectedSort
            self?.latestBtnTapped()
        }, from: self)
    }
}

extension NewsListViewCerqel {
    private func configureUI() {
        bgBottomView.backgroundColor = bg
        emptyTitle.textColor = primaryMain
        emptyTitle.font = UIFont.bodyLMedium()
        emptySearchLbl.font = UIFont.bodyMRegular()
        emptySearchLbl.textColor = typographyBody
    }
}
