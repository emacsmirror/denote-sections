;;; denote-sections.el --- Universal Sidecar Sections for Denote -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Samuel W. Flint

;; Author: Samuel W. Flint <me@samuelwflint.com>
;; version: 0.0.1
;; Package-Requires: ((universal-sidecar "2.5.0") (denote "2.2.4") (emacs "27.1"))
;; Keywords: convenience, files, notes, hypermedia
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
;; TODO

;;; Code:

(require 'denote)
(require 'universal-sidecar)


;; Backlinks Section

(defvar-local denote-sections-backlinks-cache nil
  "Cache data for backlinks.")

(defun denote-sections-backlinks--get-backlinks (buffer)
  "Get denote backlinks for BUFFER."
  (with-current-buffer buffer
    (if denote-sections-backlinks-cache
        denote-sections-backlinks-cache          ;TODO: handle cache invalidation
      (when-let* ((filename buffer-file-name)
                  (id (denote-retrieve-filename-identifier filename))
                  (xref-file-name-display 'abs)
                  (dir (denote-directory))
                  (xref-alist (xref--analyze (xref-matches-in-files id (denote-directory-files nil :omit-current :text-only)))))
        (setq-local denote-sections-backlinks-cache xref-alist)))))

(universal-sidecar-define-section denote-sections-backlinks-section () (:predicate (stringp buffer-file-name))
  "Display backlinks for denote buffers."
  (when-let* ((backlinks (denote-sections-backlinks--get-backlinks buffer)))
    (universal-sidecar-insert-section denote-sections-backlinks-section "Backlinks:"
      (insert (universal-sidecar-fontify-as org-mode ()
                (with-temp-buffer
                  (dolist (group backlinks)
                    (let ((filename (car group)))
                      (insert (format " - [[file:%s][%s]] :: \n"
                                      (denote-get-file-name-relative-to-denote-directory filename)
                                      (denote-retrieve-title-value filename (denote-filetype-heuristics filename))))
                      (dolist (xref (cdr group))
                        (pcase-let (((cl-struct xref-item summary location) xref))
                          (let ((line (xref-location-line location)))
                            (insert (format "    + [[file:%s:%d][%d]]: %s\n" filename line line summary)))))))
                  (buffer-string)))))))

(provide 'denote-sections)

;;; denote-sections.el ends here
