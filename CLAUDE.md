# NutrientWise

Bilingual (English/French) iOS app for looking up nutritional information from the Canadian Nutrient File. See `README.md` for the user-facing feature list.

## Stack

- **Language:** Objective-C (not Swift)
- **UI:** UIKit, XIB-based (no Storyboards except `Launch Screen.storyboard`)
- **Lifecycle:** UIScene (`AppDelegate` + `SceneDelegate`)
- **Persistence:** Core Data backed by `DATA_v3.sqlite` (bundled, read-only nutrient database sourced from the Canadian Nutrient File 2015)
- **Sync:** iCloud key-value store for language, profile, and favorites
- **Deployment target:** iOS 15+ (`IPHONEOS_DEPLOYMENT_TARGET = 15.0` in the pbxproj; lowered in commit `8bf73b9` to support older devices)

## Project layout

- `Nutrient Wise.xcworkspace` — the workspace to open and build against
- `Nutrient Wise.xcodeproj` — underlying project
- `Nutrient Wise/` — app sources (Objective-C `.h`/`.m` + `.xib` pairs)
- `Nutrient WiseTests/` — XCTest unit test target (includes `ViewControllerIntegrationTests.m` which drives every VC through its XIB-loaded view hierarchy without XCUITest)
- `Nutrient WiseUITests/` — XCUITest UI test target (**does not exist yet** — see "Adding a UI test target" below)
- `Configs/` — xcconfig files; `Secret.xcconfig` is gitignored and holds `BUNDLE_ID_PREFIX` + `DEVELOPMENT_TEAM`. A `Secret.xcconfig.template` is checked in.
- `Model.xcdatamodeld/` — Core Data model
- `en.lproj/`, `fr.lproj/` — localized strings and HTML (`about-en.html`, `about-fr.html`)
- `HockeySDK-iOS/` — legacy crash reporting (do not modernize without asking)
- `GoogleService-Info.plist` — Firebase config; a `.template` is checked in, the real file is gitignored

## Scheme and targets

- App scheme: **Nutrient Wise** (`TestAction` has `codeCoverageEnabled = "YES"` scoped to the app target only)
- Unit test target: **Nutrient WiseTests** (XCTest) — uses `BUNDLE_LOADER` / `TEST_HOST` to link against the app at runtime, and has `HEADER_SEARCH_PATHS = "$(SRCROOT)/Nutrient Wise"` so tests can `#import` app headers directly
- UI test target: **Nutrient WiseUITests** (XCUITest) — not yet created; see "Adding a UI test target" below
- Bundle identifier is derived from `BUNDLE_ID_PREFIX` in `Secret.xcconfig` — do not hardcode it in `Info.plist` or the pbxproj

## Code conventions

- Objective-C style: `FooHelper` / `FooController` naming, `.h`/`.m` pairs, one XIB per view controller where applicable
- Helpers encapsulate cross-cutting concerns: `LanguageHelper`, `ProfileHelper`, `FavoriteHelper`, `ArrayHelper`, `CellHelper`
- Search/lookup goes through `Finder` against Core Data entities (`FoodName`, `NutritiveName`, `NutritiveValue`, `Measure`, `ConversionFactor`)
- Do not introduce Swift, SwiftUI, Storyboards, or SPM without first checking with the user — this codebase is intentionally UIKit/ObjC
- Do not touch `DATA_v3.sqlite`; it ships as-is

## Secrets and signing

- Never commit `Configs/Secret.xcconfig`, `GoogleService-Info.plist`, or `ExportOptions.plist` — templates exist for a reason
- Never hardcode team IDs, bundle prefixes, or API keys; read them from xcconfig

## Using XcodeBuildMCP

Prefer XcodeBuildMCP tools over `xcodebuild` shell commands for every build/run/test/simulator task. The shell workflow is a fallback for things MCP cannot do.

**Session defaults first.** Before the first build, run, or test call in a session, always call `session_show_defaults` to confirm the active workspace, scheme, and simulator. Do not assume they are set. Recommended defaults for this project:

- Workspace: `Nutrient Wise.xcworkspace` (prefer the workspace, not the `.xcodeproj`)
- Scheme: `Nutrient Wise`
- Simulator: any iPhone running iOS 15 or later

Use `session_set_defaults` once at the top of a session and then call the build/run tools with empty arguments.

**Typical flows:**

- Build + launch on simulator: `build_run_sim` (this is the one-shot: build, install, launch)
- Build only: `build_sim`
- Run tests: `test_sim`
- Install a prebuilt `.app`: `install_app_sim` then `launch_app_sim`
- Stream logs from a running app: `launch_app_logs_sim` or `start_sim_log_cap` / `stop_sim_log_cap`
- Discovery: only call `discover_projs` / `list_schemes` / `list_sims` when `session_show_defaults` shows something is missing or wrong
- UI checks: `screenshot`, `snapshot_ui` (for view-hierarchy + coordinates), `describe_ui`-style calls before tapping

**Rules of thumb:**

- Do not call `discover_projs` at the start of every session — it is slow and usually unnecessary once defaults are set
- When a build fails, read the MCP error output directly; do not fall back to `xcodebuild` unless the MCP tool is clearly the wrong tool for the job
- Only simulator tools are enabled by default. Device builds, macOS builds, LLDB debugging, and UI automation require the user to enable those workflows in XcodeBuildMCP config — if a call fails with "tool not available," ask the user to enable the workflow rather than silently falling back
- For a quick "does this still compile?" check after edits, `build_sim` is enough; reserve `build_run_sim` for when you actually need to exercise the app

## Testing

**Coverage target: 80% line coverage across the app target.** When adding or changing code, add tests to keep the overall line coverage at or above 80%. If a change would drop coverage below the target, flag it before finishing. Last measured baseline: **83.1%** (111 tests).

### What lives where

- **Nutrient WiseTests** (XCTest) — three layers of tests in one target:
  1. **Pure helper tests** — `LanguageHelperTests`, `ProfileHelperTests`, `ArrayHelperTests`, `FavoriteHelperTests`, `CellHelperTests`. No Core Data, no UIKit in most cases.
  2. **Core Data tests** — `FinderTests` uses `NWTestSupport` to build an in-memory `NSManagedObjectContext` from the merged model. **Never load `DATA_v3.sqlite` in tests** — always use `[NWTestSupport newInMemoryContext]`.
  3. **View controller integration tests** — `ViewControllerIntegrationTests` instantiates each VC from its XIB (`initWithNibName:` / `initWithFood:` / etc.), forces `self.view` to load, and drives datasource, delegate, and action methods directly. This exercises ~83% of the UIKit code without needing a XCUITest runner. When adding a new VC, extend this file.

`NWTestSupport` is the shared harness: in-memory Core Data stack, fixture builders (`insertFoodWithId:`, `insertNutritiveNameWithSymbol:`, etc.), and `resetUserDefaults` for the app's `NSUserDefaults` keys (`language`, `profile`, `favorites`, `conversionFactors`).

Stub delegate classes for the ProfileSelection / SettingsLanguage / MeasureSelection delegates live at the top of `ViewControllerIntegrationTests.m` (`NWProfileSelectionStub`, etc.). Reuse them rather than `[NSObject new]` — plain `NSObject` doesn't respond to the delegate selectors and the tests will crash.

### Running tests

- **Preferred:** `test_sim` via XcodeBuildMCP once session defaults are set
- **With coverage + explicit result bundle** (needed for `get_coverage_report`):
  ```
  xcodebuild test -workspace "Nutrient Wise.xcworkspace" \
    -scheme "Nutrient Wise" \
    -destination "platform=iOS Simulator,id=<UUID>" \
    -resultBundlePath /tmp/nw-test.xcresult \
    -enableCodeCoverage YES
  ```
  Then: `get_coverage_report { xcresultPath: "/tmp/nw-test.xcresult", showFiles: true }`. The scheme's `TestAction` already has `codeCoverageEnabled = "YES"`, but MCP's `test_sim` sometimes writes an incomplete result bundle — run `xcodebuild` directly when you need a guaranteed-readable bundle.

When coverage drops below 80%, call `get_file_coverage` on the biggest uncovered files first (don't chase tiny wins).

### What to test vs. skip

- **Test:** helpers, `Finder`, Core Data fetches, profile filtering, unit conversion via `ConversionFactor`/`Measure`, favorites persistence, every view controller's datasource + delegate + action methods
- **Expected to stay low:** `if (kDebug) NSLog(...)` branches (dead code — `kDebug` is a `NO` constant in several files), `Finder.searchFoodById:` (marked `// TODO not working`), `AppDelegate` / `SceneDelegate` iCloud paths (fire from `NSUbiquitousKeyValueStore` notifications that don't trigger in tests), and trivial `initWithNibName:bundle:` template stubs
- The `UISearchBar+UISearchBarLocalized` category walks private view-hierarchy class names (`UINavigationButton`, `UISearchBarTextField`) and only covers ~50% — it's brittle by design; don't try to boost it

### Adding a UI test target (XCUITest)

The project currently has no `Nutrient WiseUITests` target. Coverage sits at 83% via integration tests alone, so XCUITest isn't needed to hit the coverage bar — but if you want true end-to-end tests that launch the app via `XCUIApplication` and drive real user flows, here's what's needed:

**Do it from Xcode, not by hand-editing the pbxproj.** The target requires a `PBXNativeTarget` with productType `com.apple.product-type.bundle.ui-testing`, a `XCConfigurationList` with Debug / Release / "Ad hoc distribution" configurations, an Info.plist, a blueprint entry in the scheme's `TestAction` `Testables`, and a target dependency on the app. Hand-editing pbxproj to add all of that is high-risk surgery with no coverage upside.

**Xcode wizard path:**

1. File → New → Target → iOS → **UI Testing Bundle**
2. Product Name: `Nutrient WiseUITests`
3. Target to be Tested: **Nutrient Wise**
4. After creation, verify in the project editor:
   - The target's `TEST_TARGET_NAME` is `Nutrient Wise`
   - The target is attached to the `Nutrient Wise` scheme's Test action
   - `TARGETED_DEVICE_FAMILY = 1` (iPhone), matching the app
   - There is no legacy `RunUnitTests` shell script phase (Xcode 3/4 template leftover; if one sneaks in, remove it — it breaks the build)
5. If you use `xcconfig`, inherit `BUNDLE_ID_PREFIX` from `Configs/Secret.xcconfig` for consistency

**Before writing UI tests:** add stable `accessibilityIdentifier` values (set in code, not labels) to the key views you'll be tapping — search bar, result table cells, serving-size cell, favorites tab, profile selection rows, language switch rows. Localized labels change between `en` and `fr` and will break tests that rely on visible text. The priority surfaces to instrument are: `Search.m` (search bar + result table), `FoodDetail.m` (measure cell, favorite button, "All Nutritive Values" row), `Favorites.m` (table cells + edit button), `Profiles.m` / `ProfileSelection.m`, `Settings.m` / `SettingsLanguage.m`.

**Suggested first UI test suite:**

- First-launch profile selection flow
- Search "apple" → tap result → assert `FoodDetail` appears → tap measure → pick "1 cup" → verify nutrient value recomputes
- Add to favorites → switch to Favorites tab → assert row is present → swipe-delete → assert empty state returns
- Settings → Language → switch to Français → verify tab titles change
- Settings → About → verify the localized HTML loads (en + fr)

**One gotcha:** the test host for UI tests is the app itself, but XCUIApplication launches a fresh process, so `NSUserDefaults` state leaks across tests unless you reset in `setUp`. Pass `-StartFromClean YES` via `XCUIApplication.launchArguments` and read it in `AppDelegate` (you'll need to add that hook — it doesn't exist yet).

## When in doubt

- Read `README.md` for product context
- Read the relevant `*Helper.m` before touching cross-cutting behavior
- Ask the user before adding dependencies, changing the deployment target, or introducing a new language/framework
