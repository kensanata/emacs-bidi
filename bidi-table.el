;;; bidi-table.el --- bidi type categories for Emacs -*- coding: iso-2022-7bit -*-

;; Copyright (C) 2001  Alex Schroeder <alex@gnu.org>

;; Version: $Id: bidi-table.el,v 1.5 2001/11/21 11:50:40 alex Exp $
;; Keywords: wp
;; Author: Alex Schroeder <alex@gnu.org>
;; Maintainer: Alex Schroeder <alex@gnu.org>
;; URL: http://www.emacswiki.org/cgi-bin/wiki.pl?CategoryBiDi

;; This file is not part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.
;;
;; This is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
;; for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
;; MA 02111-1307, USA.

;;; Commentary:

;; This file uses some character categories to store bidi type
;; information (L, R, AL, EN, etc.).  The information herein is derived
;; from UnicodeData.txt.  Furthermore, an alist for character mirroring
;; is created.  The information therein is derived from
;; BidiMirroring.txt.  Both files are available from
;; http://www.unicode.org/.

;;; Code:

;; Parsing BidiMirroring.txt

;; (defun my-bidi-extract-mirrors ()
;;   (interactive)
;;   (let* ((buf (get-buffer-create "*bidi*"))
;; 	 (standard-output buf))
;;     (princ "'(")
;;     (while (re-search-forward
;; 	    "^\\([0-9A-Z]...\\); \\([0-9A-Z]...\\)\\( # \\(.*\\)\\)?" 
;; 	    nil t)
;;       (princ "(?\\x")
;;       (princ (match-string 1))
;;       (princ " . ")
;;       (princ (match-string 2))
;;       (princ ") ;; ")
;;       (when (match-string 4)
;; 	(princ (match-string 4)))
;;       (princ "\n"))
;;     (princ ")\n")
;;     (switch-to-buffer buf)))

;; Parsing UnicodeData.txt

;; (defun my-bidi-extract-field ()
;;   (interactive)
;;   (let* ((pos (point-min))
;; 	 (buf (get-buffer-create "*bidi*"))
;; 	 (standard-output buf))
;;     (princ "'(")
;;     (while (search-forward ";" nil t)
;;       (princ "(?\\x")
;;       (princ (buffer-substring-no-properties pos (1- (point))))
;;       (princ " . bidi-category-")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (setq pos (point))
;;       (search-forward ";")
;;       (princ (downcase (buffer-substring-no-properties pos (1- (point)))))
;;       (princ ") ;; ")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (search-forward ";")
;;       (setq pos (point))
;;       (search-forward ";")
;;       (princ (buffer-substring-no-properties pos (1- (point))))
;;       (princ "\n")
;;       (forward-line 1)
;;       (setq pos (point)))
;;     (princ ")\n")
;;     (switch-to-buffer buf)))

(defvar bidi-mirroring-table nil
  "Mappings for mirror characters.
This is an alist where each element has the form (CHAR . MIRROR-CHAR).
Both characters are multi-byte characters.")

(let ((table (standard-category-table))
      ;; FIXME: the bidi types used here are actually variables
      ;; Replace these with the real categories as soon as we have
      ;; reserved the definite list of categories to use.
      (ucs-bidi-alist
       '((?\x0000 . bidi-category-bn) ;; NULL
	 (?\x0001 . bidi-category-bn) ;; START OF HEADING
	 (?\x0002 . bidi-category-bn) ;; START OF TEXT
	 (?\x0003 . bidi-category-bn) ;; END OF TEXT
	 (?\x0004 . bidi-category-bn) ;; END OF TRANSMISSION
	 (?\x0005 . bidi-category-bn) ;; ENQUIRY
	 (?\x0006 . bidi-category-bn) ;; ACKNOWLEDGE
	 (?\x0007 . bidi-category-bn) ;; BELL
	 (?\x0008 . bidi-category-bn) ;; BACKSPACE
	 (?\x0009 . bidi-category-s) ;; HORIZONTAL TABULATION
	 (?\x000A . bidi-category-b) ;; LINE FEED
	 (?\x000B . bidi-category-s) ;; VERTICAL TABULATION
	 (?\x000C . bidi-category-ws) ;; FORM FEED
	 (?\x000D . bidi-category-b) ;; CARRIAGE RETURN
	 (?\x000E . bidi-category-bn) ;; SHIFT OUT
	 (?\x000F . bidi-category-bn) ;; SHIFT IN
	 (?\x0010 . bidi-category-bn) ;; DATA LINK ESCAPE
	 (?\x0011 . bidi-category-bn) ;; DEVICE CONTROL ONE
	 (?\x0012 . bidi-category-bn) ;; DEVICE CONTROL TWO
	 (?\x0013 . bidi-category-bn) ;; DEVICE CONTROL THREE
	 (?\x0014 . bidi-category-bn) ;; DEVICE CONTROL FOUR
	 (?\x0015 . bidi-category-bn) ;; NEGATIVE ACKNOWLEDGE
	 (?\x0016 . bidi-category-bn) ;; SYNCHRONOUS IDLE
	 (?\x0017 . bidi-category-bn) ;; END OF TRANSMISSION BLOCK
	 (?\x0018 . bidi-category-bn) ;; CANCEL
	 (?\x0019 . bidi-category-bn) ;; END OF MEDIUM
	 (?\x001A . bidi-category-bn) ;; SUBSTITUTE
	 (?\x001B . bidi-category-bn) ;; ESCAPE
	 (?\x001C . bidi-category-b) ;; FILE SEPARATOR
	 (?\x001D . bidi-category-b) ;; GROUP SEPARATOR
	 (?\x001E . bidi-category-b) ;; RECORD SEPARATOR
	 (?\x001F . bidi-category-s) ;; UNIT SEPARATOR
	 (?\x0020 . bidi-category-ws) ;; 
	 (?\x0021 . bidi-category-on) ;; 
	 (?\x0022 . bidi-category-on) ;; 
	 (?\x0023 . bidi-category-et) ;; 
	 (?\x0024 . bidi-category-et) ;; 
	 (?\x0025 . bidi-category-et) ;; 
	 (?\x0026 . bidi-category-on) ;; 
	 (?\x0027 . bidi-category-on) ;; APOSTROPHE-QUOTE
	 (?\x0028 . bidi-category-on) ;; OPENING PARENTHESIS
	 (?\x0029 . bidi-category-on) ;; CLOSING PARENTHESIS
	 (?\x002A . bidi-category-on) ;; 
	 (?\x002B . bidi-category-et) ;; 
	 (?\x002C . bidi-category-cs) ;; 
	 (?\x002D . bidi-category-et) ;; 
	 (?\x002E . bidi-category-cs) ;; PERIOD
	 (?\x002F . bidi-category-es) ;; SLASH
	 (?\x0030 . bidi-category-en) ;; 
	 (?\x0031 . bidi-category-en) ;; 
	 (?\x0032 . bidi-category-en) ;; 
	 (?\x0033 . bidi-category-en) ;; 
	 (?\x0034 . bidi-category-en) ;; 
	 (?\x0035 . bidi-category-en) ;; 
	 (?\x0036 . bidi-category-en) ;; 
	 (?\x0037 . bidi-category-en) ;; 
	 (?\x0038 . bidi-category-en) ;; 
	 (?\x0039 . bidi-category-en) ;; 
	 (?\x003A . bidi-category-cs) ;; 
	 (?\x003B . bidi-category-on) ;; 
	 (?\x003C . bidi-category-on) ;; 
	 (?\x003D . bidi-category-on) ;; 
	 (?\x003E . bidi-category-on) ;; 
	 (?\x003F . bidi-category-on) ;; 
	 (?\x0040 . bidi-category-on) ;; 
	 (?\x0041 . bidi-category-l) ;; 
	 (?\x0042 . bidi-category-l) ;; 
	 (?\x0043 . bidi-category-l) ;; 
	 (?\x0044 . bidi-category-l) ;; 
	 (?\x0045 . bidi-category-l) ;; 
	 (?\x0046 . bidi-category-l) ;; 
	 (?\x0047 . bidi-category-l) ;; 
	 (?\x0048 . bidi-category-l) ;; 
	 (?\x0049 . bidi-category-l) ;; 
	 (?\x004A . bidi-category-l) ;; 
	 (?\x004B . bidi-category-l) ;; 
	 (?\x004C . bidi-category-l) ;; 
	 (?\x004D . bidi-category-l) ;; 
	 (?\x004E . bidi-category-l) ;; 
	 (?\x004F . bidi-category-l) ;; 
	 (?\x0050 . bidi-category-l) ;; 
	 (?\x0051 . bidi-category-l) ;; 
	 (?\x0052 . bidi-category-l) ;; 
	 (?\x0053 . bidi-category-l) ;; 
	 (?\x0054 . bidi-category-l) ;; 
	 (?\x0055 . bidi-category-l) ;; 
	 (?\x0056 . bidi-category-l) ;; 
	 (?\x0057 . bidi-category-l) ;; 
	 (?\x0058 . bidi-category-l) ;; 
	 (?\x0059 . bidi-category-l) ;; 
	 (?\x005A . bidi-category-l) ;; 
	 (?\x005B . bidi-category-on) ;; OPENING SQUARE BRACKET
	 (?\x005C . bidi-category-on) ;; BACKSLASH
	 (?\x005D . bidi-category-on) ;; CLOSING SQUARE BRACKET
	 (?\x005E . bidi-category-on) ;; SPACING CIRCUMFLEX
	 (?\x005F . bidi-category-on) ;; SPACING UNDERSCORE
	 (?\x0060 . bidi-category-on) ;; SPACING GRAVE
	 (?\x0061 . bidi-category-l) ;; 
	 (?\x0062 . bidi-category-l) ;; 
	 (?\x0063 . bidi-category-l) ;; 
	 (?\x0064 . bidi-category-l) ;; 
	 (?\x0065 . bidi-category-l) ;; 
	 (?\x0066 . bidi-category-l) ;; 
	 (?\x0067 . bidi-category-l) ;; 
	 (?\x0068 . bidi-category-l) ;; 
	 (?\x0069 . bidi-category-l) ;; 
	 (?\x006A . bidi-category-l) ;; 
	 (?\x006B . bidi-category-l) ;; 
	 (?\x006C . bidi-category-l) ;; 
	 (?\x006D . bidi-category-l) ;; 
	 (?\x006E . bidi-category-l) ;; 
	 (?\x006F . bidi-category-l) ;; 
	 (?\x0070 . bidi-category-l) ;; 
	 (?\x0071 . bidi-category-l) ;; 
	 (?\x0072 . bidi-category-l) ;; 
	 (?\x0073 . bidi-category-l) ;; 
	 (?\x0074 . bidi-category-l) ;; 
	 (?\x0075 . bidi-category-l) ;; 
	 (?\x0076 . bidi-category-l) ;; 
	 (?\x0077 . bidi-category-l) ;; 
	 (?\x0078 . bidi-category-l) ;; 
	 (?\x0079 . bidi-category-l) ;; 
	 (?\x007A . bidi-category-l) ;; 
	 (?\x007B . bidi-category-on) ;; OPENING CURLY BRACKET
	 (?\x007C . bidi-category-on) ;; VERTICAL BAR
	 (?\x007D . bidi-category-on) ;; CLOSING CURLY BRACKET
	 (?\x007E . bidi-category-on) ;; 
	 (?\x007F . bidi-category-bn) ;; DELETE
	 (?\x0080 . bidi-category-bn) ;; 
	 (?\x0081 . bidi-category-bn) ;; 
	 (?\x0082 . bidi-category-bn) ;; BREAK PERMITTED HERE
	 (?\x0083 . bidi-category-bn) ;; NO BREAK HERE
	 (?\x0084 . bidi-category-bn) ;; 
	 (?\x0085 . bidi-category-b) ;; NEXT LINE
	 (?\x0086 . bidi-category-bn) ;; START OF SELECTED AREA
	 (?\x0087 . bidi-category-bn) ;; END OF SELECTED AREA
	 (?\x0088 . bidi-category-bn) ;; CHARACTER TABULATION SET
	 (?\x0089 . bidi-category-bn) ;; CHARACTER TABULATION WITH JUSTIFICATION
	 (?\x008A . bidi-category-bn) ;; LINE TABULATION SET
	 (?\x008B . bidi-category-bn) ;; PARTIAL LINE DOWN
	 (?\x008C . bidi-category-bn) ;; PARTIAL LINE UP
	 (?\x008D . bidi-category-bn) ;; REVERSE LINE FEED
	 (?\x008E . bidi-category-bn) ;; SINGLE SHIFT TWO
	 (?\x008F . bidi-category-bn) ;; SINGLE SHIFT THREE
	 (?\x0090 . bidi-category-bn) ;; DEVICE CONTROL STRING
	 (?\x0091 . bidi-category-bn) ;; PRIVATE USE ONE
	 (?\x0092 . bidi-category-bn) ;; PRIVATE USE TWO
	 (?\x0093 . bidi-category-bn) ;; SET TRANSMIT STATE
	 (?\x0094 . bidi-category-bn) ;; CANCEL CHARACTER
	 (?\x0095 . bidi-category-bn) ;; MESSAGE WAITING
	 (?\x0096 . bidi-category-bn) ;; START OF GUARDED AREA
	 (?\x0097 . bidi-category-bn) ;; END OF GUARDED AREA
	 (?\x0098 . bidi-category-bn) ;; START OF STRING
	 (?\x0099 . bidi-category-bn) ;; 
	 (?\x009A . bidi-category-bn) ;; SINGLE CHARACTER INTRODUCER
	 (?\x009B . bidi-category-bn) ;; CONTROL SEQUENCE INTRODUCER
	 (?\x009C . bidi-category-bn) ;; STRING TERMINATOR
	 (?\x009D . bidi-category-bn) ;; OPERATING SYSTEM COMMAND
	 (?\x009E . bidi-category-bn) ;; PRIVACY MESSAGE
	 (?\x009F . bidi-category-bn) ;; APPLICATION PROGRAM COMMAND
	 (?\x00A0 . bidi-category-cs) ;; NON-BREAKING SPACE
	 (?\x00A1 . bidi-category-on) ;; 
	 (?\x00A2 . bidi-category-et) ;; 
	 (?\x00A3 . bidi-category-et) ;; 
	 (?\x00A4 . bidi-category-et) ;; 
	 (?\x00A5 . bidi-category-et) ;; 
	 (?\x00A6 . bidi-category-on) ;; BROKEN VERTICAL BAR
	 (?\x00A7 . bidi-category-on) ;; 
	 (?\x00A8 . bidi-category-on) ;; SPACING DIAERESIS
	 (?\x00A9 . bidi-category-on) ;; 
	 (?\x00AA . bidi-category-l) ;; 
	 (?\x00AB . bidi-category-on) ;; LEFT POINTING GUILLEMET
	 (?\x00AC . bidi-category-on) ;; 
	 (?\x00AD . bidi-category-on) ;; 
	 (?\x00AE . bidi-category-on) ;; REGISTERED TRADE MARK SIGN
	 (?\x00AF . bidi-category-on) ;; SPACING MACRON
	 (?\x00B0 . bidi-category-et) ;; 
	 (?\x00B1 . bidi-category-et) ;; PLUS-OR-MINUS SIGN
	 (?\x00B2 . bidi-category-en) ;; SUPERSCRIPT DIGIT TWO
	 (?\x00B3 . bidi-category-en) ;; SUPERSCRIPT DIGIT THREE
	 (?\x00B4 . bidi-category-on) ;; SPACING ACUTE
	 (?\x00B5 . bidi-category-l) ;; 
	 (?\x00B6 . bidi-category-on) ;; PARAGRAPH SIGN
	 (?\x00B7 . bidi-category-on) ;; 
	 (?\x00B8 . bidi-category-on) ;; SPACING CEDILLA
	 (?\x00B9 . bidi-category-en) ;; SUPERSCRIPT DIGIT ONE
	 (?\x00BA . bidi-category-l) ;; 
	 (?\x00BB . bidi-category-on) ;; RIGHT POINTING GUILLEMET
	 (?\x00BC . bidi-category-on) ;; FRACTION ONE QUARTER
	 (?\x00BD . bidi-category-on) ;; FRACTION ONE HALF
	 (?\x00BE . bidi-category-on) ;; FRACTION THREE QUARTERS
	 (?\x00BF . bidi-category-on) ;; 
	 (?\x00C0 . bidi-category-l) ;; LATIN CAPITAL LETTER A GRAVE
	 (?\x00C1 . bidi-category-l) ;; LATIN CAPITAL LETTER A ACUTE
	 (?\x00C2 . bidi-category-l) ;; LATIN CAPITAL LETTER A CIRCUMFLEX
	 (?\x00C3 . bidi-category-l) ;; LATIN CAPITAL LETTER A TILDE
	 (?\x00C4 . bidi-category-l) ;; LATIN CAPITAL LETTER A DIAERESIS
	 (?\x00C5 . bidi-category-l) ;; LATIN CAPITAL LETTER A RING
	 (?\x00C6 . bidi-category-l) ;; LATIN CAPITAL LETTER A E
	 (?\x00C7 . bidi-category-l) ;; LATIN CAPITAL LETTER C CEDILLA
	 (?\x00C8 . bidi-category-l) ;; LATIN CAPITAL LETTER E GRAVE
	 (?\x00C9 . bidi-category-l) ;; LATIN CAPITAL LETTER E ACUTE
	 (?\x00CA . bidi-category-l) ;; LATIN CAPITAL LETTER E CIRCUMFLEX
	 (?\x00CB . bidi-category-l) ;; LATIN CAPITAL LETTER E DIAERESIS
	 (?\x00CC . bidi-category-l) ;; LATIN CAPITAL LETTER I GRAVE
	 (?\x00CD . bidi-category-l) ;; LATIN CAPITAL LETTER I ACUTE
	 (?\x00CE . bidi-category-l) ;; LATIN CAPITAL LETTER I CIRCUMFLEX
	 (?\x00CF . bidi-category-l) ;; LATIN CAPITAL LETTER I DIAERESIS
	 (?\x00D0 . bidi-category-l) ;; 
	 (?\x00D1 . bidi-category-l) ;; LATIN CAPITAL LETTER N TILDE
	 (?\x00D2 . bidi-category-l) ;; LATIN CAPITAL LETTER O GRAVE
	 (?\x00D3 . bidi-category-l) ;; LATIN CAPITAL LETTER O ACUTE
	 (?\x00D4 . bidi-category-l) ;; LATIN CAPITAL LETTER O CIRCUMFLEX
	 (?\x00D5 . bidi-category-l) ;; LATIN CAPITAL LETTER O TILDE
	 (?\x00D6 . bidi-category-l) ;; LATIN CAPITAL LETTER O DIAERESIS
	 (?\x00D7 . bidi-category-on) ;; 
	 (?\x00D8 . bidi-category-l) ;; LATIN CAPITAL LETTER O SLASH
	 (?\x00D9 . bidi-category-l) ;; LATIN CAPITAL LETTER U GRAVE
	 (?\x00DA . bidi-category-l) ;; LATIN CAPITAL LETTER U ACUTE
	 (?\x00DB . bidi-category-l) ;; LATIN CAPITAL LETTER U CIRCUMFLEX
	 (?\x00DC . bidi-category-l) ;; LATIN CAPITAL LETTER U DIAERESIS
	 (?\x00DD . bidi-category-l) ;; LATIN CAPITAL LETTER Y ACUTE
	 (?\x00DE . bidi-category-l) ;; 
	 (?\x00DF . bidi-category-l) ;; 
	 (?\x00E0 . bidi-category-l) ;; LATIN SMALL LETTER A GRAVE
	 (?\x00E1 . bidi-category-l) ;; LATIN SMALL LETTER A ACUTE
	 (?\x00E2 . bidi-category-l) ;; LATIN SMALL LETTER A CIRCUMFLEX
	 (?\x00E3 . bidi-category-l) ;; LATIN SMALL LETTER A TILDE
	 (?\x00E4 . bidi-category-l) ;; LATIN SMALL LETTER A DIAERESIS
	 (?\x00E5 . bidi-category-l) ;; LATIN SMALL LETTER A RING
	 (?\x00E6 . bidi-category-l) ;; LATIN SMALL LETTER A E
	 (?\x00E7 . bidi-category-l) ;; LATIN SMALL LETTER C CEDILLA
	 (?\x00E8 . bidi-category-l) ;; LATIN SMALL LETTER E GRAVE
	 (?\x00E9 . bidi-category-l) ;; LATIN SMALL LETTER E ACUTE
	 (?\x00EA . bidi-category-l) ;; LATIN SMALL LETTER E CIRCUMFLEX
	 (?\x00EB . bidi-category-l) ;; LATIN SMALL LETTER E DIAERESIS
	 (?\x00EC . bidi-category-l) ;; LATIN SMALL LETTER I GRAVE
	 (?\x00ED . bidi-category-l) ;; LATIN SMALL LETTER I ACUTE
	 (?\x00EE . bidi-category-l) ;; LATIN SMALL LETTER I CIRCUMFLEX
	 (?\x00EF . bidi-category-l) ;; LATIN SMALL LETTER I DIAERESIS
	 (?\x00F0 . bidi-category-l) ;; 
	 (?\x00F1 . bidi-category-l) ;; LATIN SMALL LETTER N TILDE
	 (?\x00F2 . bidi-category-l) ;; LATIN SMALL LETTER O GRAVE
	 (?\x00F3 . bidi-category-l) ;; LATIN SMALL LETTER O ACUTE
	 (?\x00F4 . bidi-category-l) ;; LATIN SMALL LETTER O CIRCUMFLEX
	 (?\x00F5 . bidi-category-l) ;; LATIN SMALL LETTER O TILDE
	 (?\x00F6 . bidi-category-l) ;; LATIN SMALL LETTER O DIAERESIS
	 (?\x00F7 . bidi-category-on) ;; 
	 (?\x00F8 . bidi-category-l) ;; LATIN SMALL LETTER O SLASH
	 (?\x00F9 . bidi-category-l) ;; LATIN SMALL LETTER U GRAVE
	 (?\x00FA . bidi-category-l) ;; LATIN SMALL LETTER U ACUTE
	 (?\x00FB . bidi-category-l) ;; LATIN SMALL LETTER U CIRCUMFLEX
	 (?\x00FC . bidi-category-l) ;; LATIN SMALL LETTER U DIAERESIS
	 (?\x00FD . bidi-category-l) ;; LATIN SMALL LETTER Y ACUTE
	 (?\x00FE . bidi-category-l) ;; 
	 (?\x00FF . bidi-category-l) ;; LATIN SMALL LETTER Y DIAERESIS
	 (?\x0100 . bidi-category-l) ;; LATIN CAPITAL LETTER A MACRON
	 (?\x0101 . bidi-category-l) ;; LATIN SMALL LETTER A MACRON
	 (?\x0102 . bidi-category-l) ;; LATIN CAPITAL LETTER A BREVE
	 (?\x0103 . bidi-category-l) ;; LATIN SMALL LETTER A BREVE
	 (?\x0104 . bidi-category-l) ;; LATIN CAPITAL LETTER A OGONEK
	 (?\x0105 . bidi-category-l) ;; LATIN SMALL LETTER A OGONEK
	 (?\x0106 . bidi-category-l) ;; LATIN CAPITAL LETTER C ACUTE
	 (?\x0107 . bidi-category-l) ;; LATIN SMALL LETTER C ACUTE
	 (?\x0108 . bidi-category-l) ;; LATIN CAPITAL LETTER C CIRCUMFLEX
	 (?\x0109 . bidi-category-l) ;; LATIN SMALL LETTER C CIRCUMFLEX
	 (?\x010A . bidi-category-l) ;; LATIN CAPITAL LETTER C DOT
	 (?\x010B . bidi-category-l) ;; LATIN SMALL LETTER C DOT
	 (?\x010C . bidi-category-l) ;; LATIN CAPITAL LETTER C HACEK
	 (?\x010D . bidi-category-l) ;; LATIN SMALL LETTER C HACEK
	 (?\x010E . bidi-category-l) ;; LATIN CAPITAL LETTER D HACEK
	 (?\x010F . bidi-category-l) ;; LATIN SMALL LETTER D HACEK
	 (?\x0110 . bidi-category-l) ;; LATIN CAPITAL LETTER D BAR
	 (?\x0111 . bidi-category-l) ;; LATIN SMALL LETTER D BAR
	 (?\x0112 . bidi-category-l) ;; LATIN CAPITAL LETTER E MACRON
	 (?\x0113 . bidi-category-l) ;; LATIN SMALL LETTER E MACRON
	 (?\x0114 . bidi-category-l) ;; LATIN CAPITAL LETTER E BREVE
	 (?\x0115 . bidi-category-l) ;; LATIN SMALL LETTER E BREVE
	 (?\x0116 . bidi-category-l) ;; LATIN CAPITAL LETTER E DOT
	 (?\x0117 . bidi-category-l) ;; LATIN SMALL LETTER E DOT
	 (?\x0118 . bidi-category-l) ;; LATIN CAPITAL LETTER E OGONEK
	 (?\x0119 . bidi-category-l) ;; LATIN SMALL LETTER E OGONEK
	 (?\x011A . bidi-category-l) ;; LATIN CAPITAL LETTER E HACEK
	 (?\x011B . bidi-category-l) ;; LATIN SMALL LETTER E HACEK
	 (?\x011C . bidi-category-l) ;; LATIN CAPITAL LETTER G CIRCUMFLEX
	 (?\x011D . bidi-category-l) ;; LATIN SMALL LETTER G CIRCUMFLEX
	 (?\x011E . bidi-category-l) ;; LATIN CAPITAL LETTER G BREVE
	 (?\x011F . bidi-category-l) ;; LATIN SMALL LETTER G BREVE
	 (?\x0120 . bidi-category-l) ;; LATIN CAPITAL LETTER G DOT
	 (?\x0121 . bidi-category-l) ;; LATIN SMALL LETTER G DOT
	 (?\x0122 . bidi-category-l) ;; LATIN CAPITAL LETTER G CEDILLA
	 (?\x0123 . bidi-category-l) ;; LATIN SMALL LETTER G CEDILLA
	 (?\x0124 . bidi-category-l) ;; LATIN CAPITAL LETTER H CIRCUMFLEX
	 (?\x0125 . bidi-category-l) ;; LATIN SMALL LETTER H CIRCUMFLEX
	 (?\x0126 . bidi-category-l) ;; LATIN CAPITAL LETTER H BAR
	 (?\x0127 . bidi-category-l) ;; LATIN SMALL LETTER H BAR
	 (?\x0128 . bidi-category-l) ;; LATIN CAPITAL LETTER I TILDE
	 (?\x0129 . bidi-category-l) ;; LATIN SMALL LETTER I TILDE
	 (?\x012A . bidi-category-l) ;; LATIN CAPITAL LETTER I MACRON
	 (?\x012B . bidi-category-l) ;; LATIN SMALL LETTER I MACRON
	 (?\x012C . bidi-category-l) ;; LATIN CAPITAL LETTER I BREVE
	 (?\x012D . bidi-category-l) ;; LATIN SMALL LETTER I BREVE
	 (?\x012E . bidi-category-l) ;; LATIN CAPITAL LETTER I OGONEK
	 (?\x012F . bidi-category-l) ;; LATIN SMALL LETTER I OGONEK
	 (?\x0130 . bidi-category-l) ;; LATIN CAPITAL LETTER I DOT
	 (?\x0131 . bidi-category-l) ;; 
	 (?\x0132 . bidi-category-l) ;; LATIN CAPITAL LETTER I J
	 (?\x0133 . bidi-category-l) ;; LATIN SMALL LETTER I J
	 (?\x0134 . bidi-category-l) ;; LATIN CAPITAL LETTER J CIRCUMFLEX
	 (?\x0135 . bidi-category-l) ;; LATIN SMALL LETTER J CIRCUMFLEX
	 (?\x0136 . bidi-category-l) ;; LATIN CAPITAL LETTER K CEDILLA
	 (?\x0137 . bidi-category-l) ;; LATIN SMALL LETTER K CEDILLA
	 (?\x0138 . bidi-category-l) ;; 
	 (?\x0139 . bidi-category-l) ;; LATIN CAPITAL LETTER L ACUTE
	 (?\x013A . bidi-category-l) ;; LATIN SMALL LETTER L ACUTE
	 (?\x013B . bidi-category-l) ;; LATIN CAPITAL LETTER L CEDILLA
	 (?\x013C . bidi-category-l) ;; LATIN SMALL LETTER L CEDILLA
	 (?\x013D . bidi-category-l) ;; LATIN CAPITAL LETTER L HACEK
	 (?\x013E . bidi-category-l) ;; LATIN SMALL LETTER L HACEK
	 (?\x013F . bidi-category-l) ;; 
	 (?\x0140 . bidi-category-l) ;; 
	 (?\x0141 . bidi-category-l) ;; LATIN CAPITAL LETTER L SLASH
	 (?\x0142 . bidi-category-l) ;; LATIN SMALL LETTER L SLASH
	 (?\x0143 . bidi-category-l) ;; LATIN CAPITAL LETTER N ACUTE
	 (?\x0144 . bidi-category-l) ;; LATIN SMALL LETTER N ACUTE
	 (?\x0145 . bidi-category-l) ;; LATIN CAPITAL LETTER N CEDILLA
	 (?\x0146 . bidi-category-l) ;; LATIN SMALL LETTER N CEDILLA
	 (?\x0147 . bidi-category-l) ;; LATIN CAPITAL LETTER N HACEK
	 (?\x0148 . bidi-category-l) ;; LATIN SMALL LETTER N HACEK
	 (?\x0149 . bidi-category-l) ;; LATIN SMALL LETTER APOSTROPHE N
	 (?\x014A . bidi-category-l) ;; 
	 (?\x014B . bidi-category-l) ;; 
	 (?\x014C . bidi-category-l) ;; LATIN CAPITAL LETTER O MACRON
	 (?\x014D . bidi-category-l) ;; LATIN SMALL LETTER O MACRON
	 (?\x014E . bidi-category-l) ;; LATIN CAPITAL LETTER O BREVE
	 (?\x014F . bidi-category-l) ;; LATIN SMALL LETTER O BREVE
	 (?\x0150 . bidi-category-l) ;; LATIN CAPITAL LETTER O DOUBLE ACUTE
	 (?\x0151 . bidi-category-l) ;; LATIN SMALL LETTER O DOUBLE ACUTE
	 (?\x0152 . bidi-category-l) ;; LATIN CAPITAL LETTER O E
	 (?\x0153 . bidi-category-l) ;; LATIN SMALL LETTER O E
	 (?\x0154 . bidi-category-l) ;; LATIN CAPITAL LETTER R ACUTE
	 (?\x0155 . bidi-category-l) ;; LATIN SMALL LETTER R ACUTE
	 (?\x0156 . bidi-category-l) ;; LATIN CAPITAL LETTER R CEDILLA
	 (?\x0157 . bidi-category-l) ;; LATIN SMALL LETTER R CEDILLA
	 (?\x0158 . bidi-category-l) ;; LATIN CAPITAL LETTER R HACEK
	 (?\x0159 . bidi-category-l) ;; LATIN SMALL LETTER R HACEK
	 (?\x015A . bidi-category-l) ;; LATIN CAPITAL LETTER S ACUTE
	 (?\x015B . bidi-category-l) ;; LATIN SMALL LETTER S ACUTE
	 (?\x015C . bidi-category-l) ;; LATIN CAPITAL LETTER S CIRCUMFLEX
	 (?\x015D . bidi-category-l) ;; LATIN SMALL LETTER S CIRCUMFLEX
	 (?\x015E . bidi-category-l) ;; LATIN CAPITAL LETTER S CEDILLA
	 (?\x015F . bidi-category-l) ;; LATIN SMALL LETTER S CEDILLA
	 (?\x0160 . bidi-category-l) ;; LATIN CAPITAL LETTER S HACEK
	 (?\x0161 . bidi-category-l) ;; LATIN SMALL LETTER S HACEK
	 (?\x0162 . bidi-category-l) ;; LATIN CAPITAL LETTER T CEDILLA
	 (?\x0163 . bidi-category-l) ;; LATIN SMALL LETTER T CEDILLA
	 (?\x0164 . bidi-category-l) ;; LATIN CAPITAL LETTER T HACEK
	 (?\x0165 . bidi-category-l) ;; LATIN SMALL LETTER T HACEK
	 (?\x0166 . bidi-category-l) ;; LATIN CAPITAL LETTER T BAR
	 (?\x0167 . bidi-category-l) ;; LATIN SMALL LETTER T BAR
	 (?\x0168 . bidi-category-l) ;; LATIN CAPITAL LETTER U TILDE
	 (?\x0169 . bidi-category-l) ;; LATIN SMALL LETTER U TILDE
	 (?\x016A . bidi-category-l) ;; LATIN CAPITAL LETTER U MACRON
	 (?\x016B . bidi-category-l) ;; LATIN SMALL LETTER U MACRON
	 (?\x016C . bidi-category-l) ;; LATIN CAPITAL LETTER U BREVE
	 (?\x016D . bidi-category-l) ;; LATIN SMALL LETTER U BREVE
	 (?\x016E . bidi-category-l) ;; LATIN CAPITAL LETTER U RING
	 (?\x016F . bidi-category-l) ;; LATIN SMALL LETTER U RING
	 (?\x0170 . bidi-category-l) ;; LATIN CAPITAL LETTER U DOUBLE ACUTE
	 (?\x0171 . bidi-category-l) ;; LATIN SMALL LETTER U DOUBLE ACUTE
	 (?\x0172 . bidi-category-l) ;; LATIN CAPITAL LETTER U OGONEK
	 (?\x0173 . bidi-category-l) ;; LATIN SMALL LETTER U OGONEK
	 (?\x0174 . bidi-category-l) ;; LATIN CAPITAL LETTER W CIRCUMFLEX
	 (?\x0175 . bidi-category-l) ;; LATIN SMALL LETTER W CIRCUMFLEX
	 (?\x0176 . bidi-category-l) ;; LATIN CAPITAL LETTER Y CIRCUMFLEX
	 (?\x0177 . bidi-category-l) ;; LATIN SMALL LETTER Y CIRCUMFLEX
	 (?\x0178 . bidi-category-l) ;; LATIN CAPITAL LETTER Y DIAERESIS
	 (?\x0179 . bidi-category-l) ;; LATIN CAPITAL LETTER Z ACUTE
	 (?\x017A . bidi-category-l) ;; LATIN SMALL LETTER Z ACUTE
	 (?\x017B . bidi-category-l) ;; LATIN CAPITAL LETTER Z DOT
	 (?\x017C . bidi-category-l) ;; LATIN SMALL LETTER Z DOT
	 (?\x017D . bidi-category-l) ;; LATIN CAPITAL LETTER Z HACEK
	 (?\x017E . bidi-category-l) ;; LATIN SMALL LETTER Z HACEK
	 (?\x017F . bidi-category-l) ;; 
	 (?\x0180 . bidi-category-l) ;; LATIN SMALL LETTER B BAR
	 (?\x0181 . bidi-category-l) ;; LATIN CAPITAL LETTER B HOOK
	 (?\x0182 . bidi-category-l) ;; LATIN CAPITAL LETTER B TOPBAR
	 (?\x0183 . bidi-category-l) ;; LATIN SMALL LETTER B TOPBAR
	 (?\x0184 . bidi-category-l) ;; 
	 (?\x0185 . bidi-category-l) ;; 
	 (?\x0186 . bidi-category-l) ;; 
	 (?\x0187 . bidi-category-l) ;; LATIN CAPITAL LETTER C HOOK
	 (?\x0188 . bidi-category-l) ;; LATIN SMALL LETTER C HOOK
	 (?\x0189 . bidi-category-l) ;; 
	 (?\x018A . bidi-category-l) ;; LATIN CAPITAL LETTER D HOOK
	 (?\x018B . bidi-category-l) ;; LATIN CAPITAL LETTER D TOPBAR
	 (?\x018C . bidi-category-l) ;; LATIN SMALL LETTER D TOPBAR
	 (?\x018D . bidi-category-l) ;; 
	 (?\x018E . bidi-category-l) ;; LATIN CAPITAL LETTER TURNED E
	 (?\x018F . bidi-category-l) ;; 
	 (?\x0190 . bidi-category-l) ;; LATIN CAPITAL LETTER EPSILON
	 (?\x0191 . bidi-category-l) ;; LATIN CAPITAL LETTER F HOOK
	 (?\x0192 . bidi-category-l) ;; LATIN SMALL LETTER SCRIPT F
	 (?\x0193 . bidi-category-l) ;; LATIN CAPITAL LETTER G HOOK
	 (?\x0194 . bidi-category-l) ;; 
	 (?\x0195 . bidi-category-l) ;; LATIN SMALL LETTER H V
	 (?\x0196 . bidi-category-l) ;; 
	 (?\x0197 . bidi-category-l) ;; LATIN CAPITAL LETTER BARRED I
	 (?\x0198 . bidi-category-l) ;; LATIN CAPITAL LETTER K HOOK
	 (?\x0199 . bidi-category-l) ;; LATIN SMALL LETTER K HOOK
	 (?\x019A . bidi-category-l) ;; LATIN SMALL LETTER BARRED L
	 (?\x019B . bidi-category-l) ;; LATIN SMALL LETTER BARRED LAMBDA
	 (?\x019C . bidi-category-l) ;; 
	 (?\x019D . bidi-category-l) ;; LATIN CAPITAL LETTER N HOOK
	 (?\x019E . bidi-category-l) ;; 
	 (?\x019F . bidi-category-l) ;; LATIN CAPITAL LETTER BARRED O
	 (?\x01A0 . bidi-category-l) ;; LATIN CAPITAL LETTER O HORN
	 (?\x01A1 . bidi-category-l) ;; LATIN SMALL LETTER O HORN
	 (?\x01A2 . bidi-category-l) ;; LATIN CAPITAL LETTER O I
	 (?\x01A3 . bidi-category-l) ;; LATIN SMALL LETTER O I
	 (?\x01A4 . bidi-category-l) ;; LATIN CAPITAL LETTER P HOOK
	 (?\x01A5 . bidi-category-l) ;; LATIN SMALL LETTER P HOOK
	 (?\x01A6 . bidi-category-l) ;; LATIN LETTER Y R
	 (?\x01A7 . bidi-category-l) ;; 
	 (?\x01A8 . bidi-category-l) ;; 
	 (?\x01A9 . bidi-category-l) ;; 
	 (?\x01AA . bidi-category-l) ;; 
	 (?\x01AB . bidi-category-l) ;; LATIN SMALL LETTER T PALATAL HOOK
	 (?\x01AC . bidi-category-l) ;; LATIN CAPITAL LETTER T HOOK
	 (?\x01AD . bidi-category-l) ;; LATIN SMALL LETTER T HOOK
	 (?\x01AE . bidi-category-l) ;; LATIN CAPITAL LETTER T RETROFLEX HOOK
	 (?\x01AF . bidi-category-l) ;; LATIN CAPITAL LETTER U HORN
	 (?\x01B0 . bidi-category-l) ;; LATIN SMALL LETTER U HORN
	 (?\x01B1 . bidi-category-l) ;; 
	 (?\x01B2 . bidi-category-l) ;; LATIN CAPITAL LETTER SCRIPT V
	 (?\x01B3 . bidi-category-l) ;; LATIN CAPITAL LETTER Y HOOK
	 (?\x01B4 . bidi-category-l) ;; LATIN SMALL LETTER Y HOOK
	 (?\x01B5 . bidi-category-l) ;; LATIN CAPITAL LETTER Z BAR
	 (?\x01B6 . bidi-category-l) ;; LATIN SMALL LETTER Z BAR
	 (?\x01B7 . bidi-category-l) ;; LATIN CAPITAL LETTER YOGH
	 (?\x01B8 . bidi-category-l) ;; LATIN CAPITAL LETTER REVERSED YOGH
	 (?\x01B9 . bidi-category-l) ;; LATIN SMALL LETTER REVERSED YOGH
	 (?\x01BA . bidi-category-l) ;; LATIN SMALL LETTER YOGH WITH TAIL
	 (?\x01BB . bidi-category-l) ;; LATIN LETTER TWO BAR
	 (?\x01BC . bidi-category-l) ;; 
	 (?\x01BD . bidi-category-l) ;; 
	 (?\x01BE . bidi-category-l) ;; LATIN LETTER INVERTED GLOTTAL STOP BAR
	 (?\x01BF . bidi-category-l) ;; 
	 (?\x01C0 . bidi-category-l) ;; LATIN LETTER PIPE
	 (?\x01C1 . bidi-category-l) ;; LATIN LETTER DOUBLE PIPE
	 (?\x01C2 . bidi-category-l) ;; LATIN LETTER PIPE DOUBLE BAR
	 (?\x01C3 . bidi-category-l) ;; LATIN LETTER EXCLAMATION MARK
	 (?\x01C4 . bidi-category-l) ;; LATIN CAPITAL LETTER D Z HACEK
	 (?\x01C5 . bidi-category-l) ;; LATIN LETTER CAPITAL D SMALL Z HACEK
	 (?\x01C6 . bidi-category-l) ;; LATIN SMALL LETTER D Z HACEK
	 (?\x01C7 . bidi-category-l) ;; LATIN CAPITAL LETTER L J
	 (?\x01C8 . bidi-category-l) ;; LATIN LETTER CAPITAL L SMALL J
	 (?\x01C9 . bidi-category-l) ;; LATIN SMALL LETTER L J
	 (?\x01CA . bidi-category-l) ;; LATIN CAPITAL LETTER N J
	 (?\x01CB . bidi-category-l) ;; LATIN LETTER CAPITAL N SMALL J
	 (?\x01CC . bidi-category-l) ;; LATIN SMALL LETTER N J
	 (?\x01CD . bidi-category-l) ;; LATIN CAPITAL LETTER A HACEK
	 (?\x01CE . bidi-category-l) ;; LATIN SMALL LETTER A HACEK
	 (?\x01CF . bidi-category-l) ;; LATIN CAPITAL LETTER I HACEK
	 (?\x01D0 . bidi-category-l) ;; LATIN SMALL LETTER I HACEK
	 (?\x01D1 . bidi-category-l) ;; LATIN CAPITAL LETTER O HACEK
	 (?\x01D2 . bidi-category-l) ;; LATIN SMALL LETTER O HACEK
	 (?\x01D3 . bidi-category-l) ;; LATIN CAPITAL LETTER U HACEK
	 (?\x01D4 . bidi-category-l) ;; LATIN SMALL LETTER U HACEK
	 (?\x01D5 . bidi-category-l) ;; LATIN CAPITAL LETTER U DIAERESIS MACRON
	 (?\x01D6 . bidi-category-l) ;; LATIN SMALL LETTER U DIAERESIS MACRON
	 (?\x01D7 . bidi-category-l) ;; LATIN CAPITAL LETTER U DIAERESIS ACUTE
	 (?\x01D8 . bidi-category-l) ;; LATIN SMALL LETTER U DIAERESIS ACUTE
	 (?\x01D9 . bidi-category-l) ;; LATIN CAPITAL LETTER U DIAERESIS HACEK
	 (?\x01DA . bidi-category-l) ;; LATIN SMALL LETTER U DIAERESIS HACEK
	 (?\x01DB . bidi-category-l) ;; LATIN CAPITAL LETTER U DIAERESIS GRAVE
	 (?\x01DC . bidi-category-l) ;; LATIN SMALL LETTER U DIAERESIS GRAVE
	 (?\x01DD . bidi-category-l) ;; 
	 (?\x01DE . bidi-category-l) ;; LATIN CAPITAL LETTER A DIAERESIS MACRON
	 (?\x01DF . bidi-category-l) ;; LATIN SMALL LETTER A DIAERESIS MACRON
	 (?\x01E0 . bidi-category-l) ;; LATIN CAPITAL LETTER A DOT MACRON
	 (?\x01E1 . bidi-category-l) ;; LATIN SMALL LETTER A DOT MACRON
	 (?\x01E2 . bidi-category-l) ;; LATIN CAPITAL LETTER A E MACRON
	 (?\x01E3 . bidi-category-l) ;; LATIN SMALL LETTER A E MACRON
	 (?\x01E4 . bidi-category-l) ;; LATIN CAPITAL LETTER G BAR
	 (?\x01E5 . bidi-category-l) ;; LATIN SMALL LETTER G BAR
	 (?\x01E6 . bidi-category-l) ;; LATIN CAPITAL LETTER G HACEK
	 (?\x01E7 . bidi-category-l) ;; LATIN SMALL LETTER G HACEK
	 (?\x01E8 . bidi-category-l) ;; LATIN CAPITAL LETTER K HACEK
	 (?\x01E9 . bidi-category-l) ;; LATIN SMALL LETTER K HACEK
	 (?\x01EA . bidi-category-l) ;; LATIN CAPITAL LETTER O OGONEK
	 (?\x01EB . bidi-category-l) ;; LATIN SMALL LETTER O OGONEK
	 (?\x01EC . bidi-category-l) ;; LATIN CAPITAL LETTER O OGONEK MACRON
	 (?\x01ED . bidi-category-l) ;; LATIN SMALL LETTER O OGONEK MACRON
	 (?\x01EE . bidi-category-l) ;; LATIN CAPITAL LETTER YOGH HACEK
	 (?\x01EF . bidi-category-l) ;; LATIN SMALL LETTER YOGH HACEK
	 (?\x01F0 . bidi-category-l) ;; LATIN SMALL LETTER J HACEK
	 (?\x01F1 . bidi-category-l) ;; 
	 (?\x01F2 . bidi-category-l) ;; 
	 (?\x01F3 . bidi-category-l) ;; 
	 (?\x01F4 . bidi-category-l) ;; 
	 (?\x01F5 . bidi-category-l) ;; 
	 (?\x01F6 . bidi-category-l) ;; 
	 (?\x01F7 . bidi-category-l) ;; 
	 (?\x01F8 . bidi-category-l) ;; 
	 (?\x01F9 . bidi-category-l) ;; 
	 (?\x01FA . bidi-category-l) ;; 
	 (?\x01FB . bidi-category-l) ;; 
	 (?\x01FC . bidi-category-l) ;; 
	 (?\x01FD . bidi-category-l) ;; 
	 (?\x01FE . bidi-category-l) ;; 
	 (?\x01FF . bidi-category-l) ;; 
	 (?\x0200 . bidi-category-l) ;; 
	 (?\x0201 . bidi-category-l) ;; 
	 (?\x0202 . bidi-category-l) ;; 
	 (?\x0203 . bidi-category-l) ;; 
	 (?\x0204 . bidi-category-l) ;; 
	 (?\x0205 . bidi-category-l) ;; 
	 (?\x0206 . bidi-category-l) ;; 
	 (?\x0207 . bidi-category-l) ;; 
	 (?\x0208 . bidi-category-l) ;; 
	 (?\x0209 . bidi-category-l) ;; 
	 (?\x020A . bidi-category-l) ;; 
	 (?\x020B . bidi-category-l) ;; 
	 (?\x020C . bidi-category-l) ;; 
	 (?\x020D . bidi-category-l) ;; 
	 (?\x020E . bidi-category-l) ;; 
	 (?\x020F . bidi-category-l) ;; 
	 (?\x0210 . bidi-category-l) ;; 
	 (?\x0211 . bidi-category-l) ;; 
	 (?\x0212 . bidi-category-l) ;; 
	 (?\x0213 . bidi-category-l) ;; 
	 (?\x0214 . bidi-category-l) ;; 
	 (?\x0215 . bidi-category-l) ;; 
	 (?\x0216 . bidi-category-l) ;; 
	 (?\x0217 . bidi-category-l) ;; 
	 (?\x0218 . bidi-category-l) ;; 
	 (?\x0219 . bidi-category-l) ;; 
	 (?\x021A . bidi-category-l) ;; 
	 (?\x021B . bidi-category-l) ;; 
	 (?\x021C . bidi-category-l) ;; 
	 (?\x021D . bidi-category-l) ;; 
	 (?\x021E . bidi-category-l) ;; 
	 (?\x021F . bidi-category-l) ;; 
	 (?\x0222 . bidi-category-l) ;; 
	 (?\x0223 . bidi-category-l) ;; 
	 (?\x0224 . bidi-category-l) ;; 
	 (?\x0225 . bidi-category-l) ;; 
	 (?\x0226 . bidi-category-l) ;; 
	 (?\x0227 . bidi-category-l) ;; 
	 (?\x0228 . bidi-category-l) ;; 
	 (?\x0229 . bidi-category-l) ;; 
	 (?\x022A . bidi-category-l) ;; 
	 (?\x022B . bidi-category-l) ;; 
	 (?\x022C . bidi-category-l) ;; 
	 (?\x022D . bidi-category-l) ;; 
	 (?\x022E . bidi-category-l) ;; 
	 (?\x022F . bidi-category-l) ;; 
	 (?\x0230 . bidi-category-l) ;; 
	 (?\x0231 . bidi-category-l) ;; 
	 (?\x0232 . bidi-category-l) ;; 
	 (?\x0233 . bidi-category-l) ;; 
	 (?\x0250 . bidi-category-l) ;; 
	 (?\x0251 . bidi-category-l) ;; LATIN SMALL LETTER SCRIPT A
	 (?\x0252 . bidi-category-l) ;; LATIN SMALL LETTER TURNED SCRIPT A
	 (?\x0253 . bidi-category-l) ;; LATIN SMALL LETTER B HOOK
	 (?\x0254 . bidi-category-l) ;; 
	 (?\x0255 . bidi-category-l) ;; LATIN SMALL LETTER C CURL
	 (?\x0256 . bidi-category-l) ;; LATIN SMALL LETTER D RETROFLEX HOOK
	 (?\x0257 . bidi-category-l) ;; LATIN SMALL LETTER D HOOK
	 (?\x0258 . bidi-category-l) ;; 
	 (?\x0259 . bidi-category-l) ;; 
	 (?\x025A . bidi-category-l) ;; LATIN SMALL LETTER SCHWA HOOK
	 (?\x025B . bidi-category-l) ;; LATIN SMALL LETTER EPSILON
	 (?\x025C . bidi-category-l) ;; LATIN SMALL LETTER REVERSED EPSILON
	 (?\x025D . bidi-category-l) ;; LATIN SMALL LETTER REVERSED EPSILON HOOK
	 (?\x025E . bidi-category-l) ;; LATIN SMALL LETTER CLOSED REVERSED EPSILON
	 (?\x025F . bidi-category-l) ;; LATIN SMALL LETTER DOTLESS J BAR
	 (?\x0260 . bidi-category-l) ;; LATIN SMALL LETTER G HOOK
	 (?\x0261 . bidi-category-l) ;; 
	 (?\x0262 . bidi-category-l) ;; 
	 (?\x0263 . bidi-category-l) ;; 
	 (?\x0264 . bidi-category-l) ;; LATIN SMALL LETTER BABY GAMMA
	 (?\x0265 . bidi-category-l) ;; 
	 (?\x0266 . bidi-category-l) ;; LATIN SMALL LETTER H HOOK
	 (?\x0267 . bidi-category-l) ;; LATIN SMALL LETTER HENG HOOK
	 (?\x0268 . bidi-category-l) ;; LATIN SMALL LETTER BARRED I
	 (?\x0269 . bidi-category-l) ;; 
	 (?\x026A . bidi-category-l) ;; 
	 (?\x026B . bidi-category-l) ;; 
	 (?\x026C . bidi-category-l) ;; LATIN SMALL LETTER L BELT
	 (?\x026D . bidi-category-l) ;; LATIN SMALL LETTER L RETROFLEX HOOK
	 (?\x026E . bidi-category-l) ;; LATIN SMALL LETTER L YOGH
	 (?\x026F . bidi-category-l) ;; 
	 (?\x0270 . bidi-category-l) ;; 
	 (?\x0271 . bidi-category-l) ;; LATIN SMALL LETTER M HOOK
	 (?\x0272 . bidi-category-l) ;; LATIN SMALL LETTER N HOOK
	 (?\x0273 . bidi-category-l) ;; LATIN SMALL LETTER N RETROFLEX HOOK
	 (?\x0274 . bidi-category-l) ;; 
	 (?\x0275 . bidi-category-l) ;; 
	 (?\x0276 . bidi-category-l) ;; LATIN LETTER SMALL CAPITAL O E
	 (?\x0277 . bidi-category-l) ;; 
	 (?\x0278 . bidi-category-l) ;; 
	 (?\x0279 . bidi-category-l) ;; 
	 (?\x027A . bidi-category-l) ;; 
	 (?\x027B . bidi-category-l) ;; LATIN SMALL LETTER TURNED R HOOK
	 (?\x027C . bidi-category-l) ;; 
	 (?\x027D . bidi-category-l) ;; LATIN SMALL LETTER R HOOK
	 (?\x027E . bidi-category-l) ;; LATIN SMALL LETTER FISHHOOK R
	 (?\x027F . bidi-category-l) ;; LATIN SMALL LETTER REVERSED FISHHOOK R
	 (?\x0280 . bidi-category-l) ;; 
	 (?\x0281 . bidi-category-l) ;; 
	 (?\x0282 . bidi-category-l) ;; LATIN SMALL LETTER S HOOK
	 (?\x0283 . bidi-category-l) ;; 
	 (?\x0284 . bidi-category-l) ;; LATIN SMALL LETTER DOTLESS J BAR HOOK
	 (?\x0285 . bidi-category-l) ;; 
	 (?\x0286 . bidi-category-l) ;; LATIN SMALL LETTER ESH CURL
	 (?\x0287 . bidi-category-l) ;; 
	 (?\x0288 . bidi-category-l) ;; LATIN SMALL LETTER T RETROFLEX HOOK
	 (?\x0289 . bidi-category-l) ;; 
	 (?\x028A . bidi-category-l) ;; 
	 (?\x028B . bidi-category-l) ;; LATIN SMALL LETTER SCRIPT V
	 (?\x028C . bidi-category-l) ;; 
	 (?\x028D . bidi-category-l) ;; 
	 (?\x028E . bidi-category-l) ;; 
	 (?\x028F . bidi-category-l) ;; 
	 (?\x0290 . bidi-category-l) ;; LATIN SMALL LETTER Z RETROFLEX HOOK
	 (?\x0291 . bidi-category-l) ;; LATIN SMALL LETTER Z CURL
	 (?\x0292 . bidi-category-l) ;; LATIN SMALL LETTER YOGH
	 (?\x0293 . bidi-category-l) ;; LATIN SMALL LETTER YOGH CURL
	 (?\x0294 . bidi-category-l) ;; 
	 (?\x0295 . bidi-category-l) ;; LATIN LETTER REVERSED GLOTTAL STOP
	 (?\x0296 . bidi-category-l) ;; 
	 (?\x0297 . bidi-category-l) ;; 
	 (?\x0298 . bidi-category-l) ;; LATIN LETTER BULLSEYE
	 (?\x0299 . bidi-category-l) ;; 
	 (?\x029A . bidi-category-l) ;; LATIN SMALL LETTER CLOSED EPSILON
	 (?\x029B . bidi-category-l) ;; LATIN LETTER SMALL CAPITAL G HOOK
	 (?\x029C . bidi-category-l) ;; 
	 (?\x029D . bidi-category-l) ;; LATIN SMALL LETTER CROSSED-TAIL J
	 (?\x029E . bidi-category-l) ;; 
	 (?\x029F . bidi-category-l) ;; 
	 (?\x02A0 . bidi-category-l) ;; LATIN SMALL LETTER Q HOOK
	 (?\x02A1 . bidi-category-l) ;; LATIN LETTER GLOTTAL STOP BAR
	 (?\x02A2 . bidi-category-l) ;; LATIN LETTER REVERSED GLOTTAL STOP BAR
	 (?\x02A3 . bidi-category-l) ;; LATIN SMALL LETTER D Z
	 (?\x02A4 . bidi-category-l) ;; LATIN SMALL LETTER D YOGH
	 (?\x02A5 . bidi-category-l) ;; LATIN SMALL LETTER D Z CURL
	 (?\x02A6 . bidi-category-l) ;; LATIN SMALL LETTER T S
	 (?\x02A7 . bidi-category-l) ;; LATIN SMALL LETTER T ESH
	 (?\x02A8 . bidi-category-l) ;; LATIN SMALL LETTER T C CURL
	 (?\x02A9 . bidi-category-l) ;; 
	 (?\x02AA . bidi-category-l) ;; 
	 (?\x02AB . bidi-category-l) ;; 
	 (?\x02AC . bidi-category-l) ;; 
	 (?\x02AD . bidi-category-l) ;; 
	 (?\x02B0 . bidi-category-l) ;; 
	 (?\x02B1 . bidi-category-l) ;; MODIFIER LETTER SMALL H HOOK
	 (?\x02B2 . bidi-category-l) ;; 
	 (?\x02B3 . bidi-category-l) ;; 
	 (?\x02B4 . bidi-category-l) ;; 
	 (?\x02B5 . bidi-category-l) ;; MODIFIER LETTER SMALL TURNED R HOOK
	 (?\x02B6 . bidi-category-l) ;; 
	 (?\x02B7 . bidi-category-l) ;; 
	 (?\x02B8 . bidi-category-l) ;; 
	 (?\x02B9 . bidi-category-on) ;; 
	 (?\x02BA . bidi-category-on) ;; 
	 (?\x02BB . bidi-category-l) ;; 
	 (?\x02BC . bidi-category-l) ;; 
	 (?\x02BD . bidi-category-l) ;; 
	 (?\x02BE . bidi-category-l) ;; 
	 (?\x02BF . bidi-category-l) ;; 
	 (?\x02C0 . bidi-category-l) ;; 
	 (?\x02C1 . bidi-category-l) ;; 
	 (?\x02C2 . bidi-category-on) ;; 
	 (?\x02C3 . bidi-category-on) ;; 
	 (?\x02C4 . bidi-category-on) ;; 
	 (?\x02C5 . bidi-category-on) ;; 
	 (?\x02C6 . bidi-category-on) ;; MODIFIER LETTER CIRCUMFLEX
	 (?\x02C7 . bidi-category-on) ;; MODIFIER LETTER HACEK
	 (?\x02C8 . bidi-category-on) ;; 
	 (?\x02C9 . bidi-category-on) ;; 
	 (?\x02CA . bidi-category-on) ;; MODIFIER LETTER ACUTE
	 (?\x02CB . bidi-category-on) ;; MODIFIER LETTER GRAVE
	 (?\x02CC . bidi-category-on) ;; 
	 (?\x02CD . bidi-category-on) ;; 
	 (?\x02CE . bidi-category-on) ;; MODIFIER LETTER LOW GRAVE
	 (?\x02CF . bidi-category-on) ;; MODIFIER LETTER LOW ACUTE
	 (?\x02D0 . bidi-category-l) ;; 
	 (?\x02D1 . bidi-category-l) ;; 
	 (?\x02D2 . bidi-category-on) ;; MODIFIER LETTER CENTERED RIGHT HALF RING
	 (?\x02D3 . bidi-category-on) ;; MODIFIER LETTER CENTERED LEFT HALF RING
	 (?\x02D4 . bidi-category-on) ;; 
	 (?\x02D5 . bidi-category-on) ;; 
	 (?\x02D6 . bidi-category-on) ;; 
	 (?\x02D7 . bidi-category-on) ;; 
	 (?\x02D8 . bidi-category-on) ;; SPACING BREVE
	 (?\x02D9 . bidi-category-on) ;; SPACING DOT ABOVE
	 (?\x02DA . bidi-category-on) ;; SPACING RING ABOVE
	 (?\x02DB . bidi-category-on) ;; SPACING OGONEK
	 (?\x02DC . bidi-category-on) ;; SPACING TILDE
	 (?\x02DD . bidi-category-on) ;; SPACING DOUBLE ACUTE
	 (?\x02DE . bidi-category-on) ;; 
	 (?\x02DF . bidi-category-on) ;; 
	 (?\x02E0 . bidi-category-l) ;; 
	 (?\x02E1 . bidi-category-l) ;; 
	 (?\x02E2 . bidi-category-l) ;; 
	 (?\x02E3 . bidi-category-l) ;; 
	 (?\x02E4 . bidi-category-l) ;; 
	 (?\x02E5 . bidi-category-on) ;; 
	 (?\x02E6 . bidi-category-on) ;; 
	 (?\x02E7 . bidi-category-on) ;; 
	 (?\x02E8 . bidi-category-on) ;; 
	 (?\x02E9 . bidi-category-on) ;; 
	 (?\x02EA . bidi-category-on) ;; 
	 (?\x02EB . bidi-category-on) ;; 
	 (?\x02EC . bidi-category-on) ;; 
	 (?\x02ED . bidi-category-on) ;; 
	 (?\x02EE . bidi-category-l) ;; 
	 (?\x0300 . bidi-category-nsm) ;; NON-SPACING GRAVE
	 (?\x0301 . bidi-category-nsm) ;; NON-SPACING ACUTE
	 (?\x0302 . bidi-category-nsm) ;; NON-SPACING CIRCUMFLEX
	 (?\x0303 . bidi-category-nsm) ;; NON-SPACING TILDE
	 (?\x0304 . bidi-category-nsm) ;; NON-SPACING MACRON
	 (?\x0305 . bidi-category-nsm) ;; NON-SPACING OVERSCORE
	 (?\x0306 . bidi-category-nsm) ;; NON-SPACING BREVE
	 (?\x0307 . bidi-category-nsm) ;; NON-SPACING DOT ABOVE
	 (?\x0308 . bidi-category-nsm) ;; NON-SPACING DIAERESIS
	 (?\x0309 . bidi-category-nsm) ;; NON-SPACING HOOK ABOVE
	 (?\x030A . bidi-category-nsm) ;; NON-SPACING RING ABOVE
	 (?\x030B . bidi-category-nsm) ;; NON-SPACING DOUBLE ACUTE
	 (?\x030C . bidi-category-nsm) ;; NON-SPACING HACEK
	 (?\x030D . bidi-category-nsm) ;; NON-SPACING VERTICAL LINE ABOVE
	 (?\x030E . bidi-category-nsm) ;; NON-SPACING DOUBLE VERTICAL LINE ABOVE
	 (?\x030F . bidi-category-nsm) ;; NON-SPACING DOUBLE GRAVE
	 (?\x0310 . bidi-category-nsm) ;; NON-SPACING CANDRABINDU
	 (?\x0311 . bidi-category-nsm) ;; NON-SPACING INVERTED BREVE
	 (?\x0312 . bidi-category-nsm) ;; NON-SPACING TURNED COMMA ABOVE
	 (?\x0313 . bidi-category-nsm) ;; NON-SPACING COMMA ABOVE
	 (?\x0314 . bidi-category-nsm) ;; NON-SPACING REVERSED COMMA ABOVE
	 (?\x0315 . bidi-category-nsm) ;; NON-SPACING COMMA ABOVE RIGHT
	 (?\x0316 . bidi-category-nsm) ;; NON-SPACING GRAVE BELOW
	 (?\x0317 . bidi-category-nsm) ;; NON-SPACING ACUTE BELOW
	 (?\x0318 . bidi-category-nsm) ;; NON-SPACING LEFT TACK BELOW
	 (?\x0319 . bidi-category-nsm) ;; NON-SPACING RIGHT TACK BELOW
	 (?\x031A . bidi-category-nsm) ;; NON-SPACING LEFT ANGLE ABOVE
	 (?\x031B . bidi-category-nsm) ;; NON-SPACING HORN
	 (?\x031C . bidi-category-nsm) ;; NON-SPACING LEFT HALF RING BELOW
	 (?\x031D . bidi-category-nsm) ;; NON-SPACING UP TACK BELOW
	 (?\x031E . bidi-category-nsm) ;; NON-SPACING DOWN TACK BELOW
	 (?\x031F . bidi-category-nsm) ;; NON-SPACING PLUS SIGN BELOW
	 (?\x0320 . bidi-category-nsm) ;; NON-SPACING MINUS SIGN BELOW
	 (?\x0321 . bidi-category-nsm) ;; NON-SPACING PALATALIZED HOOK BELOW
	 (?\x0322 . bidi-category-nsm) ;; NON-SPACING RETROFLEX HOOK BELOW
	 (?\x0323 . bidi-category-nsm) ;; NON-SPACING DOT BELOW
	 (?\x0324 . bidi-category-nsm) ;; NON-SPACING DOUBLE DOT BELOW
	 (?\x0325 . bidi-category-nsm) ;; NON-SPACING RING BELOW
	 (?\x0326 . bidi-category-nsm) ;; NON-SPACING COMMA BELOW
	 (?\x0327 . bidi-category-nsm) ;; NON-SPACING CEDILLA
	 (?\x0328 . bidi-category-nsm) ;; NON-SPACING OGONEK
	 (?\x0329 . bidi-category-nsm) ;; NON-SPACING VERTICAL LINE BELOW
	 (?\x032A . bidi-category-nsm) ;; NON-SPACING BRIDGE BELOW
	 (?\x032B . bidi-category-nsm) ;; NON-SPACING INVERTED DOUBLE ARCH BELOW
	 (?\x032C . bidi-category-nsm) ;; NON-SPACING HACEK BELOW
	 (?\x032D . bidi-category-nsm) ;; NON-SPACING CIRCUMFLEX BELOW
	 (?\x032E . bidi-category-nsm) ;; NON-SPACING BREVE BELOW
	 (?\x032F . bidi-category-nsm) ;; NON-SPACING INVERTED BREVE BELOW
	 (?\x0330 . bidi-category-nsm) ;; NON-SPACING TILDE BELOW
	 (?\x0331 . bidi-category-nsm) ;; NON-SPACING MACRON BELOW
	 (?\x0332 . bidi-category-nsm) ;; NON-SPACING UNDERSCORE
	 (?\x0333 . bidi-category-nsm) ;; NON-SPACING DOUBLE UNDERSCORE
	 (?\x0334 . bidi-category-nsm) ;; NON-SPACING TILDE OVERLAY
	 (?\x0335 . bidi-category-nsm) ;; NON-SPACING SHORT BAR OVERLAY
	 (?\x0336 . bidi-category-nsm) ;; NON-SPACING LONG BAR OVERLAY
	 (?\x0337 . bidi-category-nsm) ;; NON-SPACING SHORT SLASH OVERLAY
	 (?\x0338 . bidi-category-nsm) ;; NON-SPACING LONG SLASH OVERLAY
	 (?\x0339 . bidi-category-nsm) ;; NON-SPACING RIGHT HALF RING BELOW
	 (?\x033A . bidi-category-nsm) ;; NON-SPACING INVERTED BRIDGE BELOW
	 (?\x033B . bidi-category-nsm) ;; NON-SPACING SQUARE BELOW
	 (?\x033C . bidi-category-nsm) ;; NON-SPACING SEAGULL BELOW
	 (?\x033D . bidi-category-nsm) ;; NON-SPACING X ABOVE
	 (?\x033E . bidi-category-nsm) ;; NON-SPACING VERTICAL TILDE
	 (?\x033F . bidi-category-nsm) ;; NON-SPACING DOUBLE OVERSCORE
	 (?\x0340 . bidi-category-nsm) ;; NON-SPACING GRAVE TONE MARK
	 (?\x0341 . bidi-category-nsm) ;; NON-SPACING ACUTE TONE MARK
	 (?\x0342 . bidi-category-nsm) ;; 
	 (?\x0343 . bidi-category-nsm) ;; 
	 (?\x0344 . bidi-category-nsm) ;; GREEK NON-SPACING DIAERESIS TONOS
	 (?\x0345 . bidi-category-nsm) ;; GREEK NON-SPACING IOTA BELOW
	 (?\x0346 . bidi-category-nsm) ;; 
	 (?\x0347 . bidi-category-nsm) ;; 
	 (?\x0348 . bidi-category-nsm) ;; 
	 (?\x0349 . bidi-category-nsm) ;; 
	 (?\x034A . bidi-category-nsm) ;; 
	 (?\x034B . bidi-category-nsm) ;; 
	 (?\x034C . bidi-category-nsm) ;; 
	 (?\x034D . bidi-category-nsm) ;; 
	 (?\x034E . bidi-category-nsm) ;; 
	 (?\x0360 . bidi-category-nsm) ;; 
	 (?\x0361 . bidi-category-nsm) ;; 
	 (?\x0362 . bidi-category-nsm) ;; 
	 (?\x0374 . bidi-category-on) ;; GREEK UPPER NUMERAL SIGN
	 (?\x0375 . bidi-category-on) ;; 
	 (?\x037A . bidi-category-l) ;; GREEK SPACING IOTA BELOW
	 (?\x037E . bidi-category-on) ;; 
	 (?\x0384 . bidi-category-on) ;; GREEK SPACING TONOS
	 (?\x0385 . bidi-category-on) ;; GREEK SPACING DIAERESIS TONOS
	 (?\x0386 . bidi-category-l) ;; GREEK CAPITAL LETTER ALPHA TONOS
	 (?\x0387 . bidi-category-on) ;; 
	 (?\x0388 . bidi-category-l) ;; GREEK CAPITAL LETTER EPSILON TONOS
	 (?\x0389 . bidi-category-l) ;; GREEK CAPITAL LETTER ETA TONOS
	 (?\x038A . bidi-category-l) ;; GREEK CAPITAL LETTER IOTA TONOS
	 (?\x038C . bidi-category-l) ;; GREEK CAPITAL LETTER OMICRON TONOS
	 (?\x038E . bidi-category-l) ;; GREEK CAPITAL LETTER UPSILON TONOS
	 (?\x038F . bidi-category-l) ;; GREEK CAPITAL LETTER OMEGA TONOS
	 (?\x0390 . bidi-category-l) ;; GREEK SMALL LETTER IOTA DIAERESIS TONOS
	 (?\x0391 . bidi-category-l) ;; 
	 (?\x0392 . bidi-category-l) ;; 
	 (?\x0393 . bidi-category-l) ;; 
	 (?\x0394 . bidi-category-l) ;; 
	 (?\x0395 . bidi-category-l) ;; 
	 (?\x0396 . bidi-category-l) ;; 
	 (?\x0397 . bidi-category-l) ;; 
	 (?\x0398 . bidi-category-l) ;; 
	 (?\x0399 . bidi-category-l) ;; 
	 (?\x039A . bidi-category-l) ;; 
	 (?\x039B . bidi-category-l) ;; GREEK CAPITAL LETTER LAMBDA
	 (?\x039C . bidi-category-l) ;; 
	 (?\x039D . bidi-category-l) ;; 
	 (?\x039E . bidi-category-l) ;; 
	 (?\x039F . bidi-category-l) ;; 
	 (?\x03A0 . bidi-category-l) ;; 
	 (?\x03A1 . bidi-category-l) ;; 
	 (?\x03A3 . bidi-category-l) ;; 
	 (?\x03A4 . bidi-category-l) ;; 
	 (?\x03A5 . bidi-category-l) ;; 
	 (?\x03A6 . bidi-category-l) ;; 
	 (?\x03A7 . bidi-category-l) ;; 
	 (?\x03A8 . bidi-category-l) ;; 
	 (?\x03A9 . bidi-category-l) ;; 
	 (?\x03AA . bidi-category-l) ;; GREEK CAPITAL LETTER IOTA DIAERESIS
	 (?\x03AB . bidi-category-l) ;; GREEK CAPITAL LETTER UPSILON DIAERESIS
	 (?\x03AC . bidi-category-l) ;; GREEK SMALL LETTER ALPHA TONOS
	 (?\x03AD . bidi-category-l) ;; GREEK SMALL LETTER EPSILON TONOS
	 (?\x03AE . bidi-category-l) ;; GREEK SMALL LETTER ETA TONOS
	 (?\x03AF . bidi-category-l) ;; GREEK SMALL LETTER IOTA TONOS
	 (?\x03B0 . bidi-category-l) ;; GREEK SMALL LETTER UPSILON DIAERESIS TONOS
	 (?\x03B1 . bidi-category-l) ;; 
	 (?\x03B2 . bidi-category-l) ;; 
	 (?\x03B3 . bidi-category-l) ;; 
	 (?\x03B4 . bidi-category-l) ;; 
	 (?\x03B5 . bidi-category-l) ;; 
	 (?\x03B6 . bidi-category-l) ;; 
	 (?\x03B7 . bidi-category-l) ;; 
	 (?\x03B8 . bidi-category-l) ;; 
	 (?\x03B9 . bidi-category-l) ;; 
	 (?\x03BA . bidi-category-l) ;; 
	 (?\x03BB . bidi-category-l) ;; GREEK SMALL LETTER LAMBDA
	 (?\x03BC . bidi-category-l) ;; 
	 (?\x03BD . bidi-category-l) ;; 
	 (?\x03BE . bidi-category-l) ;; 
	 (?\x03BF . bidi-category-l) ;; 
	 (?\x03C0 . bidi-category-l) ;; 
	 (?\x03C1 . bidi-category-l) ;; 
	 (?\x03C2 . bidi-category-l) ;; 
	 (?\x03C3 . bidi-category-l) ;; 
	 (?\x03C4 . bidi-category-l) ;; 
	 (?\x03C5 . bidi-category-l) ;; 
	 (?\x03C6 . bidi-category-l) ;; 
	 (?\x03C7 . bidi-category-l) ;; 
	 (?\x03C8 . bidi-category-l) ;; 
	 (?\x03C9 . bidi-category-l) ;; 
	 (?\x03CA . bidi-category-l) ;; GREEK SMALL LETTER IOTA DIAERESIS
	 (?\x03CB . bidi-category-l) ;; GREEK SMALL LETTER UPSILON DIAERESIS
	 (?\x03CC . bidi-category-l) ;; GREEK SMALL LETTER OMICRON TONOS
	 (?\x03CD . bidi-category-l) ;; GREEK SMALL LETTER UPSILON TONOS
	 (?\x03CE . bidi-category-l) ;; GREEK SMALL LETTER OMEGA TONOS
	 (?\x03D0 . bidi-category-l) ;; GREEK SMALL LETTER CURLED BETA
	 (?\x03D1 . bidi-category-l) ;; GREEK SMALL LETTER SCRIPT THETA
	 (?\x03D2 . bidi-category-l) ;; GREEK CAPITAL LETTER UPSILON HOOK
	 (?\x03D3 . bidi-category-l) ;; GREEK CAPITAL LETTER UPSILON HOOK TONOS
	 (?\x03D4 . bidi-category-l) ;; GREEK CAPITAL LETTER UPSILON HOOK DIAERESIS
	 (?\x03D5 . bidi-category-l) ;; GREEK SMALL LETTER SCRIPT PHI
	 (?\x03D6 . bidi-category-l) ;; GREEK SMALL LETTER OMEGA PI
	 (?\x03D7 . bidi-category-l) ;; 
	 (?\x03DA . bidi-category-l) ;; GREEK CAPITAL LETTER STIGMA
	 (?\x03DB . bidi-category-l) ;; 
	 (?\x03DC . bidi-category-l) ;; GREEK CAPITAL LETTER DIGAMMA
	 (?\x03DD . bidi-category-l) ;; 
	 (?\x03DE . bidi-category-l) ;; GREEK CAPITAL LETTER KOPPA
	 (?\x03DF . bidi-category-l) ;; 
	 (?\x03E0 . bidi-category-l) ;; GREEK CAPITAL LETTER SAMPI
	 (?\x03E1 . bidi-category-l) ;; 
	 (?\x03E2 . bidi-category-l) ;; GREEK CAPITAL LETTER SHEI
	 (?\x03E3 . bidi-category-l) ;; GREEK SMALL LETTER SHEI
	 (?\x03E4 . bidi-category-l) ;; GREEK CAPITAL LETTER FEI
	 (?\x03E5 . bidi-category-l) ;; GREEK SMALL LETTER FEI
	 (?\x03E6 . bidi-category-l) ;; GREEK CAPITAL LETTER KHEI
	 (?\x03E7 . bidi-category-l) ;; GREEK SMALL LETTER KHEI
	 (?\x03E8 . bidi-category-l) ;; GREEK CAPITAL LETTER HORI
	 (?\x03E9 . bidi-category-l) ;; GREEK SMALL LETTER HORI
	 (?\x03EA . bidi-category-l) ;; GREEK CAPITAL LETTER GANGIA
	 (?\x03EB . bidi-category-l) ;; GREEK SMALL LETTER GANGIA
	 (?\x03EC . bidi-category-l) ;; GREEK CAPITAL LETTER SHIMA
	 (?\x03ED . bidi-category-l) ;; GREEK SMALL LETTER SHIMA
	 (?\x03EE . bidi-category-l) ;; GREEK CAPITAL LETTER DEI
	 (?\x03EF . bidi-category-l) ;; GREEK SMALL LETTER DEI
	 (?\x03F0 . bidi-category-l) ;; GREEK SMALL LETTER SCRIPT KAPPA
	 (?\x03F1 . bidi-category-l) ;; GREEK SMALL LETTER TAILED RHO
	 (?\x03F2 . bidi-category-l) ;; GREEK SMALL LETTER LUNATE SIGMA
	 (?\x03F3 . bidi-category-l) ;; 
	 (?\x03F4 . bidi-category-l) ;; 
	 (?\x03F5 . bidi-category-l) ;; 
	 (?\x0400 . bidi-category-l) ;; 
	 (?\x0401 . bidi-category-l) ;; 
	 (?\x0402 . bidi-category-l) ;; 
	 (?\x0403 . bidi-category-l) ;; 
	 (?\x0404 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER E
	 (?\x0405 . bidi-category-l) ;; 
	 (?\x0406 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER I
	 (?\x0407 . bidi-category-l) ;; 
	 (?\x0408 . bidi-category-l) ;; 
	 (?\x0409 . bidi-category-l) ;; 
	 (?\x040A . bidi-category-l) ;; 
	 (?\x040B . bidi-category-l) ;; 
	 (?\x040C . bidi-category-l) ;; 
	 (?\x040D . bidi-category-l) ;; 
	 (?\x040E . bidi-category-l) ;; 
	 (?\x040F . bidi-category-l) ;; 
	 (?\x0410 . bidi-category-l) ;; 
	 (?\x0411 . bidi-category-l) ;; 
	 (?\x0412 . bidi-category-l) ;; 
	 (?\x0413 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER GE
	 (?\x0414 . bidi-category-l) ;; 
	 (?\x0415 . bidi-category-l) ;; 
	 (?\x0416 . bidi-category-l) ;; 
	 (?\x0417 . bidi-category-l) ;; 
	 (?\x0418 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER II
	 (?\x0419 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER SHORT II
	 (?\x041A . bidi-category-l) ;; 
	 (?\x041B . bidi-category-l) ;; 
	 (?\x041C . bidi-category-l) ;; 
	 (?\x041D . bidi-category-l) ;; 
	 (?\x041E . bidi-category-l) ;; 
	 (?\x041F . bidi-category-l) ;; 
	 (?\x0420 . bidi-category-l) ;; 
	 (?\x0421 . bidi-category-l) ;; 
	 (?\x0422 . bidi-category-l) ;; 
	 (?\x0423 . bidi-category-l) ;; 
	 (?\x0424 . bidi-category-l) ;; 
	 (?\x0425 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KHA
	 (?\x0426 . bidi-category-l) ;; 
	 (?\x0427 . bidi-category-l) ;; 
	 (?\x0428 . bidi-category-l) ;; 
	 (?\x0429 . bidi-category-l) ;; 
	 (?\x042A . bidi-category-l) ;; 
	 (?\x042B . bidi-category-l) ;; CYRILLIC CAPITAL LETTER YERI
	 (?\x042C . bidi-category-l) ;; 
	 (?\x042D . bidi-category-l) ;; CYRILLIC CAPITAL LETTER REVERSED E
	 (?\x042E . bidi-category-l) ;; CYRILLIC CAPITAL LETTER IU
	 (?\x042F . bidi-category-l) ;; CYRILLIC CAPITAL LETTER IA
	 (?\x0430 . bidi-category-l) ;; 
	 (?\x0431 . bidi-category-l) ;; 
	 (?\x0432 . bidi-category-l) ;; 
	 (?\x0433 . bidi-category-l) ;; CYRILLIC SMALL LETTER GE
	 (?\x0434 . bidi-category-l) ;; 
	 (?\x0435 . bidi-category-l) ;; 
	 (?\x0436 . bidi-category-l) ;; 
	 (?\x0437 . bidi-category-l) ;; 
	 (?\x0438 . bidi-category-l) ;; CYRILLIC SMALL LETTER II
	 (?\x0439 . bidi-category-l) ;; CYRILLIC SMALL LETTER SHORT II
	 (?\x043A . bidi-category-l) ;; 
	 (?\x043B . bidi-category-l) ;; 
	 (?\x043C . bidi-category-l) ;; 
	 (?\x043D . bidi-category-l) ;; 
	 (?\x043E . bidi-category-l) ;; 
	 (?\x043F . bidi-category-l) ;; 
	 (?\x0440 . bidi-category-l) ;; 
	 (?\x0441 . bidi-category-l) ;; 
	 (?\x0442 . bidi-category-l) ;; 
	 (?\x0443 . bidi-category-l) ;; 
	 (?\x0444 . bidi-category-l) ;; 
	 (?\x0445 . bidi-category-l) ;; CYRILLIC SMALL LETTER KHA
	 (?\x0446 . bidi-category-l) ;; 
	 (?\x0447 . bidi-category-l) ;; 
	 (?\x0448 . bidi-category-l) ;; 
	 (?\x0449 . bidi-category-l) ;; 
	 (?\x044A . bidi-category-l) ;; 
	 (?\x044B . bidi-category-l) ;; CYRILLIC SMALL LETTER YERI
	 (?\x044C . bidi-category-l) ;; 
	 (?\x044D . bidi-category-l) ;; CYRILLIC SMALL LETTER REVERSED E
	 (?\x044E . bidi-category-l) ;; CYRILLIC SMALL LETTER IU
	 (?\x044F . bidi-category-l) ;; CYRILLIC SMALL LETTER IA
	 (?\x0450 . bidi-category-l) ;; 
	 (?\x0451 . bidi-category-l) ;; 
	 (?\x0452 . bidi-category-l) ;; 
	 (?\x0453 . bidi-category-l) ;; 
	 (?\x0454 . bidi-category-l) ;; CYRILLIC SMALL LETTER E
	 (?\x0455 . bidi-category-l) ;; 
	 (?\x0456 . bidi-category-l) ;; CYRILLIC SMALL LETTER I
	 (?\x0457 . bidi-category-l) ;; 
	 (?\x0458 . bidi-category-l) ;; 
	 (?\x0459 . bidi-category-l) ;; 
	 (?\x045A . bidi-category-l) ;; 
	 (?\x045B . bidi-category-l) ;; 
	 (?\x045C . bidi-category-l) ;; 
	 (?\x045D . bidi-category-l) ;; 
	 (?\x045E . bidi-category-l) ;; 
	 (?\x045F . bidi-category-l) ;; 
	 (?\x0460 . bidi-category-l) ;; 
	 (?\x0461 . bidi-category-l) ;; 
	 (?\x0462 . bidi-category-l) ;; 
	 (?\x0463 . bidi-category-l) ;; 
	 (?\x0464 . bidi-category-l) ;; 
	 (?\x0465 . bidi-category-l) ;; 
	 (?\x0466 . bidi-category-l) ;; 
	 (?\x0467 . bidi-category-l) ;; 
	 (?\x0468 . bidi-category-l) ;; 
	 (?\x0469 . bidi-category-l) ;; 
	 (?\x046A . bidi-category-l) ;; 
	 (?\x046B . bidi-category-l) ;; 
	 (?\x046C . bidi-category-l) ;; 
	 (?\x046D . bidi-category-l) ;; 
	 (?\x046E . bidi-category-l) ;; 
	 (?\x046F . bidi-category-l) ;; 
	 (?\x0470 . bidi-category-l) ;; 
	 (?\x0471 . bidi-category-l) ;; 
	 (?\x0472 . bidi-category-l) ;; 
	 (?\x0473 . bidi-category-l) ;; 
	 (?\x0474 . bidi-category-l) ;; 
	 (?\x0475 . bidi-category-l) ;; 
	 (?\x0476 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER IZHITSA DOUBLE GRAVE
	 (?\x0477 . bidi-category-l) ;; CYRILLIC SMALL LETTER IZHITSA DOUBLE GRAVE
	 (?\x0478 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER UK DIGRAPH
	 (?\x0479 . bidi-category-l) ;; CYRILLIC SMALL LETTER UK DIGRAPH
	 (?\x047A . bidi-category-l) ;; 
	 (?\x047B . bidi-category-l) ;; 
	 (?\x047C . bidi-category-l) ;; CYRILLIC CAPITAL LETTER OMEGA TITLO
	 (?\x047D . bidi-category-l) ;; CYRILLIC SMALL LETTER OMEGA TITLO
	 (?\x047E . bidi-category-l) ;; 
	 (?\x047F . bidi-category-l) ;; 
	 (?\x0480 . bidi-category-l) ;; 
	 (?\x0481 . bidi-category-l) ;; 
	 (?\x0482 . bidi-category-l) ;; 
	 (?\x0483 . bidi-category-nsm) ;; CYRILLIC NON-SPACING TITLO
	 (?\x0484 . bidi-category-nsm) ;; CYRILLIC NON-SPACING PALATALIZATION
	 (?\x0485 . bidi-category-nsm) ;; CYRILLIC NON-SPACING DASIA PNEUMATA
	 (?\x0486 . bidi-category-nsm) ;; CYRILLIC NON-SPACING PSILI PNEUMATA
	 (?\x0488 . bidi-category-nsm) ;; 
	 (?\x0489 . bidi-category-nsm) ;; 
	 (?\x048C . bidi-category-l) ;; 
	 (?\x048D . bidi-category-l) ;; 
	 (?\x048E . bidi-category-l) ;; 
	 (?\x048F . bidi-category-l) ;; 
	 (?\x0490 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER GE WITH UPTURN
	 (?\x0491 . bidi-category-l) ;; CYRILLIC SMALL LETTER GE WITH UPTURN
	 (?\x0492 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER GE BAR
	 (?\x0493 . bidi-category-l) ;; CYRILLIC SMALL LETTER GE BAR
	 (?\x0494 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER GE HOOK
	 (?\x0495 . bidi-category-l) ;; CYRILLIC SMALL LETTER GE HOOK
	 (?\x0496 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER ZHE WITH RIGHT DESCENDER
	 (?\x0497 . bidi-category-l) ;; CYRILLIC SMALL LETTER ZHE WITH RIGHT DESCENDER
	 (?\x0498 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER ZE CEDILLA
	 (?\x0499 . bidi-category-l) ;; CYRILLIC SMALL LETTER ZE CEDILLA
	 (?\x049A . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KA WITH RIGHT DESCENDER
	 (?\x049B . bidi-category-l) ;; CYRILLIC SMALL LETTER KA WITH RIGHT DESCENDER
	 (?\x049C . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KA VERTICAL BAR
	 (?\x049D . bidi-category-l) ;; CYRILLIC SMALL LETTER KA VERTICAL BAR
	 (?\x049E . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KA BAR
	 (?\x049F . bidi-category-l) ;; CYRILLIC SMALL LETTER KA BAR
	 (?\x04A0 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER REVERSED GE KA
	 (?\x04A1 . bidi-category-l) ;; CYRILLIC SMALL LETTER REVERSED GE KA
	 (?\x04A2 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER EN WITH RIGHT DESCENDER
	 (?\x04A3 . bidi-category-l) ;; CYRILLIC SMALL LETTER EN WITH RIGHT DESCENDER
	 (?\x04A4 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER EN GE
	 (?\x04A5 . bidi-category-l) ;; CYRILLIC SMALL LETTER EN GE
	 (?\x04A6 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER PE HOOK
	 (?\x04A7 . bidi-category-l) ;; CYRILLIC SMALL LETTER PE HOOK
	 (?\x04A8 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER O HOOK
	 (?\x04A9 . bidi-category-l) ;; CYRILLIC SMALL LETTER O HOOK
	 (?\x04AA . bidi-category-l) ;; CYRILLIC CAPITAL LETTER ES CEDILLA
	 (?\x04AB . bidi-category-l) ;; CYRILLIC SMALL LETTER ES CEDILLA
	 (?\x04AC . bidi-category-l) ;; CYRILLIC CAPITAL LETTER TE WITH RIGHT DESCENDER
	 (?\x04AD . bidi-category-l) ;; CYRILLIC SMALL LETTER TE WITH RIGHT DESCENDER
	 (?\x04AE . bidi-category-l) ;; 
	 (?\x04AF . bidi-category-l) ;; 
	 (?\x04B0 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER STRAIGHT U BAR
	 (?\x04B1 . bidi-category-l) ;; CYRILLIC SMALL LETTER STRAIGHT U BAR
	 (?\x04B2 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KHA WITH RIGHT DESCENDER
	 (?\x04B3 . bidi-category-l) ;; CYRILLIC SMALL LETTER KHA WITH RIGHT DESCENDER
	 (?\x04B4 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER TE TSE
	 (?\x04B5 . bidi-category-l) ;; CYRILLIC SMALL LETTER TE TSE
	 (?\x04B6 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER CHE WITH RIGHT DESCENDER
	 (?\x04B7 . bidi-category-l) ;; CYRILLIC SMALL LETTER CHE WITH RIGHT DESCENDER
	 (?\x04B8 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER CHE VERTICAL BAR
	 (?\x04B9 . bidi-category-l) ;; CYRILLIC SMALL LETTER CHE VERTICAL BAR
	 (?\x04BA . bidi-category-l) ;; CYRILLIC CAPITAL LETTER H
	 (?\x04BB . bidi-category-l) ;; CYRILLIC SMALL LETTER H
	 (?\x04BC . bidi-category-l) ;; CYRILLIC CAPITAL LETTER IE HOOK
	 (?\x04BD . bidi-category-l) ;; CYRILLIC SMALL LETTER IE HOOK
	 (?\x04BE . bidi-category-l) ;; CYRILLIC CAPITAL LETTER IE HOOK OGONEK
	 (?\x04BF . bidi-category-l) ;; CYRILLIC SMALL LETTER IE HOOK OGONEK
	 (?\x04C0 . bidi-category-l) ;; CYRILLIC LETTER I
	 (?\x04C1 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER SHORT ZHE
	 (?\x04C2 . bidi-category-l) ;; CYRILLIC SMALL LETTER SHORT ZHE
	 (?\x04C3 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER KA HOOK
	 (?\x04C4 . bidi-category-l) ;; CYRILLIC SMALL LETTER KA HOOK
	 (?\x04C7 . bidi-category-l) ;; CYRILLIC CAPITAL LETTER EN HOOK
	 (?\x04C8 . bidi-category-l) ;; CYRILLIC SMALL LETTER EN HOOK
	 (?\x04CB . bidi-category-l) ;; CYRILLIC CAPITAL LETTER CHE WITH LEFT DESCENDER
	 (?\x04CC . bidi-category-l) ;; CYRILLIC SMALL LETTER CHE WITH LEFT DESCENDER
	 (?\x04D0 . bidi-category-l) ;; 
	 (?\x04D1 . bidi-category-l) ;; 
	 (?\x04D2 . bidi-category-l) ;; 
	 (?\x04D3 . bidi-category-l) ;; 
	 (?\x04D4 . bidi-category-l) ;; 
	 (?\x04D5 . bidi-category-l) ;; 
	 (?\x04D6 . bidi-category-l) ;; 
	 (?\x04D7 . bidi-category-l) ;; 
	 (?\x04D8 . bidi-category-l) ;; 
	 (?\x04D9 . bidi-category-l) ;; 
	 (?\x04DA . bidi-category-l) ;; 
	 (?\x04DB . bidi-category-l) ;; 
	 (?\x04DC . bidi-category-l) ;; 
	 (?\x04DD . bidi-category-l) ;; 
	 (?\x04DE . bidi-category-l) ;; 
	 (?\x04DF . bidi-category-l) ;; 
	 (?\x04E0 . bidi-category-l) ;; 
	 (?\x04E1 . bidi-category-l) ;; 
	 (?\x04E2 . bidi-category-l) ;; 
	 (?\x04E3 . bidi-category-l) ;; 
	 (?\x04E4 . bidi-category-l) ;; 
	 (?\x04E5 . bidi-category-l) ;; 
	 (?\x04E6 . bidi-category-l) ;; 
	 (?\x04E7 . bidi-category-l) ;; 
	 (?\x04E8 . bidi-category-l) ;; 
	 (?\x04E9 . bidi-category-l) ;; 
	 (?\x04EA . bidi-category-l) ;; 
	 (?\x04EB . bidi-category-l) ;; 
	 (?\x04EC . bidi-category-l) ;; 
	 (?\x04ED . bidi-category-l) ;; 
	 (?\x04EE . bidi-category-l) ;; 
	 (?\x04EF . bidi-category-l) ;; 
	 (?\x04F0 . bidi-category-l) ;; 
	 (?\x04F1 . bidi-category-l) ;; 
	 (?\x04F2 . bidi-category-l) ;; 
	 (?\x04F3 . bidi-category-l) ;; 
	 (?\x04F4 . bidi-category-l) ;; 
	 (?\x04F5 . bidi-category-l) ;; 
	 (?\x04F8 . bidi-category-l) ;; 
	 (?\x04F9 . bidi-category-l) ;; 
	 (?\x0531 . bidi-category-l) ;; 
	 (?\x0532 . bidi-category-l) ;; 
	 (?\x0533 . bidi-category-l) ;; 
	 (?\x0534 . bidi-category-l) ;; 
	 (?\x0535 . bidi-category-l) ;; 
	 (?\x0536 . bidi-category-l) ;; 
	 (?\x0537 . bidi-category-l) ;; 
	 (?\x0538 . bidi-category-l) ;; 
	 (?\x0539 . bidi-category-l) ;; 
	 (?\x053A . bidi-category-l) ;; 
	 (?\x053B . bidi-category-l) ;; 
	 (?\x053C . bidi-category-l) ;; 
	 (?\x053D . bidi-category-l) ;; 
	 (?\x053E . bidi-category-l) ;; 
	 (?\x053F . bidi-category-l) ;; 
	 (?\x0540 . bidi-category-l) ;; 
	 (?\x0541 . bidi-category-l) ;; 
	 (?\x0542 . bidi-category-l) ;; ARMENIAN CAPITAL LETTER LAD
	 (?\x0543 . bidi-category-l) ;; 
	 (?\x0544 . bidi-category-l) ;; 
	 (?\x0545 . bidi-category-l) ;; 
	 (?\x0546 . bidi-category-l) ;; 
	 (?\x0547 . bidi-category-l) ;; 
	 (?\x0548 . bidi-category-l) ;; 
	 (?\x0549 . bidi-category-l) ;; 
	 (?\x054A . bidi-category-l) ;; 
	 (?\x054B . bidi-category-l) ;; 
	 (?\x054C . bidi-category-l) ;; 
	 (?\x054D . bidi-category-l) ;; 
	 (?\x054E . bidi-category-l) ;; 
	 (?\x054F . bidi-category-l) ;; 
	 (?\x0550 . bidi-category-l) ;; 
	 (?\x0551 . bidi-category-l) ;; 
	 (?\x0552 . bidi-category-l) ;; 
	 (?\x0553 . bidi-category-l) ;; 
	 (?\x0554 . bidi-category-l) ;; 
	 (?\x0555 . bidi-category-l) ;; 
	 (?\x0556 . bidi-category-l) ;; 
	 (?\x0559 . bidi-category-l) ;; 
	 (?\x055A . bidi-category-l) ;; ARMENIAN MODIFIER LETTER RIGHT HALF RING
	 (?\x055B . bidi-category-l) ;; 
	 (?\x055C . bidi-category-l) ;; 
	 (?\x055D . bidi-category-l) ;; 
	 (?\x055E . bidi-category-l) ;; 
	 (?\x055F . bidi-category-l) ;; 
	 (?\x0561 . bidi-category-l) ;; 
	 (?\x0562 . bidi-category-l) ;; 
	 (?\x0563 . bidi-category-l) ;; 
	 (?\x0564 . bidi-category-l) ;; 
	 (?\x0565 . bidi-category-l) ;; 
	 (?\x0566 . bidi-category-l) ;; 
	 (?\x0567 . bidi-category-l) ;; 
	 (?\x0568 . bidi-category-l) ;; 
	 (?\x0569 . bidi-category-l) ;; 
	 (?\x056A . bidi-category-l) ;; 
	 (?\x056B . bidi-category-l) ;; 
	 (?\x056C . bidi-category-l) ;; 
	 (?\x056D . bidi-category-l) ;; 
	 (?\x056E . bidi-category-l) ;; 
	 (?\x056F . bidi-category-l) ;; 
	 (?\x0570 . bidi-category-l) ;; 
	 (?\x0571 . bidi-category-l) ;; 
	 (?\x0572 . bidi-category-l) ;; ARMENIAN SMALL LETTER LAD
	 (?\x0573 . bidi-category-l) ;; 
	 (?\x0574 . bidi-category-l) ;; 
	 (?\x0575 . bidi-category-l) ;; 
	 (?\x0576 . bidi-category-l) ;; 
	 (?\x0577 . bidi-category-l) ;; 
	 (?\x0578 . bidi-category-l) ;; 
	 (?\x0579 . bidi-category-l) ;; 
	 (?\x057A . bidi-category-l) ;; 
	 (?\x057B . bidi-category-l) ;; 
	 (?\x057C . bidi-category-l) ;; 
	 (?\x057D . bidi-category-l) ;; 
	 (?\x057E . bidi-category-l) ;; 
	 (?\x057F . bidi-category-l) ;; 
	 (?\x0580 . bidi-category-l) ;; 
	 (?\x0581 . bidi-category-l) ;; 
	 (?\x0582 . bidi-category-l) ;; 
	 (?\x0583 . bidi-category-l) ;; 
	 (?\x0584 . bidi-category-l) ;; 
	 (?\x0585 . bidi-category-l) ;; 
	 (?\x0586 . bidi-category-l) ;; 
	 (?\x0587 . bidi-category-l) ;; 
	 (?\x0589 . bidi-category-l) ;; ARMENIAN PERIOD
	 (?\x058A . bidi-category-on) ;; 
	 (?\x0591 . bidi-category-nsm) ;; 
	 (?\x0592 . bidi-category-nsm) ;; 
	 (?\x0593 . bidi-category-nsm) ;; 
	 (?\x0594 . bidi-category-nsm) ;; 
	 (?\x0595 . bidi-category-nsm) ;; 
	 (?\x0596 . bidi-category-nsm) ;; 
	 (?\x0597 . bidi-category-nsm) ;; 
	 (?\x0598 . bidi-category-nsm) ;; 
	 (?\x0599 . bidi-category-nsm) ;; 
	 (?\x059A . bidi-category-nsm) ;; 
	 (?\x059B . bidi-category-nsm) ;; 
	 (?\x059C . bidi-category-nsm) ;; 
	 (?\x059D . bidi-category-nsm) ;; 
	 (?\x059E . bidi-category-nsm) ;; 
	 (?\x059F . bidi-category-nsm) ;; 
	 (?\x05A0 . bidi-category-nsm) ;; 
	 (?\x05A1 . bidi-category-nsm) ;; 
	 (?\x05A3 . bidi-category-nsm) ;; 
	 (?\x05A4 . bidi-category-nsm) ;; 
	 (?\x05A5 . bidi-category-nsm) ;; 
	 (?\x05A6 . bidi-category-nsm) ;; 
	 (?\x05A7 . bidi-category-nsm) ;; 
	 (?\x05A8 . bidi-category-nsm) ;; 
	 (?\x05A9 . bidi-category-nsm) ;; 
	 (?\x05AA . bidi-category-nsm) ;; 
	 (?\x05AB . bidi-category-nsm) ;; 
	 (?\x05AC . bidi-category-nsm) ;; 
	 (?\x05AD . bidi-category-nsm) ;; 
	 (?\x05AE . bidi-category-nsm) ;; 
	 (?\x05AF . bidi-category-nsm) ;; 
	 (?\x05B0 . bidi-category-nsm) ;; 
	 (?\x05B1 . bidi-category-nsm) ;; 
	 (?\x05B2 . bidi-category-nsm) ;; 
	 (?\x05B3 . bidi-category-nsm) ;; 
	 (?\x05B4 . bidi-category-nsm) ;; 
	 (?\x05B5 . bidi-category-nsm) ;; 
	 (?\x05B6 . bidi-category-nsm) ;; 
	 (?\x05B7 . bidi-category-nsm) ;; 
	 (?\x05B8 . bidi-category-nsm) ;; 
	 (?\x05B9 . bidi-category-nsm) ;; 
	 (?\x05BB . bidi-category-nsm) ;; 
	 (?\x05BC . bidi-category-nsm) ;; HEBREW POINT DAGESH
	 (?\x05BD . bidi-category-nsm) ;; 
	 (?\x05BE . bidi-category-r) ;; 
	 (?\x05BF . bidi-category-nsm) ;; 
	 (?\x05C0 . bidi-category-r) ;; HEBREW POINT PASEQ
	 (?\x05C1 . bidi-category-nsm) ;; 
	 (?\x05C2 . bidi-category-nsm) ;; 
	 (?\x05C3 . bidi-category-r) ;; 
	 (?\x05C4 . bidi-category-nsm) ;; 
	 (?\x05D0 . bidi-category-r) ;; 
	 (?\x05D1 . bidi-category-r) ;; 
	 (?\x05D2 . bidi-category-r) ;; 
	 (?\x05D3 . bidi-category-r) ;; 
	 (?\x05D4 . bidi-category-r) ;; 
	 (?\x05D5 . bidi-category-r) ;; 
	 (?\x05D6 . bidi-category-r) ;; 
	 (?\x05D7 . bidi-category-r) ;; 
	 (?\x05D8 . bidi-category-r) ;; 
	 (?\x05D9 . bidi-category-r) ;; 
	 (?\x05DA . bidi-category-r) ;; 
	 (?\x05DB . bidi-category-r) ;; 
	 (?\x05DC . bidi-category-r) ;; 
	 (?\x05DD . bidi-category-r) ;; 
	 (?\x05DE . bidi-category-r) ;; 
	 (?\x05DF . bidi-category-r) ;; 
	 (?\x05E0 . bidi-category-r) ;; 
	 (?\x05E1 . bidi-category-r) ;; 
	 (?\x05E2 . bidi-category-r) ;; 
	 (?\x05E3 . bidi-category-r) ;; 
	 (?\x05E4 . bidi-category-r) ;; 
	 (?\x05E5 . bidi-category-r) ;; 
	 (?\x05E6 . bidi-category-r) ;; 
	 (?\x05E7 . bidi-category-r) ;; 
	 (?\x05E8 . bidi-category-r) ;; 
	 (?\x05E9 . bidi-category-r) ;; 
	 (?\x05EA . bidi-category-r) ;; 
	 (?\x05F0 . bidi-category-r) ;; HEBREW LETTER DOUBLE VAV
	 (?\x05F1 . bidi-category-r) ;; HEBREW LETTER VAV YOD
	 (?\x05F2 . bidi-category-r) ;; HEBREW LETTER DOUBLE YOD
	 (?\x05F3 . bidi-category-r) ;; 
	 (?\x05F4 . bidi-category-r) ;; 
	 (?\x060C . bidi-category-cs) ;; 
	 (?\x061B . bidi-category-al) ;; 
	 (?\x061F . bidi-category-al) ;; 
	 (?\x0621 . bidi-category-al) ;; ARABIC LETTER HAMZAH
	 (?\x0622 . bidi-category-al) ;; ARABIC LETTER MADDAH ON ALEF
	 (?\x0623 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON ALEF
	 (?\x0624 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON WAW
	 (?\x0625 . bidi-category-al) ;; ARABIC LETTER HAMZAH UNDER ALEF
	 (?\x0626 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON YA
	 (?\x0627 . bidi-category-al) ;; 
	 (?\x0628 . bidi-category-al) ;; ARABIC LETTER BAA
	 (?\x0629 . bidi-category-al) ;; ARABIC LETTER TAA MARBUTAH
	 (?\x062A . bidi-category-al) ;; ARABIC LETTER TAA
	 (?\x062B . bidi-category-al) ;; ARABIC LETTER THAA
	 (?\x062C . bidi-category-al) ;; 
	 (?\x062D . bidi-category-al) ;; ARABIC LETTER HAA
	 (?\x062E . bidi-category-al) ;; ARABIC LETTER KHAA
	 (?\x062F . bidi-category-al) ;; 
	 (?\x0630 . bidi-category-al) ;; 
	 (?\x0631 . bidi-category-al) ;; ARABIC LETTER RA
	 (?\x0632 . bidi-category-al) ;; 
	 (?\x0633 . bidi-category-al) ;; 
	 (?\x0634 . bidi-category-al) ;; 
	 (?\x0635 . bidi-category-al) ;; 
	 (?\x0636 . bidi-category-al) ;; 
	 (?\x0637 . bidi-category-al) ;; 
	 (?\x0638 . bidi-category-al) ;; ARABIC LETTER DHAH
	 (?\x0639 . bidi-category-al) ;; 
	 (?\x063A . bidi-category-al) ;; 
	 (?\x0640 . bidi-category-al) ;; 
	 (?\x0641 . bidi-category-al) ;; ARABIC LETTER FA
	 (?\x0642 . bidi-category-al) ;; 
	 (?\x0643 . bidi-category-al) ;; ARABIC LETTER CAF
	 (?\x0644 . bidi-category-al) ;; 
	 (?\x0645 . bidi-category-al) ;; 
	 (?\x0646 . bidi-category-al) ;; 
	 (?\x0647 . bidi-category-al) ;; ARABIC LETTER HA
	 (?\x0648 . bidi-category-al) ;; 
	 (?\x0649 . bidi-category-al) ;; ARABIC LETTER ALEF MAQSURAH
	 (?\x064A . bidi-category-al) ;; ARABIC LETTER YA
	 (?\x064B . bidi-category-nsm) ;; 
	 (?\x064C . bidi-category-nsm) ;; 
	 (?\x064D . bidi-category-nsm) ;; 
	 (?\x064E . bidi-category-nsm) ;; ARABIC FATHAH
	 (?\x064F . bidi-category-nsm) ;; ARABIC DAMMAH
	 (?\x0650 . bidi-category-nsm) ;; ARABIC KASRAH
	 (?\x0651 . bidi-category-nsm) ;; ARABIC SHADDAH
	 (?\x0652 . bidi-category-nsm) ;; 
	 (?\x0653 . bidi-category-nsm) ;; 
	 (?\x0654 . bidi-category-nsm) ;; 
	 (?\x0655 . bidi-category-nsm) ;; 
	 (?\x0660 . bidi-category-an) ;; 
	 (?\x0661 . bidi-category-an) ;; 
	 (?\x0662 . bidi-category-an) ;; 
	 (?\x0663 . bidi-category-an) ;; 
	 (?\x0664 . bidi-category-an) ;; 
	 (?\x0665 . bidi-category-an) ;; 
	 (?\x0666 . bidi-category-an) ;; 
	 (?\x0667 . bidi-category-an) ;; 
	 (?\x0668 . bidi-category-an) ;; 
	 (?\x0669 . bidi-category-an) ;; 
	 (?\x066A . bidi-category-et) ;; 
	 (?\x066B . bidi-category-an) ;; 
	 (?\x066C . bidi-category-an) ;; 
	 (?\x066D . bidi-category-al) ;; 
	 (?\x0670 . bidi-category-nsm) ;; ARABIC ALEF ABOVE
	 (?\x0671 . bidi-category-al) ;; ARABIC LETTER HAMZAT WASL ON ALEF
	 (?\x0672 . bidi-category-al) ;; ARABIC LETTER WAVY HAMZAH ON ALEF
	 (?\x0673 . bidi-category-al) ;; ARABIC LETTER WAVY HAMZAH UNDER ALEF
	 (?\x0674 . bidi-category-al) ;; ARABIC LETTER HIGH HAMZAH
	 (?\x0675 . bidi-category-al) ;; ARABIC LETTER HIGH HAMZAH ALEF
	 (?\x0676 . bidi-category-al) ;; ARABIC LETTER HIGH HAMZAH WAW
	 (?\x0677 . bidi-category-al) ;; ARABIC LETTER HIGH HAMZAH WAW WITH DAMMAH
	 (?\x0678 . bidi-category-al) ;; ARABIC LETTER HIGH HAMZAH YA
	 (?\x0679 . bidi-category-al) ;; ARABIC LETTER TAA WITH SMALL TAH
	 (?\x067A . bidi-category-al) ;; ARABIC LETTER TAA WITH TWO DOTS VERTICAL ABOVE
	 (?\x067B . bidi-category-al) ;; ARABIC LETTER BAA WITH TWO DOTS VERTICAL BELOW
	 (?\x067C . bidi-category-al) ;; ARABIC LETTER TAA WITH RING
	 (?\x067D . bidi-category-al) ;; ARABIC LETTER TAA WITH THREE DOTS ABOVE DOWNWARD
	 (?\x067E . bidi-category-al) ;; ARABIC LETTER TAA WITH THREE DOTS BELOW
	 (?\x067F . bidi-category-al) ;; ARABIC LETTER TAA WITH FOUR DOTS ABOVE
	 (?\x0680 . bidi-category-al) ;; ARABIC LETTER BAA WITH FOUR DOTS BELOW
	 (?\x0681 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON HAA
	 (?\x0682 . bidi-category-al) ;; ARABIC LETTER HAA WITH TWO DOTS VERTICAL ABOVE
	 (?\x0683 . bidi-category-al) ;; ARABIC LETTER HAA WITH MIDDLE TWO DOTS
	 (?\x0684 . bidi-category-al) ;; ARABIC LETTER HAA WITH MIDDLE TWO DOTS VERTICAL
	 (?\x0685 . bidi-category-al) ;; ARABIC LETTER HAA WITH THREE DOTS ABOVE
	 (?\x0686 . bidi-category-al) ;; ARABIC LETTER HAA WITH MIDDLE THREE DOTS DOWNWARD
	 (?\x0687 . bidi-category-al) ;; ARABIC LETTER HAA WITH MIDDLE FOUR DOTS
	 (?\x0688 . bidi-category-al) ;; ARABIC LETTER DAL WITH SMALL TAH
	 (?\x0689 . bidi-category-al) ;; 
	 (?\x068A . bidi-category-al) ;; 
	 (?\x068B . bidi-category-al) ;; 
	 (?\x068C . bidi-category-al) ;; ARABIC LETTER DAL WITH TWO DOTS ABOVE
	 (?\x068D . bidi-category-al) ;; ARABIC LETTER DAL WITH TWO DOTS BELOW
	 (?\x068E . bidi-category-al) ;; ARABIC LETTER DAL WITH THREE DOTS ABOVE
	 (?\x068F . bidi-category-al) ;; ARABIC LETTER DAL WITH THREE DOTS ABOVE DOWNWARD
	 (?\x0690 . bidi-category-al) ;; 
	 (?\x0691 . bidi-category-al) ;; ARABIC LETTER RA WITH SMALL TAH
	 (?\x0692 . bidi-category-al) ;; ARABIC LETTER RA WITH SMALL V
	 (?\x0693 . bidi-category-al) ;; ARABIC LETTER RA WITH RING
	 (?\x0694 . bidi-category-al) ;; ARABIC LETTER RA WITH DOT BELOW
	 (?\x0695 . bidi-category-al) ;; ARABIC LETTER RA WITH SMALL V BELOW
	 (?\x0696 . bidi-category-al) ;; ARABIC LETTER RA WITH DOT BELOW AND DOT ABOVE
	 (?\x0697 . bidi-category-al) ;; ARABIC LETTER RA WITH TWO DOTS ABOVE
	 (?\x0698 . bidi-category-al) ;; ARABIC LETTER RA WITH THREE DOTS ABOVE
	 (?\x0699 . bidi-category-al) ;; ARABIC LETTER RA WITH FOUR DOTS ABOVE
	 (?\x069A . bidi-category-al) ;; 
	 (?\x069B . bidi-category-al) ;; 
	 (?\x069C . bidi-category-al) ;; 
	 (?\x069D . bidi-category-al) ;; 
	 (?\x069E . bidi-category-al) ;; 
	 (?\x069F . bidi-category-al) ;; 
	 (?\x06A0 . bidi-category-al) ;; 
	 (?\x06A1 . bidi-category-al) ;; ARABIC LETTER DOTLESS FA
	 (?\x06A2 . bidi-category-al) ;; ARABIC LETTER FA WITH DOT MOVED BELOW
	 (?\x06A3 . bidi-category-al) ;; ARABIC LETTER FA WITH DOT BELOW
	 (?\x06A4 . bidi-category-al) ;; ARABIC LETTER FA WITH THREE DOTS ABOVE
	 (?\x06A5 . bidi-category-al) ;; ARABIC LETTER FA WITH THREE DOTS BELOW
	 (?\x06A6 . bidi-category-al) ;; ARABIC LETTER FA WITH FOUR DOTS ABOVE
	 (?\x06A7 . bidi-category-al) ;; 
	 (?\x06A8 . bidi-category-al) ;; 
	 (?\x06A9 . bidi-category-al) ;; ARABIC LETTER OPEN CAF
	 (?\x06AA . bidi-category-al) ;; ARABIC LETTER SWASH CAF
	 (?\x06AB . bidi-category-al) ;; ARABIC LETTER CAF WITH RING
	 (?\x06AC . bidi-category-al) ;; ARABIC LETTER CAF WITH DOT ABOVE
	 (?\x06AD . bidi-category-al) ;; ARABIC LETTER CAF WITH THREE DOTS ABOVE
	 (?\x06AE . bidi-category-al) ;; ARABIC LETTER CAF WITH THREE DOTS BELOW
	 (?\x06AF . bidi-category-al) ;; 
	 (?\x06B0 . bidi-category-al) ;; 
	 (?\x06B1 . bidi-category-al) ;; ARABIC LETTER GAF WITH TWO DOTS ABOVE
	 (?\x06B2 . bidi-category-al) ;; 
	 (?\x06B3 . bidi-category-al) ;; ARABIC LETTER GAF WITH TWO DOTS VERTICAL BELOW
	 (?\x06B4 . bidi-category-al) ;; 
	 (?\x06B5 . bidi-category-al) ;; 
	 (?\x06B6 . bidi-category-al) ;; 
	 (?\x06B7 . bidi-category-al) ;; 
	 (?\x06B8 . bidi-category-al) ;; 
	 (?\x06B9 . bidi-category-al) ;; 
	 (?\x06BA . bidi-category-al) ;; ARABIC LETTER DOTLESS NOON
	 (?\x06BB . bidi-category-al) ;; ARABIC LETTER DOTLESS NOON WITH SMALL TAH
	 (?\x06BC . bidi-category-al) ;; 
	 (?\x06BD . bidi-category-al) ;; 
	 (?\x06BE . bidi-category-al) ;; ARABIC LETTER KNOTTED HA
	 (?\x06BF . bidi-category-al) ;; 
	 (?\x06C0 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON HA
	 (?\x06C1 . bidi-category-al) ;; ARABIC LETTER HA GOAL
	 (?\x06C2 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON HA GOAL
	 (?\x06C3 . bidi-category-al) ;; ARABIC LETTER TAA MARBUTAH GOAL
	 (?\x06C4 . bidi-category-al) ;; 
	 (?\x06C5 . bidi-category-al) ;; ARABIC LETTER WAW WITH BAR
	 (?\x06C6 . bidi-category-al) ;; ARABIC LETTER WAW WITH SMALL V
	 (?\x06C7 . bidi-category-al) ;; ARABIC LETTER WAW WITH DAMMAH
	 (?\x06C8 . bidi-category-al) ;; ARABIC LETTER WAW WITH ALEF ABOVE
	 (?\x06C9 . bidi-category-al) ;; ARABIC LETTER WAW WITH INVERTED SMALL V
	 (?\x06CA . bidi-category-al) ;; 
	 (?\x06CB . bidi-category-al) ;; ARABIC LETTER WAW WITH THREE DOTS ABOVE
	 (?\x06CC . bidi-category-al) ;; ARABIC LETTER DOTLESS YA
	 (?\x06CD . bidi-category-al) ;; ARABIC LETTER YA WITH TAIL
	 (?\x06CE . bidi-category-al) ;; ARABIC LETTER YA WITH SMALL V
	 (?\x06CF . bidi-category-al) ;; 
	 (?\x06D0 . bidi-category-al) ;; ARABIC LETTER YA WITH TWO DOTS VERTICAL BELOW
	 (?\x06D1 . bidi-category-al) ;; ARABIC LETTER YA WITH THREE DOTS BELOW
	 (?\x06D2 . bidi-category-al) ;; ARABIC LETTER YA BARREE
	 (?\x06D3 . bidi-category-al) ;; ARABIC LETTER HAMZAH ON YA BARREE
	 (?\x06D4 . bidi-category-al) ;; ARABIC PERIOD
	 (?\x06D5 . bidi-category-al) ;; 
	 (?\x06D6 . bidi-category-nsm) ;; 
	 (?\x06D7 . bidi-category-nsm) ;; 
	 (?\x06D8 . bidi-category-nsm) ;; 
	 (?\x06D9 . bidi-category-nsm) ;; 
	 (?\x06DA . bidi-category-nsm) ;; 
	 (?\x06DB . bidi-category-nsm) ;; 
	 (?\x06DC . bidi-category-nsm) ;; 
	 (?\x06DD . bidi-category-nsm) ;; 
	 (?\x06DE . bidi-category-nsm) ;; 
	 (?\x06DF . bidi-category-nsm) ;; 
	 (?\x06E0 . bidi-category-nsm) ;; 
	 (?\x06E1 . bidi-category-nsm) ;; 
	 (?\x06E2 . bidi-category-nsm) ;; 
	 (?\x06E3 . bidi-category-nsm) ;; 
	 (?\x06E4 . bidi-category-nsm) ;; 
	 (?\x06E5 . bidi-category-al) ;; 
	 (?\x06E6 . bidi-category-al) ;; 
	 (?\x06E7 . bidi-category-nsm) ;; 
	 (?\x06E8 . bidi-category-nsm) ;; 
	 (?\x06E9 . bidi-category-on) ;; 
	 (?\x06EA . bidi-category-nsm) ;; 
	 (?\x06EB . bidi-category-nsm) ;; 
	 (?\x06EC . bidi-category-nsm) ;; 
	 (?\x06ED . bidi-category-nsm) ;; 
	 (?\x06F0 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT ZERO
	 (?\x06F1 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT ONE
	 (?\x06F2 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT TWO
	 (?\x06F3 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT THREE
	 (?\x06F4 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT FOUR
	 (?\x06F5 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT FIVE
	 (?\x06F6 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT SIX
	 (?\x06F7 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT SEVEN
	 (?\x06F8 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT EIGHT
	 (?\x06F9 . bidi-category-en) ;; EASTERN ARABIC-INDIC DIGIT NINE
	 (?\x06FA . bidi-category-al) ;; 
	 (?\x06FB . bidi-category-al) ;; 
	 (?\x06FC . bidi-category-al) ;; 
	 (?\x06FD . bidi-category-al) ;; 
	 (?\x06FE . bidi-category-al) ;; 
	 (?\x0700 . bidi-category-al) ;; 
	 (?\x0701 . bidi-category-al) ;; 
	 (?\x0702 . bidi-category-al) ;; 
	 (?\x0703 . bidi-category-al) ;; 
	 (?\x0704 . bidi-category-al) ;; 
	 (?\x0705 . bidi-category-al) ;; 
	 (?\x0706 . bidi-category-al) ;; 
	 (?\x0707 . bidi-category-al) ;; 
	 (?\x0708 . bidi-category-al) ;; 
	 (?\x0709 . bidi-category-al) ;; 
	 (?\x070A . bidi-category-al) ;; 
	 (?\x070B . bidi-category-al) ;; 
	 (?\x070C . bidi-category-al) ;; 
	 (?\x070D . bidi-category-al) ;; 
	 (?\x070F . bidi-category-bn) ;; 
	 (?\x0710 . bidi-category-al) ;; 
	 (?\x0711 . bidi-category-nsm) ;; 
	 (?\x0712 . bidi-category-al) ;; 
	 (?\x0713 . bidi-category-al) ;; 
	 (?\x0714 . bidi-category-al) ;; 
	 (?\x0715 . bidi-category-al) ;; 
	 (?\x0716 . bidi-category-al) ;; 
	 (?\x0717 . bidi-category-al) ;; 
	 (?\x0718 . bidi-category-al) ;; 
	 (?\x0719 . bidi-category-al) ;; 
	 (?\x071A . bidi-category-al) ;; 
	 (?\x071B . bidi-category-al) ;; 
	 (?\x071C . bidi-category-al) ;; 
	 (?\x071D . bidi-category-al) ;; 
	 (?\x071E . bidi-category-al) ;; 
	 (?\x071F . bidi-category-al) ;; 
	 (?\x0720 . bidi-category-al) ;; 
	 (?\x0721 . bidi-category-al) ;; 
	 (?\x0722 . bidi-category-al) ;; 
	 (?\x0723 . bidi-category-al) ;; 
	 (?\x0724 . bidi-category-al) ;; 
	 (?\x0725 . bidi-category-al) ;; 
	 (?\x0726 . bidi-category-al) ;; 
	 (?\x0727 . bidi-category-al) ;; 
	 (?\x0728 . bidi-category-al) ;; 
	 (?\x0729 . bidi-category-al) ;; 
	 (?\x072A . bidi-category-al) ;; 
	 (?\x072B . bidi-category-al) ;; 
	 (?\x072C . bidi-category-al) ;; 
	 (?\x0730 . bidi-category-nsm) ;; 
	 (?\x0731 . bidi-category-nsm) ;; 
	 (?\x0732 . bidi-category-nsm) ;; 
	 (?\x0733 . bidi-category-nsm) ;; 
	 (?\x0734 . bidi-category-nsm) ;; 
	 (?\x0735 . bidi-category-nsm) ;; 
	 (?\x0736 . bidi-category-nsm) ;; 
	 (?\x0737 . bidi-category-nsm) ;; 
	 (?\x0738 . bidi-category-nsm) ;; 
	 (?\x0739 . bidi-category-nsm) ;; 
	 (?\x073A . bidi-category-nsm) ;; 
	 (?\x073B . bidi-category-nsm) ;; 
	 (?\x073C . bidi-category-nsm) ;; 
	 (?\x073D . bidi-category-nsm) ;; 
	 (?\x073E . bidi-category-nsm) ;; 
	 (?\x073F . bidi-category-nsm) ;; 
	 (?\x0740 . bidi-category-nsm) ;; 
	 (?\x0741 . bidi-category-nsm) ;; 
	 (?\x0742 . bidi-category-nsm) ;; 
	 (?\x0743 . bidi-category-nsm) ;; 
	 (?\x0744 . bidi-category-nsm) ;; 
	 (?\x0745 . bidi-category-nsm) ;; 
	 (?\x0746 . bidi-category-nsm) ;; 
	 (?\x0747 . bidi-category-nsm) ;; 
	 (?\x0748 . bidi-category-nsm) ;; 
	 (?\x0749 . bidi-category-nsm) ;; 
	 (?\x074A . bidi-category-nsm) ;; 
	 (?\x0780 . bidi-category-al) ;; 
	 (?\x0781 . bidi-category-al) ;; 
	 (?\x0782 . bidi-category-al) ;; 
	 (?\x0783 . bidi-category-al) ;; 
	 (?\x0784 . bidi-category-al) ;; 
	 (?\x0785 . bidi-category-al) ;; 
	 (?\x0786 . bidi-category-al) ;; 
	 (?\x0787 . bidi-category-al) ;; 
	 (?\x0788 . bidi-category-al) ;; 
	 (?\x0789 . bidi-category-al) ;; 
	 (?\x078A . bidi-category-al) ;; 
	 (?\x078B . bidi-category-al) ;; 
	 (?\x078C . bidi-category-al) ;; 
	 (?\x078D . bidi-category-al) ;; 
	 (?\x078E . bidi-category-al) ;; 
	 (?\x078F . bidi-category-al) ;; 
	 (?\x0790 . bidi-category-al) ;; 
	 (?\x0791 . bidi-category-al) ;; 
	 (?\x0792 . bidi-category-al) ;; 
	 (?\x0793 . bidi-category-al) ;; 
	 (?\x0794 . bidi-category-al) ;; 
	 (?\x0795 . bidi-category-al) ;; 
	 (?\x0796 . bidi-category-al) ;; 
	 (?\x0797 . bidi-category-al) ;; 
	 (?\x0798 . bidi-category-al) ;; 
	 (?\x0799 . bidi-category-al) ;; 
	 (?\x079A . bidi-category-al) ;; 
	 (?\x079B . bidi-category-al) ;; 
	 (?\x079C . bidi-category-al) ;; 
	 (?\x079D . bidi-category-al) ;; 
	 (?\x079E . bidi-category-al) ;; 
	 (?\x079F . bidi-category-al) ;; 
	 (?\x07A0 . bidi-category-al) ;; 
	 (?\x07A1 . bidi-category-al) ;; 
	 (?\x07A2 . bidi-category-al) ;; 
	 (?\x07A3 . bidi-category-al) ;; 
	 (?\x07A4 . bidi-category-al) ;; 
	 (?\x07A5 . bidi-category-al) ;; 
	 (?\x07A6 . bidi-category-nsm) ;; 
	 (?\x07A7 . bidi-category-nsm) ;; 
	 (?\x07A8 . bidi-category-nsm) ;; 
	 (?\x07A9 . bidi-category-nsm) ;; 
	 (?\x07AA . bidi-category-nsm) ;; 
	 (?\x07AB . bidi-category-nsm) ;; 
	 (?\x07AC . bidi-category-nsm) ;; 
	 (?\x07AD . bidi-category-nsm) ;; 
	 (?\x07AE . bidi-category-nsm) ;; 
	 (?\x07AF . bidi-category-nsm) ;; 
	 (?\x07B0 . bidi-category-nsm) ;; 
	 (?\x0901 . bidi-category-nsm) ;; 
	 (?\x0902 . bidi-category-nsm) ;; 
	 (?\x0903 . bidi-category-l) ;; 
	 (?\x0905 . bidi-category-l) ;; 
	 (?\x0906 . bidi-category-l) ;; 
	 (?\x0907 . bidi-category-l) ;; 
	 (?\x0908 . bidi-category-l) ;; 
	 (?\x0909 . bidi-category-l) ;; 
	 (?\x090A . bidi-category-l) ;; 
	 (?\x090B . bidi-category-l) ;; 
	 (?\x090C . bidi-category-l) ;; 
	 (?\x090D . bidi-category-l) ;; 
	 (?\x090E . bidi-category-l) ;; 
	 (?\x090F . bidi-category-l) ;; 
	 (?\x0910 . bidi-category-l) ;; 
	 (?\x0911 . bidi-category-l) ;; 
	 (?\x0912 . bidi-category-l) ;; 
	 (?\x0913 . bidi-category-l) ;; 
	 (?\x0914 . bidi-category-l) ;; 
	 (?\x0915 . bidi-category-l) ;; 
	 (?\x0916 . bidi-category-l) ;; 
	 (?\x0917 . bidi-category-l) ;; 
	 (?\x0918 . bidi-category-l) ;; 
	 (?\x0919 . bidi-category-l) ;; 
	 (?\x091A . bidi-category-l) ;; 
	 (?\x091B . bidi-category-l) ;; 
	 (?\x091C . bidi-category-l) ;; 
	 (?\x091D . bidi-category-l) ;; 
	 (?\x091E . bidi-category-l) ;; 
	 (?\x091F . bidi-category-l) ;; 
	 (?\x0920 . bidi-category-l) ;; 
	 (?\x0921 . bidi-category-l) ;; 
	 (?\x0922 . bidi-category-l) ;; 
	 (?\x0923 . bidi-category-l) ;; 
	 (?\x0924 . bidi-category-l) ;; 
	 (?\x0925 . bidi-category-l) ;; 
	 (?\x0926 . bidi-category-l) ;; 
	 (?\x0927 . bidi-category-l) ;; 
	 (?\x0928 . bidi-category-l) ;; 
	 (?\x0929 . bidi-category-l) ;; 
	 (?\x092A . bidi-category-l) ;; 
	 (?\x092B . bidi-category-l) ;; 
	 (?\x092C . bidi-category-l) ;; 
	 (?\x092D . bidi-category-l) ;; 
	 (?\x092E . bidi-category-l) ;; 
	 (?\x092F . bidi-category-l) ;; 
	 (?\x0930 . bidi-category-l) ;; 
	 (?\x0931 . bidi-category-l) ;; 
	 (?\x0932 . bidi-category-l) ;; 
	 (?\x0933 . bidi-category-l) ;; 
	 (?\x0934 . bidi-category-l) ;; 
	 (?\x0935 . bidi-category-l) ;; 
	 (?\x0936 . bidi-category-l) ;; 
	 (?\x0937 . bidi-category-l) ;; 
	 (?\x0938 . bidi-category-l) ;; 
	 (?\x0939 . bidi-category-l) ;; 
	 (?\x093C . bidi-category-nsm) ;; 
	 (?\x093D . bidi-category-l) ;; 
	 (?\x093E . bidi-category-l) ;; 
	 (?\x093F . bidi-category-l) ;; 
	 (?\x0940 . bidi-category-l) ;; 
	 (?\x0941 . bidi-category-nsm) ;; 
	 (?\x0942 . bidi-category-nsm) ;; 
	 (?\x0943 . bidi-category-nsm) ;; 
	 (?\x0944 . bidi-category-nsm) ;; 
	 (?\x0945 . bidi-category-nsm) ;; 
	 (?\x0946 . bidi-category-nsm) ;; 
	 (?\x0947 . bidi-category-nsm) ;; 
	 (?\x0948 . bidi-category-nsm) ;; 
	 (?\x0949 . bidi-category-l) ;; 
	 (?\x094A . bidi-category-l) ;; 
	 (?\x094B . bidi-category-l) ;; 
	 (?\x094C . bidi-category-l) ;; 
	 (?\x094D . bidi-category-nsm) ;; 
	 (?\x0950 . bidi-category-l) ;; 
	 (?\x0951 . bidi-category-nsm) ;; 
	 (?\x0952 . bidi-category-nsm) ;; 
	 (?\x0953 . bidi-category-nsm) ;; 
	 (?\x0954 . bidi-category-nsm) ;; 
	 (?\x0958 . bidi-category-l) ;; 
	 (?\x0959 . bidi-category-l) ;; 
	 (?\x095A . bidi-category-l) ;; 
	 (?\x095B . bidi-category-l) ;; 
	 (?\x095C . bidi-category-l) ;; 
	 (?\x095D . bidi-category-l) ;; 
	 (?\x095E . bidi-category-l) ;; 
	 (?\x095F . bidi-category-l) ;; 
	 (?\x0960 . bidi-category-l) ;; 
	 (?\x0961 . bidi-category-l) ;; 
	 (?\x0962 . bidi-category-nsm) ;; 
	 (?\x0963 . bidi-category-nsm) ;; 
	 (?\x0964 . bidi-category-l) ;; 
	 (?\x0965 . bidi-category-l) ;; 
	 (?\x0966 . bidi-category-l) ;; 
	 (?\x0967 . bidi-category-l) ;; 
	 (?\x0968 . bidi-category-l) ;; 
	 (?\x0969 . bidi-category-l) ;; 
	 (?\x096A . bidi-category-l) ;; 
	 (?\x096B . bidi-category-l) ;; 
	 (?\x096C . bidi-category-l) ;; 
	 (?\x096D . bidi-category-l) ;; 
	 (?\x096E . bidi-category-l) ;; 
	 (?\x096F . bidi-category-l) ;; 
	 (?\x0970 . bidi-category-l) ;; 
	 (?\x0981 . bidi-category-nsm) ;; 
	 (?\x0982 . bidi-category-l) ;; 
	 (?\x0983 . bidi-category-l) ;; 
	 (?\x0985 . bidi-category-l) ;; 
	 (?\x0986 . bidi-category-l) ;; 
	 (?\x0987 . bidi-category-l) ;; 
	 (?\x0988 . bidi-category-l) ;; 
	 (?\x0989 . bidi-category-l) ;; 
	 (?\x098A . bidi-category-l) ;; 
	 (?\x098B . bidi-category-l) ;; 
	 (?\x098C . bidi-category-l) ;; 
	 (?\x098F . bidi-category-l) ;; 
	 (?\x0990 . bidi-category-l) ;; 
	 (?\x0993 . bidi-category-l) ;; 
	 (?\x0994 . bidi-category-l) ;; 
	 (?\x0995 . bidi-category-l) ;; 
	 (?\x0996 . bidi-category-l) ;; 
	 (?\x0997 . bidi-category-l) ;; 
	 (?\x0998 . bidi-category-l) ;; 
	 (?\x0999 . bidi-category-l) ;; 
	 (?\x099A . bidi-category-l) ;; 
	 (?\x099B . bidi-category-l) ;; 
	 (?\x099C . bidi-category-l) ;; 
	 (?\x099D . bidi-category-l) ;; 
	 (?\x099E . bidi-category-l) ;; 
	 (?\x099F . bidi-category-l) ;; 
	 (?\x09A0 . bidi-category-l) ;; 
	 (?\x09A1 . bidi-category-l) ;; 
	 (?\x09A2 . bidi-category-l) ;; 
	 (?\x09A3 . bidi-category-l) ;; 
	 (?\x09A4 . bidi-category-l) ;; 
	 (?\x09A5 . bidi-category-l) ;; 
	 (?\x09A6 . bidi-category-l) ;; 
	 (?\x09A7 . bidi-category-l) ;; 
	 (?\x09A8 . bidi-category-l) ;; 
	 (?\x09AA . bidi-category-l) ;; 
	 (?\x09AB . bidi-category-l) ;; 
	 (?\x09AC . bidi-category-l) ;; 
	 (?\x09AD . bidi-category-l) ;; 
	 (?\x09AE . bidi-category-l) ;; 
	 (?\x09AF . bidi-category-l) ;; 
	 (?\x09B0 . bidi-category-l) ;; 
	 (?\x09B2 . bidi-category-l) ;; 
	 (?\x09B6 . bidi-category-l) ;; 
	 (?\x09B7 . bidi-category-l) ;; 
	 (?\x09B8 . bidi-category-l) ;; 
	 (?\x09B9 . bidi-category-l) ;; 
	 (?\x09BC . bidi-category-nsm) ;; 
	 (?\x09BE . bidi-category-l) ;; 
	 (?\x09BF . bidi-category-l) ;; 
	 (?\x09C0 . bidi-category-l) ;; 
	 (?\x09C1 . bidi-category-nsm) ;; 
	 (?\x09C2 . bidi-category-nsm) ;; 
	 (?\x09C3 . bidi-category-nsm) ;; 
	 (?\x09C4 . bidi-category-nsm) ;; 
	 (?\x09C7 . bidi-category-l) ;; 
	 (?\x09C8 . bidi-category-l) ;; 
	 (?\x09CB . bidi-category-l) ;; 
	 (?\x09CC . bidi-category-l) ;; 
	 (?\x09CD . bidi-category-nsm) ;; 
	 (?\x09D7 . bidi-category-l) ;; 
	 (?\x09DC . bidi-category-l) ;; 
	 (?\x09DD . bidi-category-l) ;; 
	 (?\x09DF . bidi-category-l) ;; 
	 (?\x09E0 . bidi-category-l) ;; 
	 (?\x09E1 . bidi-category-l) ;; 
	 (?\x09E2 . bidi-category-nsm) ;; 
	 (?\x09E3 . bidi-category-nsm) ;; 
	 (?\x09E6 . bidi-category-l) ;; 
	 (?\x09E7 . bidi-category-l) ;; 
	 (?\x09E8 . bidi-category-l) ;; 
	 (?\x09E9 . bidi-category-l) ;; 
	 (?\x09EA . bidi-category-l) ;; 
	 (?\x09EB . bidi-category-l) ;; 
	 (?\x09EC . bidi-category-l) ;; 
	 (?\x09ED . bidi-category-l) ;; 
	 (?\x09EE . bidi-category-l) ;; 
	 (?\x09EF . bidi-category-l) ;; 
	 (?\x09F0 . bidi-category-l) ;; 
	 (?\x09F1 . bidi-category-l) ;; BENGALI LETTER VA WITH LOWER DIAGONAL
	 (?\x09F2 . bidi-category-et) ;; 
	 (?\x09F3 . bidi-category-et) ;; 
	 (?\x09F4 . bidi-category-l) ;; 
	 (?\x09F5 . bidi-category-l) ;; 
	 (?\x09F6 . bidi-category-l) ;; 
	 (?\x09F7 . bidi-category-l) ;; 
	 (?\x09F8 . bidi-category-l) ;; 
	 (?\x09F9 . bidi-category-l) ;; 
	 (?\x09FA . bidi-category-l) ;; 
	 (?\x0A02 . bidi-category-nsm) ;; 
	 (?\x0A05 . bidi-category-l) ;; 
	 (?\x0A06 . bidi-category-l) ;; 
	 (?\x0A07 . bidi-category-l) ;; 
	 (?\x0A08 . bidi-category-l) ;; 
	 (?\x0A09 . bidi-category-l) ;; 
	 (?\x0A0A . bidi-category-l) ;; 
	 (?\x0A0F . bidi-category-l) ;; 
	 (?\x0A10 . bidi-category-l) ;; 
	 (?\x0A13 . bidi-category-l) ;; 
	 (?\x0A14 . bidi-category-l) ;; 
	 (?\x0A15 . bidi-category-l) ;; 
	 (?\x0A16 . bidi-category-l) ;; 
	 (?\x0A17 . bidi-category-l) ;; 
	 (?\x0A18 . bidi-category-l) ;; 
	 (?\x0A19 . bidi-category-l) ;; 
	 (?\x0A1A . bidi-category-l) ;; 
	 (?\x0A1B . bidi-category-l) ;; 
	 (?\x0A1C . bidi-category-l) ;; 
	 (?\x0A1D . bidi-category-l) ;; 
	 (?\x0A1E . bidi-category-l) ;; 
	 (?\x0A1F . bidi-category-l) ;; 
	 (?\x0A20 . bidi-category-l) ;; 
	 (?\x0A21 . bidi-category-l) ;; 
	 (?\x0A22 . bidi-category-l) ;; 
	 (?\x0A23 . bidi-category-l) ;; 
	 (?\x0A24 . bidi-category-l) ;; 
	 (?\x0A25 . bidi-category-l) ;; 
	 (?\x0A26 . bidi-category-l) ;; 
	 (?\x0A27 . bidi-category-l) ;; 
	 (?\x0A28 . bidi-category-l) ;; 
	 (?\x0A2A . bidi-category-l) ;; 
	 (?\x0A2B . bidi-category-l) ;; 
	 (?\x0A2C . bidi-category-l) ;; 
	 (?\x0A2D . bidi-category-l) ;; 
	 (?\x0A2E . bidi-category-l) ;; 
	 (?\x0A2F . bidi-category-l) ;; 
	 (?\x0A30 . bidi-category-l) ;; 
	 (?\x0A32 . bidi-category-l) ;; 
	 (?\x0A33 . bidi-category-l) ;; 
	 (?\x0A35 . bidi-category-l) ;; 
	 (?\x0A36 . bidi-category-l) ;; 
	 (?\x0A38 . bidi-category-l) ;; 
	 (?\x0A39 . bidi-category-l) ;; 
	 (?\x0A3C . bidi-category-nsm) ;; 
	 (?\x0A3E . bidi-category-l) ;; 
	 (?\x0A3F . bidi-category-l) ;; 
	 (?\x0A40 . bidi-category-l) ;; 
	 (?\x0A41 . bidi-category-nsm) ;; 
	 (?\x0A42 . bidi-category-nsm) ;; 
	 (?\x0A47 . bidi-category-nsm) ;; 
	 (?\x0A48 . bidi-category-nsm) ;; 
	 (?\x0A4B . bidi-category-nsm) ;; 
	 (?\x0A4C . bidi-category-nsm) ;; 
	 (?\x0A4D . bidi-category-nsm) ;; 
	 (?\x0A59 . bidi-category-l) ;; 
	 (?\x0A5A . bidi-category-l) ;; 
	 (?\x0A5B . bidi-category-l) ;; 
	 (?\x0A5C . bidi-category-l) ;; 
	 (?\x0A5E . bidi-category-l) ;; 
	 (?\x0A66 . bidi-category-l) ;; 
	 (?\x0A67 . bidi-category-l) ;; 
	 (?\x0A68 . bidi-category-l) ;; 
	 (?\x0A69 . bidi-category-l) ;; 
	 (?\x0A6A . bidi-category-l) ;; 
	 (?\x0A6B . bidi-category-l) ;; 
	 (?\x0A6C . bidi-category-l) ;; 
	 (?\x0A6D . bidi-category-l) ;; 
	 (?\x0A6E . bidi-category-l) ;; 
	 (?\x0A6F . bidi-category-l) ;; 
	 (?\x0A70 . bidi-category-nsm) ;; 
	 (?\x0A71 . bidi-category-nsm) ;; 
	 (?\x0A72 . bidi-category-l) ;; 
	 (?\x0A73 . bidi-category-l) ;; 
	 (?\x0A74 . bidi-category-l) ;; 
	 (?\x0A81 . bidi-category-nsm) ;; 
	 (?\x0A82 . bidi-category-nsm) ;; 
	 (?\x0A83 . bidi-category-l) ;; 
	 (?\x0A85 . bidi-category-l) ;; 
	 (?\x0A86 . bidi-category-l) ;; 
	 (?\x0A87 . bidi-category-l) ;; 
	 (?\x0A88 . bidi-category-l) ;; 
	 (?\x0A89 . bidi-category-l) ;; 
	 (?\x0A8A . bidi-category-l) ;; 
	 (?\x0A8B . bidi-category-l) ;; 
	 (?\x0A8D . bidi-category-l) ;; 
	 (?\x0A8F . bidi-category-l) ;; 
	 (?\x0A90 . bidi-category-l) ;; 
	 (?\x0A91 . bidi-category-l) ;; 
	 (?\x0A93 . bidi-category-l) ;; 
	 (?\x0A94 . bidi-category-l) ;; 
	 (?\x0A95 . bidi-category-l) ;; 
	 (?\x0A96 . bidi-category-l) ;; 
	 (?\x0A97 . bidi-category-l) ;; 
	 (?\x0A98 . bidi-category-l) ;; 
	 (?\x0A99 . bidi-category-l) ;; 
	 (?\x0A9A . bidi-category-l) ;; 
	 (?\x0A9B . bidi-category-l) ;; 
	 (?\x0A9C . bidi-category-l) ;; 
	 (?\x0A9D . bidi-category-l) ;; 
	 (?\x0A9E . bidi-category-l) ;; 
	 (?\x0A9F . bidi-category-l) ;; 
	 (?\x0AA0 . bidi-category-l) ;; 
	 (?\x0AA1 . bidi-category-l) ;; 
	 (?\x0AA2 . bidi-category-l) ;; 
	 (?\x0AA3 . bidi-category-l) ;; 
	 (?\x0AA4 . bidi-category-l) ;; 
	 (?\x0AA5 . bidi-category-l) ;; 
	 (?\x0AA6 . bidi-category-l) ;; 
	 (?\x0AA7 . bidi-category-l) ;; 
	 (?\x0AA8 . bidi-category-l) ;; 
	 (?\x0AAA . bidi-category-l) ;; 
	 (?\x0AAB . bidi-category-l) ;; 
	 (?\x0AAC . bidi-category-l) ;; 
	 (?\x0AAD . bidi-category-l) ;; 
	 (?\x0AAE . bidi-category-l) ;; 
	 (?\x0AAF . bidi-category-l) ;; 
	 (?\x0AB0 . bidi-category-l) ;; 
	 (?\x0AB2 . bidi-category-l) ;; 
	 (?\x0AB3 . bidi-category-l) ;; 
	 (?\x0AB5 . bidi-category-l) ;; 
	 (?\x0AB6 . bidi-category-l) ;; 
	 (?\x0AB7 . bidi-category-l) ;; 
	 (?\x0AB8 . bidi-category-l) ;; 
	 (?\x0AB9 . bidi-category-l) ;; 
	 (?\x0ABC . bidi-category-nsm) ;; 
	 (?\x0ABD . bidi-category-l) ;; 
	 (?\x0ABE . bidi-category-l) ;; 
	 (?\x0ABF . bidi-category-l) ;; 
	 (?\x0AC0 . bidi-category-l) ;; 
	 (?\x0AC1 . bidi-category-nsm) ;; 
	 (?\x0AC2 . bidi-category-nsm) ;; 
	 (?\x0AC3 . bidi-category-nsm) ;; 
	 (?\x0AC4 . bidi-category-nsm) ;; 
	 (?\x0AC5 . bidi-category-nsm) ;; 
	 (?\x0AC7 . bidi-category-nsm) ;; 
	 (?\x0AC8 . bidi-category-nsm) ;; 
	 (?\x0AC9 . bidi-category-l) ;; 
	 (?\x0ACB . bidi-category-l) ;; 
	 (?\x0ACC . bidi-category-l) ;; 
	 (?\x0ACD . bidi-category-nsm) ;; 
	 (?\x0AD0 . bidi-category-l) ;; 
	 (?\x0AE0 . bidi-category-l) ;; 
	 (?\x0AE6 . bidi-category-l) ;; 
	 (?\x0AE7 . bidi-category-l) ;; 
	 (?\x0AE8 . bidi-category-l) ;; 
	 (?\x0AE9 . bidi-category-l) ;; 
	 (?\x0AEA . bidi-category-l) ;; 
	 (?\x0AEB . bidi-category-l) ;; 
	 (?\x0AEC . bidi-category-l) ;; 
	 (?\x0AED . bidi-category-l) ;; 
	 (?\x0AEE . bidi-category-l) ;; 
	 (?\x0AEF . bidi-category-l) ;; 
	 (?\x0B01 . bidi-category-nsm) ;; 
	 (?\x0B02 . bidi-category-l) ;; 
	 (?\x0B03 . bidi-category-l) ;; 
	 (?\x0B05 . bidi-category-l) ;; 
	 (?\x0B06 . bidi-category-l) ;; 
	 (?\x0B07 . bidi-category-l) ;; 
	 (?\x0B08 . bidi-category-l) ;; 
	 (?\x0B09 . bidi-category-l) ;; 
	 (?\x0B0A . bidi-category-l) ;; 
	 (?\x0B0B . bidi-category-l) ;; 
	 (?\x0B0C . bidi-category-l) ;; 
	 (?\x0B0F . bidi-category-l) ;; 
	 (?\x0B10 . bidi-category-l) ;; 
	 (?\x0B13 . bidi-category-l) ;; 
	 (?\x0B14 . bidi-category-l) ;; 
	 (?\x0B15 . bidi-category-l) ;; 
	 (?\x0B16 . bidi-category-l) ;; 
	 (?\x0B17 . bidi-category-l) ;; 
	 (?\x0B18 . bidi-category-l) ;; 
	 (?\x0B19 . bidi-category-l) ;; 
	 (?\x0B1A . bidi-category-l) ;; 
	 (?\x0B1B . bidi-category-l) ;; 
	 (?\x0B1C . bidi-category-l) ;; 
	 (?\x0B1D . bidi-category-l) ;; 
	 (?\x0B1E . bidi-category-l) ;; 
	 (?\x0B1F . bidi-category-l) ;; 
	 (?\x0B20 . bidi-category-l) ;; 
	 (?\x0B21 . bidi-category-l) ;; 
	 (?\x0B22 . bidi-category-l) ;; 
	 (?\x0B23 . bidi-category-l) ;; 
	 (?\x0B24 . bidi-category-l) ;; 
	 (?\x0B25 . bidi-category-l) ;; 
	 (?\x0B26 . bidi-category-l) ;; 
	 (?\x0B27 . bidi-category-l) ;; 
	 (?\x0B28 . bidi-category-l) ;; 
	 (?\x0B2A . bidi-category-l) ;; 
	 (?\x0B2B . bidi-category-l) ;; 
	 (?\x0B2C . bidi-category-l) ;; 
	 (?\x0B2D . bidi-category-l) ;; 
	 (?\x0B2E . bidi-category-l) ;; 
	 (?\x0B2F . bidi-category-l) ;; 
	 (?\x0B30 . bidi-category-l) ;; 
	 (?\x0B32 . bidi-category-l) ;; 
	 (?\x0B33 . bidi-category-l) ;; 
	 (?\x0B36 . bidi-category-l) ;; 
	 (?\x0B37 . bidi-category-l) ;; 
	 (?\x0B38 . bidi-category-l) ;; 
	 (?\x0B39 . bidi-category-l) ;; 
	 (?\x0B3C . bidi-category-nsm) ;; 
	 (?\x0B3D . bidi-category-l) ;; 
	 (?\x0B3E . bidi-category-l) ;; 
	 (?\x0B3F . bidi-category-nsm) ;; 
	 (?\x0B40 . bidi-category-l) ;; 
	 (?\x0B41 . bidi-category-nsm) ;; 
	 (?\x0B42 . bidi-category-nsm) ;; 
	 (?\x0B43 . bidi-category-nsm) ;; 
	 (?\x0B47 . bidi-category-l) ;; 
	 (?\x0B48 . bidi-category-l) ;; 
	 (?\x0B4B . bidi-category-l) ;; 
	 (?\x0B4C . bidi-category-l) ;; 
	 (?\x0B4D . bidi-category-nsm) ;; 
	 (?\x0B56 . bidi-category-nsm) ;; 
	 (?\x0B57 . bidi-category-l) ;; 
	 (?\x0B5C . bidi-category-l) ;; 
	 (?\x0B5D . bidi-category-l) ;; 
	 (?\x0B5F . bidi-category-l) ;; 
	 (?\x0B60 . bidi-category-l) ;; 
	 (?\x0B61 . bidi-category-l) ;; 
	 (?\x0B66 . bidi-category-l) ;; 
	 (?\x0B67 . bidi-category-l) ;; 
	 (?\x0B68 . bidi-category-l) ;; 
	 (?\x0B69 . bidi-category-l) ;; 
	 (?\x0B6A . bidi-category-l) ;; 
	 (?\x0B6B . bidi-category-l) ;; 
	 (?\x0B6C . bidi-category-l) ;; 
	 (?\x0B6D . bidi-category-l) ;; 
	 (?\x0B6E . bidi-category-l) ;; 
	 (?\x0B6F . bidi-category-l) ;; 
	 (?\x0B70 . bidi-category-l) ;; 
	 (?\x0B82 . bidi-category-nsm) ;; 
	 (?\x0B83 . bidi-category-l) ;; 
	 (?\x0B85 . bidi-category-l) ;; 
	 (?\x0B86 . bidi-category-l) ;; 
	 (?\x0B87 . bidi-category-l) ;; 
	 (?\x0B88 . bidi-category-l) ;; 
	 (?\x0B89 . bidi-category-l) ;; 
	 (?\x0B8A . bidi-category-l) ;; 
	 (?\x0B8E . bidi-category-l) ;; 
	 (?\x0B8F . bidi-category-l) ;; 
	 (?\x0B90 . bidi-category-l) ;; 
	 (?\x0B92 . bidi-category-l) ;; 
	 (?\x0B93 . bidi-category-l) ;; 
	 (?\x0B94 . bidi-category-l) ;; 
	 (?\x0B95 . bidi-category-l) ;; 
	 (?\x0B99 . bidi-category-l) ;; 
	 (?\x0B9A . bidi-category-l) ;; 
	 (?\x0B9C . bidi-category-l) ;; 
	 (?\x0B9E . bidi-category-l) ;; 
	 (?\x0B9F . bidi-category-l) ;; 
	 (?\x0BA3 . bidi-category-l) ;; 
	 (?\x0BA4 . bidi-category-l) ;; 
	 (?\x0BA8 . bidi-category-l) ;; 
	 (?\x0BA9 . bidi-category-l) ;; 
	 (?\x0BAA . bidi-category-l) ;; 
	 (?\x0BAE . bidi-category-l) ;; 
	 (?\x0BAF . bidi-category-l) ;; 
	 (?\x0BB0 . bidi-category-l) ;; 
	 (?\x0BB1 . bidi-category-l) ;; 
	 (?\x0BB2 . bidi-category-l) ;; 
	 (?\x0BB3 . bidi-category-l) ;; 
	 (?\x0BB4 . bidi-category-l) ;; 
	 (?\x0BB5 . bidi-category-l) ;; 
	 (?\x0BB7 . bidi-category-l) ;; 
	 (?\x0BB8 . bidi-category-l) ;; 
	 (?\x0BB9 . bidi-category-l) ;; 
	 (?\x0BBE . bidi-category-l) ;; 
	 (?\x0BBF . bidi-category-l) ;; 
	 (?\x0BC0 . bidi-category-nsm) ;; 
	 (?\x0BC1 . bidi-category-l) ;; 
	 (?\x0BC2 . bidi-category-l) ;; 
	 (?\x0BC6 . bidi-category-l) ;; 
	 (?\x0BC7 . bidi-category-l) ;; 
	 (?\x0BC8 . bidi-category-l) ;; 
	 (?\x0BCA . bidi-category-l) ;; 
	 (?\x0BCB . bidi-category-l) ;; 
	 (?\x0BCC . bidi-category-l) ;; 
	 (?\x0BCD . bidi-category-nsm) ;; 
	 (?\x0BD7 . bidi-category-l) ;; 
	 (?\x0BE7 . bidi-category-l) ;; 
	 (?\x0BE8 . bidi-category-l) ;; 
	 (?\x0BE9 . bidi-category-l) ;; 
	 (?\x0BEA . bidi-category-l) ;; 
	 (?\x0BEB . bidi-category-l) ;; 
	 (?\x0BEC . bidi-category-l) ;; 
	 (?\x0BED . bidi-category-l) ;; 
	 (?\x0BEE . bidi-category-l) ;; 
	 (?\x0BEF . bidi-category-l) ;; 
	 (?\x0BF0 . bidi-category-l) ;; 
	 (?\x0BF1 . bidi-category-l) ;; 
	 (?\x0BF2 . bidi-category-l) ;; 
	 (?\x0C01 . bidi-category-l) ;; 
	 (?\x0C02 . bidi-category-l) ;; 
	 (?\x0C03 . bidi-category-l) ;; 
	 (?\x0C05 . bidi-category-l) ;; 
	 (?\x0C06 . bidi-category-l) ;; 
	 (?\x0C07 . bidi-category-l) ;; 
	 (?\x0C08 . bidi-category-l) ;; 
	 (?\x0C09 . bidi-category-l) ;; 
	 (?\x0C0A . bidi-category-l) ;; 
	 (?\x0C0B . bidi-category-l) ;; 
	 (?\x0C0C . bidi-category-l) ;; 
	 (?\x0C0E . bidi-category-l) ;; 
	 (?\x0C0F . bidi-category-l) ;; 
	 (?\x0C10 . bidi-category-l) ;; 
	 (?\x0C12 . bidi-category-l) ;; 
	 (?\x0C13 . bidi-category-l) ;; 
	 (?\x0C14 . bidi-category-l) ;; 
	 (?\x0C15 . bidi-category-l) ;; 
	 (?\x0C16 . bidi-category-l) ;; 
	 (?\x0C17 . bidi-category-l) ;; 
	 (?\x0C18 . bidi-category-l) ;; 
	 (?\x0C19 . bidi-category-l) ;; 
	 (?\x0C1A . bidi-category-l) ;; 
	 (?\x0C1B . bidi-category-l) ;; 
	 (?\x0C1C . bidi-category-l) ;; 
	 (?\x0C1D . bidi-category-l) ;; 
	 (?\x0C1E . bidi-category-l) ;; 
	 (?\x0C1F . bidi-category-l) ;; 
	 (?\x0C20 . bidi-category-l) ;; 
	 (?\x0C21 . bidi-category-l) ;; 
	 (?\x0C22 . bidi-category-l) ;; 
	 (?\x0C23 . bidi-category-l) ;; 
	 (?\x0C24 . bidi-category-l) ;; 
	 (?\x0C25 . bidi-category-l) ;; 
	 (?\x0C26 . bidi-category-l) ;; 
	 (?\x0C27 . bidi-category-l) ;; 
	 (?\x0C28 . bidi-category-l) ;; 
	 (?\x0C2A . bidi-category-l) ;; 
	 (?\x0C2B . bidi-category-l) ;; 
	 (?\x0C2C . bidi-category-l) ;; 
	 (?\x0C2D . bidi-category-l) ;; 
	 (?\x0C2E . bidi-category-l) ;; 
	 (?\x0C2F . bidi-category-l) ;; 
	 (?\x0C30 . bidi-category-l) ;; 
	 (?\x0C31 . bidi-category-l) ;; 
	 (?\x0C32 . bidi-category-l) ;; 
	 (?\x0C33 . bidi-category-l) ;; 
	 (?\x0C35 . bidi-category-l) ;; 
	 (?\x0C36 . bidi-category-l) ;; 
	 (?\x0C37 . bidi-category-l) ;; 
	 (?\x0C38 . bidi-category-l) ;; 
	 (?\x0C39 . bidi-category-l) ;; 
	 (?\x0C3E . bidi-category-nsm) ;; 
	 (?\x0C3F . bidi-category-nsm) ;; 
	 (?\x0C40 . bidi-category-nsm) ;; 
	 (?\x0C41 . bidi-category-l) ;; 
	 (?\x0C42 . bidi-category-l) ;; 
	 (?\x0C43 . bidi-category-l) ;; 
	 (?\x0C44 . bidi-category-l) ;; 
	 (?\x0C46 . bidi-category-nsm) ;; 
	 (?\x0C47 . bidi-category-nsm) ;; 
	 (?\x0C48 . bidi-category-nsm) ;; 
	 (?\x0C4A . bidi-category-nsm) ;; 
	 (?\x0C4B . bidi-category-nsm) ;; 
	 (?\x0C4C . bidi-category-nsm) ;; 
	 (?\x0C4D . bidi-category-nsm) ;; 
	 (?\x0C55 . bidi-category-nsm) ;; 
	 (?\x0C56 . bidi-category-nsm) ;; 
	 (?\x0C60 . bidi-category-l) ;; 
	 (?\x0C61 . bidi-category-l) ;; 
	 (?\x0C66 . bidi-category-l) ;; 
	 (?\x0C67 . bidi-category-l) ;; 
	 (?\x0C68 . bidi-category-l) ;; 
	 (?\x0C69 . bidi-category-l) ;; 
	 (?\x0C6A . bidi-category-l) ;; 
	 (?\x0C6B . bidi-category-l) ;; 
	 (?\x0C6C . bidi-category-l) ;; 
	 (?\x0C6D . bidi-category-l) ;; 
	 (?\x0C6E . bidi-category-l) ;; 
	 (?\x0C6F . bidi-category-l) ;; 
	 (?\x0C82 . bidi-category-l) ;; 
	 (?\x0C83 . bidi-category-l) ;; 
	 (?\x0C85 . bidi-category-l) ;; 
	 (?\x0C86 . bidi-category-l) ;; 
	 (?\x0C87 . bidi-category-l) ;; 
	 (?\x0C88 . bidi-category-l) ;; 
	 (?\x0C89 . bidi-category-l) ;; 
	 (?\x0C8A . bidi-category-l) ;; 
	 (?\x0C8B . bidi-category-l) ;; 
	 (?\x0C8C . bidi-category-l) ;; 
	 (?\x0C8E . bidi-category-l) ;; 
	 (?\x0C8F . bidi-category-l) ;; 
	 (?\x0C90 . bidi-category-l) ;; 
	 (?\x0C92 . bidi-category-l) ;; 
	 (?\x0C93 . bidi-category-l) ;; 
	 (?\x0C94 . bidi-category-l) ;; 
	 (?\x0C95 . bidi-category-l) ;; 
	 (?\x0C96 . bidi-category-l) ;; 
	 (?\x0C97 . bidi-category-l) ;; 
	 (?\x0C98 . bidi-category-l) ;; 
	 (?\x0C99 . bidi-category-l) ;; 
	 (?\x0C9A . bidi-category-l) ;; 
	 (?\x0C9B . bidi-category-l) ;; 
	 (?\x0C9C . bidi-category-l) ;; 
	 (?\x0C9D . bidi-category-l) ;; 
	 (?\x0C9E . bidi-category-l) ;; 
	 (?\x0C9F . bidi-category-l) ;; 
	 (?\x0CA0 . bidi-category-l) ;; 
	 (?\x0CA1 . bidi-category-l) ;; 
	 (?\x0CA2 . bidi-category-l) ;; 
	 (?\x0CA3 . bidi-category-l) ;; 
	 (?\x0CA4 . bidi-category-l) ;; 
	 (?\x0CA5 . bidi-category-l) ;; 
	 (?\x0CA6 . bidi-category-l) ;; 
	 (?\x0CA7 . bidi-category-l) ;; 
	 (?\x0CA8 . bidi-category-l) ;; 
	 (?\x0CAA . bidi-category-l) ;; 
	 (?\x0CAB . bidi-category-l) ;; 
	 (?\x0CAC . bidi-category-l) ;; 
	 (?\x0CAD . bidi-category-l) ;; 
	 (?\x0CAE . bidi-category-l) ;; 
	 (?\x0CAF . bidi-category-l) ;; 
	 (?\x0CB0 . bidi-category-l) ;; 
	 (?\x0CB1 . bidi-category-l) ;; 
	 (?\x0CB2 . bidi-category-l) ;; 
	 (?\x0CB3 . bidi-category-l) ;; 
	 (?\x0CB5 . bidi-category-l) ;; 
	 (?\x0CB6 . bidi-category-l) ;; 
	 (?\x0CB7 . bidi-category-l) ;; 
	 (?\x0CB8 . bidi-category-l) ;; 
	 (?\x0CB9 . bidi-category-l) ;; 
	 (?\x0CBE . bidi-category-l) ;; 
	 (?\x0CBF . bidi-category-nsm) ;; 
	 (?\x0CC0 . bidi-category-l) ;; 
	 (?\x0CC1 . bidi-category-l) ;; 
	 (?\x0CC2 . bidi-category-l) ;; 
	 (?\x0CC3 . bidi-category-l) ;; 
	 (?\x0CC4 . bidi-category-l) ;; 
	 (?\x0CC6 . bidi-category-nsm) ;; 
	 (?\x0CC7 . bidi-category-l) ;; 
	 (?\x0CC8 . bidi-category-l) ;; 
	 (?\x0CCA . bidi-category-l) ;; 
	 (?\x0CCB . bidi-category-l) ;; 
	 (?\x0CCC . bidi-category-nsm) ;; 
	 (?\x0CCD . bidi-category-nsm) ;; 
	 (?\x0CD5 . bidi-category-l) ;; 
	 (?\x0CD6 . bidi-category-l) ;; 
	 (?\x0CDE . bidi-category-l) ;; 
	 (?\x0CE0 . bidi-category-l) ;; 
	 (?\x0CE1 . bidi-category-l) ;; 
	 (?\x0CE6 . bidi-category-l) ;; 
	 (?\x0CE7 . bidi-category-l) ;; 
	 (?\x0CE8 . bidi-category-l) ;; 
	 (?\x0CE9 . bidi-category-l) ;; 
	 (?\x0CEA . bidi-category-l) ;; 
	 (?\x0CEB . bidi-category-l) ;; 
	 (?\x0CEC . bidi-category-l) ;; 
	 (?\x0CED . bidi-category-l) ;; 
	 (?\x0CEE . bidi-category-l) ;; 
	 (?\x0CEF . bidi-category-l) ;; 
	 (?\x0D02 . bidi-category-l) ;; 
	 (?\x0D03 . bidi-category-l) ;; 
	 (?\x0D05 . bidi-category-l) ;; 
	 (?\x0D06 . bidi-category-l) ;; 
	 (?\x0D07 . bidi-category-l) ;; 
	 (?\x0D08 . bidi-category-l) ;; 
	 (?\x0D09 . bidi-category-l) ;; 
	 (?\x0D0A . bidi-category-l) ;; 
	 (?\x0D0B . bidi-category-l) ;; 
	 (?\x0D0C . bidi-category-l) ;; 
	 (?\x0D0E . bidi-category-l) ;; 
	 (?\x0D0F . bidi-category-l) ;; 
	 (?\x0D10 . bidi-category-l) ;; 
	 (?\x0D12 . bidi-category-l) ;; 
	 (?\x0D13 . bidi-category-l) ;; 
	 (?\x0D14 . bidi-category-l) ;; 
	 (?\x0D15 . bidi-category-l) ;; 
	 (?\x0D16 . bidi-category-l) ;; 
	 (?\x0D17 . bidi-category-l) ;; 
	 (?\x0D18 . bidi-category-l) ;; 
	 (?\x0D19 . bidi-category-l) ;; 
	 (?\x0D1A . bidi-category-l) ;; 
	 (?\x0D1B . bidi-category-l) ;; 
	 (?\x0D1C . bidi-category-l) ;; 
	 (?\x0D1D . bidi-category-l) ;; 
	 (?\x0D1E . bidi-category-l) ;; 
	 (?\x0D1F . bidi-category-l) ;; 
	 (?\x0D20 . bidi-category-l) ;; 
	 (?\x0D21 . bidi-category-l) ;; 
	 (?\x0D22 . bidi-category-l) ;; 
	 (?\x0D23 . bidi-category-l) ;; 
	 (?\x0D24 . bidi-category-l) ;; 
	 (?\x0D25 . bidi-category-l) ;; 
	 (?\x0D26 . bidi-category-l) ;; 
	 (?\x0D27 . bidi-category-l) ;; 
	 (?\x0D28 . bidi-category-l) ;; 
	 (?\x0D2A . bidi-category-l) ;; 
	 (?\x0D2B . bidi-category-l) ;; 
	 (?\x0D2C . bidi-category-l) ;; 
	 (?\x0D2D . bidi-category-l) ;; 
	 (?\x0D2E . bidi-category-l) ;; 
	 (?\x0D2F . bidi-category-l) ;; 
	 (?\x0D30 . bidi-category-l) ;; 
	 (?\x0D31 . bidi-category-l) ;; 
	 (?\x0D32 . bidi-category-l) ;; 
	 (?\x0D33 . bidi-category-l) ;; 
	 (?\x0D34 . bidi-category-l) ;; 
	 (?\x0D35 . bidi-category-l) ;; 
	 (?\x0D36 . bidi-category-l) ;; 
	 (?\x0D37 . bidi-category-l) ;; 
	 (?\x0D38 . bidi-category-l) ;; 
	 (?\x0D39 . bidi-category-l) ;; 
	 (?\x0D3E . bidi-category-l) ;; 
	 (?\x0D3F . bidi-category-l) ;; 
	 (?\x0D40 . bidi-category-l) ;; 
	 (?\x0D41 . bidi-category-nsm) ;; 
	 (?\x0D42 . bidi-category-nsm) ;; 
	 (?\x0D43 . bidi-category-nsm) ;; 
	 (?\x0D46 . bidi-category-l) ;; 
	 (?\x0D47 . bidi-category-l) ;; 
	 (?\x0D48 . bidi-category-l) ;; 
	 (?\x0D4A . bidi-category-l) ;; 
	 (?\x0D4B . bidi-category-l) ;; 
	 (?\x0D4C . bidi-category-l) ;; 
	 (?\x0D4D . bidi-category-nsm) ;; 
	 (?\x0D57 . bidi-category-l) ;; 
	 (?\x0D60 . bidi-category-l) ;; 
	 (?\x0D61 . bidi-category-l) ;; 
	 (?\x0D66 . bidi-category-l) ;; 
	 (?\x0D67 . bidi-category-l) ;; 
	 (?\x0D68 . bidi-category-l) ;; 
	 (?\x0D69 . bidi-category-l) ;; 
	 (?\x0D6A . bidi-category-l) ;; 
	 (?\x0D6B . bidi-category-l) ;; 
	 (?\x0D6C . bidi-category-l) ;; 
	 (?\x0D6D . bidi-category-l) ;; 
	 (?\x0D6E . bidi-category-l) ;; 
	 (?\x0D6F . bidi-category-l) ;; 
	 (?\x0D82 . bidi-category-l) ;; 
	 (?\x0D83 . bidi-category-l) ;; 
	 (?\x0D85 . bidi-category-l) ;; 
	 (?\x0D86 . bidi-category-l) ;; 
	 (?\x0D87 . bidi-category-l) ;; 
	 (?\x0D88 . bidi-category-l) ;; 
	 (?\x0D89 . bidi-category-l) ;; 
	 (?\x0D8A . bidi-category-l) ;; 
	 (?\x0D8B . bidi-category-l) ;; 
	 (?\x0D8C . bidi-category-l) ;; 
	 (?\x0D8D . bidi-category-l) ;; 
	 (?\x0D8E . bidi-category-l) ;; 
	 (?\x0D8F . bidi-category-l) ;; 
	 (?\x0D90 . bidi-category-l) ;; 
	 (?\x0D91 . bidi-category-l) ;; 
	 (?\x0D92 . bidi-category-l) ;; 
	 (?\x0D93 . bidi-category-l) ;; 
	 (?\x0D94 . bidi-category-l) ;; 
	 (?\x0D95 . bidi-category-l) ;; 
	 (?\x0D96 . bidi-category-l) ;; 
	 (?\x0D9A . bidi-category-l) ;; 
	 (?\x0D9B . bidi-category-l) ;; 
	 (?\x0D9C . bidi-category-l) ;; 
	 (?\x0D9D . bidi-category-l) ;; 
	 (?\x0D9E . bidi-category-l) ;; 
	 (?\x0D9F . bidi-category-l) ;; 
	 (?\x0DA0 . bidi-category-l) ;; 
	 (?\x0DA1 . bidi-category-l) ;; 
	 (?\x0DA2 . bidi-category-l) ;; 
	 (?\x0DA3 . bidi-category-l) ;; 
	 (?\x0DA4 . bidi-category-l) ;; 
	 (?\x0DA5 . bidi-category-l) ;; 
	 (?\x0DA6 . bidi-category-l) ;; 
	 (?\x0DA7 . bidi-category-l) ;; 
	 (?\x0DA8 . bidi-category-l) ;; 
	 (?\x0DA9 . bidi-category-l) ;; 
	 (?\x0DAA . bidi-category-l) ;; 
	 (?\x0DAB . bidi-category-l) ;; 
	 (?\x0DAC . bidi-category-l) ;; 
	 (?\x0DAD . bidi-category-l) ;; 
	 (?\x0DAE . bidi-category-l) ;; 
	 (?\x0DAF . bidi-category-l) ;; 
	 (?\x0DB0 . bidi-category-l) ;; 
	 (?\x0DB1 . bidi-category-l) ;; 
	 (?\x0DB3 . bidi-category-l) ;; 
	 (?\x0DB4 . bidi-category-l) ;; 
	 (?\x0DB5 . bidi-category-l) ;; 
	 (?\x0DB6 . bidi-category-l) ;; 
	 (?\x0DB7 . bidi-category-l) ;; 
	 (?\x0DB8 . bidi-category-l) ;; 
	 (?\x0DB9 . bidi-category-l) ;; 
	 (?\x0DBA . bidi-category-l) ;; 
	 (?\x0DBB . bidi-category-l) ;; 
	 (?\x0DBD . bidi-category-l) ;; 
	 (?\x0DC0 . bidi-category-l) ;; 
	 (?\x0DC1 . bidi-category-l) ;; 
	 (?\x0DC2 . bidi-category-l) ;; 
	 (?\x0DC3 . bidi-category-l) ;; 
	 (?\x0DC4 . bidi-category-l) ;; 
	 (?\x0DC5 . bidi-category-l) ;; 
	 (?\x0DC6 . bidi-category-l) ;; 
	 (?\x0DCA . bidi-category-nsm) ;; 
	 (?\x0DCF . bidi-category-l) ;; 
	 (?\x0DD0 . bidi-category-l) ;; 
	 (?\x0DD1 . bidi-category-l) ;; 
	 (?\x0DD2 . bidi-category-nsm) ;; 
	 (?\x0DD3 . bidi-category-nsm) ;; 
	 (?\x0DD4 . bidi-category-nsm) ;; 
	 (?\x0DD6 . bidi-category-nsm) ;; 
	 (?\x0DD8 . bidi-category-l) ;; 
	 (?\x0DD9 . bidi-category-l) ;; 
	 (?\x0DDA . bidi-category-l) ;; 
	 (?\x0DDB . bidi-category-l) ;; 
	 (?\x0DDC . bidi-category-l) ;; 
	 (?\x0DDD . bidi-category-l) ;; 
	 (?\x0DDE . bidi-category-l) ;; 
	 (?\x0DDF . bidi-category-l) ;; 
	 (?\x0DF2 . bidi-category-l) ;; 
	 (?\x0DF3 . bidi-category-l) ;; 
	 (?\x0DF4 . bidi-category-l) ;; 
	 (?\x0E01 . bidi-category-l) ;; THAI LETTER KO KAI
	 (?\x0E02 . bidi-category-l) ;; THAI LETTER KHO KHAI
	 (?\x0E03 . bidi-category-l) ;; THAI LETTER KHO KHUAT
	 (?\x0E04 . bidi-category-l) ;; THAI LETTER KHO KHWAI
	 (?\x0E05 . bidi-category-l) ;; THAI LETTER KHO KHON
	 (?\x0E06 . bidi-category-l) ;; THAI LETTER KHO RAKHANG
	 (?\x0E07 . bidi-category-l) ;; THAI LETTER NGO NGU
	 (?\x0E08 . bidi-category-l) ;; THAI LETTER CHO CHAN
	 (?\x0E09 . bidi-category-l) ;; THAI LETTER CHO CHING
	 (?\x0E0A . bidi-category-l) ;; THAI LETTER CHO CHANG
	 (?\x0E0B . bidi-category-l) ;; THAI LETTER SO SO
	 (?\x0E0C . bidi-category-l) ;; THAI LETTER CHO CHOE
	 (?\x0E0D . bidi-category-l) ;; THAI LETTER YO YING
	 (?\x0E0E . bidi-category-l) ;; THAI LETTER DO CHADA
	 (?\x0E0F . bidi-category-l) ;; THAI LETTER TO PATAK
	 (?\x0E10 . bidi-category-l) ;; THAI LETTER THO THAN
	 (?\x0E11 . bidi-category-l) ;; THAI LETTER THO NANGMONTHO
	 (?\x0E12 . bidi-category-l) ;; THAI LETTER THO PHUTHAO
	 (?\x0E13 . bidi-category-l) ;; THAI LETTER NO NEN
	 (?\x0E14 . bidi-category-l) ;; THAI LETTER DO DEK
	 (?\x0E15 . bidi-category-l) ;; THAI LETTER TO TAO
	 (?\x0E16 . bidi-category-l) ;; THAI LETTER THO THUNG
	 (?\x0E17 . bidi-category-l) ;; THAI LETTER THO THAHAN
	 (?\x0E18 . bidi-category-l) ;; THAI LETTER THO THONG
	 (?\x0E19 . bidi-category-l) ;; THAI LETTER NO NU
	 (?\x0E1A . bidi-category-l) ;; THAI LETTER BO BAIMAI
	 (?\x0E1B . bidi-category-l) ;; THAI LETTER PO PLA
	 (?\x0E1C . bidi-category-l) ;; THAI LETTER PHO PHUNG
	 (?\x0E1D . bidi-category-l) ;; THAI LETTER FO FA
	 (?\x0E1E . bidi-category-l) ;; THAI LETTER PHO PHAN
	 (?\x0E1F . bidi-category-l) ;; THAI LETTER FO FAN
	 (?\x0E20 . bidi-category-l) ;; THAI LETTER PHO SAMPHAO
	 (?\x0E21 . bidi-category-l) ;; THAI LETTER MO MA
	 (?\x0E22 . bidi-category-l) ;; THAI LETTER YO YAK
	 (?\x0E23 . bidi-category-l) ;; THAI LETTER RO RUA
	 (?\x0E24 . bidi-category-l) ;; THAI LETTER RU
	 (?\x0E25 . bidi-category-l) ;; THAI LETTER LO LING
	 (?\x0E26 . bidi-category-l) ;; THAI LETTER LU
	 (?\x0E27 . bidi-category-l) ;; THAI LETTER WO WAEN
	 (?\x0E28 . bidi-category-l) ;; THAI LETTER SO SALA
	 (?\x0E29 . bidi-category-l) ;; THAI LETTER SO RUSI
	 (?\x0E2A . bidi-category-l) ;; THAI LETTER SO SUA
	 (?\x0E2B . bidi-category-l) ;; THAI LETTER HO HIP
	 (?\x0E2C . bidi-category-l) ;; THAI LETTER LO CHULA
	 (?\x0E2D . bidi-category-l) ;; THAI LETTER O ANG
	 (?\x0E2E . bidi-category-l) ;; THAI LETTER HO NOK HUK
	 (?\x0E2F . bidi-category-l) ;; THAI PAI YAN NOI
	 (?\x0E30 . bidi-category-l) ;; THAI VOWEL SIGN SARA A
	 (?\x0E31 . bidi-category-nsm) ;; THAI VOWEL SIGN MAI HAN-AKAT
	 (?\x0E32 . bidi-category-l) ;; THAI VOWEL SIGN SARA AA
	 (?\x0E33 . bidi-category-l) ;; THAI VOWEL SIGN SARA AM
	 (?\x0E34 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA I
	 (?\x0E35 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA II
	 (?\x0E36 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA UE
	 (?\x0E37 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA UEE
	 (?\x0E38 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA U
	 (?\x0E39 . bidi-category-nsm) ;; THAI VOWEL SIGN SARA UU
	 (?\x0E3A . bidi-category-nsm) ;; THAI VOWEL SIGN PHINTHU
	 (?\x0E3F . bidi-category-et) ;; THAI BAHT SIGN
	 (?\x0E40 . bidi-category-l) ;; THAI VOWEL SIGN SARA E
	 (?\x0E41 . bidi-category-l) ;; THAI VOWEL SIGN SARA AE
	 (?\x0E42 . bidi-category-l) ;; THAI VOWEL SIGN SARA O
	 (?\x0E43 . bidi-category-l) ;; THAI VOWEL SIGN SARA MAI MUAN
	 (?\x0E44 . bidi-category-l) ;; THAI VOWEL SIGN SARA MAI MALAI
	 (?\x0E45 . bidi-category-l) ;; THAI LAK KHANG YAO
	 (?\x0E46 . bidi-category-l) ;; THAI MAI YAMOK
	 (?\x0E47 . bidi-category-nsm) ;; THAI VOWEL SIGN MAI TAI KHU
	 (?\x0E48 . bidi-category-nsm) ;; THAI TONE MAI EK
	 (?\x0E49 . bidi-category-nsm) ;; THAI TONE MAI THO
	 (?\x0E4A . bidi-category-nsm) ;; THAI TONE MAI TRI
	 (?\x0E4B . bidi-category-nsm) ;; THAI TONE MAI CHATTAWA
	 (?\x0E4C . bidi-category-nsm) ;; THAI THANTHAKHAT
	 (?\x0E4D . bidi-category-nsm) ;; THAI NIKKHAHIT
	 (?\x0E4E . bidi-category-nsm) ;; THAI YAMAKKAN
	 (?\x0E4F . bidi-category-l) ;; THAI FONGMAN
	 (?\x0E50 . bidi-category-l) ;; 
	 (?\x0E51 . bidi-category-l) ;; 
	 (?\x0E52 . bidi-category-l) ;; 
	 (?\x0E53 . bidi-category-l) ;; 
	 (?\x0E54 . bidi-category-l) ;; 
	 (?\x0E55 . bidi-category-l) ;; 
	 (?\x0E56 . bidi-category-l) ;; 
	 (?\x0E57 . bidi-category-l) ;; 
	 (?\x0E58 . bidi-category-l) ;; 
	 (?\x0E59 . bidi-category-l) ;; 
	 (?\x0E5A . bidi-category-l) ;; THAI ANGKHANKHU
	 (?\x0E5B . bidi-category-l) ;; THAI KHOMUT
	 (?\x0E81 . bidi-category-l) ;; 
	 (?\x0E82 . bidi-category-l) ;; 
	 (?\x0E84 . bidi-category-l) ;; 
	 (?\x0E87 . bidi-category-l) ;; 
	 (?\x0E88 . bidi-category-l) ;; 
	 (?\x0E8A . bidi-category-l) ;; 
	 (?\x0E8D . bidi-category-l) ;; 
	 (?\x0E94 . bidi-category-l) ;; 
	 (?\x0E95 . bidi-category-l) ;; 
	 (?\x0E96 . bidi-category-l) ;; 
	 (?\x0E97 . bidi-category-l) ;; 
	 (?\x0E99 . bidi-category-l) ;; 
	 (?\x0E9A . bidi-category-l) ;; 
	 (?\x0E9B . bidi-category-l) ;; 
	 (?\x0E9C . bidi-category-l) ;; 
	 (?\x0E9D . bidi-category-l) ;; 
	 (?\x0E9E . bidi-category-l) ;; 
	 (?\x0E9F . bidi-category-l) ;; 
	 (?\x0EA1 . bidi-category-l) ;; 
	 (?\x0EA2 . bidi-category-l) ;; 
	 (?\x0EA3 . bidi-category-l) ;; 
	 (?\x0EA5 . bidi-category-l) ;; 
	 (?\x0EA7 . bidi-category-l) ;; 
	 (?\x0EAA . bidi-category-l) ;; 
	 (?\x0EAB . bidi-category-l) ;; 
	 (?\x0EAD . bidi-category-l) ;; 
	 (?\x0EAE . bidi-category-l) ;; 
	 (?\x0EAF . bidi-category-l) ;; 
	 (?\x0EB0 . bidi-category-l) ;; 
	 (?\x0EB1 . bidi-category-nsm) ;; 
	 (?\x0EB2 . bidi-category-l) ;; 
	 (?\x0EB3 . bidi-category-l) ;; 
	 (?\x0EB4 . bidi-category-nsm) ;; 
	 (?\x0EB5 . bidi-category-nsm) ;; 
	 (?\x0EB6 . bidi-category-nsm) ;; 
	 (?\x0EB7 . bidi-category-nsm) ;; 
	 (?\x0EB8 . bidi-category-nsm) ;; 
	 (?\x0EB9 . bidi-category-nsm) ;; 
	 (?\x0EBB . bidi-category-nsm) ;; 
	 (?\x0EBC . bidi-category-nsm) ;; 
	 (?\x0EBD . bidi-category-l) ;; 
	 (?\x0EC0 . bidi-category-l) ;; 
	 (?\x0EC1 . bidi-category-l) ;; 
	 (?\x0EC2 . bidi-category-l) ;; 
	 (?\x0EC3 . bidi-category-l) ;; 
	 (?\x0EC4 . bidi-category-l) ;; 
	 (?\x0EC6 . bidi-category-l) ;; 
	 (?\x0EC8 . bidi-category-nsm) ;; 
	 (?\x0EC9 . bidi-category-nsm) ;; 
	 (?\x0ECA . bidi-category-nsm) ;; 
	 (?\x0ECB . bidi-category-nsm) ;; 
	 (?\x0ECC . bidi-category-nsm) ;; 
	 (?\x0ECD . bidi-category-nsm) ;; 
	 (?\x0ED0 . bidi-category-l) ;; 
	 (?\x0ED1 . bidi-category-l) ;; 
	 (?\x0ED2 . bidi-category-l) ;; 
	 (?\x0ED3 . bidi-category-l) ;; 
	 (?\x0ED4 . bidi-category-l) ;; 
	 (?\x0ED5 . bidi-category-l) ;; 
	 (?\x0ED6 . bidi-category-l) ;; 
	 (?\x0ED7 . bidi-category-l) ;; 
	 (?\x0ED8 . bidi-category-l) ;; 
	 (?\x0ED9 . bidi-category-l) ;; 
	 (?\x0EDC . bidi-category-l) ;; 
	 (?\x0EDD . bidi-category-l) ;; 
	 (?\x0F00 . bidi-category-l) ;; 
	 (?\x0F01 . bidi-category-l) ;; 
	 (?\x0F02 . bidi-category-l) ;; 
	 (?\x0F03 . bidi-category-l) ;; 
	 (?\x0F04 . bidi-category-l) ;; TIBETAN SINGLE ORNAMENT
	 (?\x0F05 . bidi-category-l) ;; 
	 (?\x0F06 . bidi-category-l) ;; 
	 (?\x0F07 . bidi-category-l) ;; 
	 (?\x0F08 . bidi-category-l) ;; TIBETAN RGYANSHAD
	 (?\x0F09 . bidi-category-l) ;; 
	 (?\x0F0A . bidi-category-l) ;; 
	 (?\x0F0B . bidi-category-l) ;; TIBETAN TSEG
	 (?\x0F0C . bidi-category-l) ;; 
	 (?\x0F0D . bidi-category-l) ;; TIBETAN SHAD
	 (?\x0F0E . bidi-category-l) ;; TIBETAN DOUBLE SHAD
	 (?\x0F0F . bidi-category-l) ;; 
	 (?\x0F10 . bidi-category-l) ;; 
	 (?\x0F11 . bidi-category-l) ;; TIBETAN RINCHANPHUNGSHAD
	 (?\x0F12 . bidi-category-l) ;; 
	 (?\x0F13 . bidi-category-l) ;; 
	 (?\x0F14 . bidi-category-l) ;; TIBETAN COMMA
	 (?\x0F15 . bidi-category-l) ;; 
	 (?\x0F16 . bidi-category-l) ;; 
	 (?\x0F17 . bidi-category-l) ;; 
	 (?\x0F18 . bidi-category-nsm) ;; 
	 (?\x0F19 . bidi-category-nsm) ;; 
	 (?\x0F1A . bidi-category-l) ;; 
	 (?\x0F1B . bidi-category-l) ;; 
	 (?\x0F1C . bidi-category-l) ;; 
	 (?\x0F1D . bidi-category-l) ;; 
	 (?\x0F1E . bidi-category-l) ;; 
	 (?\x0F1F . bidi-category-l) ;; 
	 (?\x0F20 . bidi-category-l) ;; 
	 (?\x0F21 . bidi-category-l) ;; 
	 (?\x0F22 . bidi-category-l) ;; 
	 (?\x0F23 . bidi-category-l) ;; 
	 (?\x0F24 . bidi-category-l) ;; 
	 (?\x0F25 . bidi-category-l) ;; 
	 (?\x0F26 . bidi-category-l) ;; 
	 (?\x0F27 . bidi-category-l) ;; 
	 (?\x0F28 . bidi-category-l) ;; 
	 (?\x0F29 . bidi-category-l) ;; 
	 (?\x0F2A . bidi-category-l) ;; 
	 (?\x0F2B . bidi-category-l) ;; 
	 (?\x0F2C . bidi-category-l) ;; 
	 (?\x0F2D . bidi-category-l) ;; 
	 (?\x0F2E . bidi-category-l) ;; 
	 (?\x0F2F . bidi-category-l) ;; 
	 (?\x0F30 . bidi-category-l) ;; 
	 (?\x0F31 . bidi-category-l) ;; 
	 (?\x0F32 . bidi-category-l) ;; 
	 (?\x0F33 . bidi-category-l) ;; 
	 (?\x0F34 . bidi-category-l) ;; 
	 (?\x0F35 . bidi-category-nsm) ;; TIBETAN HONORIFIC UNDER RING
	 (?\x0F36 . bidi-category-l) ;; 
	 (?\x0F37 . bidi-category-nsm) ;; TIBETAN UNDER RING
	 (?\x0F38 . bidi-category-l) ;; 
	 (?\x0F39 . bidi-category-nsm) ;; TIBETAN LENITION MARK
	 (?\x0F3A . bidi-category-on) ;; 
	 (?\x0F3B . bidi-category-on) ;; 
	 (?\x0F3C . bidi-category-on) ;; TIBETAN LEFT BRACE
	 (?\x0F3D . bidi-category-on) ;; TIBETAN RIGHT BRACE
	 (?\x0F3E . bidi-category-l) ;; 
	 (?\x0F3F . bidi-category-l) ;; 
	 (?\x0F40 . bidi-category-l) ;; 
	 (?\x0F41 . bidi-category-l) ;; 
	 (?\x0F42 . bidi-category-l) ;; 
	 (?\x0F43 . bidi-category-l) ;; 
	 (?\x0F44 . bidi-category-l) ;; 
	 (?\x0F45 . bidi-category-l) ;; 
	 (?\x0F46 . bidi-category-l) ;; 
	 (?\x0F47 . bidi-category-l) ;; 
	 (?\x0F49 . bidi-category-l) ;; 
	 (?\x0F4A . bidi-category-l) ;; TIBETAN LETTER REVERSED TA
	 (?\x0F4B . bidi-category-l) ;; TIBETAN LETTER REVERSED THA
	 (?\x0F4C . bidi-category-l) ;; TIBETAN LETTER REVERSED DA
	 (?\x0F4D . bidi-category-l) ;; 
	 (?\x0F4E . bidi-category-l) ;; TIBETAN LETTER REVERSED NA
	 (?\x0F4F . bidi-category-l) ;; 
	 (?\x0F50 . bidi-category-l) ;; 
	 (?\x0F51 . bidi-category-l) ;; 
	 (?\x0F52 . bidi-category-l) ;; 
	 (?\x0F53 . bidi-category-l) ;; 
	 (?\x0F54 . bidi-category-l) ;; 
	 (?\x0F55 . bidi-category-l) ;; 
	 (?\x0F56 . bidi-category-l) ;; 
	 (?\x0F57 . bidi-category-l) ;; 
	 (?\x0F58 . bidi-category-l) ;; 
	 (?\x0F59 . bidi-category-l) ;; 
	 (?\x0F5A . bidi-category-l) ;; 
	 (?\x0F5B . bidi-category-l) ;; 
	 (?\x0F5C . bidi-category-l) ;; 
	 (?\x0F5D . bidi-category-l) ;; 
	 (?\x0F5E . bidi-category-l) ;; 
	 (?\x0F5F . bidi-category-l) ;; 
	 (?\x0F60 . bidi-category-l) ;; TIBETAN LETTER AA
	 (?\x0F61 . bidi-category-l) ;; 
	 (?\x0F62 . bidi-category-l) ;; 
	 (?\x0F63 . bidi-category-l) ;; 
	 (?\x0F64 . bidi-category-l) ;; 
	 (?\x0F65 . bidi-category-l) ;; TIBETAN LETTER REVERSED SHA
	 (?\x0F66 . bidi-category-l) ;; 
	 (?\x0F67 . bidi-category-l) ;; 
	 (?\x0F68 . bidi-category-l) ;; 
	 (?\x0F69 . bidi-category-l) ;; 
	 (?\x0F6A . bidi-category-l) ;; 
	 (?\x0F71 . bidi-category-nsm) ;; 
	 (?\x0F72 . bidi-category-nsm) ;; 
	 (?\x0F73 . bidi-category-nsm) ;; 
	 (?\x0F74 . bidi-category-nsm) ;; 
	 (?\x0F75 . bidi-category-nsm) ;; 
	 (?\x0F76 . bidi-category-nsm) ;; 
	 (?\x0F77 . bidi-category-nsm) ;; 
	 (?\x0F78 . bidi-category-nsm) ;; 
	 (?\x0F79 . bidi-category-nsm) ;; 
	 (?\x0F7A . bidi-category-nsm) ;; 
	 (?\x0F7B . bidi-category-nsm) ;; TIBETAN VOWEL SIGN AI
	 (?\x0F7C . bidi-category-nsm) ;; 
	 (?\x0F7D . bidi-category-nsm) ;; TIBETAN VOWEL SIGN AU
	 (?\x0F7E . bidi-category-nsm) ;; TIBETAN ANUSVARA
	 (?\x0F7F . bidi-category-l) ;; TIBETAN VISARGA
	 (?\x0F80 . bidi-category-nsm) ;; TIBETAN VOWEL SIGN SHORT I
	 (?\x0F81 . bidi-category-nsm) ;; 
	 (?\x0F82 . bidi-category-nsm) ;; TIBETAN CANDRABINDU WITH ORNAMENT
	 (?\x0F83 . bidi-category-nsm) ;; TIBETAN CANDRABINDU
	 (?\x0F84 . bidi-category-nsm) ;; TIBETAN VIRAMA
	 (?\x0F85 . bidi-category-l) ;; TIBETAN CHUCHENYIGE
	 (?\x0F86 . bidi-category-nsm) ;; 
	 (?\x0F87 . bidi-category-nsm) ;; 
	 (?\x0F88 . bidi-category-l) ;; 
	 (?\x0F89 . bidi-category-l) ;; 
	 (?\x0F8A . bidi-category-l) ;; 
	 (?\x0F8B . bidi-category-l) ;; 
	 (?\x0F90 . bidi-category-nsm) ;; 
	 (?\x0F91 . bidi-category-nsm) ;; 
	 (?\x0F92 . bidi-category-nsm) ;; 
	 (?\x0F93 . bidi-category-nsm) ;; 
	 (?\x0F94 . bidi-category-nsm) ;; 
	 (?\x0F95 . bidi-category-nsm) ;; 
	 (?\x0F96 . bidi-category-nsm) ;; 
	 (?\x0F97 . bidi-category-nsm) ;; 
	 (?\x0F99 . bidi-category-nsm) ;; 
	 (?\x0F9A . bidi-category-nsm) ;; 
	 (?\x0F9B . bidi-category-nsm) ;; 
	 (?\x0F9C . bidi-category-nsm) ;; 
	 (?\x0F9D . bidi-category-nsm) ;; 
	 (?\x0F9E . bidi-category-nsm) ;; 
	 (?\x0F9F . bidi-category-nsm) ;; 
	 (?\x0FA0 . bidi-category-nsm) ;; 
	 (?\x0FA1 . bidi-category-nsm) ;; 
	 (?\x0FA2 . bidi-category-nsm) ;; 
	 (?\x0FA3 . bidi-category-nsm) ;; 
	 (?\x0FA4 . bidi-category-nsm) ;; 
	 (?\x0FA5 . bidi-category-nsm) ;; 
	 (?\x0FA6 . bidi-category-nsm) ;; 
	 (?\x0FA7 . bidi-category-nsm) ;; 
	 (?\x0FA8 . bidi-category-nsm) ;; 
	 (?\x0FA9 . bidi-category-nsm) ;; 
	 (?\x0FAA . bidi-category-nsm) ;; 
	 (?\x0FAB . bidi-category-nsm) ;; 
	 (?\x0FAC . bidi-category-nsm) ;; 
	 (?\x0FAD . bidi-category-nsm) ;; 
	 (?\x0FAE . bidi-category-nsm) ;; 
	 (?\x0FAF . bidi-category-nsm) ;; 
	 (?\x0FB0 . bidi-category-nsm) ;; 
	 (?\x0FB1 . bidi-category-nsm) ;; 
	 (?\x0FB2 . bidi-category-nsm) ;; 
	 (?\x0FB3 . bidi-category-nsm) ;; 
	 (?\x0FB4 . bidi-category-nsm) ;; 
	 (?\x0FB5 . bidi-category-nsm) ;; 
	 (?\x0FB6 . bidi-category-nsm) ;; 
	 (?\x0FB7 . bidi-category-nsm) ;; 
	 (?\x0FB8 . bidi-category-nsm) ;; 
	 (?\x0FB9 . bidi-category-nsm) ;; 
	 (?\x0FBA . bidi-category-nsm) ;; 
	 (?\x0FBB . bidi-category-nsm) ;; 
	 (?\x0FBC . bidi-category-nsm) ;; 
	 (?\x0FBE . bidi-category-l) ;; 
	 (?\x0FBF . bidi-category-l) ;; 
	 (?\x0FC0 . bidi-category-l) ;; 
	 (?\x0FC1 . bidi-category-l) ;; 
	 (?\x0FC2 . bidi-category-l) ;; 
	 (?\x0FC3 . bidi-category-l) ;; 
	 (?\x0FC4 . bidi-category-l) ;; 
	 (?\x0FC5 . bidi-category-l) ;; 
	 (?\x0FC6 . bidi-category-nsm) ;; 
	 (?\x0FC7 . bidi-category-l) ;; 
	 (?\x0FC8 . bidi-category-l) ;; 
	 (?\x0FC9 . bidi-category-l) ;; 
	 (?\x0FCA . bidi-category-l) ;; 
	 (?\x0FCB . bidi-category-l) ;; 
	 (?\x0FCC . bidi-category-l) ;; 
	 (?\x0FCF . bidi-category-l) ;; 
	 (?\x1000 . bidi-category-l) ;; 
	 (?\x1001 . bidi-category-l) ;; 
	 (?\x1002 . bidi-category-l) ;; 
	 (?\x1003 . bidi-category-l) ;; 
	 (?\x1004 . bidi-category-l) ;; 
	 (?\x1005 . bidi-category-l) ;; 
	 (?\x1006 . bidi-category-l) ;; 
	 (?\x1007 . bidi-category-l) ;; 
	 (?\x1008 . bidi-category-l) ;; 
	 (?\x1009 . bidi-category-l) ;; 
	 (?\x100A . bidi-category-l) ;; 
	 (?\x100B . bidi-category-l) ;; 
	 (?\x100C . bidi-category-l) ;; 
	 (?\x100D . bidi-category-l) ;; 
	 (?\x100E . bidi-category-l) ;; 
	 (?\x100F . bidi-category-l) ;; 
	 (?\x1010 . bidi-category-l) ;; 
	 (?\x1011 . bidi-category-l) ;; 
	 (?\x1012 . bidi-category-l) ;; 
	 (?\x1013 . bidi-category-l) ;; 
	 (?\x1014 . bidi-category-l) ;; 
	 (?\x1015 . bidi-category-l) ;; 
	 (?\x1016 . bidi-category-l) ;; 
	 (?\x1017 . bidi-category-l) ;; 
	 (?\x1018 . bidi-category-l) ;; 
	 (?\x1019 . bidi-category-l) ;; 
	 (?\x101A . bidi-category-l) ;; 
	 (?\x101B . bidi-category-l) ;; 
	 (?\x101C . bidi-category-l) ;; 
	 (?\x101D . bidi-category-l) ;; 
	 (?\x101E . bidi-category-l) ;; 
	 (?\x101F . bidi-category-l) ;; 
	 (?\x1020 . bidi-category-l) ;; 
	 (?\x1021 . bidi-category-l) ;; 
	 (?\x1023 . bidi-category-l) ;; 
	 (?\x1024 . bidi-category-l) ;; 
	 (?\x1025 . bidi-category-l) ;; 
	 (?\x1026 . bidi-category-l) ;; 
	 (?\x1027 . bidi-category-l) ;; 
	 (?\x1029 . bidi-category-l) ;; 
	 (?\x102A . bidi-category-l) ;; 
	 (?\x102C . bidi-category-l) ;; 
	 (?\x102D . bidi-category-nsm) ;; 
	 (?\x102E . bidi-category-nsm) ;; 
	 (?\x102F . bidi-category-nsm) ;; 
	 (?\x1030 . bidi-category-nsm) ;; 
	 (?\x1031 . bidi-category-l) ;; 
	 (?\x1032 . bidi-category-nsm) ;; 
	 (?\x1036 . bidi-category-nsm) ;; 
	 (?\x1037 . bidi-category-nsm) ;; 
	 (?\x1038 . bidi-category-l) ;; 
	 (?\x1039 . bidi-category-nsm) ;; 
	 (?\x1040 . bidi-category-l) ;; 
	 (?\x1041 . bidi-category-l) ;; 
	 (?\x1042 . bidi-category-l) ;; 
	 (?\x1043 . bidi-category-l) ;; 
	 (?\x1044 . bidi-category-l) ;; 
	 (?\x1045 . bidi-category-l) ;; 
	 (?\x1046 . bidi-category-l) ;; 
	 (?\x1047 . bidi-category-l) ;; 
	 (?\x1048 . bidi-category-l) ;; 
	 (?\x1049 . bidi-category-l) ;; 
	 (?\x104A . bidi-category-l) ;; 
	 (?\x104B . bidi-category-l) ;; 
	 (?\x104C . bidi-category-l) ;; 
	 (?\x104D . bidi-category-l) ;; 
	 (?\x104E . bidi-category-l) ;; 
	 (?\x104F . bidi-category-l) ;; 
	 (?\x1050 . bidi-category-l) ;; 
	 (?\x1051 . bidi-category-l) ;; 
	 (?\x1052 . bidi-category-l) ;; 
	 (?\x1053 . bidi-category-l) ;; 
	 (?\x1054 . bidi-category-l) ;; 
	 (?\x1055 . bidi-category-l) ;; 
	 (?\x1056 . bidi-category-l) ;; 
	 (?\x1057 . bidi-category-l) ;; 
	 (?\x1058 . bidi-category-nsm) ;; 
	 (?\x1059 . bidi-category-nsm) ;; 
	 (?\x10A0 . bidi-category-l) ;; 
	 (?\x10A1 . bidi-category-l) ;; 
	 (?\x10A2 . bidi-category-l) ;; 
	 (?\x10A3 . bidi-category-l) ;; 
	 (?\x10A4 . bidi-category-l) ;; 
	 (?\x10A5 . bidi-category-l) ;; 
	 (?\x10A6 . bidi-category-l) ;; 
	 (?\x10A7 . bidi-category-l) ;; 
	 (?\x10A8 . bidi-category-l) ;; 
	 (?\x10A9 . bidi-category-l) ;; 
	 (?\x10AA . bidi-category-l) ;; 
	 (?\x10AB . bidi-category-l) ;; 
	 (?\x10AC . bidi-category-l) ;; 
	 (?\x10AD . bidi-category-l) ;; 
	 (?\x10AE . bidi-category-l) ;; 
	 (?\x10AF . bidi-category-l) ;; 
	 (?\x10B0 . bidi-category-l) ;; 
	 (?\x10B1 . bidi-category-l) ;; 
	 (?\x10B2 . bidi-category-l) ;; 
	 (?\x10B3 . bidi-category-l) ;; 
	 (?\x10B4 . bidi-category-l) ;; 
	 (?\x10B5 . bidi-category-l) ;; 
	 (?\x10B6 . bidi-category-l) ;; 
	 (?\x10B7 . bidi-category-l) ;; 
	 (?\x10B8 . bidi-category-l) ;; 
	 (?\x10B9 . bidi-category-l) ;; 
	 (?\x10BA . bidi-category-l) ;; 
	 (?\x10BB . bidi-category-l) ;; 
	 (?\x10BC . bidi-category-l) ;; 
	 (?\x10BD . bidi-category-l) ;; 
	 (?\x10BE . bidi-category-l) ;; 
	 (?\x10BF . bidi-category-l) ;; 
	 (?\x10C0 . bidi-category-l) ;; 
	 (?\x10C1 . bidi-category-l) ;; 
	 (?\x10C2 . bidi-category-l) ;; 
	 (?\x10C3 . bidi-category-l) ;; 
	 (?\x10C4 . bidi-category-l) ;; 
	 (?\x10C5 . bidi-category-l) ;; 
	 (?\x10D0 . bidi-category-l) ;; GEORGIAN SMALL LETTER AN
	 (?\x10D1 . bidi-category-l) ;; GEORGIAN SMALL LETTER BAN
	 (?\x10D2 . bidi-category-l) ;; GEORGIAN SMALL LETTER GAN
	 (?\x10D3 . bidi-category-l) ;; GEORGIAN SMALL LETTER DON
	 (?\x10D4 . bidi-category-l) ;; GEORGIAN SMALL LETTER EN
	 (?\x10D5 . bidi-category-l) ;; GEORGIAN SMALL LETTER VIN
	 (?\x10D6 . bidi-category-l) ;; GEORGIAN SMALL LETTER ZEN
	 (?\x10D7 . bidi-category-l) ;; GEORGIAN SMALL LETTER TAN
	 (?\x10D8 . bidi-category-l) ;; GEORGIAN SMALL LETTER IN
	 (?\x10D9 . bidi-category-l) ;; GEORGIAN SMALL LETTER KAN
	 (?\x10DA . bidi-category-l) ;; GEORGIAN SMALL LETTER LAS
	 (?\x10DB . bidi-category-l) ;; GEORGIAN SMALL LETTER MAN
	 (?\x10DC . bidi-category-l) ;; GEORGIAN SMALL LETTER NAR
	 (?\x10DD . bidi-category-l) ;; GEORGIAN SMALL LETTER ON
	 (?\x10DE . bidi-category-l) ;; GEORGIAN SMALL LETTER PAR
	 (?\x10DF . bidi-category-l) ;; GEORGIAN SMALL LETTER ZHAR
	 (?\x10E0 . bidi-category-l) ;; GEORGIAN SMALL LETTER RAE
	 (?\x10E1 . bidi-category-l) ;; GEORGIAN SMALL LETTER SAN
	 (?\x10E2 . bidi-category-l) ;; GEORGIAN SMALL LETTER TAR
	 (?\x10E3 . bidi-category-l) ;; GEORGIAN SMALL LETTER UN
	 (?\x10E4 . bidi-category-l) ;; GEORGIAN SMALL LETTER PHAR
	 (?\x10E5 . bidi-category-l) ;; GEORGIAN SMALL LETTER KHAR
	 (?\x10E6 . bidi-category-l) ;; GEORGIAN SMALL LETTER GHAN
	 (?\x10E7 . bidi-category-l) ;; GEORGIAN SMALL LETTER QAR
	 (?\x10E8 . bidi-category-l) ;; GEORGIAN SMALL LETTER SHIN
	 (?\x10E9 . bidi-category-l) ;; GEORGIAN SMALL LETTER CHIN
	 (?\x10EA . bidi-category-l) ;; GEORGIAN SMALL LETTER CAN
	 (?\x10EB . bidi-category-l) ;; GEORGIAN SMALL LETTER JIL
	 (?\x10EC . bidi-category-l) ;; GEORGIAN SMALL LETTER CIL
	 (?\x10ED . bidi-category-l) ;; GEORGIAN SMALL LETTER CHAR
	 (?\x10EE . bidi-category-l) ;; GEORGIAN SMALL LETTER XAN
	 (?\x10EF . bidi-category-l) ;; GEORGIAN SMALL LETTER JHAN
	 (?\x10F0 . bidi-category-l) ;; GEORGIAN SMALL LETTER HAE
	 (?\x10F1 . bidi-category-l) ;; GEORGIAN SMALL LETTER HE
	 (?\x10F2 . bidi-category-l) ;; GEORGIAN SMALL LETTER HIE
	 (?\x10F3 . bidi-category-l) ;; GEORGIAN SMALL LETTER WE
	 (?\x10F4 . bidi-category-l) ;; GEORGIAN SMALL LETTER HAR
	 (?\x10F5 . bidi-category-l) ;; GEORGIAN SMALL LETTER HOE
	 (?\x10F6 . bidi-category-l) ;; GEORGIAN SMALL LETTER FI
	 (?\x10FB . bidi-category-l) ;; 
	 (?\x1100 . bidi-category-l) ;; 
	 (?\x1101 . bidi-category-l) ;; 
	 (?\x1102 . bidi-category-l) ;; 
	 (?\x1103 . bidi-category-l) ;; 
	 (?\x1104 . bidi-category-l) ;; 
	 (?\x1105 . bidi-category-l) ;; 
	 (?\x1106 . bidi-category-l) ;; 
	 (?\x1107 . bidi-category-l) ;; 
	 (?\x1108 . bidi-category-l) ;; 
	 (?\x1109 . bidi-category-l) ;; 
	 (?\x110A . bidi-category-l) ;; 
	 (?\x110B . bidi-category-l) ;; 
	 (?\x110C . bidi-category-l) ;; 
	 (?\x110D . bidi-category-l) ;; 
	 (?\x110E . bidi-category-l) ;; 
	 (?\x110F . bidi-category-l) ;; 
	 (?\x1110 . bidi-category-l) ;; 
	 (?\x1111 . bidi-category-l) ;; 
	 (?\x1112 . bidi-category-l) ;; 
	 (?\x1113 . bidi-category-l) ;; 
	 (?\x1114 . bidi-category-l) ;; 
	 (?\x1115 . bidi-category-l) ;; 
	 (?\x1116 . bidi-category-l) ;; 
	 (?\x1117 . bidi-category-l) ;; 
	 (?\x1118 . bidi-category-l) ;; 
	 (?\x1119 . bidi-category-l) ;; 
	 (?\x111A . bidi-category-l) ;; 
	 (?\x111B . bidi-category-l) ;; 
	 (?\x111C . bidi-category-l) ;; 
	 (?\x111D . bidi-category-l) ;; 
	 (?\x111E . bidi-category-l) ;; 
	 (?\x111F . bidi-category-l) ;; 
	 (?\x1120 . bidi-category-l) ;; 
	 (?\x1121 . bidi-category-l) ;; 
	 (?\x1122 . bidi-category-l) ;; 
	 (?\x1123 . bidi-category-l) ;; 
	 (?\x1124 . bidi-category-l) ;; 
	 (?\x1125 . bidi-category-l) ;; 
	 (?\x1126 . bidi-category-l) ;; 
	 (?\x1127 . bidi-category-l) ;; 
	 (?\x1128 . bidi-category-l) ;; 
	 (?\x1129 . bidi-category-l) ;; 
	 (?\x112A . bidi-category-l) ;; 
	 (?\x112B . bidi-category-l) ;; 
	 (?\x112C . bidi-category-l) ;; 
	 (?\x112D . bidi-category-l) ;; 
	 (?\x112E . bidi-category-l) ;; 
	 (?\x112F . bidi-category-l) ;; 
	 (?\x1130 . bidi-category-l) ;; 
	 (?\x1131 . bidi-category-l) ;; 
	 (?\x1132 . bidi-category-l) ;; 
	 (?\x1133 . bidi-category-l) ;; 
	 (?\x1134 . bidi-category-l) ;; 
	 (?\x1135 . bidi-category-l) ;; 
	 (?\x1136 . bidi-category-l) ;; 
	 (?\x1137 . bidi-category-l) ;; 
	 (?\x1138 . bidi-category-l) ;; 
	 (?\x1139 . bidi-category-l) ;; 
	 (?\x113A . bidi-category-l) ;; 
	 (?\x113B . bidi-category-l) ;; 
	 (?\x113C . bidi-category-l) ;; 
	 (?\x113D . bidi-category-l) ;; 
	 (?\x113E . bidi-category-l) ;; 
	 (?\x113F . bidi-category-l) ;; 
	 (?\x1140 . bidi-category-l) ;; 
	 (?\x1141 . bidi-category-l) ;; 
	 (?\x1142 . bidi-category-l) ;; 
	 (?\x1143 . bidi-category-l) ;; 
	 (?\x1144 . bidi-category-l) ;; 
	 (?\x1145 . bidi-category-l) ;; 
	 (?\x1146 . bidi-category-l) ;; 
	 (?\x1147 . bidi-category-l) ;; 
	 (?\x1148 . bidi-category-l) ;; 
	 (?\x1149 . bidi-category-l) ;; 
	 (?\x114A . bidi-category-l) ;; 
	 (?\x114B . bidi-category-l) ;; 
	 (?\x114C . bidi-category-l) ;; 
	 (?\x114D . bidi-category-l) ;; 
	 (?\x114E . bidi-category-l) ;; 
	 (?\x114F . bidi-category-l) ;; 
	 (?\x1150 . bidi-category-l) ;; 
	 (?\x1151 . bidi-category-l) ;; 
	 (?\x1152 . bidi-category-l) ;; 
	 (?\x1153 . bidi-category-l) ;; 
	 (?\x1154 . bidi-category-l) ;; 
	 (?\x1155 . bidi-category-l) ;; 
	 (?\x1156 . bidi-category-l) ;; 
	 (?\x1157 . bidi-category-l) ;; 
	 (?\x1158 . bidi-category-l) ;; 
	 (?\x1159 . bidi-category-l) ;; 
	 (?\x115F . bidi-category-l) ;; 
	 (?\x1160 . bidi-category-l) ;; 
	 (?\x1161 . bidi-category-l) ;; 
	 (?\x1162 . bidi-category-l) ;; 
	 (?\x1163 . bidi-category-l) ;; 
	 (?\x1164 . bidi-category-l) ;; 
	 (?\x1165 . bidi-category-l) ;; 
	 (?\x1166 . bidi-category-l) ;; 
	 (?\x1167 . bidi-category-l) ;; 
	 (?\x1168 . bidi-category-l) ;; 
	 (?\x1169 . bidi-category-l) ;; 
	 (?\x116A . bidi-category-l) ;; 
	 (?\x116B . bidi-category-l) ;; 
	 (?\x116C . bidi-category-l) ;; 
	 (?\x116D . bidi-category-l) ;; 
	 (?\x116E . bidi-category-l) ;; 
	 (?\x116F . bidi-category-l) ;; 
	 (?\x1170 . bidi-category-l) ;; 
	 (?\x1171 . bidi-category-l) ;; 
	 (?\x1172 . bidi-category-l) ;; 
	 (?\x1173 . bidi-category-l) ;; 
	 (?\x1174 . bidi-category-l) ;; 
	 (?\x1175 . bidi-category-l) ;; 
	 (?\x1176 . bidi-category-l) ;; 
	 (?\x1177 . bidi-category-l) ;; 
	 (?\x1178 . bidi-category-l) ;; 
	 (?\x1179 . bidi-category-l) ;; 
	 (?\x117A . bidi-category-l) ;; 
	 (?\x117B . bidi-category-l) ;; 
	 (?\x117C . bidi-category-l) ;; 
	 (?\x117D . bidi-category-l) ;; 
	 (?\x117E . bidi-category-l) ;; 
	 (?\x117F . bidi-category-l) ;; 
	 (?\x1180 . bidi-category-l) ;; 
	 (?\x1181 . bidi-category-l) ;; 
	 (?\x1182 . bidi-category-l) ;; 
	 (?\x1183 . bidi-category-l) ;; 
	 (?\x1184 . bidi-category-l) ;; 
	 (?\x1185 . bidi-category-l) ;; 
	 (?\x1186 . bidi-category-l) ;; 
	 (?\x1187 . bidi-category-l) ;; 
	 (?\x1188 . bidi-category-l) ;; 
	 (?\x1189 . bidi-category-l) ;; 
	 (?\x118A . bidi-category-l) ;; 
	 (?\x118B . bidi-category-l) ;; 
	 (?\x118C . bidi-category-l) ;; 
	 (?\x118D . bidi-category-l) ;; 
	 (?\x118E . bidi-category-l) ;; 
	 (?\x118F . bidi-category-l) ;; 
	 (?\x1190 . bidi-category-l) ;; 
	 (?\x1191 . bidi-category-l) ;; 
	 (?\x1192 . bidi-category-l) ;; 
	 (?\x1193 . bidi-category-l) ;; 
	 (?\x1194 . bidi-category-l) ;; 
	 (?\x1195 . bidi-category-l) ;; 
	 (?\x1196 . bidi-category-l) ;; 
	 (?\x1197 . bidi-category-l) ;; 
	 (?\x1198 . bidi-category-l) ;; 
	 (?\x1199 . bidi-category-l) ;; 
	 (?\x119A . bidi-category-l) ;; 
	 (?\x119B . bidi-category-l) ;; 
	 (?\x119C . bidi-category-l) ;; 
	 (?\x119D . bidi-category-l) ;; 
	 (?\x119E . bidi-category-l) ;; 
	 (?\x119F . bidi-category-l) ;; 
	 (?\x11A0 . bidi-category-l) ;; 
	 (?\x11A1 . bidi-category-l) ;; 
	 (?\x11A2 . bidi-category-l) ;; 
	 (?\x11A8 . bidi-category-l) ;; 
	 (?\x11A9 . bidi-category-l) ;; 
	 (?\x11AA . bidi-category-l) ;; 
	 (?\x11AB . bidi-category-l) ;; 
	 (?\x11AC . bidi-category-l) ;; 
	 (?\x11AD . bidi-category-l) ;; 
	 (?\x11AE . bidi-category-l) ;; 
	 (?\x11AF . bidi-category-l) ;; 
	 (?\x11B0 . bidi-category-l) ;; 
	 (?\x11B1 . bidi-category-l) ;; 
	 (?\x11B2 . bidi-category-l) ;; 
	 (?\x11B3 . bidi-category-l) ;; 
	 (?\x11B4 . bidi-category-l) ;; 
	 (?\x11B5 . bidi-category-l) ;; 
	 (?\x11B6 . bidi-category-l) ;; 
	 (?\x11B7 . bidi-category-l) ;; 
	 (?\x11B8 . bidi-category-l) ;; 
	 (?\x11B9 . bidi-category-l) ;; 
	 (?\x11BA . bidi-category-l) ;; 
	 (?\x11BB . bidi-category-l) ;; 
	 (?\x11BC . bidi-category-l) ;; 
	 (?\x11BD . bidi-category-l) ;; 
	 (?\x11BE . bidi-category-l) ;; 
	 (?\x11BF . bidi-category-l) ;; 
	 (?\x11C0 . bidi-category-l) ;; 
	 (?\x11C1 . bidi-category-l) ;; 
	 (?\x11C2 . bidi-category-l) ;; 
	 (?\x11C3 . bidi-category-l) ;; 
	 (?\x11C4 . bidi-category-l) ;; 
	 (?\x11C5 . bidi-category-l) ;; 
	 (?\x11C6 . bidi-category-l) ;; 
	 (?\x11C7 . bidi-category-l) ;; 
	 (?\x11C8 . bidi-category-l) ;; 
	 (?\x11C9 . bidi-category-l) ;; 
	 (?\x11CA . bidi-category-l) ;; 
	 (?\x11CB . bidi-category-l) ;; 
	 (?\x11CC . bidi-category-l) ;; 
	 (?\x11CD . bidi-category-l) ;; 
	 (?\x11CE . bidi-category-l) ;; 
	 (?\x11CF . bidi-category-l) ;; 
	 (?\x11D0 . bidi-category-l) ;; 
	 (?\x11D1 . bidi-category-l) ;; 
	 (?\x11D2 . bidi-category-l) ;; 
	 (?\x11D3 . bidi-category-l) ;; 
	 (?\x11D4 . bidi-category-l) ;; 
	 (?\x11D5 . bidi-category-l) ;; 
	 (?\x11D6 . bidi-category-l) ;; 
	 (?\x11D7 . bidi-category-l) ;; 
	 (?\x11D8 . bidi-category-l) ;; 
	 (?\x11D9 . bidi-category-l) ;; 
	 (?\x11DA . bidi-category-l) ;; 
	 (?\x11DB . bidi-category-l) ;; 
	 (?\x11DC . bidi-category-l) ;; 
	 (?\x11DD . bidi-category-l) ;; 
	 (?\x11DE . bidi-category-l) ;; 
	 (?\x11DF . bidi-category-l) ;; 
	 (?\x11E0 . bidi-category-l) ;; 
	 (?\x11E1 . bidi-category-l) ;; 
	 (?\x11E2 . bidi-category-l) ;; 
	 (?\x11E3 . bidi-category-l) ;; 
	 (?\x11E4 . bidi-category-l) ;; 
	 (?\x11E5 . bidi-category-l) ;; 
	 (?\x11E6 . bidi-category-l) ;; 
	 (?\x11E7 . bidi-category-l) ;; 
	 (?\x11E8 . bidi-category-l) ;; 
	 (?\x11E9 . bidi-category-l) ;; 
	 (?\x11EA . bidi-category-l) ;; 
	 (?\x11EB . bidi-category-l) ;; 
	 (?\x11EC . bidi-category-l) ;; 
	 (?\x11ED . bidi-category-l) ;; 
	 (?\x11EE . bidi-category-l) ;; 
	 (?\x11EF . bidi-category-l) ;; 
	 (?\x11F0 . bidi-category-l) ;; 
	 (?\x11F1 . bidi-category-l) ;; 
	 (?\x11F2 . bidi-category-l) ;; 
	 (?\x11F3 . bidi-category-l) ;; 
	 (?\x11F4 . bidi-category-l) ;; 
	 (?\x11F5 . bidi-category-l) ;; 
	 (?\x11F6 . bidi-category-l) ;; 
	 (?\x11F7 . bidi-category-l) ;; 
	 (?\x11F8 . bidi-category-l) ;; 
	 (?\x11F9 . bidi-category-l) ;; 
	 (?\x1200 . bidi-category-l) ;; 
	 (?\x1201 . bidi-category-l) ;; 
	 (?\x1202 . bidi-category-l) ;; 
	 (?\x1203 . bidi-category-l) ;; 
	 (?\x1204 . bidi-category-l) ;; 
	 (?\x1205 . bidi-category-l) ;; 
	 (?\x1206 . bidi-category-l) ;; 
	 (?\x1208 . bidi-category-l) ;; 
	 (?\x1209 . bidi-category-l) ;; 
	 (?\x120A . bidi-category-l) ;; 
	 (?\x120B . bidi-category-l) ;; 
	 (?\x120C . bidi-category-l) ;; 
	 (?\x120D . bidi-category-l) ;; 
	 (?\x120E . bidi-category-l) ;; 
	 (?\x120F . bidi-category-l) ;; 
	 (?\x1210 . bidi-category-l) ;; 
	 (?\x1211 . bidi-category-l) ;; 
	 (?\x1212 . bidi-category-l) ;; 
	 (?\x1213 . bidi-category-l) ;; 
	 (?\x1214 . bidi-category-l) ;; 
	 (?\x1215 . bidi-category-l) ;; 
	 (?\x1216 . bidi-category-l) ;; 
	 (?\x1217 . bidi-category-l) ;; 
	 (?\x1218 . bidi-category-l) ;; 
	 (?\x1219 . bidi-category-l) ;; 
	 (?\x121A . bidi-category-l) ;; 
	 (?\x121B . bidi-category-l) ;; 
	 (?\x121C . bidi-category-l) ;; 
	 (?\x121D . bidi-category-l) ;; 
	 (?\x121E . bidi-category-l) ;; 
	 (?\x121F . bidi-category-l) ;; 
	 (?\x1220 . bidi-category-l) ;; 
	 (?\x1221 . bidi-category-l) ;; 
	 (?\x1222 . bidi-category-l) ;; 
	 (?\x1223 . bidi-category-l) ;; 
	 (?\x1224 . bidi-category-l) ;; 
	 (?\x1225 . bidi-category-l) ;; 
	 (?\x1226 . bidi-category-l) ;; 
	 (?\x1227 . bidi-category-l) ;; 
	 (?\x1228 . bidi-category-l) ;; 
	 (?\x1229 . bidi-category-l) ;; 
	 (?\x122A . bidi-category-l) ;; 
	 (?\x122B . bidi-category-l) ;; 
	 (?\x122C . bidi-category-l) ;; 
	 (?\x122D . bidi-category-l) ;; 
	 (?\x122E . bidi-category-l) ;; 
	 (?\x122F . bidi-category-l) ;; 
	 (?\x1230 . bidi-category-l) ;; 
	 (?\x1231 . bidi-category-l) ;; 
	 (?\x1232 . bidi-category-l) ;; 
	 (?\x1233 . bidi-category-l) ;; 
	 (?\x1234 . bidi-category-l) ;; 
	 (?\x1235 . bidi-category-l) ;; 
	 (?\x1236 . bidi-category-l) ;; 
	 (?\x1237 . bidi-category-l) ;; 
	 (?\x1238 . bidi-category-l) ;; 
	 (?\x1239 . bidi-category-l) ;; 
	 (?\x123A . bidi-category-l) ;; 
	 (?\x123B . bidi-category-l) ;; 
	 (?\x123C . bidi-category-l) ;; 
	 (?\x123D . bidi-category-l) ;; 
	 (?\x123E . bidi-category-l) ;; 
	 (?\x123F . bidi-category-l) ;; 
	 (?\x1240 . bidi-category-l) ;; 
	 (?\x1241 . bidi-category-l) ;; 
	 (?\x1242 . bidi-category-l) ;; 
	 (?\x1243 . bidi-category-l) ;; 
	 (?\x1244 . bidi-category-l) ;; 
	 (?\x1245 . bidi-category-l) ;; 
	 (?\x1246 . bidi-category-l) ;; 
	 (?\x1248 . bidi-category-l) ;; 
	 (?\x124A . bidi-category-l) ;; 
	 (?\x124B . bidi-category-l) ;; 
	 (?\x124C . bidi-category-l) ;; 
	 (?\x124D . bidi-category-l) ;; 
	 (?\x1250 . bidi-category-l) ;; 
	 (?\x1251 . bidi-category-l) ;; 
	 (?\x1252 . bidi-category-l) ;; 
	 (?\x1253 . bidi-category-l) ;; 
	 (?\x1254 . bidi-category-l) ;; 
	 (?\x1255 . bidi-category-l) ;; 
	 (?\x1256 . bidi-category-l) ;; 
	 (?\x1258 . bidi-category-l) ;; 
	 (?\x125A . bidi-category-l) ;; 
	 (?\x125B . bidi-category-l) ;; 
	 (?\x125C . bidi-category-l) ;; 
	 (?\x125D . bidi-category-l) ;; 
	 (?\x1260 . bidi-category-l) ;; 
	 (?\x1261 . bidi-category-l) ;; 
	 (?\x1262 . bidi-category-l) ;; 
	 (?\x1263 . bidi-category-l) ;; 
	 (?\x1264 . bidi-category-l) ;; 
	 (?\x1265 . bidi-category-l) ;; 
	 (?\x1266 . bidi-category-l) ;; 
	 (?\x1267 . bidi-category-l) ;; 
	 (?\x1268 . bidi-category-l) ;; 
	 (?\x1269 . bidi-category-l) ;; 
	 (?\x126A . bidi-category-l) ;; 
	 (?\x126B . bidi-category-l) ;; 
	 (?\x126C . bidi-category-l) ;; 
	 (?\x126D . bidi-category-l) ;; 
	 (?\x126E . bidi-category-l) ;; 
	 (?\x126F . bidi-category-l) ;; 
	 (?\x1270 . bidi-category-l) ;; 
	 (?\x1271 . bidi-category-l) ;; 
	 (?\x1272 . bidi-category-l) ;; 
	 (?\x1273 . bidi-category-l) ;; 
	 (?\x1274 . bidi-category-l) ;; 
	 (?\x1275 . bidi-category-l) ;; 
	 (?\x1276 . bidi-category-l) ;; 
	 (?\x1277 . bidi-category-l) ;; 
	 (?\x1278 . bidi-category-l) ;; 
	 (?\x1279 . bidi-category-l) ;; 
	 (?\x127A . bidi-category-l) ;; 
	 (?\x127B . bidi-category-l) ;; 
	 (?\x127C . bidi-category-l) ;; 
	 (?\x127D . bidi-category-l) ;; 
	 (?\x127E . bidi-category-l) ;; 
	 (?\x127F . bidi-category-l) ;; 
	 (?\x1280 . bidi-category-l) ;; 
	 (?\x1281 . bidi-category-l) ;; 
	 (?\x1282 . bidi-category-l) ;; 
	 (?\x1283 . bidi-category-l) ;; 
	 (?\x1284 . bidi-category-l) ;; 
	 (?\x1285 . bidi-category-l) ;; 
	 (?\x1286 . bidi-category-l) ;; 
	 (?\x1288 . bidi-category-l) ;; 
	 (?\x128A . bidi-category-l) ;; 
	 (?\x128B . bidi-category-l) ;; 
	 (?\x128C . bidi-category-l) ;; 
	 (?\x128D . bidi-category-l) ;; 
	 (?\x1290 . bidi-category-l) ;; 
	 (?\x1291 . bidi-category-l) ;; 
	 (?\x1292 . bidi-category-l) ;; 
	 (?\x1293 . bidi-category-l) ;; 
	 (?\x1294 . bidi-category-l) ;; 
	 (?\x1295 . bidi-category-l) ;; 
	 (?\x1296 . bidi-category-l) ;; 
	 (?\x1297 . bidi-category-l) ;; 
	 (?\x1298 . bidi-category-l) ;; 
	 (?\x1299 . bidi-category-l) ;; 
	 (?\x129A . bidi-category-l) ;; 
	 (?\x129B . bidi-category-l) ;; 
	 (?\x129C . bidi-category-l) ;; 
	 (?\x129D . bidi-category-l) ;; 
	 (?\x129E . bidi-category-l) ;; 
	 (?\x129F . bidi-category-l) ;; 
	 (?\x12A0 . bidi-category-l) ;; 
	 (?\x12A1 . bidi-category-l) ;; 
	 (?\x12A2 . bidi-category-l) ;; 
	 (?\x12A3 . bidi-category-l) ;; 
	 (?\x12A4 . bidi-category-l) ;; 
	 (?\x12A5 . bidi-category-l) ;; 
	 (?\x12A6 . bidi-category-l) ;; 
	 (?\x12A7 . bidi-category-l) ;; 
	 (?\x12A8 . bidi-category-l) ;; 
	 (?\x12A9 . bidi-category-l) ;; 
	 (?\x12AA . bidi-category-l) ;; 
	 (?\x12AB . bidi-category-l) ;; 
	 (?\x12AC . bidi-category-l) ;; 
	 (?\x12AD . bidi-category-l) ;; 
	 (?\x12AE . bidi-category-l) ;; 
	 (?\x12B0 . bidi-category-l) ;; 
	 (?\x12B2 . bidi-category-l) ;; 
	 (?\x12B3 . bidi-category-l) ;; 
	 (?\x12B4 . bidi-category-l) ;; 
	 (?\x12B5 . bidi-category-l) ;; 
	 (?\x12B8 . bidi-category-l) ;; 
	 (?\x12B9 . bidi-category-l) ;; 
	 (?\x12BA . bidi-category-l) ;; 
	 (?\x12BB . bidi-category-l) ;; 
	 (?\x12BC . bidi-category-l) ;; 
	 (?\x12BD . bidi-category-l) ;; 
	 (?\x12BE . bidi-category-l) ;; 
	 (?\x12C0 . bidi-category-l) ;; 
	 (?\x12C2 . bidi-category-l) ;; 
	 (?\x12C3 . bidi-category-l) ;; 
	 (?\x12C4 . bidi-category-l) ;; 
	 (?\x12C5 . bidi-category-l) ;; 
	 (?\x12C8 . bidi-category-l) ;; 
	 (?\x12C9 . bidi-category-l) ;; 
	 (?\x12CA . bidi-category-l) ;; 
	 (?\x12CB . bidi-category-l) ;; 
	 (?\x12CC . bidi-category-l) ;; 
	 (?\x12CD . bidi-category-l) ;; 
	 (?\x12CE . bidi-category-l) ;; 
	 (?\x12D0 . bidi-category-l) ;; 
	 (?\x12D1 . bidi-category-l) ;; 
	 (?\x12D2 . bidi-category-l) ;; 
	 (?\x12D3 . bidi-category-l) ;; 
	 (?\x12D4 . bidi-category-l) ;; 
	 (?\x12D5 . bidi-category-l) ;; 
	 (?\x12D6 . bidi-category-l) ;; 
	 (?\x12D8 . bidi-category-l) ;; 
	 (?\x12D9 . bidi-category-l) ;; 
	 (?\x12DA . bidi-category-l) ;; 
	 (?\x12DB . bidi-category-l) ;; 
	 (?\x12DC . bidi-category-l) ;; 
	 (?\x12DD . bidi-category-l) ;; 
	 (?\x12DE . bidi-category-l) ;; 
	 (?\x12DF . bidi-category-l) ;; 
	 (?\x12E0 . bidi-category-l) ;; 
	 (?\x12E1 . bidi-category-l) ;; 
	 (?\x12E2 . bidi-category-l) ;; 
	 (?\x12E3 . bidi-category-l) ;; 
	 (?\x12E4 . bidi-category-l) ;; 
	 (?\x12E5 . bidi-category-l) ;; 
	 (?\x12E6 . bidi-category-l) ;; 
	 (?\x12E7 . bidi-category-l) ;; 
	 (?\x12E8 . bidi-category-l) ;; 
	 (?\x12E9 . bidi-category-l) ;; 
	 (?\x12EA . bidi-category-l) ;; 
	 (?\x12EB . bidi-category-l) ;; 
	 (?\x12EC . bidi-category-l) ;; 
	 (?\x12ED . bidi-category-l) ;; 
	 (?\x12EE . bidi-category-l) ;; 
	 (?\x12F0 . bidi-category-l) ;; 
	 (?\x12F1 . bidi-category-l) ;; 
	 (?\x12F2 . bidi-category-l) ;; 
	 (?\x12F3 . bidi-category-l) ;; 
	 (?\x12F4 . bidi-category-l) ;; 
	 (?\x12F5 . bidi-category-l) ;; 
	 (?\x12F6 . bidi-category-l) ;; 
	 (?\x12F7 . bidi-category-l) ;; 
	 (?\x12F8 . bidi-category-l) ;; 
	 (?\x12F9 . bidi-category-l) ;; 
	 (?\x12FA . bidi-category-l) ;; 
	 (?\x12FB . bidi-category-l) ;; 
	 (?\x12FC . bidi-category-l) ;; 
	 (?\x12FD . bidi-category-l) ;; 
	 (?\x12FE . bidi-category-l) ;; 
	 (?\x12FF . bidi-category-l) ;; 
	 (?\x1300 . bidi-category-l) ;; 
	 (?\x1301 . bidi-category-l) ;; 
	 (?\x1302 . bidi-category-l) ;; 
	 (?\x1303 . bidi-category-l) ;; 
	 (?\x1304 . bidi-category-l) ;; 
	 (?\x1305 . bidi-category-l) ;; 
	 (?\x1306 . bidi-category-l) ;; 
	 (?\x1307 . bidi-category-l) ;; 
	 (?\x1308 . bidi-category-l) ;; 
	 (?\x1309 . bidi-category-l) ;; 
	 (?\x130A . bidi-category-l) ;; 
	 (?\x130B . bidi-category-l) ;; 
	 (?\x130C . bidi-category-l) ;; 
	 (?\x130D . bidi-category-l) ;; 
	 (?\x130E . bidi-category-l) ;; 
	 (?\x1310 . bidi-category-l) ;; 
	 (?\x1312 . bidi-category-l) ;; 
	 (?\x1313 . bidi-category-l) ;; 
	 (?\x1314 . bidi-category-l) ;; 
	 (?\x1315 . bidi-category-l) ;; 
	 (?\x1318 . bidi-category-l) ;; 
	 (?\x1319 . bidi-category-l) ;; 
	 (?\x131A . bidi-category-l) ;; 
	 (?\x131B . bidi-category-l) ;; 
	 (?\x131C . bidi-category-l) ;; 
	 (?\x131D . bidi-category-l) ;; 
	 (?\x131E . bidi-category-l) ;; 
	 (?\x1320 . bidi-category-l) ;; 
	 (?\x1321 . bidi-category-l) ;; 
	 (?\x1322 . bidi-category-l) ;; 
	 (?\x1323 . bidi-category-l) ;; 
	 (?\x1324 . bidi-category-l) ;; 
	 (?\x1325 . bidi-category-l) ;; 
	 (?\x1326 . bidi-category-l) ;; 
	 (?\x1327 . bidi-category-l) ;; 
	 (?\x1328 . bidi-category-l) ;; 
	 (?\x1329 . bidi-category-l) ;; 
	 (?\x132A . bidi-category-l) ;; 
	 (?\x132B . bidi-category-l) ;; 
	 (?\x132C . bidi-category-l) ;; 
	 (?\x132D . bidi-category-l) ;; 
	 (?\x132E . bidi-category-l) ;; 
	 (?\x132F . bidi-category-l) ;; 
	 (?\x1330 . bidi-category-l) ;; 
	 (?\x1331 . bidi-category-l) ;; 
	 (?\x1332 . bidi-category-l) ;; 
	 (?\x1333 . bidi-category-l) ;; 
	 (?\x1334 . bidi-category-l) ;; 
	 (?\x1335 . bidi-category-l) ;; 
	 (?\x1336 . bidi-category-l) ;; 
	 (?\x1337 . bidi-category-l) ;; 
	 (?\x1338 . bidi-category-l) ;; 
	 (?\x1339 . bidi-category-l) ;; 
	 (?\x133A . bidi-category-l) ;; 
	 (?\x133B . bidi-category-l) ;; 
	 (?\x133C . bidi-category-l) ;; 
	 (?\x133D . bidi-category-l) ;; 
	 (?\x133E . bidi-category-l) ;; 
	 (?\x133F . bidi-category-l) ;; 
	 (?\x1340 . bidi-category-l) ;; 
	 (?\x1341 . bidi-category-l) ;; 
	 (?\x1342 . bidi-category-l) ;; 
	 (?\x1343 . bidi-category-l) ;; 
	 (?\x1344 . bidi-category-l) ;; 
	 (?\x1345 . bidi-category-l) ;; 
	 (?\x1346 . bidi-category-l) ;; 
	 (?\x1348 . bidi-category-l) ;; 
	 (?\x1349 . bidi-category-l) ;; 
	 (?\x134A . bidi-category-l) ;; 
	 (?\x134B . bidi-category-l) ;; 
	 (?\x134C . bidi-category-l) ;; 
	 (?\x134D . bidi-category-l) ;; 
	 (?\x134E . bidi-category-l) ;; 
	 (?\x134F . bidi-category-l) ;; 
	 (?\x1350 . bidi-category-l) ;; 
	 (?\x1351 . bidi-category-l) ;; 
	 (?\x1352 . bidi-category-l) ;; 
	 (?\x1353 . bidi-category-l) ;; 
	 (?\x1354 . bidi-category-l) ;; 
	 (?\x1355 . bidi-category-l) ;; 
	 (?\x1356 . bidi-category-l) ;; 
	 (?\x1357 . bidi-category-l) ;; 
	 (?\x1358 . bidi-category-l) ;; 
	 (?\x1359 . bidi-category-l) ;; 
	 (?\x135A . bidi-category-l) ;; 
	 (?\x1361 . bidi-category-l) ;; 
	 (?\x1362 . bidi-category-l) ;; 
	 (?\x1363 . bidi-category-l) ;; 
	 (?\x1364 . bidi-category-l) ;; 
	 (?\x1365 . bidi-category-l) ;; 
	 (?\x1366 . bidi-category-l) ;; 
	 (?\x1367 . bidi-category-l) ;; 
	 (?\x1368 . bidi-category-l) ;; 
	 (?\x1369 . bidi-category-l) ;; 
	 (?\x136A . bidi-category-l) ;; 
	 (?\x136B . bidi-category-l) ;; 
	 (?\x136C . bidi-category-l) ;; 
	 (?\x136D . bidi-category-l) ;; 
	 (?\x136E . bidi-category-l) ;; 
	 (?\x136F . bidi-category-l) ;; 
	 (?\x1370 . bidi-category-l) ;; 
	 (?\x1371 . bidi-category-l) ;; 
	 (?\x1372 . bidi-category-l) ;; 
	 (?\x1373 . bidi-category-l) ;; 
	 (?\x1374 . bidi-category-l) ;; 
	 (?\x1375 . bidi-category-l) ;; 
	 (?\x1376 . bidi-category-l) ;; 
	 (?\x1377 . bidi-category-l) ;; 
	 (?\x1378 . bidi-category-l) ;; 
	 (?\x1379 . bidi-category-l) ;; 
	 (?\x137A . bidi-category-l) ;; 
	 (?\x137B . bidi-category-l) ;; 
	 (?\x137C . bidi-category-l) ;; 
	 (?\x13A0 . bidi-category-l) ;; 
	 (?\x13A1 . bidi-category-l) ;; 
	 (?\x13A2 . bidi-category-l) ;; 
	 (?\x13A3 . bidi-category-l) ;; 
	 (?\x13A4 . bidi-category-l) ;; 
	 (?\x13A5 . bidi-category-l) ;; 
	 (?\x13A6 . bidi-category-l) ;; 
	 (?\x13A7 . bidi-category-l) ;; 
	 (?\x13A8 . bidi-category-l) ;; 
	 (?\x13A9 . bidi-category-l) ;; 
	 (?\x13AA . bidi-category-l) ;; 
	 (?\x13AB . bidi-category-l) ;; 
	 (?\x13AC . bidi-category-l) ;; 
	 (?\x13AD . bidi-category-l) ;; 
	 (?\x13AE . bidi-category-l) ;; 
	 (?\x13AF . bidi-category-l) ;; 
	 (?\x13B0 . bidi-category-l) ;; 
	 (?\x13B1 . bidi-category-l) ;; 
	 (?\x13B2 . bidi-category-l) ;; 
	 (?\x13B3 . bidi-category-l) ;; 
	 (?\x13B4 . bidi-category-l) ;; 
	 (?\x13B5 . bidi-category-l) ;; 
	 (?\x13B6 . bidi-category-l) ;; 
	 (?\x13B7 . bidi-category-l) ;; 
	 (?\x13B8 . bidi-category-l) ;; 
	 (?\x13B9 . bidi-category-l) ;; 
	 (?\x13BA . bidi-category-l) ;; 
	 (?\x13BB . bidi-category-l) ;; 
	 (?\x13BC . bidi-category-l) ;; 
	 (?\x13BD . bidi-category-l) ;; 
	 (?\x13BE . bidi-category-l) ;; 
	 (?\x13BF . bidi-category-l) ;; 
	 (?\x13C0 . bidi-category-l) ;; 
	 (?\x13C1 . bidi-category-l) ;; 
	 (?\x13C2 . bidi-category-l) ;; 
	 (?\x13C3 . bidi-category-l) ;; 
	 (?\x13C4 . bidi-category-l) ;; 
	 (?\x13C5 . bidi-category-l) ;; 
	 (?\x13C6 . bidi-category-l) ;; 
	 (?\x13C7 . bidi-category-l) ;; 
	 (?\x13C8 . bidi-category-l) ;; 
	 (?\x13C9 . bidi-category-l) ;; 
	 (?\x13CA . bidi-category-l) ;; 
	 (?\x13CB . bidi-category-l) ;; 
	 (?\x13CC . bidi-category-l) ;; 
	 (?\x13CD . bidi-category-l) ;; 
	 (?\x13CE . bidi-category-l) ;; 
	 (?\x13CF . bidi-category-l) ;; 
	 (?\x13D0 . bidi-category-l) ;; 
	 (?\x13D1 . bidi-category-l) ;; 
	 (?\x13D2 . bidi-category-l) ;; 
	 (?\x13D3 . bidi-category-l) ;; 
	 (?\x13D4 . bidi-category-l) ;; 
	 (?\x13D5 . bidi-category-l) ;; 
	 (?\x13D6 . bidi-category-l) ;; 
	 (?\x13D7 . bidi-category-l) ;; 
	 (?\x13D8 . bidi-category-l) ;; 
	 (?\x13D9 . bidi-category-l) ;; 
	 (?\x13DA . bidi-category-l) ;; 
	 (?\x13DB . bidi-category-l) ;; 
	 (?\x13DC . bidi-category-l) ;; 
	 (?\x13DD . bidi-category-l) ;; 
	 (?\x13DE . bidi-category-l) ;; 
	 (?\x13DF . bidi-category-l) ;; 
	 (?\x13E0 . bidi-category-l) ;; 
	 (?\x13E1 . bidi-category-l) ;; 
	 (?\x13E2 . bidi-category-l) ;; 
	 (?\x13E3 . bidi-category-l) ;; 
	 (?\x13E4 . bidi-category-l) ;; 
	 (?\x13E5 . bidi-category-l) ;; 
	 (?\x13E6 . bidi-category-l) ;; 
	 (?\x13E7 . bidi-category-l) ;; 
	 (?\x13E8 . bidi-category-l) ;; 
	 (?\x13E9 . bidi-category-l) ;; 
	 (?\x13EA . bidi-category-l) ;; 
	 (?\x13EB . bidi-category-l) ;; 
	 (?\x13EC . bidi-category-l) ;; 
	 (?\x13ED . bidi-category-l) ;; 
	 (?\x13EE . bidi-category-l) ;; 
	 (?\x13EF . bidi-category-l) ;; 
	 (?\x13F0 . bidi-category-l) ;; 
	 (?\x13F1 . bidi-category-l) ;; 
	 (?\x13F2 . bidi-category-l) ;; 
	 (?\x13F3 . bidi-category-l) ;; 
	 (?\x13F4 . bidi-category-l) ;; 
	 (?\x1401 . bidi-category-l) ;; 
	 (?\x1402 . bidi-category-l) ;; 
	 (?\x1403 . bidi-category-l) ;; 
	 (?\x1404 . bidi-category-l) ;; 
	 (?\x1405 . bidi-category-l) ;; 
	 (?\x1406 . bidi-category-l) ;; 
	 (?\x1407 . bidi-category-l) ;; 
	 (?\x1408 . bidi-category-l) ;; 
	 (?\x1409 . bidi-category-l) ;; 
	 (?\x140A . bidi-category-l) ;; 
	 (?\x140B . bidi-category-l) ;; 
	 (?\x140C . bidi-category-l) ;; 
	 (?\x140D . bidi-category-l) ;; 
	 (?\x140E . bidi-category-l) ;; 
	 (?\x140F . bidi-category-l) ;; 
	 (?\x1410 . bidi-category-l) ;; 
	 (?\x1411 . bidi-category-l) ;; 
	 (?\x1412 . bidi-category-l) ;; 
	 (?\x1413 . bidi-category-l) ;; 
	 (?\x1414 . bidi-category-l) ;; 
	 (?\x1415 . bidi-category-l) ;; 
	 (?\x1416 . bidi-category-l) ;; 
	 (?\x1417 . bidi-category-l) ;; 
	 (?\x1418 . bidi-category-l) ;; 
	 (?\x1419 . bidi-category-l) ;; 
	 (?\x141A . bidi-category-l) ;; 
	 (?\x141B . bidi-category-l) ;; 
	 (?\x141C . bidi-category-l) ;; 
	 (?\x141D . bidi-category-l) ;; 
	 (?\x141E . bidi-category-l) ;; 
	 (?\x141F . bidi-category-l) ;; 
	 (?\x1420 . bidi-category-l) ;; 
	 (?\x1421 . bidi-category-l) ;; 
	 (?\x1422 . bidi-category-l) ;; 
	 (?\x1423 . bidi-category-l) ;; 
	 (?\x1424 . bidi-category-l) ;; 
	 (?\x1425 . bidi-category-l) ;; 
	 (?\x1426 . bidi-category-l) ;; 
	 (?\x1427 . bidi-category-l) ;; 
	 (?\x1428 . bidi-category-l) ;; 
	 (?\x1429 . bidi-category-l) ;; 
	 (?\x142A . bidi-category-l) ;; 
	 (?\x142B . bidi-category-l) ;; 
	 (?\x142C . bidi-category-l) ;; 
	 (?\x142D . bidi-category-l) ;; 
	 (?\x142E . bidi-category-l) ;; 
	 (?\x142F . bidi-category-l) ;; 
	 (?\x1430 . bidi-category-l) ;; 
	 (?\x1431 . bidi-category-l) ;; 
	 (?\x1432 . bidi-category-l) ;; 
	 (?\x1433 . bidi-category-l) ;; 
	 (?\x1434 . bidi-category-l) ;; 
	 (?\x1435 . bidi-category-l) ;; 
	 (?\x1436 . bidi-category-l) ;; 
	 (?\x1437 . bidi-category-l) ;; 
	 (?\x1438 . bidi-category-l) ;; 
	 (?\x1439 . bidi-category-l) ;; 
	 (?\x143A . bidi-category-l) ;; 
	 (?\x143B . bidi-category-l) ;; 
	 (?\x143C . bidi-category-l) ;; 
	 (?\x143D . bidi-category-l) ;; 
	 (?\x143E . bidi-category-l) ;; 
	 (?\x143F . bidi-category-l) ;; 
	 (?\x1440 . bidi-category-l) ;; 
	 (?\x1441 . bidi-category-l) ;; 
	 (?\x1442 . bidi-category-l) ;; 
	 (?\x1443 . bidi-category-l) ;; 
	 (?\x1444 . bidi-category-l) ;; 
	 (?\x1445 . bidi-category-l) ;; 
	 (?\x1446 . bidi-category-l) ;; 
	 (?\x1447 . bidi-category-l) ;; 
	 (?\x1448 . bidi-category-l) ;; 
	 (?\x1449 . bidi-category-l) ;; 
	 (?\x144A . bidi-category-l) ;; 
	 (?\x144B . bidi-category-l) ;; 
	 (?\x144C . bidi-category-l) ;; 
	 (?\x144D . bidi-category-l) ;; 
	 (?\x144E . bidi-category-l) ;; 
	 (?\x144F . bidi-category-l) ;; 
	 (?\x1450 . bidi-category-l) ;; 
	 (?\x1451 . bidi-category-l) ;; 
	 (?\x1452 . bidi-category-l) ;; 
	 (?\x1453 . bidi-category-l) ;; 
	 (?\x1454 . bidi-category-l) ;; 
	 (?\x1455 . bidi-category-l) ;; 
	 (?\x1456 . bidi-category-l) ;; 
	 (?\x1457 . bidi-category-l) ;; 
	 (?\x1458 . bidi-category-l) ;; 
	 (?\x1459 . bidi-category-l) ;; 
	 (?\x145A . bidi-category-l) ;; 
	 (?\x145B . bidi-category-l) ;; 
	 (?\x145C . bidi-category-l) ;; 
	 (?\x145D . bidi-category-l) ;; 
	 (?\x145E . bidi-category-l) ;; 
	 (?\x145F . bidi-category-l) ;; 
	 (?\x1460 . bidi-category-l) ;; 
	 (?\x1461 . bidi-category-l) ;; 
	 (?\x1462 . bidi-category-l) ;; 
	 (?\x1463 . bidi-category-l) ;; 
	 (?\x1464 . bidi-category-l) ;; 
	 (?\x1465 . bidi-category-l) ;; 
	 (?\x1466 . bidi-category-l) ;; 
	 (?\x1467 . bidi-category-l) ;; 
	 (?\x1468 . bidi-category-l) ;; 
	 (?\x1469 . bidi-category-l) ;; 
	 (?\x146A . bidi-category-l) ;; 
	 (?\x146B . bidi-category-l) ;; 
	 (?\x146C . bidi-category-l) ;; 
	 (?\x146D . bidi-category-l) ;; 
	 (?\x146E . bidi-category-l) ;; 
	 (?\x146F . bidi-category-l) ;; 
	 (?\x1470 . bidi-category-l) ;; 
	 (?\x1471 . bidi-category-l) ;; 
	 (?\x1472 . bidi-category-l) ;; 
	 (?\x1473 . bidi-category-l) ;; 
	 (?\x1474 . bidi-category-l) ;; 
	 (?\x1475 . bidi-category-l) ;; 
	 (?\x1476 . bidi-category-l) ;; 
	 (?\x1477 . bidi-category-l) ;; 
	 (?\x1478 . bidi-category-l) ;; 
	 (?\x1479 . bidi-category-l) ;; 
	 (?\x147A . bidi-category-l) ;; 
	 (?\x147B . bidi-category-l) ;; 
	 (?\x147C . bidi-category-l) ;; 
	 (?\x147D . bidi-category-l) ;; 
	 (?\x147E . bidi-category-l) ;; 
	 (?\x147F . bidi-category-l) ;; 
	 (?\x1480 . bidi-category-l) ;; 
	 (?\x1481 . bidi-category-l) ;; 
	 (?\x1482 . bidi-category-l) ;; 
	 (?\x1483 . bidi-category-l) ;; 
	 (?\x1484 . bidi-category-l) ;; 
	 (?\x1485 . bidi-category-l) ;; 
	 (?\x1486 . bidi-category-l) ;; 
	 (?\x1487 . bidi-category-l) ;; 
	 (?\x1488 . bidi-category-l) ;; 
	 (?\x1489 . bidi-category-l) ;; 
	 (?\x148A . bidi-category-l) ;; 
	 (?\x148B . bidi-category-l) ;; 
	 (?\x148C . bidi-category-l) ;; 
	 (?\x148D . bidi-category-l) ;; 
	 (?\x148E . bidi-category-l) ;; 
	 (?\x148F . bidi-category-l) ;; 
	 (?\x1490 . bidi-category-l) ;; 
	 (?\x1491 . bidi-category-l) ;; 
	 (?\x1492 . bidi-category-l) ;; 
	 (?\x1493 . bidi-category-l) ;; 
	 (?\x1494 . bidi-category-l) ;; 
	 (?\x1495 . bidi-category-l) ;; 
	 (?\x1496 . bidi-category-l) ;; 
	 (?\x1497 . bidi-category-l) ;; 
	 (?\x1498 . bidi-category-l) ;; 
	 (?\x1499 . bidi-category-l) ;; 
	 (?\x149A . bidi-category-l) ;; 
	 (?\x149B . bidi-category-l) ;; 
	 (?\x149C . bidi-category-l) ;; 
	 (?\x149D . bidi-category-l) ;; 
	 (?\x149E . bidi-category-l) ;; 
	 (?\x149F . bidi-category-l) ;; 
	 (?\x14A0 . bidi-category-l) ;; 
	 (?\x14A1 . bidi-category-l) ;; 
	 (?\x14A2 . bidi-category-l) ;; 
	 (?\x14A3 . bidi-category-l) ;; 
	 (?\x14A4 . bidi-category-l) ;; 
	 (?\x14A5 . bidi-category-l) ;; 
	 (?\x14A6 . bidi-category-l) ;; 
	 (?\x14A7 . bidi-category-l) ;; 
	 (?\x14A8 . bidi-category-l) ;; 
	 (?\x14A9 . bidi-category-l) ;; 
	 (?\x14AA . bidi-category-l) ;; 
	 (?\x14AB . bidi-category-l) ;; 
	 (?\x14AC . bidi-category-l) ;; 
	 (?\x14AD . bidi-category-l) ;; 
	 (?\x14AE . bidi-category-l) ;; 
	 (?\x14AF . bidi-category-l) ;; 
	 (?\x14B0 . bidi-category-l) ;; 
	 (?\x14B1 . bidi-category-l) ;; 
	 (?\x14B2 . bidi-category-l) ;; 
	 (?\x14B3 . bidi-category-l) ;; 
	 (?\x14B4 . bidi-category-l) ;; 
	 (?\x14B5 . bidi-category-l) ;; 
	 (?\x14B6 . bidi-category-l) ;; 
	 (?\x14B7 . bidi-category-l) ;; 
	 (?\x14B8 . bidi-category-l) ;; 
	 (?\x14B9 . bidi-category-l) ;; 
	 (?\x14BA . bidi-category-l) ;; 
	 (?\x14BB . bidi-category-l) ;; 
	 (?\x14BC . bidi-category-l) ;; 
	 (?\x14BD . bidi-category-l) ;; 
	 (?\x14BE . bidi-category-l) ;; 
	 (?\x14BF . bidi-category-l) ;; 
	 (?\x14C0 . bidi-category-l) ;; 
	 (?\x14C1 . bidi-category-l) ;; 
	 (?\x14C2 . bidi-category-l) ;; 
	 (?\x14C3 . bidi-category-l) ;; 
	 (?\x14C4 . bidi-category-l) ;; 
	 (?\x14C5 . bidi-category-l) ;; 
	 (?\x14C6 . bidi-category-l) ;; 
	 (?\x14C7 . bidi-category-l) ;; 
	 (?\x14C8 . bidi-category-l) ;; 
	 (?\x14C9 . bidi-category-l) ;; 
	 (?\x14CA . bidi-category-l) ;; 
	 (?\x14CB . bidi-category-l) ;; 
	 (?\x14CC . bidi-category-l) ;; 
	 (?\x14CD . bidi-category-l) ;; 
	 (?\x14CE . bidi-category-l) ;; 
	 (?\x14CF . bidi-category-l) ;; 
	 (?\x14D0 . bidi-category-l) ;; 
	 (?\x14D1 . bidi-category-l) ;; 
	 (?\x14D2 . bidi-category-l) ;; 
	 (?\x14D3 . bidi-category-l) ;; 
	 (?\x14D4 . bidi-category-l) ;; 
	 (?\x14D5 . bidi-category-l) ;; 
	 (?\x14D6 . bidi-category-l) ;; 
	 (?\x14D7 . bidi-category-l) ;; 
	 (?\x14D8 . bidi-category-l) ;; 
	 (?\x14D9 . bidi-category-l) ;; 
	 (?\x14DA . bidi-category-l) ;; 
	 (?\x14DB . bidi-category-l) ;; 
	 (?\x14DC . bidi-category-l) ;; 
	 (?\x14DD . bidi-category-l) ;; 
	 (?\x14DE . bidi-category-l) ;; 
	 (?\x14DF . bidi-category-l) ;; 
	 (?\x14E0 . bidi-category-l) ;; 
	 (?\x14E1 . bidi-category-l) ;; 
	 (?\x14E2 . bidi-category-l) ;; 
	 (?\x14E3 . bidi-category-l) ;; 
	 (?\x14E4 . bidi-category-l) ;; 
	 (?\x14E5 . bidi-category-l) ;; 
	 (?\x14E6 . bidi-category-l) ;; 
	 (?\x14E7 . bidi-category-l) ;; 
	 (?\x14E8 . bidi-category-l) ;; 
	 (?\x14E9 . bidi-category-l) ;; 
	 (?\x14EA . bidi-category-l) ;; 
	 (?\x14EB . bidi-category-l) ;; 
	 (?\x14EC . bidi-category-l) ;; 
	 (?\x14ED . bidi-category-l) ;; 
	 (?\x14EE . bidi-category-l) ;; 
	 (?\x14EF . bidi-category-l) ;; 
	 (?\x14F0 . bidi-category-l) ;; 
	 (?\x14F1 . bidi-category-l) ;; 
	 (?\x14F2 . bidi-category-l) ;; 
	 (?\x14F3 . bidi-category-l) ;; 
	 (?\x14F4 . bidi-category-l) ;; 
	 (?\x14F5 . bidi-category-l) ;; 
	 (?\x14F6 . bidi-category-l) ;; 
	 (?\x14F7 . bidi-category-l) ;; 
	 (?\x14F8 . bidi-category-l) ;; 
	 (?\x14F9 . bidi-category-l) ;; 
	 (?\x14FA . bidi-category-l) ;; 
	 (?\x14FB . bidi-category-l) ;; 
	 (?\x14FC . bidi-category-l) ;; 
	 (?\x14FD . bidi-category-l) ;; 
	 (?\x14FE . bidi-category-l) ;; 
	 (?\x14FF . bidi-category-l) ;; 
	 (?\x1500 . bidi-category-l) ;; 
	 (?\x1501 . bidi-category-l) ;; 
	 (?\x1502 . bidi-category-l) ;; 
	 (?\x1503 . bidi-category-l) ;; 
	 (?\x1504 . bidi-category-l) ;; 
	 (?\x1505 . bidi-category-l) ;; 
	 (?\x1506 . bidi-category-l) ;; 
	 (?\x1507 . bidi-category-l) ;; 
	 (?\x1508 . bidi-category-l) ;; 
	 (?\x1509 . bidi-category-l) ;; 
	 (?\x150A . bidi-category-l) ;; 
	 (?\x150B . bidi-category-l) ;; 
	 (?\x150C . bidi-category-l) ;; 
	 (?\x150D . bidi-category-l) ;; 
	 (?\x150E . bidi-category-l) ;; 
	 (?\x150F . bidi-category-l) ;; 
	 (?\x1510 . bidi-category-l) ;; 
	 (?\x1511 . bidi-category-l) ;; 
	 (?\x1512 . bidi-category-l) ;; 
	 (?\x1513 . bidi-category-l) ;; 
	 (?\x1514 . bidi-category-l) ;; 
	 (?\x1515 . bidi-category-l) ;; 
	 (?\x1516 . bidi-category-l) ;; 
	 (?\x1517 . bidi-category-l) ;; 
	 (?\x1518 . bidi-category-l) ;; 
	 (?\x1519 . bidi-category-l) ;; 
	 (?\x151A . bidi-category-l) ;; 
	 (?\x151B . bidi-category-l) ;; 
	 (?\x151C . bidi-category-l) ;; 
	 (?\x151D . bidi-category-l) ;; 
	 (?\x151E . bidi-category-l) ;; 
	 (?\x151F . bidi-category-l) ;; 
	 (?\x1520 . bidi-category-l) ;; 
	 (?\x1521 . bidi-category-l) ;; 
	 (?\x1522 . bidi-category-l) ;; 
	 (?\x1523 . bidi-category-l) ;; 
	 (?\x1524 . bidi-category-l) ;; 
	 (?\x1525 . bidi-category-l) ;; 
	 (?\x1526 . bidi-category-l) ;; 
	 (?\x1527 . bidi-category-l) ;; 
	 (?\x1528 . bidi-category-l) ;; 
	 (?\x1529 . bidi-category-l) ;; 
	 (?\x152A . bidi-category-l) ;; 
	 (?\x152B . bidi-category-l) ;; 
	 (?\x152C . bidi-category-l) ;; 
	 (?\x152D . bidi-category-l) ;; 
	 (?\x152E . bidi-category-l) ;; 
	 (?\x152F . bidi-category-l) ;; 
	 (?\x1530 . bidi-category-l) ;; 
	 (?\x1531 . bidi-category-l) ;; 
	 (?\x1532 . bidi-category-l) ;; 
	 (?\x1533 . bidi-category-l) ;; 
	 (?\x1534 . bidi-category-l) ;; 
	 (?\x1535 . bidi-category-l) ;; 
	 (?\x1536 . bidi-category-l) ;; 
	 (?\x1537 . bidi-category-l) ;; 
	 (?\x1538 . bidi-category-l) ;; 
	 (?\x1539 . bidi-category-l) ;; 
	 (?\x153A . bidi-category-l) ;; 
	 (?\x153B . bidi-category-l) ;; 
	 (?\x153C . bidi-category-l) ;; 
	 (?\x153D . bidi-category-l) ;; 
	 (?\x153E . bidi-category-l) ;; 
	 (?\x153F . bidi-category-l) ;; 
	 (?\x1540 . bidi-category-l) ;; 
	 (?\x1541 . bidi-category-l) ;; 
	 (?\x1542 . bidi-category-l) ;; 
	 (?\x1543 . bidi-category-l) ;; 
	 (?\x1544 . bidi-category-l) ;; 
	 (?\x1545 . bidi-category-l) ;; 
	 (?\x1546 . bidi-category-l) ;; 
	 (?\x1547 . bidi-category-l) ;; 
	 (?\x1548 . bidi-category-l) ;; 
	 (?\x1549 . bidi-category-l) ;; 
	 (?\x154A . bidi-category-l) ;; 
	 (?\x154B . bidi-category-l) ;; 
	 (?\x154C . bidi-category-l) ;; 
	 (?\x154D . bidi-category-l) ;; 
	 (?\x154E . bidi-category-l) ;; 
	 (?\x154F . bidi-category-l) ;; 
	 (?\x1550 . bidi-category-l) ;; 
	 (?\x1551 . bidi-category-l) ;; 
	 (?\x1552 . bidi-category-l) ;; 
	 (?\x1553 . bidi-category-l) ;; 
	 (?\x1554 . bidi-category-l) ;; 
	 (?\x1555 . bidi-category-l) ;; 
	 (?\x1556 . bidi-category-l) ;; 
	 (?\x1557 . bidi-category-l) ;; 
	 (?\x1558 . bidi-category-l) ;; 
	 (?\x1559 . bidi-category-l) ;; 
	 (?\x155A . bidi-category-l) ;; 
	 (?\x155B . bidi-category-l) ;; 
	 (?\x155C . bidi-category-l) ;; 
	 (?\x155D . bidi-category-l) ;; 
	 (?\x155E . bidi-category-l) ;; 
	 (?\x155F . bidi-category-l) ;; 
	 (?\x1560 . bidi-category-l) ;; 
	 (?\x1561 . bidi-category-l) ;; 
	 (?\x1562 . bidi-category-l) ;; 
	 (?\x1563 . bidi-category-l) ;; 
	 (?\x1564 . bidi-category-l) ;; 
	 (?\x1565 . bidi-category-l) ;; 
	 (?\x1566 . bidi-category-l) ;; 
	 (?\x1567 . bidi-category-l) ;; 
	 (?\x1568 . bidi-category-l) ;; 
	 (?\x1569 . bidi-category-l) ;; 
	 (?\x156A . bidi-category-l) ;; 
	 (?\x156B . bidi-category-l) ;; 
	 (?\x156C . bidi-category-l) ;; 
	 (?\x156D . bidi-category-l) ;; 
	 (?\x156E . bidi-category-l) ;; 
	 (?\x156F . bidi-category-l) ;; 
	 (?\x1570 . bidi-category-l) ;; 
	 (?\x1571 . bidi-category-l) ;; 
	 (?\x1572 . bidi-category-l) ;; 
	 (?\x1573 . bidi-category-l) ;; 
	 (?\x1574 . bidi-category-l) ;; 
	 (?\x1575 . bidi-category-l) ;; 
	 (?\x1576 . bidi-category-l) ;; 
	 (?\x1577 . bidi-category-l) ;; 
	 (?\x1578 . bidi-category-l) ;; 
	 (?\x1579 . bidi-category-l) ;; 
	 (?\x157A . bidi-category-l) ;; 
	 (?\x157B . bidi-category-l) ;; 
	 (?\x157C . bidi-category-l) ;; 
	 (?\x157D . bidi-category-l) ;; 
	 (?\x157E . bidi-category-l) ;; 
	 (?\x157F . bidi-category-l) ;; 
	 (?\x1580 . bidi-category-l) ;; 
	 (?\x1581 . bidi-category-l) ;; 
	 (?\x1582 . bidi-category-l) ;; 
	 (?\x1583 . bidi-category-l) ;; 
	 (?\x1584 . bidi-category-l) ;; 
	 (?\x1585 . bidi-category-l) ;; 
	 (?\x1586 . bidi-category-l) ;; 
	 (?\x1587 . bidi-category-l) ;; 
	 (?\x1588 . bidi-category-l) ;; 
	 (?\x1589 . bidi-category-l) ;; 
	 (?\x158A . bidi-category-l) ;; 
	 (?\x158B . bidi-category-l) ;; 
	 (?\x158C . bidi-category-l) ;; 
	 (?\x158D . bidi-category-l) ;; 
	 (?\x158E . bidi-category-l) ;; 
	 (?\x158F . bidi-category-l) ;; 
	 (?\x1590 . bidi-category-l) ;; 
	 (?\x1591 . bidi-category-l) ;; 
	 (?\x1592 . bidi-category-l) ;; 
	 (?\x1593 . bidi-category-l) ;; 
	 (?\x1594 . bidi-category-l) ;; 
	 (?\x1595 . bidi-category-l) ;; 
	 (?\x1596 . bidi-category-l) ;; 
	 (?\x1597 . bidi-category-l) ;; 
	 (?\x1598 . bidi-category-l) ;; 
	 (?\x1599 . bidi-category-l) ;; 
	 (?\x159A . bidi-category-l) ;; 
	 (?\x159B . bidi-category-l) ;; 
	 (?\x159C . bidi-category-l) ;; 
	 (?\x159D . bidi-category-l) ;; 
	 (?\x159E . bidi-category-l) ;; 
	 (?\x159F . bidi-category-l) ;; 
	 (?\x15A0 . bidi-category-l) ;; 
	 (?\x15A1 . bidi-category-l) ;; 
	 (?\x15A2 . bidi-category-l) ;; 
	 (?\x15A3 . bidi-category-l) ;; 
	 (?\x15A4 . bidi-category-l) ;; 
	 (?\x15A5 . bidi-category-l) ;; 
	 (?\x15A6 . bidi-category-l) ;; 
	 (?\x15A7 . bidi-category-l) ;; 
	 (?\x15A8 . bidi-category-l) ;; 
	 (?\x15A9 . bidi-category-l) ;; 
	 (?\x15AA . bidi-category-l) ;; 
	 (?\x15AB . bidi-category-l) ;; 
	 (?\x15AC . bidi-category-l) ;; 
	 (?\x15AD . bidi-category-l) ;; 
	 (?\x15AE . bidi-category-l) ;; 
	 (?\x15AF . bidi-category-l) ;; 
	 (?\x15B0 . bidi-category-l) ;; 
	 (?\x15B1 . bidi-category-l) ;; 
	 (?\x15B2 . bidi-category-l) ;; 
	 (?\x15B3 . bidi-category-l) ;; 
	 (?\x15B4 . bidi-category-l) ;; 
	 (?\x15B5 . bidi-category-l) ;; 
	 (?\x15B6 . bidi-category-l) ;; 
	 (?\x15B7 . bidi-category-l) ;; 
	 (?\x15B8 . bidi-category-l) ;; 
	 (?\x15B9 . bidi-category-l) ;; 
	 (?\x15BA . bidi-category-l) ;; 
	 (?\x15BB . bidi-category-l) ;; 
	 (?\x15BC . bidi-category-l) ;; 
	 (?\x15BD . bidi-category-l) ;; 
	 (?\x15BE . bidi-category-l) ;; 
	 (?\x15BF . bidi-category-l) ;; 
	 (?\x15C0 . bidi-category-l) ;; 
	 (?\x15C1 . bidi-category-l) ;; 
	 (?\x15C2 . bidi-category-l) ;; 
	 (?\x15C3 . bidi-category-l) ;; 
	 (?\x15C4 . bidi-category-l) ;; 
	 (?\x15C5 . bidi-category-l) ;; 
	 (?\x15C6 . bidi-category-l) ;; 
	 (?\x15C7 . bidi-category-l) ;; 
	 (?\x15C8 . bidi-category-l) ;; 
	 (?\x15C9 . bidi-category-l) ;; 
	 (?\x15CA . bidi-category-l) ;; 
	 (?\x15CB . bidi-category-l) ;; 
	 (?\x15CC . bidi-category-l) ;; 
	 (?\x15CD . bidi-category-l) ;; 
	 (?\x15CE . bidi-category-l) ;; 
	 (?\x15CF . bidi-category-l) ;; 
	 (?\x15D0 . bidi-category-l) ;; 
	 (?\x15D1 . bidi-category-l) ;; 
	 (?\x15D2 . bidi-category-l) ;; 
	 (?\x15D3 . bidi-category-l) ;; 
	 (?\x15D4 . bidi-category-l) ;; 
	 (?\x15D5 . bidi-category-l) ;; 
	 (?\x15D6 . bidi-category-l) ;; 
	 (?\x15D7 . bidi-category-l) ;; 
	 (?\x15D8 . bidi-category-l) ;; 
	 (?\x15D9 . bidi-category-l) ;; 
	 (?\x15DA . bidi-category-l) ;; 
	 (?\x15DB . bidi-category-l) ;; 
	 (?\x15DC . bidi-category-l) ;; 
	 (?\x15DD . bidi-category-l) ;; 
	 (?\x15DE . bidi-category-l) ;; 
	 (?\x15DF . bidi-category-l) ;; 
	 (?\x15E0 . bidi-category-l) ;; 
	 (?\x15E1 . bidi-category-l) ;; 
	 (?\x15E2 . bidi-category-l) ;; 
	 (?\x15E3 . bidi-category-l) ;; 
	 (?\x15E4 . bidi-category-l) ;; 
	 (?\x15E5 . bidi-category-l) ;; 
	 (?\x15E6 . bidi-category-l) ;; 
	 (?\x15E7 . bidi-category-l) ;; 
	 (?\x15E8 . bidi-category-l) ;; 
	 (?\x15E9 . bidi-category-l) ;; 
	 (?\x15EA . bidi-category-l) ;; 
	 (?\x15EB . bidi-category-l) ;; 
	 (?\x15EC . bidi-category-l) ;; 
	 (?\x15ED . bidi-category-l) ;; 
	 (?\x15EE . bidi-category-l) ;; 
	 (?\x15EF . bidi-category-l) ;; 
	 (?\x15F0 . bidi-category-l) ;; 
	 (?\x15F1 . bidi-category-l) ;; 
	 (?\x15F2 . bidi-category-l) ;; 
	 (?\x15F3 . bidi-category-l) ;; 
	 (?\x15F4 . bidi-category-l) ;; 
	 (?\x15F5 . bidi-category-l) ;; 
	 (?\x15F6 . bidi-category-l) ;; 
	 (?\x15F7 . bidi-category-l) ;; 
	 (?\x15F8 . bidi-category-l) ;; 
	 (?\x15F9 . bidi-category-l) ;; 
	 (?\x15FA . bidi-category-l) ;; 
	 (?\x15FB . bidi-category-l) ;; 
	 (?\x15FC . bidi-category-l) ;; 
	 (?\x15FD . bidi-category-l) ;; 
	 (?\x15FE . bidi-category-l) ;; 
	 (?\x15FF . bidi-category-l) ;; 
	 (?\x1600 . bidi-category-l) ;; 
	 (?\x1601 . bidi-category-l) ;; 
	 (?\x1602 . bidi-category-l) ;; 
	 (?\x1603 . bidi-category-l) ;; 
	 (?\x1604 . bidi-category-l) ;; 
	 (?\x1605 . bidi-category-l) ;; 
	 (?\x1606 . bidi-category-l) ;; 
	 (?\x1607 . bidi-category-l) ;; 
	 (?\x1608 . bidi-category-l) ;; 
	 (?\x1609 . bidi-category-l) ;; 
	 (?\x160A . bidi-category-l) ;; 
	 (?\x160B . bidi-category-l) ;; 
	 (?\x160C . bidi-category-l) ;; 
	 (?\x160D . bidi-category-l) ;; 
	 (?\x160E . bidi-category-l) ;; 
	 (?\x160F . bidi-category-l) ;; 
	 (?\x1610 . bidi-category-l) ;; 
	 (?\x1611 . bidi-category-l) ;; 
	 (?\x1612 . bidi-category-l) ;; 
	 (?\x1613 . bidi-category-l) ;; 
	 (?\x1614 . bidi-category-l) ;; 
	 (?\x1615 . bidi-category-l) ;; 
	 (?\x1616 . bidi-category-l) ;; 
	 (?\x1617 . bidi-category-l) ;; 
	 (?\x1618 . bidi-category-l) ;; 
	 (?\x1619 . bidi-category-l) ;; 
	 (?\x161A . bidi-category-l) ;; 
	 (?\x161B . bidi-category-l) ;; 
	 (?\x161C . bidi-category-l) ;; 
	 (?\x161D . bidi-category-l) ;; 
	 (?\x161E . bidi-category-l) ;; 
	 (?\x161F . bidi-category-l) ;; 
	 (?\x1620 . bidi-category-l) ;; 
	 (?\x1621 . bidi-category-l) ;; 
	 (?\x1622 . bidi-category-l) ;; 
	 (?\x1623 . bidi-category-l) ;; 
	 (?\x1624 . bidi-category-l) ;; 
	 (?\x1625 . bidi-category-l) ;; 
	 (?\x1626 . bidi-category-l) ;; 
	 (?\x1627 . bidi-category-l) ;; 
	 (?\x1628 . bidi-category-l) ;; 
	 (?\x1629 . bidi-category-l) ;; 
	 (?\x162A . bidi-category-l) ;; 
	 (?\x162B . bidi-category-l) ;; 
	 (?\x162C . bidi-category-l) ;; 
	 (?\x162D . bidi-category-l) ;; 
	 (?\x162E . bidi-category-l) ;; 
	 (?\x162F . bidi-category-l) ;; 
	 (?\x1630 . bidi-category-l) ;; 
	 (?\x1631 . bidi-category-l) ;; 
	 (?\x1632 . bidi-category-l) ;; 
	 (?\x1633 . bidi-category-l) ;; 
	 (?\x1634 . bidi-category-l) ;; 
	 (?\x1635 . bidi-category-l) ;; 
	 (?\x1636 . bidi-category-l) ;; 
	 (?\x1637 . bidi-category-l) ;; 
	 (?\x1638 . bidi-category-l) ;; 
	 (?\x1639 . bidi-category-l) ;; 
	 (?\x163A . bidi-category-l) ;; 
	 (?\x163B . bidi-category-l) ;; 
	 (?\x163C . bidi-category-l) ;; 
	 (?\x163D . bidi-category-l) ;; 
	 (?\x163E . bidi-category-l) ;; 
	 (?\x163F . bidi-category-l) ;; 
	 (?\x1640 . bidi-category-l) ;; 
	 (?\x1641 . bidi-category-l) ;; 
	 (?\x1642 . bidi-category-l) ;; 
	 (?\x1643 . bidi-category-l) ;; 
	 (?\x1644 . bidi-category-l) ;; 
	 (?\x1645 . bidi-category-l) ;; 
	 (?\x1646 . bidi-category-l) ;; 
	 (?\x1647 . bidi-category-l) ;; 
	 (?\x1648 . bidi-category-l) ;; 
	 (?\x1649 . bidi-category-l) ;; 
	 (?\x164A . bidi-category-l) ;; 
	 (?\x164B . bidi-category-l) ;; 
	 (?\x164C . bidi-category-l) ;; 
	 (?\x164D . bidi-category-l) ;; 
	 (?\x164E . bidi-category-l) ;; 
	 (?\x164F . bidi-category-l) ;; 
	 (?\x1650 . bidi-category-l) ;; 
	 (?\x1651 . bidi-category-l) ;; 
	 (?\x1652 . bidi-category-l) ;; 
	 (?\x1653 . bidi-category-l) ;; 
	 (?\x1654 . bidi-category-l) ;; 
	 (?\x1655 . bidi-category-l) ;; 
	 (?\x1656 . bidi-category-l) ;; 
	 (?\x1657 . bidi-category-l) ;; 
	 (?\x1658 . bidi-category-l) ;; 
	 (?\x1659 . bidi-category-l) ;; 
	 (?\x165A . bidi-category-l) ;; 
	 (?\x165B . bidi-category-l) ;; 
	 (?\x165C . bidi-category-l) ;; 
	 (?\x165D . bidi-category-l) ;; 
	 (?\x165E . bidi-category-l) ;; 
	 (?\x165F . bidi-category-l) ;; 
	 (?\x1660 . bidi-category-l) ;; 
	 (?\x1661 . bidi-category-l) ;; 
	 (?\x1662 . bidi-category-l) ;; 
	 (?\x1663 . bidi-category-l) ;; 
	 (?\x1664 . bidi-category-l) ;; 
	 (?\x1665 . bidi-category-l) ;; 
	 (?\x1666 . bidi-category-l) ;; 
	 (?\x1667 . bidi-category-l) ;; 
	 (?\x1668 . bidi-category-l) ;; 
	 (?\x1669 . bidi-category-l) ;; 
	 (?\x166A . bidi-category-l) ;; 
	 (?\x166B . bidi-category-l) ;; 
	 (?\x166C . bidi-category-l) ;; 
	 (?\x166D . bidi-category-l) ;; 
	 (?\x166E . bidi-category-l) ;; 
	 (?\x166F . bidi-category-l) ;; 
	 (?\x1670 . bidi-category-l) ;; 
	 (?\x1671 . bidi-category-l) ;; 
	 (?\x1672 . bidi-category-l) ;; 
	 (?\x1673 . bidi-category-l) ;; 
	 (?\x1674 . bidi-category-l) ;; 
	 (?\x1675 . bidi-category-l) ;; 
	 (?\x1676 . bidi-category-l) ;; 
	 (?\x1680 . bidi-category-ws) ;; 
	 (?\x1681 . bidi-category-l) ;; 
	 (?\x1682 . bidi-category-l) ;; 
	 (?\x1683 . bidi-category-l) ;; 
	 (?\x1684 . bidi-category-l) ;; 
	 (?\x1685 . bidi-category-l) ;; 
	 (?\x1686 . bidi-category-l) ;; 
	 (?\x1687 . bidi-category-l) ;; 
	 (?\x1688 . bidi-category-l) ;; 
	 (?\x1689 . bidi-category-l) ;; 
	 (?\x168A . bidi-category-l) ;; 
	 (?\x168B . bidi-category-l) ;; 
	 (?\x168C . bidi-category-l) ;; 
	 (?\x168D . bidi-category-l) ;; 
	 (?\x168E . bidi-category-l) ;; 
	 (?\x168F . bidi-category-l) ;; 
	 (?\x1690 . bidi-category-l) ;; 
	 (?\x1691 . bidi-category-l) ;; 
	 (?\x1692 . bidi-category-l) ;; 
	 (?\x1693 . bidi-category-l) ;; 
	 (?\x1694 . bidi-category-l) ;; 
	 (?\x1695 . bidi-category-l) ;; 
	 (?\x1696 . bidi-category-l) ;; 
	 (?\x1697 . bidi-category-l) ;; 
	 (?\x1698 . bidi-category-l) ;; 
	 (?\x1699 . bidi-category-l) ;; 
	 (?\x169A . bidi-category-l) ;; 
	 (?\x169B . bidi-category-on) ;; 
	 (?\x169C . bidi-category-on) ;; 
	 (?\x16A0 . bidi-category-l) ;; 
	 (?\x16A1 . bidi-category-l) ;; 
	 (?\x16A2 . bidi-category-l) ;; 
	 (?\x16A3 . bidi-category-l) ;; 
	 (?\x16A4 . bidi-category-l) ;; 
	 (?\x16A5 . bidi-category-l) ;; 
	 (?\x16A6 . bidi-category-l) ;; 
	 (?\x16A7 . bidi-category-l) ;; 
	 (?\x16A8 . bidi-category-l) ;; 
	 (?\x16A9 . bidi-category-l) ;; 
	 (?\x16AA . bidi-category-l) ;; 
	 (?\x16AB . bidi-category-l) ;; 
	 (?\x16AC . bidi-category-l) ;; 
	 (?\x16AD . bidi-category-l) ;; 
	 (?\x16AE . bidi-category-l) ;; 
	 (?\x16AF . bidi-category-l) ;; 
	 (?\x16B0 . bidi-category-l) ;; 
	 (?\x16B1 . bidi-category-l) ;; 
	 (?\x16B2 . bidi-category-l) ;; 
	 (?\x16B3 . bidi-category-l) ;; 
	 (?\x16B4 . bidi-category-l) ;; 
	 (?\x16B5 . bidi-category-l) ;; 
	 (?\x16B6 . bidi-category-l) ;; 
	 (?\x16B7 . bidi-category-l) ;; 
	 (?\x16B8 . bidi-category-l) ;; 
	 (?\x16B9 . bidi-category-l) ;; 
	 (?\x16BA . bidi-category-l) ;; 
	 (?\x16BB . bidi-category-l) ;; 
	 (?\x16BC . bidi-category-l) ;; 
	 (?\x16BD . bidi-category-l) ;; 
	 (?\x16BE . bidi-category-l) ;; 
	 (?\x16BF . bidi-category-l) ;; 
	 (?\x16C0 . bidi-category-l) ;; 
	 (?\x16C1 . bidi-category-l) ;; 
	 (?\x16C2 . bidi-category-l) ;; 
	 (?\x16C3 . bidi-category-l) ;; 
	 (?\x16C4 . bidi-category-l) ;; 
	 (?\x16C5 . bidi-category-l) ;; 
	 (?\x16C6 . bidi-category-l) ;; 
	 (?\x16C7 . bidi-category-l) ;; 
	 (?\x16C8 . bidi-category-l) ;; 
	 (?\x16C9 . bidi-category-l) ;; 
	 (?\x16CA . bidi-category-l) ;; 
	 (?\x16CB . bidi-category-l) ;; 
	 (?\x16CC . bidi-category-l) ;; 
	 (?\x16CD . bidi-category-l) ;; 
	 (?\x16CE . bidi-category-l) ;; 
	 (?\x16CF . bidi-category-l) ;; 
	 (?\x16D0 . bidi-category-l) ;; 
	 (?\x16D1 . bidi-category-l) ;; 
	 (?\x16D2 . bidi-category-l) ;; 
	 (?\x16D3 . bidi-category-l) ;; 
	 (?\x16D4 . bidi-category-l) ;; 
	 (?\x16D5 . bidi-category-l) ;; 
	 (?\x16D6 . bidi-category-l) ;; 
	 (?\x16D7 . bidi-category-l) ;; 
	 (?\x16D8 . bidi-category-l) ;; 
	 (?\x16D9 . bidi-category-l) ;; 
	 (?\x16DA . bidi-category-l) ;; 
	 (?\x16DB . bidi-category-l) ;; 
	 (?\x16DC . bidi-category-l) ;; 
	 (?\x16DD . bidi-category-l) ;; 
	 (?\x16DE . bidi-category-l) ;; 
	 (?\x16DF . bidi-category-l) ;; 
	 (?\x16E0 . bidi-category-l) ;; 
	 (?\x16E1 . bidi-category-l) ;; 
	 (?\x16E2 . bidi-category-l) ;; 
	 (?\x16E3 . bidi-category-l) ;; 
	 (?\x16E4 . bidi-category-l) ;; 
	 (?\x16E5 . bidi-category-l) ;; 
	 (?\x16E6 . bidi-category-l) ;; 
	 (?\x16E7 . bidi-category-l) ;; 
	 (?\x16E8 . bidi-category-l) ;; 
	 (?\x16E9 . bidi-category-l) ;; 
	 (?\x16EA . bidi-category-l) ;; 
	 (?\x16EB . bidi-category-l) ;; 
	 (?\x16EC . bidi-category-l) ;; 
	 (?\x16ED . bidi-category-l) ;; 
	 (?\x16EE . bidi-category-l) ;; 
	 (?\x16EF . bidi-category-l) ;; 
	 (?\x16F0 . bidi-category-l) ;; 
	 (?\x1780 . bidi-category-l) ;; 
	 (?\x1781 . bidi-category-l) ;; 
	 (?\x1782 . bidi-category-l) ;; 
	 (?\x1783 . bidi-category-l) ;; 
	 (?\x1784 . bidi-category-l) ;; 
	 (?\x1785 . bidi-category-l) ;; 
	 (?\x1786 . bidi-category-l) ;; 
	 (?\x1787 . bidi-category-l) ;; 
	 (?\x1788 . bidi-category-l) ;; 
	 (?\x1789 . bidi-category-l) ;; 
	 (?\x178A . bidi-category-l) ;; 
	 (?\x178B . bidi-category-l) ;; 
	 (?\x178C . bidi-category-l) ;; 
	 (?\x178D . bidi-category-l) ;; 
	 (?\x178E . bidi-category-l) ;; 
	 (?\x178F . bidi-category-l) ;; 
	 (?\x1790 . bidi-category-l) ;; 
	 (?\x1791 . bidi-category-l) ;; 
	 (?\x1792 . bidi-category-l) ;; 
	 (?\x1793 . bidi-category-l) ;; 
	 (?\x1794 . bidi-category-l) ;; 
	 (?\x1795 . bidi-category-l) ;; 
	 (?\x1796 . bidi-category-l) ;; 
	 (?\x1797 . bidi-category-l) ;; 
	 (?\x1798 . bidi-category-l) ;; 
	 (?\x1799 . bidi-category-l) ;; 
	 (?\x179A . bidi-category-l) ;; 
	 (?\x179B . bidi-category-l) ;; 
	 (?\x179C . bidi-category-l) ;; 
	 (?\x179D . bidi-category-l) ;; 
	 (?\x179E . bidi-category-l) ;; 
	 (?\x179F . bidi-category-l) ;; 
	 (?\x17A0 . bidi-category-l) ;; 
	 (?\x17A1 . bidi-category-l) ;; 
	 (?\x17A2 . bidi-category-l) ;; 
	 (?\x17A3 . bidi-category-l) ;; 
	 (?\x17A4 . bidi-category-l) ;; 
	 (?\x17A5 . bidi-category-l) ;; 
	 (?\x17A6 . bidi-category-l) ;; 
	 (?\x17A7 . bidi-category-l) ;; 
	 (?\x17A8 . bidi-category-l) ;; 
	 (?\x17A9 . bidi-category-l) ;; 
	 (?\x17AA . bidi-category-l) ;; 
	 (?\x17AB . bidi-category-l) ;; 
	 (?\x17AC . bidi-category-l) ;; 
	 (?\x17AD . bidi-category-l) ;; 
	 (?\x17AE . bidi-category-l) ;; 
	 (?\x17AF . bidi-category-l) ;; 
	 (?\x17B0 . bidi-category-l) ;; 
	 (?\x17B1 . bidi-category-l) ;; 
	 (?\x17B2 . bidi-category-l) ;; 
	 (?\x17B3 . bidi-category-l) ;; 
	 (?\x17B4 . bidi-category-l) ;; 
	 (?\x17B5 . bidi-category-l) ;; 
	 (?\x17B6 . bidi-category-l) ;; 
	 (?\x17B7 . bidi-category-nsm) ;; 
	 (?\x17B8 . bidi-category-nsm) ;; 
	 (?\x17B9 . bidi-category-nsm) ;; 
	 (?\x17BA . bidi-category-nsm) ;; 
	 (?\x17BB . bidi-category-nsm) ;; 
	 (?\x17BC . bidi-category-nsm) ;; 
	 (?\x17BD . bidi-category-nsm) ;; 
	 (?\x17BE . bidi-category-l) ;; 
	 (?\x17BF . bidi-category-l) ;; 
	 (?\x17C0 . bidi-category-l) ;; 
	 (?\x17C1 . bidi-category-l) ;; 
	 (?\x17C2 . bidi-category-l) ;; 
	 (?\x17C3 . bidi-category-l) ;; 
	 (?\x17C4 . bidi-category-l) ;; 
	 (?\x17C5 . bidi-category-l) ;; 
	 (?\x17C6 . bidi-category-nsm) ;; 
	 (?\x17C7 . bidi-category-l) ;; 
	 (?\x17C8 . bidi-category-l) ;; 
	 (?\x17C9 . bidi-category-nsm) ;; 
	 (?\x17CA . bidi-category-nsm) ;; 
	 (?\x17CB . bidi-category-nsm) ;; 
	 (?\x17CC . bidi-category-nsm) ;; 
	 (?\x17CD . bidi-category-nsm) ;; 
	 (?\x17CE . bidi-category-nsm) ;; 
	 (?\x17CF . bidi-category-nsm) ;; 
	 (?\x17D0 . bidi-category-nsm) ;; 
	 (?\x17D1 . bidi-category-nsm) ;; 
	 (?\x17D2 . bidi-category-nsm) ;; 
	 (?\x17D3 . bidi-category-nsm) ;; 
	 (?\x17D4 . bidi-category-l) ;; 
	 (?\x17D5 . bidi-category-l) ;; 
	 (?\x17D6 . bidi-category-l) ;; 
	 (?\x17D7 . bidi-category-l) ;; 
	 (?\x17D8 . bidi-category-l) ;; 
	 (?\x17D9 . bidi-category-l) ;; 
	 (?\x17DA . bidi-category-l) ;; 
	 (?\x17DB . bidi-category-et) ;; 
	 (?\x17DC . bidi-category-l) ;; 
	 (?\x17E0 . bidi-category-l) ;; 
	 (?\x17E1 . bidi-category-l) ;; 
	 (?\x17E2 . bidi-category-l) ;; 
	 (?\x17E3 . bidi-category-l) ;; 
	 (?\x17E4 . bidi-category-l) ;; 
	 (?\x17E5 . bidi-category-l) ;; 
	 (?\x17E6 . bidi-category-l) ;; 
	 (?\x17E7 . bidi-category-l) ;; 
	 (?\x17E8 . bidi-category-l) ;; 
	 (?\x17E9 . bidi-category-l) ;; 
	 (?\x1800 . bidi-category-on) ;; 
	 (?\x1801 . bidi-category-on) ;; 
	 (?\x1802 . bidi-category-on) ;; 
	 (?\x1803 . bidi-category-on) ;; 
	 (?\x1804 . bidi-category-on) ;; 
	 (?\x1805 . bidi-category-on) ;; 
	 (?\x1806 . bidi-category-on) ;; 
	 (?\x1807 . bidi-category-on) ;; 
	 (?\x1808 . bidi-category-on) ;; 
	 (?\x1809 . bidi-category-on) ;; 
	 (?\x180A . bidi-category-on) ;; 
	 (?\x180B . bidi-category-bn) ;; 
	 (?\x180C . bidi-category-bn) ;; 
	 (?\x180D . bidi-category-bn) ;; 
	 (?\x180E . bidi-category-bn) ;; 
	 (?\x1810 . bidi-category-l) ;; 
	 (?\x1811 . bidi-category-l) ;; 
	 (?\x1812 . bidi-category-l) ;; 
	 (?\x1813 . bidi-category-l) ;; 
	 (?\x1814 . bidi-category-l) ;; 
	 (?\x1815 . bidi-category-l) ;; 
	 (?\x1816 . bidi-category-l) ;; 
	 (?\x1817 . bidi-category-l) ;; 
	 (?\x1818 . bidi-category-l) ;; 
	 (?\x1819 . bidi-category-l) ;; 
	 (?\x1820 . bidi-category-l) ;; 
	 (?\x1821 . bidi-category-l) ;; 
	 (?\x1822 . bidi-category-l) ;; 
	 (?\x1823 . bidi-category-l) ;; 
	 (?\x1824 . bidi-category-l) ;; 
	 (?\x1825 . bidi-category-l) ;; 
	 (?\x1826 . bidi-category-l) ;; 
	 (?\x1827 . bidi-category-l) ;; 
	 (?\x1828 . bidi-category-l) ;; 
	 (?\x1829 . bidi-category-l) ;; 
	 (?\x182A . bidi-category-l) ;; 
	 (?\x182B . bidi-category-l) ;; 
	 (?\x182C . bidi-category-l) ;; 
	 (?\x182D . bidi-category-l) ;; 
	 (?\x182E . bidi-category-l) ;; 
	 (?\x182F . bidi-category-l) ;; 
	 (?\x1830 . bidi-category-l) ;; 
	 (?\x1831 . bidi-category-l) ;; 
	 (?\x1832 . bidi-category-l) ;; 
	 (?\x1833 . bidi-category-l) ;; 
	 (?\x1834 . bidi-category-l) ;; 
	 (?\x1835 . bidi-category-l) ;; 
	 (?\x1836 . bidi-category-l) ;; 
	 (?\x1837 . bidi-category-l) ;; 
	 (?\x1838 . bidi-category-l) ;; 
	 (?\x1839 . bidi-category-l) ;; 
	 (?\x183A . bidi-category-l) ;; 
	 (?\x183B . bidi-category-l) ;; 
	 (?\x183C . bidi-category-l) ;; 
	 (?\x183D . bidi-category-l) ;; 
	 (?\x183E . bidi-category-l) ;; 
	 (?\x183F . bidi-category-l) ;; 
	 (?\x1840 . bidi-category-l) ;; 
	 (?\x1841 . bidi-category-l) ;; 
	 (?\x1842 . bidi-category-l) ;; 
	 (?\x1843 . bidi-category-l) ;; 
	 (?\x1844 . bidi-category-l) ;; 
	 (?\x1845 . bidi-category-l) ;; 
	 (?\x1846 . bidi-category-l) ;; 
	 (?\x1847 . bidi-category-l) ;; 
	 (?\x1848 . bidi-category-l) ;; 
	 (?\x1849 . bidi-category-l) ;; 
	 (?\x184A . bidi-category-l) ;; 
	 (?\x184B . bidi-category-l) ;; 
	 (?\x184C . bidi-category-l) ;; 
	 (?\x184D . bidi-category-l) ;; 
	 (?\x184E . bidi-category-l) ;; 
	 (?\x184F . bidi-category-l) ;; 
	 (?\x1850 . bidi-category-l) ;; 
	 (?\x1851 . bidi-category-l) ;; 
	 (?\x1852 . bidi-category-l) ;; 
	 (?\x1853 . bidi-category-l) ;; 
	 (?\x1854 . bidi-category-l) ;; 
	 (?\x1855 . bidi-category-l) ;; 
	 (?\x1856 . bidi-category-l) ;; 
	 (?\x1857 . bidi-category-l) ;; 
	 (?\x1858 . bidi-category-l) ;; 
	 (?\x1859 . bidi-category-l) ;; 
	 (?\x185A . bidi-category-l) ;; 
	 (?\x185B . bidi-category-l) ;; 
	 (?\x185C . bidi-category-l) ;; 
	 (?\x185D . bidi-category-l) ;; 
	 (?\x185E . bidi-category-l) ;; 
	 (?\x185F . bidi-category-l) ;; 
	 (?\x1860 . bidi-category-l) ;; 
	 (?\x1861 . bidi-category-l) ;; 
	 (?\x1862 . bidi-category-l) ;; 
	 (?\x1863 . bidi-category-l) ;; 
	 (?\x1864 . bidi-category-l) ;; 
	 (?\x1865 . bidi-category-l) ;; 
	 (?\x1866 . bidi-category-l) ;; 
	 (?\x1867 . bidi-category-l) ;; 
	 (?\x1868 . bidi-category-l) ;; 
	 (?\x1869 . bidi-category-l) ;; 
	 (?\x186A . bidi-category-l) ;; 
	 (?\x186B . bidi-category-l) ;; 
	 (?\x186C . bidi-category-l) ;; 
	 (?\x186D . bidi-category-l) ;; 
	 (?\x186E . bidi-category-l) ;; 
	 (?\x186F . bidi-category-l) ;; 
	 (?\x1870 . bidi-category-l) ;; 
	 (?\x1871 . bidi-category-l) ;; 
	 (?\x1872 . bidi-category-l) ;; 
	 (?\x1873 . bidi-category-l) ;; 
	 (?\x1874 . bidi-category-l) ;; 
	 (?\x1875 . bidi-category-l) ;; 
	 (?\x1876 . bidi-category-l) ;; 
	 (?\x1877 . bidi-category-l) ;; 
	 (?\x1880 . bidi-category-l) ;; 
	 (?\x1881 . bidi-category-l) ;; 
	 (?\x1882 . bidi-category-l) ;; 
	 (?\x1883 . bidi-category-l) ;; 
	 (?\x1884 . bidi-category-l) ;; 
	 (?\x1885 . bidi-category-l) ;; 
	 (?\x1886 . bidi-category-l) ;; 
	 (?\x1887 . bidi-category-l) ;; 
	 (?\x1888 . bidi-category-l) ;; 
	 (?\x1889 . bidi-category-l) ;; 
	 (?\x188A . bidi-category-l) ;; 
	 (?\x188B . bidi-category-l) ;; 
	 (?\x188C . bidi-category-l) ;; 
	 (?\x188D . bidi-category-l) ;; 
	 (?\x188E . bidi-category-l) ;; 
	 (?\x188F . bidi-category-l) ;; 
	 (?\x1890 . bidi-category-l) ;; 
	 (?\x1891 . bidi-category-l) ;; 
	 (?\x1892 . bidi-category-l) ;; 
	 (?\x1893 . bidi-category-l) ;; 
	 (?\x1894 . bidi-category-l) ;; 
	 (?\x1895 . bidi-category-l) ;; 
	 (?\x1896 . bidi-category-l) ;; 
	 (?\x1897 . bidi-category-l) ;; 
	 (?\x1898 . bidi-category-l) ;; 
	 (?\x1899 . bidi-category-l) ;; 
	 (?\x189A . bidi-category-l) ;; 
	 (?\x189B . bidi-category-l) ;; 
	 (?\x189C . bidi-category-l) ;; 
	 (?\x189D . bidi-category-l) ;; 
	 (?\x189E . bidi-category-l) ;; 
	 (?\x189F . bidi-category-l) ;; 
	 (?\x18A0 . bidi-category-l) ;; 
	 (?\x18A1 . bidi-category-l) ;; 
	 (?\x18A2 . bidi-category-l) ;; 
	 (?\x18A3 . bidi-category-l) ;; 
	 (?\x18A4 . bidi-category-l) ;; 
	 (?\x18A5 . bidi-category-l) ;; 
	 (?\x18A6 . bidi-category-l) ;; 
	 (?\x18A7 . bidi-category-l) ;; 
	 (?\x18A8 . bidi-category-l) ;; 
	 (?\x18A9 . bidi-category-nsm) ;; 
	 (?\x1E00 . bidi-category-l) ;; 
	 (?\x1E01 . bidi-category-l) ;; 
	 (?\x1E02 . bidi-category-l) ;; 
	 (?\x1E03 . bidi-category-l) ;; 
	 (?\x1E04 . bidi-category-l) ;; 
	 (?\x1E05 . bidi-category-l) ;; 
	 (?\x1E06 . bidi-category-l) ;; 
	 (?\x1E07 . bidi-category-l) ;; 
	 (?\x1E08 . bidi-category-l) ;; 
	 (?\x1E09 . bidi-category-l) ;; 
	 (?\x1E0A . bidi-category-l) ;; 
	 (?\x1E0B . bidi-category-l) ;; 
	 (?\x1E0C . bidi-category-l) ;; 
	 (?\x1E0D . bidi-category-l) ;; 
	 (?\x1E0E . bidi-category-l) ;; 
	 (?\x1E0F . bidi-category-l) ;; 
	 (?\x1E10 . bidi-category-l) ;; 
	 (?\x1E11 . bidi-category-l) ;; 
	 (?\x1E12 . bidi-category-l) ;; 
	 (?\x1E13 . bidi-category-l) ;; 
	 (?\x1E14 . bidi-category-l) ;; 
	 (?\x1E15 . bidi-category-l) ;; 
	 (?\x1E16 . bidi-category-l) ;; 
	 (?\x1E17 . bidi-category-l) ;; 
	 (?\x1E18 . bidi-category-l) ;; 
	 (?\x1E19 . bidi-category-l) ;; 
	 (?\x1E1A . bidi-category-l) ;; 
	 (?\x1E1B . bidi-category-l) ;; 
	 (?\x1E1C . bidi-category-l) ;; 
	 (?\x1E1D . bidi-category-l) ;; 
	 (?\x1E1E . bidi-category-l) ;; 
	 (?\x1E1F . bidi-category-l) ;; 
	 (?\x1E20 . bidi-category-l) ;; 
	 (?\x1E21 . bidi-category-l) ;; 
	 (?\x1E22 . bidi-category-l) ;; 
	 (?\x1E23 . bidi-category-l) ;; 
	 (?\x1E24 . bidi-category-l) ;; 
	 (?\x1E25 . bidi-category-l) ;; 
	 (?\x1E26 . bidi-category-l) ;; 
	 (?\x1E27 . bidi-category-l) ;; 
	 (?\x1E28 . bidi-category-l) ;; 
	 (?\x1E29 . bidi-category-l) ;; 
	 (?\x1E2A . bidi-category-l) ;; 
	 (?\x1E2B . bidi-category-l) ;; 
	 (?\x1E2C . bidi-category-l) ;; 
	 (?\x1E2D . bidi-category-l) ;; 
	 (?\x1E2E . bidi-category-l) ;; 
	 (?\x1E2F . bidi-category-l) ;; 
	 (?\x1E30 . bidi-category-l) ;; 
	 (?\x1E31 . bidi-category-l) ;; 
	 (?\x1E32 . bidi-category-l) ;; 
	 (?\x1E33 . bidi-category-l) ;; 
	 (?\x1E34 . bidi-category-l) ;; 
	 (?\x1E35 . bidi-category-l) ;; 
	 (?\x1E36 . bidi-category-l) ;; 
	 (?\x1E37 . bidi-category-l) ;; 
	 (?\x1E38 . bidi-category-l) ;; 
	 (?\x1E39 . bidi-category-l) ;; 
	 (?\x1E3A . bidi-category-l) ;; 
	 (?\x1E3B . bidi-category-l) ;; 
	 (?\x1E3C . bidi-category-l) ;; 
	 (?\x1E3D . bidi-category-l) ;; 
	 (?\x1E3E . bidi-category-l) ;; 
	 (?\x1E3F . bidi-category-l) ;; 
	 (?\x1E40 . bidi-category-l) ;; 
	 (?\x1E41 . bidi-category-l) ;; 
	 (?\x1E42 . bidi-category-l) ;; 
	 (?\x1E43 . bidi-category-l) ;; 
	 (?\x1E44 . bidi-category-l) ;; 
	 (?\x1E45 . bidi-category-l) ;; 
	 (?\x1E46 . bidi-category-l) ;; 
	 (?\x1E47 . bidi-category-l) ;; 
	 (?\x1E48 . bidi-category-l) ;; 
	 (?\x1E49 . bidi-category-l) ;; 
	 (?\x1E4A . bidi-category-l) ;; 
	 (?\x1E4B . bidi-category-l) ;; 
	 (?\x1E4C . bidi-category-l) ;; 
	 (?\x1E4D . bidi-category-l) ;; 
	 (?\x1E4E . bidi-category-l) ;; 
	 (?\x1E4F . bidi-category-l) ;; 
	 (?\x1E50 . bidi-category-l) ;; 
	 (?\x1E51 . bidi-category-l) ;; 
	 (?\x1E52 . bidi-category-l) ;; 
	 (?\x1E53 . bidi-category-l) ;; 
	 (?\x1E54 . bidi-category-l) ;; 
	 (?\x1E55 . bidi-category-l) ;; 
	 (?\x1E56 . bidi-category-l) ;; 
	 (?\x1E57 . bidi-category-l) ;; 
	 (?\x1E58 . bidi-category-l) ;; 
	 (?\x1E59 . bidi-category-l) ;; 
	 (?\x1E5A . bidi-category-l) ;; 
	 (?\x1E5B . bidi-category-l) ;; 
	 (?\x1E5C . bidi-category-l) ;; 
	 (?\x1E5D . bidi-category-l) ;; 
	 (?\x1E5E . bidi-category-l) ;; 
	 (?\x1E5F . bidi-category-l) ;; 
	 (?\x1E60 . bidi-category-l) ;; 
	 (?\x1E61 . bidi-category-l) ;; 
	 (?\x1E62 . bidi-category-l) ;; 
	 (?\x1E63 . bidi-category-l) ;; 
	 (?\x1E64 . bidi-category-l) ;; 
	 (?\x1E65 . bidi-category-l) ;; 
	 (?\x1E66 . bidi-category-l) ;; 
	 (?\x1E67 . bidi-category-l) ;; 
	 (?\x1E68 . bidi-category-l) ;; 
	 (?\x1E69 . bidi-category-l) ;; 
	 (?\x1E6A . bidi-category-l) ;; 
	 (?\x1E6B . bidi-category-l) ;; 
	 (?\x1E6C . bidi-category-l) ;; 
	 (?\x1E6D . bidi-category-l) ;; 
	 (?\x1E6E . bidi-category-l) ;; 
	 (?\x1E6F . bidi-category-l) ;; 
	 (?\x1E70 . bidi-category-l) ;; 
	 (?\x1E71 . bidi-category-l) ;; 
	 (?\x1E72 . bidi-category-l) ;; 
	 (?\x1E73 . bidi-category-l) ;; 
	 (?\x1E74 . bidi-category-l) ;; 
	 (?\x1E75 . bidi-category-l) ;; 
	 (?\x1E76 . bidi-category-l) ;; 
	 (?\x1E77 . bidi-category-l) ;; 
	 (?\x1E78 . bidi-category-l) ;; 
	 (?\x1E79 . bidi-category-l) ;; 
	 (?\x1E7A . bidi-category-l) ;; 
	 (?\x1E7B . bidi-category-l) ;; 
	 (?\x1E7C . bidi-category-l) ;; 
	 (?\x1E7D . bidi-category-l) ;; 
	 (?\x1E7E . bidi-category-l) ;; 
	 (?\x1E7F . bidi-category-l) ;; 
	 (?\x1E80 . bidi-category-l) ;; 
	 (?\x1E81 . bidi-category-l) ;; 
	 (?\x1E82 . bidi-category-l) ;; 
	 (?\x1E83 . bidi-category-l) ;; 
	 (?\x1E84 . bidi-category-l) ;; 
	 (?\x1E85 . bidi-category-l) ;; 
	 (?\x1E86 . bidi-category-l) ;; 
	 (?\x1E87 . bidi-category-l) ;; 
	 (?\x1E88 . bidi-category-l) ;; 
	 (?\x1E89 . bidi-category-l) ;; 
	 (?\x1E8A . bidi-category-l) ;; 
	 (?\x1E8B . bidi-category-l) ;; 
	 (?\x1E8C . bidi-category-l) ;; 
	 (?\x1E8D . bidi-category-l) ;; 
	 (?\x1E8E . bidi-category-l) ;; 
	 (?\x1E8F . bidi-category-l) ;; 
	 (?\x1E90 . bidi-category-l) ;; 
	 (?\x1E91 . bidi-category-l) ;; 
	 (?\x1E92 . bidi-category-l) ;; 
	 (?\x1E93 . bidi-category-l) ;; 
	 (?\x1E94 . bidi-category-l) ;; 
	 (?\x1E95 . bidi-category-l) ;; 
	 (?\x1E96 . bidi-category-l) ;; 
	 (?\x1E97 . bidi-category-l) ;; 
	 (?\x1E98 . bidi-category-l) ;; 
	 (?\x1E99 . bidi-category-l) ;; 
	 (?\x1E9A . bidi-category-l) ;; 
	 (?\x1E9B . bidi-category-l) ;; 
	 (?\x1EA0 . bidi-category-l) ;; 
	 (?\x1EA1 . bidi-category-l) ;; 
	 (?\x1EA2 . bidi-category-l) ;; 
	 (?\x1EA3 . bidi-category-l) ;; 
	 (?\x1EA4 . bidi-category-l) ;; 
	 (?\x1EA5 . bidi-category-l) ;; 
	 (?\x1EA6 . bidi-category-l) ;; 
	 (?\x1EA7 . bidi-category-l) ;; 
	 (?\x1EA8 . bidi-category-l) ;; 
	 (?\x1EA9 . bidi-category-l) ;; 
	 (?\x1EAA . bidi-category-l) ;; 
	 (?\x1EAB . bidi-category-l) ;; 
	 (?\x1EAC . bidi-category-l) ;; 
	 (?\x1EAD . bidi-category-l) ;; 
	 (?\x1EAE . bidi-category-l) ;; 
	 (?\x1EAF . bidi-category-l) ;; 
	 (?\x1EB0 . bidi-category-l) ;; 
	 (?\x1EB1 . bidi-category-l) ;; 
	 (?\x1EB2 . bidi-category-l) ;; 
	 (?\x1EB3 . bidi-category-l) ;; 
	 (?\x1EB4 . bidi-category-l) ;; 
	 (?\x1EB5 . bidi-category-l) ;; 
	 (?\x1EB6 . bidi-category-l) ;; 
	 (?\x1EB7 . bidi-category-l) ;; 
	 (?\x1EB8 . bidi-category-l) ;; 
	 (?\x1EB9 . bidi-category-l) ;; 
	 (?\x1EBA . bidi-category-l) ;; 
	 (?\x1EBB . bidi-category-l) ;; 
	 (?\x1EBC . bidi-category-l) ;; 
	 (?\x1EBD . bidi-category-l) ;; 
	 (?\x1EBE . bidi-category-l) ;; 
	 (?\x1EBF . bidi-category-l) ;; 
	 (?\x1EC0 . bidi-category-l) ;; 
	 (?\x1EC1 . bidi-category-l) ;; 
	 (?\x1EC2 . bidi-category-l) ;; 
	 (?\x1EC3 . bidi-category-l) ;; 
	 (?\x1EC4 . bidi-category-l) ;; 
	 (?\x1EC5 . bidi-category-l) ;; 
	 (?\x1EC6 . bidi-category-l) ;; 
	 (?\x1EC7 . bidi-category-l) ;; 
	 (?\x1EC8 . bidi-category-l) ;; 
	 (?\x1EC9 . bidi-category-l) ;; 
	 (?\x1ECA . bidi-category-l) ;; 
	 (?\x1ECB . bidi-category-l) ;; 
	 (?\x1ECC . bidi-category-l) ;; 
	 (?\x1ECD . bidi-category-l) ;; 
	 (?\x1ECE . bidi-category-l) ;; 
	 (?\x1ECF . bidi-category-l) ;; 
	 (?\x1ED0 . bidi-category-l) ;; 
	 (?\x1ED1 . bidi-category-l) ;; 
	 (?\x1ED2 . bidi-category-l) ;; 
	 (?\x1ED3 . bidi-category-l) ;; 
	 (?\x1ED4 . bidi-category-l) ;; 
	 (?\x1ED5 . bidi-category-l) ;; 
	 (?\x1ED6 . bidi-category-l) ;; 
	 (?\x1ED7 . bidi-category-l) ;; 
	 (?\x1ED8 . bidi-category-l) ;; 
	 (?\x1ED9 . bidi-category-l) ;; 
	 (?\x1EDA . bidi-category-l) ;; 
	 (?\x1EDB . bidi-category-l) ;; 
	 (?\x1EDC . bidi-category-l) ;; 
	 (?\x1EDD . bidi-category-l) ;; 
	 (?\x1EDE . bidi-category-l) ;; 
	 (?\x1EDF . bidi-category-l) ;; 
	 (?\x1EE0 . bidi-category-l) ;; 
	 (?\x1EE1 . bidi-category-l) ;; 
	 (?\x1EE2 . bidi-category-l) ;; 
	 (?\x1EE3 . bidi-category-l) ;; 
	 (?\x1EE4 . bidi-category-l) ;; 
	 (?\x1EE5 . bidi-category-l) ;; 
	 (?\x1EE6 . bidi-category-l) ;; 
	 (?\x1EE7 . bidi-category-l) ;; 
	 (?\x1EE8 . bidi-category-l) ;; 
	 (?\x1EE9 . bidi-category-l) ;; 
	 (?\x1EEA . bidi-category-l) ;; 
	 (?\x1EEB . bidi-category-l) ;; 
	 (?\x1EEC . bidi-category-l) ;; 
	 (?\x1EED . bidi-category-l) ;; 
	 (?\x1EEE . bidi-category-l) ;; 
	 (?\x1EEF . bidi-category-l) ;; 
	 (?\x1EF0 . bidi-category-l) ;; 
	 (?\x1EF1 . bidi-category-l) ;; 
	 (?\x1EF2 . bidi-category-l) ;; 
	 (?\x1EF3 . bidi-category-l) ;; 
	 (?\x1EF4 . bidi-category-l) ;; 
	 (?\x1EF5 . bidi-category-l) ;; 
	 (?\x1EF6 . bidi-category-l) ;; 
	 (?\x1EF7 . bidi-category-l) ;; 
	 (?\x1EF8 . bidi-category-l) ;; 
	 (?\x1EF9 . bidi-category-l) ;; 
	 (?\x1F00 . bidi-category-l) ;; 
	 (?\x1F01 . bidi-category-l) ;; 
	 (?\x1F02 . bidi-category-l) ;; 
	 (?\x1F03 . bidi-category-l) ;; 
	 (?\x1F04 . bidi-category-l) ;; 
	 (?\x1F05 . bidi-category-l) ;; 
	 (?\x1F06 . bidi-category-l) ;; 
	 (?\x1F07 . bidi-category-l) ;; 
	 (?\x1F08 . bidi-category-l) ;; 
	 (?\x1F09 . bidi-category-l) ;; 
	 (?\x1F0A . bidi-category-l) ;; 
	 (?\x1F0B . bidi-category-l) ;; 
	 (?\x1F0C . bidi-category-l) ;; 
	 (?\x1F0D . bidi-category-l) ;; 
	 (?\x1F0E . bidi-category-l) ;; 
	 (?\x1F0F . bidi-category-l) ;; 
	 (?\x1F10 . bidi-category-l) ;; 
	 (?\x1F11 . bidi-category-l) ;; 
	 (?\x1F12 . bidi-category-l) ;; 
	 (?\x1F13 . bidi-category-l) ;; 
	 (?\x1F14 . bidi-category-l) ;; 
	 (?\x1F15 . bidi-category-l) ;; 
	 (?\x1F18 . bidi-category-l) ;; 
	 (?\x1F19 . bidi-category-l) ;; 
	 (?\x1F1A . bidi-category-l) ;; 
	 (?\x1F1B . bidi-category-l) ;; 
	 (?\x1F1C . bidi-category-l) ;; 
	 (?\x1F1D . bidi-category-l) ;; 
	 (?\x1F20 . bidi-category-l) ;; 
	 (?\x1F21 . bidi-category-l) ;; 
	 (?\x1F22 . bidi-category-l) ;; 
	 (?\x1F23 . bidi-category-l) ;; 
	 (?\x1F24 . bidi-category-l) ;; 
	 (?\x1F25 . bidi-category-l) ;; 
	 (?\x1F26 . bidi-category-l) ;; 
	 (?\x1F27 . bidi-category-l) ;; 
	 (?\x1F28 . bidi-category-l) ;; 
	 (?\x1F29 . bidi-category-l) ;; 
	 (?\x1F2A . bidi-category-l) ;; 
	 (?\x1F2B . bidi-category-l) ;; 
	 (?\x1F2C . bidi-category-l) ;; 
	 (?\x1F2D . bidi-category-l) ;; 
	 (?\x1F2E . bidi-category-l) ;; 
	 (?\x1F2F . bidi-category-l) ;; 
	 (?\x1F30 . bidi-category-l) ;; 
	 (?\x1F31 . bidi-category-l) ;; 
	 (?\x1F32 . bidi-category-l) ;; 
	 (?\x1F33 . bidi-category-l) ;; 
	 (?\x1F34 . bidi-category-l) ;; 
	 (?\x1F35 . bidi-category-l) ;; 
	 (?\x1F36 . bidi-category-l) ;; 
	 (?\x1F37 . bidi-category-l) ;; 
	 (?\x1F38 . bidi-category-l) ;; 
	 (?\x1F39 . bidi-category-l) ;; 
	 (?\x1F3A . bidi-category-l) ;; 
	 (?\x1F3B . bidi-category-l) ;; 
	 (?\x1F3C . bidi-category-l) ;; 
	 (?\x1F3D . bidi-category-l) ;; 
	 (?\x1F3E . bidi-category-l) ;; 
	 (?\x1F3F . bidi-category-l) ;; 
	 (?\x1F40 . bidi-category-l) ;; 
	 (?\x1F41 . bidi-category-l) ;; 
	 (?\x1F42 . bidi-category-l) ;; 
	 (?\x1F43 . bidi-category-l) ;; 
	 (?\x1F44 . bidi-category-l) ;; 
	 (?\x1F45 . bidi-category-l) ;; 
	 (?\x1F48 . bidi-category-l) ;; 
	 (?\x1F49 . bidi-category-l) ;; 
	 (?\x1F4A . bidi-category-l) ;; 
	 (?\x1F4B . bidi-category-l) ;; 
	 (?\x1F4C . bidi-category-l) ;; 
	 (?\x1F4D . bidi-category-l) ;; 
	 (?\x1F50 . bidi-category-l) ;; 
	 (?\x1F51 . bidi-category-l) ;; 
	 (?\x1F52 . bidi-category-l) ;; 
	 (?\x1F53 . bidi-category-l) ;; 
	 (?\x1F54 . bidi-category-l) ;; 
	 (?\x1F55 . bidi-category-l) ;; 
	 (?\x1F56 . bidi-category-l) ;; 
	 (?\x1F57 . bidi-category-l) ;; 
	 (?\x1F59 . bidi-category-l) ;; 
	 (?\x1F5B . bidi-category-l) ;; 
	 (?\x1F5D . bidi-category-l) ;; 
	 (?\x1F5F . bidi-category-l) ;; 
	 (?\x1F60 . bidi-category-l) ;; 
	 (?\x1F61 . bidi-category-l) ;; 
	 (?\x1F62 . bidi-category-l) ;; 
	 (?\x1F63 . bidi-category-l) ;; 
	 (?\x1F64 . bidi-category-l) ;; 
	 (?\x1F65 . bidi-category-l) ;; 
	 (?\x1F66 . bidi-category-l) ;; 
	 (?\x1F67 . bidi-category-l) ;; 
	 (?\x1F68 . bidi-category-l) ;; 
	 (?\x1F69 . bidi-category-l) ;; 
	 (?\x1F6A . bidi-category-l) ;; 
	 (?\x1F6B . bidi-category-l) ;; 
	 (?\x1F6C . bidi-category-l) ;; 
	 (?\x1F6D . bidi-category-l) ;; 
	 (?\x1F6E . bidi-category-l) ;; 
	 (?\x1F6F . bidi-category-l) ;; 
	 (?\x1F70 . bidi-category-l) ;; 
	 (?\x1F71 . bidi-category-l) ;; 
	 (?\x1F72 . bidi-category-l) ;; 
	 (?\x1F73 . bidi-category-l) ;; 
	 (?\x1F74 . bidi-category-l) ;; 
	 (?\x1F75 . bidi-category-l) ;; 
	 (?\x1F76 . bidi-category-l) ;; 
	 (?\x1F77 . bidi-category-l) ;; 
	 (?\x1F78 . bidi-category-l) ;; 
	 (?\x1F79 . bidi-category-l) ;; 
	 (?\x1F7A . bidi-category-l) ;; 
	 (?\x1F7B . bidi-category-l) ;; 
	 (?\x1F7C . bidi-category-l) ;; 
	 (?\x1F7D . bidi-category-l) ;; 
	 (?\x1F80 . bidi-category-l) ;; 
	 (?\x1F81 . bidi-category-l) ;; 
	 (?\x1F82 . bidi-category-l) ;; 
	 (?\x1F83 . bidi-category-l) ;; 
	 (?\x1F84 . bidi-category-l) ;; 
	 (?\x1F85 . bidi-category-l) ;; 
	 (?\x1F86 . bidi-category-l) ;; 
	 (?\x1F87 . bidi-category-l) ;; 
	 (?\x1F88 . bidi-category-l) ;; 
	 (?\x1F89 . bidi-category-l) ;; 
	 (?\x1F8A . bidi-category-l) ;; 
	 (?\x1F8B . bidi-category-l) ;; 
	 (?\x1F8C . bidi-category-l) ;; 
	 (?\x1F8D . bidi-category-l) ;; 
	 (?\x1F8E . bidi-category-l) ;; 
	 (?\x1F8F . bidi-category-l) ;; 
	 (?\x1F90 . bidi-category-l) ;; 
	 (?\x1F91 . bidi-category-l) ;; 
	 (?\x1F92 . bidi-category-l) ;; 
	 (?\x1F93 . bidi-category-l) ;; 
	 (?\x1F94 . bidi-category-l) ;; 
	 (?\x1F95 . bidi-category-l) ;; 
	 (?\x1F96 . bidi-category-l) ;; 
	 (?\x1F97 . bidi-category-l) ;; 
	 (?\x1F98 . bidi-category-l) ;; 
	 (?\x1F99 . bidi-category-l) ;; 
	 (?\x1F9A . bidi-category-l) ;; 
	 (?\x1F9B . bidi-category-l) ;; 
	 (?\x1F9C . bidi-category-l) ;; 
	 (?\x1F9D . bidi-category-l) ;; 
	 (?\x1F9E . bidi-category-l) ;; 
	 (?\x1F9F . bidi-category-l) ;; 
	 (?\x1FA0 . bidi-category-l) ;; 
	 (?\x1FA1 . bidi-category-l) ;; 
	 (?\x1FA2 . bidi-category-l) ;; 
	 (?\x1FA3 . bidi-category-l) ;; 
	 (?\x1FA4 . bidi-category-l) ;; 
	 (?\x1FA5 . bidi-category-l) ;; 
	 (?\x1FA6 . bidi-category-l) ;; 
	 (?\x1FA7 . bidi-category-l) ;; 
	 (?\x1FA8 . bidi-category-l) ;; 
	 (?\x1FA9 . bidi-category-l) ;; 
	 (?\x1FAA . bidi-category-l) ;; 
	 (?\x1FAB . bidi-category-l) ;; 
	 (?\x1FAC . bidi-category-l) ;; 
	 (?\x1FAD . bidi-category-l) ;; 
	 (?\x1FAE . bidi-category-l) ;; 
	 (?\x1FAF . bidi-category-l) ;; 
	 (?\x1FB0 . bidi-category-l) ;; 
	 (?\x1FB1 . bidi-category-l) ;; 
	 (?\x1FB2 . bidi-category-l) ;; 
	 (?\x1FB3 . bidi-category-l) ;; 
	 (?\x1FB4 . bidi-category-l) ;; 
	 (?\x1FB6 . bidi-category-l) ;; 
	 (?\x1FB7 . bidi-category-l) ;; 
	 (?\x1FB8 . bidi-category-l) ;; 
	 (?\x1FB9 . bidi-category-l) ;; 
	 (?\x1FBA . bidi-category-l) ;; 
	 (?\x1FBB . bidi-category-l) ;; 
	 (?\x1FBC . bidi-category-l) ;; 
	 (?\x1FBD . bidi-category-on) ;; 
	 (?\x1FBE . bidi-category-l) ;; 
	 (?\x1FBF . bidi-category-on) ;; 
	 (?\x1FC0 . bidi-category-on) ;; 
	 (?\x1FC1 . bidi-category-on) ;; 
	 (?\x1FC2 . bidi-category-l) ;; 
	 (?\x1FC3 . bidi-category-l) ;; 
	 (?\x1FC4 . bidi-category-l) ;; 
	 (?\x1FC6 . bidi-category-l) ;; 
	 (?\x1FC7 . bidi-category-l) ;; 
	 (?\x1FC8 . bidi-category-l) ;; 
	 (?\x1FC9 . bidi-category-l) ;; 
	 (?\x1FCA . bidi-category-l) ;; 
	 (?\x1FCB . bidi-category-l) ;; 
	 (?\x1FCC . bidi-category-l) ;; 
	 (?\x1FCD . bidi-category-on) ;; 
	 (?\x1FCE . bidi-category-on) ;; 
	 (?\x1FCF . bidi-category-on) ;; 
	 (?\x1FD0 . bidi-category-l) ;; 
	 (?\x1FD1 . bidi-category-l) ;; 
	 (?\x1FD2 . bidi-category-l) ;; 
	 (?\x1FD3 . bidi-category-l) ;; 
	 (?\x1FD6 . bidi-category-l) ;; 
	 (?\x1FD7 . bidi-category-l) ;; 
	 (?\x1FD8 . bidi-category-l) ;; 
	 (?\x1FD9 . bidi-category-l) ;; 
	 (?\x1FDA . bidi-category-l) ;; 
	 (?\x1FDB . bidi-category-l) ;; 
	 (?\x1FDD . bidi-category-on) ;; 
	 (?\x1FDE . bidi-category-on) ;; 
	 (?\x1FDF . bidi-category-on) ;; 
	 (?\x1FE0 . bidi-category-l) ;; 
	 (?\x1FE1 . bidi-category-l) ;; 
	 (?\x1FE2 . bidi-category-l) ;; 
	 (?\x1FE3 . bidi-category-l) ;; 
	 (?\x1FE4 . bidi-category-l) ;; 
	 (?\x1FE5 . bidi-category-l) ;; 
	 (?\x1FE6 . bidi-category-l) ;; 
	 (?\x1FE7 . bidi-category-l) ;; 
	 (?\x1FE8 . bidi-category-l) ;; 
	 (?\x1FE9 . bidi-category-l) ;; 
	 (?\x1FEA . bidi-category-l) ;; 
	 (?\x1FEB . bidi-category-l) ;; 
	 (?\x1FEC . bidi-category-l) ;; 
	 (?\x1FED . bidi-category-on) ;; 
	 (?\x1FEE . bidi-category-on) ;; 
	 (?\x1FEF . bidi-category-on) ;; 
	 (?\x1FF2 . bidi-category-l) ;; 
	 (?\x1FF3 . bidi-category-l) ;; 
	 (?\x1FF4 . bidi-category-l) ;; 
	 (?\x1FF6 . bidi-category-l) ;; 
	 (?\x1FF7 . bidi-category-l) ;; 
	 (?\x1FF8 . bidi-category-l) ;; 
	 (?\x1FF9 . bidi-category-l) ;; 
	 (?\x1FFA . bidi-category-l) ;; 
	 (?\x1FFB . bidi-category-l) ;; 
	 (?\x1FFC . bidi-category-l) ;; 
	 (?\x1FFD . bidi-category-on) ;; 
	 (?\x1FFE . bidi-category-on) ;; 
	 (?\x2000 . bidi-category-ws) ;; 
	 (?\x2001 . bidi-category-ws) ;; 
	 (?\x2002 . bidi-category-ws) ;; 
	 (?\x2003 . bidi-category-ws) ;; 
	 (?\x2004 . bidi-category-ws) ;; 
	 (?\x2005 . bidi-category-ws) ;; 
	 (?\x2006 . bidi-category-ws) ;; 
	 (?\x2007 . bidi-category-ws) ;; 
	 (?\x2008 . bidi-category-ws) ;; 
	 (?\x2009 . bidi-category-ws) ;; 
	 (?\x200A . bidi-category-ws) ;; 
	 (?\x200B . bidi-category-bn) ;; 
	 (?\x200C . bidi-category-bn) ;; 
	 (?\x200D . bidi-category-bn) ;; 
	 (?\x200E . bidi-category-l) ;; 
	 (?\x200F . bidi-category-r) ;; 
	 (?\x2010 . bidi-category-on) ;; 
	 (?\x2011 . bidi-category-on) ;; 
	 (?\x2012 . bidi-category-on) ;; 
	 (?\x2013 . bidi-category-on) ;; 
	 (?\x2014 . bidi-category-on) ;; 
	 (?\x2015 . bidi-category-on) ;; QUOTATION DASH
	 (?\x2016 . bidi-category-on) ;; DOUBLE VERTICAL BAR
	 (?\x2017 . bidi-category-on) ;; SPACING DOUBLE UNDERSCORE
	 (?\x2018 . bidi-category-on) ;; SINGLE TURNED COMMA QUOTATION MARK
	 (?\x2019 . bidi-category-on) ;; SINGLE COMMA QUOTATION MARK
	 (?\x201A . bidi-category-on) ;; LOW SINGLE COMMA QUOTATION MARK
	 (?\x201B . bidi-category-on) ;; SINGLE REVERSED COMMA QUOTATION MARK
	 (?\x201C . bidi-category-on) ;; DOUBLE TURNED COMMA QUOTATION MARK
	 (?\x201D . bidi-category-on) ;; DOUBLE COMMA QUOTATION MARK
	 (?\x201E . bidi-category-on) ;; LOW DOUBLE COMMA QUOTATION MARK
	 (?\x201F . bidi-category-on) ;; DOUBLE REVERSED COMMA QUOTATION MARK
	 (?\x2020 . bidi-category-on) ;; 
	 (?\x2021 . bidi-category-on) ;; 
	 (?\x2022 . bidi-category-on) ;; 
	 (?\x2023 . bidi-category-on) ;; 
	 (?\x2024 . bidi-category-on) ;; 
	 (?\x2025 . bidi-category-on) ;; 
	 (?\x2026 . bidi-category-on) ;; 
	 (?\x2027 . bidi-category-on) ;; 
	 (?\x2028 . bidi-category-ws) ;; 
	 (?\x2029 . bidi-category-b) ;; 
	 (?\x202A . bidi-category-lre) ;; 
	 (?\x202B . bidi-category-rle) ;; 
	 (?\x202C . bidi-category-pdf) ;; 
	 (?\x202D . bidi-category-lro) ;; 
	 (?\x202E . bidi-category-rlo) ;; 
	 (?\x202F . bidi-category-ws) ;; 
	 (?\x2030 . bidi-category-et) ;; 
	 (?\x2031 . bidi-category-et) ;; 
	 (?\x2032 . bidi-category-et) ;; 
	 (?\x2033 . bidi-category-et) ;; 
	 (?\x2034 . bidi-category-et) ;; 
	 (?\x2035 . bidi-category-on) ;; 
	 (?\x2036 . bidi-category-on) ;; 
	 (?\x2037 . bidi-category-on) ;; 
	 (?\x2038 . bidi-category-on) ;; 
	 (?\x2039 . bidi-category-on) ;; LEFT POINTING SINGLE GUILLEMET
	 (?\x203A . bidi-category-on) ;; RIGHT POINTING SINGLE GUILLEMET
	 (?\x203B . bidi-category-on) ;; 
	 (?\x203C . bidi-category-on) ;; 
	 (?\x203D . bidi-category-on) ;; 
	 (?\x203E . bidi-category-on) ;; SPACING OVERSCORE
	 (?\x203F . bidi-category-on) ;; 
	 (?\x2040 . bidi-category-on) ;; 
	 (?\x2041 . bidi-category-on) ;; 
	 (?\x2042 . bidi-category-on) ;; 
	 (?\x2043 . bidi-category-on) ;; 
	 (?\x2044 . bidi-category-on) ;; 
	 (?\x2045 . bidi-category-on) ;; 
	 (?\x2046 . bidi-category-on) ;; 
	 (?\x2048 . bidi-category-on) ;; 
	 (?\x2049 . bidi-category-on) ;; 
	 (?\x204A . bidi-category-on) ;; 
	 (?\x204B . bidi-category-on) ;; 
	 (?\x204C . bidi-category-on) ;; 
	 (?\x204D . bidi-category-on) ;; 
	 (?\x206A . bidi-category-bn) ;; 
	 (?\x206B . bidi-category-bn) ;; 
	 (?\x206C . bidi-category-bn) ;; 
	 (?\x206D . bidi-category-bn) ;; 
	 (?\x206E . bidi-category-bn) ;; 
	 (?\x206F . bidi-category-bn) ;; 
	 (?\x2070 . bidi-category-en) ;; SUPERSCRIPT DIGIT ZERO
	 (?\x2074 . bidi-category-en) ;; SUPERSCRIPT DIGIT FOUR
	 (?\x2075 . bidi-category-en) ;; SUPERSCRIPT DIGIT FIVE
	 (?\x2076 . bidi-category-en) ;; SUPERSCRIPT DIGIT SIX
	 (?\x2077 . bidi-category-en) ;; SUPERSCRIPT DIGIT SEVEN
	 (?\x2078 . bidi-category-en) ;; SUPERSCRIPT DIGIT EIGHT
	 (?\x2079 . bidi-category-en) ;; SUPERSCRIPT DIGIT NINE
	 (?\x207A . bidi-category-et) ;; 
	 (?\x207B . bidi-category-et) ;; SUPERSCRIPT HYPHEN-MINUS
	 (?\x207C . bidi-category-on) ;; 
	 (?\x207D . bidi-category-on) ;; SUPERSCRIPT OPENING PARENTHESIS
	 (?\x207E . bidi-category-on) ;; SUPERSCRIPT CLOSING PARENTHESIS
	 (?\x207F . bidi-category-l) ;; 
	 (?\x2080 . bidi-category-en) ;; SUBSCRIPT DIGIT ZERO
	 (?\x2081 . bidi-category-en) ;; SUBSCRIPT DIGIT ONE
	 (?\x2082 . bidi-category-en) ;; SUBSCRIPT DIGIT TWO
	 (?\x2083 . bidi-category-en) ;; SUBSCRIPT DIGIT THREE
	 (?\x2084 . bidi-category-en) ;; SUBSCRIPT DIGIT FOUR
	 (?\x2085 . bidi-category-en) ;; SUBSCRIPT DIGIT FIVE
	 (?\x2086 . bidi-category-en) ;; SUBSCRIPT DIGIT SIX
	 (?\x2087 . bidi-category-en) ;; SUBSCRIPT DIGIT SEVEN
	 (?\x2088 . bidi-category-en) ;; SUBSCRIPT DIGIT EIGHT
	 (?\x2089 . bidi-category-en) ;; SUBSCRIPT DIGIT NINE
	 (?\x208A . bidi-category-et) ;; 
	 (?\x208B . bidi-category-et) ;; SUBSCRIPT HYPHEN-MINUS
	 (?\x208C . bidi-category-on) ;; 
	 (?\x208D . bidi-category-on) ;; SUBSCRIPT OPENING PARENTHESIS
	 (?\x208E . bidi-category-on) ;; SUBSCRIPT CLOSING PARENTHESIS
	 (?\x20A0 . bidi-category-et) ;; 
	 (?\x20A1 . bidi-category-et) ;; 
	 (?\x20A2 . bidi-category-et) ;; 
	 (?\x20A3 . bidi-category-et) ;; 
	 (?\x20A4 . bidi-category-et) ;; 
	 (?\x20A5 . bidi-category-et) ;; 
	 (?\x20A6 . bidi-category-et) ;; 
	 (?\x20A7 . bidi-category-et) ;; 
	 (?\x20A8 . bidi-category-et) ;; 
	 (?\x20A9 . bidi-category-et) ;; 
	 (?\x20AA . bidi-category-et) ;; 
	 (?\x20AB . bidi-category-et) ;; 
	 (?\x20AC . bidi-category-et) ;; 
	 (?\x20AD . bidi-category-et) ;; 
	 (?\x20AE . bidi-category-et) ;; 
	 (?\x20AF . bidi-category-et) ;; 
	 (?\x20D0 . bidi-category-nsm) ;; NON-SPACING LEFT HARPOON ABOVE
	 (?\x20D1 . bidi-category-nsm) ;; NON-SPACING RIGHT HARPOON ABOVE
	 (?\x20D2 . bidi-category-nsm) ;; NON-SPACING LONG VERTICAL BAR OVERLAY
	 (?\x20D3 . bidi-category-nsm) ;; NON-SPACING SHORT VERTICAL BAR OVERLAY
	 (?\x20D4 . bidi-category-nsm) ;; NON-SPACING ANTICLOCKWISE ARROW ABOVE
	 (?\x20D5 . bidi-category-nsm) ;; NON-SPACING CLOCKWISE ARROW ABOVE
	 (?\x20D6 . bidi-category-nsm) ;; NON-SPACING LEFT ARROW ABOVE
	 (?\x20D7 . bidi-category-nsm) ;; NON-SPACING RIGHT ARROW ABOVE
	 (?\x20D8 . bidi-category-nsm) ;; NON-SPACING RING OVERLAY
	 (?\x20D9 . bidi-category-nsm) ;; NON-SPACING CLOCKWISE RING OVERLAY
	 (?\x20DA . bidi-category-nsm) ;; NON-SPACING ANTICLOCKWISE RING OVERLAY
	 (?\x20DB . bidi-category-nsm) ;; NON-SPACING THREE DOTS ABOVE
	 (?\x20DC . bidi-category-nsm) ;; NON-SPACING FOUR DOTS ABOVE
	 (?\x20DD . bidi-category-nsm) ;; ENCLOSING CIRCLE
	 (?\x20DE . bidi-category-nsm) ;; ENCLOSING SQUARE
	 (?\x20DF . bidi-category-nsm) ;; ENCLOSING DIAMOND
	 (?\x20E0 . bidi-category-nsm) ;; ENCLOSING CIRCLE SLASH
	 (?\x20E1 . bidi-category-nsm) ;; NON-SPACING LEFT RIGHT ARROW ABOVE
	 (?\x20E2 . bidi-category-nsm) ;; 
	 (?\x20E3 . bidi-category-nsm) ;; 
	 (?\x2100 . bidi-category-on) ;; 
	 (?\x2101 . bidi-category-on) ;; 
	 (?\x2102 . bidi-category-l) ;; DOUBLE-STRUCK C
	 (?\x2103 . bidi-category-on) ;; DEGREES CENTIGRADE
	 (?\x2104 . bidi-category-on) ;; C L SYMBOL
	 (?\x2105 . bidi-category-on) ;; 
	 (?\x2106 . bidi-category-on) ;; 
	 (?\x2107 . bidi-category-l) ;; EULERS
	 (?\x2108 . bidi-category-on) ;; 
	 (?\x2109 . bidi-category-on) ;; DEGREES FAHRENHEIT
	 (?\x210A . bidi-category-l) ;; 
	 (?\x210B . bidi-category-l) ;; SCRIPT H
	 (?\x210C . bidi-category-l) ;; BLACK-LETTER H
	 (?\x210D . bidi-category-l) ;; DOUBLE-STRUCK H
	 (?\x210E . bidi-category-l) ;; 
	 (?\x210F . bidi-category-l) ;; PLANCK CONSTANT OVER 2 PI
	 (?\x2110 . bidi-category-l) ;; SCRIPT I
	 (?\x2111 . bidi-category-l) ;; BLACK-LETTER I
	 (?\x2112 . bidi-category-l) ;; SCRIPT L
	 (?\x2113 . bidi-category-l) ;; 
	 (?\x2114 . bidi-category-on) ;; 
	 (?\x2115 . bidi-category-l) ;; DOUBLE-STRUCK N
	 (?\x2116 . bidi-category-on) ;; NUMERO
	 (?\x2117 . bidi-category-on) ;; 
	 (?\x2118 . bidi-category-on) ;; SCRIPT P
	 (?\x2119 . bidi-category-l) ;; DOUBLE-STRUCK P
	 (?\x211A . bidi-category-l) ;; DOUBLE-STRUCK Q
	 (?\x211B . bidi-category-l) ;; SCRIPT R
	 (?\x211C . bidi-category-l) ;; BLACK-LETTER R
	 (?\x211D . bidi-category-l) ;; DOUBLE-STRUCK R
	 (?\x211E . bidi-category-on) ;; 
	 (?\x211F . bidi-category-on) ;; 
	 (?\x2120 . bidi-category-on) ;; 
	 (?\x2121 . bidi-category-on) ;; T E L SYMBOL
	 (?\x2122 . bidi-category-on) ;; TRADEMARK
	 (?\x2123 . bidi-category-on) ;; 
	 (?\x2124 . bidi-category-l) ;; DOUBLE-STRUCK Z
	 (?\x2125 . bidi-category-on) ;; OUNCE
	 (?\x2126 . bidi-category-l) ;; OHM
	 (?\x2127 . bidi-category-on) ;; MHO
	 (?\x2128 . bidi-category-l) ;; BLACK-LETTER Z
	 (?\x2129 . bidi-category-on) ;; 
	 (?\x212A . bidi-category-l) ;; DEGREES KELVIN
	 (?\x212B . bidi-category-l) ;; ANGSTROM UNIT
	 (?\x212C . bidi-category-l) ;; SCRIPT B
	 (?\x212D . bidi-category-l) ;; BLACK-LETTER C
	 (?\x212E . bidi-category-et) ;; 
	 (?\x212F . bidi-category-l) ;; 
	 (?\x2130 . bidi-category-l) ;; SCRIPT E
	 (?\x2131 . bidi-category-l) ;; SCRIPT F
	 (?\x2132 . bidi-category-on) ;; TURNED F
	 (?\x2133 . bidi-category-l) ;; SCRIPT M
	 (?\x2134 . bidi-category-l) ;; 
	 (?\x2135 . bidi-category-l) ;; FIRST TRANSFINITE CARDINAL
	 (?\x2136 . bidi-category-l) ;; SECOND TRANSFINITE CARDINAL
	 (?\x2137 . bidi-category-l) ;; THIRD TRANSFINITE CARDINAL
	 (?\x2138 . bidi-category-l) ;; FOURTH TRANSFINITE CARDINAL
	 (?\x2139 . bidi-category-l) ;; 
	 (?\x213A . bidi-category-on) ;; 
	 (?\x2153 . bidi-category-on) ;; FRACTION ONE THIRD
	 (?\x2154 . bidi-category-on) ;; FRACTION TWO THIRDS
	 (?\x2155 . bidi-category-on) ;; FRACTION ONE FIFTH
	 (?\x2156 . bidi-category-on) ;; FRACTION TWO FIFTHS
	 (?\x2157 . bidi-category-on) ;; FRACTION THREE FIFTHS
	 (?\x2158 . bidi-category-on) ;; FRACTION FOUR FIFTHS
	 (?\x2159 . bidi-category-on) ;; FRACTION ONE SIXTH
	 (?\x215A . bidi-category-on) ;; FRACTION FIVE SIXTHS
	 (?\x215B . bidi-category-on) ;; FRACTION ONE EIGHTH
	 (?\x215C . bidi-category-on) ;; FRACTION THREE EIGHTHS
	 (?\x215D . bidi-category-on) ;; FRACTION FIVE EIGHTHS
	 (?\x215E . bidi-category-on) ;; FRACTION SEVEN EIGHTHS
	 (?\x215F . bidi-category-on) ;; 
	 (?\x2160 . bidi-category-l) ;; 
	 (?\x2161 . bidi-category-l) ;; 
	 (?\x2162 . bidi-category-l) ;; 
	 (?\x2163 . bidi-category-l) ;; 
	 (?\x2164 . bidi-category-l) ;; 
	 (?\x2165 . bidi-category-l) ;; 
	 (?\x2166 . bidi-category-l) ;; 
	 (?\x2167 . bidi-category-l) ;; 
	 (?\x2168 . bidi-category-l) ;; 
	 (?\x2169 . bidi-category-l) ;; 
	 (?\x216A . bidi-category-l) ;; 
	 (?\x216B . bidi-category-l) ;; 
	 (?\x216C . bidi-category-l) ;; 
	 (?\x216D . bidi-category-l) ;; 
	 (?\x216E . bidi-category-l) ;; 
	 (?\x216F . bidi-category-l) ;; 
	 (?\x2170 . bidi-category-l) ;; 
	 (?\x2171 . bidi-category-l) ;; 
	 (?\x2172 . bidi-category-l) ;; 
	 (?\x2173 . bidi-category-l) ;; 
	 (?\x2174 . bidi-category-l) ;; 
	 (?\x2175 . bidi-category-l) ;; 
	 (?\x2176 . bidi-category-l) ;; 
	 (?\x2177 . bidi-category-l) ;; 
	 (?\x2178 . bidi-category-l) ;; 
	 (?\x2179 . bidi-category-l) ;; 
	 (?\x217A . bidi-category-l) ;; 
	 (?\x217B . bidi-category-l) ;; 
	 (?\x217C . bidi-category-l) ;; 
	 (?\x217D . bidi-category-l) ;; 
	 (?\x217E . bidi-category-l) ;; 
	 (?\x217F . bidi-category-l) ;; 
	 (?\x2180 . bidi-category-l) ;; 
	 (?\x2181 . bidi-category-l) ;; 
	 (?\x2182 . bidi-category-l) ;; 
	 (?\x2183 . bidi-category-l) ;; 
	 (?\x2190 . bidi-category-on) ;; LEFT ARROW
	 (?\x2191 . bidi-category-on) ;; UP ARROW
	 (?\x2192 . bidi-category-on) ;; RIGHT ARROW
	 (?\x2193 . bidi-category-on) ;; DOWN ARROW
	 (?\x2194 . bidi-category-on) ;; 
	 (?\x2195 . bidi-category-on) ;; 
	 (?\x2196 . bidi-category-on) ;; UPPER LEFT ARROW
	 (?\x2197 . bidi-category-on) ;; UPPER RIGHT ARROW
	 (?\x2198 . bidi-category-on) ;; LOWER RIGHT ARROW
	 (?\x2199 . bidi-category-on) ;; LOWER LEFT ARROW
	 (?\x219A . bidi-category-on) ;; LEFT ARROW WITH STROKE
	 (?\x219B . bidi-category-on) ;; RIGHT ARROW WITH STROKE
	 (?\x219C . bidi-category-on) ;; LEFT WAVE ARROW
	 (?\x219D . bidi-category-on) ;; RIGHT WAVE ARROW
	 (?\x219E . bidi-category-on) ;; LEFT TWO HEADED ARROW
	 (?\x219F . bidi-category-on) ;; UP TWO HEADED ARROW
	 (?\x21A0 . bidi-category-on) ;; RIGHT TWO HEADED ARROW
	 (?\x21A1 . bidi-category-on) ;; DOWN TWO HEADED ARROW
	 (?\x21A2 . bidi-category-on) ;; LEFT ARROW WITH TAIL
	 (?\x21A3 . bidi-category-on) ;; RIGHT ARROW WITH TAIL
	 (?\x21A4 . bidi-category-on) ;; LEFT ARROW FROM BAR
	 (?\x21A5 . bidi-category-on) ;; UP ARROW FROM BAR
	 (?\x21A6 . bidi-category-on) ;; RIGHT ARROW FROM BAR
	 (?\x21A7 . bidi-category-on) ;; DOWN ARROW FROM BAR
	 (?\x21A8 . bidi-category-on) ;; 
	 (?\x21A9 . bidi-category-on) ;; LEFT ARROW WITH HOOK
	 (?\x21AA . bidi-category-on) ;; RIGHT ARROW WITH HOOK
	 (?\x21AB . bidi-category-on) ;; LEFT ARROW WITH LOOP
	 (?\x21AC . bidi-category-on) ;; RIGHT ARROW WITH LOOP
	 (?\x21AD . bidi-category-on) ;; 
	 (?\x21AE . bidi-category-on) ;; 
	 (?\x21AF . bidi-category-on) ;; DOWN ZIGZAG ARROW
	 (?\x21B0 . bidi-category-on) ;; UP ARROW WITH TIP LEFT
	 (?\x21B1 . bidi-category-on) ;; UP ARROW WITH TIP RIGHT
	 (?\x21B2 . bidi-category-on) ;; DOWN ARROW WITH TIP LEFT
	 (?\x21B3 . bidi-category-on) ;; DOWN ARROW WITH TIP RIGHT
	 (?\x21B4 . bidi-category-on) ;; RIGHT ARROW WITH CORNER DOWN
	 (?\x21B5 . bidi-category-on) ;; DOWN ARROW WITH CORNER LEFT
	 (?\x21B6 . bidi-category-on) ;; 
	 (?\x21B7 . bidi-category-on) ;; 
	 (?\x21B8 . bidi-category-on) ;; UPPER LEFT ARROW TO LONG BAR
	 (?\x21B9 . bidi-category-on) ;; LEFT ARROW TO BAR OVER RIGHT ARROW TO BAR
	 (?\x21BA . bidi-category-on) ;; 
	 (?\x21BB . bidi-category-on) ;; 
	 (?\x21BC . bidi-category-on) ;; LEFT HARPOON WITH BARB UP
	 (?\x21BD . bidi-category-on) ;; LEFT HARPOON WITH BARB DOWN
	 (?\x21BE . bidi-category-on) ;; UP HARPOON WITH BARB RIGHT
	 (?\x21BF . bidi-category-on) ;; UP HARPOON WITH BARB LEFT
	 (?\x21C0 . bidi-category-on) ;; RIGHT HARPOON WITH BARB UP
	 (?\x21C1 . bidi-category-on) ;; RIGHT HARPOON WITH BARB DOWN
	 (?\x21C2 . bidi-category-on) ;; DOWN HARPOON WITH BARB RIGHT
	 (?\x21C3 . bidi-category-on) ;; DOWN HARPOON WITH BARB LEFT
	 (?\x21C4 . bidi-category-on) ;; RIGHT ARROW OVER LEFT ARROW
	 (?\x21C5 . bidi-category-on) ;; UP ARROW LEFT OF DOWN ARROW
	 (?\x21C6 . bidi-category-on) ;; LEFT ARROW OVER RIGHT ARROW
	 (?\x21C7 . bidi-category-on) ;; LEFT PAIRED ARROWS
	 (?\x21C8 . bidi-category-on) ;; UP PAIRED ARROWS
	 (?\x21C9 . bidi-category-on) ;; RIGHT PAIRED ARROWS
	 (?\x21CA . bidi-category-on) ;; DOWN PAIRED ARROWS
	 (?\x21CB . bidi-category-on) ;; LEFT HARPOON OVER RIGHT HARPOON
	 (?\x21CC . bidi-category-on) ;; RIGHT HARPOON OVER LEFT HARPOON
	 (?\x21CD . bidi-category-on) ;; LEFT DOUBLE ARROW WITH STROKE
	 (?\x21CE . bidi-category-on) ;; 
	 (?\x21CF . bidi-category-on) ;; RIGHT DOUBLE ARROW WITH STROKE
	 (?\x21D0 . bidi-category-on) ;; LEFT DOUBLE ARROW
	 (?\x21D1 . bidi-category-on) ;; UP DOUBLE ARROW
	 (?\x21D2 . bidi-category-on) ;; RIGHT DOUBLE ARROW
	 (?\x21D3 . bidi-category-on) ;; DOWN DOUBLE ARROW
	 (?\x21D4 . bidi-category-on) ;; 
	 (?\x21D5 . bidi-category-on) ;; 
	 (?\x21D6 . bidi-category-on) ;; UPPER LEFT DOUBLE ARROW
	 (?\x21D7 . bidi-category-on) ;; UPPER RIGHT DOUBLE ARROW
	 (?\x21D8 . bidi-category-on) ;; LOWER RIGHT DOUBLE ARROW
	 (?\x21D9 . bidi-category-on) ;; LOWER LEFT DOUBLE ARROW
	 (?\x21DA . bidi-category-on) ;; LEFT TRIPLE ARROW
	 (?\x21DB . bidi-category-on) ;; RIGHT TRIPLE ARROW
	 (?\x21DC . bidi-category-on) ;; LEFT SQUIGGLE ARROW
	 (?\x21DD . bidi-category-on) ;; RIGHT SQUIGGLE ARROW
	 (?\x21DE . bidi-category-on) ;; UP ARROW WITH DOUBLE STROKE
	 (?\x21DF . bidi-category-on) ;; DOWN ARROW WITH DOUBLE STROKE
	 (?\x21E0 . bidi-category-on) ;; LEFT DASHED ARROW
	 (?\x21E1 . bidi-category-on) ;; UP DASHED ARROW
	 (?\x21E2 . bidi-category-on) ;; RIGHT DASHED ARROW
	 (?\x21E3 . bidi-category-on) ;; DOWN DASHED ARROW
	 (?\x21E4 . bidi-category-on) ;; LEFT ARROW TO BAR
	 (?\x21E5 . bidi-category-on) ;; RIGHT ARROW TO BAR
	 (?\x21E6 . bidi-category-on) ;; WHITE LEFT ARROW
	 (?\x21E7 . bidi-category-on) ;; WHITE UP ARROW
	 (?\x21E8 . bidi-category-on) ;; WHITE RIGHT ARROW
	 (?\x21E9 . bidi-category-on) ;; WHITE DOWN ARROW
	 (?\x21EA . bidi-category-on) ;; WHITE UP ARROW FROM BAR
	 (?\x21EB . bidi-category-on) ;; 
	 (?\x21EC . bidi-category-on) ;; 
	 (?\x21ED . bidi-category-on) ;; 
	 (?\x21EE . bidi-category-on) ;; 
	 (?\x21EF . bidi-category-on) ;; 
	 (?\x21F0 . bidi-category-on) ;; 
	 (?\x21F1 . bidi-category-on) ;; 
	 (?\x21F2 . bidi-category-on) ;; 
	 (?\x21F3 . bidi-category-on) ;; 
	 (?\x2200 . bidi-category-on) ;; 
	 (?\x2201 . bidi-category-on) ;; 
	 (?\x2202 . bidi-category-on) ;; 
	 (?\x2203 . bidi-category-on) ;; 
	 (?\x2204 . bidi-category-on) ;; 
	 (?\x2205 . bidi-category-on) ;; 
	 (?\x2206 . bidi-category-on) ;; 
	 (?\x2207 . bidi-category-on) ;; 
	 (?\x2208 . bidi-category-on) ;; 
	 (?\x2209 . bidi-category-on) ;; 
	 (?\x220A . bidi-category-on) ;; 
	 (?\x220B . bidi-category-on) ;; 
	 (?\x220C . bidi-category-on) ;; 
	 (?\x220D . bidi-category-on) ;; 
	 (?\x220E . bidi-category-on) ;; 
	 (?\x220F . bidi-category-on) ;; 
	 (?\x2210 . bidi-category-on) ;; 
	 (?\x2211 . bidi-category-on) ;; 
	 (?\x2212 . bidi-category-et) ;; 
	 (?\x2213 . bidi-category-et) ;; 
	 (?\x2214 . bidi-category-on) ;; 
	 (?\x2215 . bidi-category-on) ;; 
	 (?\x2216 . bidi-category-on) ;; 
	 (?\x2217 . bidi-category-on) ;; 
	 (?\x2218 . bidi-category-on) ;; 
	 (?\x2219 . bidi-category-on) ;; 
	 (?\x221A . bidi-category-on) ;; 
	 (?\x221B . bidi-category-on) ;; 
	 (?\x221C . bidi-category-on) ;; 
	 (?\x221D . bidi-category-on) ;; 
	 (?\x221E . bidi-category-on) ;; 
	 (?\x221F . bidi-category-on) ;; 
	 (?\x2220 . bidi-category-on) ;; 
	 (?\x2221 . bidi-category-on) ;; 
	 (?\x2222 . bidi-category-on) ;; 
	 (?\x2223 . bidi-category-on) ;; 
	 (?\x2224 . bidi-category-on) ;; 
	 (?\x2225 . bidi-category-on) ;; 
	 (?\x2226 . bidi-category-on) ;; 
	 (?\x2227 . bidi-category-on) ;; 
	 (?\x2228 . bidi-category-on) ;; 
	 (?\x2229 . bidi-category-on) ;; 
	 (?\x222A . bidi-category-on) ;; 
	 (?\x222B . bidi-category-on) ;; 
	 (?\x222C . bidi-category-on) ;; 
	 (?\x222D . bidi-category-on) ;; 
	 (?\x222E . bidi-category-on) ;; 
	 (?\x222F . bidi-category-on) ;; 
	 (?\x2230 . bidi-category-on) ;; 
	 (?\x2231 . bidi-category-on) ;; 
	 (?\x2232 . bidi-category-on) ;; 
	 (?\x2233 . bidi-category-on) ;; 
	 (?\x2234 . bidi-category-on) ;; 
	 (?\x2235 . bidi-category-on) ;; 
	 (?\x2236 . bidi-category-on) ;; 
	 (?\x2237 . bidi-category-on) ;; 
	 (?\x2238 . bidi-category-on) ;; 
	 (?\x2239 . bidi-category-on) ;; 
	 (?\x223A . bidi-category-on) ;; 
	 (?\x223B . bidi-category-on) ;; 
	 (?\x223C . bidi-category-on) ;; 
	 (?\x223D . bidi-category-on) ;; 
	 (?\x223E . bidi-category-on) ;; 
	 (?\x223F . bidi-category-on) ;; 
	 (?\x2240 . bidi-category-on) ;; 
	 (?\x2241 . bidi-category-on) ;; 
	 (?\x2242 . bidi-category-on) ;; 
	 (?\x2243 . bidi-category-on) ;; 
	 (?\x2244 . bidi-category-on) ;; 
	 (?\x2245 . bidi-category-on) ;; 
	 (?\x2246 . bidi-category-on) ;; 
	 (?\x2247 . bidi-category-on) ;; 
	 (?\x2248 . bidi-category-on) ;; 
	 (?\x2249 . bidi-category-on) ;; 
	 (?\x224A . bidi-category-on) ;; 
	 (?\x224B . bidi-category-on) ;; 
	 (?\x224C . bidi-category-on) ;; 
	 (?\x224D . bidi-category-on) ;; 
	 (?\x224E . bidi-category-on) ;; 
	 (?\x224F . bidi-category-on) ;; 
	 (?\x2250 . bidi-category-on) ;; 
	 (?\x2251 . bidi-category-on) ;; 
	 (?\x2252 . bidi-category-on) ;; 
	 (?\x2253 . bidi-category-on) ;; 
	 (?\x2254 . bidi-category-on) ;; COLON EQUAL
	 (?\x2255 . bidi-category-on) ;; EQUAL COLON
	 (?\x2256 . bidi-category-on) ;; 
	 (?\x2257 . bidi-category-on) ;; 
	 (?\x2258 . bidi-category-on) ;; 
	 (?\x2259 . bidi-category-on) ;; 
	 (?\x225A . bidi-category-on) ;; 
	 (?\x225B . bidi-category-on) ;; 
	 (?\x225C . bidi-category-on) ;; 
	 (?\x225D . bidi-category-on) ;; 
	 (?\x225E . bidi-category-on) ;; 
	 (?\x225F . bidi-category-on) ;; 
	 (?\x2260 . bidi-category-on) ;; 
	 (?\x2261 . bidi-category-on) ;; 
	 (?\x2262 . bidi-category-on) ;; 
	 (?\x2263 . bidi-category-on) ;; 
	 (?\x2264 . bidi-category-on) ;; LESS THAN OR EQUAL TO
	 (?\x2265 . bidi-category-on) ;; GREATER THAN OR EQUAL TO
	 (?\x2266 . bidi-category-on) ;; LESS THAN OVER EQUAL TO
	 (?\x2267 . bidi-category-on) ;; GREATER THAN OVER EQUAL TO
	 (?\x2268 . bidi-category-on) ;; LESS THAN BUT NOT EQUAL TO
	 (?\x2269 . bidi-category-on) ;; GREATER THAN BUT NOT EQUAL TO
	 (?\x226A . bidi-category-on) ;; MUCH LESS THAN
	 (?\x226B . bidi-category-on) ;; MUCH GREATER THAN
	 (?\x226C . bidi-category-on) ;; 
	 (?\x226D . bidi-category-on) ;; 
	 (?\x226E . bidi-category-on) ;; NOT LESS THAN
	 (?\x226F . bidi-category-on) ;; NOT GREATER THAN
	 (?\x2270 . bidi-category-on) ;; NEITHER LESS THAN NOR EQUAL TO
	 (?\x2271 . bidi-category-on) ;; NEITHER GREATER THAN NOR EQUAL TO
	 (?\x2272 . bidi-category-on) ;; LESS THAN OR EQUIVALENT TO
	 (?\x2273 . bidi-category-on) ;; GREATER THAN OR EQUIVALENT TO
	 (?\x2274 . bidi-category-on) ;; NEITHER LESS THAN NOR EQUIVALENT TO
	 (?\x2275 . bidi-category-on) ;; NEITHER GREATER THAN NOR EQUIVALENT TO
	 (?\x2276 . bidi-category-on) ;; LESS THAN OR GREATER THAN
	 (?\x2277 . bidi-category-on) ;; GREATER THAN OR LESS THAN
	 (?\x2278 . bidi-category-on) ;; NEITHER LESS THAN NOR GREATER THAN
	 (?\x2279 . bidi-category-on) ;; NEITHER GREATER THAN NOR LESS THAN
	 (?\x227A . bidi-category-on) ;; 
	 (?\x227B . bidi-category-on) ;; 
	 (?\x227C . bidi-category-on) ;; 
	 (?\x227D . bidi-category-on) ;; 
	 (?\x227E . bidi-category-on) ;; 
	 (?\x227F . bidi-category-on) ;; 
	 (?\x2280 . bidi-category-on) ;; 
	 (?\x2281 . bidi-category-on) ;; 
	 (?\x2282 . bidi-category-on) ;; 
	 (?\x2283 . bidi-category-on) ;; 
	 (?\x2284 . bidi-category-on) ;; 
	 (?\x2285 . bidi-category-on) ;; 
	 (?\x2286 . bidi-category-on) ;; 
	 (?\x2287 . bidi-category-on) ;; 
	 (?\x2288 . bidi-category-on) ;; 
	 (?\x2289 . bidi-category-on) ;; 
	 (?\x228A . bidi-category-on) ;; SUBSET OF OR NOT EQUAL TO
	 (?\x228B . bidi-category-on) ;; SUPERSET OF OR NOT EQUAL TO
	 (?\x228C . bidi-category-on) ;; 
	 (?\x228D . bidi-category-on) ;; 
	 (?\x228E . bidi-category-on) ;; 
	 (?\x228F . bidi-category-on) ;; 
	 (?\x2290 . bidi-category-on) ;; 
	 (?\x2291 . bidi-category-on) ;; 
	 (?\x2292 . bidi-category-on) ;; 
	 (?\x2293 . bidi-category-on) ;; 
	 (?\x2294 . bidi-category-on) ;; 
	 (?\x2295 . bidi-category-on) ;; 
	 (?\x2296 . bidi-category-on) ;; 
	 (?\x2297 . bidi-category-on) ;; 
	 (?\x2298 . bidi-category-on) ;; 
	 (?\x2299 . bidi-category-on) ;; 
	 (?\x229A . bidi-category-on) ;; 
	 (?\x229B . bidi-category-on) ;; 
	 (?\x229C . bidi-category-on) ;; 
	 (?\x229D . bidi-category-on) ;; 
	 (?\x229E . bidi-category-on) ;; 
	 (?\x229F . bidi-category-on) ;; 
	 (?\x22A0 . bidi-category-on) ;; 
	 (?\x22A1 . bidi-category-on) ;; 
	 (?\x22A2 . bidi-category-on) ;; 
	 (?\x22A3 . bidi-category-on) ;; 
	 (?\x22A4 . bidi-category-on) ;; 
	 (?\x22A5 . bidi-category-on) ;; 
	 (?\x22A6 . bidi-category-on) ;; 
	 (?\x22A7 . bidi-category-on) ;; 
	 (?\x22A8 . bidi-category-on) ;; 
	 (?\x22A9 . bidi-category-on) ;; 
	 (?\x22AA . bidi-category-on) ;; 
	 (?\x22AB . bidi-category-on) ;; 
	 (?\x22AC . bidi-category-on) ;; 
	 (?\x22AD . bidi-category-on) ;; 
	 (?\x22AE . bidi-category-on) ;; 
	 (?\x22AF . bidi-category-on) ;; 
	 (?\x22B0 . bidi-category-on) ;; 
	 (?\x22B1 . bidi-category-on) ;; 
	 (?\x22B2 . bidi-category-on) ;; 
	 (?\x22B3 . bidi-category-on) ;; 
	 (?\x22B4 . bidi-category-on) ;; 
	 (?\x22B5 . bidi-category-on) ;; 
	 (?\x22B6 . bidi-category-on) ;; 
	 (?\x22B7 . bidi-category-on) ;; 
	 (?\x22B8 . bidi-category-on) ;; 
	 (?\x22B9 . bidi-category-on) ;; 
	 (?\x22BA . bidi-category-on) ;; 
	 (?\x22BB . bidi-category-on) ;; 
	 (?\x22BC . bidi-category-on) ;; 
	 (?\x22BD . bidi-category-on) ;; 
	 (?\x22BE . bidi-category-on) ;; 
	 (?\x22BF . bidi-category-on) ;; 
	 (?\x22C0 . bidi-category-on) ;; 
	 (?\x22C1 . bidi-category-on) ;; 
	 (?\x22C2 . bidi-category-on) ;; 
	 (?\x22C3 . bidi-category-on) ;; 
	 (?\x22C4 . bidi-category-on) ;; 
	 (?\x22C5 . bidi-category-on) ;; 
	 (?\x22C6 . bidi-category-on) ;; 
	 (?\x22C7 . bidi-category-on) ;; 
	 (?\x22C8 . bidi-category-on) ;; 
	 (?\x22C9 . bidi-category-on) ;; 
	 (?\x22CA . bidi-category-on) ;; 
	 (?\x22CB . bidi-category-on) ;; 
	 (?\x22CC . bidi-category-on) ;; 
	 (?\x22CD . bidi-category-on) ;; 
	 (?\x22CE . bidi-category-on) ;; 
	 (?\x22CF . bidi-category-on) ;; 
	 (?\x22D0 . bidi-category-on) ;; 
	 (?\x22D1 . bidi-category-on) ;; 
	 (?\x22D2 . bidi-category-on) ;; 
	 (?\x22D3 . bidi-category-on) ;; 
	 (?\x22D4 . bidi-category-on) ;; 
	 (?\x22D5 . bidi-category-on) ;; 
	 (?\x22D6 . bidi-category-on) ;; LESS THAN WITH DOT
	 (?\x22D7 . bidi-category-on) ;; GREATER THAN WITH DOT
	 (?\x22D8 . bidi-category-on) ;; VERY MUCH LESS THAN
	 (?\x22D9 . bidi-category-on) ;; VERY MUCH GREATER THAN
	 (?\x22DA . bidi-category-on) ;; LESS THAN EQUAL TO OR GREATER THAN
	 (?\x22DB . bidi-category-on) ;; GREATER THAN EQUAL TO OR LESS THAN
	 (?\x22DC . bidi-category-on) ;; EQUAL TO OR LESS THAN
	 (?\x22DD . bidi-category-on) ;; EQUAL TO OR GREATER THAN
	 (?\x22DE . bidi-category-on) ;; 
	 (?\x22DF . bidi-category-on) ;; 
	 (?\x22E0 . bidi-category-on) ;; 
	 (?\x22E1 . bidi-category-on) ;; 
	 (?\x22E2 . bidi-category-on) ;; 
	 (?\x22E3 . bidi-category-on) ;; 
	 (?\x22E4 . bidi-category-on) ;; 
	 (?\x22E5 . bidi-category-on) ;; 
	 (?\x22E6 . bidi-category-on) ;; LESS THAN BUT NOT EQUIVALENT TO
	 (?\x22E7 . bidi-category-on) ;; GREATER THAN BUT NOT EQUIVALENT TO
	 (?\x22E8 . bidi-category-on) ;; 
	 (?\x22E9 . bidi-category-on) ;; 
	 (?\x22EA . bidi-category-on) ;; 
	 (?\x22EB . bidi-category-on) ;; 
	 (?\x22EC . bidi-category-on) ;; 
	 (?\x22ED . bidi-category-on) ;; 
	 (?\x22EE . bidi-category-on) ;; 
	 (?\x22EF . bidi-category-on) ;; 
	 (?\x22F0 . bidi-category-on) ;; 
	 (?\x22F1 . bidi-category-on) ;; 
	 (?\x2300 . bidi-category-on) ;; 
	 (?\x2301 . bidi-category-on) ;; 
	 (?\x2302 . bidi-category-on) ;; 
	 (?\x2303 . bidi-category-on) ;; 
	 (?\x2304 . bidi-category-on) ;; 
	 (?\x2305 . bidi-category-on) ;; 
	 (?\x2306 . bidi-category-on) ;; 
	 (?\x2307 . bidi-category-on) ;; 
	 (?\x2308 . bidi-category-on) ;; 
	 (?\x2309 . bidi-category-on) ;; 
	 (?\x230A . bidi-category-on) ;; 
	 (?\x230B . bidi-category-on) ;; 
	 (?\x230C . bidi-category-on) ;; 
	 (?\x230D . bidi-category-on) ;; 
	 (?\x230E . bidi-category-on) ;; 
	 (?\x230F . bidi-category-on) ;; 
	 (?\x2310 . bidi-category-on) ;; 
	 (?\x2311 . bidi-category-on) ;; 
	 (?\x2312 . bidi-category-on) ;; 
	 (?\x2313 . bidi-category-on) ;; 
	 (?\x2314 . bidi-category-on) ;; 
	 (?\x2315 . bidi-category-on) ;; 
	 (?\x2316 . bidi-category-on) ;; 
	 (?\x2317 . bidi-category-on) ;; 
	 (?\x2318 . bidi-category-on) ;; COMMAND KEY
	 (?\x2319 . bidi-category-on) ;; 
	 (?\x231A . bidi-category-on) ;; 
	 (?\x231B . bidi-category-on) ;; 
	 (?\x231C . bidi-category-on) ;; 
	 (?\x231D . bidi-category-on) ;; 
	 (?\x231E . bidi-category-on) ;; 
	 (?\x231F . bidi-category-on) ;; 
	 (?\x2320 . bidi-category-on) ;; 
	 (?\x2321 . bidi-category-on) ;; 
	 (?\x2322 . bidi-category-on) ;; 
	 (?\x2323 . bidi-category-on) ;; 
	 (?\x2324 . bidi-category-on) ;; ENTER KEY
	 (?\x2325 . bidi-category-on) ;; 
	 (?\x2326 . bidi-category-on) ;; DELETE TO THE RIGHT KEY
	 (?\x2327 . bidi-category-on) ;; CLEAR KEY
	 (?\x2328 . bidi-category-on) ;; 
	 (?\x2329 . bidi-category-on) ;; BRA
	 (?\x232A . bidi-category-on) ;; KET
	 (?\x232B . bidi-category-on) ;; DELETE TO THE LEFT KEY
	 (?\x232C . bidi-category-on) ;; 
	 (?\x232D . bidi-category-on) ;; 
	 (?\x232E . bidi-category-on) ;; 
	 (?\x232F . bidi-category-on) ;; 
	 (?\x2330 . bidi-category-on) ;; 
	 (?\x2331 . bidi-category-on) ;; 
	 (?\x2332 . bidi-category-on) ;; 
	 (?\x2333 . bidi-category-on) ;; 
	 (?\x2334 . bidi-category-on) ;; 
	 (?\x2335 . bidi-category-on) ;; 
	 (?\x2336 . bidi-category-l) ;; 
	 (?\x2337 . bidi-category-l) ;; 
	 (?\x2338 . bidi-category-l) ;; 
	 (?\x2339 . bidi-category-l) ;; 
	 (?\x233A . bidi-category-l) ;; 
	 (?\x233B . bidi-category-l) ;; 
	 (?\x233C . bidi-category-l) ;; 
	 (?\x233D . bidi-category-l) ;; 
	 (?\x233E . bidi-category-l) ;; 
	 (?\x233F . bidi-category-l) ;; 
	 (?\x2340 . bidi-category-l) ;; 
	 (?\x2341 . bidi-category-l) ;; 
	 (?\x2342 . bidi-category-l) ;; 
	 (?\x2343 . bidi-category-l) ;; 
	 (?\x2344 . bidi-category-l) ;; 
	 (?\x2345 . bidi-category-l) ;; 
	 (?\x2346 . bidi-category-l) ;; 
	 (?\x2347 . bidi-category-l) ;; 
	 (?\x2348 . bidi-category-l) ;; 
	 (?\x2349 . bidi-category-l) ;; 
	 (?\x234A . bidi-category-l) ;; 
	 (?\x234B . bidi-category-l) ;; 
	 (?\x234C . bidi-category-l) ;; 
	 (?\x234D . bidi-category-l) ;; 
	 (?\x234E . bidi-category-l) ;; 
	 (?\x234F . bidi-category-l) ;; 
	 (?\x2350 . bidi-category-l) ;; 
	 (?\x2351 . bidi-category-l) ;; 
	 (?\x2352 . bidi-category-l) ;; 
	 (?\x2353 . bidi-category-l) ;; 
	 (?\x2354 . bidi-category-l) ;; 
	 (?\x2355 . bidi-category-l) ;; 
	 (?\x2356 . bidi-category-l) ;; 
	 (?\x2357 . bidi-category-l) ;; 
	 (?\x2358 . bidi-category-l) ;; 
	 (?\x2359 . bidi-category-l) ;; 
	 (?\x235A . bidi-category-l) ;; 
	 (?\x235B . bidi-category-l) ;; 
	 (?\x235C . bidi-category-l) ;; 
	 (?\x235D . bidi-category-l) ;; 
	 (?\x235E . bidi-category-l) ;; 
	 (?\x235F . bidi-category-l) ;; 
	 (?\x2360 . bidi-category-l) ;; 
	 (?\x2361 . bidi-category-l) ;; 
	 (?\x2362 . bidi-category-l) ;; 
	 (?\x2363 . bidi-category-l) ;; 
	 (?\x2364 . bidi-category-l) ;; 
	 (?\x2365 . bidi-category-l) ;; 
	 (?\x2366 . bidi-category-l) ;; 
	 (?\x2367 . bidi-category-l) ;; 
	 (?\x2368 . bidi-category-l) ;; 
	 (?\x2369 . bidi-category-l) ;; 
	 (?\x236A . bidi-category-l) ;; 
	 (?\x236B . bidi-category-l) ;; 
	 (?\x236C . bidi-category-l) ;; 
	 (?\x236D . bidi-category-l) ;; 
	 (?\x236E . bidi-category-l) ;; 
	 (?\x236F . bidi-category-l) ;; 
	 (?\x2370 . bidi-category-l) ;; 
	 (?\x2371 . bidi-category-l) ;; 
	 (?\x2372 . bidi-category-l) ;; 
	 (?\x2373 . bidi-category-l) ;; 
	 (?\x2374 . bidi-category-l) ;; 
	 (?\x2375 . bidi-category-l) ;; 
	 (?\x2376 . bidi-category-l) ;; 
	 (?\x2377 . bidi-category-l) ;; 
	 (?\x2378 . bidi-category-l) ;; 
	 (?\x2379 . bidi-category-l) ;; 
	 (?\x237A . bidi-category-l) ;; 
	 (?\x237B . bidi-category-on) ;; 
	 (?\x237D . bidi-category-on) ;; 
	 (?\x237E . bidi-category-on) ;; 
	 (?\x237F . bidi-category-on) ;; 
	 (?\x2380 . bidi-category-on) ;; 
	 (?\x2381 . bidi-category-on) ;; 
	 (?\x2382 . bidi-category-on) ;; 
	 (?\x2383 . bidi-category-on) ;; 
	 (?\x2384 . bidi-category-on) ;; 
	 (?\x2385 . bidi-category-on) ;; 
	 (?\x2386 . bidi-category-on) ;; 
	 (?\x2387 . bidi-category-on) ;; 
	 (?\x2388 . bidi-category-on) ;; 
	 (?\x2389 . bidi-category-on) ;; 
	 (?\x238A . bidi-category-on) ;; 
	 (?\x238B . bidi-category-on) ;; 
	 (?\x238C . bidi-category-on) ;; 
	 (?\x238D . bidi-category-on) ;; 
	 (?\x238E . bidi-category-on) ;; 
	 (?\x238F . bidi-category-on) ;; 
	 (?\x2390 . bidi-category-on) ;; 
	 (?\x2391 . bidi-category-on) ;; 
	 (?\x2392 . bidi-category-on) ;; 
	 (?\x2393 . bidi-category-on) ;; 
	 (?\x2394 . bidi-category-on) ;; 
	 (?\x2395 . bidi-category-l) ;; 
	 (?\x2396 . bidi-category-on) ;; 
	 (?\x2397 . bidi-category-on) ;; 
	 (?\x2398 . bidi-category-on) ;; 
	 (?\x2399 . bidi-category-on) ;; 
	 (?\x239A . bidi-category-on) ;; 
	 (?\x2400 . bidi-category-on) ;; GRAPHIC FOR NULL
	 (?\x2401 . bidi-category-on) ;; GRAPHIC FOR START OF HEADING
	 (?\x2402 . bidi-category-on) ;; GRAPHIC FOR START OF TEXT
	 (?\x2403 . bidi-category-on) ;; GRAPHIC FOR END OF TEXT
	 (?\x2404 . bidi-category-on) ;; GRAPHIC FOR END OF TRANSMISSION
	 (?\x2405 . bidi-category-on) ;; GRAPHIC FOR ENQUIRY
	 (?\x2406 . bidi-category-on) ;; GRAPHIC FOR ACKNOWLEDGE
	 (?\x2407 . bidi-category-on) ;; GRAPHIC FOR BELL
	 (?\x2408 . bidi-category-on) ;; GRAPHIC FOR BACKSPACE
	 (?\x2409 . bidi-category-on) ;; GRAPHIC FOR HORIZONTAL TABULATION
	 (?\x240A . bidi-category-on) ;; GRAPHIC FOR LINE FEED
	 (?\x240B . bidi-category-on) ;; GRAPHIC FOR VERTICAL TABULATION
	 (?\x240C . bidi-category-on) ;; GRAPHIC FOR FORM FEED
	 (?\x240D . bidi-category-on) ;; GRAPHIC FOR CARRIAGE RETURN
	 (?\x240E . bidi-category-on) ;; GRAPHIC FOR SHIFT OUT
	 (?\x240F . bidi-category-on) ;; GRAPHIC FOR SHIFT IN
	 (?\x2410 . bidi-category-on) ;; GRAPHIC FOR DATA LINK ESCAPE
	 (?\x2411 . bidi-category-on) ;; GRAPHIC FOR DEVICE CONTROL ONE
	 (?\x2412 . bidi-category-on) ;; GRAPHIC FOR DEVICE CONTROL TWO
	 (?\x2413 . bidi-category-on) ;; GRAPHIC FOR DEVICE CONTROL THREE
	 (?\x2414 . bidi-category-on) ;; GRAPHIC FOR DEVICE CONTROL FOUR
	 (?\x2415 . bidi-category-on) ;; GRAPHIC FOR NEGATIVE ACKNOWLEDGE
	 (?\x2416 . bidi-category-on) ;; GRAPHIC FOR SYNCHRONOUS IDLE
	 (?\x2417 . bidi-category-on) ;; GRAPHIC FOR END OF TRANSMISSION BLOCK
	 (?\x2418 . bidi-category-on) ;; GRAPHIC FOR CANCEL
	 (?\x2419 . bidi-category-on) ;; GRAPHIC FOR END OF MEDIUM
	 (?\x241A . bidi-category-on) ;; GRAPHIC FOR SUBSTITUTE
	 (?\x241B . bidi-category-on) ;; GRAPHIC FOR ESCAPE
	 (?\x241C . bidi-category-on) ;; GRAPHIC FOR FILE SEPARATOR
	 (?\x241D . bidi-category-on) ;; GRAPHIC FOR GROUP SEPARATOR
	 (?\x241E . bidi-category-on) ;; GRAPHIC FOR RECORD SEPARATOR
	 (?\x241F . bidi-category-on) ;; GRAPHIC FOR UNIT SEPARATOR
	 (?\x2420 . bidi-category-on) ;; GRAPHIC FOR SPACE
	 (?\x2421 . bidi-category-on) ;; GRAPHIC FOR DELETE
	 (?\x2422 . bidi-category-on) ;; BLANK
	 (?\x2423 . bidi-category-on) ;; 
	 (?\x2424 . bidi-category-on) ;; GRAPHIC FOR NEWLINE
	 (?\x2425 . bidi-category-on) ;; 
	 (?\x2426 . bidi-category-on) ;; 
	 (?\x2440 . bidi-category-on) ;; 
	 (?\x2441 . bidi-category-on) ;; 
	 (?\x2442 . bidi-category-on) ;; 
	 (?\x2443 . bidi-category-on) ;; 
	 (?\x2444 . bidi-category-on) ;; 
	 (?\x2445 . bidi-category-on) ;; 
	 (?\x2446 . bidi-category-on) ;; 
	 (?\x2447 . bidi-category-on) ;; 
	 (?\x2448 . bidi-category-on) ;; 
	 (?\x2449 . bidi-category-on) ;; 
	 (?\x244A . bidi-category-on) ;; 
	 (?\x2460 . bidi-category-en) ;; 
	 (?\x2461 . bidi-category-en) ;; 
	 (?\x2462 . bidi-category-en) ;; 
	 (?\x2463 . bidi-category-en) ;; 
	 (?\x2464 . bidi-category-en) ;; 
	 (?\x2465 . bidi-category-en) ;; 
	 (?\x2466 . bidi-category-en) ;; 
	 (?\x2467 . bidi-category-en) ;; 
	 (?\x2468 . bidi-category-en) ;; 
	 (?\x2469 . bidi-category-en) ;; 
	 (?\x246A . bidi-category-en) ;; 
	 (?\x246B . bidi-category-en) ;; 
	 (?\x246C . bidi-category-en) ;; 
	 (?\x246D . bidi-category-en) ;; 
	 (?\x246E . bidi-category-en) ;; 
	 (?\x246F . bidi-category-en) ;; 
	 (?\x2470 . bidi-category-en) ;; 
	 (?\x2471 . bidi-category-en) ;; 
	 (?\x2472 . bidi-category-en) ;; 
	 (?\x2473 . bidi-category-en) ;; 
	 (?\x2474 . bidi-category-en) ;; 
	 (?\x2475 . bidi-category-en) ;; 
	 (?\x2476 . bidi-category-en) ;; 
	 (?\x2477 . bidi-category-en) ;; 
	 (?\x2478 . bidi-category-en) ;; 
	 (?\x2479 . bidi-category-en) ;; 
	 (?\x247A . bidi-category-en) ;; 
	 (?\x247B . bidi-category-en) ;; 
	 (?\x247C . bidi-category-en) ;; 
	 (?\x247D . bidi-category-en) ;; 
	 (?\x247E . bidi-category-en) ;; 
	 (?\x247F . bidi-category-en) ;; 
	 (?\x2480 . bidi-category-en) ;; 
	 (?\x2481 . bidi-category-en) ;; 
	 (?\x2482 . bidi-category-en) ;; 
	 (?\x2483 . bidi-category-en) ;; 
	 (?\x2484 . bidi-category-en) ;; 
	 (?\x2485 . bidi-category-en) ;; 
	 (?\x2486 . bidi-category-en) ;; 
	 (?\x2487 . bidi-category-en) ;; 
	 (?\x2488 . bidi-category-en) ;; DIGIT ONE PERIOD
	 (?\x2489 . bidi-category-en) ;; DIGIT TWO PERIOD
	 (?\x248A . bidi-category-en) ;; DIGIT THREE PERIOD
	 (?\x248B . bidi-category-en) ;; DIGIT FOUR PERIOD
	 (?\x248C . bidi-category-en) ;; DIGIT FIVE PERIOD
	 (?\x248D . bidi-category-en) ;; DIGIT SIX PERIOD
	 (?\x248E . bidi-category-en) ;; DIGIT SEVEN PERIOD
	 (?\x248F . bidi-category-en) ;; DIGIT EIGHT PERIOD
	 (?\x2490 . bidi-category-en) ;; DIGIT NINE PERIOD
	 (?\x2491 . bidi-category-en) ;; NUMBER TEN PERIOD
	 (?\x2492 . bidi-category-en) ;; NUMBER ELEVEN PERIOD
	 (?\x2493 . bidi-category-en) ;; NUMBER TWELVE PERIOD
	 (?\x2494 . bidi-category-en) ;; NUMBER THIRTEEN PERIOD
	 (?\x2495 . bidi-category-en) ;; NUMBER FOURTEEN PERIOD
	 (?\x2496 . bidi-category-en) ;; NUMBER FIFTEEN PERIOD
	 (?\x2497 . bidi-category-en) ;; NUMBER SIXTEEN PERIOD
	 (?\x2498 . bidi-category-en) ;; NUMBER SEVENTEEN PERIOD
	 (?\x2499 . bidi-category-en) ;; NUMBER EIGHTEEN PERIOD
	 (?\x249A . bidi-category-en) ;; NUMBER NINETEEN PERIOD
	 (?\x249B . bidi-category-en) ;; NUMBER TWENTY PERIOD
	 (?\x249C . bidi-category-l) ;; 
	 (?\x249D . bidi-category-l) ;; 
	 (?\x249E . bidi-category-l) ;; 
	 (?\x249F . bidi-category-l) ;; 
	 (?\x24A0 . bidi-category-l) ;; 
	 (?\x24A1 . bidi-category-l) ;; 
	 (?\x24A2 . bidi-category-l) ;; 
	 (?\x24A3 . bidi-category-l) ;; 
	 (?\x24A4 . bidi-category-l) ;; 
	 (?\x24A5 . bidi-category-l) ;; 
	 (?\x24A6 . bidi-category-l) ;; 
	 (?\x24A7 . bidi-category-l) ;; 
	 (?\x24A8 . bidi-category-l) ;; 
	 (?\x24A9 . bidi-category-l) ;; 
	 (?\x24AA . bidi-category-l) ;; 
	 (?\x24AB . bidi-category-l) ;; 
	 (?\x24AC . bidi-category-l) ;; 
	 (?\x24AD . bidi-category-l) ;; 
	 (?\x24AE . bidi-category-l) ;; 
	 (?\x24AF . bidi-category-l) ;; 
	 (?\x24B0 . bidi-category-l) ;; 
	 (?\x24B1 . bidi-category-l) ;; 
	 (?\x24B2 . bidi-category-l) ;; 
	 (?\x24B3 . bidi-category-l) ;; 
	 (?\x24B4 . bidi-category-l) ;; 
	 (?\x24B5 . bidi-category-l) ;; 
	 (?\x24B6 . bidi-category-l) ;; 
	 (?\x24B7 . bidi-category-l) ;; 
	 (?\x24B8 . bidi-category-l) ;; 
	 (?\x24B9 . bidi-category-l) ;; 
	 (?\x24BA . bidi-category-l) ;; 
	 (?\x24BB . bidi-category-l) ;; 
	 (?\x24BC . bidi-category-l) ;; 
	 (?\x24BD . bidi-category-l) ;; 
	 (?\x24BE . bidi-category-l) ;; 
	 (?\x24BF . bidi-category-l) ;; 
	 (?\x24C0 . bidi-category-l) ;; 
	 (?\x24C1 . bidi-category-l) ;; 
	 (?\x24C2 . bidi-category-l) ;; 
	 (?\x24C3 . bidi-category-l) ;; 
	 (?\x24C4 . bidi-category-l) ;; 
	 (?\x24C5 . bidi-category-l) ;; 
	 (?\x24C6 . bidi-category-l) ;; 
	 (?\x24C7 . bidi-category-l) ;; 
	 (?\x24C8 . bidi-category-l) ;; 
	 (?\x24C9 . bidi-category-l) ;; 
	 (?\x24CA . bidi-category-l) ;; 
	 (?\x24CB . bidi-category-l) ;; 
	 (?\x24CC . bidi-category-l) ;; 
	 (?\x24CD . bidi-category-l) ;; 
	 (?\x24CE . bidi-category-l) ;; 
	 (?\x24CF . bidi-category-l) ;; 
	 (?\x24D0 . bidi-category-l) ;; 
	 (?\x24D1 . bidi-category-l) ;; 
	 (?\x24D2 . bidi-category-l) ;; 
	 (?\x24D3 . bidi-category-l) ;; 
	 (?\x24D4 . bidi-category-l) ;; 
	 (?\x24D5 . bidi-category-l) ;; 
	 (?\x24D6 . bidi-category-l) ;; 
	 (?\x24D7 . bidi-category-l) ;; 
	 (?\x24D8 . bidi-category-l) ;; 
	 (?\x24D9 . bidi-category-l) ;; 
	 (?\x24DA . bidi-category-l) ;; 
	 (?\x24DB . bidi-category-l) ;; 
	 (?\x24DC . bidi-category-l) ;; 
	 (?\x24DD . bidi-category-l) ;; 
	 (?\x24DE . bidi-category-l) ;; 
	 (?\x24DF . bidi-category-l) ;; 
	 (?\x24E0 . bidi-category-l) ;; 
	 (?\x24E1 . bidi-category-l) ;; 
	 (?\x24E2 . bidi-category-l) ;; 
	 (?\x24E3 . bidi-category-l) ;; 
	 (?\x24E4 . bidi-category-l) ;; 
	 (?\x24E5 . bidi-category-l) ;; 
	 (?\x24E6 . bidi-category-l) ;; 
	 (?\x24E7 . bidi-category-l) ;; 
	 (?\x24E8 . bidi-category-l) ;; 
	 (?\x24E9 . bidi-category-l) ;; 
	 (?\x24EA . bidi-category-en) ;; 
	 (?\x2500 . bidi-category-on) ;; FORMS LIGHT HORIZONTAL
	 (?\x2501 . bidi-category-on) ;; FORMS HEAVY HORIZONTAL
	 (?\x2502 . bidi-category-on) ;; FORMS LIGHT VERTICAL
	 (?\x2503 . bidi-category-on) ;; FORMS HEAVY VERTICAL
	 (?\x2504 . bidi-category-on) ;; FORMS LIGHT TRIPLE DASH HORIZONTAL
	 (?\x2505 . bidi-category-on) ;; FORMS HEAVY TRIPLE DASH HORIZONTAL
	 (?\x2506 . bidi-category-on) ;; FORMS LIGHT TRIPLE DASH VERTICAL
	 (?\x2507 . bidi-category-on) ;; FORMS HEAVY TRIPLE DASH VERTICAL
	 (?\x2508 . bidi-category-on) ;; FORMS LIGHT QUADRUPLE DASH HORIZONTAL
	 (?\x2509 . bidi-category-on) ;; FORMS HEAVY QUADRUPLE DASH HORIZONTAL
	 (?\x250A . bidi-category-on) ;; FORMS LIGHT QUADRUPLE DASH VERTICAL
	 (?\x250B . bidi-category-on) ;; FORMS HEAVY QUADRUPLE DASH VERTICAL
	 (?\x250C . bidi-category-on) ;; FORMS LIGHT DOWN AND RIGHT
	 (?\x250D . bidi-category-on) ;; FORMS DOWN LIGHT AND RIGHT HEAVY
	 (?\x250E . bidi-category-on) ;; FORMS DOWN HEAVY AND RIGHT LIGHT
	 (?\x250F . bidi-category-on) ;; FORMS HEAVY DOWN AND RIGHT
	 (?\x2510 . bidi-category-on) ;; FORMS LIGHT DOWN AND LEFT
	 (?\x2511 . bidi-category-on) ;; FORMS DOWN LIGHT AND LEFT HEAVY
	 (?\x2512 . bidi-category-on) ;; FORMS DOWN HEAVY AND LEFT LIGHT
	 (?\x2513 . bidi-category-on) ;; FORMS HEAVY DOWN AND LEFT
	 (?\x2514 . bidi-category-on) ;; FORMS LIGHT UP AND RIGHT
	 (?\x2515 . bidi-category-on) ;; FORMS UP LIGHT AND RIGHT HEAVY
	 (?\x2516 . bidi-category-on) ;; FORMS UP HEAVY AND RIGHT LIGHT
	 (?\x2517 . bidi-category-on) ;; FORMS HEAVY UP AND RIGHT
	 (?\x2518 . bidi-category-on) ;; FORMS LIGHT UP AND LEFT
	 (?\x2519 . bidi-category-on) ;; FORMS UP LIGHT AND LEFT HEAVY
	 (?\x251A . bidi-category-on) ;; FORMS UP HEAVY AND LEFT LIGHT
	 (?\x251B . bidi-category-on) ;; FORMS HEAVY UP AND LEFT
	 (?\x251C . bidi-category-on) ;; FORMS LIGHT VERTICAL AND RIGHT
	 (?\x251D . bidi-category-on) ;; FORMS VERTICAL LIGHT AND RIGHT HEAVY
	 (?\x251E . bidi-category-on) ;; FORMS UP HEAVY AND RIGHT DOWN LIGHT
	 (?\x251F . bidi-category-on) ;; FORMS DOWN HEAVY AND RIGHT UP LIGHT
	 (?\x2520 . bidi-category-on) ;; FORMS VERTICAL HEAVY AND RIGHT LIGHT
	 (?\x2521 . bidi-category-on) ;; FORMS DOWN LIGHT AND RIGHT UP HEAVY
	 (?\x2522 . bidi-category-on) ;; FORMS UP LIGHT AND RIGHT DOWN HEAVY
	 (?\x2523 . bidi-category-on) ;; FORMS HEAVY VERTICAL AND RIGHT
	 (?\x2524 . bidi-category-on) ;; FORMS LIGHT VERTICAL AND LEFT
	 (?\x2525 . bidi-category-on) ;; FORMS VERTICAL LIGHT AND LEFT HEAVY
	 (?\x2526 . bidi-category-on) ;; FORMS UP HEAVY AND LEFT DOWN LIGHT
	 (?\x2527 . bidi-category-on) ;; FORMS DOWN HEAVY AND LEFT UP LIGHT
	 (?\x2528 . bidi-category-on) ;; FORMS VERTICAL HEAVY AND LEFT LIGHT
	 (?\x2529 . bidi-category-on) ;; FORMS DOWN LIGHT AND LEFT UP HEAVY
	 (?\x252A . bidi-category-on) ;; FORMS UP LIGHT AND LEFT DOWN HEAVY
	 (?\x252B . bidi-category-on) ;; FORMS HEAVY VERTICAL AND LEFT
	 (?\x252C . bidi-category-on) ;; FORMS LIGHT DOWN AND HORIZONTAL
	 (?\x252D . bidi-category-on) ;; FORMS LEFT HEAVY AND RIGHT DOWN LIGHT
	 (?\x252E . bidi-category-on) ;; FORMS RIGHT HEAVY AND LEFT DOWN LIGHT
	 (?\x252F . bidi-category-on) ;; FORMS DOWN LIGHT AND HORIZONTAL HEAVY
	 (?\x2530 . bidi-category-on) ;; FORMS DOWN HEAVY AND HORIZONTAL LIGHT
	 (?\x2531 . bidi-category-on) ;; FORMS RIGHT LIGHT AND LEFT DOWN HEAVY
	 (?\x2532 . bidi-category-on) ;; FORMS LEFT LIGHT AND RIGHT DOWN HEAVY
	 (?\x2533 . bidi-category-on) ;; FORMS HEAVY DOWN AND HORIZONTAL
	 (?\x2534 . bidi-category-on) ;; FORMS LIGHT UP AND HORIZONTAL
	 (?\x2535 . bidi-category-on) ;; FORMS LEFT HEAVY AND RIGHT UP LIGHT
	 (?\x2536 . bidi-category-on) ;; FORMS RIGHT HEAVY AND LEFT UP LIGHT
	 (?\x2537 . bidi-category-on) ;; FORMS UP LIGHT AND HORIZONTAL HEAVY
	 (?\x2538 . bidi-category-on) ;; FORMS UP HEAVY AND HORIZONTAL LIGHT
	 (?\x2539 . bidi-category-on) ;; FORMS RIGHT LIGHT AND LEFT UP HEAVY
	 (?\x253A . bidi-category-on) ;; FORMS LEFT LIGHT AND RIGHT UP HEAVY
	 (?\x253B . bidi-category-on) ;; FORMS HEAVY UP AND HORIZONTAL
	 (?\x253C . bidi-category-on) ;; FORMS LIGHT VERTICAL AND HORIZONTAL
	 (?\x253D . bidi-category-on) ;; FORMS LEFT HEAVY AND RIGHT VERTICAL LIGHT
	 (?\x253E . bidi-category-on) ;; FORMS RIGHT HEAVY AND LEFT VERTICAL LIGHT
	 (?\x253F . bidi-category-on) ;; FORMS VERTICAL LIGHT AND HORIZONTAL HEAVY
	 (?\x2540 . bidi-category-on) ;; FORMS UP HEAVY AND DOWN HORIZONTAL LIGHT
	 (?\x2541 . bidi-category-on) ;; FORMS DOWN HEAVY AND UP HORIZONTAL LIGHT
	 (?\x2542 . bidi-category-on) ;; FORMS VERTICAL HEAVY AND HORIZONTAL LIGHT
	 (?\x2543 . bidi-category-on) ;; FORMS LEFT UP HEAVY AND RIGHT DOWN LIGHT
	 (?\x2544 . bidi-category-on) ;; FORMS RIGHT UP HEAVY AND LEFT DOWN LIGHT
	 (?\x2545 . bidi-category-on) ;; FORMS LEFT DOWN HEAVY AND RIGHT UP LIGHT
	 (?\x2546 . bidi-category-on) ;; FORMS RIGHT DOWN HEAVY AND LEFT UP LIGHT
	 (?\x2547 . bidi-category-on) ;; FORMS DOWN LIGHT AND UP HORIZONTAL HEAVY
	 (?\x2548 . bidi-category-on) ;; FORMS UP LIGHT AND DOWN HORIZONTAL HEAVY
	 (?\x2549 . bidi-category-on) ;; FORMS RIGHT LIGHT AND LEFT VERTICAL HEAVY
	 (?\x254A . bidi-category-on) ;; FORMS LEFT LIGHT AND RIGHT VERTICAL HEAVY
	 (?\x254B . bidi-category-on) ;; FORMS HEAVY VERTICAL AND HORIZONTAL
	 (?\x254C . bidi-category-on) ;; FORMS LIGHT DOUBLE DASH HORIZONTAL
	 (?\x254D . bidi-category-on) ;; FORMS HEAVY DOUBLE DASH HORIZONTAL
	 (?\x254E . bidi-category-on) ;; FORMS LIGHT DOUBLE DASH VERTICAL
	 (?\x254F . bidi-category-on) ;; FORMS HEAVY DOUBLE DASH VERTICAL
	 (?\x2550 . bidi-category-on) ;; FORMS DOUBLE HORIZONTAL
	 (?\x2551 . bidi-category-on) ;; FORMS DOUBLE VERTICAL
	 (?\x2552 . bidi-category-on) ;; FORMS DOWN SINGLE AND RIGHT DOUBLE
	 (?\x2553 . bidi-category-on) ;; FORMS DOWN DOUBLE AND RIGHT SINGLE
	 (?\x2554 . bidi-category-on) ;; FORMS DOUBLE DOWN AND RIGHT
	 (?\x2555 . bidi-category-on) ;; FORMS DOWN SINGLE AND LEFT DOUBLE
	 (?\x2556 . bidi-category-on) ;; FORMS DOWN DOUBLE AND LEFT SINGLE
	 (?\x2557 . bidi-category-on) ;; FORMS DOUBLE DOWN AND LEFT
	 (?\x2558 . bidi-category-on) ;; FORMS UP SINGLE AND RIGHT DOUBLE
	 (?\x2559 . bidi-category-on) ;; FORMS UP DOUBLE AND RIGHT SINGLE
	 (?\x255A . bidi-category-on) ;; FORMS DOUBLE UP AND RIGHT
	 (?\x255B . bidi-category-on) ;; FORMS UP SINGLE AND LEFT DOUBLE
	 (?\x255C . bidi-category-on) ;; FORMS UP DOUBLE AND LEFT SINGLE
	 (?\x255D . bidi-category-on) ;; FORMS DOUBLE UP AND LEFT
	 (?\x255E . bidi-category-on) ;; FORMS VERTICAL SINGLE AND RIGHT DOUBLE
	 (?\x255F . bidi-category-on) ;; FORMS VERTICAL DOUBLE AND RIGHT SINGLE
	 (?\x2560 . bidi-category-on) ;; FORMS DOUBLE VERTICAL AND RIGHT
	 (?\x2561 . bidi-category-on) ;; FORMS VERTICAL SINGLE AND LEFT DOUBLE
	 (?\x2562 . bidi-category-on) ;; FORMS VERTICAL DOUBLE AND LEFT SINGLE
	 (?\x2563 . bidi-category-on) ;; FORMS DOUBLE VERTICAL AND LEFT
	 (?\x2564 . bidi-category-on) ;; FORMS DOWN SINGLE AND HORIZONTAL DOUBLE
	 (?\x2565 . bidi-category-on) ;; FORMS DOWN DOUBLE AND HORIZONTAL SINGLE
	 (?\x2566 . bidi-category-on) ;; FORMS DOUBLE DOWN AND HORIZONTAL
	 (?\x2567 . bidi-category-on) ;; FORMS UP SINGLE AND HORIZONTAL DOUBLE
	 (?\x2568 . bidi-category-on) ;; FORMS UP DOUBLE AND HORIZONTAL SINGLE
	 (?\x2569 . bidi-category-on) ;; FORMS DOUBLE UP AND HORIZONTAL
	 (?\x256A . bidi-category-on) ;; FORMS VERTICAL SINGLE AND HORIZONTAL DOUBLE
	 (?\x256B . bidi-category-on) ;; FORMS VERTICAL DOUBLE AND HORIZONTAL SINGLE
	 (?\x256C . bidi-category-on) ;; FORMS DOUBLE VERTICAL AND HORIZONTAL
	 (?\x256D . bidi-category-on) ;; FORMS LIGHT ARC DOWN AND RIGHT
	 (?\x256E . bidi-category-on) ;; FORMS LIGHT ARC DOWN AND LEFT
	 (?\x256F . bidi-category-on) ;; FORMS LIGHT ARC UP AND LEFT
	 (?\x2570 . bidi-category-on) ;; FORMS LIGHT ARC UP AND RIGHT
	 (?\x2571 . bidi-category-on) ;; FORMS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
	 (?\x2572 . bidi-category-on) ;; FORMS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
	 (?\x2573 . bidi-category-on) ;; FORMS LIGHT DIAGONAL CROSS
	 (?\x2574 . bidi-category-on) ;; FORMS LIGHT LEFT
	 (?\x2575 . bidi-category-on) ;; FORMS LIGHT UP
	 (?\x2576 . bidi-category-on) ;; FORMS LIGHT RIGHT
	 (?\x2577 . bidi-category-on) ;; FORMS LIGHT DOWN
	 (?\x2578 . bidi-category-on) ;; FORMS HEAVY LEFT
	 (?\x2579 . bidi-category-on) ;; FORMS HEAVY UP
	 (?\x257A . bidi-category-on) ;; FORMS HEAVY RIGHT
	 (?\x257B . bidi-category-on) ;; FORMS HEAVY DOWN
	 (?\x257C . bidi-category-on) ;; FORMS LIGHT LEFT AND HEAVY RIGHT
	 (?\x257D . bidi-category-on) ;; FORMS LIGHT UP AND HEAVY DOWN
	 (?\x257E . bidi-category-on) ;; FORMS HEAVY LEFT AND LIGHT RIGHT
	 (?\x257F . bidi-category-on) ;; FORMS HEAVY UP AND LIGHT DOWN
	 (?\x2580 . bidi-category-on) ;; 
	 (?\x2581 . bidi-category-on) ;; 
	 (?\x2582 . bidi-category-on) ;; 
	 (?\x2583 . bidi-category-on) ;; 
	 (?\x2584 . bidi-category-on) ;; 
	 (?\x2585 . bidi-category-on) ;; 
	 (?\x2586 . bidi-category-on) ;; LOWER THREE QUARTER BLOCK
	 (?\x2587 . bidi-category-on) ;; 
	 (?\x2588 . bidi-category-on) ;; 
	 (?\x2589 . bidi-category-on) ;; 
	 (?\x258A . bidi-category-on) ;; LEFT THREE QUARTER BLOCK
	 (?\x258B . bidi-category-on) ;; 
	 (?\x258C . bidi-category-on) ;; 
	 (?\x258D . bidi-category-on) ;; 
	 (?\x258E . bidi-category-on) ;; 
	 (?\x258F . bidi-category-on) ;; 
	 (?\x2590 . bidi-category-on) ;; 
	 (?\x2591 . bidi-category-on) ;; 
	 (?\x2592 . bidi-category-on) ;; 
	 (?\x2593 . bidi-category-on) ;; 
	 (?\x2594 . bidi-category-on) ;; 
	 (?\x2595 . bidi-category-on) ;; 
	 (?\x25A0 . bidi-category-on) ;; 
	 (?\x25A1 . bidi-category-on) ;; 
	 (?\x25A2 . bidi-category-on) ;; 
	 (?\x25A3 . bidi-category-on) ;; 
	 (?\x25A4 . bidi-category-on) ;; 
	 (?\x25A5 . bidi-category-on) ;; 
	 (?\x25A6 . bidi-category-on) ;; 
	 (?\x25A7 . bidi-category-on) ;; 
	 (?\x25A8 . bidi-category-on) ;; 
	 (?\x25A9 . bidi-category-on) ;; 
	 (?\x25AA . bidi-category-on) ;; 
	 (?\x25AB . bidi-category-on) ;; 
	 (?\x25AC . bidi-category-on) ;; 
	 (?\x25AD . bidi-category-on) ;; 
	 (?\x25AE . bidi-category-on) ;; 
	 (?\x25AF . bidi-category-on) ;; 
	 (?\x25B0 . bidi-category-on) ;; 
	 (?\x25B1 . bidi-category-on) ;; 
	 (?\x25B2 . bidi-category-on) ;; BLACK UP POINTING TRIANGLE
	 (?\x25B3 . bidi-category-on) ;; WHITE UP POINTING TRIANGLE
	 (?\x25B4 . bidi-category-on) ;; BLACK UP POINTING SMALL TRIANGLE
	 (?\x25B5 . bidi-category-on) ;; WHITE UP POINTING SMALL TRIANGLE
	 (?\x25B6 . bidi-category-on) ;; BLACK RIGHT POINTING TRIANGLE
	 (?\x25B7 . bidi-category-on) ;; WHITE RIGHT POINTING TRIANGLE
	 (?\x25B8 . bidi-category-on) ;; BLACK RIGHT POINTING SMALL TRIANGLE
	 (?\x25B9 . bidi-category-on) ;; WHITE RIGHT POINTING SMALL TRIANGLE
	 (?\x25BA . bidi-category-on) ;; BLACK RIGHT POINTING POINTER
	 (?\x25BB . bidi-category-on) ;; WHITE RIGHT POINTING POINTER
	 (?\x25BC . bidi-category-on) ;; BLACK DOWN POINTING TRIANGLE
	 (?\x25BD . bidi-category-on) ;; WHITE DOWN POINTING TRIANGLE
	 (?\x25BE . bidi-category-on) ;; BLACK DOWN POINTING SMALL TRIANGLE
	 (?\x25BF . bidi-category-on) ;; WHITE DOWN POINTING SMALL TRIANGLE
	 (?\x25C0 . bidi-category-on) ;; BLACK LEFT POINTING TRIANGLE
	 (?\x25C1 . bidi-category-on) ;; WHITE LEFT POINTING TRIANGLE
	 (?\x25C2 . bidi-category-on) ;; BLACK LEFT POINTING SMALL TRIANGLE
	 (?\x25C3 . bidi-category-on) ;; WHITE LEFT POINTING SMALL TRIANGLE
	 (?\x25C4 . bidi-category-on) ;; BLACK LEFT POINTING POINTER
	 (?\x25C5 . bidi-category-on) ;; WHITE LEFT POINTING POINTER
	 (?\x25C6 . bidi-category-on) ;; 
	 (?\x25C7 . bidi-category-on) ;; 
	 (?\x25C8 . bidi-category-on) ;; 
	 (?\x25C9 . bidi-category-on) ;; 
	 (?\x25CA . bidi-category-on) ;; 
	 (?\x25CB . bidi-category-on) ;; 
	 (?\x25CC . bidi-category-on) ;; 
	 (?\x25CD . bidi-category-on) ;; 
	 (?\x25CE . bidi-category-on) ;; 
	 (?\x25CF . bidi-category-on) ;; 
	 (?\x25D0 . bidi-category-on) ;; 
	 (?\x25D1 . bidi-category-on) ;; 
	 (?\x25D2 . bidi-category-on) ;; 
	 (?\x25D3 . bidi-category-on) ;; 
	 (?\x25D4 . bidi-category-on) ;; 
	 (?\x25D5 . bidi-category-on) ;; 
	 (?\x25D6 . bidi-category-on) ;; 
	 (?\x25D7 . bidi-category-on) ;; 
	 (?\x25D8 . bidi-category-on) ;; 
	 (?\x25D9 . bidi-category-on) ;; 
	 (?\x25DA . bidi-category-on) ;; 
	 (?\x25DB . bidi-category-on) ;; 
	 (?\x25DC . bidi-category-on) ;; 
	 (?\x25DD . bidi-category-on) ;; 
	 (?\x25DE . bidi-category-on) ;; 
	 (?\x25DF . bidi-category-on) ;; 
	 (?\x25E0 . bidi-category-on) ;; 
	 (?\x25E1 . bidi-category-on) ;; 
	 (?\x25E2 . bidi-category-on) ;; 
	 (?\x25E3 . bidi-category-on) ;; 
	 (?\x25E4 . bidi-category-on) ;; 
	 (?\x25E5 . bidi-category-on) ;; 
	 (?\x25E6 . bidi-category-on) ;; 
	 (?\x25E7 . bidi-category-on) ;; 
	 (?\x25E8 . bidi-category-on) ;; 
	 (?\x25E9 . bidi-category-on) ;; 
	 (?\x25EA . bidi-category-on) ;; 
	 (?\x25EB . bidi-category-on) ;; 
	 (?\x25EC . bidi-category-on) ;; WHITE UP POINTING TRIANGLE WITH DOT
	 (?\x25ED . bidi-category-on) ;; UP POINTING TRIANGLE WITH LEFT HALF BLACK
	 (?\x25EE . bidi-category-on) ;; UP POINTING TRIANGLE WITH RIGHT HALF BLACK
	 (?\x25EF . bidi-category-on) ;; 
	 (?\x25F0 . bidi-category-on) ;; 
	 (?\x25F1 . bidi-category-on) ;; 
	 (?\x25F2 . bidi-category-on) ;; 
	 (?\x25F3 . bidi-category-on) ;; 
	 (?\x25F4 . bidi-category-on) ;; 
	 (?\x25F5 . bidi-category-on) ;; 
	 (?\x25F6 . bidi-category-on) ;; 
	 (?\x25F7 . bidi-category-on) ;; 
	 (?\x2600 . bidi-category-on) ;; 
	 (?\x2601 . bidi-category-on) ;; 
	 (?\x2602 . bidi-category-on) ;; 
	 (?\x2603 . bidi-category-on) ;; 
	 (?\x2604 . bidi-category-on) ;; 
	 (?\x2605 . bidi-category-on) ;; 
	 (?\x2606 . bidi-category-on) ;; 
	 (?\x2607 . bidi-category-on) ;; 
	 (?\x2608 . bidi-category-on) ;; 
	 (?\x2609 . bidi-category-on) ;; 
	 (?\x260A . bidi-category-on) ;; 
	 (?\x260B . bidi-category-on) ;; 
	 (?\x260C . bidi-category-on) ;; 
	 (?\x260D . bidi-category-on) ;; 
	 (?\x260E . bidi-category-on) ;; 
	 (?\x260F . bidi-category-on) ;; 
	 (?\x2610 . bidi-category-on) ;; 
	 (?\x2611 . bidi-category-on) ;; 
	 (?\x2612 . bidi-category-on) ;; 
	 (?\x2613 . bidi-category-on) ;; 
	 (?\x2619 . bidi-category-on) ;; 
	 (?\x261A . bidi-category-on) ;; 
	 (?\x261B . bidi-category-on) ;; 
	 (?\x261C . bidi-category-on) ;; 
	 (?\x261D . bidi-category-on) ;; 
	 (?\x261E . bidi-category-on) ;; 
	 (?\x261F . bidi-category-on) ;; 
	 (?\x2620 . bidi-category-on) ;; 
	 (?\x2621 . bidi-category-on) ;; 
	 (?\x2622 . bidi-category-on) ;; 
	 (?\x2623 . bidi-category-on) ;; 
	 (?\x2624 . bidi-category-on) ;; 
	 (?\x2625 . bidi-category-on) ;; 
	 (?\x2626 . bidi-category-on) ;; 
	 (?\x2627 . bidi-category-on) ;; 
	 (?\x2628 . bidi-category-on) ;; 
	 (?\x2629 . bidi-category-on) ;; 
	 (?\x262A . bidi-category-on) ;; 
	 (?\x262B . bidi-category-on) ;; SYMBOL OF IRAN
	 (?\x262C . bidi-category-on) ;; 
	 (?\x262D . bidi-category-on) ;; 
	 (?\x262E . bidi-category-on) ;; 
	 (?\x262F . bidi-category-on) ;; 
	 (?\x2630 . bidi-category-on) ;; 
	 (?\x2631 . bidi-category-on) ;; 
	 (?\x2632 . bidi-category-on) ;; 
	 (?\x2633 . bidi-category-on) ;; 
	 (?\x2634 . bidi-category-on) ;; 
	 (?\x2635 . bidi-category-on) ;; 
	 (?\x2636 . bidi-category-on) ;; 
	 (?\x2637 . bidi-category-on) ;; 
	 (?\x2638 . bidi-category-on) ;; 
	 (?\x2639 . bidi-category-on) ;; 
	 (?\x263A . bidi-category-on) ;; 
	 (?\x263B . bidi-category-on) ;; 
	 (?\x263C . bidi-category-on) ;; 
	 (?\x263D . bidi-category-on) ;; 
	 (?\x263E . bidi-category-on) ;; 
	 (?\x263F . bidi-category-on) ;; 
	 (?\x2640 . bidi-category-on) ;; 
	 (?\x2641 . bidi-category-on) ;; 
	 (?\x2642 . bidi-category-on) ;; 
	 (?\x2643 . bidi-category-on) ;; 
	 (?\x2644 . bidi-category-on) ;; 
	 (?\x2645 . bidi-category-on) ;; 
	 (?\x2646 . bidi-category-on) ;; 
	 (?\x2647 . bidi-category-on) ;; 
	 (?\x2648 . bidi-category-on) ;; 
	 (?\x2649 . bidi-category-on) ;; 
	 (?\x264A . bidi-category-on) ;; 
	 (?\x264B . bidi-category-on) ;; 
	 (?\x264C . bidi-category-on) ;; 
	 (?\x264D . bidi-category-on) ;; 
	 (?\x264E . bidi-category-on) ;; 
	 (?\x264F . bidi-category-on) ;; 
	 (?\x2650 . bidi-category-on) ;; 
	 (?\x2651 . bidi-category-on) ;; 
	 (?\x2652 . bidi-category-on) ;; 
	 (?\x2653 . bidi-category-on) ;; 
	 (?\x2654 . bidi-category-on) ;; 
	 (?\x2655 . bidi-category-on) ;; 
	 (?\x2656 . bidi-category-on) ;; 
	 (?\x2657 . bidi-category-on) ;; 
	 (?\x2658 . bidi-category-on) ;; 
	 (?\x2659 . bidi-category-on) ;; 
	 (?\x265A . bidi-category-on) ;; 
	 (?\x265B . bidi-category-on) ;; 
	 (?\x265C . bidi-category-on) ;; 
	 (?\x265D . bidi-category-on) ;; 
	 (?\x265E . bidi-category-on) ;; 
	 (?\x265F . bidi-category-on) ;; 
	 (?\x2660 . bidi-category-on) ;; 
	 (?\x2661 . bidi-category-on) ;; 
	 (?\x2662 . bidi-category-on) ;; 
	 (?\x2663 . bidi-category-on) ;; 
	 (?\x2664 . bidi-category-on) ;; 
	 (?\x2665 . bidi-category-on) ;; 
	 (?\x2666 . bidi-category-on) ;; 
	 (?\x2667 . bidi-category-on) ;; 
	 (?\x2668 . bidi-category-on) ;; 
	 (?\x2669 . bidi-category-on) ;; 
	 (?\x266A . bidi-category-on) ;; 
	 (?\x266B . bidi-category-on) ;; BARRED EIGHTH NOTES
	 (?\x266C . bidi-category-on) ;; BARRED SIXTEENTH NOTES
	 (?\x266D . bidi-category-on) ;; FLAT
	 (?\x266E . bidi-category-on) ;; NATURAL
	 (?\x266F . bidi-category-on) ;; SHARP
	 (?\x2670 . bidi-category-on) ;; 
	 (?\x2671 . bidi-category-on) ;; 
	 (?\x2701 . bidi-category-on) ;; 
	 (?\x2702 . bidi-category-on) ;; 
	 (?\x2703 . bidi-category-on) ;; 
	 (?\x2704 . bidi-category-on) ;; 
	 (?\x2706 . bidi-category-on) ;; 
	 (?\x2707 . bidi-category-on) ;; 
	 (?\x2708 . bidi-category-on) ;; 
	 (?\x2709 . bidi-category-on) ;; 
	 (?\x270C . bidi-category-on) ;; 
	 (?\x270D . bidi-category-on) ;; 
	 (?\x270E . bidi-category-on) ;; 
	 (?\x270F . bidi-category-on) ;; 
	 (?\x2710 . bidi-category-on) ;; 
	 (?\x2711 . bidi-category-on) ;; 
	 (?\x2712 . bidi-category-on) ;; 
	 (?\x2713 . bidi-category-on) ;; 
	 (?\x2714 . bidi-category-on) ;; 
	 (?\x2715 . bidi-category-on) ;; 
	 (?\x2716 . bidi-category-on) ;; 
	 (?\x2717 . bidi-category-on) ;; 
	 (?\x2718 . bidi-category-on) ;; 
	 (?\x2719 . bidi-category-on) ;; 
	 (?\x271A . bidi-category-on) ;; 
	 (?\x271B . bidi-category-on) ;; OPEN CENTER CROSS
	 (?\x271C . bidi-category-on) ;; HEAVY OPEN CENTER CROSS
	 (?\x271D . bidi-category-on) ;; 
	 (?\x271E . bidi-category-on) ;; 
	 (?\x271F . bidi-category-on) ;; 
	 (?\x2720 . bidi-category-on) ;; 
	 (?\x2721 . bidi-category-on) ;; 
	 (?\x2722 . bidi-category-on) ;; 
	 (?\x2723 . bidi-category-on) ;; 
	 (?\x2724 . bidi-category-on) ;; 
	 (?\x2725 . bidi-category-on) ;; 
	 (?\x2726 . bidi-category-on) ;; 
	 (?\x2727 . bidi-category-on) ;; 
	 (?\x2729 . bidi-category-on) ;; 
	 (?\x272A . bidi-category-on) ;; 
	 (?\x272B . bidi-category-on) ;; OPEN CENTER BLACK STAR
	 (?\x272C . bidi-category-on) ;; BLACK CENTER WHITE STAR
	 (?\x272D . bidi-category-on) ;; 
	 (?\x272E . bidi-category-on) ;; 
	 (?\x272F . bidi-category-on) ;; 
	 (?\x2730 . bidi-category-on) ;; 
	 (?\x2731 . bidi-category-on) ;; 
	 (?\x2732 . bidi-category-on) ;; OPEN CENTER ASTERISK
	 (?\x2733 . bidi-category-on) ;; 
	 (?\x2734 . bidi-category-on) ;; 
	 (?\x2735 . bidi-category-on) ;; 
	 (?\x2736 . bidi-category-on) ;; 
	 (?\x2737 . bidi-category-on) ;; 
	 (?\x2738 . bidi-category-on) ;; 
	 (?\x2739 . bidi-category-on) ;; 
	 (?\x273A . bidi-category-on) ;; 
	 (?\x273B . bidi-category-on) ;; 
	 (?\x273C . bidi-category-on) ;; OPEN CENTER TEARDROP-SPOKED ASTERISK
	 (?\x273D . bidi-category-on) ;; 
	 (?\x273E . bidi-category-on) ;; 
	 (?\x273F . bidi-category-on) ;; 
	 (?\x2740 . bidi-category-on) ;; 
	 (?\x2741 . bidi-category-on) ;; 
	 (?\x2742 . bidi-category-on) ;; CIRCLED OPEN CENTER EIGHT POINTED STAR
	 (?\x2743 . bidi-category-on) ;; 
	 (?\x2744 . bidi-category-on) ;; 
	 (?\x2745 . bidi-category-on) ;; 
	 (?\x2746 . bidi-category-on) ;; 
	 (?\x2747 . bidi-category-on) ;; 
	 (?\x2748 . bidi-category-on) ;; 
	 (?\x2749 . bidi-category-on) ;; 
	 (?\x274A . bidi-category-on) ;; 
	 (?\x274B . bidi-category-on) ;; 
	 (?\x274D . bidi-category-on) ;; 
	 (?\x274F . bidi-category-on) ;; 
	 (?\x2750 . bidi-category-on) ;; 
	 (?\x2751 . bidi-category-on) ;; 
	 (?\x2752 . bidi-category-on) ;; 
	 (?\x2756 . bidi-category-on) ;; 
	 (?\x2758 . bidi-category-on) ;; 
	 (?\x2759 . bidi-category-on) ;; 
	 (?\x275A . bidi-category-on) ;; 
	 (?\x275B . bidi-category-on) ;; 
	 (?\x275C . bidi-category-on) ;; 
	 (?\x275D . bidi-category-on) ;; 
	 (?\x275E . bidi-category-on) ;; 
	 (?\x2761 . bidi-category-on) ;; 
	 (?\x2762 . bidi-category-on) ;; 
	 (?\x2763 . bidi-category-on) ;; 
	 (?\x2764 . bidi-category-on) ;; 
	 (?\x2765 . bidi-category-on) ;; 
	 (?\x2766 . bidi-category-on) ;; 
	 (?\x2767 . bidi-category-on) ;; 
	 (?\x2776 . bidi-category-on) ;; INVERSE CIRCLED DIGIT ONE
	 (?\x2777 . bidi-category-on) ;; INVERSE CIRCLED DIGIT TWO
	 (?\x2778 . bidi-category-on) ;; INVERSE CIRCLED DIGIT THREE
	 (?\x2779 . bidi-category-on) ;; INVERSE CIRCLED DIGIT FOUR
	 (?\x277A . bidi-category-on) ;; INVERSE CIRCLED DIGIT FIVE
	 (?\x277B . bidi-category-on) ;; INVERSE CIRCLED DIGIT SIX
	 (?\x277C . bidi-category-on) ;; INVERSE CIRCLED DIGIT SEVEN
	 (?\x277D . bidi-category-on) ;; INVERSE CIRCLED DIGIT EIGHT
	 (?\x277E . bidi-category-on) ;; INVERSE CIRCLED DIGIT NINE
	 (?\x277F . bidi-category-on) ;; INVERSE CIRCLED NUMBER TEN
	 (?\x2780 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT ONE
	 (?\x2781 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT TWO
	 (?\x2782 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT THREE
	 (?\x2783 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT FOUR
	 (?\x2784 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT FIVE
	 (?\x2785 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT SIX
	 (?\x2786 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT SEVEN
	 (?\x2787 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT EIGHT
	 (?\x2788 . bidi-category-on) ;; CIRCLED SANS-SERIF DIGIT NINE
	 (?\x2789 . bidi-category-on) ;; CIRCLED SANS-SERIF NUMBER TEN
	 (?\x278A . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT ONE
	 (?\x278B . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT TWO
	 (?\x278C . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT THREE
	 (?\x278D . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT FOUR
	 (?\x278E . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT FIVE
	 (?\x278F . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT SIX
	 (?\x2790 . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT SEVEN
	 (?\x2791 . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT EIGHT
	 (?\x2792 . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF DIGIT NINE
	 (?\x2793 . bidi-category-on) ;; INVERSE CIRCLED SANS-SERIF NUMBER TEN
	 (?\x2794 . bidi-category-on) ;; HEAVY WIDE-HEADED RIGHT ARROW
	 (?\x2798 . bidi-category-on) ;; HEAVY LOWER RIGHT ARROW
	 (?\x2799 . bidi-category-on) ;; HEAVY RIGHT ARROW
	 (?\x279A . bidi-category-on) ;; HEAVY UPPER RIGHT ARROW
	 (?\x279B . bidi-category-on) ;; DRAFTING POINT RIGHT ARROW
	 (?\x279C . bidi-category-on) ;; HEAVY ROUND-TIPPED RIGHT ARROW
	 (?\x279D . bidi-category-on) ;; TRIANGLE-HEADED RIGHT ARROW
	 (?\x279E . bidi-category-on) ;; HEAVY TRIANGLE-HEADED RIGHT ARROW
	 (?\x279F . bidi-category-on) ;; DASHED TRIANGLE-HEADED RIGHT ARROW
	 (?\x27A0 . bidi-category-on) ;; HEAVY DASHED TRIANGLE-HEADED RIGHT ARROW
	 (?\x27A1 . bidi-category-on) ;; BLACK RIGHT ARROW
	 (?\x27A2 . bidi-category-on) ;; THREE-D TOP-LIGHTED RIGHT ARROWHEAD
	 (?\x27A3 . bidi-category-on) ;; THREE-D BOTTOM-LIGHTED RIGHT ARROWHEAD
	 (?\x27A4 . bidi-category-on) ;; BLACK RIGHT ARROWHEAD
	 (?\x27A5 . bidi-category-on) ;; HEAVY BLACK CURVED DOWN AND RIGHT ARROW
	 (?\x27A6 . bidi-category-on) ;; HEAVY BLACK CURVED UP AND RIGHT ARROW
	 (?\x27A7 . bidi-category-on) ;; SQUAT BLACK RIGHT ARROW
	 (?\x27A8 . bidi-category-on) ;; HEAVY CONCAVE-POINTED BLACK RIGHT ARROW
	 (?\x27A9 . bidi-category-on) ;; RIGHT-SHADED WHITE RIGHT ARROW
	 (?\x27AA . bidi-category-on) ;; LEFT-SHADED WHITE RIGHT ARROW
	 (?\x27AB . bidi-category-on) ;; BACK-TILTED SHADOWED WHITE RIGHT ARROW
	 (?\x27AC . bidi-category-on) ;; FRONT-TILTED SHADOWED WHITE RIGHT ARROW
	 (?\x27AD . bidi-category-on) ;; HEAVY LOWER RIGHT-SHADOWED WHITE RIGHT ARROW
	 (?\x27AE . bidi-category-on) ;; HEAVY UPPER RIGHT-SHADOWED WHITE RIGHT ARROW
	 (?\x27AF . bidi-category-on) ;; NOTCHED LOWER RIGHT-SHADOWED WHITE RIGHT ARROW
	 (?\x27B1 . bidi-category-on) ;; NOTCHED UPPER RIGHT-SHADOWED WHITE RIGHT ARROW
	 (?\x27B2 . bidi-category-on) ;; CIRCLED HEAVY WHITE RIGHT ARROW
	 (?\x27B3 . bidi-category-on) ;; WHITE-FEATHERED RIGHT ARROW
	 (?\x27B4 . bidi-category-on) ;; BLACK-FEATHERED LOWER RIGHT ARROW
	 (?\x27B5 . bidi-category-on) ;; BLACK-FEATHERED RIGHT ARROW
	 (?\x27B6 . bidi-category-on) ;; BLACK-FEATHERED UPPER RIGHT ARROW
	 (?\x27B7 . bidi-category-on) ;; HEAVY BLACK-FEATHERED LOWER RIGHT ARROW
	 (?\x27B8 . bidi-category-on) ;; HEAVY BLACK-FEATHERED RIGHT ARROW
	 (?\x27B9 . bidi-category-on) ;; HEAVY BLACK-FEATHERED UPPER RIGHT ARROW
	 (?\x27BA . bidi-category-on) ;; TEARDROP-BARBED RIGHT ARROW
	 (?\x27BB . bidi-category-on) ;; HEAVY TEARDROP-SHANKED RIGHT ARROW
	 (?\x27BC . bidi-category-on) ;; WEDGE-TAILED RIGHT ARROW
	 (?\x27BD . bidi-category-on) ;; HEAVY WEDGE-TAILED RIGHT ARROW
	 (?\x27BE . bidi-category-on) ;; OPEN-OUTLINED RIGHT ARROW
	 (?\x2800 . bidi-category-on) ;; 
	 (?\x2801 . bidi-category-on) ;; 
	 (?\x2802 . bidi-category-on) ;; 
	 (?\x2803 . bidi-category-on) ;; 
	 (?\x2804 . bidi-category-on) ;; 
	 (?\x2805 . bidi-category-on) ;; 
	 (?\x2806 . bidi-category-on) ;; 
	 (?\x2807 . bidi-category-on) ;; 
	 (?\x2808 . bidi-category-on) ;; 
	 (?\x2809 . bidi-category-on) ;; 
	 (?\x280A . bidi-category-on) ;; 
	 (?\x280B . bidi-category-on) ;; 
	 (?\x280C . bidi-category-on) ;; 
	 (?\x280D . bidi-category-on) ;; 
	 (?\x280E . bidi-category-on) ;; 
	 (?\x280F . bidi-category-on) ;; 
	 (?\x2810 . bidi-category-on) ;; 
	 (?\x2811 . bidi-category-on) ;; 
	 (?\x2812 . bidi-category-on) ;; 
	 (?\x2813 . bidi-category-on) ;; 
	 (?\x2814 . bidi-category-on) ;; 
	 (?\x2815 . bidi-category-on) ;; 
	 (?\x2816 . bidi-category-on) ;; 
	 (?\x2817 . bidi-category-on) ;; 
	 (?\x2818 . bidi-category-on) ;; 
	 (?\x2819 . bidi-category-on) ;; 
	 (?\x281A . bidi-category-on) ;; 
	 (?\x281B . bidi-category-on) ;; 
	 (?\x281C . bidi-category-on) ;; 
	 (?\x281D . bidi-category-on) ;; 
	 (?\x281E . bidi-category-on) ;; 
	 (?\x281F . bidi-category-on) ;; 
	 (?\x2820 . bidi-category-on) ;; 
	 (?\x2821 . bidi-category-on) ;; 
	 (?\x2822 . bidi-category-on) ;; 
	 (?\x2823 . bidi-category-on) ;; 
	 (?\x2824 . bidi-category-on) ;; 
	 (?\x2825 . bidi-category-on) ;; 
	 (?\x2826 . bidi-category-on) ;; 
	 (?\x2827 . bidi-category-on) ;; 
	 (?\x2828 . bidi-category-on) ;; 
	 (?\x2829 . bidi-category-on) ;; 
	 (?\x282A . bidi-category-on) ;; 
	 (?\x282B . bidi-category-on) ;; 
	 (?\x282C . bidi-category-on) ;; 
	 (?\x282D . bidi-category-on) ;; 
	 (?\x282E . bidi-category-on) ;; 
	 (?\x282F . bidi-category-on) ;; 
	 (?\x2830 . bidi-category-on) ;; 
	 (?\x2831 . bidi-category-on) ;; 
	 (?\x2832 . bidi-category-on) ;; 
	 (?\x2833 . bidi-category-on) ;; 
	 (?\x2834 . bidi-category-on) ;; 
	 (?\x2835 . bidi-category-on) ;; 
	 (?\x2836 . bidi-category-on) ;; 
	 (?\x2837 . bidi-category-on) ;; 
	 (?\x2838 . bidi-category-on) ;; 
	 (?\x2839 . bidi-category-on) ;; 
	 (?\x283A . bidi-category-on) ;; 
	 (?\x283B . bidi-category-on) ;; 
	 (?\x283C . bidi-category-on) ;; 
	 (?\x283D . bidi-category-on) ;; 
	 (?\x283E . bidi-category-on) ;; 
	 (?\x283F . bidi-category-on) ;; 
	 (?\x2840 . bidi-category-on) ;; 
	 (?\x2841 . bidi-category-on) ;; 
	 (?\x2842 . bidi-category-on) ;; 
	 (?\x2843 . bidi-category-on) ;; 
	 (?\x2844 . bidi-category-on) ;; 
	 (?\x2845 . bidi-category-on) ;; 
	 (?\x2846 . bidi-category-on) ;; 
	 (?\x2847 . bidi-category-on) ;; 
	 (?\x2848 . bidi-category-on) ;; 
	 (?\x2849 . bidi-category-on) ;; 
	 (?\x284A . bidi-category-on) ;; 
	 (?\x284B . bidi-category-on) ;; 
	 (?\x284C . bidi-category-on) ;; 
	 (?\x284D . bidi-category-on) ;; 
	 (?\x284E . bidi-category-on) ;; 
	 (?\x284F . bidi-category-on) ;; 
	 (?\x2850 . bidi-category-on) ;; 
	 (?\x2851 . bidi-category-on) ;; 
	 (?\x2852 . bidi-category-on) ;; 
	 (?\x2853 . bidi-category-on) ;; 
	 (?\x2854 . bidi-category-on) ;; 
	 (?\x2855 . bidi-category-on) ;; 
	 (?\x2856 . bidi-category-on) ;; 
	 (?\x2857 . bidi-category-on) ;; 
	 (?\x2858 . bidi-category-on) ;; 
	 (?\x2859 . bidi-category-on) ;; 
	 (?\x285A . bidi-category-on) ;; 
	 (?\x285B . bidi-category-on) ;; 
	 (?\x285C . bidi-category-on) ;; 
	 (?\x285D . bidi-category-on) ;; 
	 (?\x285E . bidi-category-on) ;; 
	 (?\x285F . bidi-category-on) ;; 
	 (?\x2860 . bidi-category-on) ;; 
	 (?\x2861 . bidi-category-on) ;; 
	 (?\x2862 . bidi-category-on) ;; 
	 (?\x2863 . bidi-category-on) ;; 
	 (?\x2864 . bidi-category-on) ;; 
	 (?\x2865 . bidi-category-on) ;; 
	 (?\x2866 . bidi-category-on) ;; 
	 (?\x2867 . bidi-category-on) ;; 
	 (?\x2868 . bidi-category-on) ;; 
	 (?\x2869 . bidi-category-on) ;; 
	 (?\x286A . bidi-category-on) ;; 
	 (?\x286B . bidi-category-on) ;; 
	 (?\x286C . bidi-category-on) ;; 
	 (?\x286D . bidi-category-on) ;; 
	 (?\x286E . bidi-category-on) ;; 
	 (?\x286F . bidi-category-on) ;; 
	 (?\x2870 . bidi-category-on) ;; 
	 (?\x2871 . bidi-category-on) ;; 
	 (?\x2872 . bidi-category-on) ;; 
	 (?\x2873 . bidi-category-on) ;; 
	 (?\x2874 . bidi-category-on) ;; 
	 (?\x2875 . bidi-category-on) ;; 
	 (?\x2876 . bidi-category-on) ;; 
	 (?\x2877 . bidi-category-on) ;; 
	 (?\x2878 . bidi-category-on) ;; 
	 (?\x2879 . bidi-category-on) ;; 
	 (?\x287A . bidi-category-on) ;; 
	 (?\x287B . bidi-category-on) ;; 
	 (?\x287C . bidi-category-on) ;; 
	 (?\x287D . bidi-category-on) ;; 
	 (?\x287E . bidi-category-on) ;; 
	 (?\x287F . bidi-category-on) ;; 
	 (?\x2880 . bidi-category-on) ;; 
	 (?\x2881 . bidi-category-on) ;; 
	 (?\x2882 . bidi-category-on) ;; 
	 (?\x2883 . bidi-category-on) ;; 
	 (?\x2884 . bidi-category-on) ;; 
	 (?\x2885 . bidi-category-on) ;; 
	 (?\x2886 . bidi-category-on) ;; 
	 (?\x2887 . bidi-category-on) ;; 
	 (?\x2888 . bidi-category-on) ;; 
	 (?\x2889 . bidi-category-on) ;; 
	 (?\x288A . bidi-category-on) ;; 
	 (?\x288B . bidi-category-on) ;; 
	 (?\x288C . bidi-category-on) ;; 
	 (?\x288D . bidi-category-on) ;; 
	 (?\x288E . bidi-category-on) ;; 
	 (?\x288F . bidi-category-on) ;; 
	 (?\x2890 . bidi-category-on) ;; 
	 (?\x2891 . bidi-category-on) ;; 
	 (?\x2892 . bidi-category-on) ;; 
	 (?\x2893 . bidi-category-on) ;; 
	 (?\x2894 . bidi-category-on) ;; 
	 (?\x2895 . bidi-category-on) ;; 
	 (?\x2896 . bidi-category-on) ;; 
	 (?\x2897 . bidi-category-on) ;; 
	 (?\x2898 . bidi-category-on) ;; 
	 (?\x2899 . bidi-category-on) ;; 
	 (?\x289A . bidi-category-on) ;; 
	 (?\x289B . bidi-category-on) ;; 
	 (?\x289C . bidi-category-on) ;; 
	 (?\x289D . bidi-category-on) ;; 
	 (?\x289E . bidi-category-on) ;; 
	 (?\x289F . bidi-category-on) ;; 
	 (?\x28A0 . bidi-category-on) ;; 
	 (?\x28A1 . bidi-category-on) ;; 
	 (?\x28A2 . bidi-category-on) ;; 
	 (?\x28A3 . bidi-category-on) ;; 
	 (?\x28A4 . bidi-category-on) ;; 
	 (?\x28A5 . bidi-category-on) ;; 
	 (?\x28A6 . bidi-category-on) ;; 
	 (?\x28A7 . bidi-category-on) ;; 
	 (?\x28A8 . bidi-category-on) ;; 
	 (?\x28A9 . bidi-category-on) ;; 
	 (?\x28AA . bidi-category-on) ;; 
	 (?\x28AB . bidi-category-on) ;; 
	 (?\x28AC . bidi-category-on) ;; 
	 (?\x28AD . bidi-category-on) ;; 
	 (?\x28AE . bidi-category-on) ;; 
	 (?\x28AF . bidi-category-on) ;; 
	 (?\x28B0 . bidi-category-on) ;; 
	 (?\x28B1 . bidi-category-on) ;; 
	 (?\x28B2 . bidi-category-on) ;; 
	 (?\x28B3 . bidi-category-on) ;; 
	 (?\x28B4 . bidi-category-on) ;; 
	 (?\x28B5 . bidi-category-on) ;; 
	 (?\x28B6 . bidi-category-on) ;; 
	 (?\x28B7 . bidi-category-on) ;; 
	 (?\x28B8 . bidi-category-on) ;; 
	 (?\x28B9 . bidi-category-on) ;; 
	 (?\x28BA . bidi-category-on) ;; 
	 (?\x28BB . bidi-category-on) ;; 
	 (?\x28BC . bidi-category-on) ;; 
	 (?\x28BD . bidi-category-on) ;; 
	 (?\x28BE . bidi-category-on) ;; 
	 (?\x28BF . bidi-category-on) ;; 
	 (?\x28C0 . bidi-category-on) ;; 
	 (?\x28C1 . bidi-category-on) ;; 
	 (?\x28C2 . bidi-category-on) ;; 
	 (?\x28C3 . bidi-category-on) ;; 
	 (?\x28C4 . bidi-category-on) ;; 
	 (?\x28C5 . bidi-category-on) ;; 
	 (?\x28C6 . bidi-category-on) ;; 
	 (?\x28C7 . bidi-category-on) ;; 
	 (?\x28C8 . bidi-category-on) ;; 
	 (?\x28C9 . bidi-category-on) ;; 
	 (?\x28CA . bidi-category-on) ;; 
	 (?\x28CB . bidi-category-on) ;; 
	 (?\x28CC . bidi-category-on) ;; 
	 (?\x28CD . bidi-category-on) ;; 
	 (?\x28CE . bidi-category-on) ;; 
	 (?\x28CF . bidi-category-on) ;; 
	 (?\x28D0 . bidi-category-on) ;; 
	 (?\x28D1 . bidi-category-on) ;; 
	 (?\x28D2 . bidi-category-on) ;; 
	 (?\x28D3 . bidi-category-on) ;; 
	 (?\x28D4 . bidi-category-on) ;; 
	 (?\x28D5 . bidi-category-on) ;; 
	 (?\x28D6 . bidi-category-on) ;; 
	 (?\x28D7 . bidi-category-on) ;; 
	 (?\x28D8 . bidi-category-on) ;; 
	 (?\x28D9 . bidi-category-on) ;; 
	 (?\x28DA . bidi-category-on) ;; 
	 (?\x28DB . bidi-category-on) ;; 
	 (?\x28DC . bidi-category-on) ;; 
	 (?\x28DD . bidi-category-on) ;; 
	 (?\x28DE . bidi-category-on) ;; 
	 (?\x28DF . bidi-category-on) ;; 
	 (?\x28E0 . bidi-category-on) ;; 
	 (?\x28E1 . bidi-category-on) ;; 
	 (?\x28E2 . bidi-category-on) ;; 
	 (?\x28E3 . bidi-category-on) ;; 
	 (?\x28E4 . bidi-category-on) ;; 
	 (?\x28E5 . bidi-category-on) ;; 
	 (?\x28E6 . bidi-category-on) ;; 
	 (?\x28E7 . bidi-category-on) ;; 
	 (?\x28E8 . bidi-category-on) ;; 
	 (?\x28E9 . bidi-category-on) ;; 
	 (?\x28EA . bidi-category-on) ;; 
	 (?\x28EB . bidi-category-on) ;; 
	 (?\x28EC . bidi-category-on) ;; 
	 (?\x28ED . bidi-category-on) ;; 
	 (?\x28EE . bidi-category-on) ;; 
	 (?\x28EF . bidi-category-on) ;; 
	 (?\x28F0 . bidi-category-on) ;; 
	 (?\x28F1 . bidi-category-on) ;; 
	 (?\x28F2 . bidi-category-on) ;; 
	 (?\x28F3 . bidi-category-on) ;; 
	 (?\x28F4 . bidi-category-on) ;; 
	 (?\x28F5 . bidi-category-on) ;; 
	 (?\x28F6 . bidi-category-on) ;; 
	 (?\x28F7 . bidi-category-on) ;; 
	 (?\x28F8 . bidi-category-on) ;; 
	 (?\x28F9 . bidi-category-on) ;; 
	 (?\x28FA . bidi-category-on) ;; 
	 (?\x28FB . bidi-category-on) ;; 
	 (?\x28FC . bidi-category-on) ;; 
	 (?\x28FD . bidi-category-on) ;; 
	 (?\x28FE . bidi-category-on) ;; 
	 (?\x28FF . bidi-category-on) ;; 
	 (?\x2E80 . bidi-category-on) ;; 
	 (?\x2E81 . bidi-category-on) ;; 
	 (?\x2E82 . bidi-category-on) ;; 
	 (?\x2E83 . bidi-category-on) ;; 
	 (?\x2E84 . bidi-category-on) ;; 
	 (?\x2E85 . bidi-category-on) ;; 
	 (?\x2E86 . bidi-category-on) ;; 
	 (?\x2E87 . bidi-category-on) ;; 
	 (?\x2E88 . bidi-category-on) ;; 
	 (?\x2E89 . bidi-category-on) ;; 
	 (?\x2E8A . bidi-category-on) ;; 
	 (?\x2E8B . bidi-category-on) ;; 
	 (?\x2E8C . bidi-category-on) ;; 
	 (?\x2E8D . bidi-category-on) ;; 
	 (?\x2E8E . bidi-category-on) ;; 
	 (?\x2E8F . bidi-category-on) ;; 
	 (?\x2E90 . bidi-category-on) ;; 
	 (?\x2E91 . bidi-category-on) ;; 
	 (?\x2E92 . bidi-category-on) ;; 
	 (?\x2E93 . bidi-category-on) ;; 
	 (?\x2E94 . bidi-category-on) ;; 
	 (?\x2E95 . bidi-category-on) ;; 
	 (?\x2E96 . bidi-category-on) ;; 
	 (?\x2E97 . bidi-category-on) ;; 
	 (?\x2E98 . bidi-category-on) ;; 
	 (?\x2E99 . bidi-category-on) ;; 
	 (?\x2E9B . bidi-category-on) ;; 
	 (?\x2E9C . bidi-category-on) ;; 
	 (?\x2E9D . bidi-category-on) ;; 
	 (?\x2E9E . bidi-category-on) ;; 
	 (?\x2E9F . bidi-category-on) ;; 
	 (?\x2EA0 . bidi-category-on) ;; 
	 (?\x2EA1 . bidi-category-on) ;; 
	 (?\x2EA2 . bidi-category-on) ;; 
	 (?\x2EA3 . bidi-category-on) ;; 
	 (?\x2EA4 . bidi-category-on) ;; 
	 (?\x2EA5 . bidi-category-on) ;; 
	 (?\x2EA6 . bidi-category-on) ;; 
	 (?\x2EA7 . bidi-category-on) ;; 
	 (?\x2EA8 . bidi-category-on) ;; 
	 (?\x2EA9 . bidi-category-on) ;; 
	 (?\x2EAA . bidi-category-on) ;; 
	 (?\x2EAB . bidi-category-on) ;; 
	 (?\x2EAC . bidi-category-on) ;; 
	 (?\x2EAD . bidi-category-on) ;; 
	 (?\x2EAE . bidi-category-on) ;; 
	 (?\x2EAF . bidi-category-on) ;; 
	 (?\x2EB0 . bidi-category-on) ;; 
	 (?\x2EB1 . bidi-category-on) ;; 
	 (?\x2EB2 . bidi-category-on) ;; 
	 (?\x2EB3 . bidi-category-on) ;; 
	 (?\x2EB4 . bidi-category-on) ;; 
	 (?\x2EB5 . bidi-category-on) ;; 
	 (?\x2EB6 . bidi-category-on) ;; 
	 (?\x2EB7 . bidi-category-on) ;; 
	 (?\x2EB8 . bidi-category-on) ;; 
	 (?\x2EB9 . bidi-category-on) ;; 
	 (?\x2EBA . bidi-category-on) ;; 
	 (?\x2EBB . bidi-category-on) ;; 
	 (?\x2EBC . bidi-category-on) ;; 
	 (?\x2EBD . bidi-category-on) ;; 
	 (?\x2EBE . bidi-category-on) ;; 
	 (?\x2EBF . bidi-category-on) ;; 
	 (?\x2EC0 . bidi-category-on) ;; 
	 (?\x2EC1 . bidi-category-on) ;; 
	 (?\x2EC2 . bidi-category-on) ;; 
	 (?\x2EC3 . bidi-category-on) ;; 
	 (?\x2EC4 . bidi-category-on) ;; 
	 (?\x2EC5 . bidi-category-on) ;; 
	 (?\x2EC6 . bidi-category-on) ;; 
	 (?\x2EC7 . bidi-category-on) ;; 
	 (?\x2EC8 . bidi-category-on) ;; 
	 (?\x2EC9 . bidi-category-on) ;; 
	 (?\x2ECA . bidi-category-on) ;; 
	 (?\x2ECB . bidi-category-on) ;; 
	 (?\x2ECC . bidi-category-on) ;; 
	 (?\x2ECD . bidi-category-on) ;; 
	 (?\x2ECE . bidi-category-on) ;; 
	 (?\x2ECF . bidi-category-on) ;; 
	 (?\x2ED0 . bidi-category-on) ;; 
	 (?\x2ED1 . bidi-category-on) ;; 
	 (?\x2ED2 . bidi-category-on) ;; 
	 (?\x2ED3 . bidi-category-on) ;; 
	 (?\x2ED4 . bidi-category-on) ;; 
	 (?\x2ED5 . bidi-category-on) ;; 
	 (?\x2ED6 . bidi-category-on) ;; 
	 (?\x2ED7 . bidi-category-on) ;; 
	 (?\x2ED8 . bidi-category-on) ;; 
	 (?\x2ED9 . bidi-category-on) ;; 
	 (?\x2EDA . bidi-category-on) ;; 
	 (?\x2EDB . bidi-category-on) ;; 
	 (?\x2EDC . bidi-category-on) ;; 
	 (?\x2EDD . bidi-category-on) ;; 
	 (?\x2EDE . bidi-category-on) ;; 
	 (?\x2EDF . bidi-category-on) ;; 
	 (?\x2EE0 . bidi-category-on) ;; 
	 (?\x2EE1 . bidi-category-on) ;; 
	 (?\x2EE2 . bidi-category-on) ;; 
	 (?\x2EE3 . bidi-category-on) ;; 
	 (?\x2EE4 . bidi-category-on) ;; 
	 (?\x2EE5 . bidi-category-on) ;; 
	 (?\x2EE6 . bidi-category-on) ;; 
	 (?\x2EE7 . bidi-category-on) ;; 
	 (?\x2EE8 . bidi-category-on) ;; 
	 (?\x2EE9 . bidi-category-on) ;; 
	 (?\x2EEA . bidi-category-on) ;; 
	 (?\x2EEB . bidi-category-on) ;; 
	 (?\x2EEC . bidi-category-on) ;; 
	 (?\x2EED . bidi-category-on) ;; 
	 (?\x2EEE . bidi-category-on) ;; 
	 (?\x2EEF . bidi-category-on) ;; 
	 (?\x2EF0 . bidi-category-on) ;; 
	 (?\x2EF1 . bidi-category-on) ;; 
	 (?\x2EF2 . bidi-category-on) ;; 
	 (?\x2EF3 . bidi-category-on) ;; 
	 (?\x2F00 . bidi-category-on) ;; 
	 (?\x2F01 . bidi-category-on) ;; 
	 (?\x2F02 . bidi-category-on) ;; 
	 (?\x2F03 . bidi-category-on) ;; 
	 (?\x2F04 . bidi-category-on) ;; 
	 (?\x2F05 . bidi-category-on) ;; 
	 (?\x2F06 . bidi-category-on) ;; 
	 (?\x2F07 . bidi-category-on) ;; 
	 (?\x2F08 . bidi-category-on) ;; 
	 (?\x2F09 . bidi-category-on) ;; 
	 (?\x2F0A . bidi-category-on) ;; 
	 (?\x2F0B . bidi-category-on) ;; 
	 (?\x2F0C . bidi-category-on) ;; 
	 (?\x2F0D . bidi-category-on) ;; 
	 (?\x2F0E . bidi-category-on) ;; 
	 (?\x2F0F . bidi-category-on) ;; 
	 (?\x2F10 . bidi-category-on) ;; 
	 (?\x2F11 . bidi-category-on) ;; 
	 (?\x2F12 . bidi-category-on) ;; 
	 (?\x2F13 . bidi-category-on) ;; 
	 (?\x2F14 . bidi-category-on) ;; 
	 (?\x2F15 . bidi-category-on) ;; 
	 (?\x2F16 . bidi-category-on) ;; 
	 (?\x2F17 . bidi-category-on) ;; 
	 (?\x2F18 . bidi-category-on) ;; 
	 (?\x2F19 . bidi-category-on) ;; 
	 (?\x2F1A . bidi-category-on) ;; 
	 (?\x2F1B . bidi-category-on) ;; 
	 (?\x2F1C . bidi-category-on) ;; 
	 (?\x2F1D . bidi-category-on) ;; 
	 (?\x2F1E . bidi-category-on) ;; 
	 (?\x2F1F . bidi-category-on) ;; 
	 (?\x2F20 . bidi-category-on) ;; 
	 (?\x2F21 . bidi-category-on) ;; 
	 (?\x2F22 . bidi-category-on) ;; 
	 (?\x2F23 . bidi-category-on) ;; 
	 (?\x2F24 . bidi-category-on) ;; 
	 (?\x2F25 . bidi-category-on) ;; 
	 (?\x2F26 . bidi-category-on) ;; 
	 (?\x2F27 . bidi-category-on) ;; 
	 (?\x2F28 . bidi-category-on) ;; 
	 (?\x2F29 . bidi-category-on) ;; 
	 (?\x2F2A . bidi-category-on) ;; 
	 (?\x2F2B . bidi-category-on) ;; 
	 (?\x2F2C . bidi-category-on) ;; 
	 (?\x2F2D . bidi-category-on) ;; 
	 (?\x2F2E . bidi-category-on) ;; 
	 (?\x2F2F . bidi-category-on) ;; 
	 (?\x2F30 . bidi-category-on) ;; 
	 (?\x2F31 . bidi-category-on) ;; 
	 (?\x2F32 . bidi-category-on) ;; 
	 (?\x2F33 . bidi-category-on) ;; 
	 (?\x2F34 . bidi-category-on) ;; 
	 (?\x2F35 . bidi-category-on) ;; 
	 (?\x2F36 . bidi-category-on) ;; 
	 (?\x2F37 . bidi-category-on) ;; 
	 (?\x2F38 . bidi-category-on) ;; 
	 (?\x2F39 . bidi-category-on) ;; 
	 (?\x2F3A . bidi-category-on) ;; 
	 (?\x2F3B . bidi-category-on) ;; 
	 (?\x2F3C . bidi-category-on) ;; 
	 (?\x2F3D . bidi-category-on) ;; 
	 (?\x2F3E . bidi-category-on) ;; 
	 (?\x2F3F . bidi-category-on) ;; 
	 (?\x2F40 . bidi-category-on) ;; 
	 (?\x2F41 . bidi-category-on) ;; 
	 (?\x2F42 . bidi-category-on) ;; 
	 (?\x2F43 . bidi-category-on) ;; 
	 (?\x2F44 . bidi-category-on) ;; 
	 (?\x2F45 . bidi-category-on) ;; 
	 (?\x2F46 . bidi-category-on) ;; 
	 (?\x2F47 . bidi-category-on) ;; 
	 (?\x2F48 . bidi-category-on) ;; 
	 (?\x2F49 . bidi-category-on) ;; 
	 (?\x2F4A . bidi-category-on) ;; 
	 (?\x2F4B . bidi-category-on) ;; 
	 (?\x2F4C . bidi-category-on) ;; 
	 (?\x2F4D . bidi-category-on) ;; 
	 (?\x2F4E . bidi-category-on) ;; 
	 (?\x2F4F . bidi-category-on) ;; 
	 (?\x2F50 . bidi-category-on) ;; 
	 (?\x2F51 . bidi-category-on) ;; 
	 (?\x2F52 . bidi-category-on) ;; 
	 (?\x2F53 . bidi-category-on) ;; 
	 (?\x2F54 . bidi-category-on) ;; 
	 (?\x2F55 . bidi-category-on) ;; 
	 (?\x2F56 . bidi-category-on) ;; 
	 (?\x2F57 . bidi-category-on) ;; 
	 (?\x2F58 . bidi-category-on) ;; 
	 (?\x2F59 . bidi-category-on) ;; 
	 (?\x2F5A . bidi-category-on) ;; 
	 (?\x2F5B . bidi-category-on) ;; 
	 (?\x2F5C . bidi-category-on) ;; 
	 (?\x2F5D . bidi-category-on) ;; 
	 (?\x2F5E . bidi-category-on) ;; 
	 (?\x2F5F . bidi-category-on) ;; 
	 (?\x2F60 . bidi-category-on) ;; 
	 (?\x2F61 . bidi-category-on) ;; 
	 (?\x2F62 . bidi-category-on) ;; 
	 (?\x2F63 . bidi-category-on) ;; 
	 (?\x2F64 . bidi-category-on) ;; 
	 (?\x2F65 . bidi-category-on) ;; 
	 (?\x2F66 . bidi-category-on) ;; 
	 (?\x2F67 . bidi-category-on) ;; 
	 (?\x2F68 . bidi-category-on) ;; 
	 (?\x2F69 . bidi-category-on) ;; 
	 (?\x2F6A . bidi-category-on) ;; 
	 (?\x2F6B . bidi-category-on) ;; 
	 (?\x2F6C . bidi-category-on) ;; 
	 (?\x2F6D . bidi-category-on) ;; 
	 (?\x2F6E . bidi-category-on) ;; 
	 (?\x2F6F . bidi-category-on) ;; 
	 (?\x2F70 . bidi-category-on) ;; 
	 (?\x2F71 . bidi-category-on) ;; 
	 (?\x2F72 . bidi-category-on) ;; 
	 (?\x2F73 . bidi-category-on) ;; 
	 (?\x2F74 . bidi-category-on) ;; 
	 (?\x2F75 . bidi-category-on) ;; 
	 (?\x2F76 . bidi-category-on) ;; 
	 (?\x2F77 . bidi-category-on) ;; 
	 (?\x2F78 . bidi-category-on) ;; 
	 (?\x2F79 . bidi-category-on) ;; 
	 (?\x2F7A . bidi-category-on) ;; 
	 (?\x2F7B . bidi-category-on) ;; 
	 (?\x2F7C . bidi-category-on) ;; 
	 (?\x2F7D . bidi-category-on) ;; 
	 (?\x2F7E . bidi-category-on) ;; 
	 (?\x2F7F . bidi-category-on) ;; 
	 (?\x2F80 . bidi-category-on) ;; 
	 (?\x2F81 . bidi-category-on) ;; 
	 (?\x2F82 . bidi-category-on) ;; 
	 (?\x2F83 . bidi-category-on) ;; 
	 (?\x2F84 . bidi-category-on) ;; 
	 (?\x2F85 . bidi-category-on) ;; 
	 (?\x2F86 . bidi-category-on) ;; 
	 (?\x2F87 . bidi-category-on) ;; 
	 (?\x2F88 . bidi-category-on) ;; 
	 (?\x2F89 . bidi-category-on) ;; 
	 (?\x2F8A . bidi-category-on) ;; 
	 (?\x2F8B . bidi-category-on) ;; 
	 (?\x2F8C . bidi-category-on) ;; 
	 (?\x2F8D . bidi-category-on) ;; 
	 (?\x2F8E . bidi-category-on) ;; 
	 (?\x2F8F . bidi-category-on) ;; 
	 (?\x2F90 . bidi-category-on) ;; 
	 (?\x2F91 . bidi-category-on) ;; 
	 (?\x2F92 . bidi-category-on) ;; 
	 (?\x2F93 . bidi-category-on) ;; 
	 (?\x2F94 . bidi-category-on) ;; 
	 (?\x2F95 . bidi-category-on) ;; 
	 (?\x2F96 . bidi-category-on) ;; 
	 (?\x2F97 . bidi-category-on) ;; 
	 (?\x2F98 . bidi-category-on) ;; 
	 (?\x2F99 . bidi-category-on) ;; 
	 (?\x2F9A . bidi-category-on) ;; 
	 (?\x2F9B . bidi-category-on) ;; 
	 (?\x2F9C . bidi-category-on) ;; 
	 (?\x2F9D . bidi-category-on) ;; 
	 (?\x2F9E . bidi-category-on) ;; 
	 (?\x2F9F . bidi-category-on) ;; 
	 (?\x2FA0 . bidi-category-on) ;; 
	 (?\x2FA1 . bidi-category-on) ;; 
	 (?\x2FA2 . bidi-category-on) ;; 
	 (?\x2FA3 . bidi-category-on) ;; 
	 (?\x2FA4 . bidi-category-on) ;; 
	 (?\x2FA5 . bidi-category-on) ;; 
	 (?\x2FA6 . bidi-category-on) ;; 
	 (?\x2FA7 . bidi-category-on) ;; 
	 (?\x2FA8 . bidi-category-on) ;; 
	 (?\x2FA9 . bidi-category-on) ;; 
	 (?\x2FAA . bidi-category-on) ;; 
	 (?\x2FAB . bidi-category-on) ;; 
	 (?\x2FAC . bidi-category-on) ;; 
	 (?\x2FAD . bidi-category-on) ;; 
	 (?\x2FAE . bidi-category-on) ;; 
	 (?\x2FAF . bidi-category-on) ;; 
	 (?\x2FB0 . bidi-category-on) ;; 
	 (?\x2FB1 . bidi-category-on) ;; 
	 (?\x2FB2 . bidi-category-on) ;; 
	 (?\x2FB3 . bidi-category-on) ;; 
	 (?\x2FB4 . bidi-category-on) ;; 
	 (?\x2FB5 . bidi-category-on) ;; 
	 (?\x2FB6 . bidi-category-on) ;; 
	 (?\x2FB7 . bidi-category-on) ;; 
	 (?\x2FB8 . bidi-category-on) ;; 
	 (?\x2FB9 . bidi-category-on) ;; 
	 (?\x2FBA . bidi-category-on) ;; 
	 (?\x2FBB . bidi-category-on) ;; 
	 (?\x2FBC . bidi-category-on) ;; 
	 (?\x2FBD . bidi-category-on) ;; 
	 (?\x2FBE . bidi-category-on) ;; 
	 (?\x2FBF . bidi-category-on) ;; 
	 (?\x2FC0 . bidi-category-on) ;; 
	 (?\x2FC1 . bidi-category-on) ;; 
	 (?\x2FC2 . bidi-category-on) ;; 
	 (?\x2FC3 . bidi-category-on) ;; 
	 (?\x2FC4 . bidi-category-on) ;; 
	 (?\x2FC5 . bidi-category-on) ;; 
	 (?\x2FC6 . bidi-category-on) ;; 
	 (?\x2FC7 . bidi-category-on) ;; 
	 (?\x2FC8 . bidi-category-on) ;; 
	 (?\x2FC9 . bidi-category-on) ;; 
	 (?\x2FCA . bidi-category-on) ;; 
	 (?\x2FCB . bidi-category-on) ;; 
	 (?\x2FCC . bidi-category-on) ;; 
	 (?\x2FCD . bidi-category-on) ;; 
	 (?\x2FCE . bidi-category-on) ;; 
	 (?\x2FCF . bidi-category-on) ;; 
	 (?\x2FD0 . bidi-category-on) ;; 
	 (?\x2FD1 . bidi-category-on) ;; 
	 (?\x2FD2 . bidi-category-on) ;; 
	 (?\x2FD3 . bidi-category-on) ;; 
	 (?\x2FD4 . bidi-category-on) ;; 
	 (?\x2FD5 . bidi-category-on) ;; 
	 (?\x2FF0 . bidi-category-on) ;; 
	 (?\x2FF1 . bidi-category-on) ;; 
	 (?\x2FF2 . bidi-category-on) ;; 
	 (?\x2FF3 . bidi-category-on) ;; 
	 (?\x2FF4 . bidi-category-on) ;; 
	 (?\x2FF5 . bidi-category-on) ;; 
	 (?\x2FF6 . bidi-category-on) ;; 
	 (?\x2FF7 . bidi-category-on) ;; 
	 (?\x2FF8 . bidi-category-on) ;; 
	 (?\x2FF9 . bidi-category-on) ;; 
	 (?\x2FFA . bidi-category-on) ;; 
	 (?\x2FFB . bidi-category-on) ;; 
	 (?\x3000 . bidi-category-ws) ;; 
	 (?\x3001 . bidi-category-on) ;; 
	 (?\x3002 . bidi-category-on) ;; IDEOGRAPHIC PERIOD
	 (?\x3003 . bidi-category-on) ;; 
	 (?\x3004 . bidi-category-on) ;; 
	 (?\x3005 . bidi-category-l) ;; 
	 (?\x3006 . bidi-category-l) ;; 
	 (?\x3007 . bidi-category-l) ;; 
	 (?\x3008 . bidi-category-on) ;; OPENING ANGLE BRACKET
	 (?\x3009 . bidi-category-on) ;; CLOSING ANGLE BRACKET
	 (?\x300A . bidi-category-on) ;; OPENING DOUBLE ANGLE BRACKET
	 (?\x300B . bidi-category-on) ;; CLOSING DOUBLE ANGLE BRACKET
	 (?\x300C . bidi-category-on) ;; OPENING CORNER BRACKET
	 (?\x300D . bidi-category-on) ;; CLOSING CORNER BRACKET
	 (?\x300E . bidi-category-on) ;; OPENING WHITE CORNER BRACKET
	 (?\x300F . bidi-category-on) ;; CLOSING WHITE CORNER BRACKET
	 (?\x3010 . bidi-category-on) ;; OPENING BLACK LENTICULAR BRACKET
	 (?\x3011 . bidi-category-on) ;; CLOSING BLACK LENTICULAR BRACKET
	 (?\x3012 . bidi-category-on) ;; 
	 (?\x3013 . bidi-category-on) ;; 
	 (?\x3014 . bidi-category-on) ;; OPENING TORTOISE SHELL BRACKET
	 (?\x3015 . bidi-category-on) ;; CLOSING TORTOISE SHELL BRACKET
	 (?\x3016 . bidi-category-on) ;; OPENING WHITE LENTICULAR BRACKET
	 (?\x3017 . bidi-category-on) ;; CLOSING WHITE LENTICULAR BRACKET
	 (?\x3018 . bidi-category-on) ;; OPENING WHITE TORTOISE SHELL BRACKET
	 (?\x3019 . bidi-category-on) ;; CLOSING WHITE TORTOISE SHELL BRACKET
	 (?\x301A . bidi-category-on) ;; OPENING WHITE SQUARE BRACKET
	 (?\x301B . bidi-category-on) ;; CLOSING WHITE SQUARE BRACKET
	 (?\x301C . bidi-category-on) ;; 
	 (?\x301D . bidi-category-on) ;; 
	 (?\x301E . bidi-category-on) ;; 
	 (?\x301F . bidi-category-on) ;; 
	 (?\x3020 . bidi-category-on) ;; 
	 (?\x3021 . bidi-category-l) ;; 
	 (?\x3022 . bidi-category-l) ;; 
	 (?\x3023 . bidi-category-l) ;; 
	 (?\x3024 . bidi-category-l) ;; 
	 (?\x3025 . bidi-category-l) ;; 
	 (?\x3026 . bidi-category-l) ;; 
	 (?\x3027 . bidi-category-l) ;; 
	 (?\x3028 . bidi-category-l) ;; 
	 (?\x3029 . bidi-category-l) ;; 
	 (?\x302A . bidi-category-nsm) ;; 
	 (?\x302B . bidi-category-nsm) ;; 
	 (?\x302C . bidi-category-nsm) ;; 
	 (?\x302D . bidi-category-nsm) ;; 
	 (?\x302E . bidi-category-nsm) ;; 
	 (?\x302F . bidi-category-nsm) ;; 
	 (?\x3030 . bidi-category-on) ;; 
	 (?\x3031 . bidi-category-l) ;; 
	 (?\x3032 . bidi-category-l) ;; 
	 (?\x3033 . bidi-category-l) ;; 
	 (?\x3034 . bidi-category-l) ;; 
	 (?\x3035 . bidi-category-l) ;; 
	 (?\x3036 . bidi-category-on) ;; 
	 (?\x3037 . bidi-category-on) ;; 
	 (?\x3038 . bidi-category-l) ;; 
	 (?\x3039 . bidi-category-l) ;; 
	 (?\x303A . bidi-category-l) ;; 
	 (?\x303E . bidi-category-on) ;; 
	 (?\x303F . bidi-category-on) ;; 
	 (?\x3041 . bidi-category-l) ;; 
	 (?\x3042 . bidi-category-l) ;; 
	 (?\x3043 . bidi-category-l) ;; 
	 (?\x3044 . bidi-category-l) ;; 
	 (?\x3045 . bidi-category-l) ;; 
	 (?\x3046 . bidi-category-l) ;; 
	 (?\x3047 . bidi-category-l) ;; 
	 (?\x3048 . bidi-category-l) ;; 
	 (?\x3049 . bidi-category-l) ;; 
	 (?\x304A . bidi-category-l) ;; 
	 (?\x304B . bidi-category-l) ;; 
	 (?\x304C . bidi-category-l) ;; 
	 (?\x304D . bidi-category-l) ;; 
	 (?\x304E . bidi-category-l) ;; 
	 (?\x304F . bidi-category-l) ;; 
	 (?\x3050 . bidi-category-l) ;; 
	 (?\x3051 . bidi-category-l) ;; 
	 (?\x3052 . bidi-category-l) ;; 
	 (?\x3053 . bidi-category-l) ;; 
	 (?\x3054 . bidi-category-l) ;; 
	 (?\x3055 . bidi-category-l) ;; 
	 (?\x3056 . bidi-category-l) ;; 
	 (?\x3057 . bidi-category-l) ;; 
	 (?\x3058 . bidi-category-l) ;; 
	 (?\x3059 . bidi-category-l) ;; 
	 (?\x305A . bidi-category-l) ;; 
	 (?\x305B . bidi-category-l) ;; 
	 (?\x305C . bidi-category-l) ;; 
	 (?\x305D . bidi-category-l) ;; 
	 (?\x305E . bidi-category-l) ;; 
	 (?\x305F . bidi-category-l) ;; 
	 (?\x3060 . bidi-category-l) ;; 
	 (?\x3061 . bidi-category-l) ;; 
	 (?\x3062 . bidi-category-l) ;; 
	 (?\x3063 . bidi-category-l) ;; 
	 (?\x3064 . bidi-category-l) ;; 
	 (?\x3065 . bidi-category-l) ;; 
	 (?\x3066 . bidi-category-l) ;; 
	 (?\x3067 . bidi-category-l) ;; 
	 (?\x3068 . bidi-category-l) ;; 
	 (?\x3069 . bidi-category-l) ;; 
	 (?\x306A . bidi-category-l) ;; 
	 (?\x306B . bidi-category-l) ;; 
	 (?\x306C . bidi-category-l) ;; 
	 (?\x306D . bidi-category-l) ;; 
	 (?\x306E . bidi-category-l) ;; 
	 (?\x306F . bidi-category-l) ;; 
	 (?\x3070 . bidi-category-l) ;; 
	 (?\x3071 . bidi-category-l) ;; 
	 (?\x3072 . bidi-category-l) ;; 
	 (?\x3073 . bidi-category-l) ;; 
	 (?\x3074 . bidi-category-l) ;; 
	 (?\x3075 . bidi-category-l) ;; 
	 (?\x3076 . bidi-category-l) ;; 
	 (?\x3077 . bidi-category-l) ;; 
	 (?\x3078 . bidi-category-l) ;; 
	 (?\x3079 . bidi-category-l) ;; 
	 (?\x307A . bidi-category-l) ;; 
	 (?\x307B . bidi-category-l) ;; 
	 (?\x307C . bidi-category-l) ;; 
	 (?\x307D . bidi-category-l) ;; 
	 (?\x307E . bidi-category-l) ;; 
	 (?\x307F . bidi-category-l) ;; 
	 (?\x3080 . bidi-category-l) ;; 
	 (?\x3081 . bidi-category-l) ;; 
	 (?\x3082 . bidi-category-l) ;; 
	 (?\x3083 . bidi-category-l) ;; 
	 (?\x3084 . bidi-category-l) ;; 
	 (?\x3085 . bidi-category-l) ;; 
	 (?\x3086 . bidi-category-l) ;; 
	 (?\x3087 . bidi-category-l) ;; 
	 (?\x3088 . bidi-category-l) ;; 
	 (?\x3089 . bidi-category-l) ;; 
	 (?\x308A . bidi-category-l) ;; 
	 (?\x308B . bidi-category-l) ;; 
	 (?\x308C . bidi-category-l) ;; 
	 (?\x308D . bidi-category-l) ;; 
	 (?\x308E . bidi-category-l) ;; 
	 (?\x308F . bidi-category-l) ;; 
	 (?\x3090 . bidi-category-l) ;; 
	 (?\x3091 . bidi-category-l) ;; 
	 (?\x3092 . bidi-category-l) ;; 
	 (?\x3093 . bidi-category-l) ;; 
	 (?\x3094 . bidi-category-l) ;; 
	 (?\x3099 . bidi-category-nsm) ;; NON-SPACING KATAKANA-HIRAGANA VOICED SOUND MARK
	 (?\x309A . bidi-category-nsm) ;; NON-SPACING KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
	 (?\x309B . bidi-category-on) ;; 
	 (?\x309C . bidi-category-on) ;; 
	 (?\x309D . bidi-category-l) ;; 
	 (?\x309E . bidi-category-l) ;; 
	 (?\x30A1 . bidi-category-l) ;; 
	 (?\x30A2 . bidi-category-l) ;; 
	 (?\x30A3 . bidi-category-l) ;; 
	 (?\x30A4 . bidi-category-l) ;; 
	 (?\x30A5 . bidi-category-l) ;; 
	 (?\x30A6 . bidi-category-l) ;; 
	 (?\x30A7 . bidi-category-l) ;; 
	 (?\x30A8 . bidi-category-l) ;; 
	 (?\x30A9 . bidi-category-l) ;; 
	 (?\x30AA . bidi-category-l) ;; 
	 (?\x30AB . bidi-category-l) ;; 
	 (?\x30AC . bidi-category-l) ;; 
	 (?\x30AD . bidi-category-l) ;; 
	 (?\x30AE . bidi-category-l) ;; 
	 (?\x30AF . bidi-category-l) ;; 
	 (?\x30B0 . bidi-category-l) ;; 
	 (?\x30B1 . bidi-category-l) ;; 
	 (?\x30B2 . bidi-category-l) ;; 
	 (?\x30B3 . bidi-category-l) ;; 
	 (?\x30B4 . bidi-category-l) ;; 
	 (?\x30B5 . bidi-category-l) ;; 
	 (?\x30B6 . bidi-category-l) ;; 
	 (?\x30B7 . bidi-category-l) ;; 
	 (?\x30B8 . bidi-category-l) ;; 
	 (?\x30B9 . bidi-category-l) ;; 
	 (?\x30BA . bidi-category-l) ;; 
	 (?\x30BB . bidi-category-l) ;; 
	 (?\x30BC . bidi-category-l) ;; 
	 (?\x30BD . bidi-category-l) ;; 
	 (?\x30BE . bidi-category-l) ;; 
	 (?\x30BF . bidi-category-l) ;; 
	 (?\x30C0 . bidi-category-l) ;; 
	 (?\x30C1 . bidi-category-l) ;; 
	 (?\x30C2 . bidi-category-l) ;; 
	 (?\x30C3 . bidi-category-l) ;; 
	 (?\x30C4 . bidi-category-l) ;; 
	 (?\x30C5 . bidi-category-l) ;; 
	 (?\x30C6 . bidi-category-l) ;; 
	 (?\x30C7 . bidi-category-l) ;; 
	 (?\x30C8 . bidi-category-l) ;; 
	 (?\x30C9 . bidi-category-l) ;; 
	 (?\x30CA . bidi-category-l) ;; 
	 (?\x30CB . bidi-category-l) ;; 
	 (?\x30CC . bidi-category-l) ;; 
	 (?\x30CD . bidi-category-l) ;; 
	 (?\x30CE . bidi-category-l) ;; 
	 (?\x30CF . bidi-category-l) ;; 
	 (?\x30D0 . bidi-category-l) ;; 
	 (?\x30D1 . bidi-category-l) ;; 
	 (?\x30D2 . bidi-category-l) ;; 
	 (?\x30D3 . bidi-category-l) ;; 
	 (?\x30D4 . bidi-category-l) ;; 
	 (?\x30D5 . bidi-category-l) ;; 
	 (?\x30D6 . bidi-category-l) ;; 
	 (?\x30D7 . bidi-category-l) ;; 
	 (?\x30D8 . bidi-category-l) ;; 
	 (?\x30D9 . bidi-category-l) ;; 
	 (?\x30DA . bidi-category-l) ;; 
	 (?\x30DB . bidi-category-l) ;; 
	 (?\x30DC . bidi-category-l) ;; 
	 (?\x30DD . bidi-category-l) ;; 
	 (?\x30DE . bidi-category-l) ;; 
	 (?\x30DF . bidi-category-l) ;; 
	 (?\x30E0 . bidi-category-l) ;; 
	 (?\x30E1 . bidi-category-l) ;; 
	 (?\x30E2 . bidi-category-l) ;; 
	 (?\x30E3 . bidi-category-l) ;; 
	 (?\x30E4 . bidi-category-l) ;; 
	 (?\x30E5 . bidi-category-l) ;; 
	 (?\x30E6 . bidi-category-l) ;; 
	 (?\x30E7 . bidi-category-l) ;; 
	 (?\x30E8 . bidi-category-l) ;; 
	 (?\x30E9 . bidi-category-l) ;; 
	 (?\x30EA . bidi-category-l) ;; 
	 (?\x30EB . bidi-category-l) ;; 
	 (?\x30EC . bidi-category-l) ;; 
	 (?\x30ED . bidi-category-l) ;; 
	 (?\x30EE . bidi-category-l) ;; 
	 (?\x30EF . bidi-category-l) ;; 
	 (?\x30F0 . bidi-category-l) ;; 
	 (?\x30F1 . bidi-category-l) ;; 
	 (?\x30F2 . bidi-category-l) ;; 
	 (?\x30F3 . bidi-category-l) ;; 
	 (?\x30F4 . bidi-category-l) ;; 
	 (?\x30F5 . bidi-category-l) ;; 
	 (?\x30F6 . bidi-category-l) ;; 
	 (?\x30F7 . bidi-category-l) ;; 
	 (?\x30F8 . bidi-category-l) ;; 
	 (?\x30F9 . bidi-category-l) ;; 
	 (?\x30FA . bidi-category-l) ;; 
	 (?\x30FB . bidi-category-on) ;; 
	 (?\x30FC . bidi-category-l) ;; 
	 (?\x30FD . bidi-category-l) ;; 
	 (?\x30FE . bidi-category-l) ;; 
	 (?\x3105 . bidi-category-l) ;; 
	 (?\x3106 . bidi-category-l) ;; 
	 (?\x3107 . bidi-category-l) ;; 
	 (?\x3108 . bidi-category-l) ;; 
	 (?\x3109 . bidi-category-l) ;; 
	 (?\x310A . bidi-category-l) ;; 
	 (?\x310B . bidi-category-l) ;; 
	 (?\x310C . bidi-category-l) ;; 
	 (?\x310D . bidi-category-l) ;; 
	 (?\x310E . bidi-category-l) ;; 
	 (?\x310F . bidi-category-l) ;; 
	 (?\x3110 . bidi-category-l) ;; 
	 (?\x3111 . bidi-category-l) ;; 
	 (?\x3112 . bidi-category-l) ;; 
	 (?\x3113 . bidi-category-l) ;; 
	 (?\x3114 . bidi-category-l) ;; 
	 (?\x3115 . bidi-category-l) ;; 
	 (?\x3116 . bidi-category-l) ;; 
	 (?\x3117 . bidi-category-l) ;; 
	 (?\x3118 . bidi-category-l) ;; 
	 (?\x3119 . bidi-category-l) ;; 
	 (?\x311A . bidi-category-l) ;; 
	 (?\x311B . bidi-category-l) ;; 
	 (?\x311C . bidi-category-l) ;; 
	 (?\x311D . bidi-category-l) ;; 
	 (?\x311E . bidi-category-l) ;; 
	 (?\x311F . bidi-category-l) ;; 
	 (?\x3120 . bidi-category-l) ;; 
	 (?\x3121 . bidi-category-l) ;; 
	 (?\x3122 . bidi-category-l) ;; 
	 (?\x3123 . bidi-category-l) ;; 
	 (?\x3124 . bidi-category-l) ;; 
	 (?\x3125 . bidi-category-l) ;; 
	 (?\x3126 . bidi-category-l) ;; 
	 (?\x3127 . bidi-category-l) ;; 
	 (?\x3128 . bidi-category-l) ;; 
	 (?\x3129 . bidi-category-l) ;; 
	 (?\x312A . bidi-category-l) ;; 
	 (?\x312B . bidi-category-l) ;; 
	 (?\x312C . bidi-category-l) ;; 
	 (?\x3131 . bidi-category-l) ;; HANGUL LETTER GIYEOG
	 (?\x3132 . bidi-category-l) ;; HANGUL LETTER SSANG GIYEOG
	 (?\x3133 . bidi-category-l) ;; HANGUL LETTER GIYEOG SIOS
	 (?\x3134 . bidi-category-l) ;; 
	 (?\x3135 . bidi-category-l) ;; HANGUL LETTER NIEUN JIEUJ
	 (?\x3136 . bidi-category-l) ;; HANGUL LETTER NIEUN HIEUH
	 (?\x3137 . bidi-category-l) ;; HANGUL LETTER DIGEUD
	 (?\x3138 . bidi-category-l) ;; HANGUL LETTER SSANG DIGEUD
	 (?\x3139 . bidi-category-l) ;; HANGUL LETTER LIEUL
	 (?\x313A . bidi-category-l) ;; HANGUL LETTER LIEUL GIYEOG
	 (?\x313B . bidi-category-l) ;; HANGUL LETTER LIEUL MIEUM
	 (?\x313C . bidi-category-l) ;; HANGUL LETTER LIEUL BIEUB
	 (?\x313D . bidi-category-l) ;; HANGUL LETTER LIEUL SIOS
	 (?\x313E . bidi-category-l) ;; HANGUL LETTER LIEUL TIEUT
	 (?\x313F . bidi-category-l) ;; HANGUL LETTER LIEUL PIEUP
	 (?\x3140 . bidi-category-l) ;; HANGUL LETTER LIEUL HIEUH
	 (?\x3141 . bidi-category-l) ;; 
	 (?\x3142 . bidi-category-l) ;; HANGUL LETTER BIEUB
	 (?\x3143 . bidi-category-l) ;; HANGUL LETTER SSANG BIEUB
	 (?\x3144 . bidi-category-l) ;; HANGUL LETTER BIEUB SIOS
	 (?\x3145 . bidi-category-l) ;; 
	 (?\x3146 . bidi-category-l) ;; HANGUL LETTER SSANG SIOS
	 (?\x3147 . bidi-category-l) ;; 
	 (?\x3148 . bidi-category-l) ;; HANGUL LETTER JIEUJ
	 (?\x3149 . bidi-category-l) ;; HANGUL LETTER SSANG JIEUJ
	 (?\x314A . bidi-category-l) ;; HANGUL LETTER CIEUC
	 (?\x314B . bidi-category-l) ;; HANGUL LETTER KIYEOK
	 (?\x314C . bidi-category-l) ;; HANGUL LETTER TIEUT
	 (?\x314D . bidi-category-l) ;; HANGUL LETTER PIEUP
	 (?\x314E . bidi-category-l) ;; 
	 (?\x314F . bidi-category-l) ;; 
	 (?\x3150 . bidi-category-l) ;; 
	 (?\x3151 . bidi-category-l) ;; 
	 (?\x3152 . bidi-category-l) ;; 
	 (?\x3153 . bidi-category-l) ;; 
	 (?\x3154 . bidi-category-l) ;; 
	 (?\x3155 . bidi-category-l) ;; 
	 (?\x3156 . bidi-category-l) ;; 
	 (?\x3157 . bidi-category-l) ;; 
	 (?\x3158 . bidi-category-l) ;; 
	 (?\x3159 . bidi-category-l) ;; 
	 (?\x315A . bidi-category-l) ;; 
	 (?\x315B . bidi-category-l) ;; 
	 (?\x315C . bidi-category-l) ;; 
	 (?\x315D . bidi-category-l) ;; 
	 (?\x315E . bidi-category-l) ;; 
	 (?\x315F . bidi-category-l) ;; 
	 (?\x3160 . bidi-category-l) ;; 
	 (?\x3161 . bidi-category-l) ;; 
	 (?\x3162 . bidi-category-l) ;; 
	 (?\x3163 . bidi-category-l) ;; 
	 (?\x3164 . bidi-category-l) ;; HANGUL CAE OM
	 (?\x3165 . bidi-category-l) ;; HANGUL LETTER SSANG NIEUN
	 (?\x3166 . bidi-category-l) ;; HANGUL LETTER NIEUN DIGEUD
	 (?\x3167 . bidi-category-l) ;; HANGUL LETTER NIEUN SIOS
	 (?\x3168 . bidi-category-l) ;; HANGUL LETTER NIEUN BAN CHI EUM
	 (?\x3169 . bidi-category-l) ;; HANGUL LETTER LIEUL GIYEOG SIOS
	 (?\x316A . bidi-category-l) ;; HANGUL LETTER LIEUL DIGEUD
	 (?\x316B . bidi-category-l) ;; HANGUL LETTER LIEUL BIEUB SIOS
	 (?\x316C . bidi-category-l) ;; HANGUL LETTER LIEUL BAN CHI EUM
	 (?\x316D . bidi-category-l) ;; HANGUL LETTER LIEUL YEOLIN HIEUH
	 (?\x316E . bidi-category-l) ;; HANGUL LETTER MIEUM BIEUB
	 (?\x316F . bidi-category-l) ;; HANGUL LETTER MIEUM SIOS
	 (?\x3170 . bidi-category-l) ;; HANGUL LETTER BIEUB BAN CHI EUM
	 (?\x3171 . bidi-category-l) ;; HANGUL LETTER MIEUM SUN GYEONG EUM
	 (?\x3172 . bidi-category-l) ;; HANGUL LETTER BIEUB GIYEOG
	 (?\x3173 . bidi-category-l) ;; HANGUL LETTER BIEUB DIGEUD
	 (?\x3174 . bidi-category-l) ;; HANGUL LETTER BIEUB SIOS GIYEOG
	 (?\x3175 . bidi-category-l) ;; HANGUL LETTER BIEUB SIOS DIGEUD
	 (?\x3176 . bidi-category-l) ;; HANGUL LETTER BIEUB JIEUJ
	 (?\x3177 . bidi-category-l) ;; HANGUL LETTER BIEUB TIEUT
	 (?\x3178 . bidi-category-l) ;; HANGUL LETTER BIEUB SUN GYEONG EUM
	 (?\x3179 . bidi-category-l) ;; HANGUL LETTER SSANG BIEUB SUN GYEONG EUM
	 (?\x317A . bidi-category-l) ;; HANGUL LETTER SIOS GIYEOG
	 (?\x317B . bidi-category-l) ;; HANGUL LETTER SIOS NIEUN
	 (?\x317C . bidi-category-l) ;; HANGUL LETTER SIOS DIGEUD
	 (?\x317D . bidi-category-l) ;; HANGUL LETTER SIOS BIEUB
	 (?\x317E . bidi-category-l) ;; HANGUL LETTER SIOS JIEUJ
	 (?\x317F . bidi-category-l) ;; HANGUL LETTER BAN CHI EUM
	 (?\x3180 . bidi-category-l) ;; HANGUL LETTER SSANG IEUNG
	 (?\x3181 . bidi-category-l) ;; HANGUL LETTER NGIEUNG
	 (?\x3182 . bidi-category-l) ;; HANGUL LETTER NGIEUNG SIOS
	 (?\x3183 . bidi-category-l) ;; HANGUL LETTER NGIEUNG BAN CHI EUM
	 (?\x3184 . bidi-category-l) ;; HANGUL LETTER PIEUP SUN GYEONG EUM
	 (?\x3185 . bidi-category-l) ;; HANGUL LETTER SSANG HIEUH
	 (?\x3186 . bidi-category-l) ;; HANGUL LETTER YEOLIN HIEUH
	 (?\x3187 . bidi-category-l) ;; HANGUL LETTER YOYA
	 (?\x3188 . bidi-category-l) ;; HANGUL LETTER YOYAE
	 (?\x3189 . bidi-category-l) ;; HANGUL LETTER YOI
	 (?\x318A . bidi-category-l) ;; HANGUL LETTER YUYEO
	 (?\x318B . bidi-category-l) ;; HANGUL LETTER YUYE
	 (?\x318C . bidi-category-l) ;; HANGUL LETTER YUI
	 (?\x318D . bidi-category-l) ;; HANGUL LETTER ALAE A
	 (?\x318E . bidi-category-l) ;; HANGUL LETTER ALAE AE
	 (?\x3190 . bidi-category-l) ;; KANBUN TATETEN
	 (?\x3191 . bidi-category-l) ;; KAERITEN RE
	 (?\x3192 . bidi-category-l) ;; KAERITEN ITI
	 (?\x3193 . bidi-category-l) ;; KAERITEN NI
	 (?\x3194 . bidi-category-l) ;; KAERITEN SAN
	 (?\x3195 . bidi-category-l) ;; KAERITEN SI
	 (?\x3196 . bidi-category-l) ;; KAERITEN ZYOU
	 (?\x3197 . bidi-category-l) ;; KAERITEN TYUU
	 (?\x3198 . bidi-category-l) ;; KAERITEN GE
	 (?\x3199 . bidi-category-l) ;; KAERITEN KOU
	 (?\x319A . bidi-category-l) ;; KAERITEN OTU
	 (?\x319B . bidi-category-l) ;; KAERITEN HEI
	 (?\x319C . bidi-category-l) ;; KAERITEN TEI
	 (?\x319D . bidi-category-l) ;; KAERITEN TEN
	 (?\x319E . bidi-category-l) ;; KAERITEN TI
	 (?\x319F . bidi-category-l) ;; KAERITEN ZIN
	 (?\x31A0 . bidi-category-l) ;; 
	 (?\x31A1 . bidi-category-l) ;; 
	 (?\x31A2 . bidi-category-l) ;; 
	 (?\x31A3 . bidi-category-l) ;; 
	 (?\x31A4 . bidi-category-l) ;; 
	 (?\x31A5 . bidi-category-l) ;; 
	 (?\x31A6 . bidi-category-l) ;; 
	 (?\x31A7 . bidi-category-l) ;; 
	 (?\x31A8 . bidi-category-l) ;; 
	 (?\x31A9 . bidi-category-l) ;; 
	 (?\x31AA . bidi-category-l) ;; 
	 (?\x31AB . bidi-category-l) ;; 
	 (?\x31AC . bidi-category-l) ;; 
	 (?\x31AD . bidi-category-l) ;; 
	 (?\x31AE . bidi-category-l) ;; 
	 (?\x31AF . bidi-category-l) ;; 
	 (?\x31B0 . bidi-category-l) ;; 
	 (?\x31B1 . bidi-category-l) ;; 
	 (?\x31B2 . bidi-category-l) ;; 
	 (?\x31B3 . bidi-category-l) ;; 
	 (?\x31B4 . bidi-category-l) ;; 
	 (?\x31B5 . bidi-category-l) ;; 
	 (?\x31B6 . bidi-category-l) ;; 
	 (?\x31B7 . bidi-category-l) ;; 
	 (?\x3200 . bidi-category-l) ;; PARENTHESIZED HANGUL GIYEOG
	 (?\x3201 . bidi-category-l) ;; 
	 (?\x3202 . bidi-category-l) ;; PARENTHESIZED HANGUL DIGEUD
	 (?\x3203 . bidi-category-l) ;; PARENTHESIZED HANGUL LIEUL
	 (?\x3204 . bidi-category-l) ;; 
	 (?\x3205 . bidi-category-l) ;; PARENTHESIZED HANGUL BIEUB
	 (?\x3206 . bidi-category-l) ;; 
	 (?\x3207 . bidi-category-l) ;; 
	 (?\x3208 . bidi-category-l) ;; PARENTHESIZED HANGUL JIEUJ
	 (?\x3209 . bidi-category-l) ;; PARENTHESIZED HANGUL CIEUC
	 (?\x320A . bidi-category-l) ;; PARENTHESIZED HANGUL KIYEOK
	 (?\x320B . bidi-category-l) ;; PARENTHESIZED HANGUL TIEUT
	 (?\x320C . bidi-category-l) ;; PARENTHESIZED HANGUL PIEUP
	 (?\x320D . bidi-category-l) ;; 
	 (?\x320E . bidi-category-l) ;; PARENTHESIZED HANGUL GA
	 (?\x320F . bidi-category-l) ;; PARENTHESIZED HANGUL NA
	 (?\x3210 . bidi-category-l) ;; PARENTHESIZED HANGUL DA
	 (?\x3211 . bidi-category-l) ;; PARENTHESIZED HANGUL LA
	 (?\x3212 . bidi-category-l) ;; PARENTHESIZED HANGUL MA
	 (?\x3213 . bidi-category-l) ;; PARENTHESIZED HANGUL BA
	 (?\x3214 . bidi-category-l) ;; PARENTHESIZED HANGUL SA
	 (?\x3215 . bidi-category-l) ;; PARENTHESIZED HANGUL A
	 (?\x3216 . bidi-category-l) ;; PARENTHESIZED HANGUL JA
	 (?\x3217 . bidi-category-l) ;; PARENTHESIZED HANGUL CA
	 (?\x3218 . bidi-category-l) ;; PARENTHESIZED HANGUL KA
	 (?\x3219 . bidi-category-l) ;; PARENTHESIZED HANGUL TA
	 (?\x321A . bidi-category-l) ;; PARENTHESIZED HANGUL PA
	 (?\x321B . bidi-category-l) ;; PARENTHESIZED HANGUL HA
	 (?\x321C . bidi-category-l) ;; PARENTHESIZED HANGUL JU
	 (?\x3220 . bidi-category-l) ;; 
	 (?\x3221 . bidi-category-l) ;; 
	 (?\x3222 . bidi-category-l) ;; 
	 (?\x3223 . bidi-category-l) ;; 
	 (?\x3224 . bidi-category-l) ;; 
	 (?\x3225 . bidi-category-l) ;; 
	 (?\x3226 . bidi-category-l) ;; 
	 (?\x3227 . bidi-category-l) ;; 
	 (?\x3228 . bidi-category-l) ;; 
	 (?\x3229 . bidi-category-l) ;; 
	 (?\x322A . bidi-category-l) ;; 
	 (?\x322B . bidi-category-l) ;; 
	 (?\x322C . bidi-category-l) ;; 
	 (?\x322D . bidi-category-l) ;; 
	 (?\x322E . bidi-category-l) ;; 
	 (?\x322F . bidi-category-l) ;; 
	 (?\x3230 . bidi-category-l) ;; 
	 (?\x3231 . bidi-category-l) ;; 
	 (?\x3232 . bidi-category-l) ;; 
	 (?\x3233 . bidi-category-l) ;; 
	 (?\x3234 . bidi-category-l) ;; 
	 (?\x3235 . bidi-category-l) ;; 
	 (?\x3236 . bidi-category-l) ;; 
	 (?\x3237 . bidi-category-l) ;; 
	 (?\x3238 . bidi-category-l) ;; 
	 (?\x3239 . bidi-category-l) ;; 
	 (?\x323A . bidi-category-l) ;; 
	 (?\x323B . bidi-category-l) ;; 
	 (?\x323C . bidi-category-l) ;; 
	 (?\x323D . bidi-category-l) ;; 
	 (?\x323E . bidi-category-l) ;; 
	 (?\x323F . bidi-category-l) ;; 
	 (?\x3240 . bidi-category-l) ;; 
	 (?\x3241 . bidi-category-l) ;; 
	 (?\x3242 . bidi-category-l) ;; 
	 (?\x3243 . bidi-category-l) ;; 
	 (?\x3260 . bidi-category-l) ;; CIRCLED HANGUL GIYEOG
	 (?\x3261 . bidi-category-l) ;; 
	 (?\x3262 . bidi-category-l) ;; CIRCLED HANGUL DIGEUD
	 (?\x3263 . bidi-category-l) ;; CIRCLED HANGUL LIEUL
	 (?\x3264 . bidi-category-l) ;; 
	 (?\x3265 . bidi-category-l) ;; CIRCLED HANGUL BIEUB
	 (?\x3266 . bidi-category-l) ;; 
	 (?\x3267 . bidi-category-l) ;; 
	 (?\x3268 . bidi-category-l) ;; CIRCLED HANGUL JIEUJ
	 (?\x3269 . bidi-category-l) ;; CIRCLED HANGUL CIEUC
	 (?\x326A . bidi-category-l) ;; CIRCLED HANGUL KIYEOK
	 (?\x326B . bidi-category-l) ;; CIRCLED HANGUL TIEUT
	 (?\x326C . bidi-category-l) ;; CIRCLED HANGUL PIEUP
	 (?\x326D . bidi-category-l) ;; 
	 (?\x326E . bidi-category-l) ;; CIRCLED HANGUL GA
	 (?\x326F . bidi-category-l) ;; CIRCLED HANGUL NA
	 (?\x3270 . bidi-category-l) ;; CIRCLED HANGUL DA
	 (?\x3271 . bidi-category-l) ;; CIRCLED HANGUL LA
	 (?\x3272 . bidi-category-l) ;; CIRCLED HANGUL MA
	 (?\x3273 . bidi-category-l) ;; CIRCLED HANGUL BA
	 (?\x3274 . bidi-category-l) ;; CIRCLED HANGUL SA
	 (?\x3275 . bidi-category-l) ;; CIRCLED HANGUL A
	 (?\x3276 . bidi-category-l) ;; CIRCLED HANGUL JA
	 (?\x3277 . bidi-category-l) ;; CIRCLED HANGUL CA
	 (?\x3278 . bidi-category-l) ;; CIRCLED HANGUL KA
	 (?\x3279 . bidi-category-l) ;; CIRCLED HANGUL TA
	 (?\x327A . bidi-category-l) ;; CIRCLED HANGUL PA
	 (?\x327B . bidi-category-l) ;; CIRCLED HANGUL HA
	 (?\x327F . bidi-category-l) ;; 
	 (?\x3280 . bidi-category-l) ;; 
	 (?\x3281 . bidi-category-l) ;; 
	 (?\x3282 . bidi-category-l) ;; 
	 (?\x3283 . bidi-category-l) ;; 
	 (?\x3284 . bidi-category-l) ;; 
	 (?\x3285 . bidi-category-l) ;; 
	 (?\x3286 . bidi-category-l) ;; 
	 (?\x3287 . bidi-category-l) ;; 
	 (?\x3288 . bidi-category-l) ;; 
	 (?\x3289 . bidi-category-l) ;; 
	 (?\x328A . bidi-category-l) ;; 
	 (?\x328B . bidi-category-l) ;; 
	 (?\x328C . bidi-category-l) ;; 
	 (?\x328D . bidi-category-l) ;; 
	 (?\x328E . bidi-category-l) ;; 
	 (?\x328F . bidi-category-l) ;; 
	 (?\x3290 . bidi-category-l) ;; 
	 (?\x3291 . bidi-category-l) ;; 
	 (?\x3292 . bidi-category-l) ;; 
	 (?\x3293 . bidi-category-l) ;; 
	 (?\x3294 . bidi-category-l) ;; 
	 (?\x3295 . bidi-category-l) ;; 
	 (?\x3296 . bidi-category-l) ;; 
	 (?\x3297 . bidi-category-l) ;; 
	 (?\x3298 . bidi-category-l) ;; 
	 (?\x3299 . bidi-category-l) ;; 
	 (?\x329A . bidi-category-l) ;; 
	 (?\x329B . bidi-category-l) ;; 
	 (?\x329C . bidi-category-l) ;; 
	 (?\x329D . bidi-category-l) ;; 
	 (?\x329E . bidi-category-l) ;; 
	 (?\x329F . bidi-category-l) ;; 
	 (?\x32A0 . bidi-category-l) ;; 
	 (?\x32A1 . bidi-category-l) ;; 
	 (?\x32A2 . bidi-category-l) ;; 
	 (?\x32A3 . bidi-category-l) ;; 
	 (?\x32A4 . bidi-category-l) ;; 
	 (?\x32A5 . bidi-category-l) ;; CIRCLED IDEOGRAPH CENTER
	 (?\x32A6 . bidi-category-l) ;; 
	 (?\x32A7 . bidi-category-l) ;; 
	 (?\x32A8 . bidi-category-l) ;; 
	 (?\x32A9 . bidi-category-l) ;; 
	 (?\x32AA . bidi-category-l) ;; 
	 (?\x32AB . bidi-category-l) ;; 
	 (?\x32AC . bidi-category-l) ;; 
	 (?\x32AD . bidi-category-l) ;; 
	 (?\x32AE . bidi-category-l) ;; 
	 (?\x32AF . bidi-category-l) ;; 
	 (?\x32B0 . bidi-category-l) ;; 
	 (?\x32C0 . bidi-category-l) ;; 
	 (?\x32C1 . bidi-category-l) ;; 
	 (?\x32C2 . bidi-category-l) ;; 
	 (?\x32C3 . bidi-category-l) ;; 
	 (?\x32C4 . bidi-category-l) ;; 
	 (?\x32C5 . bidi-category-l) ;; 
	 (?\x32C6 . bidi-category-l) ;; 
	 (?\x32C7 . bidi-category-l) ;; 
	 (?\x32C8 . bidi-category-l) ;; 
	 (?\x32C9 . bidi-category-l) ;; 
	 (?\x32CA . bidi-category-l) ;; 
	 (?\x32CB . bidi-category-l) ;; 
	 (?\x32D0 . bidi-category-l) ;; 
	 (?\x32D1 . bidi-category-l) ;; 
	 (?\x32D2 . bidi-category-l) ;; 
	 (?\x32D3 . bidi-category-l) ;; 
	 (?\x32D4 . bidi-category-l) ;; 
	 (?\x32D5 . bidi-category-l) ;; 
	 (?\x32D6 . bidi-category-l) ;; 
	 (?\x32D7 . bidi-category-l) ;; 
	 (?\x32D8 . bidi-category-l) ;; 
	 (?\x32D9 . bidi-category-l) ;; 
	 (?\x32DA . bidi-category-l) ;; 
	 (?\x32DB . bidi-category-l) ;; 
	 (?\x32DC . bidi-category-l) ;; 
	 (?\x32DD . bidi-category-l) ;; 
	 (?\x32DE . bidi-category-l) ;; 
	 (?\x32DF . bidi-category-l) ;; 
	 (?\x32E0 . bidi-category-l) ;; 
	 (?\x32E1 . bidi-category-l) ;; 
	 (?\x32E2 . bidi-category-l) ;; 
	 (?\x32E3 . bidi-category-l) ;; 
	 (?\x32E4 . bidi-category-l) ;; 
	 (?\x32E5 . bidi-category-l) ;; 
	 (?\x32E6 . bidi-category-l) ;; 
	 (?\x32E7 . bidi-category-l) ;; 
	 (?\x32E8 . bidi-category-l) ;; 
	 (?\x32E9 . bidi-category-l) ;; 
	 (?\x32EA . bidi-category-l) ;; 
	 (?\x32EB . bidi-category-l) ;; 
	 (?\x32EC . bidi-category-l) ;; 
	 (?\x32ED . bidi-category-l) ;; 
	 (?\x32EE . bidi-category-l) ;; 
	 (?\x32EF . bidi-category-l) ;; 
	 (?\x32F0 . bidi-category-l) ;; 
	 (?\x32F1 . bidi-category-l) ;; 
	 (?\x32F2 . bidi-category-l) ;; 
	 (?\x32F3 . bidi-category-l) ;; 
	 (?\x32F4 . bidi-category-l) ;; 
	 (?\x32F5 . bidi-category-l) ;; 
	 (?\x32F6 . bidi-category-l) ;; 
	 (?\x32F7 . bidi-category-l) ;; 
	 (?\x32F8 . bidi-category-l) ;; 
	 (?\x32F9 . bidi-category-l) ;; 
	 (?\x32FA . bidi-category-l) ;; 
	 (?\x32FB . bidi-category-l) ;; 
	 (?\x32FC . bidi-category-l) ;; 
	 (?\x32FD . bidi-category-l) ;; 
	 (?\x32FE . bidi-category-l) ;; 
	 (?\x3300 . bidi-category-l) ;; SQUARED APAATO
	 (?\x3301 . bidi-category-l) ;; SQUARED ARUHUA
	 (?\x3302 . bidi-category-l) ;; SQUARED ANPEA
	 (?\x3303 . bidi-category-l) ;; SQUARED AARU
	 (?\x3304 . bidi-category-l) ;; SQUARED ININGU
	 (?\x3305 . bidi-category-l) ;; SQUARED INTI
	 (?\x3306 . bidi-category-l) ;; SQUARED UON
	 (?\x3307 . bidi-category-l) ;; SQUARED ESUKUUDO
	 (?\x3308 . bidi-category-l) ;; SQUARED EEKAA
	 (?\x3309 . bidi-category-l) ;; SQUARED ONSU
	 (?\x330A . bidi-category-l) ;; SQUARED OOMU
	 (?\x330B . bidi-category-l) ;; SQUARED KAIRI
	 (?\x330C . bidi-category-l) ;; SQUARED KARATTO
	 (?\x330D . bidi-category-l) ;; SQUARED KARORII
	 (?\x330E . bidi-category-l) ;; SQUARED GARON
	 (?\x330F . bidi-category-l) ;; SQUARED GANMA
	 (?\x3310 . bidi-category-l) ;; SQUARED GIGA
	 (?\x3311 . bidi-category-l) ;; SQUARED GINII
	 (?\x3312 . bidi-category-l) ;; SQUARED KYURII
	 (?\x3313 . bidi-category-l) ;; SQUARED GIRUDAA
	 (?\x3314 . bidi-category-l) ;; SQUARED KIRO
	 (?\x3315 . bidi-category-l) ;; SQUARED KIROGURAMU
	 (?\x3316 . bidi-category-l) ;; SQUARED KIROMEETORU
	 (?\x3317 . bidi-category-l) ;; SQUARED KIROWATTO
	 (?\x3318 . bidi-category-l) ;; SQUARED GURAMU
	 (?\x3319 . bidi-category-l) ;; SQUARED GURAMUTON
	 (?\x331A . bidi-category-l) ;; SQUARED KURUZEIRO
	 (?\x331B . bidi-category-l) ;; SQUARED KUROONE
	 (?\x331C . bidi-category-l) ;; SQUARED KEESU
	 (?\x331D . bidi-category-l) ;; SQUARED KORUNA
	 (?\x331E . bidi-category-l) ;; SQUARED KOOPO
	 (?\x331F . bidi-category-l) ;; SQUARED SAIKURU
	 (?\x3320 . bidi-category-l) ;; SQUARED SANTIIMU
	 (?\x3321 . bidi-category-l) ;; SQUARED SIRINGU
	 (?\x3322 . bidi-category-l) ;; SQUARED SENTI
	 (?\x3323 . bidi-category-l) ;; SQUARED SENTO
	 (?\x3324 . bidi-category-l) ;; SQUARED DAASU
	 (?\x3325 . bidi-category-l) ;; SQUARED DESI
	 (?\x3326 . bidi-category-l) ;; SQUARED DORU
	 (?\x3327 . bidi-category-l) ;; SQUARED TON
	 (?\x3328 . bidi-category-l) ;; SQUARED NANO
	 (?\x3329 . bidi-category-l) ;; SQUARED NOTTO
	 (?\x332A . bidi-category-l) ;; SQUARED HAITU
	 (?\x332B . bidi-category-l) ;; SQUARED PAASENTO
	 (?\x332C . bidi-category-l) ;; SQUARED PAATU
	 (?\x332D . bidi-category-l) ;; SQUARED BAARERU
	 (?\x332E . bidi-category-l) ;; SQUARED PIASUTORU
	 (?\x332F . bidi-category-l) ;; SQUARED PIKURU
	 (?\x3330 . bidi-category-l) ;; SQUARED PIKO
	 (?\x3331 . bidi-category-l) ;; SQUARED BIRU
	 (?\x3332 . bidi-category-l) ;; SQUARED HUARADDO
	 (?\x3333 . bidi-category-l) ;; SQUARED HUIITO
	 (?\x3334 . bidi-category-l) ;; SQUARED BUSSYERU
	 (?\x3335 . bidi-category-l) ;; SQUARED HURAN
	 (?\x3336 . bidi-category-l) ;; SQUARED HEKUTAARU
	 (?\x3337 . bidi-category-l) ;; SQUARED PESO
	 (?\x3338 . bidi-category-l) ;; SQUARED PENIHI
	 (?\x3339 . bidi-category-l) ;; SQUARED HERUTU
	 (?\x333A . bidi-category-l) ;; SQUARED PENSU
	 (?\x333B . bidi-category-l) ;; SQUARED PEEZI
	 (?\x333C . bidi-category-l) ;; SQUARED BEETA
	 (?\x333D . bidi-category-l) ;; SQUARED POINTO
	 (?\x333E . bidi-category-l) ;; SQUARED BORUTO
	 (?\x333F . bidi-category-l) ;; SQUARED HON
	 (?\x3340 . bidi-category-l) ;; SQUARED PONDO
	 (?\x3341 . bidi-category-l) ;; SQUARED HOORU
	 (?\x3342 . bidi-category-l) ;; SQUARED HOON
	 (?\x3343 . bidi-category-l) ;; SQUARED MAIKURO
	 (?\x3344 . bidi-category-l) ;; SQUARED MAIRU
	 (?\x3345 . bidi-category-l) ;; SQUARED MAHHA
	 (?\x3346 . bidi-category-l) ;; SQUARED MARUKU
	 (?\x3347 . bidi-category-l) ;; SQUARED MANSYON
	 (?\x3348 . bidi-category-l) ;; SQUARED MIKURON
	 (?\x3349 . bidi-category-l) ;; SQUARED MIRI
	 (?\x334A . bidi-category-l) ;; SQUARED MIRIBAARU
	 (?\x334B . bidi-category-l) ;; SQUARED MEGA
	 (?\x334C . bidi-category-l) ;; SQUARED MEGATON
	 (?\x334D . bidi-category-l) ;; SQUARED MEETORU
	 (?\x334E . bidi-category-l) ;; SQUARED YAADO
	 (?\x334F . bidi-category-l) ;; SQUARED YAARU
	 (?\x3350 . bidi-category-l) ;; SQUARED YUAN
	 (?\x3351 . bidi-category-l) ;; SQUARED RITTORU
	 (?\x3352 . bidi-category-l) ;; SQUARED RIRA
	 (?\x3353 . bidi-category-l) ;; SQUARED RUPII
	 (?\x3354 . bidi-category-l) ;; SQUARED RUUBURU
	 (?\x3355 . bidi-category-l) ;; SQUARED REMU
	 (?\x3356 . bidi-category-l) ;; SQUARED RENTOGEN
	 (?\x3357 . bidi-category-l) ;; SQUARED WATTO
	 (?\x3358 . bidi-category-l) ;; 
	 (?\x3359 . bidi-category-l) ;; 
	 (?\x335A . bidi-category-l) ;; 
	 (?\x335B . bidi-category-l) ;; 
	 (?\x335C . bidi-category-l) ;; 
	 (?\x335D . bidi-category-l) ;; 
	 (?\x335E . bidi-category-l) ;; 
	 (?\x335F . bidi-category-l) ;; 
	 (?\x3360 . bidi-category-l) ;; 
	 (?\x3361 . bidi-category-l) ;; 
	 (?\x3362 . bidi-category-l) ;; 
	 (?\x3363 . bidi-category-l) ;; 
	 (?\x3364 . bidi-category-l) ;; 
	 (?\x3365 . bidi-category-l) ;; 
	 (?\x3366 . bidi-category-l) ;; 
	 (?\x3367 . bidi-category-l) ;; 
	 (?\x3368 . bidi-category-l) ;; 
	 (?\x3369 . bidi-category-l) ;; 
	 (?\x336A . bidi-category-l) ;; 
	 (?\x336B . bidi-category-l) ;; 
	 (?\x336C . bidi-category-l) ;; 
	 (?\x336D . bidi-category-l) ;; 
	 (?\x336E . bidi-category-l) ;; 
	 (?\x336F . bidi-category-l) ;; 
	 (?\x3370 . bidi-category-l) ;; 
	 (?\x3371 . bidi-category-l) ;; 
	 (?\x3372 . bidi-category-l) ;; 
	 (?\x3373 . bidi-category-l) ;; 
	 (?\x3374 . bidi-category-l) ;; 
	 (?\x3375 . bidi-category-l) ;; 
	 (?\x3376 . bidi-category-l) ;; 
	 (?\x337B . bidi-category-l) ;; SQUARED TWO IDEOGRAPHS ERA NAME HEISEI
	 (?\x337C . bidi-category-l) ;; SQUARED TWO IDEOGRAPHS ERA NAME SYOUWA
	 (?\x337D . bidi-category-l) ;; SQUARED TWO IDEOGRAPHS ERA NAME TAISYOU
	 (?\x337E . bidi-category-l) ;; SQUARED TWO IDEOGRAPHS ERA NAME MEIZI
	 (?\x337F . bidi-category-l) ;; SQUARED FOUR IDEOGRAPHS CORPORATION
	 (?\x3380 . bidi-category-l) ;; SQUARED PA AMPS
	 (?\x3381 . bidi-category-l) ;; SQUARED NA
	 (?\x3382 . bidi-category-l) ;; SQUARED MU A
	 (?\x3383 . bidi-category-l) ;; SQUARED MA
	 (?\x3384 . bidi-category-l) ;; SQUARED KA
	 (?\x3385 . bidi-category-l) ;; SQUARED KB
	 (?\x3386 . bidi-category-l) ;; SQUARED MB
	 (?\x3387 . bidi-category-l) ;; SQUARED GB
	 (?\x3388 . bidi-category-l) ;; SQUARED CAL
	 (?\x3389 . bidi-category-l) ;; SQUARED KCAL
	 (?\x338A . bidi-category-l) ;; SQUARED PF
	 (?\x338B . bidi-category-l) ;; SQUARED NF
	 (?\x338C . bidi-category-l) ;; SQUARED MU F
	 (?\x338D . bidi-category-l) ;; SQUARED MU G
	 (?\x338E . bidi-category-l) ;; SQUARED MG
	 (?\x338F . bidi-category-l) ;; SQUARED KG
	 (?\x3390 . bidi-category-l) ;; SQUARED HZ
	 (?\x3391 . bidi-category-l) ;; SQUARED KHZ
	 (?\x3392 . bidi-category-l) ;; SQUARED MHZ
	 (?\x3393 . bidi-category-l) ;; SQUARED GHZ
	 (?\x3394 . bidi-category-l) ;; SQUARED THZ
	 (?\x3395 . bidi-category-l) ;; SQUARED MU L
	 (?\x3396 . bidi-category-l) ;; SQUARED ML
	 (?\x3397 . bidi-category-l) ;; SQUARED DL
	 (?\x3398 . bidi-category-l) ;; SQUARED KL
	 (?\x3399 . bidi-category-l) ;; SQUARED FM
	 (?\x339A . bidi-category-l) ;; SQUARED NM
	 (?\x339B . bidi-category-l) ;; SQUARED MU M
	 (?\x339C . bidi-category-l) ;; SQUARED MM
	 (?\x339D . bidi-category-l) ;; SQUARED CM
	 (?\x339E . bidi-category-l) ;; SQUARED KM
	 (?\x339F . bidi-category-l) ;; SQUARED MM SQUARED
	 (?\x33A0 . bidi-category-l) ;; SQUARED CM SQUARED
	 (?\x33A1 . bidi-category-l) ;; SQUARED M SQUARED
	 (?\x33A2 . bidi-category-l) ;; SQUARED KM SQUARED
	 (?\x33A3 . bidi-category-l) ;; SQUARED MM CUBED
	 (?\x33A4 . bidi-category-l) ;; SQUARED CM CUBED
	 (?\x33A5 . bidi-category-l) ;; SQUARED M CUBED
	 (?\x33A6 . bidi-category-l) ;; SQUARED KM CUBED
	 (?\x33A7 . bidi-category-l) ;; SQUARED M OVER S
	 (?\x33A8 . bidi-category-l) ;; SQUARED M OVER S SQUARED
	 (?\x33A9 . bidi-category-l) ;; SQUARED PA
	 (?\x33AA . bidi-category-l) ;; SQUARED KPA
	 (?\x33AB . bidi-category-l) ;; SQUARED MPA
	 (?\x33AC . bidi-category-l) ;; SQUARED GPA
	 (?\x33AD . bidi-category-l) ;; SQUARED RAD
	 (?\x33AE . bidi-category-l) ;; SQUARED RAD OVER S
	 (?\x33AF . bidi-category-l) ;; SQUARED RAD OVER S SQUARED
	 (?\x33B0 . bidi-category-l) ;; SQUARED PS
	 (?\x33B1 . bidi-category-l) ;; SQUARED NS
	 (?\x33B2 . bidi-category-l) ;; SQUARED MU S
	 (?\x33B3 . bidi-category-l) ;; SQUARED MS
	 (?\x33B4 . bidi-category-l) ;; SQUARED PV
	 (?\x33B5 . bidi-category-l) ;; SQUARED NV
	 (?\x33B6 . bidi-category-l) ;; SQUARED MU V
	 (?\x33B7 . bidi-category-l) ;; SQUARED MV
	 (?\x33B8 . bidi-category-l) ;; SQUARED KV
	 (?\x33B9 . bidi-category-l) ;; SQUARED MV MEGA
	 (?\x33BA . bidi-category-l) ;; SQUARED PW
	 (?\x33BB . bidi-category-l) ;; SQUARED NW
	 (?\x33BC . bidi-category-l) ;; SQUARED MU W
	 (?\x33BD . bidi-category-l) ;; SQUARED MW
	 (?\x33BE . bidi-category-l) ;; SQUARED KW
	 (?\x33BF . bidi-category-l) ;; SQUARED MW MEGA
	 (?\x33C0 . bidi-category-l) ;; SQUARED K OHM
	 (?\x33C1 . bidi-category-l) ;; SQUARED M OHM
	 (?\x33C2 . bidi-category-l) ;; SQUARED AM
	 (?\x33C3 . bidi-category-l) ;; SQUARED BQ
	 (?\x33C4 . bidi-category-l) ;; SQUARED CC
	 (?\x33C5 . bidi-category-l) ;; SQUARED CD
	 (?\x33C6 . bidi-category-l) ;; SQUARED C OVER KG
	 (?\x33C7 . bidi-category-l) ;; SQUARED CO
	 (?\x33C8 . bidi-category-l) ;; SQUARED DB
	 (?\x33C9 . bidi-category-l) ;; SQUARED GY
	 (?\x33CA . bidi-category-l) ;; SQUARED HA
	 (?\x33CB . bidi-category-l) ;; SQUARED HP
	 (?\x33CC . bidi-category-l) ;; SQUARED IN
	 (?\x33CD . bidi-category-l) ;; SQUARED KK
	 (?\x33CE . bidi-category-l) ;; SQUARED KM CAPITAL
	 (?\x33CF . bidi-category-l) ;; SQUARED KT
	 (?\x33D0 . bidi-category-l) ;; SQUARED LM
	 (?\x33D1 . bidi-category-l) ;; SQUARED LN
	 (?\x33D2 . bidi-category-l) ;; SQUARED LOG
	 (?\x33D3 . bidi-category-l) ;; SQUARED LX
	 (?\x33D4 . bidi-category-l) ;; SQUARED MB SMALL
	 (?\x33D5 . bidi-category-l) ;; SQUARED MIL
	 (?\x33D6 . bidi-category-l) ;; SQUARED MOL
	 (?\x33D7 . bidi-category-l) ;; SQUARED PH
	 (?\x33D8 . bidi-category-l) ;; SQUARED PM
	 (?\x33D9 . bidi-category-l) ;; SQUARED PPM
	 (?\x33DA . bidi-category-l) ;; SQUARED PR
	 (?\x33DB . bidi-category-l) ;; SQUARED SR
	 (?\x33DC . bidi-category-l) ;; SQUARED SV
	 (?\x33DD . bidi-category-l) ;; SQUARED WB
	 (?\x33E0 . bidi-category-l) ;; 
	 (?\x33E1 . bidi-category-l) ;; 
	 (?\x33E2 . bidi-category-l) ;; 
	 (?\x33E3 . bidi-category-l) ;; 
	 (?\x33E4 . bidi-category-l) ;; 
	 (?\x33E5 . bidi-category-l) ;; 
	 (?\x33E6 . bidi-category-l) ;; 
	 (?\x33E7 . bidi-category-l) ;; 
	 (?\x33E8 . bidi-category-l) ;; 
	 (?\x33E9 . bidi-category-l) ;; 
	 (?\x33EA . bidi-category-l) ;; 
	 (?\x33EB . bidi-category-l) ;; 
	 (?\x33EC . bidi-category-l) ;; 
	 (?\x33ED . bidi-category-l) ;; 
	 (?\x33EE . bidi-category-l) ;; 
	 (?\x33EF . bidi-category-l) ;; 
	 (?\x33F0 . bidi-category-l) ;; 
	 (?\x33F1 . bidi-category-l) ;; 
	 (?\x33F2 . bidi-category-l) ;; 
	 (?\x33F3 . bidi-category-l) ;; 
	 (?\x33F4 . bidi-category-l) ;; 
	 (?\x33F5 . bidi-category-l) ;; 
	 (?\x33F6 . bidi-category-l) ;; 
	 (?\x33F7 . bidi-category-l) ;; 
	 (?\x33F8 . bidi-category-l) ;; 
	 (?\x33F9 . bidi-category-l) ;; 
	 (?\x33FA . bidi-category-l) ;; 
	 (?\x33FB . bidi-category-l) ;; 
	 (?\x33FC . bidi-category-l) ;; 
	 (?\x33FD . bidi-category-l) ;; 
	 (?\x33FE . bidi-category-l) ;; 
	 (?\x3400 . bidi-category-l) ;; 
	 (?\x4DB5 . bidi-category-l) ;; 
	 (?\x4E00 . bidi-category-l) ;; 
	 (?\x9FA5 . bidi-category-l) ;; 
	 (?\xA000 . bidi-category-l) ;; 
	 (?\xA001 . bidi-category-l) ;; 
	 (?\xA002 . bidi-category-l) ;; 
	 (?\xA003 . bidi-category-l) ;; 
	 (?\xA004 . bidi-category-l) ;; 
	 (?\xA005 . bidi-category-l) ;; 
	 (?\xA006 . bidi-category-l) ;; 
	 (?\xA007 . bidi-category-l) ;; 
	 (?\xA008 . bidi-category-l) ;; 
	 (?\xA009 . bidi-category-l) ;; 
	 (?\xA00A . bidi-category-l) ;; 
	 (?\xA00B . bidi-category-l) ;; 
	 (?\xA00C . bidi-category-l) ;; 
	 (?\xA00D . bidi-category-l) ;; 
	 (?\xA00E . bidi-category-l) ;; 
	 (?\xA00F . bidi-category-l) ;; 
	 (?\xA010 . bidi-category-l) ;; 
	 (?\xA011 . bidi-category-l) ;; 
	 (?\xA012 . bidi-category-l) ;; 
	 (?\xA013 . bidi-category-l) ;; 
	 (?\xA014 . bidi-category-l) ;; 
	 (?\xA015 . bidi-category-l) ;; 
	 (?\xA016 . bidi-category-l) ;; 
	 (?\xA017 . bidi-category-l) ;; 
	 (?\xA018 . bidi-category-l) ;; 
	 (?\xA019 . bidi-category-l) ;; 
	 (?\xA01A . bidi-category-l) ;; 
	 (?\xA01B . bidi-category-l) ;; 
	 (?\xA01C . bidi-category-l) ;; 
	 (?\xA01D . bidi-category-l) ;; 
	 (?\xA01E . bidi-category-l) ;; 
	 (?\xA01F . bidi-category-l) ;; 
	 (?\xA020 . bidi-category-l) ;; 
	 (?\xA021 . bidi-category-l) ;; 
	 (?\xA022 . bidi-category-l) ;; 
	 (?\xA023 . bidi-category-l) ;; 
	 (?\xA024 . bidi-category-l) ;; 
	 (?\xA025 . bidi-category-l) ;; 
	 (?\xA026 . bidi-category-l) ;; 
	 (?\xA027 . bidi-category-l) ;; 
	 (?\xA028 . bidi-category-l) ;; 
	 (?\xA029 . bidi-category-l) ;; 
	 (?\xA02A . bidi-category-l) ;; 
	 (?\xA02B . bidi-category-l) ;; 
	 (?\xA02C . bidi-category-l) ;; 
	 (?\xA02D . bidi-category-l) ;; 
	 (?\xA02E . bidi-category-l) ;; 
	 (?\xA02F . bidi-category-l) ;; 
	 (?\xA030 . bidi-category-l) ;; 
	 (?\xA031 . bidi-category-l) ;; 
	 (?\xA032 . bidi-category-l) ;; 
	 (?\xA033 . bidi-category-l) ;; 
	 (?\xA034 . bidi-category-l) ;; 
	 (?\xA035 . bidi-category-l) ;; 
	 (?\xA036 . bidi-category-l) ;; 
	 (?\xA037 . bidi-category-l) ;; 
	 (?\xA038 . bidi-category-l) ;; 
	 (?\xA039 . bidi-category-l) ;; 
	 (?\xA03A . bidi-category-l) ;; 
	 (?\xA03B . bidi-category-l) ;; 
	 (?\xA03C . bidi-category-l) ;; 
	 (?\xA03D . bidi-category-l) ;; 
	 (?\xA03E . bidi-category-l) ;; 
	 (?\xA03F . bidi-category-l) ;; 
	 (?\xA040 . bidi-category-l) ;; 
	 (?\xA041 . bidi-category-l) ;; 
	 (?\xA042 . bidi-category-l) ;; 
	 (?\xA043 . bidi-category-l) ;; 
	 (?\xA044 . bidi-category-l) ;; 
	 (?\xA045 . bidi-category-l) ;; 
	 (?\xA046 . bidi-category-l) ;; 
	 (?\xA047 . bidi-category-l) ;; 
	 (?\xA048 . bidi-category-l) ;; 
	 (?\xA049 . bidi-category-l) ;; 
	 (?\xA04A . bidi-category-l) ;; 
	 (?\xA04B . bidi-category-l) ;; 
	 (?\xA04C . bidi-category-l) ;; 
	 (?\xA04D . bidi-category-l) ;; 
	 (?\xA04E . bidi-category-l) ;; 
	 (?\xA04F . bidi-category-l) ;; 
	 (?\xA050 . bidi-category-l) ;; 
	 (?\xA051 . bidi-category-l) ;; 
	 (?\xA052 . bidi-category-l) ;; 
	 (?\xA053 . bidi-category-l) ;; 
	 (?\xA054 . bidi-category-l) ;; 
	 (?\xA055 . bidi-category-l) ;; 
	 (?\xA056 . bidi-category-l) ;; 
	 (?\xA057 . bidi-category-l) ;; 
	 (?\xA058 . bidi-category-l) ;; 
	 (?\xA059 . bidi-category-l) ;; 
	 (?\xA05A . bidi-category-l) ;; 
	 (?\xA05B . bidi-category-l) ;; 
	 (?\xA05C . bidi-category-l) ;; 
	 (?\xA05D . bidi-category-l) ;; 
	 (?\xA05E . bidi-category-l) ;; 
	 (?\xA05F . bidi-category-l) ;; 
	 (?\xA060 . bidi-category-l) ;; 
	 (?\xA061 . bidi-category-l) ;; 
	 (?\xA062 . bidi-category-l) ;; 
	 (?\xA063 . bidi-category-l) ;; 
	 (?\xA064 . bidi-category-l) ;; 
	 (?\xA065 . bidi-category-l) ;; 
	 (?\xA066 . bidi-category-l) ;; 
	 (?\xA067 . bidi-category-l) ;; 
	 (?\xA068 . bidi-category-l) ;; 
	 (?\xA069 . bidi-category-l) ;; 
	 (?\xA06A . bidi-category-l) ;; 
	 (?\xA06B . bidi-category-l) ;; 
	 (?\xA06C . bidi-category-l) ;; 
	 (?\xA06D . bidi-category-l) ;; 
	 (?\xA06E . bidi-category-l) ;; 
	 (?\xA06F . bidi-category-l) ;; 
	 (?\xA070 . bidi-category-l) ;; 
	 (?\xA071 . bidi-category-l) ;; 
	 (?\xA072 . bidi-category-l) ;; 
	 (?\xA073 . bidi-category-l) ;; 
	 (?\xA074 . bidi-category-l) ;; 
	 (?\xA075 . bidi-category-l) ;; 
	 (?\xA076 . bidi-category-l) ;; 
	 (?\xA077 . bidi-category-l) ;; 
	 (?\xA078 . bidi-category-l) ;; 
	 (?\xA079 . bidi-category-l) ;; 
	 (?\xA07A . bidi-category-l) ;; 
	 (?\xA07B . bidi-category-l) ;; 
	 (?\xA07C . bidi-category-l) ;; 
	 (?\xA07D . bidi-category-l) ;; 
	 (?\xA07E . bidi-category-l) ;; 
	 (?\xA07F . bidi-category-l) ;; 
	 (?\xA080 . bidi-category-l) ;; 
	 (?\xA081 . bidi-category-l) ;; 
	 (?\xA082 . bidi-category-l) ;; 
	 (?\xA083 . bidi-category-l) ;; 
	 (?\xA084 . bidi-category-l) ;; 
	 (?\xA085 . bidi-category-l) ;; 
	 (?\xA086 . bidi-category-l) ;; 
	 (?\xA087 . bidi-category-l) ;; 
	 (?\xA088 . bidi-category-l) ;; 
	 (?\xA089 . bidi-category-l) ;; 
	 (?\xA08A . bidi-category-l) ;; 
	 (?\xA08B . bidi-category-l) ;; 
	 (?\xA08C . bidi-category-l) ;; 
	 (?\xA08D . bidi-category-l) ;; 
	 (?\xA08E . bidi-category-l) ;; 
	 (?\xA08F . bidi-category-l) ;; 
	 (?\xA090 . bidi-category-l) ;; 
	 (?\xA091 . bidi-category-l) ;; 
	 (?\xA092 . bidi-category-l) ;; 
	 (?\xA093 . bidi-category-l) ;; 
	 (?\xA094 . bidi-category-l) ;; 
	 (?\xA095 . bidi-category-l) ;; 
	 (?\xA096 . bidi-category-l) ;; 
	 (?\xA097 . bidi-category-l) ;; 
	 (?\xA098 . bidi-category-l) ;; 
	 (?\xA099 . bidi-category-l) ;; 
	 (?\xA09A . bidi-category-l) ;; 
	 (?\xA09B . bidi-category-l) ;; 
	 (?\xA09C . bidi-category-l) ;; 
	 (?\xA09D . bidi-category-l) ;; 
	 (?\xA09E . bidi-category-l) ;; 
	 (?\xA09F . bidi-category-l) ;; 
	 (?\xA0A0 . bidi-category-l) ;; 
	 (?\xA0A1 . bidi-category-l) ;; 
	 (?\xA0A2 . bidi-category-l) ;; 
	 (?\xA0A3 . bidi-category-l) ;; 
	 (?\xA0A4 . bidi-category-l) ;; 
	 (?\xA0A5 . bidi-category-l) ;; 
	 (?\xA0A6 . bidi-category-l) ;; 
	 (?\xA0A7 . bidi-category-l) ;; 
	 (?\xA0A8 . bidi-category-l) ;; 
	 (?\xA0A9 . bidi-category-l) ;; 
	 (?\xA0AA . bidi-category-l) ;; 
	 (?\xA0AB . bidi-category-l) ;; 
	 (?\xA0AC . bidi-category-l) ;; 
	 (?\xA0AD . bidi-category-l) ;; 
	 (?\xA0AE . bidi-category-l) ;; 
	 (?\xA0AF . bidi-category-l) ;; 
	 (?\xA0B0 . bidi-category-l) ;; 
	 (?\xA0B1 . bidi-category-l) ;; 
	 (?\xA0B2 . bidi-category-l) ;; 
	 (?\xA0B3 . bidi-category-l) ;; 
	 (?\xA0B4 . bidi-category-l) ;; 
	 (?\xA0B5 . bidi-category-l) ;; 
	 (?\xA0B6 . bidi-category-l) ;; 
	 (?\xA0B7 . bidi-category-l) ;; 
	 (?\xA0B8 . bidi-category-l) ;; 
	 (?\xA0B9 . bidi-category-l) ;; 
	 (?\xA0BA . bidi-category-l) ;; 
	 (?\xA0BB . bidi-category-l) ;; 
	 (?\xA0BC . bidi-category-l) ;; 
	 (?\xA0BD . bidi-category-l) ;; 
	 (?\xA0BE . bidi-category-l) ;; 
	 (?\xA0BF . bidi-category-l) ;; 
	 (?\xA0C0 . bidi-category-l) ;; 
	 (?\xA0C1 . bidi-category-l) ;; 
	 (?\xA0C2 . bidi-category-l) ;; 
	 (?\xA0C3 . bidi-category-l) ;; 
	 (?\xA0C4 . bidi-category-l) ;; 
	 (?\xA0C5 . bidi-category-l) ;; 
	 (?\xA0C6 . bidi-category-l) ;; 
	 (?\xA0C7 . bidi-category-l) ;; 
	 (?\xA0C8 . bidi-category-l) ;; 
	 (?\xA0C9 . bidi-category-l) ;; 
	 (?\xA0CA . bidi-category-l) ;; 
	 (?\xA0CB . bidi-category-l) ;; 
	 (?\xA0CC . bidi-category-l) ;; 
	 (?\xA0CD . bidi-category-l) ;; 
	 (?\xA0CE . bidi-category-l) ;; 
	 (?\xA0CF . bidi-category-l) ;; 
	 (?\xA0D0 . bidi-category-l) ;; 
	 (?\xA0D1 . bidi-category-l) ;; 
	 (?\xA0D2 . bidi-category-l) ;; 
	 (?\xA0D3 . bidi-category-l) ;; 
	 (?\xA0D4 . bidi-category-l) ;; 
	 (?\xA0D5 . bidi-category-l) ;; 
	 (?\xA0D6 . bidi-category-l) ;; 
	 (?\xA0D7 . bidi-category-l) ;; 
	 (?\xA0D8 . bidi-category-l) ;; 
	 (?\xA0D9 . bidi-category-l) ;; 
	 (?\xA0DA . bidi-category-l) ;; 
	 (?\xA0DB . bidi-category-l) ;; 
	 (?\xA0DC . bidi-category-l) ;; 
	 (?\xA0DD . bidi-category-l) ;; 
	 (?\xA0DE . bidi-category-l) ;; 
	 (?\xA0DF . bidi-category-l) ;; 
	 (?\xA0E0 . bidi-category-l) ;; 
	 (?\xA0E1 . bidi-category-l) ;; 
	 (?\xA0E2 . bidi-category-l) ;; 
	 (?\xA0E3 . bidi-category-l) ;; 
	 (?\xA0E4 . bidi-category-l) ;; 
	 (?\xA0E5 . bidi-category-l) ;; 
	 (?\xA0E6 . bidi-category-l) ;; 
	 (?\xA0E7 . bidi-category-l) ;; 
	 (?\xA0E8 . bidi-category-l) ;; 
	 (?\xA0E9 . bidi-category-l) ;; 
	 (?\xA0EA . bidi-category-l) ;; 
	 (?\xA0EB . bidi-category-l) ;; 
	 (?\xA0EC . bidi-category-l) ;; 
	 (?\xA0ED . bidi-category-l) ;; 
	 (?\xA0EE . bidi-category-l) ;; 
	 (?\xA0EF . bidi-category-l) ;; 
	 (?\xA0F0 . bidi-category-l) ;; 
	 (?\xA0F1 . bidi-category-l) ;; 
	 (?\xA0F2 . bidi-category-l) ;; 
	 (?\xA0F3 . bidi-category-l) ;; 
	 (?\xA0F4 . bidi-category-l) ;; 
	 (?\xA0F5 . bidi-category-l) ;; 
	 (?\xA0F6 . bidi-category-l) ;; 
	 (?\xA0F7 . bidi-category-l) ;; 
	 (?\xA0F8 . bidi-category-l) ;; 
	 (?\xA0F9 . bidi-category-l) ;; 
	 (?\xA0FA . bidi-category-l) ;; 
	 (?\xA0FB . bidi-category-l) ;; 
	 (?\xA0FC . bidi-category-l) ;; 
	 (?\xA0FD . bidi-category-l) ;; 
	 (?\xA0FE . bidi-category-l) ;; 
	 (?\xA0FF . bidi-category-l) ;; 
	 (?\xA100 . bidi-category-l) ;; 
	 (?\xA101 . bidi-category-l) ;; 
	 (?\xA102 . bidi-category-l) ;; 
	 (?\xA103 . bidi-category-l) ;; 
	 (?\xA104 . bidi-category-l) ;; 
	 (?\xA105 . bidi-category-l) ;; 
	 (?\xA106 . bidi-category-l) ;; 
	 (?\xA107 . bidi-category-l) ;; 
	 (?\xA108 . bidi-category-l) ;; 
	 (?\xA109 . bidi-category-l) ;; 
	 (?\xA10A . bidi-category-l) ;; 
	 (?\xA10B . bidi-category-l) ;; 
	 (?\xA10C . bidi-category-l) ;; 
	 (?\xA10D . bidi-category-l) ;; 
	 (?\xA10E . bidi-category-l) ;; 
	 (?\xA10F . bidi-category-l) ;; 
	 (?\xA110 . bidi-category-l) ;; 
	 (?\xA111 . bidi-category-l) ;; 
	 (?\xA112 . bidi-category-l) ;; 
	 (?\xA113 . bidi-category-l) ;; 
	 (?\xA114 . bidi-category-l) ;; 
	 (?\xA115 . bidi-category-l) ;; 
	 (?\xA116 . bidi-category-l) ;; 
	 (?\xA117 . bidi-category-l) ;; 
	 (?\xA118 . bidi-category-l) ;; 
	 (?\xA119 . bidi-category-l) ;; 
	 (?\xA11A . bidi-category-l) ;; 
	 (?\xA11B . bidi-category-l) ;; 
	 (?\xA11C . bidi-category-l) ;; 
	 (?\xA11D . bidi-category-l) ;; 
	 (?\xA11E . bidi-category-l) ;; 
	 (?\xA11F . bidi-category-l) ;; 
	 (?\xA120 . bidi-category-l) ;; 
	 (?\xA121 . bidi-category-l) ;; 
	 (?\xA122 . bidi-category-l) ;; 
	 (?\xA123 . bidi-category-l) ;; 
	 (?\xA124 . bidi-category-l) ;; 
	 (?\xA125 . bidi-category-l) ;; 
	 (?\xA126 . bidi-category-l) ;; 
	 (?\xA127 . bidi-category-l) ;; 
	 (?\xA128 . bidi-category-l) ;; 
	 (?\xA129 . bidi-category-l) ;; 
	 (?\xA12A . bidi-category-l) ;; 
	 (?\xA12B . bidi-category-l) ;; 
	 (?\xA12C . bidi-category-l) ;; 
	 (?\xA12D . bidi-category-l) ;; 
	 (?\xA12E . bidi-category-l) ;; 
	 (?\xA12F . bidi-category-l) ;; 
	 (?\xA130 . bidi-category-l) ;; 
	 (?\xA131 . bidi-category-l) ;; 
	 (?\xA132 . bidi-category-l) ;; 
	 (?\xA133 . bidi-category-l) ;; 
	 (?\xA134 . bidi-category-l) ;; 
	 (?\xA135 . bidi-category-l) ;; 
	 (?\xA136 . bidi-category-l) ;; 
	 (?\xA137 . bidi-category-l) ;; 
	 (?\xA138 . bidi-category-l) ;; 
	 (?\xA139 . bidi-category-l) ;; 
	 (?\xA13A . bidi-category-l) ;; 
	 (?\xA13B . bidi-category-l) ;; 
	 (?\xA13C . bidi-category-l) ;; 
	 (?\xA13D . bidi-category-l) ;; 
	 (?\xA13E . bidi-category-l) ;; 
	 (?\xA13F . bidi-category-l) ;; 
	 (?\xA140 . bidi-category-l) ;; 
	 (?\xA141 . bidi-category-l) ;; 
	 (?\xA142 . bidi-category-l) ;; 
	 (?\xA143 . bidi-category-l) ;; 
	 (?\xA144 . bidi-category-l) ;; 
	 (?\xA145 . bidi-category-l) ;; 
	 (?\xA146 . bidi-category-l) ;; 
	 (?\xA147 . bidi-category-l) ;; 
	 (?\xA148 . bidi-category-l) ;; 
	 (?\xA149 . bidi-category-l) ;; 
	 (?\xA14A . bidi-category-l) ;; 
	 (?\xA14B . bidi-category-l) ;; 
	 (?\xA14C . bidi-category-l) ;; 
	 (?\xA14D . bidi-category-l) ;; 
	 (?\xA14E . bidi-category-l) ;; 
	 (?\xA14F . bidi-category-l) ;; 
	 (?\xA150 . bidi-category-l) ;; 
	 (?\xA151 . bidi-category-l) ;; 
	 (?\xA152 . bidi-category-l) ;; 
	 (?\xA153 . bidi-category-l) ;; 
	 (?\xA154 . bidi-category-l) ;; 
	 (?\xA155 . bidi-category-l) ;; 
	 (?\xA156 . bidi-category-l) ;; 
	 (?\xA157 . bidi-category-l) ;; 
	 (?\xA158 . bidi-category-l) ;; 
	 (?\xA159 . bidi-category-l) ;; 
	 (?\xA15A . bidi-category-l) ;; 
	 (?\xA15B . bidi-category-l) ;; 
	 (?\xA15C . bidi-category-l) ;; 
	 (?\xA15D . bidi-category-l) ;; 
	 (?\xA15E . bidi-category-l) ;; 
	 (?\xA15F . bidi-category-l) ;; 
	 (?\xA160 . bidi-category-l) ;; 
	 (?\xA161 . bidi-category-l) ;; 
	 (?\xA162 . bidi-category-l) ;; 
	 (?\xA163 . bidi-category-l) ;; 
	 (?\xA164 . bidi-category-l) ;; 
	 (?\xA165 . bidi-category-l) ;; 
	 (?\xA166 . bidi-category-l) ;; 
	 (?\xA167 . bidi-category-l) ;; 
	 (?\xA168 . bidi-category-l) ;; 
	 (?\xA169 . bidi-category-l) ;; 
	 (?\xA16A . bidi-category-l) ;; 
	 (?\xA16B . bidi-category-l) ;; 
	 (?\xA16C . bidi-category-l) ;; 
	 (?\xA16D . bidi-category-l) ;; 
	 (?\xA16E . bidi-category-l) ;; 
	 (?\xA16F . bidi-category-l) ;; 
	 (?\xA170 . bidi-category-l) ;; 
	 (?\xA171 . bidi-category-l) ;; 
	 (?\xA172 . bidi-category-l) ;; 
	 (?\xA173 . bidi-category-l) ;; 
	 (?\xA174 . bidi-category-l) ;; 
	 (?\xA175 . bidi-category-l) ;; 
	 (?\xA176 . bidi-category-l) ;; 
	 (?\xA177 . bidi-category-l) ;; 
	 (?\xA178 . bidi-category-l) ;; 
	 (?\xA179 . bidi-category-l) ;; 
	 (?\xA17A . bidi-category-l) ;; 
	 (?\xA17B . bidi-category-l) ;; 
	 (?\xA17C . bidi-category-l) ;; 
	 (?\xA17D . bidi-category-l) ;; 
	 (?\xA17E . bidi-category-l) ;; 
	 (?\xA17F . bidi-category-l) ;; 
	 (?\xA180 . bidi-category-l) ;; 
	 (?\xA181 . bidi-category-l) ;; 
	 (?\xA182 . bidi-category-l) ;; 
	 (?\xA183 . bidi-category-l) ;; 
	 (?\xA184 . bidi-category-l) ;; 
	 (?\xA185 . bidi-category-l) ;; 
	 (?\xA186 . bidi-category-l) ;; 
	 (?\xA187 . bidi-category-l) ;; 
	 (?\xA188 . bidi-category-l) ;; 
	 (?\xA189 . bidi-category-l) ;; 
	 (?\xA18A . bidi-category-l) ;; 
	 (?\xA18B . bidi-category-l) ;; 
	 (?\xA18C . bidi-category-l) ;; 
	 (?\xA18D . bidi-category-l) ;; 
	 (?\xA18E . bidi-category-l) ;; 
	 (?\xA18F . bidi-category-l) ;; 
	 (?\xA190 . bidi-category-l) ;; 
	 (?\xA191 . bidi-category-l) ;; 
	 (?\xA192 . bidi-category-l) ;; 
	 (?\xA193 . bidi-category-l) ;; 
	 (?\xA194 . bidi-category-l) ;; 
	 (?\xA195 . bidi-category-l) ;; 
	 (?\xA196 . bidi-category-l) ;; 
	 (?\xA197 . bidi-category-l) ;; 
	 (?\xA198 . bidi-category-l) ;; 
	 (?\xA199 . bidi-category-l) ;; 
	 (?\xA19A . bidi-category-l) ;; 
	 (?\xA19B . bidi-category-l) ;; 
	 (?\xA19C . bidi-category-l) ;; 
	 (?\xA19D . bidi-category-l) ;; 
	 (?\xA19E . bidi-category-l) ;; 
	 (?\xA19F . bidi-category-l) ;; 
	 (?\xA1A0 . bidi-category-l) ;; 
	 (?\xA1A1 . bidi-category-l) ;; 
	 (?\xA1A2 . bidi-category-l) ;; 
	 (?\xA1A3 . bidi-category-l) ;; 
	 (?\xA1A4 . bidi-category-l) ;; 
	 (?\xA1A5 . bidi-category-l) ;; 
	 (?\xA1A6 . bidi-category-l) ;; 
	 (?\xA1A7 . bidi-category-l) ;; 
	 (?\xA1A8 . bidi-category-l) ;; 
	 (?\xA1A9 . bidi-category-l) ;; 
	 (?\xA1AA . bidi-category-l) ;; 
	 (?\xA1AB . bidi-category-l) ;; 
	 (?\xA1AC . bidi-category-l) ;; 
	 (?\xA1AD . bidi-category-l) ;; 
	 (?\xA1AE . bidi-category-l) ;; 
	 (?\xA1AF . bidi-category-l) ;; 
	 (?\xA1B0 . bidi-category-l) ;; 
	 (?\xA1B1 . bidi-category-l) ;; 
	 (?\xA1B2 . bidi-category-l) ;; 
	 (?\xA1B3 . bidi-category-l) ;; 
	 (?\xA1B4 . bidi-category-l) ;; 
	 (?\xA1B5 . bidi-category-l) ;; 
	 (?\xA1B6 . bidi-category-l) ;; 
	 (?\xA1B7 . bidi-category-l) ;; 
	 (?\xA1B8 . bidi-category-l) ;; 
	 (?\xA1B9 . bidi-category-l) ;; 
	 (?\xA1BA . bidi-category-l) ;; 
	 (?\xA1BB . bidi-category-l) ;; 
	 (?\xA1BC . bidi-category-l) ;; 
	 (?\xA1BD . bidi-category-l) ;; 
	 (?\xA1BE . bidi-category-l) ;; 
	 (?\xA1BF . bidi-category-l) ;; 
	 (?\xA1C0 . bidi-category-l) ;; 
	 (?\xA1C1 . bidi-category-l) ;; 
	 (?\xA1C2 . bidi-category-l) ;; 
	 (?\xA1C3 . bidi-category-l) ;; 
	 (?\xA1C4 . bidi-category-l) ;; 
	 (?\xA1C5 . bidi-category-l) ;; 
	 (?\xA1C6 . bidi-category-l) ;; 
	 (?\xA1C7 . bidi-category-l) ;; 
	 (?\xA1C8 . bidi-category-l) ;; 
	 (?\xA1C9 . bidi-category-l) ;; 
	 (?\xA1CA . bidi-category-l) ;; 
	 (?\xA1CB . bidi-category-l) ;; 
	 (?\xA1CC . bidi-category-l) ;; 
	 (?\xA1CD . bidi-category-l) ;; 
	 (?\xA1CE . bidi-category-l) ;; 
	 (?\xA1CF . bidi-category-l) ;; 
	 (?\xA1D0 . bidi-category-l) ;; 
	 (?\xA1D1 . bidi-category-l) ;; 
	 (?\xA1D2 . bidi-category-l) ;; 
	 (?\xA1D3 . bidi-category-l) ;; 
	 (?\xA1D4 . bidi-category-l) ;; 
	 (?\xA1D5 . bidi-category-l) ;; 
	 (?\xA1D6 . bidi-category-l) ;; 
	 (?\xA1D7 . bidi-category-l) ;; 
	 (?\xA1D8 . bidi-category-l) ;; 
	 (?\xA1D9 . bidi-category-l) ;; 
	 (?\xA1DA . bidi-category-l) ;; 
	 (?\xA1DB . bidi-category-l) ;; 
	 (?\xA1DC . bidi-category-l) ;; 
	 (?\xA1DD . bidi-category-l) ;; 
	 (?\xA1DE . bidi-category-l) ;; 
	 (?\xA1DF . bidi-category-l) ;; 
	 (?\xA1E0 . bidi-category-l) ;; 
	 (?\xA1E1 . bidi-category-l) ;; 
	 (?\xA1E2 . bidi-category-l) ;; 
	 (?\xA1E3 . bidi-category-l) ;; 
	 (?\xA1E4 . bidi-category-l) ;; 
	 (?\xA1E5 . bidi-category-l) ;; 
	 (?\xA1E6 . bidi-category-l) ;; 
	 (?\xA1E7 . bidi-category-l) ;; 
	 (?\xA1E8 . bidi-category-l) ;; 
	 (?\xA1E9 . bidi-category-l) ;; 
	 (?\xA1EA . bidi-category-l) ;; 
	 (?\xA1EB . bidi-category-l) ;; 
	 (?\xA1EC . bidi-category-l) ;; 
	 (?\xA1ED . bidi-category-l) ;; 
	 (?\xA1EE . bidi-category-l) ;; 
	 (?\xA1EF . bidi-category-l) ;; 
	 (?\xA1F0 . bidi-category-l) ;; 
	 (?\xA1F1 . bidi-category-l) ;; 
	 (?\xA1F2 . bidi-category-l) ;; 
	 (?\xA1F3 . bidi-category-l) ;; 
	 (?\xA1F4 . bidi-category-l) ;; 
	 (?\xA1F5 . bidi-category-l) ;; 
	 (?\xA1F6 . bidi-category-l) ;; 
	 (?\xA1F7 . bidi-category-l) ;; 
	 (?\xA1F8 . bidi-category-l) ;; 
	 (?\xA1F9 . bidi-category-l) ;; 
	 (?\xA1FA . bidi-category-l) ;; 
	 (?\xA1FB . bidi-category-l) ;; 
	 (?\xA1FC . bidi-category-l) ;; 
	 (?\xA1FD . bidi-category-l) ;; 
	 (?\xA1FE . bidi-category-l) ;; 
	 (?\xA1FF . bidi-category-l) ;; 
	 (?\xA200 . bidi-category-l) ;; 
	 (?\xA201 . bidi-category-l) ;; 
	 (?\xA202 . bidi-category-l) ;; 
	 (?\xA203 . bidi-category-l) ;; 
	 (?\xA204 . bidi-category-l) ;; 
	 (?\xA205 . bidi-category-l) ;; 
	 (?\xA206 . bidi-category-l) ;; 
	 (?\xA207 . bidi-category-l) ;; 
	 (?\xA208 . bidi-category-l) ;; 
	 (?\xA209 . bidi-category-l) ;; 
	 (?\xA20A . bidi-category-l) ;; 
	 (?\xA20B . bidi-category-l) ;; 
	 (?\xA20C . bidi-category-l) ;; 
	 (?\xA20D . bidi-category-l) ;; 
	 (?\xA20E . bidi-category-l) ;; 
	 (?\xA20F . bidi-category-l) ;; 
	 (?\xA210 . bidi-category-l) ;; 
	 (?\xA211 . bidi-category-l) ;; 
	 (?\xA212 . bidi-category-l) ;; 
	 (?\xA213 . bidi-category-l) ;; 
	 (?\xA214 . bidi-category-l) ;; 
	 (?\xA215 . bidi-category-l) ;; 
	 (?\xA216 . bidi-category-l) ;; 
	 (?\xA217 . bidi-category-l) ;; 
	 (?\xA218 . bidi-category-l) ;; 
	 (?\xA219 . bidi-category-l) ;; 
	 (?\xA21A . bidi-category-l) ;; 
	 (?\xA21B . bidi-category-l) ;; 
	 (?\xA21C . bidi-category-l) ;; 
	 (?\xA21D . bidi-category-l) ;; 
	 (?\xA21E . bidi-category-l) ;; 
	 (?\xA21F . bidi-category-l) ;; 
	 (?\xA220 . bidi-category-l) ;; 
	 (?\xA221 . bidi-category-l) ;; 
	 (?\xA222 . bidi-category-l) ;; 
	 (?\xA223 . bidi-category-l) ;; 
	 (?\xA224 . bidi-category-l) ;; 
	 (?\xA225 . bidi-category-l) ;; 
	 (?\xA226 . bidi-category-l) ;; 
	 (?\xA227 . bidi-category-l) ;; 
	 (?\xA228 . bidi-category-l) ;; 
	 (?\xA229 . bidi-category-l) ;; 
	 (?\xA22A . bidi-category-l) ;; 
	 (?\xA22B . bidi-category-l) ;; 
	 (?\xA22C . bidi-category-l) ;; 
	 (?\xA22D . bidi-category-l) ;; 
	 (?\xA22E . bidi-category-l) ;; 
	 (?\xA22F . bidi-category-l) ;; 
	 (?\xA230 . bidi-category-l) ;; 
	 (?\xA231 . bidi-category-l) ;; 
	 (?\xA232 . bidi-category-l) ;; 
	 (?\xA233 . bidi-category-l) ;; 
	 (?\xA234 . bidi-category-l) ;; 
	 (?\xA235 . bidi-category-l) ;; 
	 (?\xA236 . bidi-category-l) ;; 
	 (?\xA237 . bidi-category-l) ;; 
	 (?\xA238 . bidi-category-l) ;; 
	 (?\xA239 . bidi-category-l) ;; 
	 (?\xA23A . bidi-category-l) ;; 
	 (?\xA23B . bidi-category-l) ;; 
	 (?\xA23C . bidi-category-l) ;; 
	 (?\xA23D . bidi-category-l) ;; 
	 (?\xA23E . bidi-category-l) ;; 
	 (?\xA23F . bidi-category-l) ;; 
	 (?\xA240 . bidi-category-l) ;; 
	 (?\xA241 . bidi-category-l) ;; 
	 (?\xA242 . bidi-category-l) ;; 
	 (?\xA243 . bidi-category-l) ;; 
	 (?\xA244 . bidi-category-l) ;; 
	 (?\xA245 . bidi-category-l) ;; 
	 (?\xA246 . bidi-category-l) ;; 
	 (?\xA247 . bidi-category-l) ;; 
	 (?\xA248 . bidi-category-l) ;; 
	 (?\xA249 . bidi-category-l) ;; 
	 (?\xA24A . bidi-category-l) ;; 
	 (?\xA24B . bidi-category-l) ;; 
	 (?\xA24C . bidi-category-l) ;; 
	 (?\xA24D . bidi-category-l) ;; 
	 (?\xA24E . bidi-category-l) ;; 
	 (?\xA24F . bidi-category-l) ;; 
	 (?\xA250 . bidi-category-l) ;; 
	 (?\xA251 . bidi-category-l) ;; 
	 (?\xA252 . bidi-category-l) ;; 
	 (?\xA253 . bidi-category-l) ;; 
	 (?\xA254 . bidi-category-l) ;; 
	 (?\xA255 . bidi-category-l) ;; 
	 (?\xA256 . bidi-category-l) ;; 
	 (?\xA257 . bidi-category-l) ;; 
	 (?\xA258 . bidi-category-l) ;; 
	 (?\xA259 . bidi-category-l) ;; 
	 (?\xA25A . bidi-category-l) ;; 
	 (?\xA25B . bidi-category-l) ;; 
	 (?\xA25C . bidi-category-l) ;; 
	 (?\xA25D . bidi-category-l) ;; 
	 (?\xA25E . bidi-category-l) ;; 
	 (?\xA25F . bidi-category-l) ;; 
	 (?\xA260 . bidi-category-l) ;; 
	 (?\xA261 . bidi-category-l) ;; 
	 (?\xA262 . bidi-category-l) ;; 
	 (?\xA263 . bidi-category-l) ;; 
	 (?\xA264 . bidi-category-l) ;; 
	 (?\xA265 . bidi-category-l) ;; 
	 (?\xA266 . bidi-category-l) ;; 
	 (?\xA267 . bidi-category-l) ;; 
	 (?\xA268 . bidi-category-l) ;; 
	 (?\xA269 . bidi-category-l) ;; 
	 (?\xA26A . bidi-category-l) ;; 
	 (?\xA26B . bidi-category-l) ;; 
	 (?\xA26C . bidi-category-l) ;; 
	 (?\xA26D . bidi-category-l) ;; 
	 (?\xA26E . bidi-category-l) ;; 
	 (?\xA26F . bidi-category-l) ;; 
	 (?\xA270 . bidi-category-l) ;; 
	 (?\xA271 . bidi-category-l) ;; 
	 (?\xA272 . bidi-category-l) ;; 
	 (?\xA273 . bidi-category-l) ;; 
	 (?\xA274 . bidi-category-l) ;; 
	 (?\xA275 . bidi-category-l) ;; 
	 (?\xA276 . bidi-category-l) ;; 
	 (?\xA277 . bidi-category-l) ;; 
	 (?\xA278 . bidi-category-l) ;; 
	 (?\xA279 . bidi-category-l) ;; 
	 (?\xA27A . bidi-category-l) ;; 
	 (?\xA27B . bidi-category-l) ;; 
	 (?\xA27C . bidi-category-l) ;; 
	 (?\xA27D . bidi-category-l) ;; 
	 (?\xA27E . bidi-category-l) ;; 
	 (?\xA27F . bidi-category-l) ;; 
	 (?\xA280 . bidi-category-l) ;; 
	 (?\xA281 . bidi-category-l) ;; 
	 (?\xA282 . bidi-category-l) ;; 
	 (?\xA283 . bidi-category-l) ;; 
	 (?\xA284 . bidi-category-l) ;; 
	 (?\xA285 . bidi-category-l) ;; 
	 (?\xA286 . bidi-category-l) ;; 
	 (?\xA287 . bidi-category-l) ;; 
	 (?\xA288 . bidi-category-l) ;; 
	 (?\xA289 . bidi-category-l) ;; 
	 (?\xA28A . bidi-category-l) ;; 
	 (?\xA28B . bidi-category-l) ;; 
	 (?\xA28C . bidi-category-l) ;; 
	 (?\xA28D . bidi-category-l) ;; 
	 (?\xA28E . bidi-category-l) ;; 
	 (?\xA28F . bidi-category-l) ;; 
	 (?\xA290 . bidi-category-l) ;; 
	 (?\xA291 . bidi-category-l) ;; 
	 (?\xA292 . bidi-category-l) ;; 
	 (?\xA293 . bidi-category-l) ;; 
	 (?\xA294 . bidi-category-l) ;; 
	 (?\xA295 . bidi-category-l) ;; 
	 (?\xA296 . bidi-category-l) ;; 
	 (?\xA297 . bidi-category-l) ;; 
	 (?\xA298 . bidi-category-l) ;; 
	 (?\xA299 . bidi-category-l) ;; 
	 (?\xA29A . bidi-category-l) ;; 
	 (?\xA29B . bidi-category-l) ;; 
	 (?\xA29C . bidi-category-l) ;; 
	 (?\xA29D . bidi-category-l) ;; 
	 (?\xA29E . bidi-category-l) ;; 
	 (?\xA29F . bidi-category-l) ;; 
	 (?\xA2A0 . bidi-category-l) ;; 
	 (?\xA2A1 . bidi-category-l) ;; 
	 (?\xA2A2 . bidi-category-l) ;; 
	 (?\xA2A3 . bidi-category-l) ;; 
	 (?\xA2A4 . bidi-category-l) ;; 
	 (?\xA2A5 . bidi-category-l) ;; 
	 (?\xA2A6 . bidi-category-l) ;; 
	 (?\xA2A7 . bidi-category-l) ;; 
	 (?\xA2A8 . bidi-category-l) ;; 
	 (?\xA2A9 . bidi-category-l) ;; 
	 (?\xA2AA . bidi-category-l) ;; 
	 (?\xA2AB . bidi-category-l) ;; 
	 (?\xA2AC . bidi-category-l) ;; 
	 (?\xA2AD . bidi-category-l) ;; 
	 (?\xA2AE . bidi-category-l) ;; 
	 (?\xA2AF . bidi-category-l) ;; 
	 (?\xA2B0 . bidi-category-l) ;; 
	 (?\xA2B1 . bidi-category-l) ;; 
	 (?\xA2B2 . bidi-category-l) ;; 
	 (?\xA2B3 . bidi-category-l) ;; 
	 (?\xA2B4 . bidi-category-l) ;; 
	 (?\xA2B5 . bidi-category-l) ;; 
	 (?\xA2B6 . bidi-category-l) ;; 
	 (?\xA2B7 . bidi-category-l) ;; 
	 (?\xA2B8 . bidi-category-l) ;; 
	 (?\xA2B9 . bidi-category-l) ;; 
	 (?\xA2BA . bidi-category-l) ;; 
	 (?\xA2BB . bidi-category-l) ;; 
	 (?\xA2BC . bidi-category-l) ;; 
	 (?\xA2BD . bidi-category-l) ;; 
	 (?\xA2BE . bidi-category-l) ;; 
	 (?\xA2BF . bidi-category-l) ;; 
	 (?\xA2C0 . bidi-category-l) ;; 
	 (?\xA2C1 . bidi-category-l) ;; 
	 (?\xA2C2 . bidi-category-l) ;; 
	 (?\xA2C3 . bidi-category-l) ;; 
	 (?\xA2C4 . bidi-category-l) ;; 
	 (?\xA2C5 . bidi-category-l) ;; 
	 (?\xA2C6 . bidi-category-l) ;; 
	 (?\xA2C7 . bidi-category-l) ;; 
	 (?\xA2C8 . bidi-category-l) ;; 
	 (?\xA2C9 . bidi-category-l) ;; 
	 (?\xA2CA . bidi-category-l) ;; 
	 (?\xA2CB . bidi-category-l) ;; 
	 (?\xA2CC . bidi-category-l) ;; 
	 (?\xA2CD . bidi-category-l) ;; 
	 (?\xA2CE . bidi-category-l) ;; 
	 (?\xA2CF . bidi-category-l) ;; 
	 (?\xA2D0 . bidi-category-l) ;; 
	 (?\xA2D1 . bidi-category-l) ;; 
	 (?\xA2D2 . bidi-category-l) ;; 
	 (?\xA2D3 . bidi-category-l) ;; 
	 (?\xA2D4 . bidi-category-l) ;; 
	 (?\xA2D5 . bidi-category-l) ;; 
	 (?\xA2D6 . bidi-category-l) ;; 
	 (?\xA2D7 . bidi-category-l) ;; 
	 (?\xA2D8 . bidi-category-l) ;; 
	 (?\xA2D9 . bidi-category-l) ;; 
	 (?\xA2DA . bidi-category-l) ;; 
	 (?\xA2DB . bidi-category-l) ;; 
	 (?\xA2DC . bidi-category-l) ;; 
	 (?\xA2DD . bidi-category-l) ;; 
	 (?\xA2DE . bidi-category-l) ;; 
	 (?\xA2DF . bidi-category-l) ;; 
	 (?\xA2E0 . bidi-category-l) ;; 
	 (?\xA2E1 . bidi-category-l) ;; 
	 (?\xA2E2 . bidi-category-l) ;; 
	 (?\xA2E3 . bidi-category-l) ;; 
	 (?\xA2E4 . bidi-category-l) ;; 
	 (?\xA2E5 . bidi-category-l) ;; 
	 (?\xA2E6 . bidi-category-l) ;; 
	 (?\xA2E7 . bidi-category-l) ;; 
	 (?\xA2E8 . bidi-category-l) ;; 
	 (?\xA2E9 . bidi-category-l) ;; 
	 (?\xA2EA . bidi-category-l) ;; 
	 (?\xA2EB . bidi-category-l) ;; 
	 (?\xA2EC . bidi-category-l) ;; 
	 (?\xA2ED . bidi-category-l) ;; 
	 (?\xA2EE . bidi-category-l) ;; 
	 (?\xA2EF . bidi-category-l) ;; 
	 (?\xA2F0 . bidi-category-l) ;; 
	 (?\xA2F1 . bidi-category-l) ;; 
	 (?\xA2F2 . bidi-category-l) ;; 
	 (?\xA2F3 . bidi-category-l) ;; 
	 (?\xA2F4 . bidi-category-l) ;; 
	 (?\xA2F5 . bidi-category-l) ;; 
	 (?\xA2F6 . bidi-category-l) ;; 
	 (?\xA2F7 . bidi-category-l) ;; 
	 (?\xA2F8 . bidi-category-l) ;; 
	 (?\xA2F9 . bidi-category-l) ;; 
	 (?\xA2FA . bidi-category-l) ;; 
	 (?\xA2FB . bidi-category-l) ;; 
	 (?\xA2FC . bidi-category-l) ;; 
	 (?\xA2FD . bidi-category-l) ;; 
	 (?\xA2FE . bidi-category-l) ;; 
	 (?\xA2FF . bidi-category-l) ;; 
	 (?\xA300 . bidi-category-l) ;; 
	 (?\xA301 . bidi-category-l) ;; 
	 (?\xA302 . bidi-category-l) ;; 
	 (?\xA303 . bidi-category-l) ;; 
	 (?\xA304 . bidi-category-l) ;; 
	 (?\xA305 . bidi-category-l) ;; 
	 (?\xA306 . bidi-category-l) ;; 
	 (?\xA307 . bidi-category-l) ;; 
	 (?\xA308 . bidi-category-l) ;; 
	 (?\xA309 . bidi-category-l) ;; 
	 (?\xA30A . bidi-category-l) ;; 
	 (?\xA30B . bidi-category-l) ;; 
	 (?\xA30C . bidi-category-l) ;; 
	 (?\xA30D . bidi-category-l) ;; 
	 (?\xA30E . bidi-category-l) ;; 
	 (?\xA30F . bidi-category-l) ;; 
	 (?\xA310 . bidi-category-l) ;; 
	 (?\xA311 . bidi-category-l) ;; 
	 (?\xA312 . bidi-category-l) ;; 
	 (?\xA313 . bidi-category-l) ;; 
	 (?\xA314 . bidi-category-l) ;; 
	 (?\xA315 . bidi-category-l) ;; 
	 (?\xA316 . bidi-category-l) ;; 
	 (?\xA317 . bidi-category-l) ;; 
	 (?\xA318 . bidi-category-l) ;; 
	 (?\xA319 . bidi-category-l) ;; 
	 (?\xA31A . bidi-category-l) ;; 
	 (?\xA31B . bidi-category-l) ;; 
	 (?\xA31C . bidi-category-l) ;; 
	 (?\xA31D . bidi-category-l) ;; 
	 (?\xA31E . bidi-category-l) ;; 
	 (?\xA31F . bidi-category-l) ;; 
	 (?\xA320 . bidi-category-l) ;; 
	 (?\xA321 . bidi-category-l) ;; 
	 (?\xA322 . bidi-category-l) ;; 
	 (?\xA323 . bidi-category-l) ;; 
	 (?\xA324 . bidi-category-l) ;; 
	 (?\xA325 . bidi-category-l) ;; 
	 (?\xA326 . bidi-category-l) ;; 
	 (?\xA327 . bidi-category-l) ;; 
	 (?\xA328 . bidi-category-l) ;; 
	 (?\xA329 . bidi-category-l) ;; 
	 (?\xA32A . bidi-category-l) ;; 
	 (?\xA32B . bidi-category-l) ;; 
	 (?\xA32C . bidi-category-l) ;; 
	 (?\xA32D . bidi-category-l) ;; 
	 (?\xA32E . bidi-category-l) ;; 
	 (?\xA32F . bidi-category-l) ;; 
	 (?\xA330 . bidi-category-l) ;; 
	 (?\xA331 . bidi-category-l) ;; 
	 (?\xA332 . bidi-category-l) ;; 
	 (?\xA333 . bidi-category-l) ;; 
	 (?\xA334 . bidi-category-l) ;; 
	 (?\xA335 . bidi-category-l) ;; 
	 (?\xA336 . bidi-category-l) ;; 
	 (?\xA337 . bidi-category-l) ;; 
	 (?\xA338 . bidi-category-l) ;; 
	 (?\xA339 . bidi-category-l) ;; 
	 (?\xA33A . bidi-category-l) ;; 
	 (?\xA33B . bidi-category-l) ;; 
	 (?\xA33C . bidi-category-l) ;; 
	 (?\xA33D . bidi-category-l) ;; 
	 (?\xA33E . bidi-category-l) ;; 
	 (?\xA33F . bidi-category-l) ;; 
	 (?\xA340 . bidi-category-l) ;; 
	 (?\xA341 . bidi-category-l) ;; 
	 (?\xA342 . bidi-category-l) ;; 
	 (?\xA343 . bidi-category-l) ;; 
	 (?\xA344 . bidi-category-l) ;; 
	 (?\xA345 . bidi-category-l) ;; 
	 (?\xA346 . bidi-category-l) ;; 
	 (?\xA347 . bidi-category-l) ;; 
	 (?\xA348 . bidi-category-l) ;; 
	 (?\xA349 . bidi-category-l) ;; 
	 (?\xA34A . bidi-category-l) ;; 
	 (?\xA34B . bidi-category-l) ;; 
	 (?\xA34C . bidi-category-l) ;; 
	 (?\xA34D . bidi-category-l) ;; 
	 (?\xA34E . bidi-category-l) ;; 
	 (?\xA34F . bidi-category-l) ;; 
	 (?\xA350 . bidi-category-l) ;; 
	 (?\xA351 . bidi-category-l) ;; 
	 (?\xA352 . bidi-category-l) ;; 
	 (?\xA353 . bidi-category-l) ;; 
	 (?\xA354 . bidi-category-l) ;; 
	 (?\xA355 . bidi-category-l) ;; 
	 (?\xA356 . bidi-category-l) ;; 
	 (?\xA357 . bidi-category-l) ;; 
	 (?\xA358 . bidi-category-l) ;; 
	 (?\xA359 . bidi-category-l) ;; 
	 (?\xA35A . bidi-category-l) ;; 
	 (?\xA35B . bidi-category-l) ;; 
	 (?\xA35C . bidi-category-l) ;; 
	 (?\xA35D . bidi-category-l) ;; 
	 (?\xA35E . bidi-category-l) ;; 
	 (?\xA35F . bidi-category-l) ;; 
	 (?\xA360 . bidi-category-l) ;; 
	 (?\xA361 . bidi-category-l) ;; 
	 (?\xA362 . bidi-category-l) ;; 
	 (?\xA363 . bidi-category-l) ;; 
	 (?\xA364 . bidi-category-l) ;; 
	 (?\xA365 . bidi-category-l) ;; 
	 (?\xA366 . bidi-category-l) ;; 
	 (?\xA367 . bidi-category-l) ;; 
	 (?\xA368 . bidi-category-l) ;; 
	 (?\xA369 . bidi-category-l) ;; 
	 (?\xA36A . bidi-category-l) ;; 
	 (?\xA36B . bidi-category-l) ;; 
	 (?\xA36C . bidi-category-l) ;; 
	 (?\xA36D . bidi-category-l) ;; 
	 (?\xA36E . bidi-category-l) ;; 
	 (?\xA36F . bidi-category-l) ;; 
	 (?\xA370 . bidi-category-l) ;; 
	 (?\xA371 . bidi-category-l) ;; 
	 (?\xA372 . bidi-category-l) ;; 
	 (?\xA373 . bidi-category-l) ;; 
	 (?\xA374 . bidi-category-l) ;; 
	 (?\xA375 . bidi-category-l) ;; 
	 (?\xA376 . bidi-category-l) ;; 
	 (?\xA377 . bidi-category-l) ;; 
	 (?\xA378 . bidi-category-l) ;; 
	 (?\xA379 . bidi-category-l) ;; 
	 (?\xA37A . bidi-category-l) ;; 
	 (?\xA37B . bidi-category-l) ;; 
	 (?\xA37C . bidi-category-l) ;; 
	 (?\xA37D . bidi-category-l) ;; 
	 (?\xA37E . bidi-category-l) ;; 
	 (?\xA37F . bidi-category-l) ;; 
	 (?\xA380 . bidi-category-l) ;; 
	 (?\xA381 . bidi-category-l) ;; 
	 (?\xA382 . bidi-category-l) ;; 
	 (?\xA383 . bidi-category-l) ;; 
	 (?\xA384 . bidi-category-l) ;; 
	 (?\xA385 . bidi-category-l) ;; 
	 (?\xA386 . bidi-category-l) ;; 
	 (?\xA387 . bidi-category-l) ;; 
	 (?\xA388 . bidi-category-l) ;; 
	 (?\xA389 . bidi-category-l) ;; 
	 (?\xA38A . bidi-category-l) ;; 
	 (?\xA38B . bidi-category-l) ;; 
	 (?\xA38C . bidi-category-l) ;; 
	 (?\xA38D . bidi-category-l) ;; 
	 (?\xA38E . bidi-category-l) ;; 
	 (?\xA38F . bidi-category-l) ;; 
	 (?\xA390 . bidi-category-l) ;; 
	 (?\xA391 . bidi-category-l) ;; 
	 (?\xA392 . bidi-category-l) ;; 
	 (?\xA393 . bidi-category-l) ;; 
	 (?\xA394 . bidi-category-l) ;; 
	 (?\xA395 . bidi-category-l) ;; 
	 (?\xA396 . bidi-category-l) ;; 
	 (?\xA397 . bidi-category-l) ;; 
	 (?\xA398 . bidi-category-l) ;; 
	 (?\xA399 . bidi-category-l) ;; 
	 (?\xA39A . bidi-category-l) ;; 
	 (?\xA39B . bidi-category-l) ;; 
	 (?\xA39C . bidi-category-l) ;; 
	 (?\xA39D . bidi-category-l) ;; 
	 (?\xA39E . bidi-category-l) ;; 
	 (?\xA39F . bidi-category-l) ;; 
	 (?\xA3A0 . bidi-category-l) ;; 
	 (?\xA3A1 . bidi-category-l) ;; 
	 (?\xA3A2 . bidi-category-l) ;; 
	 (?\xA3A3 . bidi-category-l) ;; 
	 (?\xA3A4 . bidi-category-l) ;; 
	 (?\xA3A5 . bidi-category-l) ;; 
	 (?\xA3A6 . bidi-category-l) ;; 
	 (?\xA3A7 . bidi-category-l) ;; 
	 (?\xA3A8 . bidi-category-l) ;; 
	 (?\xA3A9 . bidi-category-l) ;; 
	 (?\xA3AA . bidi-category-l) ;; 
	 (?\xA3AB . bidi-category-l) ;; 
	 (?\xA3AC . bidi-category-l) ;; 
	 (?\xA3AD . bidi-category-l) ;; 
	 (?\xA3AE . bidi-category-l) ;; 
	 (?\xA3AF . bidi-category-l) ;; 
	 (?\xA3B0 . bidi-category-l) ;; 
	 (?\xA3B1 . bidi-category-l) ;; 
	 (?\xA3B2 . bidi-category-l) ;; 
	 (?\xA3B3 . bidi-category-l) ;; 
	 (?\xA3B4 . bidi-category-l) ;; 
	 (?\xA3B5 . bidi-category-l) ;; 
	 (?\xA3B6 . bidi-category-l) ;; 
	 (?\xA3B7 . bidi-category-l) ;; 
	 (?\xA3B8 . bidi-category-l) ;; 
	 (?\xA3B9 . bidi-category-l) ;; 
	 (?\xA3BA . bidi-category-l) ;; 
	 (?\xA3BB . bidi-category-l) ;; 
	 (?\xA3BC . bidi-category-l) ;; 
	 (?\xA3BD . bidi-category-l) ;; 
	 (?\xA3BE . bidi-category-l) ;; 
	 (?\xA3BF . bidi-category-l) ;; 
	 (?\xA3C0 . bidi-category-l) ;; 
	 (?\xA3C1 . bidi-category-l) ;; 
	 (?\xA3C2 . bidi-category-l) ;; 
	 (?\xA3C3 . bidi-category-l) ;; 
	 (?\xA3C4 . bidi-category-l) ;; 
	 (?\xA3C5 . bidi-category-l) ;; 
	 (?\xA3C6 . bidi-category-l) ;; 
	 (?\xA3C7 . bidi-category-l) ;; 
	 (?\xA3C8 . bidi-category-l) ;; 
	 (?\xA3C9 . bidi-category-l) ;; 
	 (?\xA3CA . bidi-category-l) ;; 
	 (?\xA3CB . bidi-category-l) ;; 
	 (?\xA3CC . bidi-category-l) ;; 
	 (?\xA3CD . bidi-category-l) ;; 
	 (?\xA3CE . bidi-category-l) ;; 
	 (?\xA3CF . bidi-category-l) ;; 
	 (?\xA3D0 . bidi-category-l) ;; 
	 (?\xA3D1 . bidi-category-l) ;; 
	 (?\xA3D2 . bidi-category-l) ;; 
	 (?\xA3D3 . bidi-category-l) ;; 
	 (?\xA3D4 . bidi-category-l) ;; 
	 (?\xA3D5 . bidi-category-l) ;; 
	 (?\xA3D6 . bidi-category-l) ;; 
	 (?\xA3D7 . bidi-category-l) ;; 
	 (?\xA3D8 . bidi-category-l) ;; 
	 (?\xA3D9 . bidi-category-l) ;; 
	 (?\xA3DA . bidi-category-l) ;; 
	 (?\xA3DB . bidi-category-l) ;; 
	 (?\xA3DC . bidi-category-l) ;; 
	 (?\xA3DD . bidi-category-l) ;; 
	 (?\xA3DE . bidi-category-l) ;; 
	 (?\xA3DF . bidi-category-l) ;; 
	 (?\xA3E0 . bidi-category-l) ;; 
	 (?\xA3E1 . bidi-category-l) ;; 
	 (?\xA3E2 . bidi-category-l) ;; 
	 (?\xA3E3 . bidi-category-l) ;; 
	 (?\xA3E4 . bidi-category-l) ;; 
	 (?\xA3E5 . bidi-category-l) ;; 
	 (?\xA3E6 . bidi-category-l) ;; 
	 (?\xA3E7 . bidi-category-l) ;; 
	 (?\xA3E8 . bidi-category-l) ;; 
	 (?\xA3E9 . bidi-category-l) ;; 
	 (?\xA3EA . bidi-category-l) ;; 
	 (?\xA3EB . bidi-category-l) ;; 
	 (?\xA3EC . bidi-category-l) ;; 
	 (?\xA3ED . bidi-category-l) ;; 
	 (?\xA3EE . bidi-category-l) ;; 
	 (?\xA3EF . bidi-category-l) ;; 
	 (?\xA3F0 . bidi-category-l) ;; 
	 (?\xA3F1 . bidi-category-l) ;; 
	 (?\xA3F2 . bidi-category-l) ;; 
	 (?\xA3F3 . bidi-category-l) ;; 
	 (?\xA3F4 . bidi-category-l) ;; 
	 (?\xA3F5 . bidi-category-l) ;; 
	 (?\xA3F6 . bidi-category-l) ;; 
	 (?\xA3F7 . bidi-category-l) ;; 
	 (?\xA3F8 . bidi-category-l) ;; 
	 (?\xA3F9 . bidi-category-l) ;; 
	 (?\xA3FA . bidi-category-l) ;; 
	 (?\xA3FB . bidi-category-l) ;; 
	 (?\xA3FC . bidi-category-l) ;; 
	 (?\xA3FD . bidi-category-l) ;; 
	 (?\xA3FE . bidi-category-l) ;; 
	 (?\xA3FF . bidi-category-l) ;; 
	 (?\xA400 . bidi-category-l) ;; 
	 (?\xA401 . bidi-category-l) ;; 
	 (?\xA402 . bidi-category-l) ;; 
	 (?\xA403 . bidi-category-l) ;; 
	 (?\xA404 . bidi-category-l) ;; 
	 (?\xA405 . bidi-category-l) ;; 
	 (?\xA406 . bidi-category-l) ;; 
	 (?\xA407 . bidi-category-l) ;; 
	 (?\xA408 . bidi-category-l) ;; 
	 (?\xA409 . bidi-category-l) ;; 
	 (?\xA40A . bidi-category-l) ;; 
	 (?\xA40B . bidi-category-l) ;; 
	 (?\xA40C . bidi-category-l) ;; 
	 (?\xA40D . bidi-category-l) ;; 
	 (?\xA40E . bidi-category-l) ;; 
	 (?\xA40F . bidi-category-l) ;; 
	 (?\xA410 . bidi-category-l) ;; 
	 (?\xA411 . bidi-category-l) ;; 
	 (?\xA412 . bidi-category-l) ;; 
	 (?\xA413 . bidi-category-l) ;; 
	 (?\xA414 . bidi-category-l) ;; 
	 (?\xA415 . bidi-category-l) ;; 
	 (?\xA416 . bidi-category-l) ;; 
	 (?\xA417 . bidi-category-l) ;; 
	 (?\xA418 . bidi-category-l) ;; 
	 (?\xA419 . bidi-category-l) ;; 
	 (?\xA41A . bidi-category-l) ;; 
	 (?\xA41B . bidi-category-l) ;; 
	 (?\xA41C . bidi-category-l) ;; 
	 (?\xA41D . bidi-category-l) ;; 
	 (?\xA41E . bidi-category-l) ;; 
	 (?\xA41F . bidi-category-l) ;; 
	 (?\xA420 . bidi-category-l) ;; 
	 (?\xA421 . bidi-category-l) ;; 
	 (?\xA422 . bidi-category-l) ;; 
	 (?\xA423 . bidi-category-l) ;; 
	 (?\xA424 . bidi-category-l) ;; 
	 (?\xA425 . bidi-category-l) ;; 
	 (?\xA426 . bidi-category-l) ;; 
	 (?\xA427 . bidi-category-l) ;; 
	 (?\xA428 . bidi-category-l) ;; 
	 (?\xA429 . bidi-category-l) ;; 
	 (?\xA42A . bidi-category-l) ;; 
	 (?\xA42B . bidi-category-l) ;; 
	 (?\xA42C . bidi-category-l) ;; 
	 (?\xA42D . bidi-category-l) ;; 
	 (?\xA42E . bidi-category-l) ;; 
	 (?\xA42F . bidi-category-l) ;; 
	 (?\xA430 . bidi-category-l) ;; 
	 (?\xA431 . bidi-category-l) ;; 
	 (?\xA432 . bidi-category-l) ;; 
	 (?\xA433 . bidi-category-l) ;; 
	 (?\xA434 . bidi-category-l) ;; 
	 (?\xA435 . bidi-category-l) ;; 
	 (?\xA436 . bidi-category-l) ;; 
	 (?\xA437 . bidi-category-l) ;; 
	 (?\xA438 . bidi-category-l) ;; 
	 (?\xA439 . bidi-category-l) ;; 
	 (?\xA43A . bidi-category-l) ;; 
	 (?\xA43B . bidi-category-l) ;; 
	 (?\xA43C . bidi-category-l) ;; 
	 (?\xA43D . bidi-category-l) ;; 
	 (?\xA43E . bidi-category-l) ;; 
	 (?\xA43F . bidi-category-l) ;; 
	 (?\xA440 . bidi-category-l) ;; 
	 (?\xA441 . bidi-category-l) ;; 
	 (?\xA442 . bidi-category-l) ;; 
	 (?\xA443 . bidi-category-l) ;; 
	 (?\xA444 . bidi-category-l) ;; 
	 (?\xA445 . bidi-category-l) ;; 
	 (?\xA446 . bidi-category-l) ;; 
	 (?\xA447 . bidi-category-l) ;; 
	 (?\xA448 . bidi-category-l) ;; 
	 (?\xA449 . bidi-category-l) ;; 
	 (?\xA44A . bidi-category-l) ;; 
	 (?\xA44B . bidi-category-l) ;; 
	 (?\xA44C . bidi-category-l) ;; 
	 (?\xA44D . bidi-category-l) ;; 
	 (?\xA44E . bidi-category-l) ;; 
	 (?\xA44F . bidi-category-l) ;; 
	 (?\xA450 . bidi-category-l) ;; 
	 (?\xA451 . bidi-category-l) ;; 
	 (?\xA452 . bidi-category-l) ;; 
	 (?\xA453 . bidi-category-l) ;; 
	 (?\xA454 . bidi-category-l) ;; 
	 (?\xA455 . bidi-category-l) ;; 
	 (?\xA456 . bidi-category-l) ;; 
	 (?\xA457 . bidi-category-l) ;; 
	 (?\xA458 . bidi-category-l) ;; 
	 (?\xA459 . bidi-category-l) ;; 
	 (?\xA45A . bidi-category-l) ;; 
	 (?\xA45B . bidi-category-l) ;; 
	 (?\xA45C . bidi-category-l) ;; 
	 (?\xA45D . bidi-category-l) ;; 
	 (?\xA45E . bidi-category-l) ;; 
	 (?\xA45F . bidi-category-l) ;; 
	 (?\xA460 . bidi-category-l) ;; 
	 (?\xA461 . bidi-category-l) ;; 
	 (?\xA462 . bidi-category-l) ;; 
	 (?\xA463 . bidi-category-l) ;; 
	 (?\xA464 . bidi-category-l) ;; 
	 (?\xA465 . bidi-category-l) ;; 
	 (?\xA466 . bidi-category-l) ;; 
	 (?\xA467 . bidi-category-l) ;; 
	 (?\xA468 . bidi-category-l) ;; 
	 (?\xA469 . bidi-category-l) ;; 
	 (?\xA46A . bidi-category-l) ;; 
	 (?\xA46B . bidi-category-l) ;; 
	 (?\xA46C . bidi-category-l) ;; 
	 (?\xA46D . bidi-category-l) ;; 
	 (?\xA46E . bidi-category-l) ;; 
	 (?\xA46F . bidi-category-l) ;; 
	 (?\xA470 . bidi-category-l) ;; 
	 (?\xA471 . bidi-category-l) ;; 
	 (?\xA472 . bidi-category-l) ;; 
	 (?\xA473 . bidi-category-l) ;; 
	 (?\xA474 . bidi-category-l) ;; 
	 (?\xA475 . bidi-category-l) ;; 
	 (?\xA476 . bidi-category-l) ;; 
	 (?\xA477 . bidi-category-l) ;; 
	 (?\xA478 . bidi-category-l) ;; 
	 (?\xA479 . bidi-category-l) ;; 
	 (?\xA47A . bidi-category-l) ;; 
	 (?\xA47B . bidi-category-l) ;; 
	 (?\xA47C . bidi-category-l) ;; 
	 (?\xA47D . bidi-category-l) ;; 
	 (?\xA47E . bidi-category-l) ;; 
	 (?\xA47F . bidi-category-l) ;; 
	 (?\xA480 . bidi-category-l) ;; 
	 (?\xA481 . bidi-category-l) ;; 
	 (?\xA482 . bidi-category-l) ;; 
	 (?\xA483 . bidi-category-l) ;; 
	 (?\xA484 . bidi-category-l) ;; 
	 (?\xA485 . bidi-category-l) ;; 
	 (?\xA486 . bidi-category-l) ;; 
	 (?\xA487 . bidi-category-l) ;; 
	 (?\xA488 . bidi-category-l) ;; 
	 (?\xA489 . bidi-category-l) ;; 
	 (?\xA48A . bidi-category-l) ;; 
	 (?\xA48B . bidi-category-l) ;; 
	 (?\xA48C . bidi-category-l) ;; 
	 (?\xA490 . bidi-category-on) ;; 
	 (?\xA491 . bidi-category-on) ;; 
	 (?\xA492 . bidi-category-on) ;; 
	 (?\xA493 . bidi-category-on) ;; 
	 (?\xA494 . bidi-category-on) ;; 
	 (?\xA495 . bidi-category-on) ;; 
	 (?\xA496 . bidi-category-on) ;; 
	 (?\xA497 . bidi-category-on) ;; 
	 (?\xA498 . bidi-category-on) ;; 
	 (?\xA499 . bidi-category-on) ;; 
	 (?\xA49A . bidi-category-on) ;; 
	 (?\xA49B . bidi-category-on) ;; 
	 (?\xA49C . bidi-category-on) ;; 
	 (?\xA49D . bidi-category-on) ;; 
	 (?\xA49E . bidi-category-on) ;; 
	 (?\xA49F . bidi-category-on) ;; 
	 (?\xA4A0 . bidi-category-on) ;; 
	 (?\xA4A1 . bidi-category-on) ;; 
	 (?\xA4A4 . bidi-category-on) ;; 
	 (?\xA4A5 . bidi-category-on) ;; 
	 (?\xA4A6 . bidi-category-on) ;; 
	 (?\xA4A7 . bidi-category-on) ;; 
	 (?\xA4A8 . bidi-category-on) ;; 
	 (?\xA4A9 . bidi-category-on) ;; 
	 (?\xA4AA . bidi-category-on) ;; 
	 (?\xA4AB . bidi-category-on) ;; 
	 (?\xA4AC . bidi-category-on) ;; 
	 (?\xA4AD . bidi-category-on) ;; 
	 (?\xA4AE . bidi-category-on) ;; 
	 (?\xA4AF . bidi-category-on) ;; 
	 (?\xA4B0 . bidi-category-on) ;; 
	 (?\xA4B1 . bidi-category-on) ;; 
	 (?\xA4B2 . bidi-category-on) ;; 
	 (?\xA4B3 . bidi-category-on) ;; 
	 (?\xA4B5 . bidi-category-on) ;; 
	 (?\xA4B6 . bidi-category-on) ;; 
	 (?\xA4B7 . bidi-category-on) ;; 
	 (?\xA4B8 . bidi-category-on) ;; 
	 (?\xA4B9 . bidi-category-on) ;; 
	 (?\xA4BA . bidi-category-on) ;; 
	 (?\xA4BB . bidi-category-on) ;; 
	 (?\xA4BC . bidi-category-on) ;; 
	 (?\xA4BD . bidi-category-on) ;; 
	 (?\xA4BE . bidi-category-on) ;; 
	 (?\xA4BF . bidi-category-on) ;; 
	 (?\xA4C0 . bidi-category-on) ;; 
	 (?\xA4C2 . bidi-category-on) ;; 
	 (?\xA4C3 . bidi-category-on) ;; 
	 (?\xA4C4 . bidi-category-on) ;; 
	 (?\xA4C6 . bidi-category-on) ;; 
	 (?\xAC00 . bidi-category-l) ;; 
	 (?\xD7A3 . bidi-category-l) ;; 
	 (?\xD800 . bidi-category-l) ;; 
	 (?\xDB7F . bidi-category-l) ;; 
	 (?\xDB80 . bidi-category-l) ;; 
	 (?\xDBFF . bidi-category-l) ;; 
	 (?\xDC00 . bidi-category-l) ;; 
	 (?\xDFFF . bidi-category-l) ;; 
	 (?\xE000 . bidi-category-l) ;; 
	 (?\xF8FF . bidi-category-l) ;; 
	 (?\xF900 . bidi-category-l) ;; 
	 (?\xF901 . bidi-category-l) ;; 
	 (?\xF902 . bidi-category-l) ;; 
	 (?\xF903 . bidi-category-l) ;; 
	 (?\xF904 . bidi-category-l) ;; 
	 (?\xF905 . bidi-category-l) ;; 
	 (?\xF906 . bidi-category-l) ;; 
	 (?\xF907 . bidi-category-l) ;; 
	 (?\xF908 . bidi-category-l) ;; 
	 (?\xF909 . bidi-category-l) ;; 
	 (?\xF90A . bidi-category-l) ;; 
	 (?\xF90B . bidi-category-l) ;; 
	 (?\xF90C . bidi-category-l) ;; 
	 (?\xF90D . bidi-category-l) ;; 
	 (?\xF90E . bidi-category-l) ;; 
	 (?\xF90F . bidi-category-l) ;; 
	 (?\xF910 . bidi-category-l) ;; 
	 (?\xF911 . bidi-category-l) ;; 
	 (?\xF912 . bidi-category-l) ;; 
	 (?\xF913 . bidi-category-l) ;; 
	 (?\xF914 . bidi-category-l) ;; 
	 (?\xF915 . bidi-category-l) ;; 
	 (?\xF916 . bidi-category-l) ;; 
	 (?\xF917 . bidi-category-l) ;; 
	 (?\xF918 . bidi-category-l) ;; 
	 (?\xF919 . bidi-category-l) ;; 
	 (?\xF91A . bidi-category-l) ;; 
	 (?\xF91B . bidi-category-l) ;; 
	 (?\xF91C . bidi-category-l) ;; 
	 (?\xF91D . bidi-category-l) ;; 
	 (?\xF91E . bidi-category-l) ;; 
	 (?\xF91F . bidi-category-l) ;; 
	 (?\xF920 . bidi-category-l) ;; 
	 (?\xF921 . bidi-category-l) ;; 
	 (?\xF922 . bidi-category-l) ;; 
	 (?\xF923 . bidi-category-l) ;; 
	 (?\xF924 . bidi-category-l) ;; 
	 (?\xF925 . bidi-category-l) ;; 
	 (?\xF926 . bidi-category-l) ;; 
	 (?\xF927 . bidi-category-l) ;; 
	 (?\xF928 . bidi-category-l) ;; 
	 (?\xF929 . bidi-category-l) ;; 
	 (?\xF92A . bidi-category-l) ;; 
	 (?\xF92B . bidi-category-l) ;; 
	 (?\xF92C . bidi-category-l) ;; 
	 (?\xF92D . bidi-category-l) ;; 
	 (?\xF92E . bidi-category-l) ;; 
	 (?\xF92F . bidi-category-l) ;; 
	 (?\xF930 . bidi-category-l) ;; 
	 (?\xF931 . bidi-category-l) ;; 
	 (?\xF932 . bidi-category-l) ;; 
	 (?\xF933 . bidi-category-l) ;; 
	 (?\xF934 . bidi-category-l) ;; 
	 (?\xF935 . bidi-category-l) ;; 
	 (?\xF936 . bidi-category-l) ;; 
	 (?\xF937 . bidi-category-l) ;; 
	 (?\xF938 . bidi-category-l) ;; 
	 (?\xF939 . bidi-category-l) ;; 
	 (?\xF93A . bidi-category-l) ;; 
	 (?\xF93B . bidi-category-l) ;; 
	 (?\xF93C . bidi-category-l) ;; 
	 (?\xF93D . bidi-category-l) ;; 
	 (?\xF93E . bidi-category-l) ;; 
	 (?\xF93F . bidi-category-l) ;; 
	 (?\xF940 . bidi-category-l) ;; 
	 (?\xF941 . bidi-category-l) ;; 
	 (?\xF942 . bidi-category-l) ;; 
	 (?\xF943 . bidi-category-l) ;; 
	 (?\xF944 . bidi-category-l) ;; 
	 (?\xF945 . bidi-category-l) ;; 
	 (?\xF946 . bidi-category-l) ;; 
	 (?\xF947 . bidi-category-l) ;; 
	 (?\xF948 . bidi-category-l) ;; 
	 (?\xF949 . bidi-category-l) ;; 
	 (?\xF94A . bidi-category-l) ;; 
	 (?\xF94B . bidi-category-l) ;; 
	 (?\xF94C . bidi-category-l) ;; 
	 (?\xF94D . bidi-category-l) ;; 
	 (?\xF94E . bidi-category-l) ;; 
	 (?\xF94F . bidi-category-l) ;; 
	 (?\xF950 . bidi-category-l) ;; 
	 (?\xF951 . bidi-category-l) ;; 
	 (?\xF952 . bidi-category-l) ;; 
	 (?\xF953 . bidi-category-l) ;; 
	 (?\xF954 . bidi-category-l) ;; 
	 (?\xF955 . bidi-category-l) ;; 
	 (?\xF956 . bidi-category-l) ;; 
	 (?\xF957 . bidi-category-l) ;; 
	 (?\xF958 . bidi-category-l) ;; 
	 (?\xF959 . bidi-category-l) ;; 
	 (?\xF95A . bidi-category-l) ;; 
	 (?\xF95B . bidi-category-l) ;; 
	 (?\xF95C . bidi-category-l) ;; 
	 (?\xF95D . bidi-category-l) ;; 
	 (?\xF95E . bidi-category-l) ;; 
	 (?\xF95F . bidi-category-l) ;; 
	 (?\xF960 . bidi-category-l) ;; 
	 (?\xF961 . bidi-category-l) ;; 
	 (?\xF962 . bidi-category-l) ;; 
	 (?\xF963 . bidi-category-l) ;; 
	 (?\xF964 . bidi-category-l) ;; 
	 (?\xF965 . bidi-category-l) ;; 
	 (?\xF966 . bidi-category-l) ;; 
	 (?\xF967 . bidi-category-l) ;; 
	 (?\xF968 . bidi-category-l) ;; 
	 (?\xF969 . bidi-category-l) ;; 
	 (?\xF96A . bidi-category-l) ;; 
	 (?\xF96B . bidi-category-l) ;; 
	 (?\xF96C . bidi-category-l) ;; 
	 (?\xF96D . bidi-category-l) ;; 
	 (?\xF96E . bidi-category-l) ;; 
	 (?\xF96F . bidi-category-l) ;; 
	 (?\xF970 . bidi-category-l) ;; 
	 (?\xF971 . bidi-category-l) ;; 
	 (?\xF972 . bidi-category-l) ;; 
	 (?\xF973 . bidi-category-l) ;; 
	 (?\xF974 . bidi-category-l) ;; 
	 (?\xF975 . bidi-category-l) ;; 
	 (?\xF976 . bidi-category-l) ;; 
	 (?\xF977 . bidi-category-l) ;; 
	 (?\xF978 . bidi-category-l) ;; 
	 (?\xF979 . bidi-category-l) ;; 
	 (?\xF97A . bidi-category-l) ;; 
	 (?\xF97B . bidi-category-l) ;; 
	 (?\xF97C . bidi-category-l) ;; 
	 (?\xF97D . bidi-category-l) ;; 
	 (?\xF97E . bidi-category-l) ;; 
	 (?\xF97F . bidi-category-l) ;; 
	 (?\xF980 . bidi-category-l) ;; 
	 (?\xF981 . bidi-category-l) ;; 
	 (?\xF982 . bidi-category-l) ;; 
	 (?\xF983 . bidi-category-l) ;; 
	 (?\xF984 . bidi-category-l) ;; 
	 (?\xF985 . bidi-category-l) ;; 
	 (?\xF986 . bidi-category-l) ;; 
	 (?\xF987 . bidi-category-l) ;; 
	 (?\xF988 . bidi-category-l) ;; 
	 (?\xF989 . bidi-category-l) ;; 
	 (?\xF98A . bidi-category-l) ;; 
	 (?\xF98B . bidi-category-l) ;; 
	 (?\xF98C . bidi-category-l) ;; 
	 (?\xF98D . bidi-category-l) ;; 
	 (?\xF98E . bidi-category-l) ;; 
	 (?\xF98F . bidi-category-l) ;; 
	 (?\xF990 . bidi-category-l) ;; 
	 (?\xF991 . bidi-category-l) ;; 
	 (?\xF992 . bidi-category-l) ;; 
	 (?\xF993 . bidi-category-l) ;; 
	 (?\xF994 . bidi-category-l) ;; 
	 (?\xF995 . bidi-category-l) ;; 
	 (?\xF996 . bidi-category-l) ;; 
	 (?\xF997 . bidi-category-l) ;; 
	 (?\xF998 . bidi-category-l) ;; 
	 (?\xF999 . bidi-category-l) ;; 
	 (?\xF99A . bidi-category-l) ;; 
	 (?\xF99B . bidi-category-l) ;; 
	 (?\xF99C . bidi-category-l) ;; 
	 (?\xF99D . bidi-category-l) ;; 
	 (?\xF99E . bidi-category-l) ;; 
	 (?\xF99F . bidi-category-l) ;; 
	 (?\xF9A0 . bidi-category-l) ;; 
	 (?\xF9A1 . bidi-category-l) ;; 
	 (?\xF9A2 . bidi-category-l) ;; 
	 (?\xF9A3 . bidi-category-l) ;; 
	 (?\xF9A4 . bidi-category-l) ;; 
	 (?\xF9A5 . bidi-category-l) ;; 
	 (?\xF9A6 . bidi-category-l) ;; 
	 (?\xF9A7 . bidi-category-l) ;; 
	 (?\xF9A8 . bidi-category-l) ;; 
	 (?\xF9A9 . bidi-category-l) ;; 
	 (?\xF9AA . bidi-category-l) ;; 
	 (?\xF9AB . bidi-category-l) ;; 
	 (?\xF9AC . bidi-category-l) ;; 
	 (?\xF9AD . bidi-category-l) ;; 
	 (?\xF9AE . bidi-category-l) ;; 
	 (?\xF9AF . bidi-category-l) ;; 
	 (?\xF9B0 . bidi-category-l) ;; 
	 (?\xF9B1 . bidi-category-l) ;; 
	 (?\xF9B2 . bidi-category-l) ;; 
	 (?\xF9B3 . bidi-category-l) ;; 
	 (?\xF9B4 . bidi-category-l) ;; 
	 (?\xF9B5 . bidi-category-l) ;; 
	 (?\xF9B6 . bidi-category-l) ;; 
	 (?\xF9B7 . bidi-category-l) ;; 
	 (?\xF9B8 . bidi-category-l) ;; 
	 (?\xF9B9 . bidi-category-l) ;; 
	 (?\xF9BA . bidi-category-l) ;; 
	 (?\xF9BB . bidi-category-l) ;; 
	 (?\xF9BC . bidi-category-l) ;; 
	 (?\xF9BD . bidi-category-l) ;; 
	 (?\xF9BE . bidi-category-l) ;; 
	 (?\xF9BF . bidi-category-l) ;; 
	 (?\xF9C0 . bidi-category-l) ;; 
	 (?\xF9C1 . bidi-category-l) ;; 
	 (?\xF9C2 . bidi-category-l) ;; 
	 (?\xF9C3 . bidi-category-l) ;; 
	 (?\xF9C4 . bidi-category-l) ;; 
	 (?\xF9C5 . bidi-category-l) ;; 
	 (?\xF9C6 . bidi-category-l) ;; 
	 (?\xF9C7 . bidi-category-l) ;; 
	 (?\xF9C8 . bidi-category-l) ;; 
	 (?\xF9C9 . bidi-category-l) ;; 
	 (?\xF9CA . bidi-category-l) ;; 
	 (?\xF9CB . bidi-category-l) ;; 
	 (?\xF9CC . bidi-category-l) ;; 
	 (?\xF9CD . bidi-category-l) ;; 
	 (?\xF9CE . bidi-category-l) ;; 
	 (?\xF9CF . bidi-category-l) ;; 
	 (?\xF9D0 . bidi-category-l) ;; 
	 (?\xF9D1 . bidi-category-l) ;; 
	 (?\xF9D2 . bidi-category-l) ;; 
	 (?\xF9D3 . bidi-category-l) ;; 
	 (?\xF9D4 . bidi-category-l) ;; 
	 (?\xF9D5 . bidi-category-l) ;; 
	 (?\xF9D6 . bidi-category-l) ;; 
	 (?\xF9D7 . bidi-category-l) ;; 
	 (?\xF9D8 . bidi-category-l) ;; 
	 (?\xF9D9 . bidi-category-l) ;; 
	 (?\xF9DA . bidi-category-l) ;; 
	 (?\xF9DB . bidi-category-l) ;; 
	 (?\xF9DC . bidi-category-l) ;; 
	 (?\xF9DD . bidi-category-l) ;; 
	 (?\xF9DE . bidi-category-l) ;; 
	 (?\xF9DF . bidi-category-l) ;; 
	 (?\xF9E0 . bidi-category-l) ;; 
	 (?\xF9E1 . bidi-category-l) ;; 
	 (?\xF9E2 . bidi-category-l) ;; 
	 (?\xF9E3 . bidi-category-l) ;; 
	 (?\xF9E4 . bidi-category-l) ;; 
	 (?\xF9E5 . bidi-category-l) ;; 
	 (?\xF9E6 . bidi-category-l) ;; 
	 (?\xF9E7 . bidi-category-l) ;; 
	 (?\xF9E8 . bidi-category-l) ;; 
	 (?\xF9E9 . bidi-category-l) ;; 
	 (?\xF9EA . bidi-category-l) ;; 
	 (?\xF9EB . bidi-category-l) ;; 
	 (?\xF9EC . bidi-category-l) ;; 
	 (?\xF9ED . bidi-category-l) ;; 
	 (?\xF9EE . bidi-category-l) ;; 
	 (?\xF9EF . bidi-category-l) ;; 
	 (?\xF9F0 . bidi-category-l) ;; 
	 (?\xF9F1 . bidi-category-l) ;; 
	 (?\xF9F2 . bidi-category-l) ;; 
	 (?\xF9F3 . bidi-category-l) ;; 
	 (?\xF9F4 . bidi-category-l) ;; 
	 (?\xF9F5 . bidi-category-l) ;; 
	 (?\xF9F6 . bidi-category-l) ;; 
	 (?\xF9F7 . bidi-category-l) ;; 
	 (?\xF9F8 . bidi-category-l) ;; 
	 (?\xF9F9 . bidi-category-l) ;; 
	 (?\xF9FA . bidi-category-l) ;; 
	 (?\xF9FB . bidi-category-l) ;; 
	 (?\xF9FC . bidi-category-l) ;; 
	 (?\xF9FD . bidi-category-l) ;; 
	 (?\xF9FE . bidi-category-l) ;; 
	 (?\xF9FF . bidi-category-l) ;; 
	 (?\xFA00 . bidi-category-l) ;; 
	 (?\xFA01 . bidi-category-l) ;; 
	 (?\xFA02 . bidi-category-l) ;; 
	 (?\xFA03 . bidi-category-l) ;; 
	 (?\xFA04 . bidi-category-l) ;; 
	 (?\xFA05 . bidi-category-l) ;; 
	 (?\xFA06 . bidi-category-l) ;; 
	 (?\xFA07 . bidi-category-l) ;; 
	 (?\xFA08 . bidi-category-l) ;; 
	 (?\xFA09 . bidi-category-l) ;; 
	 (?\xFA0A . bidi-category-l) ;; 
	 (?\xFA0B . bidi-category-l) ;; 
	 (?\xFA0C . bidi-category-l) ;; 
	 (?\xFA0D . bidi-category-l) ;; 
	 (?\xFA0E . bidi-category-l) ;; 
	 (?\xFA0F . bidi-category-l) ;; 
	 (?\xFA10 . bidi-category-l) ;; 
	 (?\xFA11 . bidi-category-l) ;; 
	 (?\xFA12 . bidi-category-l) ;; 
	 (?\xFA13 . bidi-category-l) ;; 
	 (?\xFA14 . bidi-category-l) ;; 
	 (?\xFA15 . bidi-category-l) ;; 
	 (?\xFA16 . bidi-category-l) ;; 
	 (?\xFA17 . bidi-category-l) ;; 
	 (?\xFA18 . bidi-category-l) ;; 
	 (?\xFA19 . bidi-category-l) ;; 
	 (?\xFA1A . bidi-category-l) ;; 
	 (?\xFA1B . bidi-category-l) ;; 
	 (?\xFA1C . bidi-category-l) ;; 
	 (?\xFA1D . bidi-category-l) ;; 
	 (?\xFA1E . bidi-category-l) ;; 
	 (?\xFA1F . bidi-category-l) ;; 
	 (?\xFA20 . bidi-category-l) ;; 
	 (?\xFA21 . bidi-category-l) ;; 
	 (?\xFA22 . bidi-category-l) ;; 
	 (?\xFA23 . bidi-category-l) ;; 
	 (?\xFA24 . bidi-category-l) ;; 
	 (?\xFA25 . bidi-category-l) ;; 
	 (?\xFA26 . bidi-category-l) ;; 
	 (?\xFA27 . bidi-category-l) ;; 
	 (?\xFA28 . bidi-category-l) ;; 
	 (?\xFA29 . bidi-category-l) ;; 
	 (?\xFA2A . bidi-category-l) ;; 
	 (?\xFA2B . bidi-category-l) ;; 
	 (?\xFA2C . bidi-category-l) ;; 
	 (?\xFA2D . bidi-category-l) ;; 
	 (?\xFB00 . bidi-category-l) ;; 
	 (?\xFB01 . bidi-category-l) ;; 
	 (?\xFB02 . bidi-category-l) ;; 
	 (?\xFB03 . bidi-category-l) ;; 
	 (?\xFB04 . bidi-category-l) ;; 
	 (?\xFB05 . bidi-category-l) ;; 
	 (?\xFB06 . bidi-category-l) ;; 
	 (?\xFB13 . bidi-category-l) ;; 
	 (?\xFB14 . bidi-category-l) ;; 
	 (?\xFB15 . bidi-category-l) ;; 
	 (?\xFB16 . bidi-category-l) ;; 
	 (?\xFB17 . bidi-category-l) ;; 
	 (?\xFB1D . bidi-category-r) ;; 
	 (?\xFB1E . bidi-category-nsm) ;; HEBREW POINT VARIKA
	 (?\xFB1F . bidi-category-r) ;; 
	 (?\xFB20 . bidi-category-r) ;; 
	 (?\xFB21 . bidi-category-r) ;; 
	 (?\xFB22 . bidi-category-r) ;; 
	 (?\xFB23 . bidi-category-r) ;; 
	 (?\xFB24 . bidi-category-r) ;; 
	 (?\xFB25 . bidi-category-r) ;; 
	 (?\xFB26 . bidi-category-r) ;; 
	 (?\xFB27 . bidi-category-r) ;; 
	 (?\xFB28 . bidi-category-r) ;; 
	 (?\xFB29 . bidi-category-et) ;; 
	 (?\xFB2A . bidi-category-r) ;; 
	 (?\xFB2B . bidi-category-r) ;; 
	 (?\xFB2C . bidi-category-r) ;; 
	 (?\xFB2D . bidi-category-r) ;; 
	 (?\xFB2E . bidi-category-r) ;; 
	 (?\xFB2F . bidi-category-r) ;; 
	 (?\xFB30 . bidi-category-r) ;; 
	 (?\xFB31 . bidi-category-r) ;; 
	 (?\xFB32 . bidi-category-r) ;; 
	 (?\xFB33 . bidi-category-r) ;; 
	 (?\xFB34 . bidi-category-r) ;; 
	 (?\xFB35 . bidi-category-r) ;; 
	 (?\xFB36 . bidi-category-r) ;; 
	 (?\xFB38 . bidi-category-r) ;; 
	 (?\xFB39 . bidi-category-r) ;; 
	 (?\xFB3A . bidi-category-r) ;; 
	 (?\xFB3B . bidi-category-r) ;; 
	 (?\xFB3C . bidi-category-r) ;; 
	 (?\xFB3E . bidi-category-r) ;; 
	 (?\xFB40 . bidi-category-r) ;; 
	 (?\xFB41 . bidi-category-r) ;; 
	 (?\xFB43 . bidi-category-r) ;; 
	 (?\xFB44 . bidi-category-r) ;; 
	 (?\xFB46 . bidi-category-r) ;; 
	 (?\xFB47 . bidi-category-r) ;; 
	 (?\xFB48 . bidi-category-r) ;; 
	 (?\xFB49 . bidi-category-r) ;; 
	 (?\xFB4A . bidi-category-r) ;; 
	 (?\xFB4B . bidi-category-r) ;; 
	 (?\xFB4C . bidi-category-r) ;; 
	 (?\xFB4D . bidi-category-r) ;; 
	 (?\xFB4E . bidi-category-r) ;; 
	 (?\xFB4F . bidi-category-r) ;; 
	 (?\xFB50 . bidi-category-al) ;; 
	 (?\xFB51 . bidi-category-al) ;; 
	 (?\xFB52 . bidi-category-al) ;; 
	 (?\xFB53 . bidi-category-al) ;; 
	 (?\xFB54 . bidi-category-al) ;; 
	 (?\xFB55 . bidi-category-al) ;; 
	 (?\xFB56 . bidi-category-al) ;; 
	 (?\xFB57 . bidi-category-al) ;; 
	 (?\xFB58 . bidi-category-al) ;; 
	 (?\xFB59 . bidi-category-al) ;; 
	 (?\xFB5A . bidi-category-al) ;; 
	 (?\xFB5B . bidi-category-al) ;; 
	 (?\xFB5C . bidi-category-al) ;; 
	 (?\xFB5D . bidi-category-al) ;; 
	 (?\xFB5E . bidi-category-al) ;; 
	 (?\xFB5F . bidi-category-al) ;; 
	 (?\xFB60 . bidi-category-al) ;; 
	 (?\xFB61 . bidi-category-al) ;; 
	 (?\xFB62 . bidi-category-al) ;; 
	 (?\xFB63 . bidi-category-al) ;; 
	 (?\xFB64 . bidi-category-al) ;; 
	 (?\xFB65 . bidi-category-al) ;; 
	 (?\xFB66 . bidi-category-al) ;; 
	 (?\xFB67 . bidi-category-al) ;; 
	 (?\xFB68 . bidi-category-al) ;; 
	 (?\xFB69 . bidi-category-al) ;; 
	 (?\xFB6A . bidi-category-al) ;; 
	 (?\xFB6B . bidi-category-al) ;; 
	 (?\xFB6C . bidi-category-al) ;; 
	 (?\xFB6D . bidi-category-al) ;; 
	 (?\xFB6E . bidi-category-al) ;; 
	 (?\xFB6F . bidi-category-al) ;; 
	 (?\xFB70 . bidi-category-al) ;; 
	 (?\xFB71 . bidi-category-al) ;; 
	 (?\xFB72 . bidi-category-al) ;; 
	 (?\xFB73 . bidi-category-al) ;; 
	 (?\xFB74 . bidi-category-al) ;; 
	 (?\xFB75 . bidi-category-al) ;; 
	 (?\xFB76 . bidi-category-al) ;; 
	 (?\xFB77 . bidi-category-al) ;; 
	 (?\xFB78 . bidi-category-al) ;; 
	 (?\xFB79 . bidi-category-al) ;; 
	 (?\xFB7A . bidi-category-al) ;; 
	 (?\xFB7B . bidi-category-al) ;; 
	 (?\xFB7C . bidi-category-al) ;; 
	 (?\xFB7D . bidi-category-al) ;; 
	 (?\xFB7E . bidi-category-al) ;; 
	 (?\xFB7F . bidi-category-al) ;; 
	 (?\xFB80 . bidi-category-al) ;; 
	 (?\xFB81 . bidi-category-al) ;; 
	 (?\xFB82 . bidi-category-al) ;; 
	 (?\xFB83 . bidi-category-al) ;; 
	 (?\xFB84 . bidi-category-al) ;; 
	 (?\xFB85 . bidi-category-al) ;; 
	 (?\xFB86 . bidi-category-al) ;; 
	 (?\xFB87 . bidi-category-al) ;; 
	 (?\xFB88 . bidi-category-al) ;; 
	 (?\xFB89 . bidi-category-al) ;; 
	 (?\xFB8A . bidi-category-al) ;; 
	 (?\xFB8B . bidi-category-al) ;; 
	 (?\xFB8C . bidi-category-al) ;; 
	 (?\xFB8D . bidi-category-al) ;; 
	 (?\xFB8E . bidi-category-al) ;; 
	 (?\xFB8F . bidi-category-al) ;; 
	 (?\xFB90 . bidi-category-al) ;; 
	 (?\xFB91 . bidi-category-al) ;; 
	 (?\xFB92 . bidi-category-al) ;; 
	 (?\xFB93 . bidi-category-al) ;; 
	 (?\xFB94 . bidi-category-al) ;; 
	 (?\xFB95 . bidi-category-al) ;; 
	 (?\xFB96 . bidi-category-al) ;; 
	 (?\xFB97 . bidi-category-al) ;; 
	 (?\xFB98 . bidi-category-al) ;; 
	 (?\xFB99 . bidi-category-al) ;; 
	 (?\xFB9A . bidi-category-al) ;; 
	 (?\xFB9B . bidi-category-al) ;; 
	 (?\xFB9C . bidi-category-al) ;; 
	 (?\xFB9D . bidi-category-al) ;; 
	 (?\xFB9E . bidi-category-al) ;; 
	 (?\xFB9F . bidi-category-al) ;; 
	 (?\xFBA0 . bidi-category-al) ;; 
	 (?\xFBA1 . bidi-category-al) ;; 
	 (?\xFBA2 . bidi-category-al) ;; 
	 (?\xFBA3 . bidi-category-al) ;; 
	 (?\xFBA4 . bidi-category-al) ;; 
	 (?\xFBA5 . bidi-category-al) ;; 
	 (?\xFBA6 . bidi-category-al) ;; 
	 (?\xFBA7 . bidi-category-al) ;; 
	 (?\xFBA8 . bidi-category-al) ;; 
	 (?\xFBA9 . bidi-category-al) ;; 
	 (?\xFBAA . bidi-category-al) ;; 
	 (?\xFBAB . bidi-category-al) ;; 
	 (?\xFBAC . bidi-category-al) ;; 
	 (?\xFBAD . bidi-category-al) ;; 
	 (?\xFBAE . bidi-category-al) ;; 
	 (?\xFBAF . bidi-category-al) ;; 
	 (?\xFBB0 . bidi-category-al) ;; 
	 (?\xFBB1 . bidi-category-al) ;; 
	 (?\xFBD3 . bidi-category-al) ;; 
	 (?\xFBD4 . bidi-category-al) ;; 
	 (?\xFBD5 . bidi-category-al) ;; 
	 (?\xFBD6 . bidi-category-al) ;; 
	 (?\xFBD7 . bidi-category-al) ;; 
	 (?\xFBD8 . bidi-category-al) ;; 
	 (?\xFBD9 . bidi-category-al) ;; 
	 (?\xFBDA . bidi-category-al) ;; 
	 (?\xFBDB . bidi-category-al) ;; 
	 (?\xFBDC . bidi-category-al) ;; 
	 (?\xFBDD . bidi-category-al) ;; 
	 (?\xFBDE . bidi-category-al) ;; 
	 (?\xFBDF . bidi-category-al) ;; 
	 (?\xFBE0 . bidi-category-al) ;; 
	 (?\xFBE1 . bidi-category-al) ;; 
	 (?\xFBE2 . bidi-category-al) ;; 
	 (?\xFBE3 . bidi-category-al) ;; 
	 (?\xFBE4 . bidi-category-al) ;; 
	 (?\xFBE5 . bidi-category-al) ;; 
	 (?\xFBE6 . bidi-category-al) ;; 
	 (?\xFBE7 . bidi-category-al) ;; 
	 (?\xFBE8 . bidi-category-al) ;; 
	 (?\xFBE9 . bidi-category-al) ;; 
	 (?\xFBEA . bidi-category-al) ;; 
	 (?\xFBEB . bidi-category-al) ;; 
	 (?\xFBEC . bidi-category-al) ;; 
	 (?\xFBED . bidi-category-al) ;; 
	 (?\xFBEE . bidi-category-al) ;; 
	 (?\xFBEF . bidi-category-al) ;; 
	 (?\xFBF0 . bidi-category-al) ;; 
	 (?\xFBF1 . bidi-category-al) ;; 
	 (?\xFBF2 . bidi-category-al) ;; 
	 (?\xFBF3 . bidi-category-al) ;; 
	 (?\xFBF4 . bidi-category-al) ;; 
	 (?\xFBF5 . bidi-category-al) ;; 
	 (?\xFBF6 . bidi-category-al) ;; 
	 (?\xFBF7 . bidi-category-al) ;; 
	 (?\xFBF8 . bidi-category-al) ;; 
	 (?\xFBF9 . bidi-category-al) ;; 
	 (?\xFBFA . bidi-category-al) ;; 
	 (?\xFBFB . bidi-category-al) ;; 
	 (?\xFBFC . bidi-category-al) ;; 
	 (?\xFBFD . bidi-category-al) ;; 
	 (?\xFBFE . bidi-category-al) ;; 
	 (?\xFBFF . bidi-category-al) ;; 
	 (?\xFC00 . bidi-category-al) ;; 
	 (?\xFC01 . bidi-category-al) ;; 
	 (?\xFC02 . bidi-category-al) ;; 
	 (?\xFC03 . bidi-category-al) ;; 
	 (?\xFC04 . bidi-category-al) ;; 
	 (?\xFC05 . bidi-category-al) ;; 
	 (?\xFC06 . bidi-category-al) ;; 
	 (?\xFC07 . bidi-category-al) ;; 
	 (?\xFC08 . bidi-category-al) ;; 
	 (?\xFC09 . bidi-category-al) ;; 
	 (?\xFC0A . bidi-category-al) ;; 
	 (?\xFC0B . bidi-category-al) ;; 
	 (?\xFC0C . bidi-category-al) ;; 
	 (?\xFC0D . bidi-category-al) ;; 
	 (?\xFC0E . bidi-category-al) ;; 
	 (?\xFC0F . bidi-category-al) ;; 
	 (?\xFC10 . bidi-category-al) ;; 
	 (?\xFC11 . bidi-category-al) ;; 
	 (?\xFC12 . bidi-category-al) ;; 
	 (?\xFC13 . bidi-category-al) ;; 
	 (?\xFC14 . bidi-category-al) ;; 
	 (?\xFC15 . bidi-category-al) ;; 
	 (?\xFC16 . bidi-category-al) ;; 
	 (?\xFC17 . bidi-category-al) ;; 
	 (?\xFC18 . bidi-category-al) ;; 
	 (?\xFC19 . bidi-category-al) ;; 
	 (?\xFC1A . bidi-category-al) ;; 
	 (?\xFC1B . bidi-category-al) ;; 
	 (?\xFC1C . bidi-category-al) ;; 
	 (?\xFC1D . bidi-category-al) ;; 
	 (?\xFC1E . bidi-category-al) ;; 
	 (?\xFC1F . bidi-category-al) ;; 
	 (?\xFC20 . bidi-category-al) ;; 
	 (?\xFC21 . bidi-category-al) ;; 
	 (?\xFC22 . bidi-category-al) ;; 
	 (?\xFC23 . bidi-category-al) ;; 
	 (?\xFC24 . bidi-category-al) ;; 
	 (?\xFC25 . bidi-category-al) ;; 
	 (?\xFC26 . bidi-category-al) ;; 
	 (?\xFC27 . bidi-category-al) ;; 
	 (?\xFC28 . bidi-category-al) ;; 
	 (?\xFC29 . bidi-category-al) ;; 
	 (?\xFC2A . bidi-category-al) ;; 
	 (?\xFC2B . bidi-category-al) ;; 
	 (?\xFC2C . bidi-category-al) ;; 
	 (?\xFC2D . bidi-category-al) ;; 
	 (?\xFC2E . bidi-category-al) ;; 
	 (?\xFC2F . bidi-category-al) ;; 
	 (?\xFC30 . bidi-category-al) ;; 
	 (?\xFC31 . bidi-category-al) ;; 
	 (?\xFC32 . bidi-category-al) ;; 
	 (?\xFC33 . bidi-category-al) ;; 
	 (?\xFC34 . bidi-category-al) ;; 
	 (?\xFC35 . bidi-category-al) ;; 
	 (?\xFC36 . bidi-category-al) ;; 
	 (?\xFC37 . bidi-category-al) ;; 
	 (?\xFC38 . bidi-category-al) ;; 
	 (?\xFC39 . bidi-category-al) ;; 
	 (?\xFC3A . bidi-category-al) ;; 
	 (?\xFC3B . bidi-category-al) ;; 
	 (?\xFC3C . bidi-category-al) ;; 
	 (?\xFC3D . bidi-category-al) ;; 
	 (?\xFC3E . bidi-category-al) ;; 
	 (?\xFC3F . bidi-category-al) ;; 
	 (?\xFC40 . bidi-category-al) ;; 
	 (?\xFC41 . bidi-category-al) ;; 
	 (?\xFC42 . bidi-category-al) ;; 
	 (?\xFC43 . bidi-category-al) ;; 
	 (?\xFC44 . bidi-category-al) ;; 
	 (?\xFC45 . bidi-category-al) ;; 
	 (?\xFC46 . bidi-category-al) ;; 
	 (?\xFC47 . bidi-category-al) ;; 
	 (?\xFC48 . bidi-category-al) ;; 
	 (?\xFC49 . bidi-category-al) ;; 
	 (?\xFC4A . bidi-category-al) ;; 
	 (?\xFC4B . bidi-category-al) ;; 
	 (?\xFC4C . bidi-category-al) ;; 
	 (?\xFC4D . bidi-category-al) ;; 
	 (?\xFC4E . bidi-category-al) ;; 
	 (?\xFC4F . bidi-category-al) ;; 
	 (?\xFC50 . bidi-category-al) ;; 
	 (?\xFC51 . bidi-category-al) ;; 
	 (?\xFC52 . bidi-category-al) ;; 
	 (?\xFC53 . bidi-category-al) ;; 
	 (?\xFC54 . bidi-category-al) ;; 
	 (?\xFC55 . bidi-category-al) ;; 
	 (?\xFC56 . bidi-category-al) ;; 
	 (?\xFC57 . bidi-category-al) ;; 
	 (?\xFC58 . bidi-category-al) ;; 
	 (?\xFC59 . bidi-category-al) ;; 
	 (?\xFC5A . bidi-category-al) ;; 
	 (?\xFC5B . bidi-category-al) ;; 
	 (?\xFC5C . bidi-category-al) ;; 
	 (?\xFC5D . bidi-category-al) ;; 
	 (?\xFC5E . bidi-category-al) ;; 
	 (?\xFC5F . bidi-category-al) ;; 
	 (?\xFC60 . bidi-category-al) ;; 
	 (?\xFC61 . bidi-category-al) ;; 
	 (?\xFC62 . bidi-category-al) ;; 
	 (?\xFC63 . bidi-category-al) ;; 
	 (?\xFC64 . bidi-category-al) ;; 
	 (?\xFC65 . bidi-category-al) ;; 
	 (?\xFC66 . bidi-category-al) ;; 
	 (?\xFC67 . bidi-category-al) ;; 
	 (?\xFC68 . bidi-category-al) ;; 
	 (?\xFC69 . bidi-category-al) ;; 
	 (?\xFC6A . bidi-category-al) ;; 
	 (?\xFC6B . bidi-category-al) ;; 
	 (?\xFC6C . bidi-category-al) ;; 
	 (?\xFC6D . bidi-category-al) ;; 
	 (?\xFC6E . bidi-category-al) ;; 
	 (?\xFC6F . bidi-category-al) ;; 
	 (?\xFC70 . bidi-category-al) ;; 
	 (?\xFC71 . bidi-category-al) ;; 
	 (?\xFC72 . bidi-category-al) ;; 
	 (?\xFC73 . bidi-category-al) ;; 
	 (?\xFC74 . bidi-category-al) ;; 
	 (?\xFC75 . bidi-category-al) ;; 
	 (?\xFC76 . bidi-category-al) ;; 
	 (?\xFC77 . bidi-category-al) ;; 
	 (?\xFC78 . bidi-category-al) ;; 
	 (?\xFC79 . bidi-category-al) ;; 
	 (?\xFC7A . bidi-category-al) ;; 
	 (?\xFC7B . bidi-category-al) ;; 
	 (?\xFC7C . bidi-category-al) ;; 
	 (?\xFC7D . bidi-category-al) ;; 
	 (?\xFC7E . bidi-category-al) ;; 
	 (?\xFC7F . bidi-category-al) ;; 
	 (?\xFC80 . bidi-category-al) ;; 
	 (?\xFC81 . bidi-category-al) ;; 
	 (?\xFC82 . bidi-category-al) ;; 
	 (?\xFC83 . bidi-category-al) ;; 
	 (?\xFC84 . bidi-category-al) ;; 
	 (?\xFC85 . bidi-category-al) ;; 
	 (?\xFC86 . bidi-category-al) ;; 
	 (?\xFC87 . bidi-category-al) ;; 
	 (?\xFC88 . bidi-category-al) ;; 
	 (?\xFC89 . bidi-category-al) ;; 
	 (?\xFC8A . bidi-category-al) ;; 
	 (?\xFC8B . bidi-category-al) ;; 
	 (?\xFC8C . bidi-category-al) ;; 
	 (?\xFC8D . bidi-category-al) ;; 
	 (?\xFC8E . bidi-category-al) ;; 
	 (?\xFC8F . bidi-category-al) ;; 
	 (?\xFC90 . bidi-category-al) ;; 
	 (?\xFC91 . bidi-category-al) ;; 
	 (?\xFC92 . bidi-category-al) ;; 
	 (?\xFC93 . bidi-category-al) ;; 
	 (?\xFC94 . bidi-category-al) ;; 
	 (?\xFC95 . bidi-category-al) ;; 
	 (?\xFC96 . bidi-category-al) ;; 
	 (?\xFC97 . bidi-category-al) ;; 
	 (?\xFC98 . bidi-category-al) ;; 
	 (?\xFC99 . bidi-category-al) ;; 
	 (?\xFC9A . bidi-category-al) ;; 
	 (?\xFC9B . bidi-category-al) ;; 
	 (?\xFC9C . bidi-category-al) ;; 
	 (?\xFC9D . bidi-category-al) ;; 
	 (?\xFC9E . bidi-category-al) ;; 
	 (?\xFC9F . bidi-category-al) ;; 
	 (?\xFCA0 . bidi-category-al) ;; 
	 (?\xFCA1 . bidi-category-al) ;; 
	 (?\xFCA2 . bidi-category-al) ;; 
	 (?\xFCA3 . bidi-category-al) ;; 
	 (?\xFCA4 . bidi-category-al) ;; 
	 (?\xFCA5 . bidi-category-al) ;; 
	 (?\xFCA6 . bidi-category-al) ;; 
	 (?\xFCA7 . bidi-category-al) ;; 
	 (?\xFCA8 . bidi-category-al) ;; 
	 (?\xFCA9 . bidi-category-al) ;; 
	 (?\xFCAA . bidi-category-al) ;; 
	 (?\xFCAB . bidi-category-al) ;; 
	 (?\xFCAC . bidi-category-al) ;; 
	 (?\xFCAD . bidi-category-al) ;; 
	 (?\xFCAE . bidi-category-al) ;; 
	 (?\xFCAF . bidi-category-al) ;; 
	 (?\xFCB0 . bidi-category-al) ;; 
	 (?\xFCB1 . bidi-category-al) ;; 
	 (?\xFCB2 . bidi-category-al) ;; 
	 (?\xFCB3 . bidi-category-al) ;; 
	 (?\xFCB4 . bidi-category-al) ;; 
	 (?\xFCB5 . bidi-category-al) ;; 
	 (?\xFCB6 . bidi-category-al) ;; 
	 (?\xFCB7 . bidi-category-al) ;; 
	 (?\xFCB8 . bidi-category-al) ;; 
	 (?\xFCB9 . bidi-category-al) ;; 
	 (?\xFCBA . bidi-category-al) ;; 
	 (?\xFCBB . bidi-category-al) ;; 
	 (?\xFCBC . bidi-category-al) ;; 
	 (?\xFCBD . bidi-category-al) ;; 
	 (?\xFCBE . bidi-category-al) ;; 
	 (?\xFCBF . bidi-category-al) ;; 
	 (?\xFCC0 . bidi-category-al) ;; 
	 (?\xFCC1 . bidi-category-al) ;; 
	 (?\xFCC2 . bidi-category-al) ;; 
	 (?\xFCC3 . bidi-category-al) ;; 
	 (?\xFCC4 . bidi-category-al) ;; 
	 (?\xFCC5 . bidi-category-al) ;; 
	 (?\xFCC6 . bidi-category-al) ;; 
	 (?\xFCC7 . bidi-category-al) ;; 
	 (?\xFCC8 . bidi-category-al) ;; 
	 (?\xFCC9 . bidi-category-al) ;; 
	 (?\xFCCA . bidi-category-al) ;; 
	 (?\xFCCB . bidi-category-al) ;; 
	 (?\xFCCC . bidi-category-al) ;; 
	 (?\xFCCD . bidi-category-al) ;; 
	 (?\xFCCE . bidi-category-al) ;; 
	 (?\xFCCF . bidi-category-al) ;; 
	 (?\xFCD0 . bidi-category-al) ;; 
	 (?\xFCD1 . bidi-category-al) ;; 
	 (?\xFCD2 . bidi-category-al) ;; 
	 (?\xFCD3 . bidi-category-al) ;; 
	 (?\xFCD4 . bidi-category-al) ;; 
	 (?\xFCD5 . bidi-category-al) ;; 
	 (?\xFCD6 . bidi-category-al) ;; 
	 (?\xFCD7 . bidi-category-al) ;; 
	 (?\xFCD8 . bidi-category-al) ;; 
	 (?\xFCD9 . bidi-category-al) ;; 
	 (?\xFCDA . bidi-category-al) ;; 
	 (?\xFCDB . bidi-category-al) ;; 
	 (?\xFCDC . bidi-category-al) ;; 
	 (?\xFCDD . bidi-category-al) ;; 
	 (?\xFCDE . bidi-category-al) ;; 
	 (?\xFCDF . bidi-category-al) ;; 
	 (?\xFCE0 . bidi-category-al) ;; 
	 (?\xFCE1 . bidi-category-al) ;; 
	 (?\xFCE2 . bidi-category-al) ;; 
	 (?\xFCE3 . bidi-category-al) ;; 
	 (?\xFCE4 . bidi-category-al) ;; 
	 (?\xFCE5 . bidi-category-al) ;; 
	 (?\xFCE6 . bidi-category-al) ;; 
	 (?\xFCE7 . bidi-category-al) ;; 
	 (?\xFCE8 . bidi-category-al) ;; 
	 (?\xFCE9 . bidi-category-al) ;; 
	 (?\xFCEA . bidi-category-al) ;; 
	 (?\xFCEB . bidi-category-al) ;; 
	 (?\xFCEC . bidi-category-al) ;; 
	 (?\xFCED . bidi-category-al) ;; 
	 (?\xFCEE . bidi-category-al) ;; 
	 (?\xFCEF . bidi-category-al) ;; 
	 (?\xFCF0 . bidi-category-al) ;; 
	 (?\xFCF1 . bidi-category-al) ;; 
	 (?\xFCF2 . bidi-category-al) ;; 
	 (?\xFCF3 . bidi-category-al) ;; 
	 (?\xFCF4 . bidi-category-al) ;; 
	 (?\xFCF5 . bidi-category-al) ;; 
	 (?\xFCF6 . bidi-category-al) ;; 
	 (?\xFCF7 . bidi-category-al) ;; 
	 (?\xFCF8 . bidi-category-al) ;; 
	 (?\xFCF9 . bidi-category-al) ;; 
	 (?\xFCFA . bidi-category-al) ;; 
	 (?\xFCFB . bidi-category-al) ;; 
	 (?\xFCFC . bidi-category-al) ;; 
	 (?\xFCFD . bidi-category-al) ;; 
	 (?\xFCFE . bidi-category-al) ;; 
	 (?\xFCFF . bidi-category-al) ;; 
	 (?\xFD00 . bidi-category-al) ;; 
	 (?\xFD01 . bidi-category-al) ;; 
	 (?\xFD02 . bidi-category-al) ;; 
	 (?\xFD03 . bidi-category-al) ;; 
	 (?\xFD04 . bidi-category-al) ;; 
	 (?\xFD05 . bidi-category-al) ;; 
	 (?\xFD06 . bidi-category-al) ;; 
	 (?\xFD07 . bidi-category-al) ;; 
	 (?\xFD08 . bidi-category-al) ;; 
	 (?\xFD09 . bidi-category-al) ;; 
	 (?\xFD0A . bidi-category-al) ;; 
	 (?\xFD0B . bidi-category-al) ;; 
	 (?\xFD0C . bidi-category-al) ;; 
	 (?\xFD0D . bidi-category-al) ;; 
	 (?\xFD0E . bidi-category-al) ;; 
	 (?\xFD0F . bidi-category-al) ;; 
	 (?\xFD10 . bidi-category-al) ;; 
	 (?\xFD11 . bidi-category-al) ;; 
	 (?\xFD12 . bidi-category-al) ;; 
	 (?\xFD13 . bidi-category-al) ;; 
	 (?\xFD14 . bidi-category-al) ;; 
	 (?\xFD15 . bidi-category-al) ;; 
	 (?\xFD16 . bidi-category-al) ;; 
	 (?\xFD17 . bidi-category-al) ;; 
	 (?\xFD18 . bidi-category-al) ;; 
	 (?\xFD19 . bidi-category-al) ;; 
	 (?\xFD1A . bidi-category-al) ;; 
	 (?\xFD1B . bidi-category-al) ;; 
	 (?\xFD1C . bidi-category-al) ;; 
	 (?\xFD1D . bidi-category-al) ;; 
	 (?\xFD1E . bidi-category-al) ;; 
	 (?\xFD1F . bidi-category-al) ;; 
	 (?\xFD20 . bidi-category-al) ;; 
	 (?\xFD21 . bidi-category-al) ;; 
	 (?\xFD22 . bidi-category-al) ;; 
	 (?\xFD23 . bidi-category-al) ;; 
	 (?\xFD24 . bidi-category-al) ;; 
	 (?\xFD25 . bidi-category-al) ;; 
	 (?\xFD26 . bidi-category-al) ;; 
	 (?\xFD27 . bidi-category-al) ;; 
	 (?\xFD28 . bidi-category-al) ;; 
	 (?\xFD29 . bidi-category-al) ;; 
	 (?\xFD2A . bidi-category-al) ;; 
	 (?\xFD2B . bidi-category-al) ;; 
	 (?\xFD2C . bidi-category-al) ;; 
	 (?\xFD2D . bidi-category-al) ;; 
	 (?\xFD2E . bidi-category-al) ;; 
	 (?\xFD2F . bidi-category-al) ;; 
	 (?\xFD30 . bidi-category-al) ;; 
	 (?\xFD31 . bidi-category-al) ;; 
	 (?\xFD32 . bidi-category-al) ;; 
	 (?\xFD33 . bidi-category-al) ;; 
	 (?\xFD34 . bidi-category-al) ;; 
	 (?\xFD35 . bidi-category-al) ;; 
	 (?\xFD36 . bidi-category-al) ;; 
	 (?\xFD37 . bidi-category-al) ;; 
	 (?\xFD38 . bidi-category-al) ;; 
	 (?\xFD39 . bidi-category-al) ;; 
	 (?\xFD3A . bidi-category-al) ;; 
	 (?\xFD3B . bidi-category-al) ;; 
	 (?\xFD3C . bidi-category-al) ;; 
	 (?\xFD3D . bidi-category-al) ;; 
	 (?\xFD3E . bidi-category-on) ;; 
	 (?\xFD3F . bidi-category-on) ;; 
	 (?\xFD50 . bidi-category-al) ;; 
	 (?\xFD51 . bidi-category-al) ;; 
	 (?\xFD52 . bidi-category-al) ;; 
	 (?\xFD53 . bidi-category-al) ;; 
	 (?\xFD54 . bidi-category-al) ;; 
	 (?\xFD55 . bidi-category-al) ;; 
	 (?\xFD56 . bidi-category-al) ;; 
	 (?\xFD57 . bidi-category-al) ;; 
	 (?\xFD58 . bidi-category-al) ;; 
	 (?\xFD59 . bidi-category-al) ;; 
	 (?\xFD5A . bidi-category-al) ;; 
	 (?\xFD5B . bidi-category-al) ;; 
	 (?\xFD5C . bidi-category-al) ;; 
	 (?\xFD5D . bidi-category-al) ;; 
	 (?\xFD5E . bidi-category-al) ;; 
	 (?\xFD5F . bidi-category-al) ;; 
	 (?\xFD60 . bidi-category-al) ;; 
	 (?\xFD61 . bidi-category-al) ;; 
	 (?\xFD62 . bidi-category-al) ;; 
	 (?\xFD63 . bidi-category-al) ;; 
	 (?\xFD64 . bidi-category-al) ;; 
	 (?\xFD65 . bidi-category-al) ;; 
	 (?\xFD66 . bidi-category-al) ;; 
	 (?\xFD67 . bidi-category-al) ;; 
	 (?\xFD68 . bidi-category-al) ;; 
	 (?\xFD69 . bidi-category-al) ;; 
	 (?\xFD6A . bidi-category-al) ;; 
	 (?\xFD6B . bidi-category-al) ;; 
	 (?\xFD6C . bidi-category-al) ;; 
	 (?\xFD6D . bidi-category-al) ;; 
	 (?\xFD6E . bidi-category-al) ;; 
	 (?\xFD6F . bidi-category-al) ;; 
	 (?\xFD70 . bidi-category-al) ;; 
	 (?\xFD71 . bidi-category-al) ;; 
	 (?\xFD72 . bidi-category-al) ;; 
	 (?\xFD73 . bidi-category-al) ;; 
	 (?\xFD74 . bidi-category-al) ;; 
	 (?\xFD75 . bidi-category-al) ;; 
	 (?\xFD76 . bidi-category-al) ;; 
	 (?\xFD77 . bidi-category-al) ;; 
	 (?\xFD78 . bidi-category-al) ;; 
	 (?\xFD79 . bidi-category-al) ;; 
	 (?\xFD7A . bidi-category-al) ;; 
	 (?\xFD7B . bidi-category-al) ;; 
	 (?\xFD7C . bidi-category-al) ;; 
	 (?\xFD7D . bidi-category-al) ;; 
	 (?\xFD7E . bidi-category-al) ;; 
	 (?\xFD7F . bidi-category-al) ;; 
	 (?\xFD80 . bidi-category-al) ;; 
	 (?\xFD81 . bidi-category-al) ;; 
	 (?\xFD82 . bidi-category-al) ;; 
	 (?\xFD83 . bidi-category-al) ;; 
	 (?\xFD84 . bidi-category-al) ;; 
	 (?\xFD85 . bidi-category-al) ;; 
	 (?\xFD86 . bidi-category-al) ;; 
	 (?\xFD87 . bidi-category-al) ;; 
	 (?\xFD88 . bidi-category-al) ;; 
	 (?\xFD89 . bidi-category-al) ;; 
	 (?\xFD8A . bidi-category-al) ;; 
	 (?\xFD8B . bidi-category-al) ;; 
	 (?\xFD8C . bidi-category-al) ;; 
	 (?\xFD8D . bidi-category-al) ;; 
	 (?\xFD8E . bidi-category-al) ;; 
	 (?\xFD8F . bidi-category-al) ;; 
	 (?\xFD92 . bidi-category-al) ;; 
	 (?\xFD93 . bidi-category-al) ;; 
	 (?\xFD94 . bidi-category-al) ;; 
	 (?\xFD95 . bidi-category-al) ;; 
	 (?\xFD96 . bidi-category-al) ;; 
	 (?\xFD97 . bidi-category-al) ;; 
	 (?\xFD98 . bidi-category-al) ;; 
	 (?\xFD99 . bidi-category-al) ;; 
	 (?\xFD9A . bidi-category-al) ;; 
	 (?\xFD9B . bidi-category-al) ;; 
	 (?\xFD9C . bidi-category-al) ;; 
	 (?\xFD9D . bidi-category-al) ;; 
	 (?\xFD9E . bidi-category-al) ;; 
	 (?\xFD9F . bidi-category-al) ;; 
	 (?\xFDA0 . bidi-category-al) ;; 
	 (?\xFDA1 . bidi-category-al) ;; 
	 (?\xFDA2 . bidi-category-al) ;; 
	 (?\xFDA3 . bidi-category-al) ;; 
	 (?\xFDA4 . bidi-category-al) ;; 
	 (?\xFDA5 . bidi-category-al) ;; 
	 (?\xFDA6 . bidi-category-al) ;; 
	 (?\xFDA7 . bidi-category-al) ;; 
	 (?\xFDA8 . bidi-category-al) ;; 
	 (?\xFDA9 . bidi-category-al) ;; 
	 (?\xFDAA . bidi-category-al) ;; 
	 (?\xFDAB . bidi-category-al) ;; 
	 (?\xFDAC . bidi-category-al) ;; 
	 (?\xFDAD . bidi-category-al) ;; 
	 (?\xFDAE . bidi-category-al) ;; 
	 (?\xFDAF . bidi-category-al) ;; 
	 (?\xFDB0 . bidi-category-al) ;; 
	 (?\xFDB1 . bidi-category-al) ;; 
	 (?\xFDB2 . bidi-category-al) ;; 
	 (?\xFDB3 . bidi-category-al) ;; 
	 (?\xFDB4 . bidi-category-al) ;; 
	 (?\xFDB5 . bidi-category-al) ;; 
	 (?\xFDB6 . bidi-category-al) ;; 
	 (?\xFDB7 . bidi-category-al) ;; 
	 (?\xFDB8 . bidi-category-al) ;; 
	 (?\xFDB9 . bidi-category-al) ;; 
	 (?\xFDBA . bidi-category-al) ;; 
	 (?\xFDBB . bidi-category-al) ;; 
	 (?\xFDBC . bidi-category-al) ;; 
	 (?\xFDBD . bidi-category-al) ;; 
	 (?\xFDBE . bidi-category-al) ;; 
	 (?\xFDBF . bidi-category-al) ;; 
	 (?\xFDC0 . bidi-category-al) ;; 
	 (?\xFDC1 . bidi-category-al) ;; 
	 (?\xFDC2 . bidi-category-al) ;; 
	 (?\xFDC3 . bidi-category-al) ;; 
	 (?\xFDC4 . bidi-category-al) ;; 
	 (?\xFDC5 . bidi-category-al) ;; 
	 (?\xFDC6 . bidi-category-al) ;; 
	 (?\xFDC7 . bidi-category-al) ;; 
	 (?\xFDF0 . bidi-category-al) ;; 
	 (?\xFDF1 . bidi-category-al) ;; 
	 (?\xFDF2 . bidi-category-al) ;; 
	 (?\xFDF3 . bidi-category-al) ;; 
	 (?\xFDF4 . bidi-category-al) ;; 
	 (?\xFDF5 . bidi-category-al) ;; 
	 (?\xFDF6 . bidi-category-al) ;; 
	 (?\xFDF7 . bidi-category-al) ;; 
	 (?\xFDF8 . bidi-category-al) ;; 
	 (?\xFDF9 . bidi-category-al) ;; 
	 (?\xFDFA . bidi-category-al) ;; ARABIC LETTER SALLALLAHOU ALAYHE WASALLAM
	 (?\xFDFB . bidi-category-al) ;; ARABIC LETTER JALLAJALALOUHOU
	 (?\xFE20 . bidi-category-nsm) ;; 
	 (?\xFE21 . bidi-category-nsm) ;; 
	 (?\xFE22 . bidi-category-nsm) ;; 
	 (?\xFE23 . bidi-category-nsm) ;; 
	 (?\xFE30 . bidi-category-on) ;; GLYPH FOR VERTICAL TWO DOT LEADER
	 (?\xFE31 . bidi-category-on) ;; GLYPH FOR VERTICAL EM DASH
	 (?\xFE32 . bidi-category-on) ;; GLYPH FOR VERTICAL EN DASH
	 (?\xFE33 . bidi-category-on) ;; GLYPH FOR VERTICAL SPACING UNDERSCORE
	 (?\xFE34 . bidi-category-on) ;; GLYPH FOR VERTICAL SPACING WAVY UNDERSCORE
	 (?\xFE35 . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING PARENTHESIS
	 (?\xFE36 . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING PARENTHESIS
	 (?\xFE37 . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING CURLY BRACKET
	 (?\xFE38 . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING CURLY BRACKET
	 (?\xFE39 . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING TORTOISE SHELL BRACKET
	 (?\xFE3A . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING TORTOISE SHELL BRACKET
	 (?\xFE3B . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING BLACK LENTICULAR BRACKET
	 (?\xFE3C . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING BLACK LENTICULAR BRACKET
	 (?\xFE3D . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING DOUBLE ANGLE BRACKET
	 (?\xFE3E . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING DOUBLE ANGLE BRACKET
	 (?\xFE3F . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING ANGLE BRACKET
	 (?\xFE40 . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING ANGLE BRACKET
	 (?\xFE41 . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING CORNER BRACKET
	 (?\xFE42 . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING CORNER BRACKET
	 (?\xFE43 . bidi-category-on) ;; GLYPH FOR VERTICAL OPENING WHITE CORNER BRACKET
	 (?\xFE44 . bidi-category-on) ;; GLYPH FOR VERTICAL CLOSING WHITE CORNER BRACKET
	 (?\xFE49 . bidi-category-on) ;; SPACING DASHED OVERSCORE
	 (?\xFE4A . bidi-category-on) ;; SPACING CENTERLINE OVERSCORE
	 (?\xFE4B . bidi-category-on) ;; SPACING WAVY OVERSCORE
	 (?\xFE4C . bidi-category-on) ;; SPACING DOUBLE WAVY OVERSCORE
	 (?\xFE4D . bidi-category-on) ;; SPACING DASHED UNDERSCORE
	 (?\xFE4E . bidi-category-on) ;; SPACING CENTERLINE UNDERSCORE
	 (?\xFE4F . bidi-category-on) ;; SPACING WAVY UNDERSCORE
	 (?\xFE50 . bidi-category-cs) ;; 
	 (?\xFE51 . bidi-category-on) ;; 
	 (?\xFE52 . bidi-category-cs) ;; SMALL PERIOD
	 (?\xFE54 . bidi-category-on) ;; 
	 (?\xFE55 . bidi-category-cs) ;; 
	 (?\xFE56 . bidi-category-on) ;; 
	 (?\xFE57 . bidi-category-on) ;; 
	 (?\xFE58 . bidi-category-on) ;; 
	 (?\xFE59 . bidi-category-on) ;; SMALL OPENING PARENTHESIS
	 (?\xFE5A . bidi-category-on) ;; SMALL CLOSING PARENTHESIS
	 (?\xFE5B . bidi-category-on) ;; SMALL OPENING CURLY BRACKET
	 (?\xFE5C . bidi-category-on) ;; SMALL CLOSING CURLY BRACKET
	 (?\xFE5D . bidi-category-on) ;; SMALL OPENING TORTOISE SHELL BRACKET
	 (?\xFE5E . bidi-category-on) ;; SMALL CLOSING TORTOISE SHELL BRACKET
	 (?\xFE5F . bidi-category-et) ;; 
	 (?\xFE60 . bidi-category-on) ;; 
	 (?\xFE61 . bidi-category-on) ;; 
	 (?\xFE62 . bidi-category-et) ;; 
	 (?\xFE63 . bidi-category-et) ;; 
	 (?\xFE64 . bidi-category-on) ;; 
	 (?\xFE65 . bidi-category-on) ;; 
	 (?\xFE66 . bidi-category-on) ;; 
	 (?\xFE68 . bidi-category-on) ;; SMALL BACKSLASH
	 (?\xFE69 . bidi-category-et) ;; 
	 (?\xFE6A . bidi-category-et) ;; 
	 (?\xFE6B . bidi-category-on) ;; 
	 (?\xFE70 . bidi-category-al) ;; ARABIC SPACING FATHATAN
	 (?\xFE71 . bidi-category-al) ;; ARABIC FATHATAN ON TATWEEL
	 (?\xFE72 . bidi-category-al) ;; ARABIC SPACING DAMMATAN
	 (?\xFE74 . bidi-category-al) ;; ARABIC SPACING KASRATAN
	 (?\xFE76 . bidi-category-al) ;; ARABIC SPACING FATHAH
	 (?\xFE77 . bidi-category-al) ;; ARABIC FATHAH ON TATWEEL
	 (?\xFE78 . bidi-category-al) ;; ARABIC SPACING DAMMAH
	 (?\xFE79 . bidi-category-al) ;; ARABIC DAMMAH ON TATWEEL
	 (?\xFE7A . bidi-category-al) ;; ARABIC SPACING KASRAH
	 (?\xFE7B . bidi-category-al) ;; ARABIC KASRAH ON TATWEEL
	 (?\xFE7C . bidi-category-al) ;; ARABIC SPACING SHADDAH
	 (?\xFE7D . bidi-category-al) ;; ARABIC SHADDAH ON TATWEEL
	 (?\xFE7E . bidi-category-al) ;; ARABIC SPACING SUKUN
	 (?\xFE7F . bidi-category-al) ;; ARABIC SUKUN ON TATWEEL
	 (?\xFE80 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH
	 (?\xFE81 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC MADDAH ON ALEF
	 (?\xFE82 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC MADDAH ON ALEF
	 (?\xFE83 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH ON ALEF
	 (?\xFE84 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH ON ALEF
	 (?\xFE85 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH ON WAW
	 (?\xFE86 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH ON WAW
	 (?\xFE87 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH UNDER ALEF
	 (?\xFE88 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH UNDER ALEF
	 (?\xFE89 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH ON YA
	 (?\xFE8A . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH ON YA
	 (?\xFE8B . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC HAMZAH ON YA
	 (?\xFE8C . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC HAMZAH ON YA
	 (?\xFE8D . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC ALEF
	 (?\xFE8E . bidi-category-al) ;; GLYPH FOR FINAL ARABIC ALEF
	 (?\xFE8F . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC BAA
	 (?\xFE90 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC BAA
	 (?\xFE91 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC BAA
	 (?\xFE92 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC BAA
	 (?\xFE93 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC TAA MARBUTAH
	 (?\xFE94 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC TAA MARBUTAH
	 (?\xFE95 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC TAA
	 (?\xFE96 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC TAA
	 (?\xFE97 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC TAA
	 (?\xFE98 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC TAA
	 (?\xFE99 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC THAA
	 (?\xFE9A . bidi-category-al) ;; GLYPH FOR FINAL ARABIC THAA
	 (?\xFE9B . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC THAA
	 (?\xFE9C . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC THAA
	 (?\xFE9D . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC JEEM
	 (?\xFE9E . bidi-category-al) ;; GLYPH FOR FINAL ARABIC JEEM
	 (?\xFE9F . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC JEEM
	 (?\xFEA0 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC JEEM
	 (?\xFEA1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAA
	 (?\xFEA2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAA
	 (?\xFEA3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC HAA
	 (?\xFEA4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC HAA
	 (?\xFEA5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC KHAA
	 (?\xFEA6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC KHAA
	 (?\xFEA7 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC KHAA
	 (?\xFEA8 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC KHAA
	 (?\xFEA9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC DAL
	 (?\xFEAA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC DAL
	 (?\xFEAB . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC THAL
	 (?\xFEAC . bidi-category-al) ;; GLYPH FOR FINAL ARABIC THAL
	 (?\xFEAD . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC RA
	 (?\xFEAE . bidi-category-al) ;; GLYPH FOR FINAL ARABIC RA
	 (?\xFEAF . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC ZAIN
	 (?\xFEB0 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC ZAIN
	 (?\xFEB1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC SEEN
	 (?\xFEB2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC SEEN
	 (?\xFEB3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC SEEN
	 (?\xFEB4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC SEEN
	 (?\xFEB5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC SHEEN
	 (?\xFEB6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC SHEEN
	 (?\xFEB7 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC SHEEN
	 (?\xFEB8 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC SHEEN
	 (?\xFEB9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC SAD
	 (?\xFEBA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC SAD
	 (?\xFEBB . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC SAD
	 (?\xFEBC . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC SAD
	 (?\xFEBD . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC DAD
	 (?\xFEBE . bidi-category-al) ;; GLYPH FOR FINAL ARABIC DAD
	 (?\xFEBF . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC DAD
	 (?\xFEC0 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC DAD
	 (?\xFEC1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC TAH
	 (?\xFEC2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC TAH
	 (?\xFEC3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC TAH
	 (?\xFEC4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC TAH
	 (?\xFEC5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC DHAH
	 (?\xFEC6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC DHAH
	 (?\xFEC7 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC DHAH
	 (?\xFEC8 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC DHAH
	 (?\xFEC9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC AIN
	 (?\xFECA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC AIN
	 (?\xFECB . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC AIN
	 (?\xFECC . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC AIN
	 (?\xFECD . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC GHAIN
	 (?\xFECE . bidi-category-al) ;; GLYPH FOR FINAL ARABIC GHAIN
	 (?\xFECF . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC GHAIN
	 (?\xFED0 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC GHAIN
	 (?\xFED1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC FA
	 (?\xFED2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC FA
	 (?\xFED3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC FA
	 (?\xFED4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC FA
	 (?\xFED5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC QAF
	 (?\xFED6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC QAF
	 (?\xFED7 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC QAF
	 (?\xFED8 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC QAF
	 (?\xFED9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC CAF
	 (?\xFEDA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC CAF
	 (?\xFEDB . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC CAF
	 (?\xFEDC . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC CAF
	 (?\xFEDD . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC LAM
	 (?\xFEDE . bidi-category-al) ;; GLYPH FOR FINAL ARABIC LAM
	 (?\xFEDF . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC LAM
	 (?\xFEE0 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC LAM
	 (?\xFEE1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC MEEM
	 (?\xFEE2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC MEEM
	 (?\xFEE3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC MEEM
	 (?\xFEE4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC MEEM
	 (?\xFEE5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC NOON
	 (?\xFEE6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC NOON
	 (?\xFEE7 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC NOON
	 (?\xFEE8 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC NOON
	 (?\xFEE9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HA
	 (?\xFEEA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HA
	 (?\xFEEB . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC HA
	 (?\xFEEC . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC HA
	 (?\xFEED . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC WAW
	 (?\xFEEE . bidi-category-al) ;; GLYPH FOR FINAL ARABIC WAW
	 (?\xFEEF . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC ALEF MAQSURAH
	 (?\xFEF0 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC ALEF MAQSURAH
	 (?\xFEF1 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC YA
	 (?\xFEF2 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC YA
	 (?\xFEF3 . bidi-category-al) ;; GLYPH FOR INITIAL ARABIC YA
	 (?\xFEF4 . bidi-category-al) ;; GLYPH FOR MEDIAL ARABIC YA
	 (?\xFEF5 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC MADDAH ON LIGATURE LAM ALEF
	 (?\xFEF6 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC MADDAH ON LIGATURE LAM ALEF
	 (?\xFEF7 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH ON LIGATURE LAM ALEF
	 (?\xFEF8 . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH ON LIGATURE LAM ALEF
	 (?\xFEF9 . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC HAMZAH UNDER LIGATURE LAM ALEF
	 (?\xFEFA . bidi-category-al) ;; GLYPH FOR FINAL ARABIC HAMZAH UNDER LIGATURE LAM ALEF
	 (?\xFEFB . bidi-category-al) ;; GLYPH FOR ISOLATE ARABIC LIGATURE LAM ALEF
	 (?\xFEFC . bidi-category-al) ;; GLYPH FOR FINAL ARABIC LIGATURE LAM ALEF
	 (?\xFEFF . bidi-category-bn) ;; BYTE ORDER MARK
	 (?\xFF01 . bidi-category-on) ;; 
	 (?\xFF02 . bidi-category-on) ;; 
	 (?\xFF03 . bidi-category-et) ;; 
	 (?\xFF04 . bidi-category-et) ;; 
	 (?\xFF05 . bidi-category-et) ;; 
	 (?\xFF06 . bidi-category-on) ;; 
	 (?\xFF07 . bidi-category-on) ;; 
	 (?\xFF08 . bidi-category-on) ;; FULLWIDTH OPENING PARENTHESIS
	 (?\xFF09 . bidi-category-on) ;; FULLWIDTH CLOSING PARENTHESIS
	 (?\xFF0A . bidi-category-on) ;; 
	 (?\xFF0B . bidi-category-et) ;; 
	 (?\xFF0C . bidi-category-cs) ;; 
	 (?\xFF0D . bidi-category-et) ;; 
	 (?\xFF0E . bidi-category-cs) ;; FULLWIDTH PERIOD
	 (?\xFF0F . bidi-category-es) ;; FULLWIDTH SLASH
	 (?\xFF10 . bidi-category-en) ;; 
	 (?\xFF11 . bidi-category-en) ;; 
	 (?\xFF12 . bidi-category-en) ;; 
	 (?\xFF13 . bidi-category-en) ;; 
	 (?\xFF14 . bidi-category-en) ;; 
	 (?\xFF15 . bidi-category-en) ;; 
	 (?\xFF16 . bidi-category-en) ;; 
	 (?\xFF17 . bidi-category-en) ;; 
	 (?\xFF18 . bidi-category-en) ;; 
	 (?\xFF19 . bidi-category-en) ;; 
	 (?\xFF1A . bidi-category-cs) ;; 
	 (?\xFF1B . bidi-category-on) ;; 
	 (?\xFF1C . bidi-category-on) ;; 
	 (?\xFF1D . bidi-category-on) ;; 
	 (?\xFF1E . bidi-category-on) ;; 
	 (?\xFF1F . bidi-category-on) ;; 
	 (?\xFF20 . bidi-category-on) ;; 
	 (?\xFF21 . bidi-category-l) ;; 
	 (?\xFF22 . bidi-category-l) ;; 
	 (?\xFF23 . bidi-category-l) ;; 
	 (?\xFF24 . bidi-category-l) ;; 
	 (?\xFF25 . bidi-category-l) ;; 
	 (?\xFF26 . bidi-category-l) ;; 
	 (?\xFF27 . bidi-category-l) ;; 
	 (?\xFF28 . bidi-category-l) ;; 
	 (?\xFF29 . bidi-category-l) ;; 
	 (?\xFF2A . bidi-category-l) ;; 
	 (?\xFF2B . bidi-category-l) ;; 
	 (?\xFF2C . bidi-category-l) ;; 
	 (?\xFF2D . bidi-category-l) ;; 
	 (?\xFF2E . bidi-category-l) ;; 
	 (?\xFF2F . bidi-category-l) ;; 
	 (?\xFF30 . bidi-category-l) ;; 
	 (?\xFF31 . bidi-category-l) ;; 
	 (?\xFF32 . bidi-category-l) ;; 
	 (?\xFF33 . bidi-category-l) ;; 
	 (?\xFF34 . bidi-category-l) ;; 
	 (?\xFF35 . bidi-category-l) ;; 
	 (?\xFF36 . bidi-category-l) ;; 
	 (?\xFF37 . bidi-category-l) ;; 
	 (?\xFF38 . bidi-category-l) ;; 
	 (?\xFF39 . bidi-category-l) ;; 
	 (?\xFF3A . bidi-category-l) ;; 
	 (?\xFF3B . bidi-category-on) ;; FULLWIDTH OPENING SQUARE BRACKET
	 (?\xFF3C . bidi-category-on) ;; FULLWIDTH BACKSLASH
	 (?\xFF3D . bidi-category-on) ;; FULLWIDTH CLOSING SQUARE BRACKET
	 (?\xFF3E . bidi-category-on) ;; FULLWIDTH SPACING CIRCUMFLEX
	 (?\xFF3F . bidi-category-on) ;; FULLWIDTH SPACING UNDERSCORE
	 (?\xFF40 . bidi-category-on) ;; FULLWIDTH SPACING GRAVE
	 (?\xFF41 . bidi-category-l) ;; 
	 (?\xFF42 . bidi-category-l) ;; 
	 (?\xFF43 . bidi-category-l) ;; 
	 (?\xFF44 . bidi-category-l) ;; 
	 (?\xFF45 . bidi-category-l) ;; 
	 (?\xFF46 . bidi-category-l) ;; 
	 (?\xFF47 . bidi-category-l) ;; 
	 (?\xFF48 . bidi-category-l) ;; 
	 (?\xFF49 . bidi-category-l) ;; 
	 (?\xFF4A . bidi-category-l) ;; 
	 (?\xFF4B . bidi-category-l) ;; 
	 (?\xFF4C . bidi-category-l) ;; 
	 (?\xFF4D . bidi-category-l) ;; 
	 (?\xFF4E . bidi-category-l) ;; 
	 (?\xFF4F . bidi-category-l) ;; 
	 (?\xFF50 . bidi-category-l) ;; 
	 (?\xFF51 . bidi-category-l) ;; 
	 (?\xFF52 . bidi-category-l) ;; 
	 (?\xFF53 . bidi-category-l) ;; 
	 (?\xFF54 . bidi-category-l) ;; 
	 (?\xFF55 . bidi-category-l) ;; 
	 (?\xFF56 . bidi-category-l) ;; 
	 (?\xFF57 . bidi-category-l) ;; 
	 (?\xFF58 . bidi-category-l) ;; 
	 (?\xFF59 . bidi-category-l) ;; 
	 (?\xFF5A . bidi-category-l) ;; 
	 (?\xFF5B . bidi-category-on) ;; FULLWIDTH OPENING CURLY BRACKET
	 (?\xFF5C . bidi-category-on) ;; FULLWIDTH VERTICAL BAR
	 (?\xFF5D . bidi-category-on) ;; FULLWIDTH CLOSING CURLY BRACKET
	 (?\xFF5E . bidi-category-on) ;; FULLWIDTH SPACING TILDE
	 (?\xFF61 . bidi-category-on) ;; HALFWIDTH IDEOGRAPHIC PERIOD
	 (?\xFF62 . bidi-category-on) ;; HALFWIDTH OPENING CORNER BRACKET
	 (?\xFF63 . bidi-category-on) ;; HALFWIDTH CLOSING CORNER BRACKET
	 (?\xFF64 . bidi-category-on) ;; 
	 (?\xFF65 . bidi-category-on) ;; 
	 (?\xFF66 . bidi-category-l) ;; 
	 (?\xFF67 . bidi-category-l) ;; 
	 (?\xFF68 . bidi-category-l) ;; 
	 (?\xFF69 . bidi-category-l) ;; 
	 (?\xFF6A . bidi-category-l) ;; 
	 (?\xFF6B . bidi-category-l) ;; 
	 (?\xFF6C . bidi-category-l) ;; 
	 (?\xFF6D . bidi-category-l) ;; 
	 (?\xFF6E . bidi-category-l) ;; 
	 (?\xFF6F . bidi-category-l) ;; 
	 (?\xFF70 . bidi-category-l) ;; 
	 (?\xFF71 . bidi-category-l) ;; 
	 (?\xFF72 . bidi-category-l) ;; 
	 (?\xFF73 . bidi-category-l) ;; 
	 (?\xFF74 . bidi-category-l) ;; 
	 (?\xFF75 . bidi-category-l) ;; 
	 (?\xFF76 . bidi-category-l) ;; 
	 (?\xFF77 . bidi-category-l) ;; 
	 (?\xFF78 . bidi-category-l) ;; 
	 (?\xFF79 . bidi-category-l) ;; 
	 (?\xFF7A . bidi-category-l) ;; 
	 (?\xFF7B . bidi-category-l) ;; 
	 (?\xFF7C . bidi-category-l) ;; 
	 (?\xFF7D . bidi-category-l) ;; 
	 (?\xFF7E . bidi-category-l) ;; 
	 (?\xFF7F . bidi-category-l) ;; 
	 (?\xFF80 . bidi-category-l) ;; 
	 (?\xFF81 . bidi-category-l) ;; 
	 (?\xFF82 . bidi-category-l) ;; 
	 (?\xFF83 . bidi-category-l) ;; 
	 (?\xFF84 . bidi-category-l) ;; 
	 (?\xFF85 . bidi-category-l) ;; 
	 (?\xFF86 . bidi-category-l) ;; 
	 (?\xFF87 . bidi-category-l) ;; 
	 (?\xFF88 . bidi-category-l) ;; 
	 (?\xFF89 . bidi-category-l) ;; 
	 (?\xFF8A . bidi-category-l) ;; 
	 (?\xFF8B . bidi-category-l) ;; 
	 (?\xFF8C . bidi-category-l) ;; 
	 (?\xFF8D . bidi-category-l) ;; 
	 (?\xFF8E . bidi-category-l) ;; 
	 (?\xFF8F . bidi-category-l) ;; 
	 (?\xFF90 . bidi-category-l) ;; 
	 (?\xFF91 . bidi-category-l) ;; 
	 (?\xFF92 . bidi-category-l) ;; 
	 (?\xFF93 . bidi-category-l) ;; 
	 (?\xFF94 . bidi-category-l) ;; 
	 (?\xFF95 . bidi-category-l) ;; 
	 (?\xFF96 . bidi-category-l) ;; 
	 (?\xFF97 . bidi-category-l) ;; 
	 (?\xFF98 . bidi-category-l) ;; 
	 (?\xFF99 . bidi-category-l) ;; 
	 (?\xFF9A . bidi-category-l) ;; 
	 (?\xFF9B . bidi-category-l) ;; 
	 (?\xFF9C . bidi-category-l) ;; 
	 (?\xFF9D . bidi-category-l) ;; 
	 (?\xFF9E . bidi-category-l) ;; 
	 (?\xFF9F . bidi-category-l) ;; 
	 (?\xFFA0 . bidi-category-l) ;; HALFWIDTH HANGUL CAE OM
	 (?\xFFA1 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER GIYEOG
	 (?\xFFA2 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER SSANG GIYEOG
	 (?\xFFA3 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER GIYEOG SIOS
	 (?\xFFA4 . bidi-category-l) ;; 
	 (?\xFFA5 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER NIEUN JIEUJ
	 (?\xFFA6 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER NIEUN HIEUH
	 (?\xFFA7 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER DIGEUD
	 (?\xFFA8 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER SSANG DIGEUD
	 (?\xFFA9 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL
	 (?\xFFAA . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL GIYEOG
	 (?\xFFAB . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL MIEUM
	 (?\xFFAC . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL BIEUB
	 (?\xFFAD . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL SIOS
	 (?\xFFAE . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL TIEUT
	 (?\xFFAF . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL PIEUP
	 (?\xFFB0 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER LIEUL HIEUH
	 (?\xFFB1 . bidi-category-l) ;; 
	 (?\xFFB2 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER BIEUB
	 (?\xFFB3 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER SSANG BIEUB
	 (?\xFFB4 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER BIEUB SIOS
	 (?\xFFB5 . bidi-category-l) ;; 
	 (?\xFFB6 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER SSANG SIOS
	 (?\xFFB7 . bidi-category-l) ;; 
	 (?\xFFB8 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER JIEUJ
	 (?\xFFB9 . bidi-category-l) ;; HALFWIDTH HANGUL LETTER SSANG JIEUJ
	 (?\xFFBA . bidi-category-l) ;; HALFWIDTH HANGUL LETTER CIEUC
	 (?\xFFBB . bidi-category-l) ;; HALFWIDTH HANGUL LETTER KIYEOK
	 (?\xFFBC . bidi-category-l) ;; HALFWIDTH HANGUL LETTER TIEUT
	 (?\xFFBD . bidi-category-l) ;; HALFWIDTH HANGUL LETTER PIEUP
	 (?\xFFBE . bidi-category-l) ;; 
	 (?\xFFC2 . bidi-category-l) ;; 
	 (?\xFFC3 . bidi-category-l) ;; 
	 (?\xFFC4 . bidi-category-l) ;; 
	 (?\xFFC5 . bidi-category-l) ;; 
	 (?\xFFC6 . bidi-category-l) ;; 
	 (?\xFFC7 . bidi-category-l) ;; 
	 (?\xFFCA . bidi-category-l) ;; 
	 (?\xFFCB . bidi-category-l) ;; 
	 (?\xFFCC . bidi-category-l) ;; 
	 (?\xFFCD . bidi-category-l) ;; 
	 (?\xFFCE . bidi-category-l) ;; 
	 (?\xFFCF . bidi-category-l) ;; 
	 (?\xFFD2 . bidi-category-l) ;; 
	 (?\xFFD3 . bidi-category-l) ;; 
	 (?\xFFD4 . bidi-category-l) ;; 
	 (?\xFFD5 . bidi-category-l) ;; 
	 (?\xFFD6 . bidi-category-l) ;; 
	 (?\xFFD7 . bidi-category-l) ;; 
	 (?\xFFDA . bidi-category-l) ;; 
	 (?\xFFDB . bidi-category-l) ;; 
	 (?\xFFDC . bidi-category-l) ;; 
	 (?\xFFE0 . bidi-category-et) ;; 
	 (?\xFFE1 . bidi-category-et) ;; 
	 (?\xFFE2 . bidi-category-on) ;; 
	 (?\xFFE3 . bidi-category-on) ;; FULLWIDTH SPACING MACRON
	 (?\xFFE4 . bidi-category-on) ;; FULLWIDTH BROKEN VERTICAL BAR
	 (?\xFFE5 . bidi-category-et) ;; 
	 (?\xFFE6 . bidi-category-et) ;; 
	 (?\xFFE8 . bidi-category-on) ;; 
	 (?\xFFE9 . bidi-category-on) ;; 
	 (?\xFFEA . bidi-category-on) ;; 
	 (?\xFFEB . bidi-category-on) ;; 
	 (?\xFFEC . bidi-category-on) ;; 
	 (?\xFFED . bidi-category-on) ;; 
	 (?\xFFEE . bidi-category-on) ;; 
	 (?\xFFF9 . bidi-category-bn) ;; 
	 (?\xFFFA . bidi-category-bn) ;; 
	 (?\xFFFB . bidi-category-bn) ;; 
	 (?\xFFFC . bidi-category-on) ;; 
	 (?\xFFFD . bidi-category-on) ;; 
	 (?\x10300 . bidi-category-l) ;; 
	 (?\x10301 . bidi-category-l) ;; 
	 (?\x10302 . bidi-category-l) ;; 
	 (?\x10303 . bidi-category-l) ;; 
	 (?\x10304 . bidi-category-l) ;; 
	 (?\x10305 . bidi-category-l) ;; 
	 (?\x10306 . bidi-category-l) ;; 
	 (?\x10307 . bidi-category-l) ;; 
	 (?\x10308 . bidi-category-l) ;; 
	 (?\x10309 . bidi-category-l) ;; 
	 (?\x1030A . bidi-category-l) ;; 
	 (?\x1030B . bidi-category-l) ;; 
	 (?\x1030C . bidi-category-l) ;; 
	 (?\x1030D . bidi-category-l) ;; 
	 (?\x1030E . bidi-category-l) ;; 
	 (?\x1030F . bidi-category-l) ;; 
	 (?\x10310 . bidi-category-l) ;; 
	 (?\x10311 . bidi-category-l) ;; 
	 (?\x10312 . bidi-category-l) ;; 
	 (?\x10313 . bidi-category-l) ;; 
	 (?\x10314 . bidi-category-l) ;; 
	 (?\x10315 . bidi-category-l) ;; 
	 (?\x10316 . bidi-category-l) ;; 
	 (?\x10317 . bidi-category-l) ;; 
	 (?\x10318 . bidi-category-l) ;; 
	 (?\x10319 . bidi-category-l) ;; 
	 (?\x1031A . bidi-category-l) ;; 
	 (?\x1031B . bidi-category-l) ;; 
	 (?\x1031C . bidi-category-l) ;; 
	 (?\x1031D . bidi-category-l) ;; 
	 (?\x1031E . bidi-category-l) ;; 
	 (?\x10320 . bidi-category-l) ;; 
	 (?\x10321 . bidi-category-l) ;; 
	 (?\x10322 . bidi-category-l) ;; 
	 (?\x10323 . bidi-category-l) ;; 
	 (?\x10330 . bidi-category-l) ;; 
	 (?\x10331 . bidi-category-l) ;; 
	 (?\x10332 . bidi-category-l) ;; 
	 (?\x10333 . bidi-category-l) ;; 
	 (?\x10334 . bidi-category-l) ;; 
	 (?\x10335 . bidi-category-l) ;; 
	 (?\x10336 . bidi-category-l) ;; 
	 (?\x10337 . bidi-category-l) ;; 
	 (?\x10338 . bidi-category-l) ;; 
	 (?\x10339 . bidi-category-l) ;; 
	 (?\x1033A . bidi-category-l) ;; 
	 (?\x1033B . bidi-category-l) ;; 
	 (?\x1033C . bidi-category-l) ;; 
	 (?\x1033D . bidi-category-l) ;; 
	 (?\x1033E . bidi-category-l) ;; 
	 (?\x1033F . bidi-category-l) ;; 
	 (?\x10340 . bidi-category-l) ;; 
	 (?\x10341 . bidi-category-l) ;; 
	 (?\x10342 . bidi-category-l) ;; 
	 (?\x10343 . bidi-category-l) ;; 
	 (?\x10344 . bidi-category-l) ;; 
	 (?\x10345 . bidi-category-l) ;; 
	 (?\x10346 . bidi-category-l) ;; 
	 (?\x10347 . bidi-category-l) ;; 
	 (?\x10348 . bidi-category-l) ;; 
	 (?\x10349 . bidi-category-l) ;; 
	 (?\x1034A . bidi-category-l) ;; 
	 (?\x10400 . bidi-category-l) ;; 
	 (?\x10401 . bidi-category-l) ;; 
	 (?\x10402 . bidi-category-l) ;; 
	 (?\x10403 . bidi-category-l) ;; 
	 (?\x10404 . bidi-category-l) ;; 
	 (?\x10405 . bidi-category-l) ;; 
	 (?\x10406 . bidi-category-l) ;; 
	 (?\x10407 . bidi-category-l) ;; 
	 (?\x10408 . bidi-category-l) ;; 
	 (?\x10409 . bidi-category-l) ;; 
	 (?\x1040A . bidi-category-l) ;; 
	 (?\x1040B . bidi-category-l) ;; 
	 (?\x1040C . bidi-category-l) ;; 
	 (?\x1040D . bidi-category-l) ;; 
	 (?\x1040E . bidi-category-l) ;; 
	 (?\x1040F . bidi-category-l) ;; 
	 (?\x10410 . bidi-category-l) ;; 
	 (?\x10411 . bidi-category-l) ;; 
	 (?\x10412 . bidi-category-l) ;; 
	 (?\x10413 . bidi-category-l) ;; 
	 (?\x10414 . bidi-category-l) ;; 
	 (?\x10415 . bidi-category-l) ;; 
	 (?\x10416 . bidi-category-l) ;; 
	 (?\x10417 . bidi-category-l) ;; 
	 (?\x10418 . bidi-category-l) ;; 
	 (?\x10419 . bidi-category-l) ;; 
	 (?\x1041A . bidi-category-l) ;; 
	 (?\x1041B . bidi-category-l) ;; 
	 (?\x1041C . bidi-category-l) ;; 
	 (?\x1041D . bidi-category-l) ;; 
	 (?\x1041E . bidi-category-l) ;; 
	 (?\x1041F . bidi-category-l) ;; 
	 (?\x10420 . bidi-category-l) ;; 
	 (?\x10421 . bidi-category-l) ;; 
	 (?\x10422 . bidi-category-l) ;; 
	 (?\x10423 . bidi-category-l) ;; 
	 (?\x10424 . bidi-category-l) ;; 
	 (?\x10425 . bidi-category-l) ;; 
	 (?\x10428 . bidi-category-l) ;; 
	 (?\x10429 . bidi-category-l) ;; 
	 (?\x1042A . bidi-category-l) ;; 
	 (?\x1042B . bidi-category-l) ;; 
	 (?\x1042C . bidi-category-l) ;; 
	 (?\x1042D . bidi-category-l) ;; 
	 (?\x1042E . bidi-category-l) ;; 
	 (?\x1042F . bidi-category-l) ;; 
	 (?\x10430 . bidi-category-l) ;; 
	 (?\x10431 . bidi-category-l) ;; 
	 (?\x10432 . bidi-category-l) ;; 
	 (?\x10433 . bidi-category-l) ;; 
	 (?\x10434 . bidi-category-l) ;; 
	 (?\x10435 . bidi-category-l) ;; 
	 (?\x10436 . bidi-category-l) ;; 
	 (?\x10437 . bidi-category-l) ;; 
	 (?\x10438 . bidi-category-l) ;; 
	 (?\x10439 . bidi-category-l) ;; 
	 (?\x1043A . bidi-category-l) ;; 
	 (?\x1043B . bidi-category-l) ;; 
	 (?\x1043C . bidi-category-l) ;; 
	 (?\x1043D . bidi-category-l) ;; 
	 (?\x1043E . bidi-category-l) ;; 
	 (?\x1043F . bidi-category-l) ;; 
	 (?\x10440 . bidi-category-l) ;; 
	 (?\x10441 . bidi-category-l) ;; 
	 (?\x10442 . bidi-category-l) ;; 
	 (?\x10443 . bidi-category-l) ;; 
	 (?\x10444 . bidi-category-l) ;; 
	 (?\x10445 . bidi-category-l) ;; 
	 (?\x10446 . bidi-category-l) ;; 
	 (?\x10447 . bidi-category-l) ;; 
	 (?\x10448 . bidi-category-l) ;; 
	 (?\x10449 . bidi-category-l) ;; 
	 (?\x1044A . bidi-category-l) ;; 
	 (?\x1044B . bidi-category-l) ;; 
	 (?\x1044C . bidi-category-l) ;; 
	 (?\x1044D . bidi-category-l) ;; 
	 (?\x1D000 . bidi-category-l) ;; 
	 (?\x1D001 . bidi-category-l) ;; 
	 (?\x1D002 . bidi-category-l) ;; 
	 (?\x1D003 . bidi-category-l) ;; 
	 (?\x1D004 . bidi-category-l) ;; 
	 (?\x1D005 . bidi-category-l) ;; 
	 (?\x1D006 . bidi-category-l) ;; 
	 (?\x1D007 . bidi-category-l) ;; 
	 (?\x1D008 . bidi-category-l) ;; 
	 (?\x1D009 . bidi-category-l) ;; 
	 (?\x1D00A . bidi-category-l) ;; 
	 (?\x1D00B . bidi-category-l) ;; 
	 (?\x1D00C . bidi-category-l) ;; 
	 (?\x1D00D . bidi-category-l) ;; 
	 (?\x1D00E . bidi-category-l) ;; 
	 (?\x1D00F . bidi-category-l) ;; 
	 (?\x1D010 . bidi-category-l) ;; 
	 (?\x1D011 . bidi-category-l) ;; 
	 (?\x1D012 . bidi-category-l) ;; 
	 (?\x1D013 . bidi-category-l) ;; 
	 (?\x1D014 . bidi-category-l) ;; 
	 (?\x1D015 . bidi-category-l) ;; 
	 (?\x1D016 . bidi-category-l) ;; 
	 (?\x1D017 . bidi-category-l) ;; 
	 (?\x1D018 . bidi-category-l) ;; 
	 (?\x1D019 . bidi-category-l) ;; 
	 (?\x1D01A . bidi-category-l) ;; 
	 (?\x1D01B . bidi-category-l) ;; 
	 (?\x1D01C . bidi-category-l) ;; 
	 (?\x1D01D . bidi-category-l) ;; 
	 (?\x1D01E . bidi-category-l) ;; 
	 (?\x1D01F . bidi-category-l) ;; 
	 (?\x1D020 . bidi-category-l) ;; 
	 (?\x1D021 . bidi-category-l) ;; 
	 (?\x1D022 . bidi-category-l) ;; 
	 (?\x1D023 . bidi-category-l) ;; 
	 (?\x1D024 . bidi-category-l) ;; 
	 (?\x1D025 . bidi-category-l) ;; 
	 (?\x1D026 . bidi-category-l) ;; 
	 (?\x1D027 . bidi-category-l) ;; 
	 (?\x1D028 . bidi-category-l) ;; 
	 (?\x1D029 . bidi-category-l) ;; 
	 (?\x1D02A . bidi-category-l) ;; 
	 (?\x1D02B . bidi-category-l) ;; 
	 (?\x1D02C . bidi-category-l) ;; 
	 (?\x1D02D . bidi-category-l) ;; 
	 (?\x1D02E . bidi-category-l) ;; 
	 (?\x1D02F . bidi-category-l) ;; 
	 (?\x1D030 . bidi-category-l) ;; 
	 (?\x1D031 . bidi-category-l) ;; 
	 (?\x1D032 . bidi-category-l) ;; 
	 (?\x1D033 . bidi-category-l) ;; 
	 (?\x1D034 . bidi-category-l) ;; 
	 (?\x1D035 . bidi-category-l) ;; 
	 (?\x1D036 . bidi-category-l) ;; 
	 (?\x1D037 . bidi-category-l) ;; 
	 (?\x1D038 . bidi-category-l) ;; 
	 (?\x1D039 . bidi-category-l) ;; 
	 (?\x1D03A . bidi-category-l) ;; 
	 (?\x1D03B . bidi-category-l) ;; 
	 (?\x1D03C . bidi-category-l) ;; 
	 (?\x1D03D . bidi-category-l) ;; 
	 (?\x1D03E . bidi-category-l) ;; 
	 (?\x1D03F . bidi-category-l) ;; 
	 (?\x1D040 . bidi-category-l) ;; 
	 (?\x1D041 . bidi-category-l) ;; 
	 (?\x1D042 . bidi-category-l) ;; 
	 (?\x1D043 . bidi-category-l) ;; 
	 (?\x1D044 . bidi-category-l) ;; 
	 (?\x1D045 . bidi-category-l) ;; 
	 (?\x1D046 . bidi-category-l) ;; 
	 (?\x1D047 . bidi-category-l) ;; 
	 (?\x1D048 . bidi-category-l) ;; 
	 (?\x1D049 . bidi-category-l) ;; 
	 (?\x1D04A . bidi-category-l) ;; 
	 (?\x1D04B . bidi-category-l) ;; 
	 (?\x1D04C . bidi-category-l) ;; 
	 (?\x1D04D . bidi-category-l) ;; 
	 (?\x1D04E . bidi-category-l) ;; 
	 (?\x1D04F . bidi-category-l) ;; 
	 (?\x1D050 . bidi-category-l) ;; 
	 (?\x1D051 . bidi-category-l) ;; 
	 (?\x1D052 . bidi-category-l) ;; 
	 (?\x1D053 . bidi-category-l) ;; 
	 (?\x1D054 . bidi-category-l) ;; 
	 (?\x1D055 . bidi-category-l) ;; 
	 (?\x1D056 . bidi-category-l) ;; 
	 (?\x1D057 . bidi-category-l) ;; 
	 (?\x1D058 . bidi-category-l) ;; 
	 (?\x1D059 . bidi-category-l) ;; 
	 (?\x1D05A . bidi-category-l) ;; 
	 (?\x1D05B . bidi-category-l) ;; 
	 (?\x1D05C . bidi-category-l) ;; 
	 (?\x1D05D . bidi-category-l) ;; 
	 (?\x1D05E . bidi-category-l) ;; 
	 (?\x1D05F . bidi-category-l) ;; 
	 (?\x1D060 . bidi-category-l) ;; 
	 (?\x1D061 . bidi-category-l) ;; 
	 (?\x1D062 . bidi-category-l) ;; 
	 (?\x1D063 . bidi-category-l) ;; 
	 (?\x1D064 . bidi-category-l) ;; 
	 (?\x1D065 . bidi-category-l) ;; 
	 (?\x1D066 . bidi-category-l) ;; 
	 (?\x1D067 . bidi-category-l) ;; 
	 (?\x1D068 . bidi-category-l) ;; 
	 (?\x1D069 . bidi-category-l) ;; 
	 (?\x1D06A . bidi-category-l) ;; 
	 (?\x1D06B . bidi-category-l) ;; 
	 (?\x1D06C . bidi-category-l) ;; 
	 (?\x1D06D . bidi-category-l) ;; 
	 (?\x1D06E . bidi-category-l) ;; 
	 (?\x1D06F . bidi-category-l) ;; 
	 (?\x1D070 . bidi-category-l) ;; 
	 (?\x1D071 . bidi-category-l) ;; 
	 (?\x1D072 . bidi-category-l) ;; 
	 (?\x1D073 . bidi-category-l) ;; 
	 (?\x1D074 . bidi-category-l) ;; 
	 (?\x1D075 . bidi-category-l) ;; 
	 (?\x1D076 . bidi-category-l) ;; 
	 (?\x1D077 . bidi-category-l) ;; 
	 (?\x1D078 . bidi-category-l) ;; 
	 (?\x1D079 . bidi-category-l) ;; 
	 (?\x1D07A . bidi-category-l) ;; 
	 (?\x1D07B . bidi-category-l) ;; 
	 (?\x1D07C . bidi-category-l) ;; 
	 (?\x1D07D . bidi-category-l) ;; 
	 (?\x1D07E . bidi-category-l) ;; 
	 (?\x1D07F . bidi-category-l) ;; 
	 (?\x1D080 . bidi-category-l) ;; 
	 (?\x1D081 . bidi-category-l) ;; 
	 (?\x1D082 . bidi-category-l) ;; 
	 (?\x1D083 . bidi-category-l) ;; 
	 (?\x1D084 . bidi-category-l) ;; 
	 (?\x1D085 . bidi-category-l) ;; 
	 (?\x1D086 . bidi-category-l) ;; 
	 (?\x1D087 . bidi-category-l) ;; 
	 (?\x1D088 . bidi-category-l) ;; 
	 (?\x1D089 . bidi-category-l) ;; 
	 (?\x1D08A . bidi-category-l) ;; 
	 (?\x1D08B . bidi-category-l) ;; 
	 (?\x1D08C . bidi-category-l) ;; 
	 (?\x1D08D . bidi-category-l) ;; 
	 (?\x1D08E . bidi-category-l) ;; 
	 (?\x1D08F . bidi-category-l) ;; 
	 (?\x1D090 . bidi-category-l) ;; 
	 (?\x1D091 . bidi-category-l) ;; 
	 (?\x1D092 . bidi-category-l) ;; 
	 (?\x1D093 . bidi-category-l) ;; 
	 (?\x1D094 . bidi-category-l) ;; 
	 (?\x1D095 . bidi-category-l) ;; 
	 (?\x1D096 . bidi-category-l) ;; 
	 (?\x1D097 . bidi-category-l) ;; 
	 (?\x1D098 . bidi-category-l) ;; 
	 (?\x1D099 . bidi-category-l) ;; 
	 (?\x1D09A . bidi-category-l) ;; 
	 (?\x1D09B . bidi-category-l) ;; 
	 (?\x1D09C . bidi-category-l) ;; 
	 (?\x1D09D . bidi-category-l) ;; 
	 (?\x1D09E . bidi-category-l) ;; 
	 (?\x1D09F . bidi-category-l) ;; 
	 (?\x1D0A0 . bidi-category-l) ;; 
	 (?\x1D0A1 . bidi-category-l) ;; 
	 (?\x1D0A2 . bidi-category-l) ;; 
	 (?\x1D0A3 . bidi-category-l) ;; 
	 (?\x1D0A4 . bidi-category-l) ;; 
	 (?\x1D0A5 . bidi-category-l) ;; 
	 (?\x1D0A6 . bidi-category-l) ;; 
	 (?\x1D0A7 . bidi-category-l) ;; 
	 (?\x1D0A8 . bidi-category-l) ;; 
	 (?\x1D0A9 . bidi-category-l) ;; 
	 (?\x1D0AA . bidi-category-l) ;; 
	 (?\x1D0AB . bidi-category-l) ;; 
	 (?\x1D0AC . bidi-category-l) ;; 
	 (?\x1D0AD . bidi-category-l) ;; 
	 (?\x1D0AE . bidi-category-l) ;; 
	 (?\x1D0AF . bidi-category-l) ;; 
	 (?\x1D0B0 . bidi-category-l) ;; 
	 (?\x1D0B1 . bidi-category-l) ;; 
	 (?\x1D0B2 . bidi-category-l) ;; 
	 (?\x1D0B3 . bidi-category-l) ;; 
	 (?\x1D0B4 . bidi-category-l) ;; 
	 (?\x1D0B5 . bidi-category-l) ;; 
	 (?\x1D0B6 . bidi-category-l) ;; 
	 (?\x1D0B7 . bidi-category-l) ;; 
	 (?\x1D0B8 . bidi-category-l) ;; 
	 (?\x1D0B9 . bidi-category-l) ;; 
	 (?\x1D0BA . bidi-category-l) ;; 
	 (?\x1D0BB . bidi-category-l) ;; 
	 (?\x1D0BC . bidi-category-l) ;; 
	 (?\x1D0BD . bidi-category-l) ;; 
	 (?\x1D0BE . bidi-category-l) ;; 
	 (?\x1D0BF . bidi-category-l) ;; 
	 (?\x1D0C0 . bidi-category-l) ;; 
	 (?\x1D0C1 . bidi-category-l) ;; 
	 (?\x1D0C2 . bidi-category-l) ;; 
	 (?\x1D0C3 . bidi-category-l) ;; 
	 (?\x1D0C4 . bidi-category-l) ;; 
	 (?\x1D0C5 . bidi-category-l) ;; 
	 (?\x1D0C6 . bidi-category-l) ;; 
	 (?\x1D0C7 . bidi-category-l) ;; 
	 (?\x1D0C8 . bidi-category-l) ;; 
	 (?\x1D0C9 . bidi-category-l) ;; 
	 (?\x1D0CA . bidi-category-l) ;; 
	 (?\x1D0CB . bidi-category-l) ;; 
	 (?\x1D0CC . bidi-category-l) ;; 
	 (?\x1D0CD . bidi-category-l) ;; 
	 (?\x1D0CE . bidi-category-l) ;; 
	 (?\x1D0CF . bidi-category-l) ;; 
	 (?\x1D0D0 . bidi-category-l) ;; 
	 (?\x1D0D1 . bidi-category-l) ;; 
	 (?\x1D0D2 . bidi-category-l) ;; 
	 (?\x1D0D3 . bidi-category-l) ;; 
	 (?\x1D0D4 . bidi-category-l) ;; 
	 (?\x1D0D5 . bidi-category-l) ;; 
	 (?\x1D0D6 . bidi-category-l) ;; 
	 (?\x1D0D7 . bidi-category-l) ;; 
	 (?\x1D0D8 . bidi-category-l) ;; 
	 (?\x1D0D9 . bidi-category-l) ;; 
	 (?\x1D0DA . bidi-category-l) ;; 
	 (?\x1D0DB . bidi-category-l) ;; 
	 (?\x1D0DC . bidi-category-l) ;; 
	 (?\x1D0DD . bidi-category-l) ;; 
	 (?\x1D0DE . bidi-category-l) ;; 
	 (?\x1D0DF . bidi-category-l) ;; 
	 (?\x1D0E0 . bidi-category-l) ;; 
	 (?\x1D0E1 . bidi-category-l) ;; 
	 (?\x1D0E2 . bidi-category-l) ;; 
	 (?\x1D0E3 . bidi-category-l) ;; 
	 (?\x1D0E4 . bidi-category-l) ;; 
	 (?\x1D0E5 . bidi-category-l) ;; 
	 (?\x1D0E6 . bidi-category-l) ;; 
	 (?\x1D0E7 . bidi-category-l) ;; 
	 (?\x1D0E8 . bidi-category-l) ;; 
	 (?\x1D0E9 . bidi-category-l) ;; 
	 (?\x1D0EA . bidi-category-l) ;; 
	 (?\x1D0EB . bidi-category-l) ;; 
	 (?\x1D0EC . bidi-category-l) ;; 
	 (?\x1D0ED . bidi-category-l) ;; 
	 (?\x1D0EE . bidi-category-l) ;; 
	 (?\x1D0EF . bidi-category-l) ;; 
	 (?\x1D0F0 . bidi-category-l) ;; 
	 (?\x1D0F1 . bidi-category-l) ;; 
	 (?\x1D0F2 . bidi-category-l) ;; 
	 (?\x1D0F3 . bidi-category-l) ;; 
	 (?\x1D0F4 . bidi-category-l) ;; 
	 (?\x1D0F5 . bidi-category-l) ;; 
	 (?\x1D100 . bidi-category-l) ;; 
	 (?\x1D101 . bidi-category-l) ;; 
	 (?\x1D102 . bidi-category-l) ;; 
	 (?\x1D103 . bidi-category-l) ;; 
	 (?\x1D104 . bidi-category-l) ;; 
	 (?\x1D105 . bidi-category-l) ;; 
	 (?\x1D106 . bidi-category-l) ;; 
	 (?\x1D107 . bidi-category-l) ;; 
	 (?\x1D108 . bidi-category-l) ;; 
	 (?\x1D109 . bidi-category-l) ;; 
	 (?\x1D10A . bidi-category-l) ;; 
	 (?\x1D10B . bidi-category-l) ;; 
	 (?\x1D10C . bidi-category-l) ;; 
	 (?\x1D10D . bidi-category-l) ;; 
	 (?\x1D10E . bidi-category-l) ;; 
	 (?\x1D10F . bidi-category-l) ;; 
	 (?\x1D110 . bidi-category-l) ;; 
	 (?\x1D111 . bidi-category-l) ;; 
	 (?\x1D112 . bidi-category-l) ;; 
	 (?\x1D113 . bidi-category-l) ;; 
	 (?\x1D114 . bidi-category-l) ;; 
	 (?\x1D115 . bidi-category-l) ;; 
	 (?\x1D116 . bidi-category-l) ;; 
	 (?\x1D117 . bidi-category-l) ;; 
	 (?\x1D118 . bidi-category-l) ;; 
	 (?\x1D119 . bidi-category-l) ;; 
	 (?\x1D11A . bidi-category-l) ;; 
	 (?\x1D11B . bidi-category-l) ;; 
	 (?\x1D11C . bidi-category-l) ;; 
	 (?\x1D11D . bidi-category-l) ;; 
	 (?\x1D11E . bidi-category-l) ;; 
	 (?\x1D11F . bidi-category-l) ;; 
	 (?\x1D120 . bidi-category-l) ;; 
	 (?\x1D121 . bidi-category-l) ;; 
	 (?\x1D122 . bidi-category-l) ;; 
	 (?\x1D123 . bidi-category-l) ;; 
	 (?\x1D124 . bidi-category-l) ;; 
	 (?\x1D125 . bidi-category-l) ;; 
	 (?\x1D126 . bidi-category-l) ;; 
	 (?\x1D12A . bidi-category-l) ;; 
	 (?\x1D12B . bidi-category-l) ;; 
	 (?\x1D12C . bidi-category-l) ;; 
	 (?\x1D12D . bidi-category-l) ;; 
	 (?\x1D12E . bidi-category-l) ;; 
	 (?\x1D12F . bidi-category-l) ;; 
	 (?\x1D130 . bidi-category-l) ;; 
	 (?\x1D131 . bidi-category-l) ;; 
	 (?\x1D132 . bidi-category-l) ;; 
	 (?\x1D133 . bidi-category-l) ;; 
	 (?\x1D134 . bidi-category-l) ;; 
	 (?\x1D135 . bidi-category-l) ;; 
	 (?\x1D136 . bidi-category-l) ;; 
	 (?\x1D137 . bidi-category-l) ;; 
	 (?\x1D138 . bidi-category-l) ;; 
	 (?\x1D139 . bidi-category-l) ;; 
	 (?\x1D13A . bidi-category-l) ;; 
	 (?\x1D13B . bidi-category-l) ;; 
	 (?\x1D13C . bidi-category-l) ;; 
	 (?\x1D13D . bidi-category-l) ;; 
	 (?\x1D13E . bidi-category-l) ;; 
	 (?\x1D13F . bidi-category-l) ;; 
	 (?\x1D140 . bidi-category-l) ;; 
	 (?\x1D141 . bidi-category-l) ;; 
	 (?\x1D142 . bidi-category-l) ;; 
	 (?\x1D143 . bidi-category-l) ;; 
	 (?\x1D144 . bidi-category-l) ;; 
	 (?\x1D145 . bidi-category-l) ;; 
	 (?\x1D146 . bidi-category-l) ;; 
	 (?\x1D147 . bidi-category-l) ;; 
	 (?\x1D148 . bidi-category-l) ;; 
	 (?\x1D149 . bidi-category-l) ;; 
	 (?\x1D14A . bidi-category-l) ;; 
	 (?\x1D14B . bidi-category-l) ;; 
	 (?\x1D14C . bidi-category-l) ;; 
	 (?\x1D14D . bidi-category-l) ;; 
	 (?\x1D14E . bidi-category-l) ;; 
	 (?\x1D14F . bidi-category-l) ;; 
	 (?\x1D150 . bidi-category-l) ;; 
	 (?\x1D151 . bidi-category-l) ;; 
	 (?\x1D152 . bidi-category-l) ;; 
	 (?\x1D153 . bidi-category-l) ;; 
	 (?\x1D154 . bidi-category-l) ;; 
	 (?\x1D155 . bidi-category-l) ;; 
	 (?\x1D156 . bidi-category-l) ;; 
	 (?\x1D157 . bidi-category-l) ;; 
	 (?\x1D158 . bidi-category-l) ;; 
	 (?\x1D159 . bidi-category-l) ;; 
	 (?\x1D15A . bidi-category-l) ;; 
	 (?\x1D15B . bidi-category-l) ;; 
	 (?\x1D15C . bidi-category-l) ;; 
	 (?\x1D15D . bidi-category-l) ;; 
	 (?\x1D15E . bidi-category-l) ;; 
	 (?\x1D15F . bidi-category-l) ;; 
	 (?\x1D160 . bidi-category-l) ;; 
	 (?\x1D161 . bidi-category-l) ;; 
	 (?\x1D162 . bidi-category-l) ;; 
	 (?\x1D163 . bidi-category-l) ;; 
	 (?\x1D164 . bidi-category-l) ;; 
	 (?\x1D165 . bidi-category-l) ;; 
	 (?\x1D166 . bidi-category-l) ;; 
	 (?\x1D167 . bidi-category-nsm) ;; 
	 (?\x1D168 . bidi-category-nsm) ;; 
	 (?\x1D169 . bidi-category-nsm) ;; 
	 (?\x1D16A . bidi-category-l) ;; 
	 (?\x1D16B . bidi-category-l) ;; 
	 (?\x1D16C . bidi-category-l) ;; 
	 (?\x1D16D . bidi-category-l) ;; 
	 (?\x1D16E . bidi-category-l) ;; 
	 (?\x1D16F . bidi-category-l) ;; 
	 (?\x1D170 . bidi-category-l) ;; 
	 (?\x1D171 . bidi-category-l) ;; 
	 (?\x1D172 . bidi-category-l) ;; 
	 (?\x1D173 . bidi-category-bn) ;; 
	 (?\x1D174 . bidi-category-bn) ;; 
	 (?\x1D175 . bidi-category-bn) ;; 
	 (?\x1D176 . bidi-category-bn) ;; 
	 (?\x1D177 . bidi-category-bn) ;; 
	 (?\x1D178 . bidi-category-bn) ;; 
	 (?\x1D179 . bidi-category-bn) ;; 
	 (?\x1D17A . bidi-category-bn) ;; 
	 (?\x1D17B . bidi-category-nsm) ;; 
	 (?\x1D17C . bidi-category-nsm) ;; 
	 (?\x1D17D . bidi-category-nsm) ;; 
	 (?\x1D17E . bidi-category-nsm) ;; 
	 (?\x1D17F . bidi-category-nsm) ;; 
	 (?\x1D180 . bidi-category-nsm) ;; 
	 (?\x1D181 . bidi-category-nsm) ;; 
	 (?\x1D182 . bidi-category-nsm) ;; 
	 (?\x1D183 . bidi-category-l) ;; 
	 (?\x1D184 . bidi-category-l) ;; 
	 (?\x1D185 . bidi-category-nsm) ;; 
	 (?\x1D186 . bidi-category-nsm) ;; 
	 (?\x1D187 . bidi-category-nsm) ;; 
	 (?\x1D188 . bidi-category-nsm) ;; 
	 (?\x1D189 . bidi-category-nsm) ;; 
	 (?\x1D18A . bidi-category-nsm) ;; 
	 (?\x1D18B . bidi-category-nsm) ;; 
	 (?\x1D18C . bidi-category-l) ;; 
	 (?\x1D18D . bidi-category-l) ;; 
	 (?\x1D18E . bidi-category-l) ;; 
	 (?\x1D18F . bidi-category-l) ;; 
	 (?\x1D190 . bidi-category-l) ;; 
	 (?\x1D191 . bidi-category-l) ;; 
	 (?\x1D192 . bidi-category-l) ;; 
	 (?\x1D193 . bidi-category-l) ;; 
	 (?\x1D194 . bidi-category-l) ;; 
	 (?\x1D195 . bidi-category-l) ;; 
	 (?\x1D196 . bidi-category-l) ;; 
	 (?\x1D197 . bidi-category-l) ;; 
	 (?\x1D198 . bidi-category-l) ;; 
	 (?\x1D199 . bidi-category-l) ;; 
	 (?\x1D19A . bidi-category-l) ;; 
	 (?\x1D19B . bidi-category-l) ;; 
	 (?\x1D19C . bidi-category-l) ;; 
	 (?\x1D19D . bidi-category-l) ;; 
	 (?\x1D19E . bidi-category-l) ;; 
	 (?\x1D19F . bidi-category-l) ;; 
	 (?\x1D1A0 . bidi-category-l) ;; 
	 (?\x1D1A1 . bidi-category-l) ;; 
	 (?\x1D1A2 . bidi-category-l) ;; 
	 (?\x1D1A3 . bidi-category-l) ;; 
	 (?\x1D1A4 . bidi-category-l) ;; 
	 (?\x1D1A5 . bidi-category-l) ;; 
	 (?\x1D1A6 . bidi-category-l) ;; 
	 (?\x1D1A7 . bidi-category-l) ;; 
	 (?\x1D1A8 . bidi-category-l) ;; 
	 (?\x1D1A9 . bidi-category-l) ;; 
	 (?\x1D1AA . bidi-category-nsm) ;; 
	 (?\x1D1AB . bidi-category-nsm) ;; 
	 (?\x1D1AC . bidi-category-nsm) ;; 
	 (?\x1D1AD . bidi-category-nsm) ;; 
	 (?\x1D1AE . bidi-category-l) ;; 
	 (?\x1D1AF . bidi-category-l) ;; 
	 (?\x1D1B0 . bidi-category-l) ;; 
	 (?\x1D1B1 . bidi-category-l) ;; 
	 (?\x1D1B2 . bidi-category-l) ;; 
	 (?\x1D1B3 . bidi-category-l) ;; 
	 (?\x1D1B4 . bidi-category-l) ;; 
	 (?\x1D1B5 . bidi-category-l) ;; 
	 (?\x1D1B6 . bidi-category-l) ;; 
	 (?\x1D1B7 . bidi-category-l) ;; 
	 (?\x1D1B8 . bidi-category-l) ;; 
	 (?\x1D1B9 . bidi-category-l) ;; 
	 (?\x1D1BA . bidi-category-l) ;; 
	 (?\x1D1BB . bidi-category-l) ;; 
	 (?\x1D1BC . bidi-category-l) ;; 
	 (?\x1D1BD . bidi-category-l) ;; 
	 (?\x1D1BE . bidi-category-l) ;; 
	 (?\x1D1BF . bidi-category-l) ;; 
	 (?\x1D1C0 . bidi-category-l) ;; 
	 (?\x1D1C1 . bidi-category-l) ;; 
	 (?\x1D1C2 . bidi-category-l) ;; 
	 (?\x1D1C3 . bidi-category-l) ;; 
	 (?\x1D1C4 . bidi-category-l) ;; 
	 (?\x1D1C5 . bidi-category-l) ;; 
	 (?\x1D1C6 . bidi-category-l) ;; 
	 (?\x1D1C7 . bidi-category-l) ;; 
	 (?\x1D1C8 . bidi-category-l) ;; 
	 (?\x1D1C9 . bidi-category-l) ;; 
	 (?\x1D1CA . bidi-category-l) ;; 
	 (?\x1D1CB . bidi-category-l) ;; 
	 (?\x1D1CC . bidi-category-l) ;; 
	 (?\x1D1CD . bidi-category-l) ;; 
	 (?\x1D1CE . bidi-category-l) ;; 
	 (?\x1D1CF . bidi-category-l) ;; 
	 (?\x1D1D0 . bidi-category-l) ;; 
	 (?\x1D1D1 . bidi-category-l) ;; 
	 (?\x1D1D2 . bidi-category-l) ;; 
	 (?\x1D1D3 . bidi-category-l) ;; 
	 (?\x1D1D4 . bidi-category-l) ;; 
	 (?\x1D1D5 . bidi-category-l) ;; 
	 (?\x1D1D6 . bidi-category-l) ;; 
	 (?\x1D1D7 . bidi-category-l) ;; 
	 (?\x1D1D8 . bidi-category-l) ;; 
	 (?\x1D1D9 . bidi-category-l) ;; 
	 (?\x1D1DA . bidi-category-l) ;; 
	 (?\x1D1DB . bidi-category-l) ;; 
	 (?\x1D1DC . bidi-category-l) ;; 
	 (?\x1D1DD . bidi-category-l) ;; 
	 (?\x1D400 . bidi-category-l) ;; 
	 (?\x1D401 . bidi-category-l) ;; 
	 (?\x1D402 . bidi-category-l) ;; 
	 (?\x1D403 . bidi-category-l) ;; 
	 (?\x1D404 . bidi-category-l) ;; 
	 (?\x1D405 . bidi-category-l) ;; 
	 (?\x1D406 . bidi-category-l) ;; 
	 (?\x1D407 . bidi-category-l) ;; 
	 (?\x1D408 . bidi-category-l) ;; 
	 (?\x1D409 . bidi-category-l) ;; 
	 (?\x1D40A . bidi-category-l) ;; 
	 (?\x1D40B . bidi-category-l) ;; 
	 (?\x1D40C . bidi-category-l) ;; 
	 (?\x1D40D . bidi-category-l) ;; 
	 (?\x1D40E . bidi-category-l) ;; 
	 (?\x1D40F . bidi-category-l) ;; 
	 (?\x1D410 . bidi-category-l) ;; 
	 (?\x1D411 . bidi-category-l) ;; 
	 (?\x1D412 . bidi-category-l) ;; 
	 (?\x1D413 . bidi-category-l) ;; 
	 (?\x1D414 . bidi-category-l) ;; 
	 (?\x1D415 . bidi-category-l) ;; 
	 (?\x1D416 . bidi-category-l) ;; 
	 (?\x1D417 . bidi-category-l) ;; 
	 (?\x1D418 . bidi-category-l) ;; 
	 (?\x1D419 . bidi-category-l) ;; 
	 (?\x1D41A . bidi-category-l) ;; 
	 (?\x1D41B . bidi-category-l) ;; 
	 (?\x1D41C . bidi-category-l) ;; 
	 (?\x1D41D . bidi-category-l) ;; 
	 (?\x1D41E . bidi-category-l) ;; 
	 (?\x1D41F . bidi-category-l) ;; 
	 (?\x1D420 . bidi-category-l) ;; 
	 (?\x1D421 . bidi-category-l) ;; 
	 (?\x1D422 . bidi-category-l) ;; 
	 (?\x1D423 . bidi-category-l) ;; 
	 (?\x1D424 . bidi-category-l) ;; 
	 (?\x1D425 . bidi-category-l) ;; 
	 (?\x1D426 . bidi-category-l) ;; 
	 (?\x1D427 . bidi-category-l) ;; 
	 (?\x1D428 . bidi-category-l) ;; 
	 (?\x1D429 . bidi-category-l) ;; 
	 (?\x1D42A . bidi-category-l) ;; 
	 (?\x1D42B . bidi-category-l) ;; 
	 (?\x1D42C . bidi-category-l) ;; 
	 (?\x1D42D . bidi-category-l) ;; 
	 (?\x1D42E . bidi-category-l) ;; 
	 (?\x1D42F . bidi-category-l) ;; 
	 (?\x1D430 . bidi-category-l) ;; 
	 (?\x1D431 . bidi-category-l) ;; 
	 (?\x1D432 . bidi-category-l) ;; 
	 (?\x1D433 . bidi-category-l) ;; 
	 (?\x1D434 . bidi-category-l) ;; 
	 (?\x1D435 . bidi-category-l) ;; 
	 (?\x1D436 . bidi-category-l) ;; 
	 (?\x1D437 . bidi-category-l) ;; 
	 (?\x1D438 . bidi-category-l) ;; 
	 (?\x1D439 . bidi-category-l) ;; 
	 (?\x1D43A . bidi-category-l) ;; 
	 (?\x1D43B . bidi-category-l) ;; 
	 (?\x1D43C . bidi-category-l) ;; 
	 (?\x1D43D . bidi-category-l) ;; 
	 (?\x1D43E . bidi-category-l) ;; 
	 (?\x1D43F . bidi-category-l) ;; 
	 (?\x1D440 . bidi-category-l) ;; 
	 (?\x1D441 . bidi-category-l) ;; 
	 (?\x1D442 . bidi-category-l) ;; 
	 (?\x1D443 . bidi-category-l) ;; 
	 (?\x1D444 . bidi-category-l) ;; 
	 (?\x1D445 . bidi-category-l) ;; 
	 (?\x1D446 . bidi-category-l) ;; 
	 (?\x1D447 . bidi-category-l) ;; 
	 (?\x1D448 . bidi-category-l) ;; 
	 (?\x1D449 . bidi-category-l) ;; 
	 (?\x1D44A . bidi-category-l) ;; 
	 (?\x1D44B . bidi-category-l) ;; 
	 (?\x1D44C . bidi-category-l) ;; 
	 (?\x1D44D . bidi-category-l) ;; 
	 (?\x1D44E . bidi-category-l) ;; 
	 (?\x1D44F . bidi-category-l) ;; 
	 (?\x1D450 . bidi-category-l) ;; 
	 (?\x1D451 . bidi-category-l) ;; 
	 (?\x1D452 . bidi-category-l) ;; 
	 (?\x1D453 . bidi-category-l) ;; 
	 (?\x1D454 . bidi-category-l) ;; 
	 (?\x1D456 . bidi-category-l) ;; 
	 (?\x1D457 . bidi-category-l) ;; 
	 (?\x1D458 . bidi-category-l) ;; 
	 (?\x1D459 . bidi-category-l) ;; 
	 (?\x1D45A . bidi-category-l) ;; 
	 (?\x1D45B . bidi-category-l) ;; 
	 (?\x1D45C . bidi-category-l) ;; 
	 (?\x1D45D . bidi-category-l) ;; 
	 (?\x1D45E . bidi-category-l) ;; 
	 (?\x1D45F . bidi-category-l) ;; 
	 (?\x1D460 . bidi-category-l) ;; 
	 (?\x1D461 . bidi-category-l) ;; 
	 (?\x1D462 . bidi-category-l) ;; 
	 (?\x1D463 . bidi-category-l) ;; 
	 (?\x1D464 . bidi-category-l) ;; 
	 (?\x1D465 . bidi-category-l) ;; 
	 (?\x1D466 . bidi-category-l) ;; 
	 (?\x1D467 . bidi-category-l) ;; 
	 (?\x1D468 . bidi-category-l) ;; 
	 (?\x1D469 . bidi-category-l) ;; 
	 (?\x1D46A . bidi-category-l) ;; 
	 (?\x1D46B . bidi-category-l) ;; 
	 (?\x1D46C . bidi-category-l) ;; 
	 (?\x1D46D . bidi-category-l) ;; 
	 (?\x1D46E . bidi-category-l) ;; 
	 (?\x1D46F . bidi-category-l) ;; 
	 (?\x1D470 . bidi-category-l) ;; 
	 (?\x1D471 . bidi-category-l) ;; 
	 (?\x1D472 . bidi-category-l) ;; 
	 (?\x1D473 . bidi-category-l) ;; 
	 (?\x1D474 . bidi-category-l) ;; 
	 (?\x1D475 . bidi-category-l) ;; 
	 (?\x1D476 . bidi-category-l) ;; 
	 (?\x1D477 . bidi-category-l) ;; 
	 (?\x1D478 . bidi-category-l) ;; 
	 (?\x1D479 . bidi-category-l) ;; 
	 (?\x1D47A . bidi-category-l) ;; 
	 (?\x1D47B . bidi-category-l) ;; 
	 (?\x1D47C . bidi-category-l) ;; 
	 (?\x1D47D . bidi-category-l) ;; 
	 (?\x1D47E . bidi-category-l) ;; 
	 (?\x1D47F . bidi-category-l) ;; 
	 (?\x1D480 . bidi-category-l) ;; 
	 (?\x1D481 . bidi-category-l) ;; 
	 (?\x1D482 . bidi-category-l) ;; 
	 (?\x1D483 . bidi-category-l) ;; 
	 (?\x1D484 . bidi-category-l) ;; 
	 (?\x1D485 . bidi-category-l) ;; 
	 (?\x1D486 . bidi-category-l) ;; 
	 (?\x1D487 . bidi-category-l) ;; 
	 (?\x1D488 . bidi-category-l) ;; 
	 (?\x1D489 . bidi-category-l) ;; 
	 (?\x1D48A . bidi-category-l) ;; 
	 (?\x1D48B . bidi-category-l) ;; 
	 (?\x1D48C . bidi-category-l) ;; 
	 (?\x1D48D . bidi-category-l) ;; 
	 (?\x1D48E . bidi-category-l) ;; 
	 (?\x1D48F . bidi-category-l) ;; 
	 (?\x1D490 . bidi-category-l) ;; 
	 (?\x1D491 . bidi-category-l) ;; 
	 (?\x1D492 . bidi-category-l) ;; 
	 (?\x1D493 . bidi-category-l) ;; 
	 (?\x1D494 . bidi-category-l) ;; 
	 (?\x1D495 . bidi-category-l) ;; 
	 (?\x1D496 . bidi-category-l) ;; 
	 (?\x1D497 . bidi-category-l) ;; 
	 (?\x1D498 . bidi-category-l) ;; 
	 (?\x1D499 . bidi-category-l) ;; 
	 (?\x1D49A . bidi-category-l) ;; 
	 (?\x1D49B . bidi-category-l) ;; 
	 (?\x1D49C . bidi-category-l) ;; 
	 (?\x1D49E . bidi-category-l) ;; 
	 (?\x1D49F . bidi-category-l) ;; 
	 (?\x1D4A2 . bidi-category-l) ;; 
	 (?\x1D4A5 . bidi-category-l) ;; 
	 (?\x1D4A6 . bidi-category-l) ;; 
	 (?\x1D4A9 . bidi-category-l) ;; 
	 (?\x1D4AA . bidi-category-l) ;; 
	 (?\x1D4AB . bidi-category-l) ;; 
	 (?\x1D4AC . bidi-category-l) ;; 
	 (?\x1D4AE . bidi-category-l) ;; 
	 (?\x1D4AF . bidi-category-l) ;; 
	 (?\x1D4B0 . bidi-category-l) ;; 
	 (?\x1D4B1 . bidi-category-l) ;; 
	 (?\x1D4B2 . bidi-category-l) ;; 
	 (?\x1D4B3 . bidi-category-l) ;; 
	 (?\x1D4B4 . bidi-category-l) ;; 
	 (?\x1D4B5 . bidi-category-l) ;; 
	 (?\x1D4B6 . bidi-category-l) ;; 
	 (?\x1D4B7 . bidi-category-l) ;; 
	 (?\x1D4B8 . bidi-category-l) ;; 
	 (?\x1D4B9 . bidi-category-l) ;; 
	 (?\x1D4BB . bidi-category-l) ;; 
	 (?\x1D4BD . bidi-category-l) ;; 
	 (?\x1D4BE . bidi-category-l) ;; 
	 (?\x1D4BF . bidi-category-l) ;; 
	 (?\x1D4C0 . bidi-category-l) ;; 
	 (?\x1D4C2 . bidi-category-l) ;; 
	 (?\x1D4C3 . bidi-category-l) ;; 
	 (?\x1D4C5 . bidi-category-l) ;; 
	 (?\x1D4C6 . bidi-category-l) ;; 
	 (?\x1D4C7 . bidi-category-l) ;; 
	 (?\x1D4C8 . bidi-category-l) ;; 
	 (?\x1D4C9 . bidi-category-l) ;; 
	 (?\x1D4CA . bidi-category-l) ;; 
	 (?\x1D4CB . bidi-category-l) ;; 
	 (?\x1D4CC . bidi-category-l) ;; 
	 (?\x1D4CD . bidi-category-l) ;; 
	 (?\x1D4CE . bidi-category-l) ;; 
	 (?\x1D4CF . bidi-category-l) ;; 
	 (?\x1D4D0 . bidi-category-l) ;; 
	 (?\x1D4D1 . bidi-category-l) ;; 
	 (?\x1D4D2 . bidi-category-l) ;; 
	 (?\x1D4D3 . bidi-category-l) ;; 
	 (?\x1D4D4 . bidi-category-l) ;; 
	 (?\x1D4D5 . bidi-category-l) ;; 
	 (?\x1D4D6 . bidi-category-l) ;; 
	 (?\x1D4D7 . bidi-category-l) ;; 
	 (?\x1D4D8 . bidi-category-l) ;; 
	 (?\x1D4D9 . bidi-category-l) ;; 
	 (?\x1D4DA . bidi-category-l) ;; 
	 (?\x1D4DB . bidi-category-l) ;; 
	 (?\x1D4DC . bidi-category-l) ;; 
	 (?\x1D4DD . bidi-category-l) ;; 
	 (?\x1D4DE . bidi-category-l) ;; 
	 (?\x1D4DF . bidi-category-l) ;; 
	 (?\x1D4E0 . bidi-category-l) ;; 
	 (?\x1D4E1 . bidi-category-l) ;; 
	 (?\x1D4E2 . bidi-category-l) ;; 
	 (?\x1D4E3 . bidi-category-l) ;; 
	 (?\x1D4E4 . bidi-category-l) ;; 
	 (?\x1D4E5 . bidi-category-l) ;; 
	 (?\x1D4E6 . bidi-category-l) ;; 
	 (?\x1D4E7 . bidi-category-l) ;; 
	 (?\x1D4E8 . bidi-category-l) ;; 
	 (?\x1D4E9 . bidi-category-l) ;; 
	 (?\x1D4EA . bidi-category-l) ;; 
	 (?\x1D4EB . bidi-category-l) ;; 
	 (?\x1D4EC . bidi-category-l) ;; 
	 (?\x1D4ED . bidi-category-l) ;; 
	 (?\x1D4EE . bidi-category-l) ;; 
	 (?\x1D4EF . bidi-category-l) ;; 
	 (?\x1D4F0 . bidi-category-l) ;; 
	 (?\x1D4F1 . bidi-category-l) ;; 
	 (?\x1D4F2 . bidi-category-l) ;; 
	 (?\x1D4F3 . bidi-category-l) ;; 
	 (?\x1D4F4 . bidi-category-l) ;; 
	 (?\x1D4F5 . bidi-category-l) ;; 
	 (?\x1D4F6 . bidi-category-l) ;; 
	 (?\x1D4F7 . bidi-category-l) ;; 
	 (?\x1D4F8 . bidi-category-l) ;; 
	 (?\x1D4F9 . bidi-category-l) ;; 
	 (?\x1D4FA . bidi-category-l) ;; 
	 (?\x1D4FB . bidi-category-l) ;; 
	 (?\x1D4FC . bidi-category-l) ;; 
	 (?\x1D4FD . bidi-category-l) ;; 
	 (?\x1D4FE . bidi-category-l) ;; 
	 (?\x1D4FF . bidi-category-l) ;; 
	 (?\x1D500 . bidi-category-l) ;; 
	 (?\x1D501 . bidi-category-l) ;; 
	 (?\x1D502 . bidi-category-l) ;; 
	 (?\x1D503 . bidi-category-l) ;; 
	 (?\x1D504 . bidi-category-l) ;; 
	 (?\x1D505 . bidi-category-l) ;; 
	 (?\x1D507 . bidi-category-l) ;; 
	 (?\x1D508 . bidi-category-l) ;; 
	 (?\x1D509 . bidi-category-l) ;; 
	 (?\x1D50A . bidi-category-l) ;; 
	 (?\x1D50D . bidi-category-l) ;; 
	 (?\x1D50E . bidi-category-l) ;; 
	 (?\x1D50F . bidi-category-l) ;; 
	 (?\x1D510 . bidi-category-l) ;; 
	 (?\x1D511 . bidi-category-l) ;; 
	 (?\x1D512 . bidi-category-l) ;; 
	 (?\x1D513 . bidi-category-l) ;; 
	 (?\x1D514 . bidi-category-l) ;; 
	 (?\x1D516 . bidi-category-l) ;; 
	 (?\x1D517 . bidi-category-l) ;; 
	 (?\x1D518 . bidi-category-l) ;; 
	 (?\x1D519 . bidi-category-l) ;; 
	 (?\x1D51A . bidi-category-l) ;; 
	 (?\x1D51B . bidi-category-l) ;; 
	 (?\x1D51C . bidi-category-l) ;; 
	 (?\x1D51E . bidi-category-l) ;; 
	 (?\x1D51F . bidi-category-l) ;; 
	 (?\x1D520 . bidi-category-l) ;; 
	 (?\x1D521 . bidi-category-l) ;; 
	 (?\x1D522 . bidi-category-l) ;; 
	 (?\x1D523 . bidi-category-l) ;; 
	 (?\x1D524 . bidi-category-l) ;; 
	 (?\x1D525 . bidi-category-l) ;; 
	 (?\x1D526 . bidi-category-l) ;; 
	 (?\x1D527 . bidi-category-l) ;; 
	 (?\x1D528 . bidi-category-l) ;; 
	 (?\x1D529 . bidi-category-l) ;; 
	 (?\x1D52A . bidi-category-l) ;; 
	 (?\x1D52B . bidi-category-l) ;; 
	 (?\x1D52C . bidi-category-l) ;; 
	 (?\x1D52D . bidi-category-l) ;; 
	 (?\x1D52E . bidi-category-l) ;; 
	 (?\x1D52F . bidi-category-l) ;; 
	 (?\x1D530 . bidi-category-l) ;; 
	 (?\x1D531 . bidi-category-l) ;; 
	 (?\x1D532 . bidi-category-l) ;; 
	 (?\x1D533 . bidi-category-l) ;; 
	 (?\x1D534 . bidi-category-l) ;; 
	 (?\x1D535 . bidi-category-l) ;; 
	 (?\x1D536 . bidi-category-l) ;; 
	 (?\x1D537 . bidi-category-l) ;; 
	 (?\x1D538 . bidi-category-l) ;; 
	 (?\x1D539 . bidi-category-l) ;; 
	 (?\x1D53B . bidi-category-l) ;; 
	 (?\x1D53C . bidi-category-l) ;; 
	 (?\x1D53D . bidi-category-l) ;; 
	 (?\x1D53E . bidi-category-l) ;; 
	 (?\x1D540 . bidi-category-l) ;; 
	 (?\x1D541 . bidi-category-l) ;; 
	 (?\x1D542 . bidi-category-l) ;; 
	 (?\x1D543 . bidi-category-l) ;; 
	 (?\x1D544 . bidi-category-l) ;; 
	 (?\x1D546 . bidi-category-l) ;; 
	 (?\x1D54A . bidi-category-l) ;; 
	 (?\x1D54B . bidi-category-l) ;; 
	 (?\x1D54C . bidi-category-l) ;; 
	 (?\x1D54D . bidi-category-l) ;; 
	 (?\x1D54E . bidi-category-l) ;; 
	 (?\x1D54F . bidi-category-l) ;; 
	 (?\x1D550 . bidi-category-l) ;; 
	 (?\x1D552 . bidi-category-l) ;; 
	 (?\x1D553 . bidi-category-l) ;; 
	 (?\x1D554 . bidi-category-l) ;; 
	 (?\x1D555 . bidi-category-l) ;; 
	 (?\x1D556 . bidi-category-l) ;; 
	 (?\x1D557 . bidi-category-l) ;; 
	 (?\x1D558 . bidi-category-l) ;; 
	 (?\x1D559 . bidi-category-l) ;; 
	 (?\x1D55A . bidi-category-l) ;; 
	 (?\x1D55B . bidi-category-l) ;; 
	 (?\x1D55C . bidi-category-l) ;; 
	 (?\x1D55D . bidi-category-l) ;; 
	 (?\x1D55E . bidi-category-l) ;; 
	 (?\x1D55F . bidi-category-l) ;; 
	 (?\x1D560 . bidi-category-l) ;; 
	 (?\x1D561 . bidi-category-l) ;; 
	 (?\x1D562 . bidi-category-l) ;; 
	 (?\x1D563 . bidi-category-l) ;; 
	 (?\x1D564 . bidi-category-l) ;; 
	 (?\x1D565 . bidi-category-l) ;; 
	 (?\x1D566 . bidi-category-l) ;; 
	 (?\x1D567 . bidi-category-l) ;; 
	 (?\x1D568 . bidi-category-l) ;; 
	 (?\x1D569 . bidi-category-l) ;; 
	 (?\x1D56A . bidi-category-l) ;; 
	 (?\x1D56B . bidi-category-l) ;; 
	 (?\x1D56C . bidi-category-l) ;; 
	 (?\x1D56D . bidi-category-l) ;; 
	 (?\x1D56E . bidi-category-l) ;; 
	 (?\x1D56F . bidi-category-l) ;; 
	 (?\x1D570 . bidi-category-l) ;; 
	 (?\x1D571 . bidi-category-l) ;; 
	 (?\x1D572 . bidi-category-l) ;; 
	 (?\x1D573 . bidi-category-l) ;; 
	 (?\x1D574 . bidi-category-l) ;; 
	 (?\x1D575 . bidi-category-l) ;; 
	 (?\x1D576 . bidi-category-l) ;; 
	 (?\x1D577 . bidi-category-l) ;; 
	 (?\x1D578 . bidi-category-l) ;; 
	 (?\x1D579 . bidi-category-l) ;; 
	 (?\x1D57A . bidi-category-l) ;; 
	 (?\x1D57B . bidi-category-l) ;; 
	 (?\x1D57C . bidi-category-l) ;; 
	 (?\x1D57D . bidi-category-l) ;; 
	 (?\x1D57E . bidi-category-l) ;; 
	 (?\x1D57F . bidi-category-l) ;; 
	 (?\x1D580 . bidi-category-l) ;; 
	 (?\x1D581 . bidi-category-l) ;; 
	 (?\x1D582 . bidi-category-l) ;; 
	 (?\x1D583 . bidi-category-l) ;; 
	 (?\x1D584 . bidi-category-l) ;; 
	 (?\x1D585 . bidi-category-l) ;; 
	 (?\x1D586 . bidi-category-l) ;; 
	 (?\x1D587 . bidi-category-l) ;; 
	 (?\x1D588 . bidi-category-l) ;; 
	 (?\x1D589 . bidi-category-l) ;; 
	 (?\x1D58A . bidi-category-l) ;; 
	 (?\x1D58B . bidi-category-l) ;; 
	 (?\x1D58C . bidi-category-l) ;; 
	 (?\x1D58D . bidi-category-l) ;; 
	 (?\x1D58E . bidi-category-l) ;; 
	 (?\x1D58F . bidi-category-l) ;; 
	 (?\x1D590 . bidi-category-l) ;; 
	 (?\x1D591 . bidi-category-l) ;; 
	 (?\x1D592 . bidi-category-l) ;; 
	 (?\x1D593 . bidi-category-l) ;; 
	 (?\x1D594 . bidi-category-l) ;; 
	 (?\x1D595 . bidi-category-l) ;; 
	 (?\x1D596 . bidi-category-l) ;; 
	 (?\x1D597 . bidi-category-l) ;; 
	 (?\x1D598 . bidi-category-l) ;; 
	 (?\x1D599 . bidi-category-l) ;; 
	 (?\x1D59A . bidi-category-l) ;; 
	 (?\x1D59B . bidi-category-l) ;; 
	 (?\x1D59C . bidi-category-l) ;; 
	 (?\x1D59D . bidi-category-l) ;; 
	 (?\x1D59E . bidi-category-l) ;; 
	 (?\x1D59F . bidi-category-l) ;; 
	 (?\x1D5A0 . bidi-category-l) ;; 
	 (?\x1D5A1 . bidi-category-l) ;; 
	 (?\x1D5A2 . bidi-category-l) ;; 
	 (?\x1D5A3 . bidi-category-l) ;; 
	 (?\x1D5A4 . bidi-category-l) ;; 
	 (?\x1D5A5 . bidi-category-l) ;; 
	 (?\x1D5A6 . bidi-category-l) ;; 
	 (?\x1D5A7 . bidi-category-l) ;; 
	 (?\x1D5A8 . bidi-category-l) ;; 
	 (?\x1D5A9 . bidi-category-l) ;; 
	 (?\x1D5AA . bidi-category-l) ;; 
	 (?\x1D5AB . bidi-category-l) ;; 
	 (?\x1D5AC . bidi-category-l) ;; 
	 (?\x1D5AD . bidi-category-l) ;; 
	 (?\x1D5AE . bidi-category-l) ;; 
	 (?\x1D5AF . bidi-category-l) ;; 
	 (?\x1D5B0 . bidi-category-l) ;; 
	 (?\x1D5B1 . bidi-category-l) ;; 
	 (?\x1D5B2 . bidi-category-l) ;; 
	 (?\x1D5B3 . bidi-category-l) ;; 
	 (?\x1D5B4 . bidi-category-l) ;; 
	 (?\x1D5B5 . bidi-category-l) ;; 
	 (?\x1D5B6 . bidi-category-l) ;; 
	 (?\x1D5B7 . bidi-category-l) ;; 
	 (?\x1D5B8 . bidi-category-l) ;; 
	 (?\x1D5B9 . bidi-category-l) ;; 
	 (?\x1D5BA . bidi-category-l) ;; 
	 (?\x1D5BB . bidi-category-l) ;; 
	 (?\x1D5BC . bidi-category-l) ;; 
	 (?\x1D5BD . bidi-category-l) ;; 
	 (?\x1D5BE . bidi-category-l) ;; 
	 (?\x1D5BF . bidi-category-l) ;; 
	 (?\x1D5C0 . bidi-category-l) ;; 
	 (?\x1D5C1 . bidi-category-l) ;; 
	 (?\x1D5C2 . bidi-category-l) ;; 
	 (?\x1D5C3 . bidi-category-l) ;; 
	 (?\x1D5C4 . bidi-category-l) ;; 
	 (?\x1D5C5 . bidi-category-l) ;; 
	 (?\x1D5C6 . bidi-category-l) ;; 
	 (?\x1D5C7 . bidi-category-l) ;; 
	 (?\x1D5C8 . bidi-category-l) ;; 
	 (?\x1D5C9 . bidi-category-l) ;; 
	 (?\x1D5CA . bidi-category-l) ;; 
	 (?\x1D5CB . bidi-category-l) ;; 
	 (?\x1D5CC . bidi-category-l) ;; 
	 (?\x1D5CD . bidi-category-l) ;; 
	 (?\x1D5CE . bidi-category-l) ;; 
	 (?\x1D5CF . bidi-category-l) ;; 
	 (?\x1D5D0 . bidi-category-l) ;; 
	 (?\x1D5D1 . bidi-category-l) ;; 
	 (?\x1D5D2 . bidi-category-l) ;; 
	 (?\x1D5D3 . bidi-category-l) ;; 
	 (?\x1D5D4 . bidi-category-l) ;; 
	 (?\x1D5D5 . bidi-category-l) ;; 
	 (?\x1D5D6 . bidi-category-l) ;; 
	 (?\x1D5D7 . bidi-category-l) ;; 
	 (?\x1D5D8 . bidi-category-l) ;; 
	 (?\x1D5D9 . bidi-category-l) ;; 
	 (?\x1D5DA . bidi-category-l) ;; 
	 (?\x1D5DB . bidi-category-l) ;; 
	 (?\x1D5DC . bidi-category-l) ;; 
	 (?\x1D5DD . bidi-category-l) ;; 
	 (?\x1D5DE . bidi-category-l) ;; 
	 (?\x1D5DF . bidi-category-l) ;; 
	 (?\x1D5E0 . bidi-category-l) ;; 
	 (?\x1D5E1 . bidi-category-l) ;; 
	 (?\x1D5E2 . bidi-category-l) ;; 
	 (?\x1D5E3 . bidi-category-l) ;; 
	 (?\x1D5E4 . bidi-category-l) ;; 
	 (?\x1D5E5 . bidi-category-l) ;; 
	 (?\x1D5E6 . bidi-category-l) ;; 
	 (?\x1D5E7 . bidi-category-l) ;; 
	 (?\x1D5E8 . bidi-category-l) ;; 
	 (?\x1D5E9 . bidi-category-l) ;; 
	 (?\x1D5EA . bidi-category-l) ;; 
	 (?\x1D5EB . bidi-category-l) ;; 
	 (?\x1D5EC . bidi-category-l) ;; 
	 (?\x1D5ED . bidi-category-l) ;; 
	 (?\x1D5EE . bidi-category-l) ;; 
	 (?\x1D5EF . bidi-category-l) ;; 
	 (?\x1D5F0 . bidi-category-l) ;; 
	 (?\x1D5F1 . bidi-category-l) ;; 
	 (?\x1D5F2 . bidi-category-l) ;; 
	 (?\x1D5F3 . bidi-category-l) ;; 
	 (?\x1D5F4 . bidi-category-l) ;; 
	 (?\x1D5F5 . bidi-category-l) ;; 
	 (?\x1D5F6 . bidi-category-l) ;; 
	 (?\x1D5F7 . bidi-category-l) ;; 
	 (?\x1D5F8 . bidi-category-l) ;; 
	 (?\x1D5F9 . bidi-category-l) ;; 
	 (?\x1D5FA . bidi-category-l) ;; 
	 (?\x1D5FB . bidi-category-l) ;; 
	 (?\x1D5FC . bidi-category-l) ;; 
	 (?\x1D5FD . bidi-category-l) ;; 
	 (?\x1D5FE . bidi-category-l) ;; 
	 (?\x1D5FF . bidi-category-l) ;; 
	 (?\x1D600 . bidi-category-l) ;; 
	 (?\x1D601 . bidi-category-l) ;; 
	 (?\x1D602 . bidi-category-l) ;; 
	 (?\x1D603 . bidi-category-l) ;; 
	 (?\x1D604 . bidi-category-l) ;; 
	 (?\x1D605 . bidi-category-l) ;; 
	 (?\x1D606 . bidi-category-l) ;; 
	 (?\x1D607 . bidi-category-l) ;; 
	 (?\x1D608 . bidi-category-l) ;; 
	 (?\x1D609 . bidi-category-l) ;; 
	 (?\x1D60A . bidi-category-l) ;; 
	 (?\x1D60B . bidi-category-l) ;; 
	 (?\x1D60C . bidi-category-l) ;; 
	 (?\x1D60D . bidi-category-l) ;; 
	 (?\x1D60E . bidi-category-l) ;; 
	 (?\x1D60F . bidi-category-l) ;; 
	 (?\x1D610 . bidi-category-l) ;; 
	 (?\x1D611 . bidi-category-l) ;; 
	 (?\x1D612 . bidi-category-l) ;; 
	 (?\x1D613 . bidi-category-l) ;; 
	 (?\x1D614 . bidi-category-l) ;; 
	 (?\x1D615 . bidi-category-l) ;; 
	 (?\x1D616 . bidi-category-l) ;; 
	 (?\x1D617 . bidi-category-l) ;; 
	 (?\x1D618 . bidi-category-l) ;; 
	 (?\x1D619 . bidi-category-l) ;; 
	 (?\x1D61A . bidi-category-l) ;; 
	 (?\x1D61B . bidi-category-l) ;; 
	 (?\x1D61C . bidi-category-l) ;; 
	 (?\x1D61D . bidi-category-l) ;; 
	 (?\x1D61E . bidi-category-l) ;; 
	 (?\x1D61F . bidi-category-l) ;; 
	 (?\x1D620 . bidi-category-l) ;; 
	 (?\x1D621 . bidi-category-l) ;; 
	 (?\x1D622 . bidi-category-l) ;; 
	 (?\x1D623 . bidi-category-l) ;; 
	 (?\x1D624 . bidi-category-l) ;; 
	 (?\x1D625 . bidi-category-l) ;; 
	 (?\x1D626 . bidi-category-l) ;; 
	 (?\x1D627 . bidi-category-l) ;; 
	 (?\x1D628 . bidi-category-l) ;; 
	 (?\x1D629 . bidi-category-l) ;; 
	 (?\x1D62A . bidi-category-l) ;; 
	 (?\x1D62B . bidi-category-l) ;; 
	 (?\x1D62C . bidi-category-l) ;; 
	 (?\x1D62D . bidi-category-l) ;; 
	 (?\x1D62E . bidi-category-l) ;; 
	 (?\x1D62F . bidi-category-l) ;; 
	 (?\x1D630 . bidi-category-l) ;; 
	 (?\x1D631 . bidi-category-l) ;; 
	 (?\x1D632 . bidi-category-l) ;; 
	 (?\x1D633 . bidi-category-l) ;; 
	 (?\x1D634 . bidi-category-l) ;; 
	 (?\x1D635 . bidi-category-l) ;; 
	 (?\x1D636 . bidi-category-l) ;; 
	 (?\x1D637 . bidi-category-l) ;; 
	 (?\x1D638 . bidi-category-l) ;; 
	 (?\x1D639 . bidi-category-l) ;; 
	 (?\x1D63A . bidi-category-l) ;; 
	 (?\x1D63B . bidi-category-l) ;; 
	 (?\x1D63C . bidi-category-l) ;; 
	 (?\x1D63D . bidi-category-l) ;; 
	 (?\x1D63E . bidi-category-l) ;; 
	 (?\x1D63F . bidi-category-l) ;; 
	 (?\x1D640 . bidi-category-l) ;; 
	 (?\x1D641 . bidi-category-l) ;; 
	 (?\x1D642 . bidi-category-l) ;; 
	 (?\x1D643 . bidi-category-l) ;; 
	 (?\x1D644 . bidi-category-l) ;; 
	 (?\x1D645 . bidi-category-l) ;; 
	 (?\x1D646 . bidi-category-l) ;; 
	 (?\x1D647 . bidi-category-l) ;; 
	 (?\x1D648 . bidi-category-l) ;; 
	 (?\x1D649 . bidi-category-l) ;; 
	 (?\x1D64A . bidi-category-l) ;; 
	 (?\x1D64B . bidi-category-l) ;; 
	 (?\x1D64C . bidi-category-l) ;; 
	 (?\x1D64D . bidi-category-l) ;; 
	 (?\x1D64E . bidi-category-l) ;; 
	 (?\x1D64F . bidi-category-l) ;; 
	 (?\x1D650 . bidi-category-l) ;; 
	 (?\x1D651 . bidi-category-l) ;; 
	 (?\x1D652 . bidi-category-l) ;; 
	 (?\x1D653 . bidi-category-l) ;; 
	 (?\x1D654 . bidi-category-l) ;; 
	 (?\x1D655 . bidi-category-l) ;; 
	 (?\x1D656 . bidi-category-l) ;; 
	 (?\x1D657 . bidi-category-l) ;; 
	 (?\x1D658 . bidi-category-l) ;; 
	 (?\x1D659 . bidi-category-l) ;; 
	 (?\x1D65A . bidi-category-l) ;; 
	 (?\x1D65B . bidi-category-l) ;; 
	 (?\x1D65C . bidi-category-l) ;; 
	 (?\x1D65D . bidi-category-l) ;; 
	 (?\x1D65E . bidi-category-l) ;; 
	 (?\x1D65F . bidi-category-l) ;; 
	 (?\x1D660 . bidi-category-l) ;; 
	 (?\x1D661 . bidi-category-l) ;; 
	 (?\x1D662 . bidi-category-l) ;; 
	 (?\x1D663 . bidi-category-l) ;; 
	 (?\x1D664 . bidi-category-l) ;; 
	 (?\x1D665 . bidi-category-l) ;; 
	 (?\x1D666 . bidi-category-l) ;; 
	 (?\x1D667 . bidi-category-l) ;; 
	 (?\x1D668 . bidi-category-l) ;; 
	 (?\x1D669 . bidi-category-l) ;; 
	 (?\x1D66A . bidi-category-l) ;; 
	 (?\x1D66B . bidi-category-l) ;; 
	 (?\x1D66C . bidi-category-l) ;; 
	 (?\x1D66D . bidi-category-l) ;; 
	 (?\x1D66E . bidi-category-l) ;; 
	 (?\x1D66F . bidi-category-l) ;; 
	 (?\x1D670 . bidi-category-l) ;; 
	 (?\x1D671 . bidi-category-l) ;; 
	 (?\x1D672 . bidi-category-l) ;; 
	 (?\x1D673 . bidi-category-l) ;; 
	 (?\x1D674 . bidi-category-l) ;; 
	 (?\x1D675 . bidi-category-l) ;; 
	 (?\x1D676 . bidi-category-l) ;; 
	 (?\x1D677 . bidi-category-l) ;; 
	 (?\x1D678 . bidi-category-l) ;; 
	 (?\x1D679 . bidi-category-l) ;; 
	 (?\x1D67A . bidi-category-l) ;; 
	 (?\x1D67B . bidi-category-l) ;; 
	 (?\x1D67C . bidi-category-l) ;; 
	 (?\x1D67D . bidi-category-l) ;; 
	 (?\x1D67E . bidi-category-l) ;; 
	 (?\x1D67F . bidi-category-l) ;; 
	 (?\x1D680 . bidi-category-l) ;; 
	 (?\x1D681 . bidi-category-l) ;; 
	 (?\x1D682 . bidi-category-l) ;; 
	 (?\x1D683 . bidi-category-l) ;; 
	 (?\x1D684 . bidi-category-l) ;; 
	 (?\x1D685 . bidi-category-l) ;; 
	 (?\x1D686 . bidi-category-l) ;; 
	 (?\x1D687 . bidi-category-l) ;; 
	 (?\x1D688 . bidi-category-l) ;; 
	 (?\x1D689 . bidi-category-l) ;; 
	 (?\x1D68A . bidi-category-l) ;; 
	 (?\x1D68B . bidi-category-l) ;; 
	 (?\x1D68C . bidi-category-l) ;; 
	 (?\x1D68D . bidi-category-l) ;; 
	 (?\x1D68E . bidi-category-l) ;; 
	 (?\x1D68F . bidi-category-l) ;; 
	 (?\x1D690 . bidi-category-l) ;; 
	 (?\x1D691 . bidi-category-l) ;; 
	 (?\x1D692 . bidi-category-l) ;; 
	 (?\x1D693 . bidi-category-l) ;; 
	 (?\x1D694 . bidi-category-l) ;; 
	 (?\x1D695 . bidi-category-l) ;; 
	 (?\x1D696 . bidi-category-l) ;; 
	 (?\x1D697 . bidi-category-l) ;; 
	 (?\x1D698 . bidi-category-l) ;; 
	 (?\x1D699 . bidi-category-l) ;; 
	 (?\x1D69A . bidi-category-l) ;; 
	 (?\x1D69B . bidi-category-l) ;; 
	 (?\x1D69C . bidi-category-l) ;; 
	 (?\x1D69D . bidi-category-l) ;; 
	 (?\x1D69E . bidi-category-l) ;; 
	 (?\x1D69F . bidi-category-l) ;; 
	 (?\x1D6A0 . bidi-category-l) ;; 
	 (?\x1D6A1 . bidi-category-l) ;; 
	 (?\x1D6A2 . bidi-category-l) ;; 
	 (?\x1D6A3 . bidi-category-l) ;; 
	 (?\x1D6A8 . bidi-category-l) ;; 
	 (?\x1D6A9 . bidi-category-l) ;; 
	 (?\x1D6AA . bidi-category-l) ;; 
	 (?\x1D6AB . bidi-category-l) ;; 
	 (?\x1D6AC . bidi-category-l) ;; 
	 (?\x1D6AD . bidi-category-l) ;; 
	 (?\x1D6AE . bidi-category-l) ;; 
	 (?\x1D6AF . bidi-category-l) ;; 
	 (?\x1D6B0 . bidi-category-l) ;; 
	 (?\x1D6B1 . bidi-category-l) ;; 
	 (?\x1D6B2 . bidi-category-l) ;; 
	 (?\x1D6B3 . bidi-category-l) ;; 
	 (?\x1D6B4 . bidi-category-l) ;; 
	 (?\x1D6B5 . bidi-category-l) ;; 
	 (?\x1D6B6 . bidi-category-l) ;; 
	 (?\x1D6B7 . bidi-category-l) ;; 
	 (?\x1D6B8 . bidi-category-l) ;; 
	 (?\x1D6B9 . bidi-category-l) ;; 
	 (?\x1D6BA . bidi-category-l) ;; 
	 (?\x1D6BB . bidi-category-l) ;; 
	 (?\x1D6BC . bidi-category-l) ;; 
	 (?\x1D6BD . bidi-category-l) ;; 
	 (?\x1D6BE . bidi-category-l) ;; 
	 (?\x1D6BF . bidi-category-l) ;; 
	 (?\x1D6C0 . bidi-category-l) ;; 
	 (?\x1D6C1 . bidi-category-l) ;; 
	 (?\x1D6C2 . bidi-category-l) ;; 
	 (?\x1D6C3 . bidi-category-l) ;; 
	 (?\x1D6C4 . bidi-category-l) ;; 
	 (?\x1D6C5 . bidi-category-l) ;; 
	 (?\x1D6C6 . bidi-category-l) ;; 
	 (?\x1D6C7 . bidi-category-l) ;; 
	 (?\x1D6C8 . bidi-category-l) ;; 
	 (?\x1D6C9 . bidi-category-l) ;; 
	 (?\x1D6CA . bidi-category-l) ;; 
	 (?\x1D6CB . bidi-category-l) ;; 
	 (?\x1D6CC . bidi-category-l) ;; 
	 (?\x1D6CD . bidi-category-l) ;; 
	 (?\x1D6CE . bidi-category-l) ;; 
	 (?\x1D6CF . bidi-category-l) ;; 
	 (?\x1D6D0 . bidi-category-l) ;; 
	 (?\x1D6D1 . bidi-category-l) ;; 
	 (?\x1D6D2 . bidi-category-l) ;; 
	 (?\x1D6D3 . bidi-category-l) ;; 
	 (?\x1D6D4 . bidi-category-l) ;; 
	 (?\x1D6D5 . bidi-category-l) ;; 
	 (?\x1D6D6 . bidi-category-l) ;; 
	 (?\x1D6D7 . bidi-category-l) ;; 
	 (?\x1D6D8 . bidi-category-l) ;; 
	 (?\x1D6D9 . bidi-category-l) ;; 
	 (?\x1D6DA . bidi-category-l) ;; 
	 (?\x1D6DB . bidi-category-l) ;; 
	 (?\x1D6DC . bidi-category-l) ;; 
	 (?\x1D6DD . bidi-category-l) ;; 
	 (?\x1D6DE . bidi-category-l) ;; 
	 (?\x1D6DF . bidi-category-l) ;; 
	 (?\x1D6E0 . bidi-category-l) ;; 
	 (?\x1D6E1 . bidi-category-l) ;; 
	 (?\x1D6E2 . bidi-category-l) ;; 
	 (?\x1D6E3 . bidi-category-l) ;; 
	 (?\x1D6E4 . bidi-category-l) ;; 
	 (?\x1D6E5 . bidi-category-l) ;; 
	 (?\x1D6E6 . bidi-category-l) ;; 
	 (?\x1D6E7 . bidi-category-l) ;; 
	 (?\x1D6E8 . bidi-category-l) ;; 
	 (?\x1D6E9 . bidi-category-l) ;; 
	 (?\x1D6EA . bidi-category-l) ;; 
	 (?\x1D6EB . bidi-category-l) ;; 
	 (?\x1D6EC . bidi-category-l) ;; 
	 (?\x1D6ED . bidi-category-l) ;; 
	 (?\x1D6EE . bidi-category-l) ;; 
	 (?\x1D6EF . bidi-category-l) ;; 
	 (?\x1D6F0 . bidi-category-l) ;; 
	 (?\x1D6F1 . bidi-category-l) ;; 
	 (?\x1D6F2 . bidi-category-l) ;; 
	 (?\x1D6F3 . bidi-category-l) ;; 
	 (?\x1D6F4 . bidi-category-l) ;; 
	 (?\x1D6F5 . bidi-category-l) ;; 
	 (?\x1D6F6 . bidi-category-l) ;; 
	 (?\x1D6F7 . bidi-category-l) ;; 
	 (?\x1D6F8 . bidi-category-l) ;; 
	 (?\x1D6F9 . bidi-category-l) ;; 
	 (?\x1D6FA . bidi-category-l) ;; 
	 (?\x1D6FB . bidi-category-l) ;; 
	 (?\x1D6FC . bidi-category-l) ;; 
	 (?\x1D6FD . bidi-category-l) ;; 
	 (?\x1D6FE . bidi-category-l) ;; 
	 (?\x1D6FF . bidi-category-l) ;; 
	 (?\x1D700 . bidi-category-l) ;; 
	 (?\x1D701 . bidi-category-l) ;; 
	 (?\x1D702 . bidi-category-l) ;; 
	 (?\x1D703 . bidi-category-l) ;; 
	 (?\x1D704 . bidi-category-l) ;; 
	 (?\x1D705 . bidi-category-l) ;; 
	 (?\x1D706 . bidi-category-l) ;; 
	 (?\x1D707 . bidi-category-l) ;; 
	 (?\x1D708 . bidi-category-l) ;; 
	 (?\x1D709 . bidi-category-l) ;; 
	 (?\x1D70A . bidi-category-l) ;; 
	 (?\x1D70B . bidi-category-l) ;; 
	 (?\x1D70C . bidi-category-l) ;; 
	 (?\x1D70D . bidi-category-l) ;; 
	 (?\x1D70E . bidi-category-l) ;; 
	 (?\x1D70F . bidi-category-l) ;; 
	 (?\x1D710 . bidi-category-l) ;; 
	 (?\x1D711 . bidi-category-l) ;; 
	 (?\x1D712 . bidi-category-l) ;; 
	 (?\x1D713 . bidi-category-l) ;; 
	 (?\x1D714 . bidi-category-l) ;; 
	 (?\x1D715 . bidi-category-l) ;; 
	 (?\x1D716 . bidi-category-l) ;; 
	 (?\x1D717 . bidi-category-l) ;; 
	 (?\x1D718 . bidi-category-l) ;; 
	 (?\x1D719 . bidi-category-l) ;; 
	 (?\x1D71A . bidi-category-l) ;; 
	 (?\x1D71B . bidi-category-l) ;; 
	 (?\x1D71C . bidi-category-l) ;; 
	 (?\x1D71D . bidi-category-l) ;; 
	 (?\x1D71E . bidi-category-l) ;; 
	 (?\x1D71F . bidi-category-l) ;; 
	 (?\x1D720 . bidi-category-l) ;; 
	 (?\x1D721 . bidi-category-l) ;; 
	 (?\x1D722 . bidi-category-l) ;; 
	 (?\x1D723 . bidi-category-l) ;; 
	 (?\x1D724 . bidi-category-l) ;; 
	 (?\x1D725 . bidi-category-l) ;; 
	 (?\x1D726 . bidi-category-l) ;; 
	 (?\x1D727 . bidi-category-l) ;; 
	 (?\x1D728 . bidi-category-l) ;; 
	 (?\x1D729 . bidi-category-l) ;; 
	 (?\x1D72A . bidi-category-l) ;; 
	 (?\x1D72B . bidi-category-l) ;; 
	 (?\x1D72C . bidi-category-l) ;; 
	 (?\x1D72D . bidi-category-l) ;; 
	 (?\x1D72E . bidi-category-l) ;; 
	 (?\x1D72F . bidi-category-l) ;; 
	 (?\x1D730 . bidi-category-l) ;; 
	 (?\x1D731 . bidi-category-l) ;; 
	 (?\x1D732 . bidi-category-l) ;; 
	 (?\x1D733 . bidi-category-l) ;; 
	 (?\x1D734 . bidi-category-l) ;; 
	 (?\x1D735 . bidi-category-l) ;; 
	 (?\x1D736 . bidi-category-l) ;; 
	 (?\x1D737 . bidi-category-l) ;; 
	 (?\x1D738 . bidi-category-l) ;; 
	 (?\x1D739 . bidi-category-l) ;; 
	 (?\x1D73A . bidi-category-l) ;; 
	 (?\x1D73B . bidi-category-l) ;; 
	 (?\x1D73C . bidi-category-l) ;; 
	 (?\x1D73D . bidi-category-l) ;; 
	 (?\x1D73E . bidi-category-l) ;; 
	 (?\x1D73F . bidi-category-l) ;; 
	 (?\x1D740 . bidi-category-l) ;; 
	 (?\x1D741 . bidi-category-l) ;; 
	 (?\x1D742 . bidi-category-l) ;; 
	 (?\x1D743 . bidi-category-l) ;; 
	 (?\x1D744 . bidi-category-l) ;; 
	 (?\x1D745 . bidi-category-l) ;; 
	 (?\x1D746 . bidi-category-l) ;; 
	 (?\x1D747 . bidi-category-l) ;; 
	 (?\x1D748 . bidi-category-l) ;; 
	 (?\x1D749 . bidi-category-l) ;; 
	 (?\x1D74A . bidi-category-l) ;; 
	 (?\x1D74B . bidi-category-l) ;; 
	 (?\x1D74C . bidi-category-l) ;; 
	 (?\x1D74D . bidi-category-l) ;; 
	 (?\x1D74E . bidi-category-l) ;; 
	 (?\x1D74F . bidi-category-l) ;; 
	 (?\x1D750 . bidi-category-l) ;; 
	 (?\x1D751 . bidi-category-l) ;; 
	 (?\x1D752 . bidi-category-l) ;; 
	 (?\x1D753 . bidi-category-l) ;; 
	 (?\x1D754 . bidi-category-l) ;; 
	 (?\x1D755 . bidi-category-l) ;; 
	 (?\x1D756 . bidi-category-l) ;; 
	 (?\x1D757 . bidi-category-l) ;; 
	 (?\x1D758 . bidi-category-l) ;; 
	 (?\x1D759 . bidi-category-l) ;; 
	 (?\x1D75A . bidi-category-l) ;; 
	 (?\x1D75B . bidi-category-l) ;; 
	 (?\x1D75C . bidi-category-l) ;; 
	 (?\x1D75D . bidi-category-l) ;; 
	 (?\x1D75E . bidi-category-l) ;; 
	 (?\x1D75F . bidi-category-l) ;; 
	 (?\x1D760 . bidi-category-l) ;; 
	 (?\x1D761 . bidi-category-l) ;; 
	 (?\x1D762 . bidi-category-l) ;; 
	 (?\x1D763 . bidi-category-l) ;; 
	 (?\x1D764 . bidi-category-l) ;; 
	 (?\x1D765 . bidi-category-l) ;; 
	 (?\x1D766 . bidi-category-l) ;; 
	 (?\x1D767 . bidi-category-l) ;; 
	 (?\x1D768 . bidi-category-l) ;; 
	 (?\x1D769 . bidi-category-l) ;; 
	 (?\x1D76A . bidi-category-l) ;; 
	 (?\x1D76B . bidi-category-l) ;; 
	 (?\x1D76C . bidi-category-l) ;; 
	 (?\x1D76D . bidi-category-l) ;; 
	 (?\x1D76E . bidi-category-l) ;; 
	 (?\x1D76F . bidi-category-l) ;; 
	 (?\x1D770 . bidi-category-l) ;; 
	 (?\x1D771 . bidi-category-l) ;; 
	 (?\x1D772 . bidi-category-l) ;; 
	 (?\x1D773 . bidi-category-l) ;; 
	 (?\x1D774 . bidi-category-l) ;; 
	 (?\x1D775 . bidi-category-l) ;; 
	 (?\x1D776 . bidi-category-l) ;; 
	 (?\x1D777 . bidi-category-l) ;; 
	 (?\x1D778 . bidi-category-l) ;; 
	 (?\x1D779 . bidi-category-l) ;; 
	 (?\x1D77A . bidi-category-l) ;; 
	 (?\x1D77B . bidi-category-l) ;; 
	 (?\x1D77C . bidi-category-l) ;; 
	 (?\x1D77D . bidi-category-l) ;; 
	 (?\x1D77E . bidi-category-l) ;; 
	 (?\x1D77F . bidi-category-l) ;; 
	 (?\x1D780 . bidi-category-l) ;; 
	 (?\x1D781 . bidi-category-l) ;; 
	 (?\x1D782 . bidi-category-l) ;; 
	 (?\x1D783 . bidi-category-l) ;; 
	 (?\x1D784 . bidi-category-l) ;; 
	 (?\x1D785 . bidi-category-l) ;; 
	 (?\x1D786 . bidi-category-l) ;; 
	 (?\x1D787 . bidi-category-l) ;; 
	 (?\x1D788 . bidi-category-l) ;; 
	 (?\x1D789 . bidi-category-l) ;; 
	 (?\x1D78A . bidi-category-l) ;; 
	 (?\x1D78B . bidi-category-l) ;; 
	 (?\x1D78C . bidi-category-l) ;; 
	 (?\x1D78D . bidi-category-l) ;; 
	 (?\x1D78E . bidi-category-l) ;; 
	 (?\x1D78F . bidi-category-l) ;; 
	 (?\x1D790 . bidi-category-l) ;; 
	 (?\x1D791 . bidi-category-l) ;; 
	 (?\x1D792 . bidi-category-l) ;; 
	 (?\x1D793 . bidi-category-l) ;; 
	 (?\x1D794 . bidi-category-l) ;; 
	 (?\x1D795 . bidi-category-l) ;; 
	 (?\x1D796 . bidi-category-l) ;; 
	 (?\x1D797 . bidi-category-l) ;; 
	 (?\x1D798 . bidi-category-l) ;; 
	 (?\x1D799 . bidi-category-l) ;; 
	 (?\x1D79A . bidi-category-l) ;; 
	 (?\x1D79B . bidi-category-l) ;; 
	 (?\x1D79C . bidi-category-l) ;; 
	 (?\x1D79D . bidi-category-l) ;; 
	 (?\x1D79E . bidi-category-l) ;; 
	 (?\x1D79F . bidi-category-l) ;; 
	 (?\x1D7A0 . bidi-category-l) ;; 
	 (?\x1D7A1 . bidi-category-l) ;; 
	 (?\x1D7A2 . bidi-category-l) ;; 
	 (?\x1D7A3 . bidi-category-l) ;; 
	 (?\x1D7A4 . bidi-category-l) ;; 
	 (?\x1D7A5 . bidi-category-l) ;; 
	 (?\x1D7A6 . bidi-category-l) ;; 
	 (?\x1D7A7 . bidi-category-l) ;; 
	 (?\x1D7A8 . bidi-category-l) ;; 
	 (?\x1D7A9 . bidi-category-l) ;; 
	 (?\x1D7AA . bidi-category-l) ;; 
	 (?\x1D7AB . bidi-category-l) ;; 
	 (?\x1D7AC . bidi-category-l) ;; 
	 (?\x1D7AD . bidi-category-l) ;; 
	 (?\x1D7AE . bidi-category-l) ;; 
	 (?\x1D7AF . bidi-category-l) ;; 
	 (?\x1D7B0 . bidi-category-l) ;; 
	 (?\x1D7B1 . bidi-category-l) ;; 
	 (?\x1D7B2 . bidi-category-l) ;; 
	 (?\x1D7B3 . bidi-category-l) ;; 
	 (?\x1D7B4 . bidi-category-l) ;; 
	 (?\x1D7B5 . bidi-category-l) ;; 
	 (?\x1D7B6 . bidi-category-l) ;; 
	 (?\x1D7B7 . bidi-category-l) ;; 
	 (?\x1D7B8 . bidi-category-l) ;; 
	 (?\x1D7B9 . bidi-category-l) ;; 
	 (?\x1D7BA . bidi-category-l) ;; 
	 (?\x1D7BB . bidi-category-l) ;; 
	 (?\x1D7BC . bidi-category-l) ;; 
	 (?\x1D7BD . bidi-category-l) ;; 
	 (?\x1D7BE . bidi-category-l) ;; 
	 (?\x1D7BF . bidi-category-l) ;; 
	 (?\x1D7C0 . bidi-category-l) ;; 
	 (?\x1D7C1 . bidi-category-l) ;; 
	 (?\x1D7C2 . bidi-category-l) ;; 
	 (?\x1D7C3 . bidi-category-l) ;; 
	 (?\x1D7C4 . bidi-category-l) ;; 
	 (?\x1D7C5 . bidi-category-l) ;; 
	 (?\x1D7C6 . bidi-category-l) ;; 
	 (?\x1D7C7 . bidi-category-l) ;; 
	 (?\x1D7C8 . bidi-category-l) ;; 
	 (?\x1D7C9 . bidi-category-l) ;; 
	 (?\x1D7CE . bidi-category-en) ;; 
	 (?\x1D7CF . bidi-category-en) ;; 
	 (?\x1D7D0 . bidi-category-en) ;; 
	 (?\x1D7D1 . bidi-category-en) ;; 
	 (?\x1D7D2 . bidi-category-en) ;; 
	 (?\x1D7D3 . bidi-category-en) ;; 
	 (?\x1D7D4 . bidi-category-en) ;; 
	 (?\x1D7D5 . bidi-category-en) ;; 
	 (?\x1D7D6 . bidi-category-en) ;; 
	 (?\x1D7D7 . bidi-category-en) ;; 
	 (?\x1D7D8 . bidi-category-en) ;; 
	 (?\x1D7D9 . bidi-category-en) ;; 
	 (?\x1D7DA . bidi-category-en) ;; 
	 (?\x1D7DB . bidi-category-en) ;; 
	 (?\x1D7DC . bidi-category-en) ;; 
	 (?\x1D7DD . bidi-category-en) ;; 
	 (?\x1D7DE . bidi-category-en) ;; 
	 (?\x1D7DF . bidi-category-en) ;; 
	 (?\x1D7E0 . bidi-category-en) ;; 
	 (?\x1D7E1 . bidi-category-en) ;; 
	 (?\x1D7E2 . bidi-category-en) ;; 
	 (?\x1D7E3 . bidi-category-en) ;; 
	 (?\x1D7E4 . bidi-category-en) ;; 
	 (?\x1D7E5 . bidi-category-en) ;; 
	 (?\x1D7E6 . bidi-category-en) ;; 
	 (?\x1D7E7 . bidi-category-en) ;; 
	 (?\x1D7E8 . bidi-category-en) ;; 
	 (?\x1D7E9 . bidi-category-en) ;; 
	 (?\x1D7EA . bidi-category-en) ;; 
	 (?\x1D7EB . bidi-category-en) ;; 
	 (?\x1D7EC . bidi-category-en) ;; 
	 (?\x1D7ED . bidi-category-en) ;; 
	 (?\x1D7EE . bidi-category-en) ;; 
	 (?\x1D7EF . bidi-category-en) ;; 
	 (?\x1D7F0 . bidi-category-en) ;; 
	 (?\x1D7F1 . bidi-category-en) ;; 
	 (?\x1D7F2 . bidi-category-en) ;; 
	 (?\x1D7F3 . bidi-category-en) ;; 
	 (?\x1D7F4 . bidi-category-en) ;; 
	 (?\x1D7F5 . bidi-category-en) ;; 
	 (?\x1D7F6 . bidi-category-en) ;; 
	 (?\x1D7F7 . bidi-category-en) ;; 
	 (?\x1D7F8 . bidi-category-en) ;; 
	 (?\x1D7F9 . bidi-category-en) ;; 
	 (?\x1D7FA . bidi-category-en) ;; 
	 (?\x1D7FB . bidi-category-en) ;; 
	 (?\x1D7FC . bidi-category-en) ;; 
	 (?\x1D7FD . bidi-category-en) ;; 
	 (?\x1D7FE . bidi-category-en) ;; 
	 (?\x1D7FF . bidi-category-en) ;; 
	 (?\x20000 . bidi-category-l) ;; 
	 (?\x2A6D6 . bidi-category-l) ;; 
	 (?\x2F800 . bidi-category-l) ;; 
	 (?\x2F801 . bidi-category-l) ;; 
	 (?\x2F802 . bidi-category-l) ;; 
	 (?\x2F803 . bidi-category-l) ;; 
	 (?\x2F804 . bidi-category-l) ;; 
	 (?\x2F805 . bidi-category-l) ;; 
	 (?\x2F806 . bidi-category-l) ;; 
	 (?\x2F807 . bidi-category-l) ;; 
	 (?\x2F808 . bidi-category-l) ;; 
	 (?\x2F809 . bidi-category-l) ;; 
	 (?\x2F80A . bidi-category-l) ;; 
	 (?\x2F80B . bidi-category-l) ;; 
	 (?\x2F80C . bidi-category-l) ;; 
	 (?\x2F80D . bidi-category-l) ;; 
	 (?\x2F80E . bidi-category-l) ;; 
	 (?\x2F80F . bidi-category-l) ;; 
	 (?\x2F810 . bidi-category-l) ;; 
	 (?\x2F811 . bidi-category-l) ;; 
	 (?\x2F812 . bidi-category-l) ;; 
	 (?\x2F813 . bidi-category-l) ;; 
	 (?\x2F814 . bidi-category-l) ;; 
	 (?\x2F815 . bidi-category-l) ;; 
	 (?\x2F816 . bidi-category-l) ;; 
	 (?\x2F817 . bidi-category-l) ;; 
	 (?\x2F818 . bidi-category-l) ;; 
	 (?\x2F819 . bidi-category-l) ;; 
	 (?\x2F81A . bidi-category-l) ;; 
	 (?\x2F81B . bidi-category-l) ;; 
	 (?\x2F81C . bidi-category-l) ;; 
	 (?\x2F81D . bidi-category-l) ;; 
	 (?\x2F81E . bidi-category-l) ;; 
	 (?\x2F81F . bidi-category-l) ;; 
	 (?\x2F820 . bidi-category-l) ;; 
	 (?\x2F821 . bidi-category-l) ;; 
	 (?\x2F822 . bidi-category-l) ;; 
	 (?\x2F823 . bidi-category-l) ;; 
	 (?\x2F824 . bidi-category-l) ;; 
	 (?\x2F825 . bidi-category-l) ;; 
	 (?\x2F826 . bidi-category-l) ;; 
	 (?\x2F827 . bidi-category-l) ;; 
	 (?\x2F828 . bidi-category-l) ;; 
	 (?\x2F829 . bidi-category-l) ;; 
	 (?\x2F82A . bidi-category-l) ;; 
	 (?\x2F82B . bidi-category-l) ;; 
	 (?\x2F82C . bidi-category-l) ;; 
	 (?\x2F82D . bidi-category-l) ;; 
	 (?\x2F82E . bidi-category-l) ;; 
	 (?\x2F82F . bidi-category-l) ;; 
	 (?\x2F830 . bidi-category-l) ;; 
	 (?\x2F831 . bidi-category-l) ;; 
	 (?\x2F832 . bidi-category-l) ;; 
	 (?\x2F833 . bidi-category-l) ;; 
	 (?\x2F834 . bidi-category-l) ;; 
	 (?\x2F835 . bidi-category-l) ;; 
	 (?\x2F836 . bidi-category-l) ;; 
	 (?\x2F837 . bidi-category-l) ;; 
	 (?\x2F838 . bidi-category-l) ;; 
	 (?\x2F839 . bidi-category-l) ;; 
	 (?\x2F83A . bidi-category-l) ;; 
	 (?\x2F83B . bidi-category-l) ;; 
	 (?\x2F83C . bidi-category-l) ;; 
	 (?\x2F83D . bidi-category-l) ;; 
	 (?\x2F83E . bidi-category-l) ;; 
	 (?\x2F83F . bidi-category-l) ;; 
	 (?\x2F840 . bidi-category-l) ;; 
	 (?\x2F841 . bidi-category-l) ;; 
	 (?\x2F842 . bidi-category-l) ;; 
	 (?\x2F843 . bidi-category-l) ;; 
	 (?\x2F844 . bidi-category-l) ;; 
	 (?\x2F845 . bidi-category-l) ;; 
	 (?\x2F846 . bidi-category-l) ;; 
	 (?\x2F847 . bidi-category-l) ;; 
	 (?\x2F848 . bidi-category-l) ;; 
	 (?\x2F849 . bidi-category-l) ;; 
	 (?\x2F84A . bidi-category-l) ;; 
	 (?\x2F84B . bidi-category-l) ;; 
	 (?\x2F84C . bidi-category-l) ;; 
	 (?\x2F84D . bidi-category-l) ;; 
	 (?\x2F84E . bidi-category-l) ;; 
	 (?\x2F84F . bidi-category-l) ;; 
	 (?\x2F850 . bidi-category-l) ;; 
	 (?\x2F851 . bidi-category-l) ;; 
	 (?\x2F852 . bidi-category-l) ;; 
	 (?\x2F853 . bidi-category-l) ;; 
	 (?\x2F854 . bidi-category-l) ;; 
	 (?\x2F855 . bidi-category-l) ;; 
	 (?\x2F856 . bidi-category-l) ;; 
	 (?\x2F857 . bidi-category-l) ;; 
	 (?\x2F858 . bidi-category-l) ;; 
	 (?\x2F859 . bidi-category-l) ;; 
	 (?\x2F85A . bidi-category-l) ;; 
	 (?\x2F85B . bidi-category-l) ;; 
	 (?\x2F85C . bidi-category-l) ;; 
	 (?\x2F85D . bidi-category-l) ;; 
	 (?\x2F85E . bidi-category-l) ;; 
	 (?\x2F85F . bidi-category-l) ;; 
	 (?\x2F860 . bidi-category-l) ;; 
	 (?\x2F861 . bidi-category-l) ;; 
	 (?\x2F862 . bidi-category-l) ;; 
	 (?\x2F863 . bidi-category-l) ;; 
	 (?\x2F864 . bidi-category-l) ;; 
	 (?\x2F865 . bidi-category-l) ;; 
	 (?\x2F866 . bidi-category-l) ;; 
	 (?\x2F867 . bidi-category-l) ;; 
	 (?\x2F868 . bidi-category-l) ;; 
	 (?\x2F869 . bidi-category-l) ;; 
	 (?\x2F86A . bidi-category-l) ;; 
	 (?\x2F86B . bidi-category-l) ;; 
	 (?\x2F86C . bidi-category-l) ;; 
	 (?\x2F86D . bidi-category-l) ;; 
	 (?\x2F86E . bidi-category-l) ;; 
	 (?\x2F86F . bidi-category-l) ;; 
	 (?\x2F870 . bidi-category-l) ;; 
	 (?\x2F871 . bidi-category-l) ;; 
	 (?\x2F872 . bidi-category-l) ;; 
	 (?\x2F873 . bidi-category-l) ;; 
	 (?\x2F874 . bidi-category-l) ;; 
	 (?\x2F875 . bidi-category-l) ;; 
	 (?\x2F876 . bidi-category-l) ;; 
	 (?\x2F877 . bidi-category-l) ;; 
	 (?\x2F878 . bidi-category-l) ;; 
	 (?\x2F879 . bidi-category-l) ;; 
	 (?\x2F87A . bidi-category-l) ;; 
	 (?\x2F87B . bidi-category-l) ;; 
	 (?\x2F87C . bidi-category-l) ;; 
	 (?\x2F87D . bidi-category-l) ;; 
	 (?\x2F87E . bidi-category-l) ;; 
	 (?\x2F87F . bidi-category-l) ;; 
	 (?\x2F880 . bidi-category-l) ;; 
	 (?\x2F881 . bidi-category-l) ;; 
	 (?\x2F882 . bidi-category-l) ;; 
	 (?\x2F883 . bidi-category-l) ;; 
	 (?\x2F884 . bidi-category-l) ;; 
	 (?\x2F885 . bidi-category-l) ;; 
	 (?\x2F886 . bidi-category-l) ;; 
	 (?\x2F887 . bidi-category-l) ;; 
	 (?\x2F888 . bidi-category-l) ;; 
	 (?\x2F889 . bidi-category-l) ;; 
	 (?\x2F88A . bidi-category-l) ;; 
	 (?\x2F88B . bidi-category-l) ;; 
	 (?\x2F88C . bidi-category-l) ;; 
	 (?\x2F88D . bidi-category-l) ;; 
	 (?\x2F88E . bidi-category-l) ;; 
	 (?\x2F88F . bidi-category-l) ;; 
	 (?\x2F890 . bidi-category-l) ;; 
	 (?\x2F891 . bidi-category-l) ;; 
	 (?\x2F892 . bidi-category-l) ;; 
	 (?\x2F893 . bidi-category-l) ;; 
	 (?\x2F894 . bidi-category-l) ;; 
	 (?\x2F895 . bidi-category-l) ;; 
	 (?\x2F896 . bidi-category-l) ;; 
	 (?\x2F897 . bidi-category-l) ;; 
	 (?\x2F898 . bidi-category-l) ;; 
	 (?\x2F899 . bidi-category-l) ;; 
	 (?\x2F89A . bidi-category-l) ;; 
	 (?\x2F89B . bidi-category-l) ;; 
	 (?\x2F89C . bidi-category-l) ;; 
	 (?\x2F89D . bidi-category-l) ;; 
	 (?\x2F89E . bidi-category-l) ;; 
	 (?\x2F89F . bidi-category-l) ;; 
	 (?\x2F8A0 . bidi-category-l) ;; 
	 (?\x2F8A1 . bidi-category-l) ;; 
	 (?\x2F8A2 . bidi-category-l) ;; 
	 (?\x2F8A3 . bidi-category-l) ;; 
	 (?\x2F8A4 . bidi-category-l) ;; 
	 (?\x2F8A5 . bidi-category-l) ;; 
	 (?\x2F8A6 . bidi-category-l) ;; 
	 (?\x2F8A7 . bidi-category-l) ;; 
	 (?\x2F8A8 . bidi-category-l) ;; 
	 (?\x2F8A9 . bidi-category-l) ;; 
	 (?\x2F8AA . bidi-category-l) ;; 
	 (?\x2F8AB . bidi-category-l) ;; 
	 (?\x2F8AC . bidi-category-l) ;; 
	 (?\x2F8AD . bidi-category-l) ;; 
	 (?\x2F8AE . bidi-category-l) ;; 
	 (?\x2F8AF . bidi-category-l) ;; 
	 (?\x2F8B0 . bidi-category-l) ;; 
	 (?\x2F8B1 . bidi-category-l) ;; 
	 (?\x2F8B2 . bidi-category-l) ;; 
	 (?\x2F8B3 . bidi-category-l) ;; 
	 (?\x2F8B4 . bidi-category-l) ;; 
	 (?\x2F8B5 . bidi-category-l) ;; 
	 (?\x2F8B6 . bidi-category-l) ;; 
	 (?\x2F8B7 . bidi-category-l) ;; 
	 (?\x2F8B8 . bidi-category-l) ;; 
	 (?\x2F8B9 . bidi-category-l) ;; 
	 (?\x2F8BA . bidi-category-l) ;; 
	 (?\x2F8BB . bidi-category-l) ;; 
	 (?\x2F8BC . bidi-category-l) ;; 
	 (?\x2F8BD . bidi-category-l) ;; 
	 (?\x2F8BE . bidi-category-l) ;; 
	 (?\x2F8BF . bidi-category-l) ;; 
	 (?\x2F8C0 . bidi-category-l) ;; 
	 (?\x2F8C1 . bidi-category-l) ;; 
	 (?\x2F8C2 . bidi-category-l) ;; 
	 (?\x2F8C3 . bidi-category-l) ;; 
	 (?\x2F8C4 . bidi-category-l) ;; 
	 (?\x2F8C5 . bidi-category-l) ;; 
	 (?\x2F8C6 . bidi-category-l) ;; 
	 (?\x2F8C7 . bidi-category-l) ;; 
	 (?\x2F8C8 . bidi-category-l) ;; 
	 (?\x2F8C9 . bidi-category-l) ;; 
	 (?\x2F8CA . bidi-category-l) ;; 
	 (?\x2F8CB . bidi-category-l) ;; 
	 (?\x2F8CC . bidi-category-l) ;; 
	 (?\x2F8CD . bidi-category-l) ;; 
	 (?\x2F8CE . bidi-category-l) ;; 
	 (?\x2F8CF . bidi-category-l) ;; 
	 (?\x2F8D0 . bidi-category-l) ;; 
	 (?\x2F8D1 . bidi-category-l) ;; 
	 (?\x2F8D2 . bidi-category-l) ;; 
	 (?\x2F8D3 . bidi-category-l) ;; 
	 (?\x2F8D4 . bidi-category-l) ;; 
	 (?\x2F8D5 . bidi-category-l) ;; 
	 (?\x2F8D6 . bidi-category-l) ;; 
	 (?\x2F8D7 . bidi-category-l) ;; 
	 (?\x2F8D8 . bidi-category-l) ;; 
	 (?\x2F8D9 . bidi-category-l) ;; 
	 (?\x2F8DA . bidi-category-l) ;; 
	 (?\x2F8DB . bidi-category-l) ;; 
	 (?\x2F8DC . bidi-category-l) ;; 
	 (?\x2F8DD . bidi-category-l) ;; 
	 (?\x2F8DE . bidi-category-l) ;; 
	 (?\x2F8DF . bidi-category-l) ;; 
	 (?\x2F8E0 . bidi-category-l) ;; 
	 (?\x2F8E1 . bidi-category-l) ;; 
	 (?\x2F8E2 . bidi-category-l) ;; 
	 (?\x2F8E3 . bidi-category-l) ;; 
	 (?\x2F8E4 . bidi-category-l) ;; 
	 (?\x2F8E5 . bidi-category-l) ;; 
	 (?\x2F8E6 . bidi-category-l) ;; 
	 (?\x2F8E7 . bidi-category-l) ;; 
	 (?\x2F8E8 . bidi-category-l) ;; 
	 (?\x2F8E9 . bidi-category-l) ;; 
	 (?\x2F8EA . bidi-category-l) ;; 
	 (?\x2F8EB . bidi-category-l) ;; 
	 (?\x2F8EC . bidi-category-l) ;; 
	 (?\x2F8ED . bidi-category-l) ;; 
	 (?\x2F8EE . bidi-category-l) ;; 
	 (?\x2F8EF . bidi-category-l) ;; 
	 (?\x2F8F0 . bidi-category-l) ;; 
	 (?\x2F8F1 . bidi-category-l) ;; 
	 (?\x2F8F2 . bidi-category-l) ;; 
	 (?\x2F8F3 . bidi-category-l) ;; 
	 (?\x2F8F4 . bidi-category-l) ;; 
	 (?\x2F8F5 . bidi-category-l) ;; 
	 (?\x2F8F6 . bidi-category-l) ;; 
	 (?\x2F8F7 . bidi-category-l) ;; 
	 (?\x2F8F8 . bidi-category-l) ;; 
	 (?\x2F8F9 . bidi-category-l) ;; 
	 (?\x2F8FA . bidi-category-l) ;; 
	 (?\x2F8FB . bidi-category-l) ;; 
	 (?\x2F8FC . bidi-category-l) ;; 
	 (?\x2F8FD . bidi-category-l) ;; 
	 (?\x2F8FE . bidi-category-l) ;; 
	 (?\x2F8FF . bidi-category-l) ;; 
	 (?\x2F900 . bidi-category-l) ;; 
	 (?\x2F901 . bidi-category-l) ;; 
	 (?\x2F902 . bidi-category-l) ;; 
	 (?\x2F903 . bidi-category-l) ;; 
	 (?\x2F904 . bidi-category-l) ;; 
	 (?\x2F905 . bidi-category-l) ;; 
	 (?\x2F906 . bidi-category-l) ;; 
	 (?\x2F907 . bidi-category-l) ;; 
	 (?\x2F908 . bidi-category-l) ;; 
	 (?\x2F909 . bidi-category-l) ;; 
	 (?\x2F90A . bidi-category-l) ;; 
	 (?\x2F90B . bidi-category-l) ;; 
	 (?\x2F90C . bidi-category-l) ;; 
	 (?\x2F90D . bidi-category-l) ;; 
	 (?\x2F90E . bidi-category-l) ;; 
	 (?\x2F90F . bidi-category-l) ;; 
	 (?\x2F910 . bidi-category-l) ;; 
	 (?\x2F911 . bidi-category-l) ;; 
	 (?\x2F912 . bidi-category-l) ;; 
	 (?\x2F913 . bidi-category-l) ;; 
	 (?\x2F914 . bidi-category-l) ;; 
	 (?\x2F915 . bidi-category-l) ;; 
	 (?\x2F916 . bidi-category-l) ;; 
	 (?\x2F917 . bidi-category-l) ;; 
	 (?\x2F918 . bidi-category-l) ;; 
	 (?\x2F919 . bidi-category-l) ;; 
	 (?\x2F91A . bidi-category-l) ;; 
	 (?\x2F91B . bidi-category-l) ;; 
	 (?\x2F91C . bidi-category-l) ;; 
	 (?\x2F91D . bidi-category-l) ;; 
	 (?\x2F91E . bidi-category-l) ;; 
	 (?\x2F91F . bidi-category-l) ;; 
	 (?\x2F920 . bidi-category-l) ;; 
	 (?\x2F921 . bidi-category-l) ;; 
	 (?\x2F922 . bidi-category-l) ;; 
	 (?\x2F923 . bidi-category-l) ;; 
	 (?\x2F924 . bidi-category-l) ;; 
	 (?\x2F925 . bidi-category-l) ;; 
	 (?\x2F926 . bidi-category-l) ;; 
	 (?\x2F927 . bidi-category-l) ;; 
	 (?\x2F928 . bidi-category-l) ;; 
	 (?\x2F929 . bidi-category-l) ;; 
	 (?\x2F92A . bidi-category-l) ;; 
	 (?\x2F92B . bidi-category-l) ;; 
	 (?\x2F92C . bidi-category-l) ;; 
	 (?\x2F92D . bidi-category-l) ;; 
	 (?\x2F92E . bidi-category-l) ;; 
	 (?\x2F92F . bidi-category-l) ;; 
	 (?\x2F930 . bidi-category-l) ;; 
	 (?\x2F931 . bidi-category-l) ;; 
	 (?\x2F932 . bidi-category-l) ;; 
	 (?\x2F933 . bidi-category-l) ;; 
	 (?\x2F934 . bidi-category-l) ;; 
	 (?\x2F935 . bidi-category-l) ;; 
	 (?\x2F936 . bidi-category-l) ;; 
	 (?\x2F937 . bidi-category-l) ;; 
	 (?\x2F938 . bidi-category-l) ;; 
	 (?\x2F939 . bidi-category-l) ;; 
	 (?\x2F93A . bidi-category-l) ;; 
	 (?\x2F93B . bidi-category-l) ;; 
	 (?\x2F93C . bidi-category-l) ;; 
	 (?\x2F93D . bidi-category-l) ;; 
	 (?\x2F93E . bidi-category-l) ;; 
	 (?\x2F93F . bidi-category-l) ;; 
	 (?\x2F940 . bidi-category-l) ;; 
	 (?\x2F941 . bidi-category-l) ;; 
	 (?\x2F942 . bidi-category-l) ;; 
	 (?\x2F943 . bidi-category-l) ;; 
	 (?\x2F944 . bidi-category-l) ;; 
	 (?\x2F945 . bidi-category-l) ;; 
	 (?\x2F946 . bidi-category-l) ;; 
	 (?\x2F947 . bidi-category-l) ;; 
	 (?\x2F948 . bidi-category-l) ;; 
	 (?\x2F949 . bidi-category-l) ;; 
	 (?\x2F94A . bidi-category-l) ;; 
	 (?\x2F94B . bidi-category-l) ;; 
	 (?\x2F94C . bidi-category-l) ;; 
	 (?\x2F94D . bidi-category-l) ;; 
	 (?\x2F94E . bidi-category-l) ;; 
	 (?\x2F94F . bidi-category-l) ;; 
	 (?\x2F950 . bidi-category-l) ;; 
	 (?\x2F951 . bidi-category-l) ;; 
	 (?\x2F952 . bidi-category-l) ;; 
	 (?\x2F953 . bidi-category-l) ;; 
	 (?\x2F954 . bidi-category-l) ;; 
	 (?\x2F955 . bidi-category-l) ;; 
	 (?\x2F956 . bidi-category-l) ;; 
	 (?\x2F957 . bidi-category-l) ;; 
	 (?\x2F958 . bidi-category-l) ;; 
	 (?\x2F959 . bidi-category-l) ;; 
	 (?\x2F95A . bidi-category-l) ;; 
	 (?\x2F95B . bidi-category-l) ;; 
	 (?\x2F95C . bidi-category-l) ;; 
	 (?\x2F95D . bidi-category-l) ;; 
	 (?\x2F95E . bidi-category-l) ;; 
	 (?\x2F95F . bidi-category-l) ;; 
	 (?\x2F960 . bidi-category-l) ;; 
	 (?\x2F961 . bidi-category-l) ;; 
	 (?\x2F962 . bidi-category-l) ;; 
	 (?\x2F963 . bidi-category-l) ;; 
	 (?\x2F964 . bidi-category-l) ;; 
	 (?\x2F965 . bidi-category-l) ;; 
	 (?\x2F966 . bidi-category-l) ;; 
	 (?\x2F967 . bidi-category-l) ;; 
	 (?\x2F968 . bidi-category-l) ;; 
	 (?\x2F969 . bidi-category-l) ;; 
	 (?\x2F96A . bidi-category-l) ;; 
	 (?\x2F96B . bidi-category-l) ;; 
	 (?\x2F96C . bidi-category-l) ;; 
	 (?\x2F96D . bidi-category-l) ;; 
	 (?\x2F96E . bidi-category-l) ;; 
	 (?\x2F96F . bidi-category-l) ;; 
	 (?\x2F970 . bidi-category-l) ;; 
	 (?\x2F971 . bidi-category-l) ;; 
	 (?\x2F972 . bidi-category-l) ;; 
	 (?\x2F973 . bidi-category-l) ;; 
	 (?\x2F974 . bidi-category-l) ;; 
	 (?\x2F975 . bidi-category-l) ;; 
	 (?\x2F976 . bidi-category-l) ;; 
	 (?\x2F977 . bidi-category-l) ;; 
	 (?\x2F978 . bidi-category-l) ;; 
	 (?\x2F979 . bidi-category-l) ;; 
	 (?\x2F97A . bidi-category-l) ;; 
	 (?\x2F97B . bidi-category-l) ;; 
	 (?\x2F97C . bidi-category-l) ;; 
	 (?\x2F97D . bidi-category-l) ;; 
	 (?\x2F97E . bidi-category-l) ;; 
	 (?\x2F97F . bidi-category-l) ;; 
	 (?\x2F980 . bidi-category-l) ;; 
	 (?\x2F981 . bidi-category-l) ;; 
	 (?\x2F982 . bidi-category-l) ;; 
	 (?\x2F983 . bidi-category-l) ;; 
	 (?\x2F984 . bidi-category-l) ;; 
	 (?\x2F985 . bidi-category-l) ;; 
	 (?\x2F986 . bidi-category-l) ;; 
	 (?\x2F987 . bidi-category-l) ;; 
	 (?\x2F988 . bidi-category-l) ;; 
	 (?\x2F989 . bidi-category-l) ;; 
	 (?\x2F98A . bidi-category-l) ;; 
	 (?\x2F98B . bidi-category-l) ;; 
	 (?\x2F98C . bidi-category-l) ;; 
	 (?\x2F98D . bidi-category-l) ;; 
	 (?\x2F98E . bidi-category-l) ;; 
	 (?\x2F98F . bidi-category-l) ;; 
	 (?\x2F990 . bidi-category-l) ;; 
	 (?\x2F991 . bidi-category-l) ;; 
	 (?\x2F992 . bidi-category-l) ;; 
	 (?\x2F993 . bidi-category-l) ;; 
	 (?\x2F994 . bidi-category-l) ;; 
	 (?\x2F995 . bidi-category-l) ;; 
	 (?\x2F996 . bidi-category-l) ;; 
	 (?\x2F997 . bidi-category-l) ;; 
	 (?\x2F998 . bidi-category-l) ;; 
	 (?\x2F999 . bidi-category-l) ;; 
	 (?\x2F99A . bidi-category-l) ;; 
	 (?\x2F99B . bidi-category-l) ;; 
	 (?\x2F99C . bidi-category-l) ;; 
	 (?\x2F99D . bidi-category-l) ;; 
	 (?\x2F99E . bidi-category-l) ;; 
	 (?\x2F99F . bidi-category-l) ;; 
	 (?\x2F9A0 . bidi-category-l) ;; 
	 (?\x2F9A1 . bidi-category-l) ;; 
	 (?\x2F9A2 . bidi-category-l) ;; 
	 (?\x2F9A3 . bidi-category-l) ;; 
	 (?\x2F9A4 . bidi-category-l) ;; 
	 (?\x2F9A5 . bidi-category-l) ;; 
	 (?\x2F9A6 . bidi-category-l) ;; 
	 (?\x2F9A7 . bidi-category-l) ;; 
	 (?\x2F9A8 . bidi-category-l) ;; 
	 (?\x2F9A9 . bidi-category-l) ;; 
	 (?\x2F9AA . bidi-category-l) ;; 
	 (?\x2F9AB . bidi-category-l) ;; 
	 (?\x2F9AC . bidi-category-l) ;; 
	 (?\x2F9AD . bidi-category-l) ;; 
	 (?\x2F9AE . bidi-category-l) ;; 
	 (?\x2F9AF . bidi-category-l) ;; 
	 (?\x2F9B0 . bidi-category-l) ;; 
	 (?\x2F9B1 . bidi-category-l) ;; 
	 (?\x2F9B2 . bidi-category-l) ;; 
	 (?\x2F9B3 . bidi-category-l) ;; 
	 (?\x2F9B4 . bidi-category-l) ;; 
	 (?\x2F9B5 . bidi-category-l) ;; 
	 (?\x2F9B6 . bidi-category-l) ;; 
	 (?\x2F9B7 . bidi-category-l) ;; 
	 (?\x2F9B8 . bidi-category-l) ;; 
	 (?\x2F9B9 . bidi-category-l) ;; 
	 (?\x2F9BA . bidi-category-l) ;; 
	 (?\x2F9BB . bidi-category-l) ;; 
	 (?\x2F9BC . bidi-category-l) ;; 
	 (?\x2F9BD . bidi-category-l) ;; 
	 (?\x2F9BE . bidi-category-l) ;; 
	 (?\x2F9BF . bidi-category-l) ;; 
	 (?\x2F9C0 . bidi-category-l) ;; 
	 (?\x2F9C1 . bidi-category-l) ;; 
	 (?\x2F9C2 . bidi-category-l) ;; 
	 (?\x2F9C3 . bidi-category-l) ;; 
	 (?\x2F9C4 . bidi-category-l) ;; 
	 (?\x2F9C5 . bidi-category-l) ;; 
	 (?\x2F9C6 . bidi-category-l) ;; 
	 (?\x2F9C7 . bidi-category-l) ;; 
	 (?\x2F9C8 . bidi-category-l) ;; 
	 (?\x2F9C9 . bidi-category-l) ;; 
	 (?\x2F9CA . bidi-category-l) ;; 
	 (?\x2F9CB . bidi-category-l) ;; 
	 (?\x2F9CC . bidi-category-l) ;; 
	 (?\x2F9CD . bidi-category-l) ;; 
	 (?\x2F9CE . bidi-category-l) ;; 
	 (?\x2F9CF . bidi-category-l) ;; 
	 (?\x2F9D0 . bidi-category-l) ;; 
	 (?\x2F9D1 . bidi-category-l) ;; 
	 (?\x2F9D2 . bidi-category-l) ;; 
	 (?\x2F9D3 . bidi-category-l) ;; 
	 (?\x2F9D4 . bidi-category-l) ;; 
	 (?\x2F9D5 . bidi-category-l) ;; 
	 (?\x2F9D6 . bidi-category-l) ;; 
	 (?\x2F9D7 . bidi-category-l) ;; 
	 (?\x2F9D8 . bidi-category-l) ;; 
	 (?\x2F9D9 . bidi-category-l) ;; 
	 (?\x2F9DA . bidi-category-l) ;; 
	 (?\x2F9DB . bidi-category-l) ;; 
	 (?\x2F9DC . bidi-category-l) ;; 
	 (?\x2F9DD . bidi-category-l) ;; 
	 (?\x2F9DE . bidi-category-l) ;; 
	 (?\x2F9DF . bidi-category-l) ;; 
	 (?\x2F9E0 . bidi-category-l) ;; 
	 (?\x2F9E1 . bidi-category-l) ;; 
	 (?\x2F9E2 . bidi-category-l) ;; 
	 (?\x2F9E3 . bidi-category-l) ;; 
	 (?\x2F9E4 . bidi-category-l) ;; 
	 (?\x2F9E5 . bidi-category-l) ;; 
	 (?\x2F9E6 . bidi-category-l) ;; 
	 (?\x2F9E7 . bidi-category-l) ;; 
	 (?\x2F9E8 . bidi-category-l) ;; 
	 (?\x2F9E9 . bidi-category-l) ;; 
	 (?\x2F9EA . bidi-category-l) ;; 
	 (?\x2F9EB . bidi-category-l) ;; 
	 (?\x2F9EC . bidi-category-l) ;; 
	 (?\x2F9ED . bidi-category-l) ;; 
	 (?\x2F9EE . bidi-category-l) ;; 
	 (?\x2F9EF . bidi-category-l) ;; 
	 (?\x2F9F0 . bidi-category-l) ;; 
	 (?\x2F9F1 . bidi-category-l) ;; 
	 (?\x2F9F2 . bidi-category-l) ;; 
	 (?\x2F9F3 . bidi-category-l) ;; 
	 (?\x2F9F4 . bidi-category-l) ;; 
	 (?\x2F9F5 . bidi-category-l) ;; 
	 (?\x2F9F6 . bidi-category-l) ;; 
	 (?\x2F9F7 . bidi-category-l) ;; 
	 (?\x2F9F8 . bidi-category-l) ;; 
	 (?\x2F9F9 . bidi-category-l) ;; 
	 (?\x2F9FA . bidi-category-l) ;; 
	 (?\x2F9FB . bidi-category-l) ;; 
	 (?\x2F9FC . bidi-category-l) ;; 
	 (?\x2F9FD . bidi-category-l) ;; 
	 (?\x2F9FE . bidi-category-l) ;; 
	 (?\x2F9FF . bidi-category-l) ;; 
	 (?\x2FA00 . bidi-category-l) ;; 
	 (?\x2FA01 . bidi-category-l) ;; 
	 (?\x2FA02 . bidi-category-l) ;; 
	 (?\x2FA03 . bidi-category-l) ;; 
	 (?\x2FA04 . bidi-category-l) ;; 
	 (?\x2FA05 . bidi-category-l) ;; 
	 (?\x2FA06 . bidi-category-l) ;; 
	 (?\x2FA07 . bidi-category-l) ;; 
	 (?\x2FA08 . bidi-category-l) ;; 
	 (?\x2FA09 . bidi-category-l) ;; 
	 (?\x2FA0A . bidi-category-l) ;; 
	 (?\x2FA0B . bidi-category-l) ;; 
	 (?\x2FA0C . bidi-category-l) ;; 
	 (?\x2FA0D . bidi-category-l) ;; 
	 (?\x2FA0E . bidi-category-l) ;; 
	 (?\x2FA0F . bidi-category-l) ;; 
	 (?\x2FA10 . bidi-category-l) ;; 
	 (?\x2FA11 . bidi-category-l) ;; 
	 (?\x2FA12 . bidi-category-l) ;; 
	 (?\x2FA13 . bidi-category-l) ;; 
	 (?\x2FA14 . bidi-category-l) ;; 
	 (?\x2FA15 . bidi-category-l) ;; 
	 (?\x2FA16 . bidi-category-l) ;; 
	 (?\x2FA17 . bidi-category-l) ;; 
	 (?\x2FA18 . bidi-category-l) ;; 
	 (?\x2FA19 . bidi-category-l) ;; 
	 (?\x2FA1A . bidi-category-l) ;; 
	 (?\x2FA1B . bidi-category-l) ;; 
	 (?\x2FA1C . bidi-category-l) ;; 
	 (?\x2FA1D . bidi-category-l) ;; 
	 (?\xE0001 . bidi-category-bn) ;; 
	 (?\xE0020 . bidi-category-bn) ;; 
	 (?\xE0021 . bidi-category-bn) ;; 
	 (?\xE0022 . bidi-category-bn) ;; 
	 (?\xE0023 . bidi-category-bn) ;; 
	 (?\xE0024 . bidi-category-bn) ;; 
	 (?\xE0025 . bidi-category-bn) ;; 
	 (?\xE0026 . bidi-category-bn) ;; 
	 (?\xE0027 . bidi-category-bn) ;; 
	 (?\xE0028 . bidi-category-bn) ;; 
	 (?\xE0029 . bidi-category-bn) ;; 
	 (?\xE002A . bidi-category-bn) ;; 
	 (?\xE002B . bidi-category-bn) ;; 
	 (?\xE002C . bidi-category-bn) ;; 
	 (?\xE002D . bidi-category-bn) ;; 
	 (?\xE002E . bidi-category-bn) ;; 
	 (?\xE002F . bidi-category-bn) ;; 
	 (?\xE0030 . bidi-category-bn) ;; 
	 (?\xE0031 . bidi-category-bn) ;; 
	 (?\xE0032 . bidi-category-bn) ;; 
	 (?\xE0033 . bidi-category-bn) ;; 
	 (?\xE0034 . bidi-category-bn) ;; 
	 (?\xE0035 . bidi-category-bn) ;; 
	 (?\xE0036 . bidi-category-bn) ;; 
	 (?\xE0037 . bidi-category-bn) ;; 
	 (?\xE0038 . bidi-category-bn) ;; 
	 (?\xE0039 . bidi-category-bn) ;; 
	 (?\xE003A . bidi-category-bn) ;; 
	 (?\xE003B . bidi-category-bn) ;; 
	 (?\xE003C . bidi-category-bn) ;; 
	 (?\xE003D . bidi-category-bn) ;; 
	 (?\xE003E . bidi-category-bn) ;; 
	 (?\xE003F . bidi-category-bn) ;; 
	 (?\xE0040 . bidi-category-bn) ;; 
	 (?\xE0041 . bidi-category-bn) ;; 
	 (?\xE0042 . bidi-category-bn) ;; 
	 (?\xE0043 . bidi-category-bn) ;; 
	 (?\xE0044 . bidi-category-bn) ;; 
	 (?\xE0045 . bidi-category-bn) ;; 
	 (?\xE0046 . bidi-category-bn) ;; 
	 (?\xE0047 . bidi-category-bn) ;; 
	 (?\xE0048 . bidi-category-bn) ;; 
	 (?\xE0049 . bidi-category-bn) ;; 
	 (?\xE004A . bidi-category-bn) ;; 
	 (?\xE004B . bidi-category-bn) ;; 
	 (?\xE004C . bidi-category-bn) ;; 
	 (?\xE004D . bidi-category-bn) ;; 
	 (?\xE004E . bidi-category-bn) ;; 
	 (?\xE004F . bidi-category-bn) ;; 
	 (?\xE0050 . bidi-category-bn) ;; 
	 (?\xE0051 . bidi-category-bn) ;; 
	 (?\xE0052 . bidi-category-bn) ;; 
	 (?\xE0053 . bidi-category-bn) ;; 
	 (?\xE0054 . bidi-category-bn) ;; 
	 (?\xE0055 . bidi-category-bn) ;; 
	 (?\xE0056 . bidi-category-bn) ;; 
	 (?\xE0057 . bidi-category-bn) ;; 
	 (?\xE0058 . bidi-category-bn) ;; 
	 (?\xE0059 . bidi-category-bn) ;; 
	 (?\xE005A . bidi-category-bn) ;; 
	 (?\xE005B . bidi-category-bn) ;; 
	 (?\xE005C . bidi-category-bn) ;; 
	 (?\xE005D . bidi-category-bn) ;; 
	 (?\xE005E . bidi-category-bn) ;; 
	 (?\xE005F . bidi-category-bn) ;; 
	 (?\xE0060 . bidi-category-bn) ;; 
	 (?\xE0061 . bidi-category-bn) ;; 
	 (?\xE0062 . bidi-category-bn) ;; 
	 (?\xE0063 . bidi-category-bn) ;; 
	 (?\xE0064 . bidi-category-bn) ;; 
	 (?\xE0065 . bidi-category-bn) ;; 
	 (?\xE0066 . bidi-category-bn) ;; 
	 (?\xE0067 . bidi-category-bn) ;; 
	 (?\xE0068 . bidi-category-bn) ;; 
	 (?\xE0069 . bidi-category-bn) ;; 
	 (?\xE006A . bidi-category-bn) ;; 
	 (?\xE006B . bidi-category-bn) ;; 
	 (?\xE006C . bidi-category-bn) ;; 
	 (?\xE006D . bidi-category-bn) ;; 
	 (?\xE006E . bidi-category-bn) ;; 
	 (?\xE006F . bidi-category-bn) ;; 
	 (?\xE0070 . bidi-category-bn) ;; 
	 (?\xE0071 . bidi-category-bn) ;; 
	 (?\xE0072 . bidi-category-bn) ;; 
	 (?\xE0073 . bidi-category-bn) ;; 
	 (?\xE0074 . bidi-category-bn) ;; 
	 (?\xE0075 . bidi-category-bn) ;; 
	 (?\xE0076 . bidi-category-bn) ;; 
	 (?\xE0077 . bidi-category-bn) ;; 
	 (?\xE0078 . bidi-category-bn) ;; 
	 (?\xE0079 . bidi-category-bn) ;; 
	 (?\xE007A . bidi-category-bn) ;; 
	 (?\xE007B . bidi-category-bn) ;; 
	 (?\xE007C . bidi-category-bn) ;; 
	 (?\xE007D . bidi-category-bn) ;; 
	 (?\xE007E . bidi-category-bn) ;; 
	 (?\xE007F . bidi-category-bn) ;; 
	 (?\xF0000 . bidi-category-l) ;; 
	 (?\xFFFFD . bidi-category-l) ;; 
	 (?\x100000 . bidi-category-l) ;; 
	 (?\x10FFFD . bidi-category-l)
	 ))

;; Unification code taken from ucs-tables.el

      (ucs-8859-2-alist
       '((?\,B (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,B!(B . ?\x0104) ;; LATIN CAPITAL LETTER A WITH OGONEK
	 (?\,B"(B . ?\x02D8) ;; BREVE
	 (?\,B#(B . ?\x0141) ;; LATIN CAPITAL LETTER L WITH STROKE
	 (?\,B$(B . ?\x00A4) ;; CURRENCY SIGN
	 (?\,B%(B . ?\x013D) ;; LATIN CAPITAL LETTER L WITH CARON
	 (?\,B&(B . ?\x015A) ;; LATIN CAPITAL LETTER S WITH ACUTE
	 (?\,B'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,B((B . ?\x00A8) ;; DIAERESIS
	 (?\,B)(B . ?\x0160) ;; LATIN CAPITAL LETTER S WITH CARON
	 (?\,B*(B . ?\x015E) ;; LATIN CAPITAL LETTER S WITH CEDILLA
	 (?\,B+(B . ?\x0164) ;; LATIN CAPITAL LETTER T WITH CARON
	 (?\,B,(B . ?\x0179) ;; LATIN CAPITAL LETTER Z WITH ACUTE
	 (?\,B-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,B.(B . ?\x017D) ;; LATIN CAPITAL LETTER Z WITH CARON
	 (?\,B/(B . ?\x017B) ;; LATIN CAPITAL LETTER Z WITH DOT ABOVE
	 (?\,B0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,B1(B . ?\x0105) ;; LATIN SMALL LETTER A WITH OGONEK
	 (?\,B2(B . ?\x02DB) ;; OGONEK
	 (?\,B3(B . ?\x0142) ;; LATIN SMALL LETTER L WITH STROKE
	 (?\,B4(B . ?\x00B4) ;; ACUTE ACCENT
	 (?\,B5(B . ?\x013E) ;; LATIN SMALL LETTER L WITH CARON
	 (?\,B6(B . ?\x015B) ;; LATIN SMALL LETTER S WITH ACUTE
	 (?\,B7(B . ?\x02C7) ;; CARON
	 (?\,B8(B . ?\x00B8) ;; CEDILLA
	 (?\,B9(B . ?\x0161) ;; LATIN SMALL LETTER S WITH CARON
	 (?\,B:(B . ?\x015F) ;; LATIN SMALL LETTER S WITH CEDILLA
	 (?\,B;(B . ?\x0165) ;; LATIN SMALL LETTER T WITH CARON
	 (?\,B<(B . ?\x017A) ;; LATIN SMALL LETTER Z WITH ACUTE
	 (?\,B=(B . ?\x02DD) ;; DOUBLE ACUTE ACCENT
	 (?\,B>(B . ?\x017E) ;; LATIN SMALL LETTER Z WITH CARON
	 (?\,B?(B . ?\x017C) ;; LATIN SMALL LETTER Z WITH DOT ABOVE
	 (?\,B@(B . ?\x0154) ;; LATIN CAPITAL LETTER R WITH ACUTE
	 (?\,BA(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,BB(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,BC(B . ?\x0102) ;; LATIN CAPITAL LETTER A WITH BREVE
	 (?\,BD(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,BE(B . ?\x0139) ;; LATIN CAPITAL LETTER L WITH ACUTE
	 (?\,BF(B . ?\x0106) ;; LATIN CAPITAL LETTER C WITH ACUTE
	 (?\,BG(B . ?\x00C7) ;; LATIN CAPITAL LETTER C WITH CEDILLA
	 (?\,BH(B . ?\x010C) ;; LATIN CAPITAL LETTER C WITH CARON
	 (?\,BI(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,BJ(B . ?\x0118) ;; LATIN CAPITAL LETTER E WITH OGONEK
	 (?\,BK(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,BL(B . ?\x011A) ;; LATIN CAPITAL LETTER E WITH CARON
	 (?\,BM(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,BN(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,BO(B . ?\x010E) ;; LATIN CAPITAL LETTER D WITH CARON
	 (?\,BP(B . ?\x0110) ;; LATIN CAPITAL LETTER D WITH STROKE
	 (?\,BQ(B . ?\x0143) ;; LATIN CAPITAL LETTER N WITH ACUTE
	 (?\,BR(B . ?\x0147) ;; LATIN CAPITAL LETTER N WITH CARON
	 (?\,BS(B . ?\x00D3) ;; LATIN CAPITAL LETTER O WITH ACUTE
	 (?\,BT(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,BU(B . ?\x0150) ;; LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
	 (?\,BV(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,BW(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,BX(B . ?\x0158) ;; LATIN CAPITAL LETTER R WITH CARON
	 (?\,BY(B . ?\x016E) ;; LATIN CAPITAL LETTER U WITH RING ABOVE
	 (?\,BZ(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,B[(B . ?\x0170) ;; LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
	 (?\,B\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,B](B . ?\x00DD) ;; LATIN CAPITAL LETTER Y WITH ACUTE
	 (?\,B^(B . ?\x0162) ;; LATIN CAPITAL LETTER T WITH CEDILLA
	 (?\,B_(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,B`(B . ?\x0155) ;; LATIN SMALL LETTER R WITH ACUTE
	 (?\,Ba(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,Bb(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,Bc(B . ?\x0103) ;; LATIN SMALL LETTER A WITH BREVE
	 (?\,Bd(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,Be(B . ?\x013A) ;; LATIN SMALL LETTER L WITH ACUTE
	 (?\,Bf(B . ?\x0107) ;; LATIN SMALL LETTER C WITH ACUTE
	 (?\,Bg(B . ?\x00E7) ;; LATIN SMALL LETTER C WITH CEDILLA
	 (?\,Bh(B . ?\x010D) ;; LATIN SMALL LETTER C WITH CARON
	 (?\,Bi(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,Bj(B . ?\x0119) ;; LATIN SMALL LETTER E WITH OGONEK
	 (?\,Bk(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,Bl(B . ?\x011B) ;; LATIN SMALL LETTER E WITH CARON
	 (?\,Bm(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,Bn(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,Bo(B . ?\x010F) ;; LATIN SMALL LETTER D WITH CARON
	 (?\,Bp(B . ?\x0111) ;; LATIN SMALL LETTER D WITH STROKE
	 (?\,Bq(B . ?\x0144) ;; LATIN SMALL LETTER N WITH ACUTE
	 (?\,Br(B . ?\x0148) ;; LATIN SMALL LETTER N WITH CARON
	 (?\,Bs(B . ?\x00F3) ;; LATIN SMALL LETTER O WITH ACUTE
	 (?\,Bt(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,Bu(B . ?\x0151) ;; LATIN SMALL LETTER O WITH DOUBLE ACUTE
	 (?\,Bv(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,Bw(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,Bx(B . ?\x0159) ;; LATIN SMALL LETTER R WITH CARON
	 (?\,By(B . ?\x016F) ;; LATIN SMALL LETTER U WITH RING ABOVE
	 (?\,Bz(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,B{(B . ?\x0171) ;; LATIN SMALL LETTER U WITH DOUBLE ACUTE
	 (?\,B|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,B}(B . ?\x00FD) ;; LATIN SMALL LETTER Y WITH ACUTE
	 (?\,B~(B . ?\x0163) ;; LATIN SMALL LETTER T WITH CEDILLA
	 (?\,B(B . ?\x02D9) ;; DOT ABOVE
	 ))

      (ucs-8859-3-alist
       '((?\,C (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,C!(B . ?\x0126) ;; LATIN CAPITAL LETTER H WITH STROKE
	 (?\,C"(B . ?\x02D8) ;; BREVE
	 (?\,C#(B . ?\x00A3) ;; POUND SIGN
	 (?\,C$(B . ?\x00A4) ;; CURRENCY SIGN
	 (?\,C&(B . ?\x0124) ;; LATIN CAPITAL LETTER H WITH CIRCUMFLEX
	 (?\,C'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,C((B . ?\x00A8) ;; DIAERESIS
	 (?\,C)(B . ?\x0130) ;; LATIN CAPITAL LETTER I WITH DOT ABOVE
	 (?\,C*(B . ?\x015E) ;; LATIN CAPITAL LETTER S WITH CEDILLA
	 (?\,C+(B . ?\x011E) ;; LATIN CAPITAL LETTER G WITH BREVE
	 (?\,C,(B . ?\x0134) ;; LATIN CAPITAL LETTER J WITH CIRCUMFLEX
	 (?\,C-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,C/(B . ?\x017B) ;; LATIN CAPITAL LETTER Z WITH DOT ABOVE
	 (?\,C0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,C1(B . ?\x0127) ;; LATIN SMALL LETTER H WITH STROKE
	 (?\,C2(B . ?\x00B2) ;; SUPERSCRIPT TWO
	 (?\,C3(B . ?\x00B3) ;; SUPERSCRIPT THREE
	 (?\,C4(B . ?\x00B4) ;; ACUTE ACCENT
	 (?\,C5(B . ?\x00B5) ;; MICRO SIGN
	 (?\,C6(B . ?\x0125) ;; LATIN SMALL LETTER H WITH CIRCUMFLEX
	 (?\,C7(B . ?\x00B7) ;; MIDDLE DOT
	 (?\,C8(B . ?\x00B8) ;; CEDILLA
	 (?\,C9(B . ?\x0131) ;; LATIN SMALL LETTER DOTLESS I
	 (?\,C:(B . ?\x015F) ;; LATIN SMALL LETTER S WITH CEDILLA
	 (?\,C;(B . ?\x011F) ;; LATIN SMALL LETTER G WITH BREVE
	 (?\,C<(B . ?\x0135) ;; LATIN SMALL LETTER J WITH CIRCUMFLEX
	 (?\,C=(B . ?\x00BD) ;; VULGAR FRACTION ONE HALF
	 (?\,C?(B . ?\x017C) ;; LATIN SMALL LETTER Z WITH DOT ABOVE
	 (?\,C@(B . ?\x00C0) ;; LATIN CAPITAL LETTER A WITH GRAVE
	 (?\,CA(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,CB(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,CD(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,CE(B . ?\x010A) ;; LATIN CAPITAL LETTER C WITH DOT ABOVE
	 (?\,CF(B . ?\x0108) ;; LATIN CAPITAL LETTER C WITH CIRCUMFLEX
	 (?\,CG(B . ?\x00C7) ;; LATIN CAPITAL LETTER C WITH CEDILLA
	 (?\,CH(B . ?\x00C8) ;; LATIN CAPITAL LETTER E WITH GRAVE
	 (?\,CI(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,CJ(B . ?\x00CA) ;; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	 (?\,CK(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,CL(B . ?\x00CC) ;; LATIN CAPITAL LETTER I WITH GRAVE
	 (?\,CM(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,CN(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,CO(B . ?\x00CF) ;; LATIN CAPITAL LETTER I WITH DIAERESIS
	 (?\,CQ(B . ?\x00D1) ;; LATIN CAPITAL LETTER N WITH TILDE
	 (?\,CR(B . ?\x00D2) ;; LATIN CAPITAL LETTER O WITH GRAVE
	 (?\,CS(B . ?\x00D3) ;; LATIN CAPITAL LETTER O WITH ACUTE
	 (?\,CT(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,CU(B . ?\x0120) ;; LATIN CAPITAL LETTER G WITH DOT ABOVE
	 (?\,CV(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,CW(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,CX(B . ?\x011C) ;; LATIN CAPITAL LETTER G WITH CIRCUMFLEX
	 (?\,CY(B . ?\x00D9) ;; LATIN CAPITAL LETTER U WITH GRAVE
	 (?\,CZ(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,C[(B . ?\x00DB) ;; LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	 (?\,C\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,C](B . ?\x016C) ;; LATIN CAPITAL LETTER U WITH BREVE
	 (?\,C^(B . ?\x015C) ;; LATIN CAPITAL LETTER S WITH CIRCUMFLEX
	 (?\,C_(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,C`(B . ?\x00E0) ;; LATIN SMALL LETTER A WITH GRAVE
	 (?\,Ca(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,Cb(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,Cd(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,Ce(B . ?\x010B) ;; LATIN SMALL LETTER C WITH DOT ABOVE
	 (?\,Cf(B . ?\x0109) ;; LATIN SMALL LETTER C WITH CIRCUMFLEX
	 (?\,Cg(B . ?\x00E7) ;; LATIN SMALL LETTER C WITH CEDILLA
	 (?\,Ch(B . ?\x00E8) ;; LATIN SMALL LETTER E WITH GRAVE
	 (?\,Ci(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,Cj(B . ?\x00EA) ;; LATIN SMALL LETTER E WITH CIRCUMFLEX
	 (?\,Ck(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,Cl(B . ?\x00EC) ;; LATIN SMALL LETTER I WITH GRAVE
	 (?\,Cm(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,Cn(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,Co(B . ?\x00EF) ;; LATIN SMALL LETTER I WITH DIAERESIS
	 (?\,Cq(B . ?\x00F1) ;; LATIN SMALL LETTER N WITH TILDE
	 (?\,Cr(B . ?\x00F2) ;; LATIN SMALL LETTER O WITH GRAVE
	 (?\,Cs(B . ?\x00F3) ;; LATIN SMALL LETTER O WITH ACUTE
	 (?\,Ct(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,Cu(B . ?\x0121) ;; LATIN SMALL LETTER G WITH DOT ABOVE
	 (?\,Cv(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,Cw(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,Cx(B . ?\x011D) ;; LATIN SMALL LETTER G WITH CIRCUMFLEX
	 (?\,Cy(B . ?\x00F9) ;; LATIN SMALL LETTER U WITH GRAVE
	 (?\,Cz(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,C{(B . ?\x00FB) ;; LATIN SMALL LETTER U WITH CIRCUMFLEX
	 (?\,C|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,C}(B . ?\x016D) ;; LATIN SMALL LETTER U WITH BREVE
	 (?\,C~(B . ?\x015D) ;; LATIN SMALL LETTER S WITH CIRCUMFLEX
	 (?\,C(B . ?\x02D9) ;; DOT ABOVE
	 ))

      (ucs-8859-4-alist
       '((?\,D (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,D!(B . ?\x0104) ;; LATIN CAPITAL LETTER A WITH OGONEK
	 (?\,D"(B . ?\x0138) ;; LATIN SMALL LETTER KRA
	 (?\,D#(B . ?\x0156) ;; LATIN CAPITAL LETTER R WITH CEDILLA
	 (?\,D$(B . ?\x00A4) ;; CURRENCY SIGN
	 (?\,D%(B . ?\x0128) ;; LATIN CAPITAL LETTER I WITH TILDE
	 (?\,D&(B . ?\x013B) ;; LATIN CAPITAL LETTER L WITH CEDILLA
	 (?\,D'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,D((B . ?\x00A8) ;; DIAERESIS
	 (?\,D)(B . ?\x0160) ;; LATIN CAPITAL LETTER S WITH CARON
	 (?\,D*(B . ?\x0112) ;; LATIN CAPITAL LETTER E WITH MACRON
	 (?\,D+(B . ?\x0122) ;; LATIN CAPITAL LETTER G WITH CEDILLA
	 (?\,D,(B . ?\x0166) ;; LATIN CAPITAL LETTER T WITH STROKE
	 (?\,D-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,D.(B . ?\x017D) ;; LATIN CAPITAL LETTER Z WITH CARON
	 (?\,D/(B . ?\x00AF) ;; MACRON
	 (?\,D0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,D1(B . ?\x0105) ;; LATIN SMALL LETTER A WITH OGONEK
	 (?\,D2(B . ?\x02DB) ;; OGONEK
	 (?\,D3(B . ?\x0157) ;; LATIN SMALL LETTER R WITH CEDILLA
	 (?\,D4(B . ?\x00B4) ;; ACUTE ACCENT
	 (?\,D5(B . ?\x0129) ;; LATIN SMALL LETTER I WITH TILDE
	 (?\,D6(B . ?\x013C) ;; LATIN SMALL LETTER L WITH CEDILLA
	 (?\,D7(B . ?\x02C7) ;; CARON
	 (?\,D8(B . ?\x00B8) ;; CEDILLA
	 (?\,D9(B . ?\x0161) ;; LATIN SMALL LETTER S WITH CARON
	 (?\,D:(B . ?\x0113) ;; LATIN SMALL LETTER E WITH MACRON
	 (?\,D;(B . ?\x0123) ;; LATIN SMALL LETTER G WITH CEDILLA
	 (?\,D<(B . ?\x0167) ;; LATIN SMALL LETTER T WITH STROKE
	 (?\,D=(B . ?\x014A) ;; LATIN CAPITAL LETTER ENG
	 (?\,D>(B . ?\x017E) ;; LATIN SMALL LETTER Z WITH CARON
	 (?\,D?(B . ?\x014B) ;; LATIN SMALL LETTER ENG
	 (?\,D@(B . ?\x0100) ;; LATIN CAPITAL LETTER A WITH MACRON
	 (?\,DA(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,DB(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,DC(B . ?\x00C3) ;; LATIN CAPITAL LETTER A WITH TILDE
	 (?\,DD(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,DE(B . ?\x00C5) ;; LATIN CAPITAL LETTER A WITH RING ABOVE
	 (?\,DF(B . ?\x00C6) ;; LATIN CAPITAL LETTER AE
	 (?\,DG(B . ?\x012E) ;; LATIN CAPITAL LETTER I WITH OGONEK
	 (?\,DH(B . ?\x010C) ;; LATIN CAPITAL LETTER C WITH CARON
	 (?\,DI(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,DJ(B . ?\x0118) ;; LATIN CAPITAL LETTER E WITH OGONEK
	 (?\,DK(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,DL(B . ?\x0116) ;; LATIN CAPITAL LETTER E WITH DOT ABOVE
	 (?\,DM(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,DN(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,DO(B . ?\x012A) ;; LATIN CAPITAL LETTER I WITH MACRON
	 (?\,DP(B . ?\x0110) ;; LATIN CAPITAL LETTER D WITH STROKE
	 (?\,DQ(B . ?\x0145) ;; LATIN CAPITAL LETTER N WITH CEDILLA
	 (?\,DR(B . ?\x014C) ;; LATIN CAPITAL LETTER O WITH MACRON
	 (?\,DS(B . ?\x0136) ;; LATIN CAPITAL LETTER K WITH CEDILLA
	 (?\,DT(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,DU(B . ?\x00D5) ;; LATIN CAPITAL LETTER O WITH TILDE
	 (?\,DV(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,DW(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,DX(B . ?\x00D8) ;; LATIN CAPITAL LETTER O WITH STROKE
	 (?\,DY(B . ?\x0172) ;; LATIN CAPITAL LETTER U WITH OGONEK
	 (?\,DZ(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,D[(B . ?\x00DB) ;; LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	 (?\,D\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,D](B . ?\x0168) ;; LATIN CAPITAL LETTER U WITH TILDE
	 (?\,D^(B . ?\x016A) ;; LATIN CAPITAL LETTER U WITH MACRON
	 (?\,D_(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,D`(B . ?\x0101) ;; LATIN SMALL LETTER A WITH MACRON
	 (?\,Da(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,Db(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,Dc(B . ?\x00E3) ;; LATIN SMALL LETTER A WITH TILDE
	 (?\,Dd(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,De(B . ?\x00E5) ;; LATIN SMALL LETTER A WITH RING ABOVE
	 (?\,Df(B . ?\x00E6) ;; LATIN SMALL LETTER AE
	 (?\,Dg(B . ?\x012F) ;; LATIN SMALL LETTER I WITH OGONEK
	 (?\,Dh(B . ?\x010D) ;; LATIN SMALL LETTER C WITH CARON
	 (?\,Di(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,Dj(B . ?\x0119) ;; LATIN SMALL LETTER E WITH OGONEK
	 (?\,Dk(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,Dl(B . ?\x0117) ;; LATIN SMALL LETTER E WITH DOT ABOVE
	 (?\,Dm(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,Dn(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,Do(B . ?\x012B) ;; LATIN SMALL LETTER I WITH MACRON
	 (?\,Dp(B . ?\x0111) ;; LATIN SMALL LETTER D WITH STROKE
	 (?\,Dq(B . ?\x0146) ;; LATIN SMALL LETTER N WITH CEDILLA
	 (?\,Dr(B . ?\x014D) ;; LATIN SMALL LETTER O WITH MACRON
	 (?\,Ds(B . ?\x0137) ;; LATIN SMALL LETTER K WITH CEDILLA
	 (?\,Dt(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,Du(B . ?\x00F5) ;; LATIN SMALL LETTER O WITH TILDE
	 (?\,Dv(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,Dw(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,Dx(B . ?\x00F8) ;; LATIN SMALL LETTER O WITH STROKE
	 (?\,Dy(B . ?\x0173) ;; LATIN SMALL LETTER U WITH OGONEK
	 (?\,Dz(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,D{(B . ?\x00FB) ;; LATIN SMALL LETTER U WITH CIRCUMFLEX
	 (?\,D|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,D}(B . ?\x0169) ;; LATIN SMALL LETTER U WITH TILDE
	 (?\,D~(B . ?\x016B) ;; LATIN SMALL LETTER U WITH MACRON
	 (?\,D(B . ?\x02D9) ;; DOT ABOVE
	 ))

      (ucs-8859-5-alist
       '((?\,L (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,L!(B . ?\x0401) ;; CYRILLIC CAPITAL LETTER IO
	 (?\,L"(B . ?\x0402) ;; CYRILLIC CAPITAL LETTER DJE
	 (?\,L#(B . ?\x0403) ;; CYRILLIC CAPITAL LETTER GJE
	 (?\,L$(B . ?\x0404) ;; CYRILLIC CAPITAL LETTER UKRAINIAN IE
	 (?\,L%(B . ?\x0405) ;; CYRILLIC CAPITAL LETTER DZE
	 (?\,L&(B . ?\x0406) ;; CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
	 (?\,L'(B . ?\x0407) ;; CYRILLIC CAPITAL LETTER YI
	 (?\,L((B . ?\x0408) ;; CYRILLIC CAPITAL LETTER JE
	 (?\,L)(B . ?\x0409) ;; CYRILLIC CAPITAL LETTER LJE
	 (?\,L*(B . ?\x040A) ;; CYRILLIC CAPITAL LETTER NJE
	 (?\,L+(B . ?\x040B) ;; CYRILLIC CAPITAL LETTER TSHE
	 (?\,L,(B . ?\x040C) ;; CYRILLIC CAPITAL LETTER KJE
	 (?\,L-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,L.(B . ?\x040E) ;; CYRILLIC CAPITAL LETTER SHORT U
	 (?\,L/(B . ?\x040F) ;; CYRILLIC CAPITAL LETTER DZHE
	 (?\,L0(B . ?\x0410) ;; CYRILLIC CAPITAL LETTER A
	 (?\,L1(B . ?\x0411) ;; CYRILLIC CAPITAL LETTER BE
	 (?\,L2(B . ?\x0412) ;; CYRILLIC CAPITAL LETTER VE
	 (?\,L3(B . ?\x0413) ;; CYRILLIC CAPITAL LETTER GHE
	 (?\,L4(B . ?\x0414) ;; CYRILLIC CAPITAL LETTER DE
	 (?\,L5(B . ?\x0415) ;; CYRILLIC CAPITAL LETTER IE
	 (?\,L6(B . ?\x0416) ;; CYRILLIC CAPITAL LETTER ZHE
	 (?\,L7(B . ?\x0417) ;; CYRILLIC CAPITAL LETTER ZE
	 (?\,L8(B . ?\x0418) ;; CYRILLIC CAPITAL LETTER I
	 (?\,L9(B . ?\x0419) ;; CYRILLIC CAPITAL LETTER SHORT I
	 (?\,L:(B . ?\x041A) ;; CYRILLIC CAPITAL LETTER KA
	 (?\,L;(B . ?\x041B) ;; CYRILLIC CAPITAL LETTER EL
	 (?\,L<(B . ?\x041C) ;; CYRILLIC CAPITAL LETTER EM
	 (?\,L=(B . ?\x041D) ;; CYRILLIC CAPITAL LETTER EN
	 (?\,L>(B . ?\x041E) ;; CYRILLIC CAPITAL LETTER O
	 (?\,L?(B . ?\x041F) ;; CYRILLIC CAPITAL LETTER PE
	 (?\,L@(B . ?\x0420) ;; CYRILLIC CAPITAL LETTER ER
	 (?\,LA(B . ?\x0421) ;; CYRILLIC CAPITAL LETTER ES
	 (?\,LB(B . ?\x0422) ;; CYRILLIC CAPITAL LETTER TE
	 (?\,LC(B . ?\x0423) ;; CYRILLIC CAPITAL LETTER U
	 (?\,LD(B . ?\x0424) ;; CYRILLIC CAPITAL LETTER EF
	 (?\,LE(B . ?\x0425) ;; CYRILLIC CAPITAL LETTER HA
	 (?\,LF(B . ?\x0426) ;; CYRILLIC CAPITAL LETTER TSE
	 (?\,LG(B . ?\x0427) ;; CYRILLIC CAPITAL LETTER CHE
	 (?\,LH(B . ?\x0428) ;; CYRILLIC CAPITAL LETTER SHA
	 (?\,LI(B . ?\x0429) ;; CYRILLIC CAPITAL LETTER SHCHA
	 (?\,LJ(B . ?\x042A) ;; CYRILLIC CAPITAL LETTER HARD SIGN
	 (?\,LK(B . ?\x042B) ;; CYRILLIC CAPITAL LETTER YERU
	 (?\,LL(B . ?\x042C) ;; CYRILLIC CAPITAL LETTER SOFT SIGN
	 (?\,LM(B . ?\x042D) ;; CYRILLIC CAPITAL LETTER E
	 (?\,LN(B . ?\x042E) ;; CYRILLIC CAPITAL LETTER YU
	 (?\,LO(B . ?\x042F) ;; CYRILLIC CAPITAL LETTER YA
	 (?\,LP(B . ?\x0430) ;; CYRILLIC SMALL LETTER A
	 (?\,LQ(B . ?\x0431) ;; CYRILLIC SMALL LETTER BE
	 (?\,LR(B . ?\x0432) ;; CYRILLIC SMALL LETTER VE
	 (?\,LS(B . ?\x0433) ;; CYRILLIC SMALL LETTER GHE
	 (?\,LT(B . ?\x0434) ;; CYRILLIC SMALL LETTER DE
	 (?\,LU(B . ?\x0435) ;; CYRILLIC SMALL LETTER IE
	 (?\,LV(B . ?\x0436) ;; CYRILLIC SMALL LETTER ZHE
	 (?\,LW(B . ?\x0437) ;; CYRILLIC SMALL LETTER ZE
	 (?\,LX(B . ?\x0438) ;; CYRILLIC SMALL LETTER I
	 (?\,LY(B . ?\x0439) ;; CYRILLIC SMALL LETTER SHORT I
	 (?\,LZ(B . ?\x043A) ;; CYRILLIC SMALL LETTER KA
	 (?\,L[(B . ?\x043B) ;; CYRILLIC SMALL LETTER EL
	 (?\,L\(B . ?\x043C) ;; CYRILLIC SMALL LETTER EM
	 (?\,L](B . ?\x043D) ;; CYRILLIC SMALL LETTER EN
	 (?\,L^(B . ?\x043E) ;; CYRILLIC SMALL LETTER O
	 (?\,L_(B . ?\x043F) ;; CYRILLIC SMALL LETTER PE
	 (?\,L`(B . ?\x0440) ;; CYRILLIC SMALL LETTER ER
	 (?\,La(B . ?\x0441) ;; CYRILLIC SMALL LETTER ES
	 (?\,Lb(B . ?\x0442) ;; CYRILLIC SMALL LETTER TE
	 (?\,Lc(B . ?\x0443) ;; CYRILLIC SMALL LETTER U
	 (?\,Ld(B . ?\x0444) ;; CYRILLIC SMALL LETTER EF
	 (?\,Le(B . ?\x0445) ;; CYRILLIC SMALL LETTER HA
	 (?\,Lf(B . ?\x0446) ;; CYRILLIC SMALL LETTER TSE
	 (?\,Lg(B . ?\x0447) ;; CYRILLIC SMALL LETTER CHE
	 (?\,Lh(B . ?\x0448) ;; CYRILLIC SMALL LETTER SHA
	 (?\,Li(B . ?\x0449) ;; CYRILLIC SMALL LETTER SHCHA
	 (?\,Lj(B . ?\x044A) ;; CYRILLIC SMALL LETTER HARD SIGN
	 (?\,Lk(B . ?\x044B) ;; CYRILLIC SMALL LETTER YERU
	 (?\,Ll(B . ?\x044C) ;; CYRILLIC SMALL LETTER SOFT SIGN
	 (?\,Lm(B . ?\x044D) ;; CYRILLIC SMALL LETTER E
	 (?\,Ln(B . ?\x044E) ;; CYRILLIC SMALL LETTER YU
	 (?\,Lo(B . ?\x044F) ;; CYRILLIC SMALL LETTER YA
	 (?\,Lp(B . ?\x2116) ;; NUMERO SIGN
	 (?\,Lq(B . ?\x0451) ;; CYRILLIC SMALL LETTER IO
	 (?\,Lr(B . ?\x0452) ;; CYRILLIC SMALL LETTER DJE
	 (?\,Ls(B . ?\x0453) ;; CYRILLIC SMALL LETTER GJE
	 (?\,Lt(B . ?\x0454) ;; CYRILLIC SMALL LETTER UKRAINIAN IE
	 (?\,Lu(B . ?\x0455) ;; CYRILLIC SMALL LETTER DZE
	 (?\,Lv(B . ?\x0456) ;; CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
	 (?\,Lw(B . ?\x0457) ;; CYRILLIC SMALL LETTER YI
	 (?\,Lx(B . ?\x0458) ;; CYRILLIC SMALL LETTER JE
	 (?\,Ly(B . ?\x0459) ;; CYRILLIC SMALL LETTER LJE
	 (?\,Lz(B . ?\x045A) ;; CYRILLIC SMALL LETTER NJE
	 (?\,L{(B . ?\x045B) ;; CYRILLIC SMALL LETTER TSHE
	 (?\,L|(B . ?\x045C) ;; CYRILLIC SMALL LETTER KJE
	 (?\,L}(B . ?\x00A7) ;; SECTION SIGN
	 (?\,L~(B . ?\x045E) ;; CYRILLIC SMALL LETTER SHORT U
	 (?\,L(B . ?\x045F) ;; CYRILLIC SMALL LETTER DZHE
	 ))

      ;; Arabic probably isn't so useful in the absence of Arabic
      ;; language support.
      (ucs-8859-6-alist
       '((?,G (B . ?\x00A0)	;; NO-BREAK SPACE
	 (?,G$(B . ?\x00A4)	;; CURRENCY SIGN
	 (?,G,(B . ?\x060C)	;; ARABIC COMMA
	 (?,G-(B . ?\x00AD)	;; SOFT HYPHEN
	 (?,G;(B . ?\x061B)	;; ARABIC SEMICOLON
	 (?,G?(B . ?\x061F)	;; ARABIC QUESTION MARK
	 (?,GA(B . ?\x0621)	;; ARABIC LETTER HAMZA
	 (?,GB(B . ?\x0622)	;; ARABIC LETTER ALEF WITH MADDA ABOVE
	 (?,GC(B . ?\x0623)	;; ARABIC LETTER ALEF WITH HAMZA ABOVE
	 (?,GD(B . ?\x0624)	;; ARABIC LETTER WAW WITH HAMZA ABOVE
	 (?,GE(B . ?\x0625)	;; ARABIC LETTER ALEF WITH HAMZA BELOW
	 (?,GF(B . ?\x0626)	;; ARABIC LETTER YEH WITH HAMZA ABOVE
	 (?,GG(B . ?\x0627)	;; ARABIC LETTER ALEF
	 (?,GH(B . ?\x0628)	;; ARABIC LETTER BEH
	 (?,GI(B . ?\x0629)	;; ARABIC LETTER TEH MARBUTA
	 (?,GJ(B . ?\x062A)	;; ARABIC LETTER TEH
	 (?,GK(B . ?\x062B)	;; ARABIC LETTER THEH
	 (?,GL(B . ?\x062C)	;; ARABIC LETTER JEEM
	 (?,GM(B . ?\x062D)	;; ARABIC LETTER HAH
	 (?,GN(B . ?\x062E)	;; ARABIC LETTER KHAH
	 (?,GO(B . ?\x062F)	;; ARABIC LETTER DAL
	 (?,GP(B . ?\x0630)	;; ARABIC LETTER THAL
	 (?,GQ(B . ?\x0631)	;; ARABIC LETTER REH
	 (?,GR(B . ?\x0632)	;; ARABIC LETTER ZAIN
	 (?,GS(B . ?\x0633)	;; ARABIC LETTER SEEN
	 (?,GT(B . ?\x0634)	;; ARABIC LETTER SHEEN
	 (?,GU(B . ?\x0635)	;; ARABIC LETTER SAD
	 (?,GV(B . ?\x0636)	;; ARABIC LETTER DAD
	 (?,GW(B . ?\x0637)	;; ARABIC LETTER TAH
	 (?,GX(B . ?\x0638)	;; ARABIC LETTER ZAH
	 (?,GY(B . ?\x0639)	;; ARABIC LETTER AIN
	 (?,GZ(B . ?\x063A)	;; ARABIC LETTER GHAIN
	 (?,G`(B . ?\x0640)	;; ARABIC TATWEEL
	 (?,Ga(B . ?\x0641)	;; ARABIC LETTER FEH
	 (?,Gb(B . ?\x0642)	;; ARABIC LETTER QAF
	 (?,Gc(B . ?\x0643)	;; ARABIC LETTER KAF
	 (?,Gd(B . ?\x0644)	;; ARABIC LETTER LAM
	 (?,Ge(B . ?\x0645)	;; ARABIC LETTER MEEM
	 (?,Gf(B . ?\x0646)	;; ARABIC LETTER NOON
	 (?,Gg(B . ?\x0647)	;; ARABIC LETTER HEH
	 (?,Gh(B . ?\x0648)	;; ARABIC LETTER WAW
	 (?,Gi(B . ?\x0649)	;; ARABIC LETTER ALEF MAKSURA
	 (?,Gj(B . ?\x064A)	;; ARABIC LETTER YEH
	 (?,Gk(B . ?\x064B)	;; ARABIC FATHATAN
	 (?,Gl(B . ?\x064C)	;; ARABIC DAMMATAN
	 (?,Gm(B . ?\x064D)	;; ARABIC KASRATAN
	 (?,Gn(B . ?\x064E)	;; ARABIC FATHA
	 (?,Go(B . ?\x064F)	;; ARABIC DAMMA
	 (?,Gp(B . ?\x0650)	;; ARABIC KASRA
	 (?,Gq(B . ?\x0651)	;; ARABIC SHADDA
	 (?,Gr(B . ?\x0652)	;; ARABIC SUKUN
	 ))

      (ucs-8859-7-alist
       '((?\,F (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,F!(B . ?\x2018) ;; LEFT SINGLE QUOTATION MARK
	 (?\,F"(B . ?\x2019) ;; RIGHT SINGLE QUOTATION MARK
	 (?\,F#(B . ?\x00A3) ;; POUND SIGN
	 (?\,F&(B . ?\x00A6) ;; BROKEN BAR
	 (?\,F'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,F((B . ?\x00A8) ;; DIAERESIS
	 (?\,F)(B . ?\x00A9) ;; COPYRIGHT SIGN
	 (?\,F+(B . ?\x00AB) ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,F,(B . ?\x00AC) ;; NOT SIGN
	 (?\,F-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,F/(B . ?\x2015) ;; HORIZONTAL BAR
	 (?\,F0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,F1(B . ?\x00B1) ;; PLUS-MINUS SIGN
	 (?\,F2(B . ?\x00B2) ;; SUPERSCRIPT TWO
	 (?\,F3(B . ?\x00B3) ;; SUPERSCRIPT THREE
	 (?\,F4(B . ?\x0384) ;; GREEK TONOS
	 (?\,F5(B . ?\x0385) ;; GREEK DIALYTIKA TONOS
	 (?\,F6(B . ?\x0386) ;; GREEK CAPITAL LETTER ALPHA WITH TONOS
	 (?\,F7(B . ?\x00B7) ;; MIDDLE DOT
	 (?\,F8(B . ?\x0388) ;; GREEK CAPITAL LETTER EPSILON WITH TONOS
	 (?\,F9(B . ?\x0389) ;; GREEK CAPITAL LETTER ETA WITH TONOS
	 (?\,F:(B . ?\x038A) ;; GREEK CAPITAL LETTER IOTA WITH TONOS
	 (?\,F;(B . ?\x00BB) ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,F<(B . ?\x038C) ;; GREEK CAPITAL LETTER OMICRON WITH TONOS
	 (?\,F=(B . ?\x00BD) ;; VULGAR FRACTION ONE HALF
	 (?\,F>(B . ?\x038E) ;; GREEK CAPITAL LETTER UPSILON WITH TONOS
	 (?\,F?(B . ?\x038F) ;; GREEK CAPITAL LETTER OMEGA WITH TONOS
	 (?\,F@(B . ?\x0390) ;; GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
	 (?\,FA(B . ?\x0391) ;; GREEK CAPITAL LETTER ALPHA
	 (?\,FB(B . ?\x0392) ;; GREEK CAPITAL LETTER BETA
	 (?\,FC(B . ?\x0393) ;; GREEK CAPITAL LETTER GAMMA
	 (?\,FD(B . ?\x0394) ;; GREEK CAPITAL LETTER DELTA
	 (?\,FE(B . ?\x0395) ;; GREEK CAPITAL LETTER EPSILON
	 (?\,FF(B . ?\x0396) ;; GREEK CAPITAL LETTER ZETA
	 (?\,FG(B . ?\x0397) ;; GREEK CAPITAL LETTER ETA
	 (?\,FH(B . ?\x0398) ;; GREEK CAPITAL LETTER THETA
	 (?\,FI(B . ?\x0399) ;; GREEK CAPITAL LETTER IOTA
	 (?\,FJ(B . ?\x039A) ;; GREEK CAPITAL LETTER KAPPA
	 (?\,FK(B . ?\x039B) ;; GREEK CAPITAL LETTER LAMDA
	 (?\,FL(B . ?\x039C) ;; GREEK CAPITAL LETTER MU
	 (?\,FM(B . ?\x039D) ;; GREEK CAPITAL LETTER NU
	 (?\,FN(B . ?\x039E) ;; GREEK CAPITAL LETTER XI
	 (?\,FO(B . ?\x039F) ;; GREEK CAPITAL LETTER OMICRON
	 (?\,FP(B . ?\x03A0) ;; GREEK CAPITAL LETTER PI
	 (?\,FQ(B . ?\x03A1) ;; GREEK CAPITAL LETTER RHO
	 (?\,FS(B . ?\x03A3) ;; GREEK CAPITAL LETTER SIGMA
	 (?\,FT(B . ?\x03A4) ;; GREEK CAPITAL LETTER TAU
	 (?\,FU(B . ?\x03A5) ;; GREEK CAPITAL LETTER UPSILON
	 (?\,FV(B . ?\x03A6) ;; GREEK CAPITAL LETTER PHI
	 (?\,FW(B . ?\x03A7) ;; GREEK CAPITAL LETTER CHI
	 (?\,FX(B . ?\x03A8) ;; GREEK CAPITAL LETTER PSI
	 (?\,FY(B . ?\x03A9) ;; GREEK CAPITAL LETTER OMEGA
	 (?\,FZ(B . ?\x03AA) ;; GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
	 (?\,F[(B . ?\x03AB) ;; GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
	 (?\,F\(B . ?\x03AC) ;; GREEK SMALL LETTER ALPHA WITH TONOS
	 (?\,F](B . ?\x03AD) ;; GREEK SMALL LETTER EPSILON WITH TONOS
	 (?\,F^(B . ?\x03AE) ;; GREEK SMALL LETTER ETA WITH TONOS
	 (?\,F_(B . ?\x03AF) ;; GREEK SMALL LETTER IOTA WITH TONOS
	 (?\,F`(B . ?\x03B0) ;; GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
	 (?\,Fa(B . ?\x03B1) ;; GREEK SMALL LETTER ALPHA
	 (?\,Fb(B . ?\x03B2) ;; GREEK SMALL LETTER BETA
	 (?\,Fc(B . ?\x03B3) ;; GREEK SMALL LETTER GAMMA
	 (?\,Fd(B . ?\x03B4) ;; GREEK SMALL LETTER DELTA
	 (?\,Fe(B . ?\x03B5) ;; GREEK SMALL LETTER EPSILON
	 (?\,Ff(B . ?\x03B6) ;; GREEK SMALL LETTER ZETA
	 (?\,Fg(B . ?\x03B7) ;; GREEK SMALL LETTER ETA
	 (?\,Fh(B . ?\x03B8) ;; GREEK SMALL LETTER THETA
	 (?\,Fi(B . ?\x03B9) ;; GREEK SMALL LETTER IOTA
	 (?\,Fj(B . ?\x03BA) ;; GREEK SMALL LETTER KAPPA
	 (?\,Fk(B . ?\x03BB) ;; GREEK SMALL LETTER LAMDA
	 (?\,Fl(B . ?\x03BC) ;; GREEK SMALL LETTER MU
	 (?\,Fm(B . ?\x03BD) ;; GREEK SMALL LETTER NU
	 (?\,Fn(B . ?\x03BE) ;; GREEK SMALL LETTER XI
	 (?\,Fo(B . ?\x03BF) ;; GREEK SMALL LETTER OMICRON
	 (?\,Fp(B . ?\x03C0) ;; GREEK SMALL LETTER PI
	 (?\,Fq(B . ?\x03C1) ;; GREEK SMALL LETTER RHO
	 (?\,Fr(B . ?\x03C2) ;; GREEK SMALL LETTER FINAL SIGMA
	 (?\,Fs(B . ?\x03C3) ;; GREEK SMALL LETTER SIGMA
	 (?\,Ft(B . ?\x03C4) ;; GREEK SMALL LETTER TAU
	 (?\,Fu(B . ?\x03C5) ;; GREEK SMALL LETTER UPSILON
	 (?\,Fv(B . ?\x03C6) ;; GREEK SMALL LETTER PHI
	 (?\,Fw(B . ?\x03C7) ;; GREEK SMALL LETTER CHI
	 (?\,Fx(B . ?\x03C8) ;; GREEK SMALL LETTER PSI
	 (?\,Fy(B . ?\x03C9) ;; GREEK SMALL LETTER OMEGA
	 (?\,Fz(B . ?\x03CA) ;; GREEK SMALL LETTER IOTA WITH DIALYTIKA
	 (?\,F{(B . ?\x03CB) ;; GREEK SMALL LETTER UPSILON WITH DIALYTIKA
	 (?\,F|(B . ?\x03CC) ;; GREEK SMALL LETTER OMICRON WITH TONOS
	 (?\,F}(B . ?\x03CD) ;; GREEK SMALL LETTER UPSILON WITH TONOS
	 (?\,F~(B . ?\x03CE) ;; GREEK SMALL LETTER OMEGA WITH TONOS
	 ))

      (ucs-8859-8-alist
       '((?\,H (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,H"(B . ?\x00A2) ;; CENT SIGN
	 (?\,H#(B . ?\x00A3) ;; POUND SIGN
	 (?\,H$(B . ?\x00A4) ;; CURRENCY SIGN
	 (?\,H%(B . ?\x00A5) ;; YEN SIGN
	 (?\,H&(B . ?\x00A6) ;; BROKEN BAR
	 (?\,H'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,H((B . ?\x00A8) ;; DIAERESIS
	 (?\,H)(B . ?\x00A9) ;; COPYRIGHT SIGN
	 (?\,H*(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,H+(B . ?\x00AB) ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,H,(B . ?\x00AC) ;; NOT SIGN
	 (?\,H-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,H.(B . ?\x00AE) ;; REGISTERED SIGN
	 (?\,H/(B . ?\x00AF) ;; MACRON
	 (?\,H0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,H1(B . ?\x00B1) ;; PLUS-MINUS SIGN
	 (?\,H2(B . ?\x00B2) ;; SUPERSCRIPT TWO
	 (?\,H3(B . ?\x00B3) ;; SUPERSCRIPT THREE
	 (?\,H4(B . ?\x00B4) ;; ACUTE ACCENT
	 (?\,H5(B . ?\x00B5) ;; MICRO SIGN
	 (?\,H6(B . ?\x00B6) ;; PILCROW SIGN
	 (?\,H7(B . ?\x00B7) ;; MIDDLE DOT
	 (?\,H8(B . ?\x00B8) ;; CEDILLA
	 (?\,H9(B . ?\x00B9) ;; SUPERSCRIPT ONE
	 (?\,H:(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,H;(B . ?\x00BB) ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,H<(B . ?\x00BC) ;; VULGAR FRACTION ONE QUARTER
	 (?\,H=(B . ?\x00BD) ;; VULGAR FRACTION ONE HALF
	 (?\,H>(B . ?\x00BE) ;; VULGAR FRACTION THREE QUARTERS
	 (?\,H_(B . ?\x2017) ;; DOUBLE LOW LINE
	 (?\,H`(B . ?\x05D0) ;; HEBREW LETTER ALEF
	 (?\,Ha(B . ?\x05D1) ;; HEBREW LETTER BET
	 (?\,Hb(B . ?\x05D2) ;; HEBREW LETTER GIMEL
	 (?\,Hc(B . ?\x05D3) ;; HEBREW LETTER DALET
	 (?\,Hd(B . ?\x05D4) ;; HEBREW LETTER HE
	 (?\,He(B . ?\x05D5) ;; HEBREW LETTER VAV
	 (?\,Hf(B . ?\x05D6) ;; HEBREW LETTER ZAYIN
	 (?\,Hg(B . ?\x05D7) ;; HEBREW LETTER HET
	 (?\,Hh(B . ?\x05D8) ;; HEBREW LETTER TET
	 (?\,Hi(B . ?\x05D9) ;; HEBREW LETTER YOD
	 (?\,Hj(B . ?\x05DA) ;; HEBREW LETTER FINAL KAF
	 (?\,Hk(B . ?\x05DB) ;; HEBREW LETTER KAF
	 (?\,Hl(B . ?\x05DC) ;; HEBREW LETTER LAMED
	 (?\,Hm(B . ?\x05DD) ;; HEBREW LETTER FINAL MEM
	 (?\,Hn(B . ?\x05DE) ;; HEBREW LETTER MEM
	 (?\,Ho(B . ?\x05DF) ;; HEBREW LETTER FINAL NUN
	 (?\,Hp(B . ?\x05E0) ;; HEBREW LETTER NUN
	 (?\,Hq(B . ?\x05E1) ;; HEBREW LETTER SAMEKH
	 (?\,Hr(B . ?\x05E2) ;; HEBREW LETTER AYIN
	 (?\,Hs(B . ?\x05E3) ;; HEBREW LETTER FINAL PE
	 (?\,Ht(B . ?\x05E4) ;; HEBREW LETTER PE
	 (?\,Hu(B . ?\x05E5) ;; HEBREW LETTER FINAL TSADI
	 (?\,Hv(B . ?\x05E6) ;; HEBREW LETTER TSADI
	 (?\,Hw(B . ?\x05E7) ;; HEBREW LETTER QOF
	 (?\,Hx(B . ?\x05E8) ;; HEBREW LETTER RESH
	 (?\,Hy(B . ?\x05E9) ;; HEBREW LETTER SHIN
	 (?\,Hz(B . ?\x05EA) ;; HEBREW LETTER TAV
	 (?\,H}(B . ?\x200E) ;; LEFT-TO-RIGHT MARK
	 (?\,H~(B . ?\x200F) ;; RIGHT-TO-LEFT MARK
	 ))

      (ucs-8859-9-alist
       '((?\,M (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,M!(B . ?\x00A1) ;; INVERTED EXCLAMATION MARK
	 (?\,M"(B . ?\x00A2) ;; CENT SIGN
	 (?\,M#(B . ?\x00A3) ;; POUND SIGN
	 (?\,M$(B . ?\x00A4) ;; CURRENCY SIGN
	 (?\,M%(B . ?\x00A5) ;; YEN SIGN
	 (?\,M&(B . ?\x00A6) ;; BROKEN BAR
	 (?\,M'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,M((B . ?\x00A8) ;; DIAERESIS
	 (?\,M)(B . ?\x00A9) ;; COPYRIGHT SIGN
	 (?\,M*(B . ?\x00AA) ;; FEMININE ORDINAL INDICATOR
	 (?\,M+(B . ?\x00AB) ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,M,(B . ?\x00AC) ;; NOT SIGN
	 (?\,M-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,M.(B . ?\x00AE) ;; REGISTERED SIGN
	 (?\,M/(B . ?\x00AF) ;; MACRON
	 (?\,M0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,M1(B . ?\x00B1) ;; PLUS-MINUS SIGN
	 (?\,M2(B . ?\x00B2) ;; SUPERSCRIPT TWO
	 (?\,M3(B . ?\x00B3) ;; SUPERSCRIPT THREE
	 (?\,M4(B . ?\x00B4) ;; ACUTE ACCENT
	 (?\,M5(B . ?\x00B5) ;; MICRO SIGN
	 (?\,M6(B . ?\x00B6) ;; PILCROW SIGN
	 (?\,M7(B . ?\x00B7) ;; MIDDLE DOT
	 (?\,M8(B . ?\x00B8) ;; CEDILLA
	 (?\,M9(B . ?\x00B9) ;; SUPERSCRIPT ONE
	 (?\,M:(B . ?\x00BA) ;; MASCULINE ORDINAL INDICATOR
	 (?\,M;(B . ?\x00BB) ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,M<(B . ?\x00BC) ;; VULGAR FRACTION ONE QUARTER
	 (?\,M=(B . ?\x00BD) ;; VULGAR FRACTION ONE HALF
	 (?\,M>(B . ?\x00BE) ;; VULGAR FRACTION THREE QUARTERS
	 (?\,M?(B . ?\x00BF) ;; INVERTED QUESTION MARK
	 (?\,M@(B . ?\x00C0) ;; LATIN CAPITAL LETTER A WITH GRAVE
	 (?\,MA(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,MB(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,MC(B . ?\x00C3) ;; LATIN CAPITAL LETTER A WITH TILDE
	 (?\,MD(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,ME(B . ?\x00C5) ;; LATIN CAPITAL LETTER A WITH RING ABOVE
	 (?\,MF(B . ?\x00C6) ;; LATIN CAPITAL LETTER AE
	 (?\,MG(B . ?\x00C7) ;; LATIN CAPITAL LETTER C WITH CEDILLA
	 (?\,MH(B . ?\x00C8) ;; LATIN CAPITAL LETTER E WITH GRAVE
	 (?\,MI(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,MJ(B . ?\x00CA) ;; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	 (?\,MK(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,ML(B . ?\x00CC) ;; LATIN CAPITAL LETTER I WITH GRAVE
	 (?\,MM(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,MN(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,MO(B . ?\x00CF) ;; LATIN CAPITAL LETTER I WITH DIAERESIS
	 (?\,MP(B . ?\x011E) ;; LATIN CAPITAL LETTER G WITH BREVE
	 (?\,MQ(B . ?\x00D1) ;; LATIN CAPITAL LETTER N WITH TILDE
	 (?\,MR(B . ?\x00D2) ;; LATIN CAPITAL LETTER O WITH GRAVE
	 (?\,MS(B . ?\x00D3) ;; LATIN CAPITAL LETTER O WITH ACUTE
	 (?\,MT(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,MU(B . ?\x00D5) ;; LATIN CAPITAL LETTER O WITH TILDE
	 (?\,MV(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,MW(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,MX(B . ?\x00D8) ;; LATIN CAPITAL LETTER O WITH STROKE
	 (?\,MY(B . ?\x00D9) ;; LATIN CAPITAL LETTER U WITH GRAVE
	 (?\,MZ(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,M[(B . ?\x00DB) ;; LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	 (?\,M\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,M](B . ?\x0130) ;; LATIN CAPITAL LETTER I WITH DOT ABOVE
	 (?\,M^(B . ?\x015E) ;; LATIN CAPITAL LETTER S WITH CEDILLA
	 (?\,M_(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,M`(B . ?\x00E0) ;; LATIN SMALL LETTER A WITH GRAVE
	 (?\,Ma(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,Mb(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,Mc(B . ?\x00E3) ;; LATIN SMALL LETTER A WITH TILDE
	 (?\,Md(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,Me(B . ?\x00E5) ;; LATIN SMALL LETTER A WITH RING ABOVE
	 (?\,Mf(B . ?\x00E6) ;; LATIN SMALL LETTER AE
	 (?\,Mg(B . ?\x00E7) ;; LATIN SMALL LETTER C WITH CEDILLA
	 (?\,Mh(B . ?\x00E8) ;; LATIN SMALL LETTER E WITH GRAVE
	 (?\,Mi(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,Mj(B . ?\x00EA) ;; LATIN SMALL LETTER E WITH CIRCUMFLEX
	 (?\,Mk(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,Ml(B . ?\x00EC) ;; LATIN SMALL LETTER I WITH GRAVE
	 (?\,Mm(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,Mn(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,Mo(B . ?\x00EF) ;; LATIN SMALL LETTER I WITH DIAERESIS
	 (?\,Mp(B . ?\x011F) ;; LATIN SMALL LETTER G WITH BREVE
	 (?\,Mq(B . ?\x00F1) ;; LATIN SMALL LETTER N WITH TILDE
	 (?\,Mr(B . ?\x00F2) ;; LATIN SMALL LETTER O WITH GRAVE
	 (?\,Ms(B . ?\x00F3) ;; LATIN SMALL LETTER O WITH ACUTE
	 (?\,Mt(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,Mu(B . ?\x00F5) ;; LATIN SMALL LETTER O WITH TILDE
	 (?\,Mv(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,Mw(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,Mx(B . ?\x00F8) ;; LATIN SMALL LETTER O WITH STROKE
	 (?\,My(B . ?\x00F9) ;; LATIN SMALL LETTER U WITH GRAVE
	 (?\,Mz(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,M{(B . ?\x00FB) ;; LATIN SMALL LETTER U WITH CIRCUMFLEX
	 (?\,M|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,M}(B . ?\x0131) ;; LATIN SMALL LETTER DOTLESS I
	 (?\,M~(B . ?\x015F) ;; LATIN SMALL LETTER S WITH CEDILLA
	 (?\,M(B . ?\x00FF) ;; LATIN SMALL LETTER Y WITH DIAERESIS
	 ))

      (ucs-8859-14-alist
       '((?\,_ (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,_!(B . ?\x1E02) ;; LATIN CAPITAL LETTER B WITH DOT ABOVE
	 (?\,_"(B . ?\x1E03) ;; LATIN SMALL LETTER B WITH DOT ABOVE
	 (?\,_#(B . ?\x00A3) ;; POUND SIGN
	 (?\,_$(B . ?\x010A) ;; LATIN CAPITAL LETTER C WITH DOT ABOVE
	 (?\,_%(B . ?\x010B) ;; LATIN SMALL LETTER C WITH DOT ABOVE
	 (?\,_&(B . ?\x1E0A) ;; LATIN CAPITAL LETTER D WITH DOT ABOVE
	 (?\,_'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,_((B . ?\x1E80) ;; LATIN CAPITAL LETTER W WITH GRAVE
	 (?\,_)(B . ?\x00A9) ;; COPYRIGHT SIGN
	 (?\,_*(B . ?\x1E82) ;; LATIN CAPITAL LETTER W WITH ACUTE
	 (?\,_+(B . ?\x1E0B) ;; LATIN SMALL LETTER D WITH DOT ABOVE
	 (?\,_,(B . ?\x1EF2) ;; LATIN CAPITAL LETTER Y WITH GRAVE
	 (?\,_-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,_.(B . ?\x00AE) ;; REGISTERED SIGN
	 (?\,_/(B . ?\x0178) ;; LATIN CAPITAL LETTER Y WITH DIAERESIS
	 (?\,_0(B . ?\x1E1E) ;; LATIN CAPITAL LETTER F WITH DOT ABOVE
	 (?\,_1(B . ?\x1E1F) ;; LATIN SMALL LETTER F WITH DOT ABOVE
	 (?\,_2(B . ?\x0120) ;; LATIN CAPITAL LETTER G WITH DOT ABOVE
	 (?\,_3(B . ?\x0121) ;; LATIN SMALL LETTER G WITH DOT ABOVE
	 (?\,_4(B . ?\x1E40) ;; LATIN CAPITAL LETTER M WITH DOT ABOVE
	 (?\,_5(B . ?\x1E41) ;; LATIN SMALL LETTER M WITH DOT ABOVE
	 (?\,_6(B . ?\x00B6) ;; PILCROW SIGN
	 (?\,_7(B . ?\x1E56) ;; LATIN CAPITAL LETTER P WITH DOT ABOVE
	 (?\,_8(B . ?\x1E81) ;; LATIN SMALL LETTER W WITH GRAVE
	 (?\,_9(B . ?\x1E57) ;; LATIN SMALL LETTER P WITH DOT ABOVE
	 (?\,_:(B . ?\x1E83) ;; LATIN SMALL LETTER W WITH ACUTE
	 (?\,_;(B . ?\x1E60) ;; LATIN CAPITAL LETTER S WITH DOT ABOVE
	 (?\,_<(B . ?\x1EF3) ;; LATIN SMALL LETTER Y WITH GRAVE
	 (?\,_=(B . ?\x1E84) ;; LATIN CAPITAL LETTER W WITH DIAERESIS
	 (?\,_>(B . ?\x1E85) ;; LATIN SMALL LETTER W WITH DIAERESIS
	 (?\,_?(B . ?\x1E61) ;; LATIN SMALL LETTER S WITH DOT ABOVE
	 (?\,_@(B . ?\x00C0) ;; LATIN CAPITAL LETTER A WITH GRAVE
	 (?\,_A(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,_B(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,_C(B . ?\x00C3) ;; LATIN CAPITAL LETTER A WITH TILDE
	 (?\,_D(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,_E(B . ?\x00C5) ;; LATIN CAPITAL LETTER A WITH RING ABOVE
	 (?\,_F(B . ?\x00C6) ;; LATIN CAPITAL LETTER AE
	 (?\,_G(B . ?\x00C7) ;; LATIN CAPITAL LETTER C WITH CEDILLA
	 (?\,_H(B . ?\x00C8) ;; LATIN CAPITAL LETTER E WITH GRAVE
	 (?\,_I(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,_J(B . ?\x00CA) ;; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	 (?\,_K(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,_L(B . ?\x00CC) ;; LATIN CAPITAL LETTER I WITH GRAVE
	 (?\,_M(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,_N(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,_O(B . ?\x00CF) ;; LATIN CAPITAL LETTER I WITH DIAERESIS
	 (?\,_P(B . ?\x0174) ;; LATIN CAPITAL LETTER W WITH CIRCUMFLEX
	 (?\,_Q(B . ?\x00D1) ;; LATIN CAPITAL LETTER N WITH TILDE
	 (?\,_R(B . ?\x00D2) ;; LATIN CAPITAL LETTER O WITH GRAVE
	 (?\,_S(B . ?\x00D3) ;; LATIN CAPITAL LETTER O WITH ACUTE
	 (?\,_T(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,_U(B . ?\x00D5) ;; LATIN CAPITAL LETTER O WITH TILDE
	 (?\,_V(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,_W(B . ?\x1E6A) ;; LATIN CAPITAL LETTER T WITH DOT ABOVE
	 (?\,_X(B . ?\x00D8) ;; LATIN CAPITAL LETTER O WITH STROKE
	 (?\,_Y(B . ?\x00D9) ;; LATIN CAPITAL LETTER U WITH GRAVE
	 (?\,_Z(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,_[(B . ?\x00DB) ;; LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	 (?\,_\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,_](B . ?\x00DD) ;; LATIN CAPITAL LETTER Y WITH ACUTE
	 (?\,_^(B . ?\x0176) ;; LATIN CAPITAL LETTER Y WITH CIRCUMFLEX
	 (?\,__(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,_`(B . ?\x00E0) ;; LATIN SMALL LETTER A WITH GRAVE
	 (?\,_a(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,_b(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,_c(B . ?\x00E3) ;; LATIN SMALL LETTER A WITH TILDE
	 (?\,_d(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,_e(B . ?\x00E5) ;; LATIN SMALL LETTER A WITH RING ABOVE
	 (?\,_f(B . ?\x00E6) ;; LATIN SMALL LETTER AE
	 (?\,_g(B . ?\x00E7) ;; LATIN SMALL LETTER C WITH CEDILLA
	 (?\,_h(B . ?\x00E8) ;; LATIN SMALL LETTER E WITH GRAVE
	 (?\,_i(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,_j(B . ?\x00EA) ;; LATIN SMALL LETTER E WITH CIRCUMFLEX
	 (?\,_k(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,_l(B . ?\x00EC) ;; LATIN SMALL LETTER I WITH GRAVE
	 (?\,_m(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,_n(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,_o(B . ?\x00EF) ;; LATIN SMALL LETTER I WITH DIAERESIS
	 (?\,_p(B . ?\x0175) ;; LATIN SMALL LETTER W WITH CIRCUMFLEX
	 (?\,_q(B . ?\x00F1) ;; LATIN SMALL LETTER N WITH TILDE
	 (?\,_r(B . ?\x00F2) ;; LATIN SMALL LETTER O WITH GRAVE
	 (?\,_s(B . ?\x00F3) ;; LATIN SMALL LETTER O WITH ACUTE
	 (?\,_t(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,_u(B . ?\x00F5) ;; LATIN SMALL LETTER O WITH TILDE
	 (?\,_v(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,_w(B . ?\x1E6B) ;; LATIN SMALL LETTER T WITH DOT ABOVE
	 (?\,_x(B . ?\x00F8) ;; LATIN SMALL LETTER O WITH STROKE
	 (?\,_y(B . ?\x00F9) ;; LATIN SMALL LETTER U WITH GRAVE
	 (?\,_z(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,_{(B . ?\x00FB) ;; LATIN SMALL LETTER U WITH CIRCUMFLEX
	 (?\,_|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,_}(B . ?\x00FD) ;; LATIN SMALL LETTER Y WITH ACUTE
	 (?\,_~(B . ?\x0177) ;; LATIN SMALL LETTER Y WITH CIRCUMFLEX
	 (?\,_(B . ?\x00FF) ;; LATIN SMALL LETTER Y WITH DIAERESIS
	 ))

      (ucs-8859-15-alist
       '((?\,b (B . ?\x00A0) ;; NO-BREAK SPACE
	 (?\,b!(B . ?\x00A1) ;; INVERTED EXCLAMATION MARK
	 (?\,b"(B . ?\x00A2) ;; CENT SIGN
	 (?\,b#(B . ?\x00A3) ;; POUND SIGN
	 (?\,b$(B . ?\x20AC) ;; EURO SIGN
	 (?\,b%(B . ?\x00A5) ;; YEN SIGN
	 (?\,b&(B . ?\x0160) ;; LATIN CAPITAL LETTER S WITH CARON
	 (?\,b'(B . ?\x00A7) ;; SECTION SIGN
	 (?\,b((B . ?\x0161) ;; LATIN SMALL LETTER S WITH CARON
	 (?\,b)(B . ?\x00A9) ;; COPYRIGHT SIGN
	 (?\,b*(B . ?\x00AA) ;; FEMININE ORDINAL INDICATOR
	 (?\,b+(B . ?\x00AB) ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,b,(B . ?\x00AC) ;; NOT SIGN
	 (?\,b-(B . ?\x00AD) ;; SOFT HYPHEN
	 (?\,b.(B . ?\x00AE) ;; REGISTERED SIGN
	 (?\,b/(B . ?\x00AF) ;; MACRON
	 (?\,b0(B . ?\x00B0) ;; DEGREE SIGN
	 (?\,b1(B . ?\x00B1) ;; PLUS-MINUS SIGN
	 (?\,b2(B . ?\x00B2) ;; SUPERSCRIPT TWO
	 (?\,b3(B . ?\x00B3) ;; SUPERSCRIPT THREE
	 (?\,b4(B . ?\x017D) ;; LATIN CAPITAL LETTER Z WITH CARON
	 (?\,b5(B . ?\x00B5) ;; MICRO SIGN
	 (?\,b6(B . ?\x00B6) ;; PILCROW SIGN
	 (?\,b7(B . ?\x00B7) ;; MIDDLE DOT
	 (?\,b8(B . ?\x017E) ;; LATIN SMALL LETTER Z WITH CARON
	 (?\,b9(B . ?\x00B9) ;; SUPERSCRIPT ONE
	 (?\,b:(B . ?\x00BA) ;; MASCULINE ORDINAL INDICATOR
	 (?\,b;(B . ?\x00BB) ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\,b<(B . ?\x0152) ;; LATIN CAPITAL LIGATURE OE
	 (?\,b=(B . ?\x0153) ;; LATIN SMALL LIGATURE OE
	 (?\,b>(B . ?\x0178) ;; LATIN CAPITAL LETTER Y WITH DIAERESIS
	 (?\,b?(B . ?\x00BF) ;; INVERTED QUESTION MARK
	 (?\,b@(B . ?\x00C0) ;; LATIN CAPITAL LETTER A WITH GRAVE
	 (?\,bA(B . ?\x00C1) ;; LATIN CAPITAL LETTER A WITH ACUTE
	 (?\,bB(B . ?\x00C2) ;; LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	 (?\,bC(B . ?\x00C3) ;; LATIN CAPITAL LETTER A WITH TILDE
	 (?\,bD(B . ?\x00C4) ;; LATIN CAPITAL LETTER A WITH DIAERESIS
	 (?\,bE(B . ?\x00C5) ;; LATIN CAPITAL LETTER A WITH RING ABOVE
	 (?\,bF(B . ?\x00C6) ;; LATIN CAPITAL LETTER AE
	 (?\,bG(B . ?\x00C7) ;; LATIN CAPITAL LETTER C WITH CEDILLA
	 (?\,bH(B . ?\x00C8) ;; LATIN CAPITAL LETTER E WITH GRAVE
	 (?\,bI(B . ?\x00C9) ;; LATIN CAPITAL LETTER E WITH ACUTE
	 (?\,bJ(B . ?\x00CA) ;; LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	 (?\,bK(B . ?\x00CB) ;; LATIN CAPITAL LETTER E WITH DIAERESIS
	 (?\,bL(B . ?\x00CC) ;; LATIN CAPITAL LETTER I WITH GRAVE
	 (?\,bM(B . ?\x00CD) ;; LATIN CAPITAL LETTER I WITH ACUTE
	 (?\,bN(B . ?\x00CE) ;; LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	 (?\,bO(B . ?\x00CF) ;; LATIN CAPITAL LETTER I WITH DIAERESIS
	 (?\,bP(B . ?\x00D0) ;; LATIN CAPITAL LETTER ETH
	 (?\,bQ(B . ?\x00D1) ;; LATIN CAPITAL LETTER N WITH TILDE
	 (?\,bR(B . ?\x00D2) ;; LATIN CAPITAL LETTER O WITH GRAVE
	 (?\,bS(B . ?\x00D3) ;; LATIN CAPITAL LETTER O WITH ACUTE
	 (?\,bT(B . ?\x00D4) ;; LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	 (?\,bU(B . ?\x00D5) ;; LATIN CAPITAL LETTER O WITH TILDE
	 (?\,bV(B . ?\x00D6) ;; LATIN CAPITAL LETTER O WITH DIAERESIS
	 (?\,bW(B . ?\x00D7) ;; MULTIPLICATION SIGN
	 (?\,bX(B . ?\x00D8) ;; LATIN CAPITAL LETTER O WITH STROKE
	 (?\,bY(B . ?\x00D9) ;; LATIN CAPITAL LETTER U WITH GRAVE
	 (?\,bZ(B . ?\x00DA) ;; LATIN CAPITAL LETTER U WITH ACUTE
	 (?\,b[(B . ?\x00DB) ;; LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	 (?\,b\(B . ?\x00DC) ;; LATIN CAPITAL LETTER U WITH DIAERESIS
	 (?\,b](B . ?\x00DD) ;; LATIN CAPITAL LETTER Y WITH ACUTE
	 (?\,b^(B . ?\x00DE) ;; LATIN CAPITAL LETTER THORN
	 (?\,b_(B . ?\x00DF) ;; LATIN SMALL LETTER SHARP S
	 (?\,b`(B . ?\x00E0) ;; LATIN SMALL LETTER A WITH GRAVE
	 (?\,ba(B . ?\x00E1) ;; LATIN SMALL LETTER A WITH ACUTE
	 (?\,bb(B . ?\x00E2) ;; LATIN SMALL LETTER A WITH CIRCUMFLEX
	 (?\,bc(B . ?\x00E3) ;; LATIN SMALL LETTER A WITH TILDE
	 (?\,bd(B . ?\x00E4) ;; LATIN SMALL LETTER A WITH DIAERESIS
	 (?\,be(B . ?\x00E5) ;; LATIN SMALL LETTER A WITH RING ABOVE
	 (?\,bf(B . ?\x00E6) ;; LATIN SMALL LETTER AE
	 (?\,bg(B . ?\x00E7) ;; LATIN SMALL LETTER C WITH CEDILLA
	 (?\,bh(B . ?\x00E8) ;; LATIN SMALL LETTER E WITH GRAVE
	 (?\,bi(B . ?\x00E9) ;; LATIN SMALL LETTER E WITH ACUTE
	 (?\,bj(B . ?\x00EA) ;; LATIN SMALL LETTER E WITH CIRCUMFLEX
	 (?\,bk(B . ?\x00EB) ;; LATIN SMALL LETTER E WITH DIAERESIS
	 (?\,bl(B . ?\x00EC) ;; LATIN SMALL LETTER I WITH GRAVE
	 (?\,bm(B . ?\x00ED) ;; LATIN SMALL LETTER I WITH ACUTE
	 (?\,bn(B . ?\x00EE) ;; LATIN SMALL LETTER I WITH CIRCUMFLEX
	 (?\,bo(B . ?\x00EF) ;; LATIN SMALL LETTER I WITH DIAERESIS
	 (?\,bp(B . ?\x00F0) ;; LATIN SMALL LETTER ETH
	 (?\,bq(B . ?\x00F1) ;; LATIN SMALL LETTER N WITH TILDE
	 (?\,br(B . ?\x00F2) ;; LATIN SMALL LETTER O WITH GRAVE
	 (?\,bs(B . ?\x00F3) ;; LATIN SMALL LETTER O WITH ACUTE
	 (?\,bt(B . ?\x00F4) ;; LATIN SMALL LETTER O WITH CIRCUMFLEX
	 (?\,bu(B . ?\x00F5) ;; LATIN SMALL LETTER O WITH TILDE
	 (?\,bv(B . ?\x00F6) ;; LATIN SMALL LETTER O WITH DIAERESIS
	 (?\,bw(B . ?\x00F7) ;; DIVISION SIGN
	 (?\,bx(B . ?\x00F8) ;; LATIN SMALL LETTER O WITH STROKE
	 (?\,by(B . ?\x00F9) ;; LATIN SMALL LETTER U WITH GRAVE
	 (?\,bz(B . ?\x00FA) ;; LATIN SMALL LETTER U WITH ACUTE
	 (?\,b{(B . ?\x00FB) ;; LATIN SMALL LETTER U WITH CIRCUMFLEX
	 (?\,b|(B . ?\x00FC) ;; LATIN SMALL LETTER U WITH DIAERESIS
	 (?\,b}(B . ?\x00FD) ;; LATIN SMALL LETTER Y WITH ACUTE
	 (?\,b~(B . ?\x00FE) ;; LATIN SMALL LETTER THORN
	 (?\,b(B . ?\x00FF) ;; LATIN SMALL LETTER Y WITH DIAERESIS
	 ))

      (ucs-8859-1-alist
       (let ((i 160)
	     l)
	 (while (< i 256)
	   (push (cons (make-char 'latin-iso8859-1 (- i 128)) i)
		 l)
	   (setq i (1+ i)))
	 (nreverse l)))

      (ucs-mirror-table
       '((?\x0028 . ?\x0029) ;; LEFT PARENTHESIS
	 (?\x0029 . ?\x0028) ;; RIGHT PARENTHESIS
	 (?\x003C . ?\x003E) ;; LESS-THAN SIGN
	 (?\x003E . ?\x003C) ;; GREATER-THAN SIGN
	 (?\x005B . ?\x005D) ;; LEFT SQUARE BRACKET
	 (?\x005D . ?\x005B) ;; RIGHT SQUARE BRACKET
	 (?\x007B . ?\x007D) ;; LEFT CURLY BRACKET
	 (?\x007D . ?\x007B) ;; RIGHT CURLY BRACKET
	 (?\x00AB . ?\x00BB) ;; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\x00BB . ?\x00AB) ;; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	 (?\x2039 . ?\x203A) ;; SINGLE LEFT-POINTING ANGLE QUOTATION MARK
	 (?\x203A . ?\x2039) ;; SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
	 (?\x2045 . ?\x2046) ;; LEFT SQUARE BRACKET WITH QUILL
	 (?\x2046 . ?\x2045) ;; RIGHT SQUARE BRACKET WITH QUILL
	 (?\x207D . ?\x207E) ;; SUPERSCRIPT LEFT PARENTHESIS
	 (?\x207E . ?\x207D) ;; SUPERSCRIPT RIGHT PARENTHESIS
	 (?\x208D . ?\x208E) ;; SUBSCRIPT LEFT PARENTHESIS
	 (?\x208E . ?\x208D) ;; SUBSCRIPT RIGHT PARENTHESIS
	 (?\x2208 . ?\x220B) ;; ELEMENT OF
	 (?\x2209 . ?\x220C) ;; NOT AN ELEMENT OF
	 (?\x220A . ?\x220D) ;; SMALL ELEMENT OF
	 (?\x220B . ?\x2208) ;; CONTAINS AS MEMBER
	 (?\x220C . ?\x2209) ;; DOES NOT CONTAIN AS MEMBER
	 (?\x220D . ?\x220A) ;; SMALL CONTAINS AS MEMBER
	 (?\x223C . ?\x223D) ;; TILDE OPERATOR
	 (?\x223D . ?\x223C) ;; REVERSED TILDE
	 (?\x2243 . ?\x22CD) ;; ASYMPTOTICALLY EQUAL TO
	 (?\x2252 . ?\x2253) ;; APPROXIMATELY EQUAL TO OR THE IMAGE OF
	 (?\x2253 . ?\x2252) ;; IMAGE OF OR APPROXIMATELY EQUAL TO
	 (?\x2254 . ?\x2255) ;; COLON EQUALS
	 (?\x2255 . ?\x2254) ;; EQUALS COLON
	 (?\x2264 . ?\x2265) ;; LESS-THAN OR EQUAL TO
	 (?\x2265 . ?\x2264) ;; GREATER-THAN OR EQUAL TO
	 (?\x2266 . ?\x2267) ;; LESS-THAN OVER EQUAL TO
	 (?\x2267 . ?\x2266) ;; GREATER-THAN OVER EQUAL TO
	 (?\x2268 . ?\x2269) ;; [BEST FIT] LESS-THAN BUT NOT EQUAL TO
	 (?\x2269 . ?\x2268) ;; [BEST FIT] GREATER-THAN BUT NOT EQUAL TO
	 (?\x226A . ?\x226B) ;; MUCH LESS-THAN
	 (?\x226B . ?\x226A) ;; MUCH GREATER-THAN
	 (?\x226E . ?\x226F) ;; [BEST FIT] NOT LESS-THAN
	 (?\x226F . ?\x226E) ;; [BEST FIT] NOT GREATER-THAN
	 (?\x2270 . ?\x2271) ;; [BEST FIT] NEITHER LESS-THAN NOR EQUAL TO
	 (?\x2271 . ?\x2270) ;; [BEST FIT] NEITHER GREATER-THAN NOR EQUAL TO
	 (?\x2272 . ?\x2273) ;; [BEST FIT] LESS-THAN OR EQUIVALENT TO
	 (?\x2273 . ?\x2272) ;; [BEST FIT] GREATER-THAN OR EQUIVALENT TO
	 (?\x2274 . ?\x2275) ;; [BEST FIT] NEITHER LESS-THAN NOR EQUIVALENT TO
	 (?\x2275 . ?\x2274) ;; [BEST FIT] NEITHER GREATER-THAN NOR EQUIVALENT TO
	 (?\x2276 . ?\x2277) ;; LESS-THAN OR GREATER-THAN
	 (?\x2277 . ?\x2276) ;; GREATER-THAN OR LESS-THAN
	 (?\x2278 . ?\x2279) ;; NEITHER LESS-THAN NOR GREATER-THAN
	 (?\x2279 . ?\x2278) ;; NEITHER GREATER-THAN NOR LESS-THAN
	 (?\x227A . ?\x227B) ;; PRECEDES
	 (?\x227B . ?\x227A) ;; SUCCEEDS
	 (?\x227C . ?\x227D) ;; PRECEDES OR EQUAL TO
	 (?\x227D . ?\x227C) ;; SUCCEEDS OR EQUAL TO
	 (?\x227E . ?\x227F) ;; [BEST FIT] PRECEDES OR EQUIVALENT TO
	 (?\x227F . ?\x227E) ;; [BEST FIT] SUCCEEDS OR EQUIVALENT TO
	 (?\x2280 . ?\x2281) ;; [BEST FIT] DOES NOT PRECEDE
	 (?\x2281 . ?\x2280) ;; [BEST FIT] DOES NOT SUCCEED
	 (?\x2282 . ?\x2283) ;; SUBSET OF
	 (?\x2283 . ?\x2282) ;; SUPERSET OF
	 (?\x2284 . ?\x2285) ;; [BEST FIT] NOT A SUBSET OF
	 (?\x2285 . ?\x2284) ;; [BEST FIT] NOT A SUPERSET OF
	 (?\x2286 . ?\x2287) ;; SUBSET OF OR EQUAL TO
	 (?\x2287 . ?\x2286) ;; SUPERSET OF OR EQUAL TO
	 (?\x2288 . ?\x2289) ;; [BEST FIT] NEITHER A SUBSET OF NOR EQUAL TO
	 (?\x2289 . ?\x2288) ;; [BEST FIT] NEITHER A SUPERSET OF NOR EQUAL TO
	 (?\x228A . ?\x228B) ;; [BEST FIT] SUBSET OF WITH NOT EQUAL TO
	 (?\x228B . ?\x228A) ;; [BEST FIT] SUPERSET OF WITH NOT EQUAL TO
	 (?\x228F . ?\x2290) ;; SQUARE IMAGE OF
	 (?\x2290 . ?\x228F) ;; SQUARE ORIGINAL OF
	 (?\x2291 . ?\x2292) ;; SQUARE IMAGE OF OR EQUAL TO
	 (?\x2292 . ?\x2291) ;; SQUARE ORIGINAL OF OR EQUAL TO
	 (?\x22A2 . ?\x22A3) ;; RIGHT TACK
	 (?\x22A3 . ?\x22A2) ;; LEFT TACK
	 (?\x22B0 . ?\x22B1) ;; PRECEDES UNDER RELATION
	 (?\x22B1 . ?\x22B0) ;; SUCCEEDS UNDER RELATION
	 (?\x22B2 . ?\x22B3) ;; NORMAL SUBGROUP OF
	 (?\x22B3 . ?\x22B2) ;; CONTAINS AS NORMAL SUBGROUP
	 (?\x22B4 . ?\x22B5) ;; NORMAL SUBGROUP OF OR EQUAL TO
	 (?\x22B5 . ?\x22B4) ;; CONTAINS AS NORMAL SUBGROUP OR EQUAL TO
	 (?\x22B6 . ?\x22B7) ;; ORIGINAL OF
	 (?\x22B7 . ?\x22B6) ;; IMAGE OF
	 (?\x22C9 . ?\x22CA) ;; LEFT NORMAL FACTOR SEMIDIRECT PRODUCT
	 (?\x22CA . ?\x22C9) ;; RIGHT NORMAL FACTOR SEMIDIRECT PRODUCT
	 (?\x22CB . ?\x22CC) ;; LEFT SEMIDIRECT PRODUCT
	 (?\x22CC . ?\x22CB) ;; RIGHT SEMIDIRECT PRODUCT
	 (?\x22CD . ?\x2243) ;; REVERSED TILDE EQUALS
	 (?\x22D0 . ?\x22D1) ;; DOUBLE SUBSET
	 (?\x22D1 . ?\x22D0) ;; DOUBLE SUPERSET
	 (?\x22D6 . ?\x22D7) ;; LESS-THAN WITH DOT
	 (?\x22D7 . ?\x22D6) ;; GREATER-THAN WITH DOT
	 (?\x22D8 . ?\x22D9) ;; VERY MUCH LESS-THAN
	 (?\x22D9 . ?\x22D8) ;; VERY MUCH GREATER-THAN
	 (?\x22DA . ?\x22DB) ;; LESS-THAN EQUAL TO OR GREATER-THAN
	 (?\x22DB . ?\x22DA) ;; GREATER-THAN EQUAL TO OR LESS-THAN
	 (?\x22DC . ?\x22DD) ;; EQUAL TO OR LESS-THAN
	 (?\x22DD . ?\x22DC) ;; EQUAL TO OR GREATER-THAN
	 (?\x22DE . ?\x22DF) ;; EQUAL TO OR PRECEDES
	 (?\x22DF . ?\x22DE) ;; EQUAL TO OR SUCCEEDS
	 (?\x22E0 . ?\x22E1) ;; [BEST FIT] DOES NOT PRECEDE OR EQUAL
	 (?\x22E1 . ?\x22E0) ;; [BEST FIT] DOES NOT SUCCEED OR EQUAL
	 (?\x22E2 . ?\x22E3) ;; [BEST FIT] NOT SQUARE IMAGE OF OR EQUAL TO
	 (?\x22E3 . ?\x22E2) ;; [BEST FIT] NOT SQUARE ORIGINAL OF OR EQUAL TO
	 (?\x22E4 . ?\x22E5) ;; [BEST FIT] SQUARE IMAGE OF OR NOT EQUAL TO
	 (?\x22E5 . ?\x22E4) ;; [BEST FIT] SQUARE ORIGINAL OF OR NOT EQUAL TO
	 (?\x22E6 . ?\x22E7) ;; [BEST FIT] LESS-THAN BUT NOT EQUIVALENT TO
	 (?\x22E7 . ?\x22E6) ;; [BEST FIT] GREATER-THAN BUT NOT EQUIVALENT TO
	 (?\x22E8 . ?\x22E9) ;; [BEST FIT] PRECEDES BUT NOT EQUIVALENT TO
	 (?\x22E9 . ?\x22E8) ;; [BEST FIT] SUCCEEDS BUT NOT EQUIVALENT TO
	 (?\x22EA . ?\x22EB) ;; [BEST FIT] NOT NORMAL SUBGROUP OF
	 (?\x22EB . ?\x22EA) ;; [BEST FIT] DOES NOT CONTAIN AS NORMAL SUBGROUP
	 (?\x22EC . ?\x22ED) ;; [BEST FIT] NOT NORMAL SUBGROUP OF OR EQUAL TO
	 (?\x22ED . ?\x22EC) ;; [BEST FIT] DOES NOT CONTAIN AS NORMAL SUBGROUP OR EQUAL
	 (?\x22F0 . ?\x22F1) ;; UP RIGHT DIAGONAL ELLIPSIS
	 (?\x22F1 . ?\x22F0) ;; DOWN RIGHT DIAGONAL ELLIPSIS
	 (?\x2308 . ?\x2309) ;; LEFT CEILING
	 (?\x2309 . ?\x2308) ;; RIGHT CEILING
	 (?\x230A . ?\x230B) ;; LEFT FLOOR
	 (?\x230B . ?\x230A) ;; RIGHT FLOOR
	 (?\x2329 . ?\x232A) ;; LEFT-POINTING ANGLE BRACKET
	 (?\x232A . ?\x2329) ;; RIGHT-POINTING ANGLE BRACKET
	 (?\x3008 . ?\x3009) ;; LEFT ANGLE BRACKET
	 (?\x3009 . ?\x3008) ;; RIGHT ANGLE BRACKET
	 (?\x300A . ?\x300B) ;; LEFT DOUBLE ANGLE BRACKET
	 (?\x300B . ?\x300A) ;; RIGHT DOUBLE ANGLE BRACKET
	 (?\x300C . ?\x300D) ;; [BEST FIT] LEFT CORNER BRACKET
	 (?\x300D . ?\x300C) ;; [BEST FIT] RIGHT CORNER BRACKET
	 (?\x300E . ?\x300F) ;; [BEST FIT] LEFT WHITE CORNER BRACKET
	 (?\x300F . ?\x300E) ;; [BEST FIT] RIGHT WHITE CORNER BRACKET
	 (?\x3010 . ?\x3011) ;; LEFT BLACK LENTICULAR BRACKET
	 (?\x3011 . ?\x3010) ;; RIGHT BLACK LENTICULAR BRACKET
	 (?\x3014 . ?\x3015) ;; [BEST FIT] LEFT TORTOISE SHELL BRACKET
	 (?\x3015 . ?\x3014) ;; [BEST FIT] RIGHT TORTOISE SHELL BRACKET
	 (?\x3016 . ?\x3017) ;; LEFT WHITE LENTICULAR BRACKET
	 (?\x3017 . ?\x3016) ;; RIGHT WHITE LENTICULAR BRACKET
	 (?\x3018 . ?\x3019) ;; LEFT WHITE TORTOISE SHELL BRACKET
	 (?\x3019 . ?\x3018) ;; RIGHT WHITE TORTOISE SHELL BRACKET
	 (?\x301A . ?\x301B) ;; LEFT WHITE SQUARE BRACKET
	 (?\x301B . ?\x301A) ;; RIGHT WHITE SQUARE BRACKET
	 )))

  ;; Set bidi types for all UCS characters, if they are valid.
  ;; (decode-char 'ucs ?\x33FE) -- valid
  ;; (decode-char 'ucs ?\x3400) -- invalid
  (dolist (pair ucs-bidi-alist)
    (let ((char (decode-char 'ucs (car pair)))
	  (bidi-type (symbol-value (cdr pair))))
      (when char
	(modify-category-entry char bidi-type table))))

  ;; Use the mapping tables by Dave Love to set bidi types for the 8859
  ;; characters.  This works looking up the bidi type we set for the
  ;; corresponding UCS character.
  (dolist (n (list 15 14 9 8 7 5 4 3 2 1))
    (let ((alist (symbol-value (intern (format "ucs-8859-%d-alist" n))))
	  (categories (mapcar 'symbol-value bidi-categories)))
      (dolist (pair alist)
	(let* ((char (car pair))
	       (equiv-ucs-char (decode-char 'ucs (cdr pair)))
	       (category-set (char-category-set equiv-ucs-char)))
	  (dolist (category categories)
	    (when (aref (char-category-set equiv-ucs-char) category)
	      (modify-category-entry char category table)))))))

  ;; Set the mirror characters for the UCS characters, if they are
  ;; valid.
  (setq bidi-mirroring-table nil)
  (dolist (pair ucs-mirror-table)
    (let ((char (decode-char 'ucs (car pair)))
	  (mirror-char (decode-char 'ucs (cdr pair))))
      (when (and char mirror-char)
	(setq bidi-mirroring-table
	      (cons (cons char mirror-char)
		    bidi-mirroring-table)))))

  ;; Use the mapping tables by Dave Love to set bidi mirror characters
  ;; for the 8859 characters.  This works by looking up the bidi type we
  ;; set for the corresponding UCS character.
  (dolist (n (list 15 14 9 8 7 5 4 3 2 1))
    (let ((alist (symbol-value (intern (format "ucs-8859-%d-alist" n)))))
      (dolist (pair alist)
 	(let* ((char (car pair))
 	       (equiv-ucs-char (decode-char 'ucs (cdr pair)))
 	       (mirror-char (cdar (memq equiv-ucs-char ucs-mirror-table))))
 	  (when (and char mirror-char)
 	    (setq bidi-mirroring-table
 		  (cons (cons char mirror-char)
 			bidi-mirroring-table)))))))
  )

(assert (aref (char-category-set ?a) bidi-category-l))
(assert (aref (char-category-set ?,Hz(B) bidi-category-r))
(assert (aref (char-category-set ? ) bidi-category-ws))
(assert (not (assq ?a bidi-mirroring-table)))
(assert (eq ?\) (cdr (assq ?\( bidi-mirroring-table))))
(assert (eq ?\[ (cdr (assq ?\] bidi-mirroring-table))))

;;; bidi-table.el ends here.
