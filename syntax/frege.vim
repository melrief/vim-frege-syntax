" Copyright (c) 2014 Mario Pastorelli
"
" See the file LICENSE for copying permission.
"
" Vim syntax file
" Language:		Frege
" Maintainer:		Mario Pastorelli <pastorelli.mario@gmail.com>
"
" Missing keywords: pure and mutable

if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

" (Qualified) identifiers (no default highlighting)
syn match ConId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[A-Z][a-zA-Z0-9_']*\>"
syn match VarId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[a-z][a-zA-Z0-9_']*\>"

" Infix operators--most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match frVarSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match frConSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match frVarSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match frConSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"

" Reserved symbols--cannot be overloaded.
syn match frDelimiter  "(\|)\|\[\|\]\|,\|;\|_\|{\|}"

" Strings and constants
syn match   frSpecialChar	contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match   frSpecialChar	contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match   frSpecialCharError	contained "\\&\|'''\+"
syn region  frString		start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=frSpecialChar
syn match   frCharacter		"[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=frSpecialChar,frSpecialCharError
syn match   frCharacter		"^'\([^\\]\|\\[^']\+\|\\'\)'" contains=frSpecialChar,frSpecialCharError
syn match   frNumber		"\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>"
syn match   frFloat		"\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"

" Keyword definitions. These must be patters instead of keywords
" because otherwise they would match as keywords at the start of a
" "literate" comment (see lhs.vim).
syn match frModule		"\<module\>"
syn match frImport		"\<import\>.*"he=s+6 contains=frImportMod,frLineComment,frBlockComment
syn match frImportMod		contained "\<\(as\|qualified\|hiding\)\>"
syn match frInfix		"\<\(infix\|infixl\|infixr\)\>"
syn match frStructure		"\<\(abstract\|derive\|native\|package\|private\|protected\|public\|class\|data\|instance\|where\)\>"
syn match frTypedef		"\<\(type\)\>"
syn match frStatement		"\<\(do\|case\|of\|let\|in\)\>"
syn match frConditional		"\<\(if\|then\|else\)\>"
syn match frBoolean		"\<\(true\|false\)\>"
syn match frType		"\<\(Int\|Integer\|Char\|Bool\|Float\|Double\|IO\|Void\|Addr\|Array\|String\)\>"

" Comments
syn match   frLineComment      "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region  frBlockComment     start="{-"  end="-}" contains=frBlockComment
syn region  frPragma	       start="{-#" end="#-}"

" C Preprocessor directives. Shamelessly ripped from c.vim and trimmed
" First, see whether to flag directive-like lines or not
if (!exists("fr_allow_hash_operator"))
    syn match	cError		display "^\s*\(%:\|#\).*$"
endif
" Accept %: for # (C99)
syn region	cPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCommentError
syn match	cPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
syn region	cCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
syn region	cCppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cCppSkip
syn region	cCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cCppSkip
syn region	cIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
syn cluster	cPreProcGroup	contains=cPreCondit,cIncluded,cInclude,cDefine,cCppOut,cCppOut2,cCppSkip,cCommentStartError
syn region	cDefine		matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$"
syn region	cPreProc	matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend

syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=cCommentStartError,cSpaceError contained
syntax match	cCommentError	display "\*/" contained
syntax match	cCommentStartError display "/\*"me=e-1 contained
syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_fr_syntax_inits")
  if version < 508
    let did_fr_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink frModule			  frStructure
  HiLink frImport			  Include
  HiLink frImportMod			  frImport
  HiLink frInfix			  PreProc
  HiLink frStructure			  Structure
  HiLink frStatement			  Statement
  HiLink frConditional			  Conditional
  HiLink frSpecialChar			  SpecialChar
  HiLink frTypedef			  Typedef
  HiLink frVarSym			  frOperator
  HiLink frConSym			  frOperator
  HiLink frOperator			  Operator
  if exists("fr_highlight_delimiters")
    " Some people find this highlighting distracting.
    HiLink frDelimiter			  Delimiter
  endif
  HiLink frSpecialCharError		  Error
  HiLink frString			  String
  HiLink frCharacter			  Character
  HiLink frNumber			  Number
  HiLink frFloat			  Float
  HiLink frConditional			  Conditional
  HiLink frLiterateComment		  frComment
  HiLink frBlockComment		  frComment
  HiLink frLineComment			  frComment
  HiLink frComment			  Comment
  HiLink frPragma			  SpecialComment
  HiLink frBoolean			  Boolean
  HiLink frType			  Type
  HiLink frMaybe			  frEnumConst
  HiLink frOrdering			  frEnumConst
  HiLink frEnumConst			  Constant
  HiLink frDebug			  Debug

  HiLink cCppString		frString
  HiLink cCommentStart		frComment
  HiLink cCommentError		frError
  HiLink cCommentStartError	frError
  HiLink cInclude		Include
  HiLink cPreProc		PreProc
  HiLink cDefine		Macro
  HiLink cIncluded		frString
  HiLink cError			Error
  HiLink cPreCondit		PreCondit
  HiLink cComment		Comment
  HiLink cCppSkip		cCppOut
  HiLink cCppOut2		cCppOut
  HiLink cCppOut		Comment

  delcommand HiLink
endif

let b:current_syntax = "frege"

" Options for vi: ts=8 sw=2 sts=2 nowrap noexpandtab ft=vim
