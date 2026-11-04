# Contributing to PasteFerry

[简体中文](CONTRIBUTING.zh-CN.md)

Thank you for contributing. Keep each pull request focused on one independent
goal so it can be reviewed, tested and reverted on its own.

## One goal per pull request

- Submit one feature, one bug fix or one focused documentation improvement per
  PR. Include the tests and documentation directly needed for that change.
- Put unrelated features, refactors, dependency upgrades and incidental fixes
  in separate PRs, even when they touch the same files.
- There is no fixed limit on commits or changed lines. Scope and reviewability
  matter more than the commit count.
- PRs combining independent changes will be asked to split before review
  continues. Please do not keep adding new features to a PR already under review.

For example, a CLI version command, JSON query support and a Homebrew package
are separate goals. A feature's implementation, regression test and usage
documentation belong together. Fixing the same bug across several platforms
can also be one coherent PR.

## Discuss larger changes first

Before implementing a substantial feature, architecture change, new runtime
dependency or installation method, open an
[issue](https://github.com/baiyuze/pasteferry/issues) to discuss the problem,
proposed scope and approach with the maintainers.

Start a separate branch from the latest `main` for each independent change.
If a PR depends on another PR, link it and explain the dependency and intended
merge order. Keep unfinished work as a Draft PR.

## Describe the change and its validation

Use the PR template and provide:

1. The single problem or goal, with a related issue link when available.
2. The concrete changes and affected platforms or behavior.
3. The checks you actually ran, their results and manual reproduction or
   verification steps. State which relevant platforms were not tested.
4. Screenshots or a short recording for visible UI changes, plus any
   compatibility or migration implications.

Run checks appropriate to the change and address relevant CI failures before
requesting review. Add or update regression tests for bug fixes where practical;
documentation-only changes can be checked by reviewing formatting and links.
Build instructions are in [Building from source](guide/building.md).

During review, keep follow-up commits within the original goal. Submit new
ideas in another issue or PR. If splitting is requested, keep the original
discussion linked from the replacement PRs.
