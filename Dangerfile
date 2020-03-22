# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

additions = git.added_files
// deletions = github.pullRequest.deletions!
changedFiles = git.modified_files

# Warn when there is a big PR
warn("Big PR, 🎉 The PR added \(additions) and removed \(0) lines. 🗂 \(changedFiles) files changed.") if git.lines_of_code > 0
warn("Large PR") if git.lines_of_code > 500
warn("Huge PR") if git.lines_of_code > 700
warn("Freakin Huge PR") if git.lines_of_code > 1000

# Don't let testing shortcuts get into master by accident
fail("fdescribe left in tests") if `grep -r fdescribe specs/ `.length > 1
fail("fit left in tests") if `grep -r fit specs/ `.length > 1

// Files changed and created should includes unit tests
// modified = git.modified_files
// editedFiles = modified + git.created_files
// testFiles = editedFiles.filter { ($0.contains("Tests") || $0.contains("Test")) && ($0.fileType == .swift  || $0.fileType == .m) }
// if testFiles.isEmpty {
//     warn("PR does not contain any files related to unit tests ✅ (ignore if your changes do not require tests)")
// }

message("🎉 The PR added \(additions) and removed \(0) lines. 🗂 \(changedFiles) files changed.")