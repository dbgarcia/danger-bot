import Foundation
import Danger
import DangerSwiftCoverage
import XcodeProj
// import DangerXCodeSummary

let danger = Danger()

// Pull request size
let bigPRThreshold = 600
let additions = danger.github.pullRequest.additions!
let deletions = danger.github.pullRequest.deletions!
let changedFiles = danger.github.pullRequest.changedFiles!

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles
let podFileChanged = allSourceFiles.contains("Podfile")
let podFileLockChanged = allSourceFiles.contains("Podfile.lock")

if (additions + deletions > bigPRThreshold) && (!podFileChanged || podFileLockChanged) {
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
    fail("PR title is too short. 🙏 Please use this format `feature/NAME_000_TASK` for Feature or `release/1.2.3` for Release or `hotfix/1.2.3` for fix master")
}

if !prTitle.contains("release/") {
    fail("The Pull Request title does not follow the convention `release/1.2.4`. PR Title text")
}

if !prTitle.contains("feature/") {
    fail("The Pull Request title does not follow the convention `feature/NAME_TASKID_TITLE` and replace `TASKID` with Jira task number. PR Title text")
}

if !prTitle.contains("hotfix/") {
    fail("The Pull Request title does not follow the convention `hotfix/1.2.4`. PR Title text")
}

// Files changed and created should includes unit tests
let modified = danger.git.modifiedFiles
let editedFiles = modified + danger.git.createdFiles
let testFiles = editedFiles.filter { ($0.contains("Tests") || $0.contains("Test")) && ($0.fileType == .swift  || $0.fileType == .m) }
if testFiles.isEmpty {
    warn("PR does not contain any files related to unit tests ✅ (ignore if your changes do not require tests)")
}

message("🎉 The PR added \(additions) and removed \(deletions) lines. 🗂 \(changedFiles) files changed.")

// Run Swiftlint
// SwiftLint.lint(inline: true, configFile: ".swiftlint.yml")

// slather.configure("/Users/douglas.garcia/Documents/GitHub/danger-bot/TravisBot/TravisBot.xcodeproj", "TravisBotTests")
// slather.notify_if_coverage_is_less_than(minimum_coverage: 80)
// slather.notify_if_modified_file_is_less_than(minimum_coverage: 60)
// slather.show_coverage

// let report = XCodeSummary(filePath: "result.json")
// report.report()


let currentDirectoryPath = FileManager.default.currentDirectoryPath
print("currentDirectoryPath: \(currentDirectoryPath)")


let folderDerivedData = currentDirectoryPath.replacingOccurrences(of: "/Build/Products/Debug", with: "")

print("✅folderDerivedData: \(folderDerivedData)")

Coverage.xcodeBuildCoverage(.derivedDataFolder(folderDerivedData), minimumCoverage: 50, excludedTargets: ["DangerSwiftCoverageTests.xctest"])