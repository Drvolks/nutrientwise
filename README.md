# NutrientWise

A bilingual (English/French) iOS app for looking up nutritional information from the Canadian Nutrient File. Designed to help users track nutrients based on their specific dietary needs.

## Features

### Food Search
- Search thousands of foods from the Canadian Nutrient File database
- Results displayed in the user's selected language (English or French)
- Tap any food to view its full nutritional breakdown

### Nutritional Profiles
Six specialized profiles filter which nutrients are displayed, tailored to specific health goals:

- **Generic** — Calories, fat, saturated fat, trans fat, cholesterol, sodium, carbs, fibre, sugar, protein
- **Kidney Disease** — Protein, water, potassium, phosphorus, sodium, magnesium
- **Diabetes** — Carbohydrates, sugar, starch
- **Lipids** — Cholesterol, trans fat, monounsaturated fat, polyunsaturated fat, saturated fat, total fat
- **Hypertension** — Sodium
- **Pregnancy** — Protein, iron, calcium, fibre

### Serving Size Selection
- Choose from multiple serving sizes and measures for each food (e.g. 100g, 1 cup, 1 slice)
- Nutrient values update automatically based on the selected serving size

### Favorites
- Save frequently viewed foods to a favorites list
- Quick access from the dedicated Favorites tab
- Remembers preferred serving size per food

### iCloud Sync
- Language, profile, and favorites sync across devices via iCloud

### Bilingual
- Full English and French interface
- Automatically detects device language on first launch
- Switchable at any time from Settings

### First Launch
- Prompts user to choose a nutritional profile on first launch

## Data Source

Nutritional data comes from the [Canadian Nutrient File](https://www.canada.ca/en/health-canada/services/food-nutrition/healthy-eating/nutrient-data/canadian-nutrient-file-2015-download-files.html) (2015 edition), published by Health Canada.

## Technical Details

- Objective-C / UIKit (XIB-based, no Storyboards)
- Core Data with SQLite backing store
- UIScene lifecycle
- Targets iOS 26+
