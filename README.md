<!--
SPDX-FileCopyrightText: 2024 Samuel W. Flint <me@samuelwflint.com>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Denote Sidecar Sections

This package integrates [`denote`](https://protesilaos.com/emacs/denote) with the [Universal Sidecar](https://git.sr.ht/~swflint/emacs-universal-sidecar).
As of now, it provides only one section, a backlinks section to mimic that of `org-roam`.

The backlinks section, `denote-sections-backlinks-section` may be used as any other, simply add it to `universal-sidecar-sections`, it has no present customization.

## Citar-Denote

The [`citar-denote`](https://github.com/pprevos/citar-denote) package provides the ability to link bibliographic entries and notes.
This subpackage provides some further `universal-sidecar` sections.
These are as follows:

 - `denote-citar-sections-abstract-section` will display a formatted abstract if available.
 - `denote-citar-sections-reference-section` will display a formatted reference.
