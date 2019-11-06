" =============================================================================
" File:          autoload/ctrlp/tabs.vim
" Description:   tabs extension for ctrlp.vim
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['tabs']
"
" Where 'tabs' is the name of the file 'tabs.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',
"         \ ]

" Load guard
if exists('g:loaded_ctrlp_tabs') && g:load_ctrlp_tabs
	finish
endif
let g:loaded_ctrlp_tabs = 1

"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
		\ 'init'     : 'ctrlp#tabs#init()',
		\ 'accept'   : 'ctrlp#tabs#accept',
		\ 'lname'    : 'tabs',
		\ 'sname'    : 'tabs',
		\ 'type'     : 'line',
		\ 'enter'    : 'ctrlp#tabs#enter()',
		\ 'exit'     : 'ctrlp#tabs#exit()',
		\ 'sort'     : 0,
		\ })

" Add this extension's settings to g:tabs_var
"if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
"	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:tabs_var)
"else
"	let g:ctrlp_ext_vars = [s:tabs_var]
"endif


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#tabs#init()
	let input = []
	for i in range(tabpagenr('$'))
		let input = add(input, i + 1 . ": " . TabLabel(i + 1) )
	endfor
	return input
endfunction

function! TabLabel(n)
	let name = ""
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let name = bufname(buflist[winnr - 1]) 
	if len(name) == 0
		let name = "[No Name]"
	endif
	return name
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode    the mode that has been chosen by pressing <c-r> <c-v> <c-t> or  <c-x>
"            the values are 'e', 'v', 't' and 'h', respectively
"  a:str     the selected string
"
function! ctrlp#tabs#accept(mode, str)
	" For this example, just exit ctrlp and run help
	call ctrlp#exit()
	let bufnum = split(a:str, ": ")[0]
	execute "tabn" . bufnum
endfunction


" (optional) Do something before entering ctrlp
function! ctrlp#tabs#enter()
endfunction

" (optional) Do something after exiting ctrlp
function! ctrlp#tabs#exit()
endfunction

" (optional) Set or check for user options specific to this extension
"function! ctrlp#tabs#opts()
"endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#tabs#id()
	return s:id
endfunction

" Create a command to directly call the new search type
"
" Put this in vimrc or plugin/tabs.vim
" command! CtrlpTabs call ctrlp#init(ctrlp#tabs#id())

" vim:nofen:fdl=0:ts=2:sw=2:sts=2

