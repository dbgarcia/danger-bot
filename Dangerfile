# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# src_root = File.expand_path('../', __FILE__)

# SCHEME = "TravisBot"

xcov.report(
  project: "TravisBot.xcodeproj",
  scheme: SCHEME,
  #scheme: 'TravisBotTests',
  exclude_targets: 'TravisBot.app',
  minimum_coverage_percentage: 90,
#   output_directory: "#{src_root}/build/#{SCHEME}/xcov",
#   derived_data_path: "#{src_root}/build/derived_data"
)

## ** SwiftLint ***
# swiftlint.binary_path = "/usr/local/bin/swiftlint"
# swiftlint.config_file = "#{src_root}/.swiftlint.yml"

# Run SwiftLint and warn us if anything fails it
# swiftlint.directory = src_root
# swiftlint.lint_files inline_mode: true


# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if github.pr_title.include? "[WIP]"
    warn("PR is classed as Work in Progress") 
end

if github.pr_title.length < 5
    fail("PR title is too short. 🙏 Please use this format `feature/NAME_000_TASK Your feature title` and replace `000` with Jira task number.")
end

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title.
if github.pr_body.length < 3 && git.lines_of_code > 60
  warn("PR has no description. 📝 You should provide a description of the changes that have made.")
end

# Warn when there is a big PR
if git.lines_of_code > 300
    warn("Big PR") 
end

if git.lines_of_code > 500
    warn("Large PR") 
end

if git.lines_of_code > 700
    warn("Huge PR") 
end

if git.lines_of_code > 1000
    warn("Freakin Huge PR") 
end

# Don't let testing shortcuts get into master by accident
if `grep -r fdescribe specs/ `.length > 1
    fail("fdescribe left in tests") 
end

if `grep -r fit specs/ `.length > 1
    fail("fit left in tests") 
end

additions = git.added_files.length
changedFiles = git.modified_files.length


message("🎉 The PR added \(additions) and removed \(0) lines. 🗂 \(changedFiles) files changed.")