
import UIKit

public
class DFManager {
    
    var newsVC: NewsListViewCerqel?

    public
    init(chatTableViewCellNib: UINib, identifier: String) {
        newsVC = NewsListViewCerqel(nibName: "NewsListViewCerqel", bundle: .module)
//        chatView?.configureChatView(chatTableViewCellNib: chatTableViewCellNib, identifier: identifier)
    }
        
        
    public
    func getnewsView() -> UIViewController? {
        return newsVC
    }
}
