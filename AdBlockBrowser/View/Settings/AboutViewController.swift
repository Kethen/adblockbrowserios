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

final class AboutViewController: SettingsTableViewController<AboutViewModel> {
    let links = ["https://adblockplus.org/privacy",
                 "https://adblockplus.org/terms",
                 "https://adblockplus.org/impressum"]

    override func viewDidLoad() {
        tableView.register(SettingsHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        super.viewDidLoad()

        clearsSelectionOnViewWillAppear = false
        tableView.preservesSuperviewLayoutMargins = false
        tableView.cellLayoutMarginsFollowReadableWidth = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }

    override func viewWillLayoutSubviews() {
        tableView.layoutMargins = margins
        tableView.separatorInset = margins
        super.viewWillLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false

        if let uwUrl = URL(string: (links[indexPath.row])) {
            viewModel?.openURL(uwUrl)
            dismiss(animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let view = self.tableView(tableView, viewForHeaderInSection: section) {
            return view.sizeThatFits(CGSize(width: tableView.bounds.width, height: .infinity)).height
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = margins
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.preservesSuperviewLayoutMargins = false
        view.layoutMargins = margins
    }
}
