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
- `Nutrient WiseTests/` — XCTest unit test target
- `Nutrient WiseUITests/` — XCUITest UI test target (create if missing — see "Testing" below)
- `Configs/` — xcconfig files; `Secret.xcconfig` is gitignored and holds `BUNDLE_ID_PREFIX` + `DEVELOPMENT_TEAM`. A `Secret.xcconfig.template` is checked in.
- `Model.xcdatamodeld/` — Core Data model
- `en.lproj/`, `fr.lproj/` — localized strings and HTML (`about-en.html`, `about-fr.html`)
- `HockeySDK-iOS/` — legacy crash reporting (do not modernize without asking)
- `GoogleService-Info.plist` — Firebase config; a `.template` is checked in, the real file is gitignored

## Scheme and targets

- App scheme: **Nutrient Wise**
- Unit test target: **Nutrient WiseTests** (XCTest)
- UI test target: **Nutrient WiseUITests** (XCUITest) — may not exist yet; add it if you need to write UI tests
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

**Coverage target: 80% line coverage across the app target.** When adding or changing code, add tests to keep the overall line coverage at or above 80%. If a change would drop coverage below the target, flag it before finishing.

Two test targets:

- **Nutrient WiseTests** — XCTest unit tests. Cover helpers (`LanguageHelper`, `ProfileHelper`, `FavoriteHelper`, `ArrayHelper`, `CellHelper`), `Finder` queries against Core Data, model logic, and anything that can be tested without the UI. Prefer an in-memory Core Data stack or a fixture copy of `DATA_v3.sqlite` — never mutate the shipped database.
- **Nutrient WiseUITests** — XCUITest UI tests. Cover the user-visible flows: search → select food → pick serving size → view nutrients, profile selection on first launch, favorites add/remove, language switching, settings. Use accessibility identifiers set in code (not labels) so tests survive localization. If the UI test target does not exist yet, create it as an XCUITest target before writing tests — do not try to drive the UI from the unit test target.

**Running tests with XcodeBuildMCP:**

- Full run: `test_sim` against the `Nutrient Wise` scheme (runs both targets if both are attached to the scheme)
- After a run, pull coverage with `get_coverage_report` for the overall number and `get_file_coverage` to see which files are dragging the average down
- When coverage drops below 80%, prioritize covering the uncovered files with the highest line counts first — don't chase easy wins on tiny files

**What to test vs. skip:**

- Test: helpers, `Finder`, Core Data fetches, profile filtering, unit conversion via `ConversionFactor`/`Measure`, favorites persistence
- Skip from coverage goals: generated model accessors, `main.m`, `AppDelegate`/`SceneDelegate` boilerplate, HockeySDK glue, and pure XIB wiring — exclude these from the coverage denominator if Xcode lets you, otherwise accept that they pull the number down and compensate with thorough helper/Finder tests

## When in doubt

- Read `README.md` for product context
- Read the relevant `*Helper.m` before touching cross-cutting behavior
- Ask the user before adding dependencies, changing the deployment target, or introducing a new language/framework
