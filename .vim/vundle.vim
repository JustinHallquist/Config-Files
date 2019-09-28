" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)!
Plugin 'gmarik/Vundle.vim'

"""" Ruby/Rails plugins
" Adds Rails navigation, generator, and other commands.
Plugin 'tpope/vim-rails'

" Adds Ruby navigation and syntax highlighting.
Plugin 'vim-ruby/vim-ruby'

" Adds Bundle support.
" Plugin 'tpope/vim-bundler'

" Add CoffeeScript support
Plugin 'kchmck/vim-coffee-script'

" Runs Rubocop in Vim
Plugin 'ngmy/vim-rubocop'

" Run rspec from vim
Plugin 'thoughtbot/vim-rspec'

"""" End Ruby plugins

" Autocompletes endings for control structures in Ruby, C, and other languages.
Plugin 'tpope/vim-endwise'

" Code Completion engine for many languages
Plugin 'Shougo/neocomplete'

" :Nyancat for an awesome surprise!
Plugin 'koron/nyancat-vim'

" Git wrapper for Vim.
" Plugin 'tpope/vim-fugitive'

" Toggle commenting, currently aliased to <leader>gc
Plugin 'tomtom/tcomment_vim'

" Extend the dot macro by letting plugins use it
Plugin 'tpope/vim-repeat'

" Easily add surroundings in normal mode
Plugin 'tpope/vim-surround'

" Extra keymappings using brackets
Plugin 'tpope/vim-unimpaired'

" Databases in Vim
Plugin 'vim-scripts/dbext.vim'

" Dragula theme
Plugin 'dracula/vim'

"""" Start PHP Plugins

" PHP / Yii
Plugin 'mikehaertl/pdv-standalone'
Plugin 'StanAngeloff/php.vim'
Plugin '2072/PHP-Indenting-for-VIm'

" Help
Plugin 'powerman/vim-plugin-viewdoc'
" To activate add project specific .vimrc with
" set runtimepath+=/etc/vim/bundle/yii2-apidoc-vim
Plugin 'mikehaertl/yii-api-vim', {'rtp': 'none'}
Plugin 'mikehaertl/yii2-apidoc-vim', {'rtp': 'none'}

Plugin 'neomake/neomake'
"""" End PHP Plugins

Plugin 'chr4/nginx.vim'

" Node
Plugin 'moll/vim-node'

" CTags
Plugin 'ludovicchabant/vim-gutentags'

" fzf
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Prettier
Plugin 'prettier/vim-prettier'

call vundle#end()
