vim.cmd([[
  " 行番号
  set number relativenumber

  " スワップファイルを作成しない
  set noswapfile

  " undoFileを/tmpに作成
  set undofile
  set undodir=/tmp

  " 大文字小文字を区別しない
  set ignorecase

  " jsonのダブルコーテーション表示用 非表示設定をすべてOFF
  set conceallevel=0

  " 一番下までいったら上に戻る(検索)
  set wrapscan

  " エンコード
  set fileencodings=utf-8,euc-jp,ucs-bom,iso-2022-jp,sjis,cp932,latin1

  " タブラインを常に表示
  set showtabline=2

  " クリップボード共有
  set clipboard+=unnamedplus

  " <Tab> <Space> 等可視化
  set list
  set listchars=tab:>-,trail:_,extends:>,precedes:<

  " <Tab>を<Space>2
  set expandtab
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2

  " カーソル行をハイライト
  set cursorline

  " 右にスプリット
  set splitright

  " コメントアウト改行時にコメントアウトしないようにする
  set formatoptions-=ro

  " ヘルプをタブで開くようにする
  cabbrev help tab help
  cabbrev h tab h

  " マウス操作ON
  set mouse=n
]])
