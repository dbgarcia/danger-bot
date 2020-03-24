
import Danger

let danger = Danger()

// if danger.git.branch_for_base != "develop" {
//     fail("Please re-submit this PR to develop, we may have already fixed your issue.")
// }

// Pull request size
let bigPRThreshold = 600
let additions = danger.github.pullRequest.additions!
let deletions = danger.github.pullRequest.deletions!
let changedFiles = danger.github.pullRequest.changedFiles!
if (additions + deletions > bigPRThreshold) {
    fail("PR size seems relatively large. ✂️ If this PR contains multiple changes, please split each into separate PR will helps faster, easier review.")
}

// Pull request body validation
if danger.github.pullRequest.body == nil || danger.github.pullRequest.body!.isEmpty {
    warn("PR has no description. 📝 You should provide a description of the changes that have made.")
}

// Pull request title validation
let prTitle = danger.github.pullRequest.title
if prTitle.contains("WIP") {
    warn("PR is classed as _Work in Progress_.")
}

if prTitle.count < 5 {
    fail("PR title is too short. 🙏 Please use this format `feature/NAME_000_TASK Your feature title` and replace `000` with Jira task number.")
}

if !prTitle.contains("release/") {
    if !prTitle.contains("feature/") {
        warn("PR title does not containe the related Jira task. 🙏 Please use this format `feature/NAME_000_TASK Your feature title` and replace `000` with Jira task number.")
    }
}

// Files changed and created should includes unit tests
let modified = danger.git.modifiedFiles
let editedFiles = modified + danger.git.createdFiles
let testFiles = editedFiles.filter { ($0.contains("Tests") || $0.contains("Test")) && ($0.fileType == .swift  || $0.fileType == .m) }
if testFiles.isEmpty {
    warn("PR does not contain any files related to unit tests ✅ (ignore if your changes do not require tests)")
}

modified.forEach {
    warn("\($0)")

    if let fileTypeModified = $0.fileType, fileTypeModified.extension == "podspec" {
        warn("#{danger.git.html_link('\($0)'')}")
    }

    if $0 == "Gemfile" || $0 == "Gemfile.lock" {
        warn("#{danger.github.html_link(\($0))} was edited.")
    }

    if $0 == "Podfile" || $0 == "Podfile.lock" {
        warn("#{danger.git.html_link('Podfile')} was edited but #{danger.git.html_link('Podfile.lock')} wasn't. commit the #{danger.git.html_link('Podfile.lock')} changes.")
    }
}

// Run Swiftlint
SwiftLint.lint(inline: true, configFile: ".swiftlint.yml")

message("🎉 The PR added \(additions) and removed \(deletions) lines. 🗂 \(changedFiles) files changed.")

slather.configure("/Users/douglas.garcia/Documents/GitHub/danger-bot/TravisBot/TravisBot.xcodeproj", "TravisBotTests")
slather.notify_if_coverage_is_less_than(minimum_coverage: 80)
slather.notify_if_modified_file_is_less_than(minimum_coverage: 60)
slather.show_coverage