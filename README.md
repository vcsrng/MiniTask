# SimpleProjectSwiftUI — P2P Loan Viewer

An iOS app to view and manage P2P loan data, built with **Swift + SwiftUI** using **MVVM**.

---

## Requirements

- Xcode 15+
- iOS 17+ simulator or device
- No third-party dependencies

## Running the App

```bash
git clone https://github.com/vcsrng/SimpleProjectSwiftUI.git
cd SimpleProjectSwiftUI

# Option A — open directly
open MiniTask.xcodeproj

# Option B — regenerate project first (requires XcodeGen)
brew install xcodegen
xcodegen generate
open MiniTask.xcodeproj
```

Press **⌘R** to run. Loan data loads automatically from the API.

---

## Architecture

**MVVM** — no third-party frameworks.

```
MiniTask/
├── Models/          Loan, Borrower, Collateral, LoanDocument, RepaymentSchedule, SortOption
├── Networking/      LoanAPIServicing (protocol) + LoanAPIService (URLSession)
├── ViewModels/      LoanListViewModel, LoanDetailViewModel
├── Views/
│   ├── LoanList/    LoanListView, LoanRowView
│   ├── LoanDetail/  LoanDetailView, LoanDocumentsView, RepaymentScheduleSection
│   └── Components/  RiskBadge, StatCard, InfoRow
└── Utilities/       AppConfig, PreviewSupport
```

Key decisions:
- `LoanAPIServicing` protocol makes the service swappable/mockable in tests
- `@MainActor` on `LoanListViewModel` keeps UI updates safe without extra DispatchQueue calls
- `async/await` for networking — simple and readable
- Currency code is centralised in `AppConfig.swift` (currently `IDR`)

---

## Screens

| Screen | Features |
|---|---|
| **Loan List** | Card list with risk-color accent bar, portfolio summary dashboard (total loans, value, avg rate, risk split) |
| **Loan Detail** | Hero header with initials avatar, borrower info with credit score color, collateral, repayment timeline |
| **Loan Documents** | Document list with type icons; empty-state when none available |

---

## Additional Features

- **Portfolio Dashboard** — 4 stat cards at the top of the list (total loans, portfolio value, avg interest, A/B/C risk distribution)
- **Search** — filter by borrower name or purpose
- **Sort** — 6 options (amount, term, purpose)
- **Risk Filter** — show only A, B, or C rated loans
- **Pull to Refresh** — reload data from API
- **Credit Score Color** — green ≥ 740, orange 670–739, red < 670

---

## Tests

### Unit Tests — `MiniTaskTests/MiniTaskTests.swift`

Uses the **Swift Testing** framework (`@Test`, `#expect`). All 11 tests verified passing on iPhone 17 Pro simulator.

| Suite | Test | Status |
|---|---|---|
| `LoanListViewModelTests` | `filterByRiskRating` | ✅ |
| `LoanListViewModelTests` | `searchByBorrowerName` | ✅ |
| `LoanListViewModelTests` | `searchByPurpose` | ✅ |
| `LoanListViewModelTests` | `sortByAmountHighToLow` | ✅ |
| `LoanListViewModelTests` | `sortByTermShortToLong` | ✅ |
| `LoanListViewModelTests` | `availableRiskRatingsIncludesAll` | ✅ |
| `LoanListViewModelTests` | `loadLoansErrorSetsMessage` | ✅ |
| `LoanDetailViewModelTests` | `borrowerName` | ✅ |
| `LoanDetailViewModelTests` | `termText` | ✅ |
| `LoanDetailViewModelTests` | `installmentsSortedByDate` | ✅ |
| `LoanDetailViewModelTests` | `documentsReturned` | ✅ |

> The entire `LoanListViewModelTests` struct is annotated `@MainActor` to safely access the ViewModel's actor-isolated properties and `init`.

### UI Tests — `MiniTaskUITests/MiniTaskUITests.swift`

Uses **XCTest** and tests real app flows end-to-end:

- Loan list and navigation bar appears after launch
- Portfolio Overview dashboard is visible
- Sort & Filter toolbar button is present
- Search bar activates on tap
- Tapping a loan navigates to the detail screen
- Detail screen shows the Documents row
- Tapping Documents opens the Documents screen
- Back navigation returns to the loan list
- Launch performance baseline

Run via **⌘U** or `Product › Test`.

---

## XcodeGen & Git

A [`project.yml`](project.yml) spec is included so the `.xcodeproj` can be regenerated:

```bash
xcodegen generate
```

The `.gitignore` excludes `MiniTask.xcodeproj/` and build artefacts — only source files and `project.yml` need to be committed.

---

## API

```
GET https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/api/json/loans.json
```
