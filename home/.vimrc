set tabstop=2
set shiftwidth=2
set expandtab
set number

imap jk <Esc>
imap kj <Esc>

syntax on
colorscheme habamax
highlight MatchParen ctermfg=250 ctermbg=66

let &t_SI = "\e[6 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[2 q"
