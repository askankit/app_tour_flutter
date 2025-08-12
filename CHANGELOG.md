# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-12
### Added
- Initial release of **Custom App Tour for Flutter**.
- `CustomAppTour` class to manage and display interactive guided tours.
- `TourStep` model to define target widget, title, and description for each step.
- `HoleOverlay` widget to create a transparent highlight area over a target widget.
- `CustomSpeechBubble` widget to display tooltips with arrow indicators.
- Automatic scrolling to bring target widgets into view.
- Configurable positioning of speech bubbles (above or below the target).
- Smooth transitions between steps.

## [1.0.1] - 2025-08-13
### Fixed
- Improved positioning logic for speech bubble when near screen edges.
- Prevented tooltip from going off-screen in small viewport scenarios.

## [1.1.0] - 2025-08-15
### Added
- Screenshot placeholders in README for better documentation.
- Example usage section with code snippets.

### Changed
- Updated overlay transparency for improved readability.
- Adjusted default bubble width for better mobile display.

