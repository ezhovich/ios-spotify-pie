import SwiftUI
import WebKit

struct AuthView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AuthViewController
    
    @Binding var isPresented: Bool
    @Binding var accessToken: String?
    
    var url: String = "https://accounts.spotify.com/en/authorize?client_id=d382f23bf98d4dd59bf022470da81d10&redirect_uri=https://pie-test-login/callback&response_type=code&scope=user-top-read"
    
    func makeUIViewController(context: Context) -> AuthViewController {
        let viewController = AuthViewController(isPresented: $isPresented, accessToken: $accessToken)
        viewController.url = url
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {
    }
    
}

class AuthViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    var url: String = ""
    @Binding var isPresented: Bool
    @Binding var accessToken: String?
    
    init(isPresented: Binding<Bool>, accessToken: Binding<String?>) {
            _isPresented = isPresented
            _accessToken = accessToken
            super.init(nibName: nil, bundle: nil)
        }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebView()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    private func loadWebView() {
        guard let url = URL(string: url) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        let urlString = url.absoluteString
        let api = API()
        
        // Check if the URL contains your redirect URI
        if urlString.contains("https://pie-test-login/callback") {
            // Extract the authorization code from the URL
            if let code = api.extractAuthorizationCode(from: urlString) {
                // Do something with the authorization code
                print("Authorization Code: \(code)")
                api.getAccessToken(code: code){ auth, e in
                    if let auth = auth{
                        DispatchQueue.main.async {
                            self.accessToken = auth
                        }
                    }
                }
                isPresented = false
            }
        }
        decisionHandler(.allow)
    }
    
    
}


