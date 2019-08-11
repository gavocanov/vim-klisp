" Vim syntax file
" Language: KLisp
" Author: Paolo Gavocanov <gavocanov@gmail.com>
" Maintainer: Paolo Gavocanov <gavocanov@gmail.com>

if exists("b:current_syntax")
	finish
endif

let s:cpo_sav = &cpo
set cpo&vim

if has("folding") && exists("g:klisp_fold") && g:klisp_fold > 0
	setlocal foldmethod=syntax
endif

" -*- KEYWORDS -*-
let s:klisp_syntax_keywords = {
    \   'klispBoolean': ["false","true"]
    \ , 'klispCond': ["case","when","unless"]
    \ , 'klispConstant': ["nil", "unit"]
    \ , 'klispDefine': ["def","define","lambda"]
    \ , 'klispFunc': ["*","+","-","/","^","%","=",">","<",">=","<=","=>","=<","pow","rem","mod","abs","pi","PI","list","set","map","json","lex"]
    \ , 'klispSpecial': ["def","define","lambda","if","quote","when","unless"]
    \ }

function! s:syntax_keyword(dict)
	for key in keys(a:dict)
		execute 'syntax keyword' key join(a:dict[key], ' ')
	endfor
endfunction

call s:syntax_keyword(s:klisp_syntax_keywords)

unlet! s:key
delfunction s:syntax_keyword

" Keywords are symbols:
"   static Pattern symbolPat = Pattern.compile("[:]?([\\D&&[^/]].*/)?([\\D&&[^/]][^/]*)");
" But they:
"   * Must not end in a : or /
"   * Must not have two adjacent colons except at the beginning
"   * Must not contain any reader metacharacters except for ' and #
syntax match klispKeyword "\v<:{1,2}%([^ \n\r\t()\[\]{}";@^`~\\%/]+/)*[^ \n\r\t()\[\]{}";@^`~\\%/]+:@<!>"

syntax match klispStringEscape "\v\\%([\\btnfr"]|u\x{4}|[0-3]\o{2}|\o{1,2})" contained

syntax region klispString matchgroup=klispStringDelimiter start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=klispStringEscape,@Spell

syntax match klispCharacter "\\."
syntax match klispCharacter "\\o\%([0-3]\o\{2\}\|\o\{1,2\}\)"
syntax match klispCharacter "\\u\x\{4\}"
syntax match klispCharacter "\\space"
syntax match klispCharacter "\\tab"
syntax match klispCharacter "\\newline"
syntax match klispCharacter "\\return"
syntax match klispCharacter "\\backspace"
syntax match klispCharacter "\\formfeed"

syntax match klispSymbol "\v%([a-zA-Z!$&*_+=|<.>?-]|[^\x00-\x7F])+%(:?%([a-zA-Z0-9!#$%&*_+=|'<.>/?-]|[^\x00-\x7F]))*[#:]@<!"

let s:radix_chars = "0123456789abcdefghijklmnopqrstuvwxyz"
for s:radix in range(2, 36)
	execute 'syntax match klispNumber "\v\c<[-+]?' . s:radix . 'r[' . strpart(s:radix_chars, 0, s:radix) . ']+>"'
endfor
unlet! s:radix_chars s:radix

syntax match klispNumber "\v<[-+]?%(0\o*|0x\x+|[1-9]\d*)N?>"
syntax match klispNumber "\v<[-+]?%(0|[1-9]\d*|%(0|[1-9]\d*)\.\d*)%(M|[eE][-+]?\d+)?>"
syntax match klispNumber "\v<[-+]?%(0|[1-9]\d*)/%(0|[1-9]\d*)>"

syntax match klispVarArg "&"

syntax match klispQuote "'"
syntax match klispQuote "`"
syntax match klispUnquote "\~"
syntax match klispUnquote "\~@"
syntax match klispMeta "\^"
syntax match klispDeref "@"
syntax match klispDispatch "\v#[\^'=<_]?"

" klisp permits no more than 20 anonymous params.
syntax match klispAnonArg "%\(20\|1\d\|[1-9]\|&\)\?"
syntax keyword klispCommentTodo contained FIXME XXX TODO FIXME: XXX: TODO:
syntax match klispComment ";.*$" contains=klispCommentTodo,@Spell
syntax match klispComment "#!.*$"
" -*- TOP CLUSTER -*-
syntax cluster klispTop contains=@Spell,klispAnonArg,klispBoolean,klispCharacter,klispComment,klispCond,klispConstant,klispDefine,klispDeref,klispDispatch,klispError,klispException,klispFunc,klispKeyword,klispMacro,klispMap,klispMeta,klispNumber,klispQuote,klispRegexp,klispRepeat,klispSexp,klispSpecial,klispString,klispSymbol,klispUnquote,klispVarArg,klispVariable,klispVector

syntax region klispSexp   matchgroup=klispParen start="("  end=")" contains=@klispTop fold
syntax region klispVector matchgroup=klispParen start="\[" end="]" contains=@klispTop fold
syntax region klispMap    matchgroup=klispParen start="{"  end="}" contains=@klispTop fold

" Highlight superfluous closing parens, brackets and braces.
syntax match klispError "]\|}\|)"

syntax sync fromstart

highlight default link klispConstant                  Constant
highlight default link klispBoolean                   Boolean
highlight default link klispCharacter                 Character
highlight default link klispKeyword                   Keyword
highlight default link klispNumber                    Number
highlight default link klispString                    String
highlight default link klispStringDelimiter           String
highlight default link klispStringEscape              Character

highlight default link klispVariable                  Identifier
highlight default link klispCond                      Conditional
highlight default link klispDefine                    Define
highlight default link klispException                 Exception
highlight default link klispFunc                      Function
highlight default link klispMacro                     Macro
highlight default link klispRepeat                    Repeat

highlight default link klispSpecial                   Special
highlight default link klispVarArg                    Special
highlight default link klispQuote                     SpecialChar
highlight default link klispUnquote                   SpecialChar
highlight default link klispMeta                      SpecialChar
highlight default link klispDeref                     SpecialChar
highlight default link klispAnonArg                   SpecialChar
highlight default link klispDispatch                  SpecialChar

highlight default link klispComment                   Comment
highlight default link klispCommentTodo               Todo

highlight default link klispError                     Error

highlight default link klispParen                     Delimiter

let b:current_syntax = "klisp"
let &cpo = s:cpo_sav
unlet! s:cpo_sav
" vim:sts=4:sw=4:ts=4:noet
