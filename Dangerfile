# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"


# Fail the build based on code coverage
xcov.report(
  project: "TravisBot.xcodeproj",
  scheme: "TravisBotTests",
  minimum_coverage_percentage: 20.0,
  include_test_targets: true
)

## ** SwiftLint ***
swiftlint.binary_path = "./Pods/SwiftLint/swiftlint"
swiftlint.config_file = ".swiftlint.yml"
swiftlint.max_num_violations = 20

# Run SwiftLint and warn us if anything fails it
swiftlint.lint_files


# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if github.pr_title.include? "[WIP]"
    warn("`PR` is classed as Work in Progress") 
end

additions = git.added_files.length
modified = git.modified_files.length
deletions = git.deleted_files.length

warn(additions)
warn(modified)
warn(deletions)

# If these are all empty something has gone wrong, better to raise it in a comment
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
    warn("This `PR` has no changes at all, this is likely an issue during development.")
  end

if github.pr_title.length < 5
    fail("`PR` title is too short. 🙏 Please use this format `feature/NAME_000_TASK`, Your feature title and replace `000` with Jira task number.")
end

# Feature PR go to Develop
if github.branch_for_base != "develop" && (github.pr_title =~ /(feature)\//)
    fail("Please re-submit this PR to develop, we may have already fixed your issue.")
end

# Ensure that the Feature PR title follows the convention
if !(github.pr_title =~ /(feature)\//)
    fail("The Pull Request title does not follow the convention `feature/NAME_TASKID_TITLE` and replace `TASKID` with Jira task number. PR Title text")
end

# Ensure that the Release PR title follows the convention
if !(github.pr_title =~ /(release)\//)
    fail("The Pull Request title does not follow the convention `release/1.2.4`. PR Title text")
end

# Ensure that the Hotfix PR title follows the convention
if !(github.pr_title =~ /(hotfix)\//)
    fail("The Pull Request title does not follow the convention `hotfix/1.2.4`. PR Title text")
end

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title.
if github.pr_body.length < 3 && git.lines_of_code > 200
  warn("PR has no description. 📝 You should provide a description of the changes that have made.")
end

# Warn when there is a big PR
if git.lines_of_code > 300
    fail("PR size seems relatively large. ✂️ If this PR contains multiple changes, please split each into separate PR will helps faster, easier review.")
end

# Don't let testing shortcuts get into master by accident
if `grep -r fdescribe specs/ `.length > 1
    fail("fdescribe left in tests") 
end

if `grep -r fit specs/ `.length > 1
    fail("fit left in tests") 
end



message("🎉 The PR added \(additions) and removed \(deletions) lines. 🗂 \(modified) files changed.")