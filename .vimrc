" dein.vimの設定(http://qiita.com/delphinus/items/00ff2c0ba972c6e41542)

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  " let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  " call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" デフォルトプラグインを読み込まない
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

" setting
set nobackup   " バックアップファイルを作らない
set noswapfile " スワップファイルを作らない
set autoread   " 編集中のファイルが変更されたら自動で読み直す
set hidden     " バッファが編集中でもその他のファイルを開けるように
set showcmd    " 入力中のコマンドをステータスに表示する

" Charset, Line ending -----------------
set encoding=utf-8
scriptencoding utf-8


" 見た目系
filetype plugin indent on
set autoindent            " 自動インデントを有効に
set ambiwidth=double      " 全角記号の表示幅を修正
set number                " 行番号を表示
set cursorline            " 現在の行を強調表示
set scrolloff=8           " 上下8行の視界を確保
set ttyfast               " カーソル移動高速化
set autoread              " 外部でファイルに変更がされた場合は読みなおす
"INSERTモードのときだけ横線解除
augroup set_cursorline
  autocmd!
  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
augroup END
set virtualedit=onemore   " 行末の1文字先までカーソルを移動できるように
set smartindent           " インデントはスマートインデント
set visualbell            " ビープ音を可視化
set showmatch             " 括弧入力時の対応する括弧を表示
set laststatus=2        " ステータスラインを常に表示
set wildmode=list:longest " コマンドラインの補完
" nnoremap j gj             " 折り返し時に表示行単位での移動できるようにする
" nnoremap k gk
" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる(インクリメンタルサーチ)
set incsearch
" 検索時に最後まで行ったら最初に戻る set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Syntax highlight ---------------
syntax enable                    "シンタクスハイライトを有効化

" colorscheme
colorscheme badwolf

augroup add_syntax_hilight
  autocmd!
  "シンタックスハイライトの追加
  autocmd BufNewFile,BufRead *.json.jbuilder            set ft=ruby
  autocmd BufNewFile,BufRead *.erb                      set ft=eruby
  autocmd BufNewFile,BufRead *.scss                     set ft=scss.css
  autocmd BufNewFile,BufRead *.coffee                   set ft=coffee
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set ft=markdown
augroup END

" othree/html5.vimの設定を追加(.html.erbに対応)
" let g:html5_event_handler_attributes_complete = 1
" let g:html5_rdfa_attributes_complete = 1
" let g:html5_microdata_attributes_complete = 1
" let g:html5_aria_attributes_complete = 1

"=======================コピー&ペースト系=================
" クリップボード
set clipboard=unnamed,autoselect



"----------コピーした際に自動インデントでズレない設定----
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"--------------------------------------------------------

"==========================================================

"---------------NERDTreeの設定---------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
let g:nerdtree_tabs_open_on_console_startup=1

"<C-n>でNERDTreeTabsToggleを呼び出す設定
map <C-n> <plug>NERDTreeTabsToggle<CR>
"-------------------------------------------------

"==========================================================

"---------------syntasticの設定---------------------
" rubyファイルを開いたときのみ、保存時にrubocopを走らせる
let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
"-------------------------------------------------

"---------------tabの設定---------------------
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')
