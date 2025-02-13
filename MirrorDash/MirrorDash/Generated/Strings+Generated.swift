// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum AppStrings {
  /// Localizable.strings
  ///   MirrorDash
  internal static let howToPlay1 = AppStrings.tr("Localizable", "howToPlay1", fallback: "In Mirror Dash, you control two characters simultaneously as they move along mirrored tracks. One side of the screen displays a regular track, while the other shows its inverted version. Your goal is to avoid obstacles and collect bonuses, all while synchronizing the movements of both characters.")
  /// Tap the screen to control the characters. A single tap makes both characters jump at the same time. Stay focused to maintain your rhythm: the movement of one character can influence the other due to the mirrored nature of the tracks.
  internal static let howToPlay2 = AppStrings.tr("Localizable", "howToPlay2", fallback: "Tap the screen to control the characters. A single tap makes both characters jump at the same time. Stay focused to maintain your rhythm: the movement of one character can influence the other due to the mirrored nature of the tracks.")
  /// As you progress, you’ll encounter bonuses that make the game easier. For example, some bonuses slow down time, others grant temporary invincibility, or let you pass through obstacles unscathed. Use them wisely to reach the finish line.
  /// The objective is to guide both characters to the goal without colliding with obstacles. Attention, quick reflexes, and precise coordination are the keys to mastering Mirror Dash!
  internal static let howToPlay3 = AppStrings.tr("Localizable", "howToPlay3", fallback: "As you progress, you’ll encounter bonuses that make the game easier. For example, some bonuses slow down time, others grant temporary invincibility, or let you pass through obstacles unscathed. Use them wisely to reach the finish line.\nThe objective is to guide both characters to the goal without colliding with obstacles. Attention, quick reflexes, and precise coordination are the keys to mastering Mirror Dash!")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AppStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
