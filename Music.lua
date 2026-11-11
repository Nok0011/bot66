--[[
╔══════════════════════════════════════════════╗
║           Music.lua — نظام الموسيقى          ║
║  yt-dlp + TDLib + Redis + Lua                ║
╚══════════════════════════════════════════════╝

الأوامر المتاحة:
  تحميل [اسم أو رابط]   ← تحميل صوت mp3
  فيديو [اسم أو رابط]   ← تحميل فيديو mp4
  بحث [كلمة]            ← بحث يوتيوب 5 نتائج بأزرار
  تعطيل الموسيقى        ← تعطيل للمجموعة (مشرف+)
  تفعيل الموسيقى        ← تفعيل للمجموعة (مشرف+)
  الموسيقى للمميزين     ← تقييد للمميزين+ (مالك)
  الموسيقى للاعضاء      ← السماح للجميع (مالك)
  حالة الموسيقى         ← عرض الحالة الحالية
]]--

local MUSIC_COOLDOWN = 15  -- ثانية بين كل طلب للمستخدم
local MAX_AUDIO_MB   = 50  -- حجم أقصى للصوت ميغابايت
local MAX_VIDEO_MB   = 80  -- حجم أقصى للفيديو ميغابايت
local SEARCH_TIMEOUT = 30  -- timeout للبحث ثانية
local DL_TIMEOUT     = 150 -- timeout للتحميل ثانية

-- ─── مساعدات داخلية ───────────────────────────────────────────
local function music_disabled(chat_id)
  return Redis:get(TheMero.."music:off:"..chat_id)
end

local function music_vip_only(chat_id)
  return Redis:get(TheMero.."music:vip:"..chat_id)
end

local function on_cooldown(user_id, chat_id)
  return Redis:get(TheMero.."music:cd:"..user_id..":"..chat_id)
end

local function set_cooldown(user_id, chat_id)
  Redis:setex(TheMero.."music:cd:"..user_id..":"..chat_id, MUSIC_COOLDOWN, "1")
end

local function safe(s)
  return (s or ""):gsub("'",""):gsub('"',""):gsub("\\","")
end

local function safe_fname(s)
  return (s or ""):gsub("[^%w%s%-]",""):gsub("%s+","_"):sub(1,60)
end

local function is_url(s)
  return s:match("^https?://") ~= nil
end

local function ytarg(query)
  if is_url(query) then
    return "'"..safe(query).."'"
  else
    return "'ytsearch1:"..safe(query).."'"
  end
end

-- إذا كانت الرسالة من قناة دون مستخدم محدد، نتخطى الكول داون
local _music_uid = (msg.sender_id and msg.sender_id.user_id) or 0

-- ─── تحميل صوت ────────────────────────────────────────────────
if text and text:match("^تحميل (.+)$") then
  local query = text:match("^تحميل (.+)$")
  if music_disabled(msg_chat_id) then return false end
  if not msg.Distinguished and music_vip_only(msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ عذراً التحميل للمميزين ومافوق فقط", "md", true)
  end
  if on_cooldown(((msg.sender_id and msg.sender_id.user_id) or 0), msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ انتظر "..MUSIC_COOLDOWN.." ثانية بين كل طلب", "md", true)
  end
  set_cooldown(((msg.sender_id and msg.sender_id.user_id) or 0), msg_chat_id)
  send(msg_chat_id, msg_id, "⇜ جاري التحميل... 🎵", "md", true)
  local fname = safe_fname(query)
  if fname == "" then fname = "audio_"..math.random(10000,99999) end
  local out = "./"..fname..".mp3"
  os.execute("timeout "..DL_TIMEOUT.." "..YTDLP_BIN.." "..YTDLP_COOKIES.." "
    ..ytarg(query).." -f bestaudio --extract-audio --audio-format mp3"
    .." -o '"..fname..".mp3' --no-playlist --max-filesize "..MAX_AUDIO_MB.."M 2>/dev/null")
  local f = io.open(out, "r")
  if f then
    f:close()
    bot.sendAudio(msg_chat_id, msg_id, out, "🎵 "..query, "md", nil, query)
    sleep(2)
    os.remove(out)
  else
    send(msg_chat_id, msg_id, GetByName(msg).."⇜ لم أستطع تحميل هذا المقطع 😕", "md", true)
  end
  return
end

-- ─── تحميل فيديو ──────────────────────────────────────────────
if text and text:match("^فيديو (.+)$") then
  local query = text:match("^فيديو (.+)$")
  if music_disabled(msg_chat_id) then return false end
  if not msg.Distinguished and music_vip_only(msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ عذراً التحميل للمميزين ومافوق فقط", "md", true)
  end
  if on_cooldown(((msg.sender_id and msg.sender_id.user_id) or 0), msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ انتظر "..MUSIC_COOLDOWN.." ثانية بين كل طلب", "md", true)
  end
  set_cooldown(((msg.sender_id and msg.sender_id.user_id) or 0), msg_chat_id)
  send(msg_chat_id, msg_id, "⇜ جاري التحميل... 🎬", "md", true)
  local fname = safe_fname(query)
  if fname == "" then fname = "video_"..math.random(10000,99999) end
  local out = "./"..fname..".mp4"
  os.execute("timeout "..DL_TIMEOUT.." "..YTDLP_BIN.." "..YTDLP_COOKIES.." "
    ..ytarg(query).." -f 'bestvideo[ext=mp4]+bestaudio/best[ext=mp4]/best'"
    .." --merge-output-format mp4 -o '"..fname..".mp4' --no-playlist"
    .." --max-filesize "..MAX_VIDEO_MB.."M 2>/dev/null")
  local f = io.open(out, "r")
  if f then
    f:close()
    bot.sendVideo(msg_chat_id, msg_id, out, "🎬 "..query, "md")
    sleep(2)
    os.remove(out)
  else
    send(msg_chat_id, msg_id, GetByName(msg).."⇜ لم أستطع تحميل هذا الفيديو 😕", "md", true)
  end
  return
end

-- ─── بحث يوتيوب ───────────────────────────────────────────────
if text and text:match("^بحث (.+)$") then
  local query = text:match("^بحث (.+)$")
  if music_disabled(msg_chat_id) then return false end
  if not msg.Distinguished and music_vip_only(msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ عذراً التحميل للمميزين ومافوق فقط", "md", true)
  end
  if on_cooldown(((msg.sender_id and msg.sender_id.user_id) or 0), msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ انتظر "..MUSIC_COOLDOWN.." ثانية بين كل طلب", "md", true)
  end
  send(msg_chat_id, msg_id, "⇜ جاري البحث... 🔍", "md", true)
  local sq = safe(query)
  local handle = io.popen("timeout "..SEARCH_TIMEOUT.." "..YTDLP_BIN
    .." 'ytsearch8:"..sq.."' --flat-playlist --print '%(title)s|||%(id)s|||%(duration_string)s'"
    .." --no-playlist 2>/dev/null")
  local raw = handle:read("*all")
  handle:close()
  local results = {}
  for line in raw:gmatch("[^\n]+") do
    local title, vid_id, dur = line:match("^(.+)|||([%w%-_]+)|||(.*)$")
    if title and vid_id and #results < 5 then
      results[#results+1] = {title=title, id=vid_id, dur=dur or ""}
    end
  end
  if #results == 0 then
    return send(msg_chat_id, msg_id, "⇜ لا توجد نتائج لـ : *"..query.."*", "md", true)
  end
  -- حفظ نتائج البحث في Redis لكل مستخدم
  for i, r in ipairs(results) do
    Redis:setex(TheMero.."music:res:"..((msg.sender_id and msg.sender_id.user_id) or 0)..":"..msg_chat_id..":"..i, 300, r.id.."|"..r.title)
  end
  Redis:setex(TheMero.."music:q:"..((msg.sender_id and msg.sender_id.user_id) or 0)..":"..msg_chat_id, 300, query)
  local datar = {}
  for i, r in ipairs(results) do
    local display = r.title:sub(1,45)..(#r.title>45 and "…" or "")..(r.dur~="" and " ("..r.dur..")" or "")
    datar[i] = {{text = display, data = ((msg.sender_id and msg.sender_id.user_id) or 0)..":msr:"..i..":"..msg_chat_id}}
  end
  local reply_markup = bot.replyMarkup{type='inline', data=datar}
  return bot.sendText(msg_chat_id, msg_id,
    "🔍 *نتائج البحث عن :* _"..query.."_\n_اختر ما تريد تحميله ↓_",
    "md", false, false, false, false, reply_markup)
end

-- ─── تعطيل / تفعيل الموسيقى ──────────────────────────────────
if text == "تعطيل الموسيقى" or text == "تعطيل موسيقى" then
  if not msg.Addictive then
    return send(msg_chat_id, msg_id, "⇜ هذا الأمر للمشرفين فأعلى فقط", "md", true)
  end
  if music_disabled(msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ الموسيقى معطّلة مسبقاً", "md", true)
  end
  Redis:set(TheMero.."music:off:"..msg_chat_id, "1")
  return send(msg_chat_id, msg_id, GetByName(msg).."⇜ تم تعطيل الموسيقى 🔕", "md", true)
end

if text == "تفعيل الموسيقى" or text == "تفعيل موسيقى" then
  if not msg.Addictive then
    return send(msg_chat_id, msg_id, "⇜ هذا الأمر للمشرفين فأعلى فقط", "md", true)
  end
  if not music_disabled(msg_chat_id) then
    return send(msg_chat_id, msg_id, GetByName(msg).."⇜ الموسيقى مفعّلة مسبقاً", "md", true)
  end
  Redis:del(TheMero.."music:off:"..msg_chat_id)
  return send(msg_chat_id, msg_id, GetByName(msg).."⇜ تم تفعيل الموسيقى 🎶", "md", true)
end

-- ─── تقييد الصلاحيات ──────────────────────────────────────────
if text == "الموسيقى للمميزين" or text == "موسيقى للمميزين" then
  if not msg.TheBasicsQ then
    return send(msg_chat_id, msg_id, "⇜ هذا الأمر للمالك فأعلى فقط", "md", true)
  end
  Redis:set(TheMero.."music:vip:"..msg_chat_id, "1")
  return send(msg_chat_id, msg_id, GetByName(msg).."⇜ الموسيقى أصبحت للمميزين فأعلى فقط 🌟", "md", true)
end

if text == "الموسيقى للاعضاء" or text == "موسيقى للاعضاء" then
  if not msg.TheBasicsQ then
    return send(msg_chat_id, msg_id, "⇜ هذا الأمر للمالك فأعلى فقط", "md", true)
  end
  Redis:del(TheMero.."music:vip:"..msg_chat_id)
  return send(msg_chat_id, msg_id, GetByName(msg).."⇜ الموسيقى أصبحت متاحة لجميع الأعضاء 🎵", "md", true)
end

-- ─── حالة الموسيقى ────────────────────────────────────────────
if text == "حالة الموسيقى" or text == "حاله الموسيقى" then
  local status  = music_disabled(msg_chat_id) and "🔕 معطّلة" or "🎶 مفعّلة"
  local perm    = music_vip_only(msg_chat_id) and "🌟 للمميزين فأعلى" or "👥 لجميع الأعضاء"
  local msg_out = string.format(
    "*╔═ حالة الموسيقى ═╗*\n• الحالة : %s\n• الصلاحية : %s\n• الحجم الأقصى صوت : %dMB\n• الحجم الأقصى فيديو : %dMB\n*╚════════════════╝*",
    status, perm, MAX_AUDIO_MB, MAX_VIDEO_MB)
  return send(msg_chat_id, msg_id, msg_out, "md", true)
end

-- ─── قسم المبرمج ──────────────────────────────────────────────
if text == "المبرمج" then
  local infoc = "⌁︙اسم المبرمج : اެݪأصِــل ألأبَـهـࢪ | aBhar\n"
    .. "⌁︙يوزر المبرمج : @ziizr\n"
    .. "⌁︙ايدي المبرمج : 310516223"
  local reply_markup = bot.replyMarkup{type='inline', data={
    {{text = 'المبرمج', url = 'https://t.me/ziizr', style = 'success'}},
    {{text = 'المبرمج', url = 'https://t.me/ziizr', style = 'primary'}},
  }}
  return bot.sendVideo(msg_chat_id, msg_id, "./programmer.mp4", infoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
end

-- ─── قسم المطور ───────────────────────────────────────────────
if text == "المطور" then
  local infoc = "⌁︙اسم المبرمج : اެݪأصِــل ألأبَـهـࢪ | aBhar\n"
    .. "⌁︙يوزر المبرمج : @ziizr\n"
    .. "⌁︙ايدي المبرمج : 310516223"
  local reply_markup = bot.replyMarkup{type='inline', data={
    {{text = 'المبرمج', url = 'https://t.me/FvvZv', style = 'primary'}},
  }}
  return bot.sendVideo(msg_chat_id, msg_id, "./programmer.mp4", infoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
end