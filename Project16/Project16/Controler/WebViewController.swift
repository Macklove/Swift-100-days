import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var webView: WKWebView!
    var capital = [Capital]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://en.wikipedia.org/wiki/" + capital[0].title!)
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures=true
    }
}
