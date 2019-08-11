" Vim filetype plugin file
" Language: KLisp
" Author: Paolo Gavocanov <gavocanov@gmail.com>
" Maintainer: Paolo Gavocanov <gavocanov@gmail.com>

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = 'setlocal iskeyword< define< formatoptions< comments< commentstring< lispwords<'

setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.,:,$

" There will be false positives, but this is better than missing the whole set
" of user-defined def* definitions.
setlocal define=\\v[(/]def(ault)@!\\S*

" Remove 't' from 'formatoptions' to avoid auto-wrapping code.
setlocal formatoptions-=t

" Lisp comments are routinely nested (e.g. ;;; SECTION HEADING)
setlocal comments=n:;
setlocal commentstring=;\ %s

" -*- LISPWORDS -*-
setlocal lispwords=def,define,defn,when,if,unless

" Skip brackets in ignored syntax regions when using the % command
if exists('loaded_matchit')
	let b:match_words = &matchpairs
	let b:match_skip = 's:comment\|string\|regex\|character'
	let b:undo_ftplugin .= ' | unlet! b:match_words b:match_skip'
endif

let &cpo = s:cpo_save
unlet! s:cpo_save s:setting s:dir
"
