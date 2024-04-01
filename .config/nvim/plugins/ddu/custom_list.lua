vim.fn.openCustomList = function (selects, sf)
  sf = sf and false or sf
  selects = table.map(selects, function (v, k)
    local num = string.format("%03d", k)
    return {num..' '..v[1], v[2]}
  end)
  local selectName = table.map(selects, function(v) return v[1] end)
  local id = vim.fn['denops#callback#register'](function (text)
    local target = table.filter(function (v)
      return v[1] == text
    end, selects)
    target[1][2]()
  end)
  vim.fn['ddu#start']({
    ui = 'ff'
    , sources = {{
      name = 'custom-list'
      , params = {
        texts = selectName
        , callbackId = id
      }
    }}
    , kindOptions = {
      ['custom-list'] = {
        defaultAction = 'callback'
      }
    }
    , uiParams = { ff = { startFilter = sf } }
  })
end
vim.fn.customFileCreate = function (header, filePath)
  if string.isEmpty(header) then
    return
  end
  if string.isEmpty(filePath) then
    return
  end
  local file = io.open(filePath, "w")
  if file then
    file:write(header)
    file:close()
  end
  vim.fn.openFileInTab(filePath)
end
vim.fn.openCustomDirectory = function (directoryPath, isFilter)
  if string.isEmpty(directoryPath) then
    return
  end
  local selects = {}
  local files = table.commandResultAsTable('ls -t '..directoryPath)
  table.myForeach(function (file)
    local filePath = directoryPath..'/'..file
    local fileHandle, err = io.open(filePath, 'r')
    if fileHandle then
      local firstLine = fileHandle:read()
      fileHandle:close()
      table.insert(selects, {
        firstLine
        , function () vim.fn.openFileInTab(filePath) end
      })
    else
      os.dump('openCustomDirectory not file open. error code: '..err)
    end
  end, files)
  vim.fn.openCustomList(selects, isFilter)
end

vim.keymap.set('n', '<Space>c', function ()
  vim.fn.openCustomList({
    {
      'File : ~/.config/nvim/lua/local.lua'
      , function () vim.fn.openFileInTab('~/.config/nvim/lua/local.lua') end
    }
    , {
      'File : ~/.zshrc'
      , function () vim.fn.openFileInTab('~/.zshrc') end
    }
    , {
      'File : ~/.bashrc'
      , function () vim.fn.openFileInTab('~/.bashrc') end
    }
    , {
      'File : ~/.gitconfig.local'
      , function () vim.fn.openFileInTab('~/.gitconfig.local') end
    }
    , {
      'File : ~/.ssh/config'
      , function () vim.fn.openFileInTab('~/.ssh/config') end
    }
    , {
      'File : /etc/profile (read only)'
      , function ()
        local path = '/etc/profile'
        vim.fn.storeYank('sudo nvim '..path)
        vim.fn.openFileInTab(path)
      end
    }
    , {
      'File : /etc/hosts (read only)'
      , function ()
        local path = '/etc/hosts'
        vim.fn.storeYank('sudo nvim '..path)
        vim.fn.openFileInTab(path)
      end
    }
    , {
      'Dein : Dein Plugin Update'
      , function () vim.cmd('call dein#update()') end
    }
    , {
      'ExCmd : Toggle number setting :ToggleNumber'
      , function () vim.cmd('ToggleNumber') end
    }
    , {
      'Command : Find port prosess [lsof -i :<PORT>] (open bottom terminal)'
      , function () vim.fn.myTerminal('myCommand', 1, 'lsof -i :', nil) end
    }
    , {
      'Command : Docker prune [docker system prune] (yank)'
      , function () vim.fn.storeYank('docker system prune') end
    }
    , {
      'Command : Docker prune [docker-compose build --no-cache] (yank)'
      , function () vim.fn.storeYank('docker-compose build --no-cache') end
    }
    , {
      'Command : File permission chmod [chmod u+x <FILE>] (open bottom terminal)'
      , function () vim.fn.myTerminal('myCommand', 1, 'chmod u+x ', nil) end
    }
    -- TODO create sort and diff function
    , {
      'Command : Sort File [LANG=C sort <Raw File> > <Sort File>] (yank)'
      , function () vim.fn.storeYank('LANG=C sort ') end
    }
    , {
      'Command : Outputs the difference in both file [comm -3 <A File> <B File>] (yank)'
      , function () vim.fn.storeYank('comm -3 ') end
    }
    , {
      'Command : Big file split [split -l 10000 <File>] (yank)'
      , function () vim.fn.storeYank('split -l 10000 ') end
    }
    , {
      [[Command : jq command [jq '.[]' *.json > filename.json] (yank)]]
      , function () vim.fn.storeYank([[jq '.[]' *.json > filename.json]]) end
    }
  })
end)
