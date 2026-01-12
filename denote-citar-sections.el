;;; denote-citar-sections.el --- Universal Sidecar sections for citar-denote  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Samuel W. Flint

;; Author: Samuel W. Flint <me@samuelwflint.com>
;; Version: 0.3.0
;; Package-Requires: ((emacs "26.1") (denote "2.2.4") (universal-sidecar "1.5.0") (citar-denote "2.2.2") (citar "1.4"))
;; Keywords: convenience, files, hypermedia, notes
;; URL: https://git.sr.ht/~swflint/denote-sections
;; SPDX-License-Identifier: GPL-3.0-or-later
;; SPDX-FileCopyrightText: 2024 Samuel W. Flint <swflint@flintfam.org>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; The `citar-denote' (https://github.com/pprevos/citar-denote)
;; package provides the ability to link bibliographic entries and
;; notes.  This subpackage provides some further `universal-sidecar'
;; sections.  These are as follows:
;;
;;  - `denote-citar-sections-abstract-section' will display a
;;    formatted abstract if available.
;; - `denote-citar-sections-reference-section' will display a
;;   formatted reference.

;;; Code:

(require 'denote)
(require 'citar)
(require 'citar-denote)
(require 'universal-sidecar)


;; Utility Functions

(defun denote-citar-sections--get-keys (buffer)
  "Get citation keys for BUFFER."
  (with-current-buffer buffer
    (when (denote-file-is-note-p (buffer-file-name))
      (citar-denote--retrieve-references (buffer-file-name)))))


;; Formatted Abstract Section

;; TODO: Get *raw* and use pandoc to format as org?
(universal-sidecar-define-section denote-citar-sections-abstract-section ((title "Abstract:"))
                                  (:predicate (stringp buffer-file-name))
  "Display a formatted abstract for BUFFER in SIDECAR.

The section TITLE is customizable via keyword argument."
  (when-let* ((key (car (denote-citar-sections--get-keys buffer)))
              (citation-data (citar-get-entry key))
              (abstract (alist-get "abstract" citation-data nil nil #'string=)))
    (universal-sidecar-insert-section denote-citar-sections-abstract-section title
      (insert abstract))))


;; Formatted Reference Section

;; TODO: Use universal-sidecar-citeproc?
(universal-sidecar-define-section denote-citar-sections-reference-section ((title "Reference:"))
                                  (:predicate (stringp buffer-file-name))
  "Display a formatted reference for BUFFER in SIDECAR, with TITLE."
  (when-let* ((key (car (denote-citar-sections--get-keys buffer))))
    (universal-sidecar-insert-section denote-citar-sections-reference-section title
      (insert (citar-format-reference (list key))))))


(provide 'denote-citar-sections)
;;; denote-citar-sections.el ends here
