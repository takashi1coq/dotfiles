
return {
  yyyy = function () return os.date('%Y') end
  , mm = function () return os.date('%m') end
  , dd = function () return os.date('%d') end
  , yyyymmdd = function () return os.date('%Y%m%d') end
  , hhmmss = function () return os.date('H%M%S') end
  , yyyymmddhhmmss = function () return os.date('%Y%m%d%H%M%S') end
  , locale_date = function () return os.date('%Y/%m/%d') end
  , day_of_week = function ()
    local weekdays = {'日', '月', '火', '水', '木', '金', '土'}
    local w = os.date('*t').wday
    return weekdays[w]
  end
  , locale_time = function () return os.date('%X') end
  , locale_datetime = function ()
    return string.format(
      [[%s (%s) %s]]
      , _G.TKC.utils.datetime.locale_date()
      , _G.TKC.utils.datetime.day_of_week()
      , _G.TKC.utils.datetime.locale_time()
    )
  end
}
