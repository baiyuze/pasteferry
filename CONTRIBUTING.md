# Contributing to PasteFerry

[简体中文](CONTRIBUTING.zh-CN.md)

Thank you for contributing. Keep each pull request focused on one independent
goal so it can be reviewed, tested and reverted on its own.

## One goal per pull request

- Submit one feature, one bug fix or one focused documentation improvement per
  PR. Include the tests and documentation directly needed for that change.
- Put unrelated features, refactors, dependency upgrades and incidental fixes
  in separate PRs, even when they touch the same files. Supporting refactors or
  dependency changes needed for the current goal can stay together; explain
  why they are needed.
- There is no fixed limit on commits or changed lines. Scope and reviewability
  matter more than the commit count.
- If a PR combines independent goals, maintainers will discuss its scope and
  how to split it with you. Keep unrelated new features out of a PR already
  under review.

Changes that can be reviewed, tested and reverted independently are usually
best submitted separately. For example, an installation improvement and an
unrelated UI feature usually belong in separate PRs. A feature's implementation,
regression test and usage documentation belong together. Fixing the same bug
across several platforms can also be one coherent PR. If a larger change needs
to stay together to achieve one goal, explain the relationship and discuss the
scope with the maintainers.

## Discuss larger changes first

Before implementing a substantial feature, architecture change, new runtime
dependency or installation method, open an
[issue](https://github.com/baiyuze/pasteferry/issues) to discuss the problem,
proposed scope and approach with the maintainers.

The [feature proposal template](https://github.com/baiyuze/pasteferry/issues/new?template=feature_proposal.yml)
provides a short starting point; you do not need a finished implementation to
start the discussion. Small, focused fixes and documentation improvements can
be submitted directly as PRs.

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

Run checks appropriate to the change and address CI failures introduced by it
before requesting review. If an existing CI failure or an environment problem
blocks validation, describe it so it can be investigated together. You do not
need access to every supported platform: report the checks you could run and
the coverage limits; CI or maintainers can help with the remaining platforms.
Add or update regression tests for bug fixes where practical; documentation-only
changes can be checked by reviewing formatting and links.
Build instructions are in [Building from source](guide/building.md).

During review, keep follow-up commits within the original goal. Submit new
ideas in another issue or PR. If splitting is requested, keep the original
discussion linked from the replacement PRs.

## Preserve contribution sources

When maintainers adopt part of a PR or reorganize an external contribution,
they will link the original PR and the resulting commits, and describe what
was included and what remains outside the change.

Preserve original authorship when retaining a contributor's commits. When
combining substantial contributed code into a new commit, record appropriate
credit, such as a `Co-authored-by` trailer using the contributor's supplied
author information. When an idea is reimplemented, cite the original proposal
and thank its contributor rather than implying that their commits were merged.

For PRs submitted before these guidelines or a later revision, discuss the
scope and any proposed split with the contributor. Do not treat a contribution
as having violated requirements that were introduced after it was submitted.
