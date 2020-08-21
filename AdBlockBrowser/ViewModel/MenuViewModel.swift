/*
 * This file is part of Adblock Plus <https://adblockplus.org/>,
 * Copyright (C) 2006-present eyeo GmbH
 *
 * Adblock Plus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Adblock Plus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Adblock Plus.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation
import RxSwift
import RxRelay

enum MenuItem: Int {
    case adblockingEnabled
    case openNewTab
    case requestDesktopSite
    case addBookmark
    case share
    case history
    case settings
}

let DesktopUserAgent = "Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0"
let MobileUserAgent = "Mozilla/5.0 (Android 10; Mobile; rv:68.0) Gecko/68.0 Firefox/79.0"

final class MenuViewModel: ViewModelProtocol {
    let components: ControllerComponents
    let extensionFacade: ABPExtensionFacadeProtocol
    var viewModel: BrowserViewModel
    let isBookmarked: BehaviorRelay<Bool>
    let isHistoryViewShown: BehaviorRelay<Bool>
    let isExtensionEnabled = BehaviorRelay(value: false)
    let isPageWhitelisted = BehaviorRelay(value: false)
    let isWhitelistable = BehaviorRelay(value: false)

    private let disposeBag = DisposeBag()

    init(browserViewModel viewModel: BrowserViewModel) {
        self.components = viewModel.components
        self.extensionFacade = viewModel.components.extensionFacade
        self.viewModel = viewModel
        self.isBookmarked = viewModel.isBookmarked
        self.isHistoryViewShown = viewModel.isHistoryViewShown

        (self.extensionFacade as? NSObject)?.rx
            .observe(Bool.self, #keyPath(ABPExtensionFacade.extensionEnabled))
            .map({ $0 ?? false })
            .distinctUntilChanged()
            .bind(to: isExtensionEnabled)
            .disposed(by:disposeBag)

        let url = viewModel.url.asObservable()

        Observable.combineLatest(isExtensionEnabled.asObservable(), url) { enabled, url in
            return enabled && url != nil
        }
            .bind(to: isWhitelistable)
            .disposed(by:disposeBag)

        Observable.combineLatest(isExtensionEnabled.asObservable(), url) {
            (enabled: $0, url: $1)
        }
            .subscribe(onNext: { [weak self] combinedLatest in
                if combinedLatest.enabled, let url = combinedLatest.url {
                    self?.extensionFacade.isSiteWhitelisted(url.absoluteString) { boolValue, _ in
                        self?.isPageWhitelisted.accept(boolValue)
                    }
                } else {
                    self?.isPageWhitelisted.accept(false)
                }
            })
            .disposed(by:disposeBag)
    }

    // MARK: -

    func shouldBeEnabled(_ menuItem: MenuItem) -> Bool {
        switch menuItem {
        case .adblockingEnabled, .addBookmark, .share, .requestDesktopSite:
            return isWhitelistable.value
        default:
            return true
        }
    }

    func handle(menuItem: MenuItem) {
        switch menuItem {
        case .adblockingEnabled:
            if let url = viewModel.currentURL.value?.absoluteString {
                let whitelisted = isPageWhitelisted.value
                extensionFacade.whitelistSite(url, whitelisted: !whitelisted) { [weak self] error in
                    self?.isPageWhitelisted.accept(!whitelisted == (error == nil))
                }
            }
            return
        case .openNewTab:
            if let tab = components.chrome.focusedWindow?.add(tabWithURL: nil, atIndex: 0) {
                tab.active = true
                tab.window.focused = true
            }
        case .addBookmark:
            if isBookmarked.value {
                viewModel.removeBookmark()
            } else {
                viewModel.addBookmark()
            }
        case .share:
            viewModel.isShareDialogPresented.accept(true)
        case .history:
            isHistoryViewShown.accept(true)
        case .requestDesktopSite:
            if let tab = viewModel.activeTab.value{
                tab.desktop = !tab.desktop
                tab.murderWebView()
                viewModel.activeTab.accept(tab)
                if let url = tab.URL {
                    tab.load(url:url as URL)
                }
            }
            break
        default:
            break
        }

        viewModel.isMenuViewShown.accept(false)
    }
}
