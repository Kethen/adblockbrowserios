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

import AttributedMarkdown
import RxSwift
import UIKit

// Extracted from the embedded extension.
// File: firstRun.js
public var blockingItems:[String:(title:String, subscription:ListedSubscription)] = [:]



final class AdblockingSettingsViewController: SettingsTableViewController<AdblockingSettingsViewModel>, SwitchCellDelegate {
    @IBOutlet weak var adblockingLabel: UILabel?
    @IBOutlet weak var exceptionsLabel: UILabel?
    @IBOutlet weak var languagesLabel: UILabel?
    @IBOutlet weak var mainTable : UITableView?

    var items:[String:(title:String, subscription:ListedSubscription)] = [:]
    var itemsLang:[String:(title:String, subscription:ListedSubscription)] = [:]
    var itemsKeys:[String] = []
    var itemsLangKeys:[String] = []

    override func viewDidLoad() {
        populateListing()
        super.viewDidLoad()
        navigationItem.title = localize("Ad blocking", comment: "Ad blocking Settings - title")
        adblockingLabel?.text = localize("Ad blocking", comment: "Ad blocking Settings - cell title")
        // exceptionsLabel?.text = localize("Exceptions", comment: "Ad blocking Settings - show more blocking options")
        // languagesLabel?.text = localize("Languages", comment: "Ad blocking Settings - enable/disable acceptable ads")
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        switch segue.destination {
        case let controller as ExceptionsViewController:
            if let viewModel = viewModel {
                controller.viewModel = ExceptionsViewModel(components: viewModel.components,
                                                           isAcceptableAdsEnabled: viewModel.isAcceptableAdsEnabled)
            }
        default:
            break
        }
    }
    
    private func populateListing(){
        items = [:]
        itemsLang = [:]
        blockingItems = [:]

        items["UBLOCK-FILTERS"] = (
            title: "uBlock filters",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
                title: "uBlock filters",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-FILTERS"] = items["UBLOCK-FILTERS"]

        items["UBLOCK-BADWARE"] = (
            title: "uBlock filters – Badware risks",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
                title: "uBlock filters – Badware risks",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-BADWARE"] = items["UBLOCK-BADWARE"]

        items["UBLOCK-PRIVACY"] = (
            title: "uBlock filters – Privacy",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
                title: "uBlock filters – Privacy",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-PRIVACY"] = items["UBLOCK-PRIVACY"]

        items["UBLOCK-ABUSE"] = (
            title: "uBlock filters – Resource abuse",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
                title: "uBlock filters – Resource abuse",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-ABUSE"] = items["UBLOCK-ABUSE"]

        items["UBLOCK-UNBREAK"] = (
            title: "uBlock filters – Unbreak",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
                title: "uBlock filters – Unbreak",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-UNBREAK"] = items["UBLOCK-UNBREAK"]

        items["ADGUARD-GENERIC"] = (
            title: "AdGuard Base",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/2_without_easylist.txt",
                title: "AdGuard Base",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ADGUARD-GENERIC"] = items["ADGUARD-GENERIC"]

        items["ADGUARD-MOBILE"] = (
            title: "AdGuard Mobile Ads",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/11.txt",
                title: "AdGuard Mobile Ads",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ADGUARD-MOBILE"] = items["ADGUARD-MOBILE"]

        items["EASYLIST"] = (
            title: "EasyList",
            subscription: ListedSubscription(
                url: "https://easylist.to/easylist/easylist.txt",
                title: "EasyList",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["EASYLIST"] = items["EASYLIST"]

        items["ADGUARD-SPYWARE"] = (
            title: "AdGuard Tracking Protection",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/3.txt",
                title: "AdGuard Tracking Protection",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ADGUARD-SPYWARE"] = items["ADGUARD-SPYWARE"]

        items["EASYPRIVACY"] = (
            title: "EasyPrivacy",
            subscription: ListedSubscription(
                url: "https://easylist.to/easylist/easyprivacy.txt",
                title: "EasyPrivacy",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["EASYPRIVACY"] = items["EASYPRIVACY"]

        items["FANBOY-ENHANCED"] = (
            title: "Fanboy’s Enhanced Tracking List",
            subscription: ListedSubscription(
                url: "https://www.fanboy.co.nz/enhancedstats.txt",
                title: "Fanboy’s Enhanced Tracking List",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FANBOY-ENHANCED"] = items["FANBOY-ENHANCED"]

        items["URLHAUS-1"] = (
            title: "Online Malicious URL Blocklist",
            subscription: ListedSubscription(
                url: "https://gitlab.com/curben/urlhaus-filter/raw/master/urlhaus-filter-online.txt",
                title: "Online Malicious URL Blocklist",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["URLHAUS-1"] = items["URLHAUS-1"]

        items["SPAM404-0"] = (
            title: "Spam404",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/Spam404/lists/master/adblock-list.txt",
                title: "Spam404",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["SPAM404-0"] = items["SPAM404-0"]

        items["ADGUARD-ANNOYANCE"] = (
            title: "AdGuard Annoyances",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/14.txt",
                title: "AdGuard Annoyances",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ADGUARD-ANNOYANCE"] = items["ADGUARD-ANNOYANCE"]

        items["ADGUARD-SOCIAL"] = (
            title: "AdGuard Social Media",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/4.txt",
                title: "AdGuard Social Media",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ADGUARD-SOCIAL"] = items["ADGUARD-SOCIAL"]

        items["FANBOY-THIRDPARTY_SOCIAL"] = (
            title: "Anti-Facebook",
            subscription: ListedSubscription(
                url: "https://fanboy.co.nz/fanboy-antifacebook.txt",
                title: "Anti-Facebook",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FANBOY-THIRDPARTY_SOCIAL"] = items["FANBOY-THIRDPARTY_SOCIAL"]

        items["FANBOY-ANNOYANCE"] = (
            title: "Fanboy’s Annoyance",
            subscription: ListedSubscription(
                url: "https://easylist.to/easylist/fanboy-annoyance.txt",
                title: "Fanboy’s Annoyance",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FANBOY-ANNOYANCE"] = items["FANBOY-ANNOYANCE"]

        items["FANBOY-COOKIEMONSTER"] = (
            title: "EasyList Cookie",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/easylist-cookie.txt",
                title: "EasyList Cookie",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FANBOY-COOKIEMONSTER"] = items["FANBOY-COOKIEMONSTER"]

        items["FANBOY-SOCIAL"] = (
            title: "Fanboy’s Social",
            subscription: ListedSubscription(
                url: "https://easylist.to/easylist/fanboy-social.txt",
                title: "Fanboy’s Social",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FANBOY-SOCIAL"] = items["FANBOY-SOCIAL"]

        items["UBLOCK-ANNOYANCES"] = (
            title: "uBlock filters – Annoyances",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
                title: "uBlock filters – Annoyances",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["UBLOCK-ANNOYANCES"] = items["UBLOCK-ANNOYANCES"]

        items["DPOLLOCK-0"] = (
            title: "Dan Pollock’s hosts file",
            subscription: ListedSubscription(
                url: "https://someonewhocares.org/hosts/hosts",
                title: "Dan Pollock’s hosts file",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["DPOLLOCK-0"] = items["DPOLLOCK-0"]

        items["MVPS-0"] = (
            title: "MVPS HOSTS",
            subscription: ListedSubscription(
                url: "https://winhelp2002.mvps.org/hosts.txt",
                title: "MVPS HOSTS",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["MVPS-0"] = items["MVPS-0"]

        items["PLOWE-0"] = (
            title: "Peter Lowe’s Ad and tracking server list",
            subscription: ListedSubscription(
                url: "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext",
                title: "Peter Lowe’s Ad and tracking server list",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["PLOWE-0"] = items["PLOWE-0"]

        itemsLang["ARA-0"] = (
            title: "ara: Liste AR",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/Liste_AR.txt",
                title: "ara: Liste AR",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ARA-0"] = itemsLang["ARA-0"]

        itemsLang["BGR-0"] = (
            title: "BGR: Bulgarian Adblock list",
            subscription: ListedSubscription(
                url: "https://stanev.org/abp/adblock_bg.txt",
                title: "BGR: Bulgarian Adblock list",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["BGR-0"] = itemsLang["BGR-0"]

        itemsLang["CHN-0"] = (
            title: "CHN: EasyList China (中文)",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/easylistchina.txt",
                title: "CHN: EasyList China (中文)",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["CHN-0"] = itemsLang["CHN-0"]

        itemsLang["CHN-1"] = (
            title: "CHN: CJX's EasyList Lite",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjxlist.txt",
                title: "CHN: CJX's EasyList Lite",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["CHN-1"] = itemsLang["CHN-1"]

        itemsLang["CZE-0"] = (
            title: "CZE, SVK: EasyList Czech and Slovak",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/tomasko126/easylistczechandslovak/master/filters.txt",
                title: "CZE, SVK: EasyList Czech and Slovak",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["CZE-0"] = itemsLang["CZE-0"]

        itemsLang["DEU-0"] = (
            title: "DEU: EasyList Germany",
            subscription: ListedSubscription(
                url: "https://easylist.to/easylistgermany/easylistgermany.txt",
                title: "DEU: EasyList Germany",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["DEU-0"] = itemsLang["DEU-0"]

        itemsLang["EST-0"] = (
            title: "EST: Eesti saitidele kohandatud filter",
            subscription: ListedSubscription(
                url: "https://adblock.ee/list.php",
                title: "EST: Eesti saitidele kohandatud filter",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["EST-0"] = itemsLang["EST-0"]

        itemsLang["FIN-0"] = (
            title: "FIN: Adblock List for Finland",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/finnish-easylist-addition/finnish-easylist-addition/master/Finland_adb.txt",
                title: "FIN: Adblock List for Finland",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FIN-0"] = itemsLang["FIN-0"]

        itemsLang["FRA-0"] = (
            title: "FRA: AdGuard Français",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/16.txt",
                title: "FRA: AdGuard Français",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["FRA-0"] = itemsLang["FRA-0"]

        itemsLang["GRC-0"] = (
            title: "GRC: Greek AdBlock Filter",
            subscription: ListedSubscription(
                url: "https://www.void.gr/kargig/void-gr-filters.txt",
                title: "GRC: Greek AdBlock Filter",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["GRC-0"] = itemsLang["GRC-0"]

        itemsLang["HUN-0"] = (
            title: "HUN: hufilter",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/hufilter/hufilter/master/hufilter.txt",
                title: "HUN: hufilter",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["HUN-0"] = itemsLang["HUN-0"]

        itemsLang["IDN-0"] = (
            title: "IDN, MYS: ABPindo",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/ABPindo/indonesianadblockrules/master/subscriptions/abpindo.txt",
                title: "IDN, MYS: ABPindo",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["IDN-0"] = itemsLang["IDN-0"]

        itemsLang["IRN-0"] = (
            title: "IRN: Adblock-Iran",
            subscription: ListedSubscription(
                url: "https://gitcdn.xyz/repo/farrokhi/adblock-iran/master/filter.txt",
                title: "IRN: Adblock-Iran",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["IRN-0"] = itemsLang["IRN-0"]

        itemsLang["ISL-0"] = (
            title: "ISL: Icelandic ABP List",
            subscription: ListedSubscription(
                url: "https://adblock.gardar.net/is.abp.txt",
                title: "ISL: Icelandic ABP List",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ISL-0"] = itemsLang["ISL-0"]

        itemsLang["ISR-0"] = (
            title: "ISR: EasyList Hebrew",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/easylist/EasyListHebrew/master/EasyListHebrew.txt",
                title: "ISR: EasyList Hebrew",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ISR-0"] = itemsLang["ISR-0"]

        itemsLang["ITA-0"] = (
            title: "ITA: EasyList Italy",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/easylistitaly.txt",
                title: "ITA: EasyList Italy",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ITA-0"] = itemsLang["ITA-0"]

        items["ITA-1"] = (
            title: "ITA: ABP X Files",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/gioxx/xfiles/master/filtri.txt",
                title: "ITA: ABP X Files",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ITA-1"] = items["ITA-1"]

        itemsLang["JPN-1"] = (
            title: "JPN: AdGuard Japanese",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/7.txt",
                title: "JPN: AdGuard Japanese",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["JPN-1"] = itemsLang["JPN-1"]

        itemsLang["KOR-1"] = (
            title: "KOR: YousList",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/yous/YousList/master/youslist.txt",
                title: "KOR: YousList",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["KOR-1"] = itemsLang["KOR-1"]

        itemsLang["LTU-0"] = (
            title: "LTU: EasyList Lithuania",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/EasyList-Lithuania/easylist_lithuania/master/easylistlithuania.txt",
                title: "LTU: EasyList Lithuania",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["LTU-0"] = itemsLang["LTU-0"]

        itemsLang["LVA-0"] = (
            title: "LVA: Latvian List",
            subscription: ListedSubscription(
                url: "https://notabug.org/latvian-list/adblock-latvian/raw/master/lists/latvian-list.txt",
                title: "LVA: Latvian List",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["LVA-0"] = itemsLang["LVA-0"]

        itemsLang["NLD-0"] = (
            title: "NLD: EasyList Dutch",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/easylistdutch.txt",
                title: "NLD: EasyList Dutch",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["NLD-0"] = itemsLang["NLD-0"]

        itemsLang["NOR-0"] = (
            title: "NOR, DNK, ISL: Dandelion Sprouts nordiske filtre",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/NorwegianList.txt",
                title: "NOR, DNK, ISL: Dandelion Sprouts nordiske filtre",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["NOR-0"] = itemsLang["NOR-0"]

        itemsLang["POL-0"] = (
            title: "POL: Oficjalne Polskie Filtry do AdBlocka, uBlocka Origin i AdGuarda",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/MajkiIT/polish-ads-filter/master/polish-adblock-filters/adblock.txt",
                title: "POL: Oficjalne Polskie Filtry do AdBlocka, uBlocka Origin i AdGuarda",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["POL-0"] = itemsLang["POL-0"]

        itemsLang["POL-2"] = (
            title: "POL: Oficjalne polskie filtry przeciwko alertom o Adblocku",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/olegwukr/polish-privacy-filters/master/anti-adblock.txt",
                title: "POL: Oficjalne polskie filtry przeciwko alertom o Adblocku",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["POL-2"] = itemsLang["POL-2"]

        itemsLang["ROU-1"] = (
            title: "ROU: Romanian Ad (ROad) Block List Light",
            subscription: ListedSubscription(
                url: "https://road.adblock.ro/lista.txt",
                title: "ROU: Romanian Ad (ROad) Block List Light",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["ROU-1"] = itemsLang["ROU-1"]

        itemsLang["RUS-0"] = (
            title: "RUS: RU AdList",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/advblock+cssfixes.txt",
                title: "RUS: RU AdList",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["RUS-0"] = itemsLang["RUS-0"]

        itemsLang["SPA-0"] = (
            title: "spa: EasyList Spanish",
            subscription: ListedSubscription(
                url: "https://easylist-downloads.adblockplus.org/easylistspanish.txt",
                title: "spa: EasyList Spanish",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["SPA-0"] = itemsLang["SPA-0"]

        itemsLang["SPA-1"] = (
            title: "spa, por: AdGuard Spanish/Portuguese",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/9.txt",
                title: "spa, por: AdGuard Spanish/Portuguese",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["SPA-1"] = itemsLang["SPA-1"]

        itemsLang["SVN-0"] = (
            title: "SVN: Slovenian List",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/betterwebleon/slovenian-list/master/filters.txt",
                title: "SVN: Slovenian List",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["SVN-0"] = itemsLang["SVN-0"]

        itemsLang["SWE-1"] = (
            title: "SWE: Frellwit's Swedish Filter",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/lassekongo83/Frellwits-filter-lists/master/Frellwits-Swedish-Filter.txt",
                title: "SWE: Frellwit's Swedish Filter",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["SWE-1"] = itemsLang["SWE-1"]

        itemsLang["THA-0"] = (
            title: "THA: EasyList Thailand",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/easylist-thailand/easylist-thailand/master/subscription/easylist-thailand.txt",
                title: "THA: EasyList Thailand",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["THA-0"] = itemsLang["THA-0"]

        itemsLang["TUR-0"] = (
            title: "TUR: AdGuard Turkish",
            subscription: ListedSubscription(
                url: "https://filters.adtidy.org/extension/ublock/filters/13.txt",
                title: "TUR: AdGuard Turkish",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["TUR-0"] = itemsLang["TUR-0"]

        itemsLang["VIE-1"] = (
            title: "VIE: ABPVN List",
            subscription: ListedSubscription(
                url: "https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn.txt",
                title: "VIE: ABPVN List",
                homepage: "https://github.com/gorhill/uBlock"
            )
        )
        blockingItems["VIE-1"] = itemsLang["VIE-1"]

        itemsKeys = Array(items.keys).sorted(by: {(a:String, b:String) -> Bool in
            return a < b
        })
        itemsLangKeys = Array(itemsLang.keys).sorted(by: {(a:String, b:String) -> Bool in
             return a < b
         })
    }
    
    // MARK: - MVVM

    private let disposeBag = DisposeBag()

    override func observe(viewModel: ViewModelEx) {
        super.observe(viewModel: viewModel)

        viewModel.extensionFacade.getListedSubscriptions { [weak self] (listedSubscriptions: [String: ListedSubscription]?, error: Error?) in
            if let error = error {
                Log.error("Listed subscriptions query returned \(error)")
                return
            }

            guard let listedSubscriptions = listedSubscriptions else {
                Log.warn("Listed subscriptions query returned nil dictionary")
                return
            }

            self?.viewModel?.update(subscriptions: listedSubscriptions)
            self?.tableView.reloadData()
        }

        viewModel.isAcceptableAdsEnabled.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView?.reloadSections(IndexSet(integer: 0), with: .none)
            })
            .disposed(by:disposeBag)
    }

    // MARK: - SwitchCellDelegate
    
    
    func switchValueDidChange(_ cell: SwitchCell) {
        if cell.reuseIdentifier == "AdBlockingCell" {
            viewModel?.extensionEnabled = cell.isOn
            tableView.reloadData()
        } else if let identifier = cell.reuseIdentifier{
            var item:(title:String, subscription:ListedSubscription)
            if itemsKeys.contains(identifier){
                item = items[identifier]!
            }else{
                item = itemsLang[identifier]!
            }
            if let status = viewModel?.subscriptionsStatus[item.subscription]{
                switch status {
                case .notInstalled:
                    viewModel?.extensionFacade.addSubscription(item.subscription)
                    viewModel?.subscriptionsStatus[item.subscription] = .enabled
                case .installedButDisabled:
                    viewModel?.extensionFacade.subscription(item.subscription, enabled: true)
                    viewModel?.subscriptionsStatus[item.subscription] = .enabled
                case .enabled:
                    // Remove (not disable) subscription
                    viewModel?.extensionFacade.removeSubscription(item.subscription)
                    viewModel?.subscriptionsStatus[item.subscription] = .notInstalled
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("asking for number of rows in section %d", section)
        if section == 0{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }else if section == 1{
            return items.count
        }else{
            return itemsLang.count
        }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        let isEnabled = viewModel?.extensionEnabled ?? false
        if indexPath.section == 0 {
            cell = super.tableView(tableView, cellForRowAt: indexPath)

            if #available(iOS 9.0, *) {
                tableView.cellLayoutMarginsFollowReadableWidth = false
            }

            if cell.reuseIdentifier == "AdBlockingCell", let cell = cell as? SwitchCell {
                cell.isOn = isEnabled
                cell.delegate = self
                return cell
            }

            (cell as? SwitchCell)?.isEnabled = isEnabled


            if cell.reuseIdentifier == "ExceptionsCell" {
                let allow = localize("Yes", comment: "Allow Google search")
                let deny = localize("No", comment: "Deny Google search")
                cell.detailTextLabel?.text = viewModel?.isAcceptableAdsEnabled.value ?? false ? allow : deny
            } else {
                cell.detailTextLabel?.text = nil
            }
        }else{
            var key:String
            var item:(title:String, subscription:ListedSubscription)
            if indexPath.section == 1{
                key = itemsKeys[indexPath.row]
                item = items[key]!
            }else{
                key = itemsLangKeys[indexPath.row]
                item = itemsLang[key]!
            }
            cell = SwitchCell(style:UITableViewCell.CellStyle.default, reuseIdentifier: key)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = item.title
            cell.contentView.contentMode = UIView.ContentMode.center
            cell.indentationWidth = 10
            if let cell = cell as? SwitchCell{
                if let status = viewModel?.subscriptionsStatus[item.subscription] {
                    cell.awakeFromNib()
                    cell.type = .switch
                    cell.isOn = status == .enabled
                    cell.delegate = self
                } else {
                    cell.type = .activityIndicator
                }
            }
        }
        cell.textLabel?.numberOfLines = 2
        if let cell = cell as? SwitchCell {
            cell.selectionStyle = .none
        }else{
            cell.selectionStyle = isEnabled ? .default : .none
        }
        cell.isUserInteractionEnabled = isEnabled
        cell.textLabel?.isEnabled = isEnabled
        return cell
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 0 {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }else{
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SettingsHeader

        switch section {
        case 0:
            header?.text = localize("ADBLOCK BROWSER", comment: "Ad blocking Settings - section header")
        case 1:
            header?.text = "FILTERS"
            //header?.text = localize("MORE OPTIONS", comment: "Ad blocking Settings - section header")
        case 2:
            header?.text = "LANGUAGE SPECIFIC FILTERS"
        default:
            header?.text = nil
        }

        return header
    }
}
