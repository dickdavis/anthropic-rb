# Changelog

## [Unreleased]

## [0.6.0] - 2024-06-25

### Breaking Changes

- Responses from the Anthropic API are now encapsulated as data objects.
- Dropped support for Ruby versions prior to 3.2.4.

### Added

- Added link to `anthropic-rb-cookbook`.

### Removed

- Removed streaming contraint for tools use.

### Updated

- Refactored project for maintainability.
- Updated project funding.

## [0.5.0] - 2024-04-22

### Updated

- Refactored project for maintainability.

### Breaking Changes

- You must now pass the beta ID when enabling a beta feature. The only current beta is for Tools (id: tools-2024-04-04). Previously, you would pass `true` to enable the beta.

## [0.4.0] - 2024-04-20

### Added

- Add support for the tools beta.

### Updated

- Remove beta header for Messages API as the API is no longer in beta.

## [0.3.0] - 2023-12-28

### Added

- Add support for sending headers to client.
- Add support for beta Messages API.

## [0.2.5] - 2023-12-27

### Fixed

- Fix documentation for streaming completions.
- Yank 0.2.4 release.

## [0.2.3] - 2023-12-27

### Fixed

- Fix links in CHANGELOG.md

## [0.2.2] - 2023-12-27

### Fixed

- Fix links in CHANGELOG.md

## [0.2.1] - 2023-12-27

### Fixed

- Update CHANGELOG.md

## [0.2.0] - 2023-12-27

### Added

- Add client for interactions with Anthropic API.
- Add support for completions.

## [0.1.0] - 2023-11-30

### Added

- Initial release

[Unreleased]: https://github.com/dickdavis/anthropic-rb/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/dickdavis/anthropic-rb/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/dickdavis/anthropic-rb/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/dickdavis/anthropic-rb/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/dickdavis/anthropic-rb/compare/v0.2.5...v0.3.0
[0.2.5]: https://github.com/dickdavis/anthropic-rb/compare/v0.2.3...v0.2.5
[0.2.3]: https://github.com/dickdavis/anthropic-rb/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/dickdavis/anthropic-rb/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/dickdavis/anthropic-rb/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/dickdavis/anthropic-rb/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/dickdavis/anthropic-rb/releases/tag/v0.1.0
