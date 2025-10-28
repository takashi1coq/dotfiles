
return {
  open_custom_list = function (selects, sf)
    sf = sf and false or sf
    selects = _G.TKC.utils.table.transform(function (key, value)
      local num = string.format("%03d", key)
      return {
        num..' '..value[1]
        , value[2]
      }
    end, selects)
    local selectName = _G.TKC.utils.table.transform(
      function (_, value) return value[1] end
      , selects
    )
    local denopsCallbackId = vim.fn['denops#callback#register'](function (text)
      for _, value in ipairs(selects) do
        if value[1] == text then
          value[2]()
          break
        end
      end
    end)
    vim.fn['ddu#start']({
      ui = 'ff'
      , sources = {{
        name = 'custom-list'
        , params = {
          texts = selectName
          , callbackId = denopsCallbackId
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
  , custom_file_create = function (header, filePath)
    if _G.TKC.utils.string.is_empty(header) then
      return
    end
    if _G.TKC.utils.string.is_empty(filePath) then
      return
    end
    local file = io.open(filePath, "w")
    if file then
      file:write(header)
      file:close()
    end
    _G.TKC.utils.nvim.open_tab(filePath)
  end
  , open_custom_directory = function (directoryPath, isFilter)
    local selects = {}
    local fileInfo = _G.TKC.utils.file.get_file_info_in_path(directoryPath)
    table.sort(fileInfo, function (a, b) return a.mtime > b.mtime end)
    local filePaths = _G.TKC.utils.table.transform(function(_, value)
      return value.path
    end, fileInfo)
    for _, fullPath in ipairs(filePaths) do
      local fileHandle, err = io.open(fullPath, 'r')
      if fileHandle then
        local firstLine = fileHandle:read()
        fileHandle:close()
        table.insert(selects, {
          firstLine
          , function () _G.TKC.utils.nvim.open_tab(fullPath) end
        })
      else
        _G.TKC.utils.message.error('plugins.ddu.open_custom_directory not file open. : '..err)
      end
    end
    _G.TKC.plugins.ddu.open_custom_list(selects, isFilter)
  end
  , open_ddu_filer = function (path)
    vim.fn['ddu#start']({
      ui = 'filer'
      , sources = {{ name = 'file', params = {} }}
      , sourceOptions = {
        file = {
          path = path
        }
      }
    })
  end
  , open_current_ddu_filer = function ()
    local filename = _G.TKC.utils.file.current_file_name()
    vim.fn.matchadd('MyDduHighlight', filename)
    _G.TKC.plugins.ddu.open_ddu_filer(vim.fn.expand('%:p:h'))
  end
  , ddu_grep = function (inputTitle, path)
    local word = _G.TKC.utils.nvim.get_visual()
    if _G.TKC.utils.string.is_empty(word) then
      word = vim.fn.input(inputTitle)
      if _G.TKC.utils.string.is_empty(word) then
        return
      end
    end
    local grepWord = _G.TKC.plugins.ddu.create_permutation_grep_word(
      _G.TKC.utils.table.string_to_table(word, ' ')
    )
    vim.fn['ddu#start']({
      ui = 'ff'
      , uiParams = {
        ff = {
          autoAction = {
            name = 'preview'
          }
          , startAutoAction = true
          , previewSplit = 'vertical'
        }
      }
      , sources = {{ name = 'rg', params = { input = grepWord } }}
      , sourceOptions = {
        rg = {
          path = path
        }
      }
    })
  end
  , create_permutation_grep_word = function (t)
    local b = {}
    for p in _G.TKC.plugins.ddu.permutation(t) do
      local str = _G.TKC.utils.table.table_to_string(p, '.*')
      table.insert(b, str)
    end
    return '('.._G.TKC.utils.table.table_to_string(b, ')|(')..')'
  end
  , permutation = function (t)
    local function permgen (a, n)
      if n == 0 then
        coroutine.yield(a)
      else
        for i=1,n do
          -- put i-th element as the last one
          a[n], a[i] = a[i], a[n]
          -- generate all permutations of the other elements
          permgen(a, n - 1)
          -- restore i-th element
          a[n], a[i] = a[i], a[n]
        end
      end
    end
    local n = #t
    local co = coroutine.create(function () permgen(t, n) end)
    return function ()   -- iterator
      local _, res = coroutine.resume(co)
      return res
    end
  end
  , open_filter_window_autocmd_id = nil
  , enable_open_filter_window = function ()
    if _G.TKC.plugins.ddu.open_filter_window_autocmd_id then
      return
    end
    _G.TKC.plugins.ddu.open_filter_window_autocmd_id = vim.api.nvim_create_autocmd("User", {
      pattern = "Ddu:uiDone",
      nested = true,
      callback = function()
        vim.fn['ddu#ui#async_action']('openFilterWindow')
      end,
    })
  end
  , disable_open_filter_window = function ()
    if _G.TKC.plugins.ddu.open_filter_window_autocmd_id then
      vim.api.nvim_del_autocmd(_G.TKC.plugins.ddu.open_filter_window_autocmd_id)
      _G.TKC.plugins.ddu.open_filter_window_autocmd_id = nil
    end
  end
  , diff_left_path = nil
}


