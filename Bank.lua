function Runbank(msg)
-- يستخدم chat_id كمعرف للجلسة عندما يكون المرسل قناة
local _bank_uid = (msg.sender_id and msg.sender_id.user_id) or msg.chat_id or 0

text = nil
if msg and msg.content and msg.content.text then
text = msg.content.text.text
end
msg_chat_id = msg.chat_id
msg_id = msg.id
msg_reply_id = msg.reply_to_message_id
msg_user_send_id = (_bank_uid)
Bot_Name = (Redis:get(TheMero.."Mero:Name:Bot") or "روبي")
if text and text:match('^'..Bot_Name..' ') then
text = text:gsub('^'..Bot_Name..' ','')
end
if text then
local NewCmmd = Redis:get(TheMero.."All:Get:Reides:Commands:Group"..text) or Redis:get(TheMero.."Mero:Get:Reides:Commands:Group"..msg_chat_id..":"..text)
if NewCmmd then
text = (NewCmmd or text)
end
end
if text == 'تفعيل قبول الطلبات' then
if msg.Addictive then
Redis:set(TheMero.."Mero:AutoAcceptJoin"..msg_chat_id, "true")
Redis:del(TheMero.."Mero:AutoDeclineJoin"..msg_chat_id)
return send(msg_chat_id,msg_id,'⇜ *تم تفعيل القبول التلقائي لطلبات الانضمام* ✅\n⇜ سيتم قبول أي طلب انضمام تلقائياً',"md",true)
else
return send(msg_chat_id,msg_id,'⇜ *ليس لديك صلاحية تفعيل هذا الأمر*',"md",true)
end
end
if text == 'تعطيل قبول الطلبات' then
if msg.Addictive then
Redis:del(TheMero.."Mero:AutoAcceptJoin"..msg_chat_id)
Redis:del(TheMero.."Mero:AutoDeclineJoin"..msg_chat_id)
return send(msg_chat_id,msg_id,'⇜ *تم تعطيل القبول التلقائي لطلبات الانضمام* ❌\n⇜ لن يتم قبول الطلبات تلقائياً',"md",true)
else
return send(msg_chat_id,msg_id,'⇜ *ليس لديك صلاحية تعطيل هذا الأمر*',"md",true)
end
end
if text == 'رفض الطلبات' then
if msg.Addictive then
Redis:set(TheMero.."Mero:AutoDeclineJoin"..msg_chat_id, "true")
Redis:del(TheMero.."Mero:AutoAcceptJoin"..msg_chat_id)
return send(msg_chat_id,msg_id,'⇜ *تم تفعيل الرفض التلقائي لطلبات الانضمام* 🚫\n⇜ سيتم رفض أي طلب انضمام تلقائياً',"md",true)
else
return send(msg_chat_id,msg_id,'⇜ *ليس لديك صلاحية تفعيل هذا الأمر*',"md",true)
end
end
if text == 'حالة الطلبات' then
if msg.Addictive then
local autoAccept = Redis:get(TheMero.."Mero:AutoAcceptJoin"..msg_chat_id)
local autoDecline = Redis:get(TheMero.."Mero:AutoDeclineJoin"..msg_chat_id)
local status
if autoAccept then
status = '✅ القبول التلقائي مفعّل\n⇜ يتم قبول طلبات الانضمام تلقائياً'
elseif autoDecline then
status = '🚫 الرفض التلقائي مفعّل\n⇜ يتم رفض طلبات الانضمام تلقائياً'
else
status = '⏸ لا يوجد إجراء تلقائي على الطلبات'
end
return send(msg_chat_id,msg_id,'⇜ *حالة طلبات الانضمام*\n⇜ '..status,"md",true)
else
return send(msg_chat_id,msg_id,'⇜ *ليس لديك صلاحية*',"md",true)
end
end
if text == 'تثبيت النتائج' or text == 'تثبيت نتائج' then
if msg.ControllerBot then
time = os.date("*t")
month = time.month
day = time.day
local_time = month.."/"..day
local bank_users = Redis:smembers(TheMero.."booob")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
mony_list = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇",
"🥈",
"🥉"
}
for k,v in pairs(mony_list) do
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
Redis:set(TheMero.."medal"..v[2],convert_mony)
Redis:set(TheMero.."medal2"..v[2],emo)
Redis:set(TheMero.."medal3"..v[2],local_time)
Redis:sadd(TheMero.."medalid",v[2])
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
local user_tag = '['..user_name..'](tg://user?id='..v[2]..')'
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
Redis:set(TheMero.."medal"..v[2],convert_mony)
Redis:set(TheMero.."medal2"..v[2],emo)
Redis:set(TheMero.."medal3"..v[2],local_time)
Redis:sadd(TheMero.."medalid",v[2])
if num == 4 then
return end
end
send(msg.chat_id,msg.id, "⇜ تم تثبيت النتائج","md",true)
end
end

if text == 'حذف لعبة البنك' or text == 'حذف لعبه البنك' then
if msg.ControllerBot then
Redis:del(TheMero.."rrfffid")
Redis:del(TheMero.."booob")
Redis:del(TheMero.."taza")
Redis:del(TheMero.."ownerfram")
Redis:del(TheMero.."farmarname")
Redis:setex(TheMero.."deletbank" .. 111,1123200, true)
send(msg.chat_id,msg.id, "⇜ حذفت لعبه البنك 🏦","md",true)
end
end
if text == 'مسح لعبه المزرعه' then
if msg.ControllerBot then
for k,v in pairs(Redis:smembers(TheMero.."booob")) do 
Redis:del(TheMero.."toplvfarm"..v)
Redis:del(TheMero.."btatatime"..v)
Redis:del(TheMero.."btatanum"..v)
Redis:del(TheMero.."btataname"..v)
Redis:del(TheMero.."lemontime"..v)
Redis:del(TheMero.."lemonnum"..v)
Redis:del(TheMero.."lemonname"..v)
Redis:del(TheMero.."khesstime"..v)
Redis:del(TheMero.."khessnum"..v)
Redis:del(TheMero.."khessname"..v)
Redis:del(TheMero.."kheartime"..v)
Redis:del(TheMero.."khearnum"..v)
Redis:del(TheMero.."khearname"..v)
Redis:del(TheMero.."jzartime"..v)
Redis:del(TheMero.."jzarnum"..v)
Redis:del(TheMero.."jzarname"..v)
Redis:del(TheMero.."fleflatime"..v)
Redis:del(TheMero.."fleflanum"..v)
Redis:del(TheMero.."fleflaname"..v)
Redis:del(TheMero.."freaztime"..v)
Redis:del(TheMero.."freaznum"..v)
Redis:del(TheMero.."freazname"..v)
Redis:del(TheMero.."doratime"..v)
Redis:del(TheMero.."doranum"..v)
Redis:del(TheMero.."doraname"..v)
Redis:del(TheMero.."tomtime"..v)
Redis:del(TheMero.."tomnum"..v)
Redis:del(TheMero.."tomname"..v)
Redis:del(TheMero.."ftrtime"..v)
Redis:del(TheMero.."ftrnum"..v)
Redis:del(TheMero.."ftrname"..v)
Redis:del(TheMero.."tfahtime"..v)
Redis:del(TheMero.."tfahnum"..v)
Redis:del(TheMero.."tfahname"..v)
Redis:del(TheMero.."enabtime"..v)
Redis:del(TheMero.."enabnum"..v)
Redis:del(TheMero.."enabname"..v)
Redis:del(TheMero.."zetontime"..v)
Redis:del(TheMero.."zetonnum"..v)
Redis:del(TheMero.."zetonname"..v)
Redis:del(TheMero.."mozztime"..v)
Redis:del(TheMero.."mozznum"..v)
Redis:del(TheMero.."mozzname"..v)
Redis:del(TheMero.."mangatime"..v)
Redis:del(TheMero.."manganum"..v)
Redis:del(TheMero.."manganame"..v)
Redis:del(TheMero.."sizefram"..v)
Redis:del(TheMero.."namefram"..v)
Redis:del(TheMero.."mzroatsize"..v)
end
Redis:del(TheMero.."ownerfram")
Redis:del(TheMero.."farmarname")
send(msg.chat_id,msg.id, "⇜ مسحت لعبه المزرعه 🏦","md",true)
end
end
if text == 'مسح لعبه الكره' or text == 'مسح لعبه النوادي' then
if msg.ControllerBot then
for k,v in pairs(Redis:smembers(TheMero.."booob")) do 
Redis:del(TheMero.."namenade"..v)
Redis:del(TheMero.."nokatnade"..v)
Redis:del(TheMero.."energynade"..v)
Redis:del(TheMero.."traningnade"..v)
Redis:del(TheMero.."lkbnade"..v)
Redis:del(TheMero.."nameplayer".."1"..v)
Redis:del(TheMero.."nameplayer".."2"..v)
Redis:del(TheMero.."nameplayer".."3"..v)
Redis:del(TheMero.."nameplayer".."4"..v)
Redis:del(TheMero.."nameplayer".."5"..v)
Redis:del(TheMero.."energyplayer".."1"..v)
Redis:del(TheMero.."energyplayer".."2"..v)
Redis:del(TheMero.."energyplayer".."3"..v)
Redis:del(TheMero.."energyplayer".."4"..v)
Redis:del(TheMero.."energyplayer".."5"..v)
Redis:del(TheMero.."mrkzplayer".."1"..v)
Redis:del(TheMero.."mrkzplayer".."2"..v)
Redis:del(TheMero.."mrkzplayer".."3"..v)
Redis:del(TheMero.."mrkzplayer".."4"..v)
Redis:del(TheMero.."mrkzplayer".."5"..v)
Redis:del(TheMero.."cityplayer".."1"..v)
Redis:del(TheMero.."cityplayer".."2"..v)
Redis:del(TheMero.."cityplayer".."3"..v)
Redis:del(TheMero.."cityplayer".."4"..v)
Redis:del(TheMero.."cityplayer".."5"..v)
Redis:del(TheMero.."priceplayer".."1"..v)
Redis:del(TheMero.."priceplayer".."2"..v)
Redis:del(TheMero.."priceplayer".."3"..v)
Redis:del(TheMero.."priceplayer".."4"..v)
Redis:del(TheMero.."priceplayer".."5"..v)
end
Redis:del(TheMero.."lkbnadesadd")
Redis:del(TheMero.."ownernade")
send(msg.chat_id,msg.id, "⇜ مسحت لعبه النوادي ⚽️","md",true)
end
end

if text == 'مسح لعبة البنك' or text == 'مسح لعبه البنك' then
if msg.ControllerBot then
local bank_users = Redis:smembers(TheMero.."booob")
for k,v in pairs(bank_users) do
Redis:del(TheMero.."boob"..v)
Redis:del(TheMero.."kreednum"..v)
Redis:del(TheMero.."kreed"..v)
Redis:del(TheMero.."rrfff"..v)
Redis:del(TheMero.."numattack"..v)
Redis:del(TheMero.."tabbroat"..v)
Redis:del(TheMero.."shkse"..v)
Redis:del(TheMero.."doltebank"..v)
Redis:del(TheMero.."ratbinc"..v)
Redis:del(TheMero.."ratbtrans"..v)
Redis:del(TheMero.."mgrmasname"..v)
Redis:del(TheMero.."mgrmasnum"..v)
Redis:del(TheMero.."mgrkldname"..v)
Redis:del(TheMero.."mgrkldnum"..v)
Redis:del(TheMero.."mgrswrname"..v)
Redis:del(TheMero.."mgrswrnum"..v)
Redis:del(TheMero.."mgrktmname"..v)
Redis:del(TheMero.."mgrktmnum"..v)
Redis:del(TheMero.."akrksrname"..v)
Redis:del(TheMero.."akrksrnum"..v)
Redis:del(TheMero.."akrfelname"..v)
Redis:del(TheMero.."akrfelnum"..v)
Redis:del(TheMero.."akrmnzname"..v)
Redis:del(TheMero.."akrmnznum"..v)
Redis:del(TheMero.."airshbhname"..v)
Redis:del(TheMero.."airshbhnum"..v)
Redis:del(TheMero.."airsfarname"..v)
Redis:del(TheMero.."airsfarnum"..v)
Redis:del(TheMero.."airkhasname"..v)
Redis:del(TheMero.."airkhasnum"..v)
Redis:del(TheMero.."carrangname"..v)
Redis:del(TheMero.."carrangnum"..v)
Redis:del(TheMero.."caraccename"..v)
Redis:del(TheMero.."caraccenum"..v)
Redis:del(TheMero.."carcamrname"..v)
Redis:del(TheMero.."carcamrnum"..v)
Redis:del(TheMero.."caralntrname"..v)
Redis:del(TheMero.."caralntrnum"..v)
Redis:del(TheMero.."carhilxname"..v)
Redis:del(TheMero.."carhilxnum"..v)
Redis:del(TheMero.."carsonaname"..v)
Redis:del(TheMero.."carsonanum"..v)
Redis:del(TheMero.."carcoroname"..v)
Redis:del(TheMero.."carcoronum"..v)
Redis:del(TheMero.."rotpa"..v)
Redis:del(TheMero.."rddd"..v)
Redis:del(TheMero.."rotpagrid"..v)
Redis:del(TheMero.."rotpaid"..v)
Redis:del(TheMero.."rdddgr"..v)
Redis:del(TheMero.."rdddid"..v)
Redis:del(TheMero.."rdddtex"..v)
end
for k,v in pairs(Redis:smembers(TheMero.."company_owners:")) do 
local Cname = Redis:get(TheMero.."companys_name:"..v)
Redis:del(TheMero.."companys_owner:"..Cname)
Redis:del(TheMero.."companys_id:"..Cname)
Redis:del(TheMero.."company:mem:"..Cname)
Redis:del(TheMero.."companys_name:"..v)
end
Redis:del(TheMero.."company_owners:")
Redis:del(TheMero.."companys:")
Redis:del(TheMero.."in_company:")
local bank_usersr = Redis:smembers(TheMero.."rrfffid")
for k,v in pairs(bank_usersr) do
Redis:del(TheMero.."boob"..v)
Redis:del(TheMero.."rrfff"..v)
end
for k,v in pairs(Redis:smembers(TheMero.."ownerfram")) do 
Redis:del(TheMero.."toplvfarm"..v)
Redis:del(TheMero.."btatatime"..v)
Redis:del(TheMero.."btatanum"..v)
Redis:del(TheMero.."btataname"..v)
Redis:del(TheMero.."lemontime"..v)
Redis:del(TheMero.."lemonnum"..v)
Redis:del(TheMero.."lemonname"..v)
Redis:del(TheMero.."khesstime"..v)
Redis:del(TheMero.."khessnum"..v)
Redis:del(TheMero.."khessname"..v)
Redis:del(TheMero.."kheartime"..v)
Redis:del(TheMero.."khearnum"..v)
Redis:del(TheMero.."khearname"..v)
Redis:del(TheMero.."jzartime"..v)
Redis:del(TheMero.."jzarnum"..v)
Redis:del(TheMero.."jzarname"..v)
Redis:del(TheMero.."fleflatime"..v)
Redis:del(TheMero.."fleflanum"..v)
Redis:del(TheMero.."fleflaname"..v)
Redis:del(TheMero.."freaztime"..v)
Redis:del(TheMero.."freaznum"..v)
Redis:del(TheMero.."freazname"..v)
Redis:del(TheMero.."doratime"..v)
Redis:del(TheMero.."doranum"..v)
Redis:del(TheMero.."doraname"..v)
Redis:del(TheMero.."tomtime"..v)
Redis:del(TheMero.."tomnum"..v)
Redis:del(TheMero.."tomname"..v)
Redis:del(TheMero.."ftrtime"..v)
Redis:del(TheMero.."ftrnum"..v)
Redis:del(TheMero.."ftrname"..v)
Redis:del(TheMero.."tfahtime"..v)
Redis:del(TheMero.."tfahnum"..v)
Redis:del(TheMero.."tfahname"..v)
Redis:del(TheMero.."enabtime"..v)
Redis:del(TheMero.."enabnum"..v)
Redis:del(TheMero.."enabname"..v)
Redis:del(TheMero.."zetontime"..v)
Redis:del(TheMero.."zetonnum"..v)
Redis:del(TheMero.."zetonname"..v)
Redis:del(TheMero.."mozztime"..v)
Redis:del(TheMero.."mozznum"..v)
Redis:del(TheMero.."mozzname"..v)
Redis:del(TheMero.."mangatime"..v)
Redis:del(TheMero.."manganum"..v)
Redis:del(TheMero.."manganame"..v)
Redis:del(TheMero.."sizefram"..v)
Redis:del(TheMero.."namefram"..v)
Redis:del(TheMero.."mzroatsize"..v)
end
send(msg.chat_id,msg.id, "⇜ مسحت لعبه البنك 🏦","md",true)
end
end
if text == 'مسح لعبه الزواج' then
if msg.ControllerBot then
local zwag_users = Redis:smembers(TheMero.."roogg1")
for k,v in pairs(zwag_users) do
Redis:del(TheMero.."roog1"..v)
Redis:del(TheMero.."rooga1"..v)
Redis:del(TheMero.."rahr1"..v)
Redis:del(TheMero.."rahrr1"..v)
Redis:del(TheMero.."roogte1"..v)
end
local zwaga_users = Redis:smembers(TheMero.."roogga1")
for k,v in pairs(zwaga_users) do
Redis:del(TheMero.."roog1"..v)
Redis:del(TheMero.."rooga1"..v)
Redis:del(TheMero.."rahr1"..v)
Redis:del(TheMero.."rahrr1"..v)
Redis:del(TheMero.."roogte1"..v)
end
Redis:del(TheMero.."roogga1")
Redis:del(TheMero.."roogg1")
send(msg.chat_id,msg.id, "⇜ مسحت لعبه الزواج","md",true)
end
end
if text == 'ميدالياتي' or text == 'ميداليات' then

if Redis:sismember(TheMero.."medalid",(_bank_uid)) then
local medaa2 = Redis:get(TheMero.."medal2"..(_bank_uid))
if medaa2 == "🥇" then
local medaa = Redis:get(TheMero.."medal"..(_bank_uid))
local medaa2 = Redis:get(TheMero.."medal2"..(_bank_uid))
local medaa3 = Redis:get(TheMero.."medal3"..(_bank_uid))
send(msg.chat_id,msg.id, "ميدالياتك ↤\n\nالتاريخ ↤ "..medaa3.." \nالفلوس ↤ "..medaa.." 💵\nالمركز ↤ "..medaa2.." كونكر "..medaa2.."\n✧","md",true)
elseif medaa2 == "🥈" then
local medaa = Redis:get(TheMero.."medal"..(_bank_uid))
local medaa2 = Redis:get(TheMero.."medal2"..(_bank_uid))
local medaa3 = Redis:get(TheMero.."medal3"..(_bank_uid))
send(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ ↤ "..medaa3.." \nالفلوس ↤ "..medaa.." 💵\nالمركز ↤ "..medaa2.." ايس "..medaa2.."\n✧","md",true)
else
local medaa = Redis:get(TheMero.."medal"..(_bank_uid))
local medaa2 = Redis:get(TheMero.."medal2"..(_bank_uid))
local medaa3 = Redis:get(TheMero.."medal3"..(_bank_uid))
send(msg.chat_id,msg.id, "ميدالياتك ↤\n\nالتاريخ ↤ "..medaa3.." \nالفلوس ↤ "..medaa.." 💵\nالمركز ↤ "..medaa2.." كراون "..medaa2.."\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك ميداليات","md",true)
end
end
if text == Redis:get(TheMero..'klmahzr'..msg.chat_id) and (_bank_uid) == Redis:get(TheMero..'playerhzr'..msg.chat_id) then
if not Redis:get(TheMero.."playerhzrktm"..msg.chat_id..(_bank_uid)) then
playerhzr = Redis:get(TheMero..'playerhzr'..msg.chat_id)
Redis:srem(TheMero.."Mero:SilentGroup:Group"..msg.chat_id,playerhzr) 
Redis:del(TheMero.."playerhzrktm"..msg.chat_id..playerhzr)
end
end
if text and Redis:get(TheMero.."Start_egabahzr"..msg.chat_id) then
playerhzr = Redis:get(TheMero..'playerhzr'..msg.chat_id)
klmahzr = Redis:get(TheMero..'klmahzr'..msg.chat_id)
local ban = bot.getUser(playerhzr)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..playerhzr..")"
else
news = '@['..ban.username..']'
end
if tonumber(playerhzr) == (_bank_uid) then
if text == klmahzr then
Redis:del(TheMero.."Start_egabahzr"..msg.chat_id)
Redis:del(TheMero.."playerhzrktm"..msg.chat_id..(_bank_uid))
Redis:srem(TheMero.."Mero:SilentGroup:Group"..msg.chat_id,(_bank_uid)) 
send(msg.chat_id,msg.id,"「 "..news.." 」\n⇜ كفو عليك حزرت الاجابة ( "..klmahzr.." )\n⇜ تم فك الكتم عنك \n✧ ","md",true)
end
end
end

if not Redis:get(TheMero.."lock_getpankiuserall") or not Redis:get(TheMero.."lock_getpankiuser"..msg.chat_id) then
if text == 'بنك' or text == 'البنك' then

send(msg.chat_id,msg.id,[[
☆ اوامر البنك

⌯ انشاء حساب بنكي  ↢ تسوي حساب وتقدر تحول فلوس مع مزايا ثانيه

⌯ مسح حساب بنكي  ↢ تلغي حسابك البنكي

⌯ تحويل ↢ تطلب رقم حساب الشخص وتحول له فلوس

⌯ حسابي  ↢ يطلع لك رقم حسابك عشان تعطيه للشخص اللي بيحول لك

⌯ فلوسي ↢ يعلمك كم فلوسك

⌯ راتب ↢ يعطيك راتب كل ١٠ دقائق

⌯ بخشيش ↢ يعطيك بخشيش كل ١٠ دقايق

⌯ زرف ↢ تزرف فلوس اشخاص كل ١٠ دقايق

⌯ استثمار ↢ تستثمر بالمبلغ اللي تبيه مع نسبة ربح مضمونه من ١٪؜ الى ١٥٪؜

⌯ حظ ↢ تلعبها بأي مبلغ ياتدبله ياتخسره انت وحظك

⌯ مضاربه ↢ تضارب بأي مبلغ تبيه والنسبة من ٩٠٪؜ الى -٩٠٪؜ انت وحظك

⌯ هجوم ↢ تهجم عالخصم مع زيادة نسبة كل هجوم

⌯ كنز ↢ يعطيك كنز بسعر مختلف انتا وحظك

⌯ مراهنه ↢ تحط مبلغ وتراهن عليه

⌯ توب الفلوس ↢ يطلع توب اكثر ناس معهم فلوس بكل القروبات

⌯ توب الحراميه ↢ يطلع لك اكثر ناس زرفوا

⌯ زواج  ↢ تكتبه بالرد على رسالة شخص مع المهر ويزوجك

⌯ زواجي  ↢ يطلع وثيقة زواجك اذا متزوج

⌯ طلاق ↢ يطلقك اذا متزوج

⌯ خلع  ↢ يخلع زوجك ويرجع له المهر

⌯ زواجات ↢ يطلع اغلى ٣٠ زواجات

⌯ ترتيبي ↢ يطلع ترتيبك باللعبة

⌯ المعرض ↢ يمديك تشتري سيارات وعقارات وكثير اشياء

⌯ ممتلكاتي ↢ يطلع لك مشترياتك من المعرض

⌯ تبرع ↢ تتبرع الى افقر اللاعبين

⌯ انشاء شركه ↢ تنشئ شركتك وتضيف اصدقائك

⌯ بناء مزرعه ↢ تبني مزرعتك وتزرع وتحصد خضار

-
]],"md",true)  
return false
end
if text == 'انشاء حساب بنكي' or text == 'انشاء حساب البنكي' or text =='انشاء الحساب بنكي' or text =='انشاء الحساب البنكي' or text == "انشاء حساب" or text == "فتح حساب بنكي" then

cobnum = tonumber(Redis:get(TheMero.."bandid"..(_bank_uid)))
if cobnum == (_bank_uid) then
return send(msg.chat_id,msg.id, "⇜ حسابك محظور من لعبة البنك","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ لديك حساب بنكي مسبقاً\n\n⇜ لعرض معلومات حسابك اكتب\n⇠ `حسابي`","md",true)
end
ttshakse = '⇜ عشان تسوي حساب اختار نوع بطاقتك'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'ماستر', data = (_bank_uid)..'/master'},{text = 'فيزا', data = (_bank_uid)..'/visaa'},{text = 'اكسبرس', data = (_bank_uid)..'/express'},
},
{text = 'روبـي 🪄',url="t.me/FvvZv"}, 
}
}
return send(msg.chat_id,msg.id,ttshakse,"md",false, false, false, false, reply_markup)
end
if text == 'مسح حساب بنكي' or text == 'مسح حساب البنكي' or text =='مسح الحساب بنكي' or text =='مسح الحساب البنكي' or text == "مسح حسابي البنكي" or text == "مسح حسابي بنكي" or text == "مسح حسابي" then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ مسحت حسابك البنكي 🏦","md",true)
Redis:srem(TheMero.."booob", (_bank_uid))
Redis:srem(TheMero.."taza", (_bank_uid))
Redis:del(TheMero.."boob"..(_bank_uid))
Redis:del(TheMero.."boobb"..(_bank_uid))
Redis:del(TheMero.."rrfff"..(_bank_uid))
Redis:srem(TheMero.."rrfffid", (_bank_uid))
Redis:srem(TheMero.."roogg1", (_bank_uid))
Redis:srem(TheMero.."roogga1", (_bank_uid))
Redis:del(TheMero.."roog1"..(_bank_uid))
Redis:del(TheMero.."rooga1"..(_bank_uid))
Redis:del(TheMero.."rahr1"..(_bank_uid))
Redis:del(TheMero.."rahrr1"..(_bank_uid))
Redis:del(TheMero.."tabbroat"..(_bank_uid))
Redis:del(TheMero.."shkse"..(_bank_uid))
Redis:del(TheMero.."doltebank"..(_bank_uid))
Redis:del(TheMero.."ratbinc"..(_bank_uid))
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:del(TheMero.."mgrmasname"..(_bank_uid))
Redis:del(TheMero.."mgrmasnum"..(_bank_uid))
Redis:del(TheMero.."mgrkldname"..(_bank_uid))
Redis:del(TheMero.."mgrkldnum"..(_bank_uid))
Redis:del(TheMero.."mgrswrname"..(_bank_uid))
Redis:del(TheMero.."mgrswrnum"..(_bank_uid))
Redis:del(TheMero.."mgrktmname"..(_bank_uid))
Redis:del(TheMero.."mgrktmnum"..(_bank_uid))
Redis:del(TheMero.."akrksrname"..(_bank_uid))
Redis:del(TheMero.."akrksrnum"..(_bank_uid))
Redis:del(TheMero.."akrfelname"..(_bank_uid))
Redis:del(TheMero.."akrfelnum"..(_bank_uid))
Redis:del(TheMero.."akrmnzname"..(_bank_uid))
Redis:del(TheMero.."akrmnznum"..(_bank_uid))
Redis:del(TheMero.."airshbhname"..(_bank_uid))
Redis:del(TheMero.."airshbhnum"..(_bank_uid))
Redis:del(TheMero.."airsfarname"..(_bank_uid))
Redis:del(TheMero.."airsfarnum"..(_bank_uid))
Redis:del(TheMero.."airkhasname"..(_bank_uid))
Redis:del(TheMero.."airkhasnum"..(_bank_uid))
Redis:del(TheMero.."carrangname"..(_bank_uid))
Redis:del(TheMero.."carrangnum"..(_bank_uid))
Redis:del(TheMero.."caraccename"..(_bank_uid))
Redis:del(TheMero.."caraccenum"..(_bank_uid))
Redis:del(TheMero.."carcamrname"..(_bank_uid))
Redis:del(TheMero.."carcamrnum"..(_bank_uid))
Redis:del(TheMero.."caralntrname"..(_bank_uid))
Redis:del(TheMero.."caralntrnum"..(_bank_uid))
Redis:del(TheMero.."carhilxname"..(_bank_uid))
Redis:del(TheMero.."carhilxnum"..(_bank_uid))
Redis:del(TheMero.."carsonaname"..(_bank_uid))
Redis:del(TheMero.."carsonanum"..(_bank_uid))
Redis:del(TheMero.."carcoroname"..(_bank_uid))
Redis:del(TheMero.."carcoronum"..(_bank_uid))
namfra = Redis:get(TheMero.."namefram"..(_bank_uid))
Redis:del(TheMero.."toplvfarm"..(_bank_uid))
Redis:del(TheMero.."btatatime"..(_bank_uid))
Redis:del(TheMero.."btatanum"..(_bank_uid))
Redis:del(TheMero.."btataname"..(_bank_uid))
Redis:del(TheMero.."lemontime"..(_bank_uid))
Redis:del(TheMero.."lemonnum"..(_bank_uid))
Redis:del(TheMero.."lemonname"..(_bank_uid))
Redis:del(TheMero.."khesstime"..(_bank_uid))
Redis:del(TheMero.."khessnum"..(_bank_uid))
Redis:del(TheMero.."khessname"..(_bank_uid))
Redis:del(TheMero.."kheartime"..(_bank_uid))
Redis:del(TheMero.."khearnum"..(_bank_uid))
Redis:del(TheMero.."khearname"..(_bank_uid))
Redis:del(TheMero.."jzartime"..(_bank_uid))
Redis:del(TheMero.."jzarnum"..(_bank_uid))
Redis:del(TheMero.."jzarname"..(_bank_uid))
Redis:del(TheMero.."fleflatime"..(_bank_uid))
Redis:del(TheMero.."fleflanum"..(_bank_uid))
Redis:del(TheMero.."fleflaname"..(_bank_uid))
Redis:del(TheMero.."freaztime"..(_bank_uid))
Redis:del(TheMero.."freaznum"..(_bank_uid))
Redis:del(TheMero.."freazname"..(_bank_uid))
Redis:del(TheMero.."doratime"..(_bank_uid))
Redis:del(TheMero.."doranum"..(_bank_uid))
Redis:del(TheMero.."doraname"..(_bank_uid))
Redis:del(TheMero.."tomtime"..(_bank_uid))
Redis:del(TheMero.."tomnum"..(_bank_uid))
Redis:del(TheMero.."tomname"..(_bank_uid))
Redis:del(TheMero.."ftrtime"..(_bank_uid))
Redis:del(TheMero.."ftrnum"..(_bank_uid))
Redis:del(TheMero.."ftrname"..(_bank_uid))
Redis:del(TheMero.."tfahtime"..(_bank_uid))
Redis:del(TheMero.."tfahnum"..(_bank_uid))
Redis:del(TheMero.."tfahname"..(_bank_uid))
Redis:del(TheMero.."enabtime"..(_bank_uid))
Redis:del(TheMero.."enabnum"..(_bank_uid))
Redis:del(TheMero.."enabname"..(_bank_uid))
Redis:del(TheMero.."zetontime"..(_bank_uid))
Redis:del(TheMero.."zetonnum"..(_bank_uid))
Redis:del(TheMero.."zetonname"..(_bank_uid))
Redis:del(TheMero.."mozztime"..(_bank_uid))
Redis:del(TheMero.."mozznum"..(_bank_uid))
Redis:del(TheMero.."mozzname"..(_bank_uid))
Redis:del(TheMero.."mangatime"..(_bank_uid))
Redis:del(TheMero.."manganum"..(_bank_uid))
Redis:del(TheMero.."manganame"..(_bank_uid))
Redis:del(TheMero.."sizefram"..(_bank_uid))
Redis:del(TheMero.."namefram"..(_bank_uid))
Redis:del(TheMero.."mzroatsize"..(_bank_uid))
Redis:srem(TheMero.."farmarname", namfra)
Redis:srem(TheMero.."ownerfram",(_bank_uid))
namenad = Redis:get(TheMero.."lkbnade"..(_bank_uid))
Redis:del(TheMero.."namenade"..(_bank_uid))
Redis:del(TheMero.."nokatnade"..(_bank_uid))
Redis:del(TheMero.."energynade"..(_bank_uid))
Redis:del(TheMero.."traningnade"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."1"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."2"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."3"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."4"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."5"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."1"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."2"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."3"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."4"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."5"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."1"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."2"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."3"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."4"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."5"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."1"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."2"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."3"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."4"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."5"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."1"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."2"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."3"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."4"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."5"..(_bank_uid))
Redis:srem(TheMero.."lkbnadesadd", namenad)
Redis:srem(TheMero.."ownernade",(_bank_uid))
Redis:del(TheMero.."lkbnade"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'فلوسي' or text == 'فلوس' and tonumber(msg.reply_to_message_id) == 0 then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballancee) < 1 then
return send(msg.chat_id,msg.id, "⇜ ماعندك فلوس \n✧","md",true)
end
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id, "⇜ فلوسك `"..convert_mony.."`  ريال 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match("^فلوس @(%S+)$") or text and text:match("^فلوسه @(%S+)$") then
local UserName = text:match("^فلوس @(%S+)$") or text:match("^فلوسه @(%S+)$")
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return send(msg.chat_id,msg.id,"\n⇜ مافيه حساب كذا ","md",true)
end
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return send(msg.chat_id,msg.id,"\n⇜ هذا بوت  ","md",true)  
end
if Redis:sismember(TheMero.."booob",UserId_Info.id) then
ballanceed = Redis:get(TheMero.."boob"..UserId_Info.id) or 0
local convert_mony = string.format("%.0f",ballanceed)
send(msg.chat_id,msg.id, "⇜ فلوسه `"..convert_mony.."` ريال 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
end
if text == 'فلوسه' or text == 'فلوس' and tonumber(msg.reply_to_message_id) ~= 0 then

local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك ","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballanceed)
send(msg.chat_id,msg.id, "⇜ فلوسه `"..convert_mony.."` ريال 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
end
if text == 'حسابي' or text == 'حسابي البنكي' or text == 'رقم حسابي' then

local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد اسم"
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
cccc = Redis:get(TheMero.."boobb"..(_bank_uid))
uuuu = Redis:get(TheMero.."bbobb"..(_bank_uid))
pppp = Redis:get(TheMero.."rrfff"..(_bank_uid)) or 0
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
doltebank = Redis:get(TheMero.."doltebank"..(_bank_uid))
local convert_mony = string.format("%.0f",ballancee)
if shkse == "طيبة" then
shkseemg = "طيبة 😇"
else
shkseemg = "شريرة 😈"
end
send(msg.chat_id,msg.id, "⇜ الاسم ↤ "..news.."\n⇜ الحساب ↤ `"..cccc.."`\n⇜ بنك ↤ ❲ روبي ❳\n⇜ نوع ↤ ❲ "..uuuu.." ❳\n⇜ الرصيد ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ الزرف ❲ "..math.floor(pppp).." ريال 💵 ❳\n⇜ شخصيتك ↤ ❲ "..shkseemg.." ❳\n⇜ دولتك ↤ ❲ "..doltebank.." ❳","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مسح حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then
if msg.ControllerBot then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك ","md",true)  
return false
end
local ban = bot.getUser(Re(_bank_uid))
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد اسم"
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local Cname = Redis:get(TheMero.."in_company:name:"..(_bank_uid)) or 0
Redis:srem(TheMero.."company:mem:"..Cname, (_bank_uid))
Redis:srem(TheMero.."in_company:", (_bank_uid))
Redis:del(TheMero.."in_company:name:"..(_bank_uid), Cname)
ccccc = Redis:get(TheMero.."boobb"..Re(_bank_uid))
uuuuu = Redis:get(TheMero.."bbobb"..Re(_bank_uid))
ppppp = Redis:get(TheMero.."rrfff"..Re(_bank_uid)) or 0
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballanceed)
Redis:srem(TheMero.."booob", Re(_bank_uid))
Redis:srem(TheMero.."taza", Re(_bank_uid))
namfra = Redis:get(TheMero.."namefram"..Re(_bank_uid))
Redis:del(TheMero.."boob"..Re(_bank_uid))
Redis:del(TheMero.."boobb"..Re(_bank_uid))
Redis:del(TheMero.."rrfff"..Re(_bank_uid))
Redis:del(TheMero.."numattack"..Re(_bank_uid))
Redis:srem(TheMero.."rrfffid", Re(_bank_uid))
Redis:srem(TheMero.."roogg1", Re(_bank_uid))
Redis:srem(TheMero.."roogga1", Re(_bank_uid))
Redis:del(TheMero.."roog1"..Re(_bank_uid))
Redis:del(TheMero.."rooga1"..Re(_bank_uid))
Redis:del(TheMero.."rahr1"..Re(_bank_uid))
Redis:del(TheMero.."rahrr1"..Re(_bank_uid))
Redis:del(TheMero.."tabbroat"..Re(_bank_uid))
Redis:del(TheMero.."shkse"..Re(_bank_uid))
Redis:del(TheMero.."doltebank"..Re(_bank_uid))
Redis:del(TheMero.."ratbinc"..Re(_bank_uid))
Redis:del(TheMero.."ratbtrans"..Re(_bank_uid))
Redis:del(TheMero.."mgrmasname"..Re(_bank_uid))
Redis:del(TheMero.."mgrmasnum"..Re(_bank_uid))
Redis:del(TheMero.."mgrkldname"..Re(_bank_uid))
Redis:del(TheMero.."mgrkldnum"..Re(_bank_uid))
Redis:del(TheMero.."mgrswrname"..Re(_bank_uid))
Redis:del(TheMero.."mgrswrnum"..Re(_bank_uid))
Redis:del(TheMero.."mgrktmname"..Re(_bank_uid))
Redis:del(TheMero.."mgrktmnum"..Re(_bank_uid))
Redis:del(TheMero.."akrksrname"..Re(_bank_uid))
Redis:del(TheMero.."akrksrnum"..Re(_bank_uid))
Redis:del(TheMero.."akrfelname"..Re(_bank_uid))
Redis:del(TheMero.."akrfelnum"..Re(_bank_uid))
Redis:del(TheMero.."akrmnzname"..Re(_bank_uid))
Redis:del(TheMero.."akrmnznum"..Re(_bank_uid))
Redis:del(TheMero.."airshbhname"..Re(_bank_uid))
Redis:del(TheMero.."airshbhnum"..Re(_bank_uid))
Redis:del(TheMero.."airsfarname"..Re(_bank_uid))
Redis:del(TheMero.."airsfarnum"..Re(_bank_uid))
Redis:del(TheMero.."airkhasname"..Re(_bank_uid))
Redis:del(TheMero.."airkhasnum"..Re(_bank_uid))
Redis:del(TheMero.."carrangname"..Re(_bank_uid))
Redis:del(TheMero.."carrangnum"..Re(_bank_uid))
Redis:del(TheMero.."caraccename"..Re(_bank_uid))
Redis:del(TheMero.."caraccenum"..Re(_bank_uid))
Redis:del(TheMero.."carcamrname"..Re(_bank_uid))
Redis:del(TheMero.."carcamrnum"..Re(_bank_uid))
Redis:del(TheMero.."caralntrname"..Re(_bank_uid))
Redis:del(TheMero.."caralntrnum"..Re(_bank_uid))
Redis:del(TheMero.."carhilxname"..Re(_bank_uid))
Redis:del(TheMero.."carhilxnum"..Re(_bank_uid))
Redis:del(TheMero.."carsonaname"..Re(_bank_uid))
Redis:del(TheMero.."carsonanum"..Re(_bank_uid))
Redis:del(TheMero.."carcoroname"..Re(_bank_uid))
Redis:del(TheMero.."carcoronum"..Re(_bank_uid))
Redis:del(TheMero.."rotpa"..Re(_bank_uid))
Redis:del(TheMero.."rddd"..Re(_bank_uid))
Redis:del(TheMero.."rotpagrid"..Re(_bank_uid))
Redis:del(TheMero.."rotpaid"..Re(_bank_uid))
Redis:del(TheMero.."rdddgr"..Re(_bank_uid))
Redis:del(TheMero.."rdddid"..Re(_bank_uid))
Redis:del(TheMero.."rdddtex"..Re(_bank_uid))
Redis:del(TheMero.."toplvfarm"..Re(_bank_uid))
Redis:del(TheMero.."btatatime"..Re(_bank_uid))
Redis:del(TheMero.."btatanum"..Re(_bank_uid))
Redis:del(TheMero.."btataname"..Re(_bank_uid))
Redis:del(TheMero.."lemontime"..Re(_bank_uid))
Redis:del(TheMero.."lemonnum"..Re(_bank_uid))
Redis:del(TheMero.."lemonname"..Re(_bank_uid))
Redis:del(TheMero.."khesstime"..Re(_bank_uid))
Redis:del(TheMero.."khessnum"..Re(_bank_uid))
Redis:del(TheMero.."khessname"..Re(_bank_uid))
Redis:del(TheMero.."kheartime"..Re(_bank_uid))
Redis:del(TheMero.."khearnum"..Re(_bank_uid))
Redis:del(TheMero.."khearname"..Re(_bank_uid))
Redis:del(TheMero.."jzartime"..Re(_bank_uid))
Redis:del(TheMero.."jzarnum"..Re(_bank_uid))
Redis:del(TheMero.."jzarname"..Re(_bank_uid))
Redis:del(TheMero.."fleflatime"..Re(_bank_uid))
Redis:del(TheMero.."fleflanum"..Re(_bank_uid))
Redis:del(TheMero.."fleflaname"..Re(_bank_uid))
Redis:del(TheMero.."freaztime"..Re(_bank_uid))
Redis:del(TheMero.."freaznum"..Re(_bank_uid))
Redis:del(TheMero.."freazname"..Re(_bank_uid))
Redis:del(TheMero.."doratime"..Re(_bank_uid))
Redis:del(TheMero.."doranum"..Re(_bank_uid))
Redis:del(TheMero.."doraname"..Re(_bank_uid))
Redis:del(TheMero.."tomtime"..Re(_bank_uid))
Redis:del(TheMero.."tomnum"..Re(_bank_uid))
Redis:del(TheMero.."tomname"..Re(_bank_uid))
Redis:del(TheMero.."ftrtime"..Re(_bank_uid))
Redis:del(TheMero.."ftrnum"..Re(_bank_uid))
Redis:del(TheMero.."ftrname"..Re(_bank_uid))
Redis:del(TheMero.."tfahtime"..Re(_bank_uid))
Redis:del(TheMero.."tfahnum"..Re(_bank_uid))
Redis:del(TheMero.."tfahname"..Re(_bank_uid))
Redis:del(TheMero.."enabtime"..Re(_bank_uid))
Redis:del(TheMero.."enabnum"..Re(_bank_uid))
Redis:del(TheMero.."enabname"..Re(_bank_uid))
Redis:del(TheMero.."zetontime"..Re(_bank_uid))
Redis:del(TheMero.."zetonnum"..Re(_bank_uid))
Redis:del(TheMero.."zetonname"..Re(_bank_uid))
Redis:del(TheMero.."mozztime"..Re(_bank_uid))
Redis:del(TheMero.."mozznum"..Re(_bank_uid))
Redis:del(TheMero.."mozzname"..Re(_bank_uid))
Redis:del(TheMero.."mangatime"..Re(_bank_uid))
Redis:del(TheMero.."manganum"..Re(_bank_uid))
Redis:del(TheMero.."manganame"..Re(_bank_uid))
Redis:del(TheMero.."sizefram"..Re(_bank_uid))
Redis:del(TheMero.."namefram"..Re(_bank_uid))
Redis:del(TheMero.."mzroatsize"..Re(_bank_uid))
Redis:srem(TheMero.."farmarname", namfra)
Redis:srem(TheMero.."ownerfram",Re(_bank_uid))
namenad = Redis:get(TheMero.."lkbnade"..Re(_bank_uid))
Redis:del(TheMero.."namenade"..Re(_bank_uid))
Redis:del(TheMero.."nokatnade"..Re(_bank_uid))
Redis:del(TheMero.."energynade"..Re(_bank_uid))
Redis:del(TheMero.."traningnade"..Re(_bank_uid))
Redis:del(TheMero.."nameplayer".."1"..Re(_bank_uid))
Redis:del(TheMero.."nameplayer".."2"..Re(_bank_uid))
Redis:del(TheMero.."nameplayer".."3"..Re(_bank_uid))
Redis:del(TheMero.."nameplayer".."4"..Re(_bank_uid))
Redis:del(TheMero.."nameplayer".."5"..Re(_bank_uid))
Redis:del(TheMero.."energyplayer".."1"..Re(_bank_uid))
Redis:del(TheMero.."energyplayer".."2"..Re(_bank_uid))
Redis:del(TheMero.."energyplayer".."3"..Re(_bank_uid))
Redis:del(TheMero.."energyplayer".."4"..Re(_bank_uid))
Redis:del(TheMero.."energyplayer".."5"..Re(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."1"..Re(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."2"..Re(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."3"..Re(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."4"..Re(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."5"..Re(_bank_uid))
Redis:del(TheMero.."cityplayer".."1"..Re(_bank_uid))
Redis:del(TheMero.."cityplayer".."2"..Re(_bank_uid))
Redis:del(TheMero.."cityplayer".."3"..Re(_bank_uid))
Redis:del(TheMero.."cityplayer".."4"..Re(_bank_uid))
Redis:del(TheMero.."cityplayer".."5"..Re(_bank_uid))
Redis:del(TheMero.."priceplayer".."1"..Re(_bank_uid))
Redis:del(TheMero.."priceplayer".."2"..Re(_bank_uid))
Redis:del(TheMero.."priceplayer".."3"..Re(_bank_uid))
Redis:del(TheMero.."priceplayer".."4"..Re(_bank_uid))
Redis:del(TheMero.."priceplayer".."5"..Re(_bank_uid))
Redis:srem(TheMero.."lkbnadesadd", namenad)
Redis:srem(TheMero.."ownernade",Re(_bank_uid))
Redis:del(TheMero.."lkbnade"..Re(_bank_uid))
send(msg.chat_id,msg.id, "⇜ الاسم ↤ "..news.."\n⇜ الحساب ↤ `"..ccccc.."`\n⇜ بنك ↤ ❲ روبي ❳\n⇜ نوع ❲ "..uuuuu.." ❳\n⇜ الرصيد ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ الزرف ↤ ❲ "..math.floor(ppppp).." ريال 💵 ❳\n⇜ مسكين مسحت حسابه","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي اصلاً ","md",true)
end
end
end
if text == 'حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then

local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك ","md",true)  
return false
end
local ban = bot.getUser(Re(_bank_uid))
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد اسم"
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ccccc = Redis:get(TheMero.."boobb"..Re(_bank_uid))
uuuuu = Redis:get(TheMero.."bbobb"..Re(_bank_uid))
ppppp = Redis:get(TheMero.."rrfff"..Re(_bank_uid)) or 0
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
shkse = Redis:get(TheMero.."shkse"..Re(_bank_uid))
doltebank = Redis:get(TheMero.."doltebank"..Re(_bank_uid))
local convert_mony = string.format("%.0f",ballanceed)
if shkse == "طيبة" then
shkseemg = "طيبة 😇"
else
shkseemg = "شريرة 😈"
end
send(msg.chat_id,msg.id, "⇜ الاسم ↤ "..news.."\n⇜ الحساب ↤ `"..ccccc.."`\n⇜ بنك ↤ ❲ روبي ❳\n⇜ نوع ↤ ❲ "..uuuuu.." ❳\n⇜ الرصيد ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ الزرف ↤ ❲ "..math.floor(ppppp).." ريال 💵 ❳\n⇜ شخصيتك ↤ ❲ "..shkseemg.." ❳\n⇜ دولتك ↤ ❲ "..doltebank.." ❳ ","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
end
if text and text:match('^نسبه الحظ (.*)$') or text and text:match('^نسبة الحظ (.*)$') then
if msg.ControllerBot then
local UserName = text:match('^نسبه الحظ (.*)$') or text:match('^نسبة الحظ (.*)$')
local coniss = coin(UserName)
if coniss == 0 then
Redis:del(TheMero.."nsbhad"..1)
Redis:set(TheMero.."nsbhad"..1,0)
send(msg.chat_id,msg.id, "⇜ تم تعيين نسبة الحظ 0%","md",true)
elseif coniss == 50 then
Redis:del(TheMero.."nsbhad"..1)
Redis:set(TheMero.."nsbhad"..1,50)
send(msg.chat_id,msg.id, "⇜ تم تعيين نسبة الحظ 50%","md",true)
elseif coniss == 75 then
Redis:del(TheMero.."nsbhad"..1)
Redis:set(TheMero.."nsbhad"..1,75)
send(msg.chat_id,msg.id, "⇜ تم تعيين نسبة الحظ 75%","md",true)
elseif coniss == 100 then
Redis:del(TheMero.."nsbhad"..1)
Redis:set(TheMero.."nsbhad"..1,100)
send(msg.chat_id,msg.id, "⇜ تم تعيين نسبة الحظ 100%","md",true)
else
send(msg.chat_id,msg.id, "⇜ نسبة الحظ خطأ\n⇜ يرجى اختيار النسبة كالتالي :\n⇜ نسبه الحظ 0 او 50 او 75 او 100","md",true)
end
end
end
if text and text:match('^مسح حساب (.*)$') or text and text:match('^مسح حسابه (.*)$') then
if msg.ControllerBot then
local UserName = text:match('^مسح حساب (.*)$') or text:match('^مسح حسابه (.*)$')
local coniss = coin(UserName)
local ban = bot.getUser(coniss)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم "
end
if Redis:sismember(TheMero.."booob",coniss) then
local Cname = Redis:get(TheMero.."in_company:name:"..coniss) or 0
Redis:srem(TheMero.."company:mem:"..Cname, coniss)
Redis:srem(TheMero.."in_company:", coniss)
Redis:del(TheMero.."in_company:name:"..coniss, Cname)
ccccc = Redis:get(TheMero.."boobb"..coniss)
uuuuu = Redis:get(TheMero.."bbobb"..coniss)
ppppp = Redis:get(TheMero.."rrfff"..coniss) or 0
ballanceed = Redis:get(TheMero.."boob"..coniss) or 0
local convert_mony = string.format("%.0f",ballanceed)
namfra = Redis:get(TheMero.."namefram"..coniss)
Redis:srem(TheMero.."booob", coniss)
Redis:srem(TheMero.."taza", coniss)
Redis:del(TheMero.."boob"..coniss)
Redis:del(TheMero.."boobb"..coniss)
Redis:del(TheMero.."rrfff"..coniss)
Redis:srem(TheMero.."roogg1", coniss)
Redis:srem(TheMero.."roogga1", coniss)
Redis:del(TheMero.."roog1"..coniss)
Redis:del(TheMero.."rooga1"..coniss)
Redis:del(TheMero.."rahr1"..coniss)
Redis:del(TheMero.."rahrr1"..coniss)
Redis:del(TheMero.."tabbroat"..coniss)
Redis:del(TheMero.."shkse"..coniss)
Redis:del(TheMero.."doltebank"..coniss)
Redis:del(TheMero.."ratbinc"..coniss)
Redis:del(TheMero.."ratbtrans"..coniss)
Redis:del(TheMero.."numattack"..coniss)
Redis:del(TheMero.."mgrmasname"..coniss)
Redis:del(TheMero.."mgrmasnum"..coniss)
Redis:del(TheMero.."mgrkldname"..coniss)
Redis:del(TheMero.."mgrkldnum"..coniss)
Redis:del(TheMero.."mgrswrname"..coniss)
Redis:del(TheMero.."mgrswrnum"..coniss)
Redis:del(TheMero.."mgrktmname"..coniss)
Redis:del(TheMero.."mgrktmnum"..coniss)
Redis:del(TheMero.."akrksrname"..coniss)
Redis:del(TheMero.."akrksrnum"..coniss)
Redis:del(TheMero.."akrfelname"..coniss)
Redis:del(TheMero.."akrfelnum"..coniss)
Redis:del(TheMero.."akrmnzname"..coniss)
Redis:del(TheMero.."akrmnznum"..coniss)
Redis:del(TheMero.."airshbhname"..coniss)
Redis:del(TheMero.."airshbhnum"..coniss)
Redis:del(TheMero.."airsfarname"..coniss)
Redis:del(TheMero.."airsfarnum"..coniss)
Redis:del(TheMero.."airkhasname"..coniss)
Redis:del(TheMero.."airkhasnum"..coniss)
Redis:del(TheMero.."carrangname"..coniss)
Redis:del(TheMero.."carrangnum"..coniss)
Redis:del(TheMero.."caraccename"..coniss)
Redis:del(TheMero.."caraccenum"..coniss)
Redis:del(TheMero.."carcamrname"..coniss)
Redis:del(TheMero.."carcamrnum"..coniss)
Redis:del(TheMero.."caralntrname"..coniss)
Redis:del(TheMero.."caralntrnum"..coniss)
Redis:del(TheMero.."carhilxname"..coniss)
Redis:del(TheMero.."carhilxnum"..coniss)
Redis:del(TheMero.."carsonaname"..coniss)
Redis:del(TheMero.."carsonanum"..coniss)
Redis:del(TheMero.."carcoroname"..coniss)
Redis:del(TheMero.."carcoronum"..coniss)
Redis:srem(TheMero.."rrfffid", coniss)
Redis:del(TheMero.."rotpa"..coniss)
Redis:del(TheMero.."rddd"..coniss)
Redis:del(TheMero.."rotpagrid"..coniss)
Redis:del(TheMero.."rotpaid"..coniss)
Redis:del(TheMero.."rdddgr"..coniss)
Redis:del(TheMero.."rdddid"..coniss)
Redis:del(TheMero.."rdddtex"..coniss)
Redis:del(TheMero.."toplvfarm"..coniss)
Redis:del(TheMero.."btatatime"..coniss)
Redis:del(TheMero.."btatanum"..coniss)
Redis:del(TheMero.."btataname"..coniss)
Redis:del(TheMero.."lemontime"..coniss)
Redis:del(TheMero.."lemonnum"..coniss)
Redis:del(TheMero.."lemonname"..coniss)
Redis:del(TheMero.."khesstime"..coniss)
Redis:del(TheMero.."khessnum"..coniss)
Redis:del(TheMero.."khessname"..coniss)
Redis:del(TheMero.."kheartime"..coniss)
Redis:del(TheMero.."khearnum"..coniss)
Redis:del(TheMero.."khearname"..coniss)
Redis:del(TheMero.."jzartime"..coniss)
Redis:del(TheMero.."jzarnum"..coniss)
Redis:del(TheMero.."jzarname"..coniss)
Redis:del(TheMero.."fleflatime"..coniss)
Redis:del(TheMero.."fleflanum"..coniss)
Redis:del(TheMero.."fleflaname"..coniss)
Redis:del(TheMero.."freaztime"..coniss)
Redis:del(TheMero.."freaznum"..coniss)
Redis:del(TheMero.."freazname"..coniss)
Redis:del(TheMero.."doratime"..coniss)
Redis:del(TheMero.."doranum"..coniss)
Redis:del(TheMero.."doraname"..coniss)
Redis:del(TheMero.."tomtime"..coniss)
Redis:del(TheMero.."tomnum"..coniss)
Redis:del(TheMero.."tomname"..coniss)
Redis:del(TheMero.."ftrtime"..coniss)
Redis:del(TheMero.."ftrnum"..coniss)
Redis:del(TheMero.."ftrname"..coniss)
Redis:del(TheMero.."tfahtime"..coniss)
Redis:del(TheMero.."tfahnum"..coniss)
Redis:del(TheMero.."tfahname"..coniss)
Redis:del(TheMero.."enabtime"..coniss)
Redis:del(TheMero.."enabnum"..coniss)
Redis:del(TheMero.."enabname"..coniss)
Redis:del(TheMero.."zetontime"..coniss)
Redis:del(TheMero.."zetonnum"..coniss)
Redis:del(TheMero.."zetonname"..coniss)
Redis:del(TheMero.."mozztime"..coniss)
Redis:del(TheMero.."mozznum"..coniss)
Redis:del(TheMero.."mozzname"..coniss)
Redis:del(TheMero.."mangatime"..coniss)
Redis:del(TheMero.."manganum"..coniss)
Redis:del(TheMero.."manganame"..coniss)
Redis:del(TheMero.."sizefram"..coniss)
Redis:del(TheMero.."namefram"..coniss)
Redis:del(TheMero.."mzroatsize"..coniss)
Redis:srem(TheMero.."farmarname", namfra)
Redis:srem(TheMero.."ownerfram",coniss)
namenad = Redis:get(TheMero.."lkbnade"..coniss)
Redis:del(TheMero.."namenade"..coniss)
Redis:del(TheMero.."nokatnade"..coniss)
Redis:del(TheMero.."energynade"..coniss)
Redis:del(TheMero.."traningnade"..coniss)
Redis:del(TheMero.."nameplayer".."1"..coniss)
Redis:del(TheMero.."nameplayer".."2"..coniss)
Redis:del(TheMero.."nameplayer".."3"..coniss)
Redis:del(TheMero.."nameplayer".."4"..coniss)
Redis:del(TheMero.."nameplayer".."5"..coniss)
Redis:del(TheMero.."energyplayer".."1"..coniss)
Redis:del(TheMero.."energyplayer".."2"..coniss)
Redis:del(TheMero.."energyplayer".."3"..coniss)
Redis:del(TheMero.."energyplayer".."4"..coniss)
Redis:del(TheMero.."energyplayer".."5"..coniss)
Redis:del(TheMero.."mrkzplayer".."1"..coniss)
Redis:del(TheMero.."mrkzplayer".."2"..coniss)
Redis:del(TheMero.."mrkzplayer".."3"..coniss)
Redis:del(TheMero.."mrkzplayer".."4"..coniss)
Redis:del(TheMero.."mrkzplayer".."5"..coniss)
Redis:del(TheMero.."cityplayer".."1"..coniss)
Redis:del(TheMero.."cityplayer".."2"..coniss)
Redis:del(TheMero.."cityplayer".."3"..coniss)
Redis:del(TheMero.."cityplayer".."4"..coniss)
Redis:del(TheMero.."cityplayer".."5"..coniss)
Redis:del(TheMero.."priceplayer".."1"..coniss)
Redis:del(TheMero.."priceplayer".."2"..coniss)
Redis:del(TheMero.."priceplayer".."3"..coniss)
Redis:del(TheMero.."priceplayer".."4"..coniss)
Redis:del(TheMero.."priceplayer".."5"..coniss)
Redis:srem(TheMero.."lkbnadesadd", namenad)
Redis:srem(TheMero.."ownernade",coniss)
Redis:del(TheMero.."lkbnade"..coniss)
send(msg.chat_id,msg.id, "⇜ الاسم ↤ "..news.."\n⇜ الحساب ↤ `"..ccccc.."`\n⇜ بنك ↤ ❲ روبي ❳\n⇜ نوع ↤ ❲ "..uuuuu.." ❳\n⇜ الرصيد ↤ ❲ "..convert_mony.." ❳ ريال 💵 )\n⇜ الزرف ↤ ❲ "..math.floor(ppppp).." ريال 💵 ❳\n⇜ مسكين مسحت حسابه","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي اصلاً ","md",true)
end
end
end
if text and text:match('^حساب (.*)$') or text and text:match('^حسابه (.*)$') then

local UserName = text:match('^حساب (.*)$') or text:match('^حسابه (.*)$')
local coniss = coin(UserName)
if Redis:get(TheMero.."boballcc"..coniss) then
local yty = Redis:get(TheMero.."boballname"..coniss)
local bobpkh = Redis:get(TheMero.."boballid"..coniss)
ballancee = Redis:get(TheMero.."boob"..bobpkh) or 0
local convert_mony = string.format("%.0f",ballancee)
local dfhb = Redis:get(TheMero.."boballbalc"..coniss)
local fsvhh = Redis:get(TheMero.."boballban"..coniss)
shkse = Redis:get(TheMero.."shkse"..coniss)
doltebank = Redis:get(TheMero.."doltebank"..coniss)
if shkse == "طيبة" then
shkseemg = "طيبة 😇"
else
shkseemg = "شريرة 😈"
end
send(msg.chat_id,msg.id, "⇜ الاسم ↤ "..yty.."\n⇜ الحساب ↤ `"..coniss.."`\n⇜ بنك ↤ ❲ روبي ❳\n⇜ نوع ↤ ❲ "..fsvhh.." ❳\n⇜ الرصيد ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ شخصيتك ↤ ❲ "..shkseemg.." ❳\n⇜ دولتك ↤ ❲ "..doltebank.." ❳","md",true)
else
send(msg.chat_id,msg.id, "⇜ مافيه حساب بنكي كذا","md",true)
end
end
if text and text:match('اكشط (.*)') then

local TextAksht = text:match('اكشط (.*)')
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي ↤ "..(_bank_uid).."\n⇜ القروب ↤ "..msg.chat_id.."\n⇜ الرسالة ↤ "..text.."\n✧","md",true)
end
if not Redis:sismember(TheMero.."Akshtd:Games:",TextAksht) then
return send(msg.chat_id,msg.id,"⇜ الرمز مستخدم قبل !")
end
local list ={"100000","200000","300000","400000","500000","600000"}
local Number = tonumber(list[math.random(#list)])
Redis:srem(TheMero.."Akshtd:Games:",TextAksht)
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
cobonplus = tonumber(ballancee) + Number
Redis:set(TheMero.."boob"..(_bank_uid) , cobonplus)
local UserInfoo = bot.getUser((_bank_uid))
local GetName = '- ['..UserInfoo.first_name..'](tg://user?id='..(_bank_uid)..')'
return send(msg.chat_id,msg.id,GetName.."\n\n⇜ مبروك كشطتها واخذت ↤ "..Number.. " ريال 💵\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ","md",true)
end
end
if text == "قائمه اكشطها" then
if not msg.ControllerBot then
return send(msg.chat_id,msg.id,'\n• عذراً الامر يخص ↤︎ 〖 '..DevLink..' 〗 فقط .',"md",true)  
end
local Text = Redis:smembers(TheMero.."Akshtd:Games:") 
if #Text == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد رموز اكشطها","md",true)  
end
local Texter = "\n⇜ قائمة اكشطها : \n\n"
for k, v in pairs(Text) do
Texter = Texter..""..k.."- `"..v.."`\n"
end
return send(msg.chat_id,msg.id,Texter,"md")
end
if text == "صنع اكشطها" then
if not msg.ControllerBot then
return send(msg.chat_id,msg.id,'\n• عذراً الامر يخص ↤︎ 〖 '..DevLink..' 〗 فقط .',"md",true)  
end
Redis:del(TheMero.."Akshtd:Games:")
local list ={"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"}
local En = list[math.random(#list)]
local En1 = list[math.random(#list)]
local En2 = list[math.random(#list)]
local En3 = list[math.random(#list)]
local En4 = list[math.random(#list)]
local En5 = list[math.random(#list)]
local En6 = list[math.random(#list)]
local En7 = list[math.random(#list)]
local En8 = list[math.random(#list)]
local En9 = list[math.random(#list)]
local Num = En..En1..En2..En3..En4..En5..En6..En7..En8..En9
local Num1 = En..En1..En9..En8..En6..En7..En5..En4..En3..En2
local Num2 = En1..En2..En3..En4..En5..En6..En7..En8..En9..En
local Num3 = En9..En2..En..En4..En6..En5..En8..En3..En1..En7
local Num4 = En6..En7..En8..En9..En..En1..En2..En3..En4..En5
local Num5 = En5..En4..En3..En2..En1..En..En9..En8..En7..En6
local Num6 = En6..En7..En3..En2..En1..En5..En4..En..En9..En8
local Num7 = En1..En..En2..En7..En4..En3..En6..En5..En9..En8
local Num8 = En2..En4..En5..En6..En4..En8..En3..En7..En..En9
local Num9 = En1..En..En3..En5..En7..En9..En2..En4..En6..En8
Redis:sadd(TheMero.."Akshtd:Games:",Num)
Redis:sadd(TheMero.."Akshtd:Games:",Num1)
Redis:sadd(TheMero.."Akshtd:Games:",Num2)
Redis:sadd(TheMero.."Akshtd:Games:",Num3)
Redis:sadd(TheMero.."Akshtd:Games:",Num4)
Redis:sadd(TheMero.."Akshtd:Games:",Num5)
Redis:sadd(TheMero.."Akshtd:Games:",Num6)
Redis:sadd(TheMero.."Akshtd:Games:",Num7)
Redis:sadd(TheMero.."Akshtd:Games:",Num8)
Redis:sadd(TheMero.."Akshtd:Games:",Num9)
return send(msg.chat_id,msg.id,[[
⇜ تم صنع قائمة اكشط جديدة :

1 ↦ `]]..Num..[[`

2 ↦ `]]..Num1..[[`

3 ↦ `]]..Num2..[[`

4 ↦ `]]..Num3..[[`

5 ↦ `]]..Num4..[[`

6 ↦ `]]..Num5..[[`

7 ↦ `]]..Num6..[[`

8 ↦ `]]..Num7..[[`

9 ↦ `]]..Num8..[[`

10 ↦ `]]..Num9..[[`
]],"md")
end
if text == 'مضاربه' then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:ttl(TheMero.."iiooooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iiooooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تضارب الحين\n⇜ تعال بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `مضاربه` المبلغ","md",true)
end
if text and text:match('^مضاربه (.*)$') or text and text:match('^مضاربة (.*)$') then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local UserName = text:match('^مضاربه (.*)$') or text:match('^مضاربة (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي ↤ "..(_bank_uid).."\n⇜ القروب ↤ "..msg.chat_id.."\n⇜ الرسالة ↤ "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iiooooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iiooooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تضارب الحين\n⇜ تعال بعد "..time.." ","md",true)
end
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) < 99 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 ريال 💵\n✧","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
local modarba = {"1", "2", "3", "4"}
local Descriptioontt = modarba[math.random(#modarba)]
local modarbaa = math.random(1,90);
if Descriptioontt == "1" or Descriptioontt == "3" then
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee - ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ballanceekkku))
Redis:setex(TheMero.."iiooooo" .. (_bank_uid),900, true)
send(msg.chat_id,msg.id, "⇜ مضاربة فاشلة 📉\n⇜ نسبة الخسارة ↤ "..modarbaa.."%\n⇜ المبلغ الذي خسرته ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ فلوسك صارت ↤ ❲ "..convert_mony1.." ريال 💵 ❳\n✧","md",true)
else
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee + ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ballanceekkku))
Redis:setex(TheMero.."iiooooo" .. (_bank_uid),900, true)
send(msg.chat_id,msg.id, "⇜ مضاربة ناجحة 📈\n⇜ نسبة الربح ↤ "..modarbaa.."%\n⇜ المبلغ الذي ربحته ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ فلوسك صارت ↤ ❲ "..convert_mony1.." ريال 💵 ❳\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'استثمار' then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:ttl(TheMero.."iioooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تستثمر الحين\n⇜ تعال بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `استثمار` المبلغ","md",true)
end
if text and text:match('^استثمار (.*)$') then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local UserName = text:match('^استثمار (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iioooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تستثمر الحين\n⇜ تعال بعد "..time.." ","md",true)
end
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) < 99 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 ريال 💵\n✧","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
local hadddd = math.random(1,9);
ballanceekk = coniss / 100 * hadddd
ballanceekkk = ballancee + ballanceekk
local convert_mony = string.format("%.0f",ballanceekk)
local convert_mony1 = string.format("%.0f",ballanceekkk)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ballanceekkk))
Redis:setex(TheMero.."iioooo" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⇜ استثمار ناجح 💰\n⇜ نسبة الربح ↤ "..hadddd.."%\n⇜ مبلغ الربح ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ فلوسك صارت ↤ ❲ "..convert_mony1.." ريال 💵 ❳\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'سحب' then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:ttl(TheMero.."iioood" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioood" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تلعب سحب الحين\n⇜ تعال بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `سحب` المبلغ","md",true)
end
if text == 'حظ' then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:ttl(TheMero.."iiooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iiooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تلعب حظ الحين\n⇜ تعال بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `حظ` المبلغ","md",true)
end
if text and text:match('^حظ (.*)$') then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local UserName = text:match('^حظ (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iiooo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iiooo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تلعب حظ الحين\n⇜ تعال بعد "..time.." ","md",true)
end
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) < 99 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 ريال 💵\n✧","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
nsbhad = Redis:get(TheMero.."nsbhad"..1) or 50
if tonumber(nsbhad) == 0 then
daddd = {"2"}
elseif tonumber(nsbhad) == 50 then
daddd = {"1", "2"}
elseif tonumber(nsbhad) == 75 then
daddd = {"1", "2", "1"}
else
daddd = {"1", "1"}
end
haddd = daddd[math.random(#daddd)]
if haddd == "1" then
local new_bal = Redis:incrby(TheMero.."boob"..(_bank_uid), math.floor(coniss))
local convert_mony  = string.format("%.0f", tonumber(new_bal) - tonumber(coniss))
local convert_mony1 = string.format("%.0f", tonumber(new_bal))
Redis:setex(TheMero.."iiooo" .. (_bank_uid),900, true)
send(msg.chat_id,msg.id, "⇜ مبروك فزت بالحظ 🎉\n⇜ فلوسك قبل ↤ ❲ "..convert_mony.." ريال 💵 ❳\n⇜ رصيدك الان ↤ ❲ `"..convert_mony1.."` ريال 💵 ❳\n✧","md",true)
else
local new_bal = Redis:decrby(TheMero.."boob"..(_bank_uid), math.floor(coniss))
if tonumber(new_bal) < 0 then
  Redis:set(TheMero.."boob"..(_bank_uid), 0)
  new_bal = 0
end
local convert_mony  = string.format("%.0f", tonumber(new_bal) + tonumber(coniss))
local convert_mony1 = string.format("%.0f", tonumber(new_bal))
Redis:setex(TheMero.."iiooo" .. (_bank_uid),900, true)
send(msg.chat_id,msg.id, "⇜ للاسف خسرت بالحظ 😬\n⇜ فلوسك قبل ↤ ❲ "..convert_mony.." درهم 💵 ❳\n⇜ رصيدك الان ↤ ❲ `"..convert_mony1.."` درهم 💵 ❳\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'تحويل' then
if Redis:ttl(TheMero.."tanstime" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."tanstime" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تحول فلوس الحين\n⇜ تعال بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `تحويل` المبلغ","md",true)
end
if text and text:match('^تحويل (.*)$') then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local UserName = text:match('^تحويل (.*)$')
local coniss = coin(UserName)
if not Redis:sismember(TheMero.."booob",(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ","md",true)
end
if Redis:ttl(TheMero.."tanstime" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."tanstime" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تحول فلوس الحين\n⇜ تعال بعد "..time.." ","md",true)
end
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) < 100 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 100 درهم \n✧","md",true)
end
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballancee) < 100 then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
if tonumber(coniss) > tonumber(ballancee) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي\n✧","md",true)
end
Redis:set(TheMero.."transn"..(_bank_uid),coniss)
Redis:setex(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid),60, true)
send(msg.chat_id,msg.id,[[
⇜ ارسل الحين رقم الحساب البنكي الي تبي تحول له

– معاك دقيقة وحدة والغي طلب التحويل .
✧
]],"md",true)  
return false
end
if Redis:get(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid)) then
cccc = Redis:get(TheMero.."boobb"..(_bank_uid))
uuuu = Redis:get(TheMero.."bbobb"..(_bank_uid))
if text ~= text:match('^(%d+)$') then
Redis:del(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid)) 
Redis:del(TheMero.."transn" .. (_bank_uid))
return send(msg.chat_id,msg.id,"⇜ ارسل رقم حساب بنكي ","md",true)
end
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي ↤ "..(_bank_uid).."\n⇜ القروب ↤ "..msg.chat_id.."\n⇜ الرسالة ↤ "..text.."\n✧","md",true)
end
if text == cccc then
Redis:del(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid)) 
Redis:del(TheMero.."transn" .. (_bank_uid))
return send(msg.chat_id,msg.id,"⇜ مايمديك تحول لنفسك ","md",true)
end
if Redis:get(TheMero.."boballcc"..text) then
local UserNamey = Redis:get(TheMero.."transn"..(_bank_uid))
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
local fsvhhh = Redis:get(TheMero.."boballid"..text)
local bann = bot.getUser(fsvhhh)
if bann.first_name then
newss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
newss = " لا يوجد اسم"
end
local fsvhh = Redis:get(TheMero.."boballban"..text)
UserNameyr = UserNamey / 10
UserNameyy = UserNamey - UserNameyr
local convert_mony = string.format("%.0f",UserNameyy)
local lockKey = TheMero.."lock:trans:"..(_bank_uid)
if Redis:set(lockKey, 1, "NX", "EX", 5) == nil then
  return send(msg.chat_id,msg.id, "⇜ عملية تحويل جارية، انتظر لحظة","md",true)
end
local new_sender = Redis:decrby(TheMero.."boob"..(_bank_uid), math.floor(UserNamey))
if tonumber(new_sender) < 0 then
  Redis:incrby(TheMero.."boob"..(_bank_uid), math.floor(UserNamey))
  Redis:del(lockKey)
  Redis:del(TheMero.."trans"..msg.chat_id..":"..(_bank_uid))
  Redis:del(TheMero.."transn"..(_bank_uid))
  return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي\n✧","md",true)
end
Redis:incrby(TheMero.."boob"..fsvhhh, math.floor(UserNameyy))
Redis:del(lockKey)
Redis:setex(TheMero.."tanstime" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ حوالة صادرة من بنك روبي\n\n⇜ المرسل ↤ "..news.."\n⇜ الحساب رقم ↤ `"..cccc.."`\n⇜ نوع البطاقة ↤ "..uuuu.."\n⇜ المستلم ↤ "..newss.."\n⇜ الحساب رقم ↤ `"..text.."`\n⇜ نوع البطاقة ↤ "..fsvhh.."\n⇜ خصمت 10% رسوم تحويل\n⇜ المبلغ ↤ "..convert_mony.." ريال 💵","md",true)
send(fsvhhh,0, "⌯ حوالة واردة من بنك روبي\n\n⇜ المرسل ↤ "..news.."\n⇜ الحساب رقم ↤ `"..cccc.."`\n⇜ نوع البطاقة ↤ "..uuuu.."\n⇜ المبلغ ↤ "..convert_mony.." ريال 💵","md",true)
Redis:del(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid)) 
Redis:del(TheMero.."transn" .. (_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ مافيه حساب بنكي كذا","md",true)
Redis:del(TheMero.."trans" .. msg.chat_id .. ":" .. (_bank_uid)) 
Redis:del(TheMero.."transn" .. (_bank_uid))
end
end
if text == "ترتيبي" then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
local bank_users = Redis:smembers(TheMero.."booob")
my_num_in_bank = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."boob"..v)
table.insert(my_num_in_bank, {math.floor(tonumber(mony)) , v})
end
table.sort(my_num_in_bank, function(a, b) return a[1] > b[1] end)
for k,v in pairs(my_num_in_bank) do
if tonumber(v[2]) == tonumber((_bank_uid)) then
local mony = v[1]
return send(msg.chat_id,msg.id,"⇜ ترتيبك ( "..k.." )","md",true)
end
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "ترتيبه" and tonumber(msg.reply_to_message_id) ~= 0 then

local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك ","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local bank_users = Redis:smembers(TheMero.."booob")
my_num_in_bank = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."boob"..v)
table.insert(my_num_in_bank, {math.floor(tonumber(mony)) , v})
end
table.sort(my_num_in_bank, function(a, b) return a[1] > b[1] end)
for k,v in pairs(my_num_in_bank) do
if tonumber(v[2]) == tonumber(Re(_bank_uid)) then
local mony = v[1]
return send(msg.chat_id,msg.id,"⇜ ترتيبه ( "..k.." )","md",true)
end
end
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي","md",true)
end
end
if text == "توب" or text == "التوب" then
if Redis:ttl(TheMero.."deletbank" .. 111) >= 1036800 then
day = "13 يوم"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 950400 then
day = "12 يوم"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 864000 then
day = "11 يوم"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 777600 then
day = "10 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 691200 then
day = "9 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 604800 then
day = "8 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 518400 then
day = "7 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 432000 then
day = "6 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 345600 then
day = "5 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 259200 then
day = "4 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 172800 then
day = "3 ايام"
elseif Redis:ttl(TheMero.."deletbank" .. 111) >= 86400 then
day = "يومان"
elseif Redis:ttl(TheMero.."deletbank" .. 111) <= 86400 then
day = "يوم واحد"
else
day = " لم يحدد الوقت "
end
local toptop = "⇜ أهلين يا روح روبي هذي أوامري :\n⇜ اختر نوع التوب من الازرار\n\n⇜ تتصفر اللعبة بعد ↤ "..day.."\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'توب الفلوس', data = (_bank_uid)..'/topmon'}, {text = 'توب الحراميه', data = (_bank_uid)..'/topzrf'},
},
{
{text = 'توب المتزوجين', data = (_bank_uid)..'/zoztee'}, {text = 'توب المتبرعين', data = (_bank_uid)..'/motbra'},
},
{
{text = 'توب النوادي', data = (_bank_uid)..'/topnade'},{text = 'توب المزارع', data = (_bank_uid)..'/mazratee'},
},
{
{text = 'اخفاء', data = (_bank_uid)..'/delAmr'}, 
},
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,toptop,"md",false, false, false, false, reply_markup)
end
if text == "توب الفلوس" or text == "توب فلوس" then
local ban = bot.getUser((_bank_uid))
local my_name = (ban and ban.first_name) or "لا يوجد اسم"
ballancee = tonumber(Redis:get(TheMero.."boob"..(_bank_uid))) or 0
local bank_users = Redis:smembers(TheMero.."booob")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
local mony_list = {}
for k,v in pairs(bank_users) do
local mony = tonumber(Redis:get(TheMero.."boob"..v)) or 0
table.insert(mony_list, {mony, v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
local emoji30 = {
"🥇 )","🥈 )","🥉 )",
"4 )","5 )","6 )","7 )","8 )","9 )","10 )",
"11 )","12 )","13 )","14 )","15 )","16 )","17 )","18 )","19 )","20 )",
"21 )","22 )","23 )","24 )","25 )","26 )","27 )","28 )","29 )","30 )"
}
local function strip_flags(s)
s = s:gsub("🇾🇪️",''):gsub("🇹🇳",''):gsub("🇸🇾",''):gsub("🇸🇩",''):gsub("🇸🇦",'')
s = s:gsub("🇶🇦",''):gsub("🇵🇸",''):gsub("🇴🇲",''):gsub("🇲🇦",''):gsub("🇱🇾",'')
s = s:gsub("🇱🇧",''):gsub("🇰🇼️",''):gsub("🇯🇴",''):gsub("🇮🇶",''):gsub("🇪🇬",'')
s = s:gsub("🇧🇭",''):gsub("🇩🇿️",''):gsub("🇦🇪",'')
s = s:gsub("@[%a%d_]+",""):gsub("#[%a%d_]+","")
return s
end
local top_mony = "توب اغنى 30 شخص :\n\n"
for i, v in ipairs(mony_list) do
if i > 30 then break end
local _gu = bot.getUser(v[2]) or {}
local user_name = strip_flags(_gu.first_name or "لا يوجد اسم")
local gflos = string.format("%.0f", v[1]):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
local emo = emoji30[i] or (i.." )")
top_mony = top_mony..emo.." "..gflos.." 💰 l "..user_name.."  \n"
end
local gflous = string.format("%.0f", ballancee):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
local gg = " ━━━━━━━━━\n• you)  "..gflous.." 💰 l "..my_name.."  \n\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
local reply_markup = bot.replyMarkup{type='inline',data={{{text='روبـي 🪄',url="t.me/FvvZv"}}}}
return send(msg.chat_id,msg.id,top_mony..gg,"md",false,false,false,false,reply_markup)
end
if text == "توب القروب" or text == "توب فلوس القروب" or text == "توب الجروب" then
if not Redis:get(TheMero.."booob") then
return send(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
local group_members = bot.getSupergroupMembers(msg.chat_id,"*","*",0,200)
if not group_members or not group_members.members or #group_members.members == 0 then
return send(msg.chat_id,msg.id,"⇜ لا استطيع جلب الاعضاء","md",true)
end
local group_top = {}
for _,v in ipairs(group_members.members) do
local uid = v.member_id and v.member_id.user_id
if uid and Redis:sismember(TheMero.."booob", uid) then
local bal = tonumber(Redis:get(TheMero.."boob"..uid)) or 0
if bal > 0 then table.insert(group_top, {bal, uid}) end
end
end
if #group_top == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد لاعبين في القروب لديهم رصيد","md",true)
end
table.sort(group_top, function(a,b) return a[1] > b[1] end)
local g_emoji = {"🥇","🥈","🥉","4)","5)","6)","7)","8)","9)","10)"}
local g_txt = "⇜ توب أغنى 10 في القروب :\n\n"
for i,v in ipairs(group_top) do
if i > 10 then break end
local uname = (bot.getUser(v[2]) and bot.getUser(v[2]).first_name) or "مجهول"
local gf = string.format("%.0f",v[1]):reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
g_txt = g_txt..(g_emoji[i] or i..")").. " "..gf.." 💵  "..uname.."\n"
end
local g_markup = bot.replyMarkup{type='inline',data={{{text='اخفاء',data=(_bank_uid)..'/delAmr'},},}}
return send(msg.chat_id,msg.id,g_txt,"md",false,false,false,false,g_markup)
end
if text == "توب الحراميه" or text == "توب الحرامية" or text == "توب حراميه" or text == "توب الزرف" or text == "توب زرف" then

local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
news = news:gsub("🇾🇪️",'')
news = news:gsub("🇹🇳",'')
news = news:gsub("🇸🇾",'')
news = news:gsub("🇸🇩",'')
news = news:gsub("🇸🇦",'')
news = news:gsub("🇶🇦",'')
news = news:gsub("🇵🇸",'')
news = news:gsub("🇴🇲",'')
news = news:gsub("🇲🇦",'')
news = news:gsub("🇱🇾",'')
news = news:gsub("🇱🇧",'')
news = news:gsub("🇰🇼️",'')
news = news:gsub("🇯🇴",'')
news = news:gsub("🇮🇶",'')
news = news:gsub("🇪🇬",'')
news = news:gsub("🇧🇭",'')
news = news:gsub("🇩🇿️",'')
news = news:gsub("🇦🇪",'')
else
news = " لا يوجد اسم"
end
zrfee = Redis:get(TheMero.."rrfff"..(_bank_uid)) or 0
local ty_users = Redis:smembers(TheMero.."rrfffid")
if #ty_users == 0 then
return send(chat_id,msg_id,"⇜ لا يوجد احد","md",true)
end
ty_anubis = "⇜ توب 20 شخص زرفوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = Redis:get(TheMero.."rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
tt = tt:gsub("🇾🇪️",'')
tt = tt:gsub("🇹🇳",'')
tt = tt:gsub("🇸🇾",'')
tt = tt:gsub("🇸🇩",'')
tt = tt:gsub("🇸🇦",'')
tt = tt:gsub("🇶🇦",'')
tt = tt:gsub("🇵🇸",'')
tt = tt:gsub("🇴🇲",'')
tt = tt:gsub("🇲🇦",'')
tt = tt:gsub("🇱🇾",'')
tt = tt:gsub("🇱🇧",'')
tt = tt:gsub("🇰🇼️",'')
tt = tt:gsub("🇯🇴",'')
tt = tt:gsub("🇮🇶",'')
tt = tt:gsub("🇪🇬",'')
tt = tt:gsub("🇧🇭",'')
tt = tt:gsub("🇩🇿️",'')
tt = tt:gsub("🇦🇪",'')
tt = tt:gsub("@[%a%d_]+",'')
tt = tt:gsub("#[%a%d_]+",'')
local doltebank = Redis:get(TheMero.."doltebank"..v[2]) or " "
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
ty_anubis = ty_anubis..emoo.." "..gflos.." 💵 l "..tt.." "..doltebank.." \n"
gflous = string.format("%.0f", zrfee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ━━━━━━━━━\n• you) "..gflous.." 💵 l "..news.." \n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,ty_anubis..gg,"md",false, false, false, false, reply_markup)
end
if text == 'رشوة' or text == 'رشوه' or text == 'رشوى' or text == 'رشوا' then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iioo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ من شوي اخذت رشوة استنى "..time.." ","md",true)
end
if Redis:ttl(TheMero.."polrsho" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."polrsho" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ انتا بالسجن 🏤\n⇜ استنى "..time.." \n✧","md",true)
end
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "طيبة" then
return send(msg.chat_id,msg.id, "⇜ شخصيتك طيبة مايمديك تاخذ رشوة","md",true)
end
local daddd = {"1", "2", "3", "4",}
local haddd = daddd[math.random(#daddd)]
if haddd == "1" or haddd == "2" or haddd == "3" then
local jjjo = math.random(200,4000);
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
bakigcj = ballanceed + jjjo
Redis:set(TheMero.."boob"..(_bank_uid) , bakigcj)
send(msg.chat_id,msg.id,"⇜ هذه رشوة بطل زرف "..jjjo.." درهم 💵","md",true)
Redis:setex(TheMero.."iioo" .. (_bank_uid),600, true)
else
Redis:setex(TheMero.."polrsho" .. (_bank_uid),300, true)
send(msg.chat_id,msg.id, "⇜ مسكتك الشرطة وانتا ترتشي 🚔\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'بخشيش' or text == 'بقشيش' then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iioo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ من شوي اخذت بخشيش استنى "..time.." ","md",true)
end
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "شريرة" then
return send(msg.chat_id,msg.id, "⇜ شخصيتك شريرة مايمديك تاخذ بخشيش","md",true)
end
local jjjo = math.random(200,4000);
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
bakigcj = ballanceed + jjjo
Redis:set(TheMero.."boob"..(_bank_uid) , bakigcj)
send(msg.chat_id,msg.id,"⇜ تكرم وهي بخشيش "..jjjo.." درهم 💵","md",true)
Redis:setex(TheMero.."iioo" .. (_bank_uid),600, true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زرف' or text == 'زرفو' or text == 'زرفه' and tonumber(msg.reply_to_message_id) ~= 0 then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "طيبة" then
return send(msg.chat_id,msg.id, "⇜ شخصيتك طيبة مايمديك تزرف العالم","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك 🤣","md",true)
return false
end
if Re(_bank_uid) == (_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ بدك تزرف نفسك 🤡","md",true)  
return false
end
if Redis:ttl(TheMero.."polic" .. (_bank_uid)) >=60 then
local hours = Redis:ttl(TheMero.."polic" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id,"⇜ انتا بالسجن 🏤 استنى "..math.floor(hours).." دقائق\n✧","md",true)
end
if Redis:ttl(TheMero.."hrame" .. Re(_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."hrame" .. Re(_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ ذا المسكين مزروف قبل شوي\n⇜ يمديك تزرفه بعد "..time.." ","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
if tonumber(ballanceed) < 199 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تزرفه فلوسه اقل من 200 درهم 💵","md",true)
end
shkseto = Redis:get(TheMero.."shkse"..Re(_bank_uid))
if shkseto == "طيبة" then
local hrame = math.floor(math.random() * 200) + 1;
local ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
zrfne = ballanceed - hrame
zrfnee = ballancope + hrame
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zrfnee))
Redis:set(TheMero.."boob"..Re(_bank_uid) , math.floor(zrfne))
Redis:setex(TheMero.."hrame" .. Re(_bank_uid),600, true)
local zoropeo = Redis:get(TheMero.."rrfff"..(_bank_uid)) or 0
zoroprod = zoropeo + hrame
Redis:set(TheMero.."rrfff"..(_bank_uid),zoroprod)
Redis:sadd(TheMero.."rrfffid",(_bank_uid))
local ban = bot.getUser(Re(_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
Redis:set(TheMero.."msrokid"..msg.chat_id..Re(_bank_uid),Re(_bank_uid))
Redis:set(TheMero.."hrameid"..msg.chat_id..Re(_bank_uid),(_bank_uid))
Redis:set(TheMero.."balcmsrok"..msg.chat_id..Re(_bank_uid),hrame)
Redis:setex(TheMero.."timehrame"..msg.chat_id..(_bank_uid),30, true)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
send(msg.chat_id,0, "⇜ "..news.." في حرامي زرفك "..hrame.." درهم 💵\n⇜ رد عليه بكلمة ( شرطه )\n⇜ معك 30 ثانية\n✧","md",true)
else
local hrame = math.floor(math.random() * 200) + 1;
local ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
zrfne = ballanceed - hrame
zrfnee = ballancope + hrame
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zrfnee))
Redis:set(TheMero.."boob"..Re(_bank_uid) , math.floor(zrfne))
Redis:setex(TheMero.."hrame" .. Re(_bank_uid),600, true)
local zoropeo = Redis:get(TheMero.."rrfff"..(_bank_uid)) or 0
zoroprod = zoropeo + hrame
Redis:set(TheMero.."rrfff"..(_bank_uid),zoroprod)
Redis:sadd(TheMero.."rrfffid",(_bank_uid))
send(msg.chat_id,msg.id, "⇜ خذ يالحرامي زرفته "..hrame.." درهم 💵\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'شرطه' or text == 'الشرطه' or text == 'شرطة' and tonumber(msg.reply_to_message_id) ~= 0 then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك 🤣","md",true)
return false
end
local hrameid = Redis:get(TheMero.."hrameid"..msg.chat_id..(_bank_uid))
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "شريرة" then
return send(msg.chat_id,msg.id, "⇜ شخصيتك شريرة مايمديك تطلب الشرطة","md",true)
end
if Redis:get(TheMero.."timehrame"..msg.chat_id.. hrameid) then
local hours = Redis:ttl(TheMero.."timehrame" .. hrameid)
local msrokid = Redis:get(TheMero.."msrokid"..msg.chat_id..(_bank_uid))
local hrameid = Redis:get(TheMero.."hrameid"..msg.chat_id..(_bank_uid))
local balcmsrok = Redis:get(TheMero.."balcmsrok"..msg.chat_id..(_bank_uid)) or 0
if tonumber(hrameid) == Re(_bank_uid) and tonumber(msrokid) == (_bank_uid) then
local ballancehrame = Redis:get(TheMero.."boob"..hrameid) or 0
local ballancmsrok = Redis:get(TheMero.."boob"..msrokid) or 0
ballancehramenow = tonumber(ballancehrame) - tonumber(balcmsrok)
ballancmsroknow = tonumber(ballancmsrok) + tonumber(balcmsrok)
Redis:set(TheMero.."boob"..hrameid , ballancehramenow)
Redis:set(TheMero.."boob"..msrokid , ballancmsroknow)
local ban = bot.getUser(hrameid)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
Redis:setex(TheMero.."polic" .. hrameid,600, true)
Redis:del(TheMero.."msrokid" ..msg.chat_id..(_bank_uid)) 
Redis:del(TheMero.."hrameid" ..msg.chat_id..(_bank_uid)) 
Redis:del(TheMero.."balcmsrok" ..msg.chat_id..(_bank_uid)) 
Redis:del(TheMero.."timehrame" ..msg.chat_id..(_bank_uid))
send(msg.chat_id,msg.id,"⇜ كفو مسكته الشرطة 👨‍✈️\n⇜ الحرامي : "..news.."\n⇜ تم اعادة فلوسك : "..tonumber(balcmsrok).." درهم 💵\n⇜ سيتم سجن الحرامي\n✧","md",true)
else
send(msg.chat_id,msg.id,"⇜ تم التحقيق معه وتبين مو هو الحرامي\n⇜ باقي معك "..math.floor(hours).." ثانية\n✧","md",true)
end
else
send(msg.chat_id,msg.id,"⇜ انتهى الوقت والحرامي هرب\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match("^شرطه @(%S+)$") or text and text:match("^شرطة @(%S+)$") then

local UserName = text:match("^شرطه @(%S+)$") or text:match("^شرطة @(%S+)$")
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return send(msg.chat_id,msg.id,"\n⇜ مافيه حساب كذا ","md",true)
end
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return send(msg.chat_id,msg.id,"\n⇜ هذا بوت 🤡 ","md",true)  
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local hrameid = Redis:get(TheMero.."hrameid"..msg.chat_id..(_bank_uid))
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "شريرة" then
return send(msg.chat_id,msg.id, "⇜ شخصيتك شريرة مايمديك تطلب الشرطة","md",true)
end
if Redis:get(TheMero.."timehrame"..msg.chat_id.. hrameid) then
local hours = Redis:ttl(TheMero.."timehrame" .. hrameid)
local msrokid = Redis:get(TheMero.."msrokid"..msg.chat_id..(_bank_uid))
local hrameid = Redis:get(TheMero.."hrameid"..msg.chat_id..(_bank_uid))
local balcmsrok = Redis:get(TheMero.."balcmsrok"..msg.chat_id..(_bank_uid)) or 0
if tonumber(hrameid) == UserId_Info.id and tonumber(msrokid) == (_bank_uid) then
local ballancehrame = Redis:get(TheMero.."boob"..hrameid) or 0
local ballancmsrok = Redis:get(TheMero.."boob"..msrokid) or 0
ballancehramenow = tonumber(ballancehrame) - tonumber(balcmsrok)
ballancmsroknow = tonumber(ballancmsrok) + tonumber(balcmsrok)
Redis:set(TheMero.."boob"..hrameid , ballancehramenow)
Redis:set(TheMero.."boob"..msrokid , ballancmsroknow)
local ban = bot.getUser(hrameid)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
Redis:setex(TheMero.."polic" .. hrameid,600, true)
Redis:del(TheMero.."msrokid" ..msg.chat_id..(_bank_uid)) 
Redis:del(TheMero.."hrameid" ..msg.chat_id..(_bank_uid)) 
Redis:del(TheMero.."balcmsrok" ..msg.chat_id..(_bank_uid))
Redis:del(TheMero.."timehrame" ..msg.chat_id..(_bank_uid))
send(msg.chat_id,msg.id,"⇜ كفو مسكته الشرطة 👨‍✈️\n⇜ الحرامي : "..news.."\n⇜ تم اعادة فلوسك : "..tonumber(balcmsrok).." درهم 💵\n⇜ سيتم سجن الحرامي\n✧","md",true)
else
send(msg.chat_id,msg.id,"⇜ تم التحقيق معه وتبين مو هو الحرامي\n⇜ باقي معك "..math.floor(hours).." ثانية\n✧","md",true)
end
else
send(msg.chat_id,msg.id,"⇜ انتهى الوقت والحرامي هرب\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'راتب' or text == 'راتبي' then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iiioo" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iiioo" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ راتبك بينزل بعد "..time.." ","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد اسم"
end
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid)) or 1
ratbtrans = Redis:get(TheMero.."ratbtrans"..(_bank_uid)) or 1
if shkse == "طيبة" then
if tonumber(ratbinc) >= 270 and tonumber(ratbtrans) == 10 then
local ratpep = ballancee + 500000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 300 or tonumber(ratbinc) == 301 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500000 درهم 💵\n⇜ وظيفتك : ملك 👑\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : `"..convert_mony.."` درهم 💵\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),300)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500000 درهم 💵\n⇜ وظيفتك : ملك 👑\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : `"..convert_mony.."` درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 240 and tonumber(ratbtrans) == 9 then
local ratpep = ballancee + 200000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid)) or 0
if tonumber(ratbinc) == 270 or tonumber(ratbinc) == 271 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 200000 درهم 💵\n⇜ وظيفتك : امير 🤵‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),270)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 200000 درهم 💵\n⇜ وظيفتك : امير 🤵‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 210 and tonumber(ratbtrans) == 8 then
local ratpep = ballancee + 100000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 240 or tonumber(ratbinc) == 241 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 100000 درهم 💵\n⇜ وظيفتك : وزير 🤵‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),240)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 100000 درهم 💵\n⇜ وظيفتك : وزير 🤵‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 180 and tonumber(ratbtrans) == 7 then
local ratpep = ballancee + 70000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 210 or tonumber(ratbinc) == 211 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 70000 درهم 💵\n⇜ وظيفتك : بزنس مان كبير 💸\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),210)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 70000 درهم 💵\n⇜ وظيفتك : بزنس مان كبير 💸\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 150 and tonumber(ratbtrans) == 6 then
local ratpep = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 180 or tonumber(ratbinc) == 181 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 40000 درهم 💵\n⇜ وظيفتك : تاجر صغير 💰\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),180)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 40000 درهم 💵\n⇜ وظيفتك : تاجر صغير 💰\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 120 and tonumber(ratbtrans) == 5 then
local ratpep = ballancee + 25000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 150 or tonumber(ratbinc) == 151 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 25000 درهم 💵\n⇜ وظيفتك : طيار 👨‍✈️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),150)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 25000 درهم 💵\n⇜ وظيفتك : طيار 👨‍✈️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 90 and tonumber(ratbtrans) == 4 then
local ratpep = ballancee + 18000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 120 or tonumber(ratbinc) == 121 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 18000 درهم 💵\n⇜ وظيفتك : دكتور 👨‍⚕️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),120)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 18000 درهم 💵\n⇜ وظيفتك : دكتور 👨‍⚕️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 60 and tonumber(ratbtrans) == 3 then
local ratpep = ballancee + 9000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 90 or tonumber(ratbinc) == 91 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 9000 درهم 💵\n⇜ وظيفتك : صيدلي 👨‍🔬\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),90)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 9000 درهم 💵\n⇜ وظيفتك : صيدلي 👨‍🔬\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 30 and tonumber(ratbtrans) == 2 then
local ratpep = ballancee + 2500
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 60 or tonumber(ratbinc) == 61 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 2500 درهم 💵\n⇜ وظيفتك : نجار 👨‍🔧\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),60)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 2500 درهم 💵\n⇜ وظيفتك : نجار 👨‍🔧\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 1 and tonumber(ratbtrans) == 1 then
local ratpep = ballancee + 500
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 30 or tonumber(ratbinc) == 31 then
Redis:set(TheMero.."ratbinc"..(_bank_uid),30)
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500 درهم 💵\n⇜ وظيفتك : قروي 👨‍🌾\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500 درهم 💵\n⇜ وظيفتك : قروي 👨‍🌾\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
end
else
if tonumber(ratbinc) >= 270 and tonumber(ratbtrans) == 10 then
local ratpep = ballancee + 500000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 300 or tonumber(ratbinc) == 301 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500000 درهم 💵\n⇜ وظيفتك : ال تشابو 🧛‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),300)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500000 درهم 💵\n⇜ وظيفتك : ال تشابو 🧛‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 240 and tonumber(ratbtrans) == 9 then
local ratpep = ballancee + 200000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 270 or tonumber(ratbinc) == 271 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 200000 درهم 💵\n⇜ وظيفتك : بائع ممنوعات دولي 🎩\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),270)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 200000 درهم 💵\n⇜ وظيفتك : بائع ممنوعات دولي 🎩\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 210 and tonumber(ratbtrans) == 8 then
local ratpep = ballancee + 100000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 240 or tonumber(ratbinc) == 241 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 100000 درهم 💵\n⇜ وظيفتك : تاجر ممنوعات 🧔‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),240)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 100000 درهم 💵\n⇜ وظيفتك : تاجر ممنوعات 🧔‍♂️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 180 and tonumber(ratbtrans) == 7 then
local ratpep = ballancee + 70000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 210 or tonumber(ratbinc) == 211 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 70000 درهم 💵\n⇜ وظيفتك : بق بوس العصابة 🗣\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),210)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 70000 درهم 💵\n⇜ وظيفتك : بق بوس العصابة 🗣\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 150 and tonumber(ratbtrans) == 6 then
local ratpep = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 180 or tonumber(ratbinc) == 181 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 40000 درهم 💵\n⇜ وظيفتك : مساعد رئيس العصابة 🦹‍♀️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),180)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 40000 درهم 💵\n⇜ وظيفتك : مساعد رئيس العصابة 🦹‍♀️\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 120 and tonumber(ratbtrans) == 5 then
local ratpep = ballancee + 25000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 150 or tonumber(ratbinc) == 151 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 25000 درهم 💵\n⇜ وظيفتك : عضو عصابة 🙍\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),150)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 25000 درهم 💵\n⇜ وظيفتك : عضو عصابة 🙍\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 90 and tonumber(ratbtrans) == 4 then
local ratpep = ballancee + 18000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 120 or tonumber(ratbinc) == 121 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 18000 درهم 💵\n⇜ وظيفتك : قاتل مأجور 🔫\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),120)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 18000 درهم 💵\n⇜ وظيفتك : قاتل مأجور 🔫\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 60 and tonumber(ratbtrans) == 3 then
local ratpep = ballancee + 9000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 90 or tonumber(ratbinc) == 91 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 9000 درهم 💵\n⇜ وظيفتك : قاتل 🕴\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),90)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 9000 درهم 💵\n⇜ وظيفتك : قاتل 🕴\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 30 and tonumber(ratbtrans) == 2 then
local ratpep = ballancee + 2500
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 60 or tonumber(ratbinc) == 61 then
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 2500 درهم 💵\n⇜ وظيفتك : سارق 🥷\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
Redis:set(TheMero.."ratbinc"..(_bank_uid),60)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 2500 درهم 💵\n⇜ وظيفتك : سارق 🥷\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
elseif tonumber(ratbinc) >= 0 and tonumber(ratbtrans) == 1 then
local ratpep = ballancee + 500
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ratpep))
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:setex(TheMero.."iiioo" .. (_bank_uid),600, true)
Redis:incrby(TheMero.."ratbinc"..(_bank_uid),1)
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid))
if tonumber(ratbinc) == 30 or tonumber(ratbinc) == 31 then
Redis:set(TheMero.."ratbinc"..(_bank_uid),30)
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500 درهم 💵\n⇜ وظيفتك : مشرد 👣\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n\nتستطيع الان تطوير راتبك ارسل ( `تطوير راتب` )\n✧","md",true)
else
send(msg.chat_id,msg.id,"⌯ اشعار ايداع "..neews.."\n\n⇜ المبلغ : 500 درهم 💵\n⇜ وظيفتك : مشرد 👣\n⇜ نوع العملية : اضافة راتب\n⇜ تطوير الراتب : "..tonumber(ratbinc).."\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
end
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'تطوير راتب' or text == 'تطوير الراتب' or text == 'تطوير راتبي' then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
ratbinc = Redis:get(TheMero.."ratbinc"..(_bank_uid)) or 0
ratbtrans = Redis:get(TheMero.."ratbtrans"..(_bank_uid)) or 1
if shkse == "طيبة" then
if tonumber(ratbinc) == 270 then
if tonumber(ballanceed) < 1000000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 1000000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),10)
nowbalc = tonumber(ballancee) - 1000000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 1000000000 درهم 💵\n⇜ اصبحت وظيفتك : ملك 👑\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 240 then
if tonumber(ballanceed) < 200000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 200000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),9)
nowbalc = tonumber(ballancee) - 200000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 200000000 درهم 💵\n⇜ اصبحت وظيفتك : امير 🤵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 210 then
if tonumber(ballanceed) < 30000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 30000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),8)
nowbalc = tonumber(ballancee) - 30000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 30000000 درهم 💵\n⇜ اصبحت وظيفتك : وزير 🤵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 180 then
if tonumber(ballanceed) < 1000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 1000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),7)
nowbalc = tonumber(ballancee) - 1000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 1000000 درهم 💵\n⇜ اصبحت وظيفتك : بزنس مان كبير 💸\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 150 then
if tonumber(ballanceed) < 300000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 300000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),6)
nowbalc = tonumber(ballancee) - 300000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 300000 درهم 💵\n⇜ اصبحت وظيفتك : تاجر صغير 💰\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 120 then
if tonumber(ballanceed) < 120000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 120000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),5)
nowbalc = tonumber(ballancee) - 120000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 120000 درهم 💵\n⇜ اصبحت وظيفتك : طيار 👨\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 90 then
if tonumber(ballanceed) < 80000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 80000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),4)
nowbalc = tonumber(ballancee) - 80000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 80000 درهم 💵\n⇜ اصبحت وظيفتك : دكتور 👨\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 60 then
if tonumber(ballanceed) < 30000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 30000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),3)
nowbalc = tonumber(ballancee) - 30000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 30000 درهم 💵\n⇜ اصبحت وظيفتك : صيدلي ‍👨\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 30 then
if tonumber(ballanceed) < 3000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 3000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),2)
nowbalc = tonumber(ballancee) - 3000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 3000 درهم 💵\n⇜ اصبحت وظيفتك : نجار 👨\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
else
return send(msg.chat_id,msg.id,"⇜ لا تستطيع تطوير راتبك حالياً\n✧","md",true)
end
else
if tonumber(ratbinc) == 270 then
if tonumber(ballanceed) < 1000000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 1000000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),10)
nowbalc = tonumber(ballancee) - 1000000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 1000000000 درهم 💵\n⇜ اصبحت وظيفتك : ال تشابو 🧛\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 240 then
if tonumber(ballanceed) < 200000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 200000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),9)
nowbalc = tonumber(ballancee) - 200000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 200000000 درهم 💵\n⇜ اصبحت وظيفتك : بائع ممنوعات دولي 🎩\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 210 then
if tonumber(ballanceed) < 30000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 30000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),8)
nowbalc = tonumber(ballancee) - 30000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 30000000 درهم 💵\n⇜ اصبحت وظيفتك : تاجر ممنوعات 🧔‍♂️\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 180 then
if tonumber(ballanceed) < 1000000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 1000000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),7)
nowbalc = tonumber(ballancee) - 1000000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 1000000 درهم 💵\n⇜ اصبحت وظيفتك : بق بوس العصابة 🗣\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 150 then
if tonumber(ballanceed) < 300000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 300000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),6)
nowbalc = tonumber(ballancee) - 300000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 300000 درهم 💵\n⇜ اصبحت وظيفتك : مساعد رئيس العصابة 🦹\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 120 then
if tonumber(ballanceed) < 120000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 120000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),5)
nowbalc = tonumber(ballancee) - 120000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 120000 درهم 💵\n⇜ اصبحت وظيفتك : عضو عصابة 🙍\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 90 then
if tonumber(ballanceed) < 80000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 80000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),4)
nowbalc = tonumber(ballancee) - 80000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 80000 درهم 💵\n⇜ اصبحت وظيفتك : قاتل مأجور 🔫\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 60 then
if tonumber(ballanceed) < 30000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 30000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),3)
nowbalc = tonumber(ballancee) - 30000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 30000 درهم 💵\n⇜ اصبحت وظيفتك : قاتل 🕴\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
elseif tonumber(ratbinc) == 30 then
if tonumber(ballanceed) < 3000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تطور راتبك تحتاج مبلغ 3000 درهم 💵","md",true)
end
Redis:del(TheMero.."ratbtrans"..(_bank_uid))
Redis:set(TheMero.."ratbtrans"..(_bank_uid),2)
nowbalc = tonumber(ballancee) - 3000
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(nowbalc))
local convert_mony = string.format("%.0f",nowbalc)
send(msg.chat_id,msg.id,"⌯ اشعار تطوير راتب\n\n⇜ المبلغ : 3000 درهم 💵\n⇜ اصبحت وظيفتك : سارق 🥷\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
else
return send(msg.chat_id,msg.id,"⇜ لا تستطيع تطوير راتبك حالياً\n✧","md",true)
end
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'هجوم' then

send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `هجوم` المبلغ ( بالرد )","md",true)
end
if text and text:match("^هجوم (%d+)$") and msg.reply_to_message_id == 0 then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `هجوم` المبلغ ( بالرد )","md",true)
end
if text and text:match('^هجوم (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^هجوم (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك 🤣","md",true)  
return false
end
if Re(_bank_uid) == (_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهاجم نفسك 🤡","md",true)  
return false
end
if Redis:ttl(TheMero.."attack" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."attack" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ خسرت بأخر معركة استنى "..time.." ","md",true)
end
if Redis:ttl(TheMero.."defen" .. Re(_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."defen" .. Re(_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ الخصم خسر بأخر معركة\n⇜ يمديك تهاجمه بعد "..time.." ","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
if tonumber(ballancope) < 100000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تهجم فلوسك اقل من 100000 درهم 💵","md",true)
end
if tonumber(ballanceed) < 100000 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تهجم عليه فلوسه اقل من 100000 درهم 💵","md",true)
end
if tonumber(coniss) < 9999 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 10000 درهم 💵\n✧","md",true)
end
if tonumber(ballancope) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي","md",true)
end
if tonumber(ballanceed) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسه ماتكفي","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser((_bank_uid))
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد اسم "
end
local bann = bot.getUser(Re(_bank_uid))
if bann.first_name then
neewss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
neewss = " لا يوجد اسم"
end
if Descriptioont == "1" or Descriptioont == "3" then
local ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
zrfne = ballancope - coniss
drebattack = tonumber(coniss) / 100 * 25
drebattackk = tonumber(coniss) - math.floor(drebattack)
zrfnee = ballanceed + math.floor(drebattackk)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zrfne))
Redis:set(TheMero.."boob"..Re(_bank_uid) , math.floor(zrfnee))
Redis:setex(TheMero.."attack" .. (_bank_uid),600, true)
local convert_mony = string.format("%.0f",drebattackk)
local convert_monyy = string.format("%.0f",drebattack)
send(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\n⇜ الفائز : "..neewss.."\n⇜ الخاسر : "..neews.."\n⇜ الجائزة : "..convert_mony.." درهم 💵\n⇜ الضريبة : "..convert_monyy.." درهم 💵\n✧","md",true)
elseif Descriptioont == "2" or Descriptioont == "4" or Descriptioont == "5" or  Descriptioont == "6" or Descriptioont == "8" then
local ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
begaatt = Redis:get(TheMero.."numattack"..(_bank_uid)) or 200
numattackk = tonumber(begaatt) - 1
if numattackk == 0 then
numattackk = 1
end
attack = coniss / numattackk
zrfne = ballancope + math.floor(attack)
zrfnee = ballanceed - math.floor(attack)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zrfne))
Redis:set(TheMero.."boob"..Re(_bank_uid) , math.floor(zrfnee))
Redis:setex(TheMero.."defen" .. Re(_bank_uid),1800, true)
Redis:set(TheMero.."numattack"..(_bank_uid) , math.floor(numattackk))
local convert_mony = string.format("%.0f",math.floor(attack))
send(msg.chat_id,msg.id, "⇜ لقد فزت في المعركة\n⇜ ودمرت قلعة "..neewss.." 🏰\n⇜ الفائز : "..neews.."\n⇜ الخاسر : "..neewss.."\n⇜ الجائزة : "..convert_mony.." درهم 💵\n⇜ نسبة قوة المهاجم اصبحت "..numattackk.." 🩸\n✧","md",true)
elseif Descriptioont == "7" then
local ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local ballancope = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
halfzrf = coniss / 2
zrfne = ballancope - halfzrf
zrfnee = ballanceed + halfzrf
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zrfne))
Redis:set(TheMero.."boob"..Re(_bank_uid) , math.floor(zrfnee))
Redis:setex(TheMero.."attack" .. (_bank_uid),600, true)
local convert_mony = string.format("%.0f",math.floor(halfzrf))
send(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\n⇜ ولكن استطعت اعادة نصف الموارد\n⇜ الفائز : "..neewss.."\n⇜ الخاسر : "..neews.."\n⇜ الجائزة : "..convert_mony.." درهم 💵\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "المعرض" or text == "معرض" then

Redis:setex(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid),60, true)
send(msg.chat_id,msg.id,[[
– اهلين فيك بمعرض روبي
- يتوفر لدينا حالياً :

⇠ `سيارات`  🚗
⇠ `طيارات`  ✈️
⇠ `عقارات`  🏘
⇠ `مجوهرات`  💎

- اضغط للنسخ

✧
]],"md",true)  
return false
end
if text == "سيارات" and Redis:get(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) 
send(msg.chat_id,msg.id,[[
– السيارات المتوفرة لدينا حالياً :

⇠ `فيلار` - السعر : 10000000 💵
⇠ `اكسنت` - السعر : 9000000 💵
⇠ `كامري` - السعر : 8000000 💵
⇠ `النترا` - السعر : 7000000 💵
⇠ `هايلكس` - السعر : 6000000 💵
⇠ `سوناتا` - السعر : 5000000 💵
⇠ `كورولا` - السعر : 4000000 💵

- ارسل اسم السيارة والعدد
مثال : شراء سياره فيلار 2

✧
]],"md",true)  
return false
end
if text == "طيارات" and Redis:get(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) 
send(msg.chat_id,msg.id,[[
– الطيارات المتوفرة لدينا حالياً :

⇠ `شبح` - السعر : 1000000000 💵
⇠ `سفر` - السعر : 500000000 💵
⇠ `خاصه` - السعر : 200000000 💵

- ارسل اسم الطائرة والعدد
مثال : شراء طياره سفر 2

✧
]],"md",true)  
return false
end
if text == "عقارات" and Redis:get(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) 
send(msg.chat_id,msg.id,[[
– العقارات المتوفرة لدينا حالياً :

⇠ `قصر` - السعر : 1000000 💵
⇠ `فيلا` - السعر : 500000 💵
⇠ `منزل` - السعر : 100000 💵

- ارسل اسم العقار والعدد
مثال : شراء قصر 2

✧
]],"md",true)  
return false
end
if text == "مجوهرات" and Redis:get(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."marad" .. msg.chat_id .. ":" .. (_bank_uid)) 
send(msg.chat_id,msg.id,[[
– المجوهرات المتوفرة لدينا حالياً :

⇠ `ماسه` - السعر : 1000000 💵
⇠ `قلاده` - السعر : 500000 💵
⇠ `سوار` - السعر : 200000 💵
⇠ `خاتم` - السعر : 50000 💵

- ارسل الاسم والعدد
مثال : شراء سوار 2

✧
]],"md",true)  
return false
end
if text and text:match('^شراء ماسه (.*)$') or text and text:match('^شراء ماسة (.*)$') then

local UserName = text:match('^شراء ماسه (.*)$') or text:match('^شراء ماسة (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار ماسه بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
masmgr = tonumber(coniss) * 1000000
if tonumber(ballance) < tonumber(masmgr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local mgrmasname = Redis:get(TheMero.."mgrmasname"..(_bank_uid))
local mgrmasprice = Redis:get(TheMero.."mgrmasprice"..(_bank_uid)) or 0
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
local mgrmasnow = tonumber(mgrmasnum) + tonumber(coniss)
Redis:set(TheMero.."mgrmasnum"..(_bank_uid) , mgrmasnow)
masnamed = "ماسه"
Redis:set(TheMero.."mgrmasname"..(_bank_uid) , masnamed)
Redis:set(TheMero.."mgrmasprice"..(_bank_uid) , 1000000)
totalypalice = tonumber(ballance) - tonumber(masmgr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(masmgr))
send(msg.chat_id,msg.id, "⌯ وصل شراء مجوهرات\n⇜ النوع : ماسه \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد ماساتك : `"..mgrmasnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء قلاده (.*)$') or text and text:match('^شراء قلادة (.*)$') then

local UserName = text:match('^شراء قلاده (.*)$') or text:match('^شراء قلادة (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار قلاده بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
kldmgr = tonumber(coniss) * 500000
if tonumber(ballance) < tonumber(kldmgr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local mgrkldname = Redis:get(TheMero.."mgrkldname"..(_bank_uid))
local mgrkldprice = Redis:get(TheMero.."mgrkldprice"..(_bank_uid)) or 0
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
local mgrkldnow = tonumber(mgrkldnum) + tonumber(coniss)
Redis:set(TheMero.."mgrkldnum"..(_bank_uid) , mgrkldnow)
kldnamed = "قلاده"
Redis:set(TheMero.."mgrkldname"..(_bank_uid) , kldnamed)
Redis:set(TheMero.."mgrkldprice"..(_bank_uid) , 500000)
totalypalice = tonumber(ballance) - tonumber(kldmgr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(kldmgr))
send(msg.chat_id,msg.id, "⌯ وصل شراء مجوهرات\n⇜ النوع : قلاده \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد قلاداتك : `"..mgrkldnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سوار (.*)$') then

local UserName = text:match('^شراء سوار (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سوار بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
swrmgr = tonumber(coniss) * 200000
if tonumber(ballance) < tonumber(swrmgr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local mgrswrname = Redis:get(TheMero.."mgrswrname"..(_bank_uid))
local mgrswrprice = Redis:get(TheMero.."mgrswrprice"..(_bank_uid)) or 0
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
local mgrswrnow = tonumber(mgrswrnum) + tonumber(coniss)
Redis:set(TheMero.."mgrswrnum"..(_bank_uid) , mgrswrnow)
swrnamed = "سوار"
Redis:set(TheMero.."mgrswrname"..(_bank_uid) , swrnamed)
Redis:set(TheMero.."mgrswrprice"..(_bank_uid) , 200000)
totalypalice = tonumber(ballance) - tonumber(swrmgr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(swrmgr))
send(msg.chat_id,msg.id, "⌯ وصل شراء مجوهرات\n⇜ النوع : سوار \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد اساورك : `"..mgrswrnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء خاتم (.*)$') then
local UserName = text:match('^شراء خاتم (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار خاتم بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
ktmmgr = tonumber(coniss) * 50000
if tonumber(ballance) < tonumber(ktmmgr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local mgrktmname = Redis:get(TheMero.."mgrktmname"..(_bank_uid))
local mgrktmprice = Redis:get(TheMero.."mgrktmprice"..(_bank_uid)) or 0
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
local mgrktmnow = tonumber(mgrktmnum) + tonumber(coniss)
Redis:set(TheMero.."mgrktmnum"..(_bank_uid) , mgrktmnow)
ktmnamed = "خاتم"
Redis:set(TheMero.."mgrktmname"..(_bank_uid) , ktmnamed)
Redis:set(TheMero.."mgrktmprice"..(_bank_uid) , 50000)
totalypalice = tonumber(ballance) - tonumber(ktmmgr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(ktmmgr))
send(msg.chat_id,msg.id, "⌯ وصل شراء مجوهرات\n⇜ النوع : خاتم \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد خواتمك : `"..mgrktmnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع ماسه (.*)$') then

local UserName = text:match('^بيع ماسه (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
if tonumber(mgrmasnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك ماسات ","md",true)
end
if tonumber(mgrmasnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." ماسه","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local mgrmasname = Redis:get(TheMero.."mgrmasname"..(_bank_uid))
local mgrmasprice = Redis:get(TheMero.."mgrmasprice"..(_bank_uid)) or 0
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
local mgrmasnow = tonumber(mgrmasnum) - tonumber(coniss)
Redis:set(TheMero.."mgrmasnum"..(_bank_uid) , mgrmasnow)
local Textinggt = {"900000", "1000000", "1100000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellmgr = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellmgr
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
if tonumber(mgrmasnum) == 0 then
Redis:del(TheMero.."mgrmasname"..(_bank_uid))
Redis:del(TheMero.."mgrmasnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع مجوهرات\n⇜ النوع : ماسه \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellmgr).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع قلاده (.*)$') or text and text:match('^شراء قلادة (.*)$') then

local UserName = text:match('^بيع قلاده (.*)$') or text:match('^شراء قلادة (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
if tonumber(mgrkldnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك قلادات ","md",true)
end
if tonumber(mgrkldnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." قلاده ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local mgrkldname = Redis:get(TheMero.."mgrkldname"..(_bank_uid))
local mgrkldprice = Redis:get(TheMero.."mgrkldprice"..(_bank_uid)) or 0
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
local mgrkldnow = tonumber(mgrkldnum) - tonumber(coniss)
Redis:set(TheMero.."mgrkldnum"..(_bank_uid) , mgrkldnow)
local Textinggt = {"400000", "500000", "600000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellkld = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellkld
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
if tonumber(mgrkldnum) == 0 then
Redis:del(TheMero.."mgrkldname"..(_bank_uid))
Redis:del(TheMero.."mgrkldnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع مجوهرات\n⇜ النوع : قلاده \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellkld).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سوار (.*)$') then

local UserName = text:match('^بيع سوار (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
if tonumber(mgrswrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك اساور ","md",true)
end
if tonumber(mgrswrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سوار ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local mgrswrname = Redis:get(TheMero.."mgrswrname"..(_bank_uid))
local mgrswrprice = Redis:get(TheMero.."mgrswrprice"..(_bank_uid)) or 0
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
local mgrswrnow = tonumber(mgrswrnum) - tonumber(coniss)
Redis:set(TheMero.."mgrswrnum"..(_bank_uid) , mgrswrnow)
local Textinggt = {"150000", "200000", "300000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellswr = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellswr
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
if tonumber(mgrswrnum) == 0 then
Redis:del(TheMero.."mgrswrname"..(_bank_uid))
Redis:del(TheMero.."mgrswrnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع مجوهرات\n⇜ النوع : سوار \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellswr).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع خاتم (.*)$') then

local UserName = text:match('^بيع خاتم (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
if tonumber(mgrktmnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك خواتم ","md",true)
end
if tonumber(mgrktmnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." خاتم ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local mgrktmname = Redis:get(TheMero.."mgrktmname"..(_bank_uid))
local mgrktmprice = Redis:get(TheMero.."mgrktmprice"..(_bank_uid)) or 0
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
local mgrktmnow = tonumber(mgrktmnum) - tonumber(coniss)
Redis:set(TheMero.."mgrktmnum"..(_bank_uid) , mgrktmnow)
local Textinggt = {"40000", "50000", "60000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellktm = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellktm
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
if tonumber(mgrktmnum) == 0 then
Redis:del(TheMero.."mgrktmname"..(_bank_uid))
Redis:del(TheMero.."mgrktmnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع مجوهرات\n⇜ النوع : خاتم \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellktm).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء ماسه (.*)$') or text and text:match('^اهداء ماسة (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء ماسه (.*)$') or text:match('^اهداء ماسة (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
if tonumber(mgrmasnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك ماسات ","md",true)
end
if tonumber(mgrmasnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." ماسه ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
local mgrmasnow = tonumber(mgrmasnum) - tonumber(coniss)
Redis:set(TheMero.."mgrmasnum"..(_bank_uid) , mgrmasnow)
local mgrmasnumm = Redis:get(TheMero.."mgrmasnum"..Re(_bank_uid)) or 0
local mgrmasnoww = tonumber(mgrmasnumm) + tonumber(coniss)
Redis:set(TheMero.."mgrmasnum"..Re(_bank_uid) , mgrmasnoww)
masnamed = "ماسه"
Redis:set(TheMero.."mgrmasname"..Re(_bank_uid),masnamed)
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
if tonumber(mgrmasnum) == 0 then
Redis:del(TheMero.."mgrmasname"..(_bank_uid))
Redis:del(TheMero.."mgrmasnum"..(_bank_uid))
end
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) ماسه\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء قلاده (.*)$') or text and text:match('^اهداء قلادة (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء قلاده (.*)$') or text:match('^اهداء قلادة (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
if tonumber(mgrkldnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك قلادات ","md",true)
end
if tonumber(mgrkldnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." قلاده ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
local mgrkldnow = tonumber(mgrkldnum) - tonumber(coniss)
Redis:set(TheMero.."mgrkldnum"..(_bank_uid) , mgrkldnow)
local mgrkldnumm = Redis:get(TheMero.."mgrkldnum"..Re(_bank_uid)) or 0
local mgrkldnoww = tonumber(mgrkldnumm) + tonumber(coniss)
Redis:set(TheMero.."mgrkldnum"..Re(_bank_uid) , mgrkldnoww)
kldnamed = "قلاده"
Redis:set(TheMero.."mgrkldname"..Re(_bank_uid),kldnamed)
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
if tonumber(mgrkldnum) == 0 then
Redis:del(TheMero.."mgrkldname"..(_bank_uid))
Redis:del(TheMero.."mgrkldnum"..(_bank_uid))
end
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) قلاده\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سوار (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء سوار (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
if tonumber(mgrswrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك اساور ","md",true)
end
if tonumber(mgrswrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سوار","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
local mgrswrnow = tonumber(mgrswrnum) - tonumber(coniss)
Redis:set(TheMero.."mgrswrnum"..(_bank_uid) , mgrswrnow)
local mgrswrnumm = Redis:get(TheMero.."mgrswrnum"..Re(_bank_uid)) or 0
local mgrswrnoww = tonumber(mgrswrnumm) + tonumber(coniss)
Redis:set(TheMero.."mgrswrnum"..Re(_bank_uid) , mgrswrnoww)
swrnamed = "سوار"
Redis:set(TheMero.."mgrswrname"..Re(_bank_uid),swrnamed)
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
if tonumber(mgrswrnum) == 0 then
Redis:del(TheMero.."mgrswrname"..(_bank_uid))
Redis:del(TheMero.."mgrswrnum"..(_bank_uid))
end
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سوار\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء خاتم (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء خاتم (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
if tonumber(mgrktmnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك خواتم ","md",true)
end
if tonumber(mgrktmnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." خاتم","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
local mgrktmnow = tonumber(mgrktmnum) - tonumber(coniss)
Redis:set(TheMero.."mgrktmnum"..(_bank_uid) , mgrktmnow)
local mgrktmnumm = Redis:get(TheMero.."mgrktmnum"..Re(_bank_uid)) or 0
local mgrktmnoww = tonumber(mgrktmnumm) + tonumber(coniss)
Redis:set(TheMero.."mgrktmnum"..Re(_bank_uid) , mgrktmnoww)
ktmnamed = "خاتم"
Redis:set(TheMero.."mgrktmname"..Re(_bank_uid),ktmnamed)
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
if tonumber(mgrktmnum) == 0 then
Redis:del(TheMero.."mgrktmname"..(_bank_uid))
Redis:del(TheMero.."mgrktmnum"..(_bank_uid))
end
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) خاتم\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء قصر (.*)$') then
local UserName = text:match('^شراء قصر (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار قصر بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
ksrakr = tonumber(coniss) * 1000000
if tonumber(ballance) < tonumber(ksrakr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local akrksrname = Redis:get(TheMero.."akrksrname"..(_bank_uid))
local akrksrprice = Redis:get(TheMero.."akrksrprice"..(_bank_uid)) or 0
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
local akrksrnow = tonumber(akrksrnum) + tonumber(coniss)
Redis:set(TheMero.."akrksrnum"..(_bank_uid) , akrksrnow)
ksrnamed = "قصر"
Redis:set(TheMero.."akrksrname"..(_bank_uid) , ksrnamed)
Redis:set(TheMero.."akrksrprice"..(_bank_uid) , 1000000)
totalypalice = tonumber(ballance) - tonumber(ksrakr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(ksrakr))
send(msg.chat_id,msg.id, "⌯ وصل شراء عقار\n⇜ نوع العقار : قصر \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد قصورك : `"..akrksrnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء فيلا (.*)$') then
local UserName = text:match('^شراء فيلا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار فيلا بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
felakr = tonumber(coniss) * 500000
if tonumber(ballance) < tonumber(felakr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local akrfelname = Redis:get(TheMero.."akrfelname"..(_bank_uid))
local akrfelprice = Redis:get(TheMero.."akrfelprice"..(_bank_uid)) or 0
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
local akrfelnow = tonumber(akrfelnum) + tonumber(coniss)
Redis:set(TheMero.."akrfelnum"..(_bank_uid) , akrfelnow)
felnamed = "فيلا"
Redis:set(TheMero.."akrfelname"..(_bank_uid) , felnamed)
Redis:set(TheMero.."akrfelprice"..(_bank_uid) , 500000)
totalypalice = tonumber(ballance) - tonumber(felakr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(felakr))
send(msg.chat_id,msg.id, "⌯ وصل شراء عقار\n⇜ نوع العقار : قصر \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد فيلاتك : `"..akrfelnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء منزل (.*)$') then
local UserName = text:match('^شراء منزل (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار منزل بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
mnzakr = tonumber(coniss) * 200000
if tonumber(ballance) < tonumber(mnzakr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local akrmnzname = Redis:get(TheMero.."akrmnzname"..(_bank_uid))
local akrmnzprice = Redis:get(TheMero.."akrmnzprice"..(_bank_uid)) or 0
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
local akrmnznow = tonumber(akrmnznum) + tonumber(coniss)
Redis:set(TheMero.."akrmnznum"..(_bank_uid) , akrmnznow)
mnznamed = "منزل"
Redis:set(TheMero.."akrmnzname"..(_bank_uid) , mnznamed)
Redis:set(TheMero.."akrmnzprice"..(_bank_uid) , 200000)
totalypalice = tonumber(ballance) - tonumber(mnzakr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(mnzakr))
send(msg.chat_id,msg.id, "⌯ وصل شراء عقار\n⇜ نوع العقار : منزل \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد منازلك : `"..akrmnznow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع قصر (.*)$') then
local UserName = text:match('^بيع قصر (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
if tonumber(akrksrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك قصور ","md",true)
end
if tonumber(akrksrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." قصر","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local akrksrname = Redis:get(TheMero.."akrksrname"..(_bank_uid))
local akrksrprice = Redis:get(TheMero.."akrksrprice"..(_bank_uid)) or 0
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
local akrksrnow = tonumber(akrksrnum) - tonumber(coniss)
Redis:set(TheMero.."akrksrnum"..(_bank_uid) , akrksrnow)
local Textinggt = {"900000", "1000000", "1100000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellakr = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellakr
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
if tonumber(akrksrnum) == 0 then
Redis:del(TheMero.."akrksrname"..(_bank_uid))
Redis:del(TheMero.."akrksrnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع عقار\n⇜ نوع العقار : قصر \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellakr).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع فيلا (.*)$') then
local UserName = text:match('^بيع فيلا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
if tonumber(akrfelnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك فيلات ","md",true)
end
if tonumber(akrfelnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." فيلا ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local akrfelname = Redis:get(TheMero.."akrfelname"..(_bank_uid))
local akrfelprice = Redis:get(TheMero.."akrfelprice"..(_bank_uid)) or 0
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
local akrfelnow = tonumber(akrfelnum) - tonumber(coniss)
Redis:set(TheMero.."akrfelnum"..(_bank_uid) , akrfelnow)
local Textinggt = {"400000", "500000", "600000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
felakr = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + felakr
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
if tonumber(akrfelnum) == 0 then
Redis:del(TheMero.."akrfelname"..(_bank_uid))
Redis:del(TheMero.."akrfelnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع عقار\n⇜ نوع العقار : فيلا \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(felakr).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع منزل (.*)$') then
local UserName = text:match('^بيع منزل (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
if tonumber(akrmnznum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك منازل ","md",true)
end
if tonumber(akrmnznum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." منزل ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local akrmnzname = Redis:get(TheMero.."akrmnzname"..(_bank_uid))
local akrmnzprice = Redis:get(TheMero.."akrmnzprice"..(_bank_uid)) or 0
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
local akrmnznow = tonumber(akrmnznum) - tonumber(coniss)
Redis:set(TheMero.."akrmnznum"..(_bank_uid) , akrmnznow)
local Textinggt = {"90000", "100000", "110000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
mnzakr = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + mnzakr
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
if tonumber(akrmnznum) == 0 then
Redis:del(TheMero.."akrmnzname"..(_bank_uid))
Redis:del(TheMero.."akrmnznum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع عقار\n⇜ نوع العقار : منزل \n⇜ العدد : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(mnzakr).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء قصر (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local UserName = text:match('^اهداء قصر (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
if tonumber(akrksrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك قصور ","md",true)
end
if tonumber(akrksrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." قصر ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
local akrksrnow = tonumber(akrksrnum) - tonumber(coniss)
Redis:set(TheMero.."akrksrnum"..(_bank_uid) , akrksrnow)
local akrksrnumm = Redis:get(TheMero.."akrksrnum"..Re(_bank_uid)) or 0
local akrksrnoww = tonumber(akrksrnumm) + tonumber(coniss)
Redis:set(TheMero.."akrksrnum"..Re(_bank_uid) , akrksrnoww)
ksrnamed = "قصر"
Redis:set(TheMero.."akrksrname"..Re(_bank_uid),ksrnamed)
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
if tonumber(akrksrnum) == 0 then
Redis:del(TheMero.."akrksrname"..(_bank_uid))
Redis:del(TheMero.."akrksrnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) قصر\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء فيلا (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء فيلا (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
if tonumber(akrfelnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك فيلات ","md",true)
end
if tonumber(akrfelnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." فيلا ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
local akrfelnow = tonumber(akrfelnum) - tonumber(coniss)
Redis:set(TheMero.."akrfelnum"..(_bank_uid) , akrfelnow)
local akrfelnumm = Redis:get(TheMero.."akrfelnum"..Re(_bank_uid)) or 0
local akrfelnoww = tonumber(akrfelnumm) + tonumber(coniss)
Redis:set(TheMero.."akrfelnum"..Re(_bank_uid) , akrfelnoww)
felnamed = "فيلا"
Redis:set(TheMero.."akrfelname"..Re(_bank_uid),felnamed)
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
if tonumber(akrfelnum) == 0 then
Redis:del(TheMero.."akrfelname"..(_bank_uid))
Redis:del(TheMero.."akrfelnum"..(_bank_uid))
end
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) فيلا\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء منزل (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء منزل (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
if tonumber(akrmnznum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك منازل ","md",true)
end
if tonumber(akrmnznum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." منزل","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
local akrmnznow = tonumber(akrmnznum) - tonumber(coniss)
Redis:set(TheMero.."akrmnznum"..(_bank_uid) , akrmnznow)
local akrmnznumm = Redis:get(TheMero.."akrmnznum"..Re(_bank_uid)) or 0
local akrmnznoww = tonumber(akrmnznumm) + tonumber(coniss)
Redis:set(TheMero.."akrmnznum"..Re(_bank_uid) , akrmnznoww)
mnznamed = "منزل"
Redis:set(TheMero.."akrmnzname"..Re(_bank_uid),mnznamed)
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
if tonumber(akrmnznum) == 0 then
Redis:del(TheMero.."akrmnzname"..(_bank_uid))
Redis:del(TheMero.."akrmnznum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) منزل\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء طياره شبح (.*)$') or text and text:match('^شراء طيارة شبح (.*)$') then

local UserName = text:match('^شراء طياره شبح (.*)$') or text:match('^شراء طيارة شبح (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار طياره شبح بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
shbhair = tonumber(coniss) * 1000000000
if tonumber(ballance) < tonumber(shbhair) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local airshbhname = Redis:get(TheMero.."airshbhname"..(_bank_uid))
local airshbhprice = Redis:get(TheMero.."airshbhprice"..(_bank_uid)) or 0
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
local airshbhnow = tonumber(airshbhnum) + tonumber(coniss)
Redis:set(TheMero.."airshbhnum"..(_bank_uid) , airshbhnow)
shbhnamed = "شبح"
Redis:set(TheMero.."airshbhname"..(_bank_uid) , shbhnamed)
Redis:set(TheMero.."airshbhprice"..(_bank_uid) , 1000000000)
totalypalice = tonumber(ballance) - tonumber(shbhair)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(shbhair))
send(msg.chat_id,msg.id, "⌯ وصل شراء طائرة\n⇜ نوع الطائرة : شبح \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد طائراتك الشبح : `"..airshbhnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء طياره سفر (.*)$') or text and text:match('^شراء طيارة سفر (.*)$') then

local UserName = text:match('^شراء طياره سفر (.*)$') or text:match('^شراء طيارة سفر (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار طياره سفر بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
sfarair = tonumber(coniss) * 500000000
if tonumber(ballance) < tonumber(sfarair) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local airsfarname = Redis:get(TheMero.."airsfarname"..(_bank_uid))
local airsfarprice = Redis:get(TheMero.."airsfarprice"..(_bank_uid)) or 0
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
local airsfarnow = tonumber(airsfarnum) + tonumber(coniss)
Redis:set(TheMero.."airsfarnum"..(_bank_uid) , airsfarnow)
sfarnamed = "سفر"
Redis:set(TheMero.."airsfarname"..(_bank_uid) , sfarnamed)
Redis:set(TheMero.."airsfarprice"..(_bank_uid) , 500000000)
totalypalice = tonumber(ballance) - tonumber(sfarair)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(sfarair))
send(msg.chat_id,msg.id, "⌯ وصل شراء طائرة\n⇜ نوع الطائرة : سفر \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد طائراتك السفر : `"..airsfarnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء طياره خاصه (.*)$') or text and text:match('^شراء طيارة خاصه (.*)$') then

local UserName = text:match('^شراء طياره خاصه (.*)$') or text:match('^شراء طيارة خاصه (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار طياره خاصه بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
khasair = tonumber(coniss) * 200000000
if tonumber(ballance) < tonumber(khasair) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local airkhasname = Redis:get(TheMero.."airkhasname"..(_bank_uid))
local airkhasprice = Redis:get(TheMero.."airkhasprice"..(_bank_uid)) or 0
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
local airkhasnow = tonumber(airkhasnum) + tonumber(coniss)
Redis:set(TheMero.."airkhasnum"..(_bank_uid) , airkhasnow)
khasnamed = "خاصه"
Redis:set(TheMero.."airkhasname"..(_bank_uid) , khasnamed)
Redis:set(TheMero.."airkhasprice"..(_bank_uid) , 200000000)
totalypalice = tonumber(ballance) - tonumber(khasair)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(khasair))
send(msg.chat_id,msg.id, "⌯ وصل شراء طائرة\n⇜ نوع الطائرة : خاصه \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد طائراتك الخاصه : `"..airkhasnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع طياره شبح (.*)$') or text and text:match('^بيع طيارة شبح (.*)$') then

local UserName = text:match('^بيع طياره شبح (.*)$') or text:match('^بيع طيارة شبح (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
if tonumber(airshbhnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات شبح ","md",true)
end
if tonumber(airshbhnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طيارة شبح ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local airshbhname = Redis:get(TheMero.."airshbhname"..(_bank_uid))
local airshbhprice = Redis:get(TheMero.."airshbhprice"..(_bank_uid)) or 0
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
local airshbhnow = tonumber(airshbhnum) - tonumber(coniss)
Redis:set(TheMero.."airshbhnum"..(_bank_uid) , airshbhnow)
local Textinggt = {"900000000", "1000000000", "1100000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellair = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellair
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
if tonumber(airshbhnum) == 0 then
Redis:del(TheMero.."airshbhname"..(_bank_uid))
Redis:del(TheMero.."airshbhnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع طائرة\n⇜ نوع الطائرة : شبح \n⇜ عدد الطائرات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellair).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع طياره سفر (.*)$') or text and text:match('^بيع طيارة سفر (.*)$') then

local UserName = text:match('^بيع طياره سفر (.*)$') or text:match('^بيع طيارة سفر (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
if tonumber(airsfarnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات سفر ","md",true)
end
if tonumber(airsfarnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طيارة سفر ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local airsfarname = Redis:get(TheMero.."airsfarname"..(_bank_uid))
local airsfarprice = Redis:get(TheMero.."airsfarprice"..(_bank_uid)) or 0
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
local airsfarnow = tonumber(airsfarnum) - tonumber(coniss)
Redis:set(TheMero.."airsfarnum"..(_bank_uid) , airsfarnow)
local Textinggt = {"400000000", "500000000", "600000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellair = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellair
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
if tonumber(airsfarnum) == 0 then
Redis:del(TheMero.."airsfarname"..(_bank_uid))
Redis:del(TheMero.."airsfarnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع طائرة\n⇜ نوع الطائرة : سفر \n⇜ عدد الطائرات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellair).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع طياره خاصه (.*)$') or text and text:match('^بيع طيارة خاصه (.*)$') then

local UserName = text:match('^بيع طياره خاصه (.*)$') or text:match('^بيع طيارة خاصه (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
if tonumber(airkhasnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات خاصه ","md",true)
end
if tonumber(airkhasnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طيارة خاصه ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local airkhasname = Redis:get(TheMero.."airkhasname"..(_bank_uid))
local airkhasprice = Redis:get(TheMero.."airkhasprice"..(_bank_uid)) or 0
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
local airkhasnow = tonumber(airkhasnum) - tonumber(coniss)
Redis:set(TheMero.."airkhasnum"..(_bank_uid) , airkhasnow)
local Textinggt = {"150000000", "200000000", "250000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellair = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellair
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
if tonumber(airkhasnum) == 0 then
Redis:del(TheMero.."airkhasname"..(_bank_uid))
Redis:del(TheMero.."airkhasnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع طائرة\n⇜ نوع الطائرة : خاصه \n⇜ عدد الطائرات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellair).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء طائره شبح (.*)$') or text and text:match('^اهداء طائرة شبح (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء طائره شبح (.*)$') or text:match('^اهداء طائرة شبح (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
if tonumber(airshbhnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات شبح ","md",true)
end
if tonumber(airshbhnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طائرة شبح ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
local airshbhnow = tonumber(airshbhnum) - tonumber(coniss)
Redis:set(TheMero.."airshbhnum"..(_bank_uid) , airshbhnow)
local airshbhnumm = Redis:get(TheMero.."airshbhnum"..Re(_bank_uid)) or 0
local airshbhnoww = tonumber(airshbhnumm) + tonumber(coniss)
Redis:set(TheMero.."airshbhnum"..Re(_bank_uid) , airshbhnoww)
shbhnamed = "شبح"
Redis:set(TheMero.."airshbhname"..Re(_bank_uid),shbhnamed)
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
if tonumber(airshbhnum) == 0 then
Redis:del(TheMero.."airshbhname"..(_bank_uid))
Redis:del(TheMero.."airshbhnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) طائرة شبح\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء طائره سفر (.*)$') or text and text:match('^اهداء طائرة سفر (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء طائره سفر (.*)$') or text:match('^اهداء طائرة سفر (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
if tonumber(airsfarnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات سفر ","md",true)
end
if tonumber(airsfarnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طائرة سفر ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
local airsfarnow = tonumber(airsfarnum) - tonumber(coniss)
Redis:set(TheMero.."airsfarnum"..(_bank_uid) , airsfarnow)
local airsfarnumm = Redis:get(TheMero.."airsfarnum"..Re(_bank_uid)) or 0
local airsfarnoww = tonumber(airsfarnumm) + tonumber(coniss)
Redis:set(TheMero.."airsfarnum"..Re(_bank_uid) , airsfarnoww)
sfarnamed = "سفر"
Redis:set(TheMero.."airsfarname"..Re(_bank_uid),sfarnamed)
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
if tonumber(airsfarnum) == 0 then
Redis:del(TheMero.."airsfarname"..(_bank_uid))
Redis:del(TheMero.."airsfarnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) طائرة سفر\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء طائره خاصه (.*)$') or text and text:match('^اهداء طائرة خاصه (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then

local UserName = text:match('^اهداء طائره خاصه (.*)$') or text:match('^اهداء طائرة خاصه (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
if tonumber(airkhasnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك طائرات خاصه ","md",true)
end
if tonumber(airkhasnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." طائرة خاصه ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
local airkhasnow = tonumber(airkhasnum) - tonumber(coniss)
Redis:set(TheMero.."airkhasnum"..(_bank_uid) , airkhasnow)
local airkhasnumm = Redis:get(TheMero.."airkhasnum"..Re(_bank_uid)) or 0
local airkhasnoww = tonumber(airkhasnumm) + tonumber(coniss)
Redis:set(TheMero.."airkhasnum"..Re(_bank_uid) , airkhasnoww)
khasnamed = "خاصه"
Redis:set(TheMero.."airkhasname"..Re(_bank_uid),khasnamed)
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
if tonumber(airkhasnum) == 0 then
Redis:del(TheMero.."airkhasname"..(_bank_uid))
Redis:del(TheMero.."airkhasnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) طائرة خاصه\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره فيلار (.*)$') or text and text:match('^شراء سيارة فيلار (.*)$') then
local UserName = text:match('^شراء سياره فيلار (.*)$') or text:match('^شراء سيارة فيلار (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره فيلار بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
rangpr = tonumber(coniss) * 10000000
if tonumber(ballance) < tonumber(rangpr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local carrangname = Redis:get(TheMero.."carrangname"..(_bank_uid))
local carrangprice = Redis:get(TheMero.."carrangprice"..(_bank_uid)) or 0
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
local carrangnow = tonumber(carrangnum) + tonumber(coniss)
Redis:set(TheMero.."carrangnum"..(_bank_uid) , carrangnow)
rangnamed = "فيلار"
Redis:set(TheMero.."carrangname"..(_bank_uid) , rangnamed)
Redis:set(TheMero.."carrangprice"..(_bank_uid) , 10000000)
totalypalice = tonumber(ballance) - tonumber(rangpr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(rangpr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : فيلار \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الفيلار : `"..carrangnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره اكسنت (.*)$') or text and text:match('^شراء سيارة اكسنت (.*)$') then
local UserName = text:match('^شراء سياره اكسنت (.*)$') or text:match('^شراء سيارة اكسنت (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره اكسنت بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
accepr = tonumber(coniss) * 9000000
if tonumber(ballance) < tonumber(accepr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local caraccename = Redis:get(TheMero.."caraccename"..(_bank_uid))
local caracceprice = Redis:get(TheMero.."caracceprice"..(_bank_uid)) or 0
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
local caraccenow = tonumber(caraccenum) + tonumber(coniss)
Redis:set(TheMero.."caraccenum"..(_bank_uid) , caraccenow)
accenamed = "اكسنت"
Redis:set(TheMero.."caraccename"..(_bank_uid) , accenamed)
Redis:set(TheMero.."caracceprice"..(_bank_uid) , 9000000)
totalypalice = tonumber(ballance) - tonumber(accepr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(accepr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : اكسنت \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الاكسنت : `"..caraccenow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره كامري (.*)$') or text and text:match('^شراء سيارة كامري (.*)$') then
local UserName = text:match('^شراء سياره كامري (.*)$') or text:match('^شراء سيارة كامري (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره كامري بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
camrpr = tonumber(coniss) * 8000000
if tonumber(ballance) < tonumber(camrpr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local carcamrname = Redis:get(TheMero.."carcamrname"..(_bank_uid))
local carcamrprice = Redis:get(TheMero.."carcamrprice"..(_bank_uid)) or 0
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
local carcamrnow = tonumber(carcamrnum) + tonumber(coniss)
Redis:set(TheMero.."carcamrnum"..(_bank_uid) , carcamrnow)
camrnamed = "كامري"
Redis:set(TheMero.."carcamrname"..(_bank_uid) , camrnamed)
Redis:set(TheMero.."carcamrprice"..(_bank_uid) , 8000000)
totalypalice = tonumber(ballance) - tonumber(camrpr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(camrpr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : كامري \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الكامري : `"..carcamrnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره النترا (.*)$') or text and text:match('^شراء سيارة النترا (.*)$') then
local UserName = text:match('^شراء سياره النترا (.*)$') or text:match('^شراء سيارة النترا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره النترا بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
alntrpr = tonumber(coniss) * 7000000
if tonumber(ballance) < tonumber(alntrpr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local caralntrname = Redis:get(TheMero.."caralntrname"..(_bank_uid))
local caralntrprice = Redis:get(TheMero.."caralntrprice"..(_bank_uid)) or 0
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
local caralntrnow = tonumber(caralntrnum) + tonumber(coniss)
Redis:set(TheMero.."caralntrnum"..(_bank_uid) , caralntrnow)
alntrnamed = "النترا"
Redis:set(TheMero.."caralntrname"..(_bank_uid) , alntrnamed)
Redis:set(TheMero.."caralntrprice"..(_bank_uid) , 7000000)
totalypalice = tonumber(ballance) - tonumber(alntrpr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(alntrpr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : النترا \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الالنترا : `"..caralntrnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره هايلكس (.*)$') or text and text:match('^شراء سيارة هايلكس (.*)$') then
local UserName = text:match('^شراء سياره هايلكس (.*)$') or text:match('^شراء سيارة هايلكس (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره هايلكس بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
hilxpr = tonumber(coniss) * 6000000
if tonumber(ballance) < tonumber(hilxpr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local carhilxname = Redis:get(TheMero.."carhilxname"..(_bank_uid))
local carhilxprice = Redis:get(TheMero.."carhilxprice"..(_bank_uid)) or 0
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
local carhilxnow = tonumber(carhilxnum) + tonumber(coniss)
Redis:set(TheMero.."carhilxnum"..(_bank_uid) , carhilxnow)
hilxnamed = "هايلكس"
Redis:set(TheMero.."carhilxname"..(_bank_uid) , hilxnamed)
Redis:set(TheMero.."carhilxprice"..(_bank_uid) , 6000000)
totalypalice = tonumber(ballance) - tonumber(hilxpr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(hilxpr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : هايلكس \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الهايلكس : `"..carhilxnow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره سوناتا (.*)$') or text and text:match('^شراء سيارة سوناتا (.*)$') then
local UserName = text:match('^شراء سياره سوناتا (.*)$') or text:match('^شراء سيارة سوناتا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره سوناتا بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
sonapr = tonumber(coniss) * 5000000
if tonumber(ballance) < tonumber(sonapr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local carsonaname = Redis:get(TheMero.."carsonaname"..(_bank_uid))
local carsonaprice = Redis:get(TheMero.."carsonaprice"..(_bank_uid)) or 0
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
local carsonanow = tonumber(carsonanum) + tonumber(coniss)
Redis:set(TheMero.."carsonanum"..(_bank_uid) , carsonanow)
sonanamed = "سوناتا"
Redis:set(TheMero.."carsonaname"..(_bank_uid) , sonanamed)
Redis:set(TheMero.."carsonaprice"..(_bank_uid) , 5000000)
totalypalice = tonumber(ballance) - tonumber(sonapr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(sonapr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : سوناتا \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك السوناتا : `"..carsonanow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^شراء سياره كورولا (.*)$') or text and text:match('^شراء سيارة كورولا (.*)$') then
local UserName = text:match('^شراء سياره كورولا (.*)$') or text:match('^شراء سيارة كورولا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري اكثر من مليار سياره كورولا بعملية وحدة\n✧","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
coropr = tonumber(coniss) * 4000000
if tonumber(ballance) < tonumber(coropr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
local carcoroname = Redis:get(TheMero.."carcoroname"..(_bank_uid))
local carcoroprice = Redis:get(TheMero.."carcoroprice"..(_bank_uid)) or 0
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
local carcoronow = tonumber(carcoronum) + tonumber(coniss)
Redis:set(TheMero.."carcoronum"..(_bank_uid) , carcoronow)
coronamed = "كورولا"
Redis:set(TheMero.."carcoroname"..(_bank_uid) , coronamed)
Redis:set(TheMero.."carcoroprice"..(_bank_uid) , 4000000)
totalypalice = tonumber(ballance) - tonumber(coropr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local convert_monyy = string.format("%.0f",math.floor(coropr))
send(msg.chat_id,msg.id, "⌯ وصل شراء سيارة\n⇜ نوع السيارة : كورولا \n⇜ اجمالي السعر : "..convert_monyy.." 💵\n⇜ عدد سياراتك الكورولا : `"..carcoronow.."`\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره فيلار (.*)$') or text and text:match('^بيع سيارة فيلار (.*)$') then
local UserName = text:match('^بيع سياره فيلار (.*)$') or text:match('^بيع سيارة فيلار (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
if tonumber(carrangnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات فيلار ","md",true)
end
if tonumber(carrangnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة فيلار ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local carrangname = Redis:get(TheMero.."carrangname"..(_bank_uid))
local carrangprice = Redis:get(TheMero.."carrangprice"..(_bank_uid)) or 0
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
local carrangnow = tonumber(carrangnum) - tonumber(coniss)
Redis:set(TheMero.."carrangnum"..(_bank_uid) , carrangnow)
local Textinggt = {"9000000", "10000000", "11000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local convert_mony = string.format("%.0f",math.floor(totalypalice))
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
if tonumber(carrangnum) == 0 then
Redis:del(TheMero.."carrangname"..(_bank_uid))
Redis:del(TheMero.."carrangnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : فيلار \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره اكسنت (.*)$') or text and text:match('^بيع سيارة اكسنت (.*)$') then
local UserName = text:match('^بيع سياره اكسنت (.*)$') or text:match('^بيع سيارة اكسنت (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
if tonumber(caraccenum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات اكسنت ","md",true)
end
if tonumber(caraccenum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة اكسنت ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local caraccename = Redis:get(TheMero.."caraccename"..(_bank_uid))
local caracceprice = Redis:get(TheMero.."caracceprice"..(_bank_uid)) or 0
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
local caraccenow = tonumber(caraccenum) - tonumber(coniss)
Redis:set(TheMero.."caraccenum"..(_bank_uid) , caraccenow)
local Textinggt = {"8000000", "9000000", "10000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
if tonumber(caraccenum) == 0 then
Redis:del(TheMero.."caraccename"..(_bank_uid))
Redis:del(TheMero.."caraccenum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : اكسنت \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره كامري (.*)$') or text and text:match('^بيع سيارة كامري (.*)$') then
local UserName = text:match('^بيع سياره كامري (.*)$') or text:match('^بيع سيارة كامري (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
if tonumber(carcamrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات كامري ","md",true)
end
if tonumber(carcamrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة كامري ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local carcamrname = Redis:get(TheMero.."carcamrname"..(_bank_uid))
local carcamrprice = Redis:get(TheMero.."carcamrprice"..(_bank_uid)) or 0
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
local carcamrnow = tonumber(carcamrnum) - tonumber(coniss)
Redis:set(TheMero.."carcamrnum"..(_bank_uid) , carcamrnow)
local Textinggt = {"7000000", "8000000", "9000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
if tonumber(carcamrnum) == 0 then
Redis:del(TheMero.."carcamrname"..(_bank_uid))
Redis:del(TheMero.."carcamrnum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : كامري \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره النترا (.*)$') or text and text:match('^بيع سيارة النترا (.*)$') then
local UserName = text:match('^بيع سياره النترا (.*)$') or text:match('^بيع سيارة النترا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
if tonumber(caralntrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات النترا ","md",true)
end
if tonumber(caralntrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة النترا ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local caralntrname = Redis:get(TheMero.."caralntrname"..(_bank_uid))
local caralntrprice = Redis:get(TheMero.."caralntrprice"..(_bank_uid)) or 0
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
local caralntrnow = tonumber(caralntrnum) - tonumber(coniss)
Redis:set(TheMero.."caralntrnum"..(_bank_uid) , caralntrnow)
local Textinggt = {"6000000", "7000000", "8000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
if tonumber(caralntrnum) == 0 then
Redis:del(TheMero.."caralntrname"..(_bank_uid))
Redis:del(TheMero.."caralntrnum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : النترا \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره هايلكس (.*)$') or text and text:match('^بيع سيارة هايلكس (.*)$') then
local UserName = text:match('^بيع سياره هايلكس (.*)$') or text:match('^بيع سيارة هايلكس (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
if tonumber(carhilxnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات هايلكس ","md",true)
end
if tonumber(carhilxnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة هايلكس ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local carhilxname = Redis:get(TheMero.."carhilxname"..(_bank_uid))
local carhilxprice = Redis:get(TheMero.."carhilxprice"..(_bank_uid)) or 0
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
local carhilxnow = tonumber(carhilxnum) - tonumber(coniss)
Redis:set(TheMero.."carhilxnum"..(_bank_uid) , carhilxnow)
local Textinggt = {"5000000", "6000000", "7000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
if tonumber(carhilxnum) == 0 then
Redis:del(TheMero.."carhilxname"..(_bank_uid))
Redis:del(TheMero.."carhilxnum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : هايلكس \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره سوناتا (.*)$') or text and text:match('^بيع سيارة سوناتا (.*)$') then
local UserName = text:match('^بيع سياره سوناتا (.*)$') or text:match('^بيع سيارة سوناتا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
if tonumber(carsonanum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات سوناتا ","md",true)
end
if tonumber(carsonanum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة سوناتا ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local carsonaname = Redis:get(TheMero.."carsonaname"..(_bank_uid))
local carsonaprice = Redis:get(TheMero.."carsonaprice"..(_bank_uid)) or 0
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
local carsonanow = tonumber(carsonanum) - tonumber(coniss)
Redis:set(TheMero.."carsonanum"..(_bank_uid) , carsonanow)
local Textinggt = {"4000000", "5000000", "6000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
if tonumber(carsonanum) == 0 then
Redis:del(TheMero.."carsonaname"..(_bank_uid))
Redis:del(TheMero.."carsonanum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : سوناتا \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^بيع سياره كورولا (.*)$') or text and text:match('^بيع سيارة كورولا (.*)$') then
local UserName = text:match('^بيع سياره كورولا (.*)$') or text:match('^بيع سيارة كورولا (.*)$')
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
if tonumber(carcoronum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات كورولا ","md",true)
end
if tonumber(carcoronum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة كورولا ","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local carcoroname = Redis:get(TheMero.."carcoroname"..(_bank_uid))
local carcoroprice = Redis:get(TheMero.."carcoroprice"..(_bank_uid)) or 0
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
local carcoronow = tonumber(carcoronum) - tonumber(coniss)
Redis:set(TheMero.."carcoronum"..(_bank_uid) , carcoronow)
local Textinggt = {"3000000", "4000000", "5000000",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
sellcar = tonumber(coniss) * Descriptioont
totalypalice = tonumber(ballanceed) + sellcar
Redis:set(TheMero.."boob"..(_bank_uid) , totalypalice)
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
if tonumber(carcoronum) == 0 then
Redis:del(TheMero.."carcoroname"..(_bank_uid))
Redis:del(TheMero.."carcoronum"..(_bank_uid))
end
local convert_mony = string.format("%.0f",math.floor(totalypalice))
send(msg.chat_id,msg.id, "⌯ وصل بيع سيارة\n⇜ نوع السيارة : كورولا \n⇜ عدد السيارات : "..tonumber(coniss).."\n⇜ اجمالي السعر : "..tonumber(sellcar).." 💵\n⇜ رصيدك الان : "..convert_mony.."\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره فيلار (.*)$') or text and text:match('^اهداء سيارة فيلار (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره فيلار (.*)$') or text:match('^اهداء سيارة فيلار (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
if tonumber(carrangnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات فيلار ","md",true)
end
if tonumber(carrangnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة فيلار ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
local carrangnow = tonumber(carrangnum) - tonumber(coniss)
Redis:set(TheMero.."carrangnum"..(_bank_uid) , carrangnow)
local carrangnumm = Redis:get(TheMero.."carrangnum"..Re(_bank_uid)) or 0
local carrangnoww = tonumber(carrangnumm) + tonumber(coniss)
Redis:set(TheMero.."carrangnum"..Re(_bank_uid) , carrangnoww)
rangnamed = "فيلار"
Redis:set(TheMero.."carrangname"..Re(_bank_uid),rangnamed)
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
if tonumber(carrangnum) == 0 then
Redis:del(TheMero.."carrangname"..(_bank_uid))
Redis:del(TheMero.."carrangnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة فيلار\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره اكسنت (.*)$') or text and text:match('^اهداء سيارة اكسنت (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره اكسنت (.*)$') or text:match('^اهداء سيارة اكسنت (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
if tonumber(caraccenum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات اكسنت ","md",true)
end
if tonumber(caraccenum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة اكسنت ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
local caraccenow = tonumber(caraccenum) - tonumber(coniss)
Redis:set(TheMero.."caraccenum"..(_bank_uid) , caraccenow)
local caraccenumm = Redis:get(TheMero.."caraccenum"..Re(_bank_uid)) or 0
local caraccenoww = tonumber(caraccenumm) + tonumber(coniss)
Redis:set(TheMero.."caraccenum"..Re(_bank_uid) , caraccenoww)
accenamed = "اكسنت"
Redis:set(TheMero.."caraccename"..Re(_bank_uid),accenamed)
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
if tonumber(caraccenum) == 0 then
Redis:del(TheMero.."caraccename"..(_bank_uid))
Redis:del(TheMero.."caraccenum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة اكسنت\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره كامري (.*)$') or text and text:match('^اهداء سيارة كامري (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره كامري (.*)$') or text:match('^اهداء سيارة كامري (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
if tonumber(carcamrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات كامري ","md",true)
end
if tonumber(carcamrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة كامري ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
local carcamrnow = tonumber(carcamrnum) - tonumber(coniss)
Redis:set(TheMero.."carcamrnum"..(_bank_uid) , carcamrnow)
local carcamrnumm = Redis:get(TheMero.."carcamrnum"..Re(_bank_uid)) or 0
local carcamrnoww = tonumber(carcamrnumm) + tonumber(coniss)
Redis:set(TheMero.."carcamrnum"..Re(_bank_uid) , carcamrnoww)
camrnamed = "كامري"
Redis:set(TheMero.."carcamrname"..Re(_bank_uid),camrnamed)
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
if tonumber(carcamrnum) == 0 then
Redis:del(TheMero.."carcamrname"..(_bank_uid))
Redis:del(TheMero.."carcamrnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة كامري\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره هايلكس (.*)$') or text and text:match('^اهداء سيارة هايلكس (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره هايلكس (.*)$') or text:match('^اهداء سيارة هايلكس (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
if tonumber(carhilxnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات هايلكس ","md",true)
end
if tonumber(carhilxnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة هايلكس ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
local carhilxnow = tonumber(carhilxnum) - tonumber(coniss)
Redis:set(TheMero.."carhilxnum"..(_bank_uid) , carhilxnow)
local carhilxnumm = Redis:get(TheMero.."carhilxnum"..Re(_bank_uid)) or 0
local carhilxnoww = tonumber(carhilxnumm) + tonumber(coniss)
Redis:set(TheMero.."carhilxnum"..Re(_bank_uid) , carhilxnoww)
hilxnamed = "هايلكس"
Redis:set(TheMero.."carhilxname"..Re(_bank_uid),hilxnamed)
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
if tonumber(carhilxnum) == 0 then
Redis:del(TheMero.."carhilxname"..(_bank_uid))
Redis:del(TheMero.."carhilxnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة هايلكس\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره النترا (.*)$') or text and text:match('^اهداء سيارة النترا (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره النترا (.*)$') or text:match('^اهداء سيارة النترا (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
if tonumber(caralntrnum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات النترا ","md",true)
end
if tonumber(caralntrnum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة النترا ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
local caralntrnow = tonumber(caralntrnum) - tonumber(coniss)
Redis:set(TheMero.."caralntrnum"..(_bank_uid) , caralntrnow)
local caralntrnumm = Redis:get(TheMero.."caralntrnum"..Re(_bank_uid)) or 0
local caralntrnoww = tonumber(caralntrnumm) + tonumber(coniss)
Redis:set(TheMero.."caralntrnum"..Re(_bank_uid) , caralntrnoww)
alntrnamed = "النترا"
Redis:set(TheMero.."caralntrname"..Re(_bank_uid),alntrnamed)
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
if tonumber(caralntrnum) == 0 then
Redis:del(TheMero.."caralntrname"..(_bank_uid))
Redis:del(TheMero.."caralntrnum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة النترا\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره سوناتا (.*)$') or text and text:match('^اهداء سيارة سوناتا (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره سوناتا (.*)$') or text:match('^اهداء سيارة سوناتا (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
if tonumber(carsonanum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات سوناتا ","md",true)
end
if tonumber(carsonanum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة سوناتا ","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
local carsonanow = tonumber(carsonanum) - tonumber(coniss)
Redis:set(TheMero.."carsonanum"..(_bank_uid) , carsonanow)
local carsonanumm = Redis:get(TheMero.."carsonanum"..Re(_bank_uid)) or 0
local carsonanoww = tonumber(carsonanumm) + tonumber(coniss)
Redis:set(TheMero.."carsonanum"..Re(_bank_uid) , carsonanoww)
sonanamed = "سوناتا"
Redis:set(TheMero.."carsonaname"..Re(_bank_uid),sonanamed)
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
if tonumber(carsonanum) == 0 then
Redis:del(TheMero.."carsonaname"..(_bank_uid))
Redis:del(TheMero.."carsonanum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة سوناتا\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^اهداء سياره كورولا (.*)$') or text and text:match('^اهداء سيارة كورولا (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^اهداء سياره كورولا (.*)$') or text:match('^اهداء سيارة كورولا (.*)$')
if Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."giftmmt" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ مايمديك تهدي الحين\n⇜ تعال بعد "..time.." ","md",true)
end
local coniss = coin(UserName)
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
if tonumber(carcoronum) == 0 then
return send(msg.chat_id,msg.id, "⇜ ليس لديك سيارات كورولا ","md",true)
end
if tonumber(carcoronum) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ ماعندك "..tonumber(coniss).." سيارة كورولا","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ تهدي نفسك 🤡","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
local carcoronow = tonumber(carcoronum) - tonumber(coniss)
Redis:set(TheMero.."carcoronum"..(_bank_uid) , carcoronow)
local carcoronumm = Redis:get(TheMero.."carcoronum"..Re(_bank_uid)) or 0
local carcoronoww = tonumber(carcoronumm) + tonumber(coniss)
Redis:set(TheMero.."carcoronum"..Re(_bank_uid) , carcoronoww)
coronamed = "كورولا"
Redis:set(TheMero.."carcoroname"..Re(_bank_uid),coronamed)
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
if tonumber(carcoronum) == 0 then
Redis:del(TheMero.."carcoroname"..(_bank_uid))
Redis:del(TheMero.."carcoronum"..(_bank_uid))
end
send(msg.chat_id,msg.id, "⇜ تم اهديته ( "..tonumber(coniss).." ) سيارة كورولا\n\n⇜ اكتب `ممتلكاتي` لعرض جميع ممتلكاتك \n✧","md",true)
Redis:setex(TheMero.."giftmmt" .. (_bank_uid),1800, true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
----------
if text == "ممتلكاتي" or text == "ممتلكات" then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
local mgrmasname = Redis:get(TheMero.."mgrmasname"..(_bank_uid))
local mgrmasnum = Redis:get(TheMero.."mgrmasnum"..(_bank_uid)) or 0
if mgrmasname then
mgrmasnamee = "- "..mgrmasname.." : ( `"..mgrmasnum.."` ) \n"
else
mgrmasnamee = ""
end
local mgrkldname = Redis:get(TheMero.."mgrkldname"..(_bank_uid))
local mgrkldnum = Redis:get(TheMero.."mgrkldnum"..(_bank_uid)) or 0
if mgrkldname then
mgrkldnamee = "- "..mgrkldname.." : ( `"..mgrkldnum.."` ) \n"
else
mgrkldnamee = ""
end
local mgrswrname = Redis:get(TheMero.."mgrswrname"..(_bank_uid))
local mgrswrnum = Redis:get(TheMero.."mgrswrnum"..(_bank_uid)) or 0
if mgrswrname then
mgrswrnamee = "- "..mgrswrname.." : ( `"..mgrswrnum.."` ) \n"
else
mgrswrnamee = ""
end
local mgrktmname = Redis:get(TheMero.."mgrktmname"..(_bank_uid))
local mgrktmnum = Redis:get(TheMero.."mgrktmnum"..(_bank_uid)) or 0
if mgrktmname then
mgrktmnamee = "- "..mgrktmname.." : ( `"..mgrktmnum.."` ) \n"
else
mgrktmnamee = ""
end
local akrksrname = Redis:get(TheMero.."akrksrname"..(_bank_uid))
local akrksrnum = Redis:get(TheMero.."akrksrnum"..(_bank_uid)) or 0
if akrksrname then
akrksrnamee = "- "..akrksrname.." : ( `"..akrksrnum.."` ) \n"
else
akrksrnamee = ""
end
local akrfelname = Redis:get(TheMero.."akrfelname"..(_bank_uid))
local akrfelnum = Redis:get(TheMero.."akrfelnum"..(_bank_uid)) or 0
if akrfelname then
akrfelnamee = "- "..akrfelname.." : ( `"..akrfelnum.."` ) \n"
else
akrfelnamee = ""
end
local akrmnzname = Redis:get(TheMero.."akrmnzname"..(_bank_uid))
local akrmnznum = Redis:get(TheMero.."akrmnznum"..(_bank_uid)) or 0
if akrmnzname then
akrmnznamee = "- "..akrmnzname.." : ( `"..akrmnznum.."` ) \n"
else
akrmnznamee = ""
end
local airshbhname = Redis:get(TheMero.."airshbhname"..(_bank_uid))
local airshbhnum = Redis:get(TheMero.."airshbhnum"..(_bank_uid)) or 0
if airshbhname then
airshbhnamee = "- "..airshbhname.." : ( `"..airshbhnum.."` ) \n"
else
airshbhnamee = ""
end
local airsfarname = Redis:get(TheMero.."airsfarname"..(_bank_uid))
local airsfarnum = Redis:get(TheMero.."airsfarnum"..(_bank_uid)) or 0
if airsfarname then
airsfarnamee = "- "..airsfarname.." : ( `"..airsfarnum.."` ) \n"
else
airsfarnamee = ""
end
local airkhasname = Redis:get(TheMero.."airkhasname"..(_bank_uid))
local airkhasnum = Redis:get(TheMero.."airkhasnum"..(_bank_uid)) or 0
if airkhasname then
airkhasnamee = "- "..airkhasname.." : ( `"..airkhasnum.."` ) \n"
else
airkhasnamee = ""
end
local carrangname = Redis:get(TheMero.."carrangname"..(_bank_uid))
local carrangnum = Redis:get(TheMero.."carrangnum"..(_bank_uid)) or 0
if carrangname then
carrangnamee = "- "..carrangname.." : ( `"..carrangnum.."` ) \n"
else
carrangnamee = ""
end
local caraccename = Redis:get(TheMero.."caraccename"..(_bank_uid))
local caraccenum = Redis:get(TheMero.."caraccenum"..(_bank_uid)) or 0
if caraccename then
caraccenamee = "- "..caraccename.." : ( `"..caraccenum.."` ) \n"
else
caraccenamee = ""
end
local carcamrname = Redis:get(TheMero.."carcamrname"..(_bank_uid))
local carcamrnum = Redis:get(TheMero.."carcamrnum"..(_bank_uid)) or 0
if carcamrname then
carcamrnamee = "- "..carcamrname.." : ( `"..carcamrnum.."` ) \n"
else
carcamrnamee = ""
end
local caralntrname = Redis:get(TheMero.."caralntrname"..(_bank_uid))
local caralntrnum = Redis:get(TheMero.."caralntrnum"..(_bank_uid)) or 0
if caralntrname then
caralntrnamee = "- "..caralntrname.." : ( `"..caralntrnum.."` ) \n"
else
caralntrnamee = ""
end
local carhilxname = Redis:get(TheMero.."carhilxname"..(_bank_uid))
local carhilxnum = Redis:get(TheMero.."carhilxnum"..(_bank_uid)) or 0
if carhilxname then
carhilxnamee = "- "..carhilxname.." : ( `"..carhilxnum.."` ) \n"
else
carhilxnamee = ""
end
local carsonaname = Redis:get(TheMero.."carsonaname"..(_bank_uid))
local carsonanum = Redis:get(TheMero.."carsonanum"..(_bank_uid)) or 0
if carsonaname then
carsonanamee = "- "..carsonaname.." : ( `"..carsonanum.."` ) \n"
else
carsonanamee = ""
end
local carcoroname = Redis:get(TheMero.."carcoroname"..(_bank_uid))
local carcoronum = Redis:get(TheMero.."carcoronum"..(_bank_uid)) or 0
if carcoroname then
carcoronamee = "- "..carcoroname.." : ( `"..carcoronum.."` ) \n"
else
carcoronamee = ""
end
if akrksrnum == 0 and akrfelnum == 0 and akrmnznum == 0 and mgrmasnum == 0 and mgrkldnum == 0 and mgrswrnum == 0 and mgrktmnum == 0 and airshbhnum == 0 and airsfarnum == 0 and airkhasnum == 0 and carrangnum == 0 and caraccenum == 0 and carcamrnum == 0 and caralntrnum == 0 and carhilxnum == 0 and carsonanum == 0 and carcoronum == 0 then
send(msg.chat_id,msg.id, "⇜ لا يوجد لديك ممتلكات\n⇜ تستطيع الشراء عن طريق ارسال كلمة ( `المعرض` )\n\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ مجوهراتك : 💎\n\n"..mgrmasnamee..""..mgrkldnamee..""..mgrswrnamee..""..mgrktmnamee.."\n⇜ عقاراتك : 🏘\n\n"..akrksrnamee..""..akrfelnamee..""..akrmnznamee.."\n⇜ طائراتك : ✈️\n\n"..airshbhnamee..""..airsfarnamee..""..airkhasnamee.."\n⇜ سياراتك : 🚗\n\n"..carrangnamee..""..caraccenamee..""..carcamrnamee..""..caralntrnamee..""..carhilxnamee..""..carsonanamee..""..carcoronamee.."\n\n⇜ تستطيع بيع او اهداء ممتلكاتك\nمثال :\nبيع فيلا 4 \nاهداء طائره شبح 2 ( بالرد ) \n\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
----------
if text == 'زواج' then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زواج` المهر","md",true)
end
if text and text:match("^زواج (%d+)$") and msg.reply_to_message_id == 0 then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زواج` المهر ( بالرد )","md",true)
end
if text and text:match("^زواج (.*)$") and msg.reply_to_message_id ~= 0 then

ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local UserName = text:match('^زواج (.*)$')
local coniss = coin(UserName)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ زوجتك نفسي 🤣😒","md",true)  
return false
end
if Redis:get(TheMero.."zwag_request:"..(_bank_uid)) then 
return send(msg.chat_id,msg.id, "⇜ في طلب باسمك انتظر قليلاً \n✧","md",true)
end
if tonumber(coniss) < 10000 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 10000 درهم \n✧","md",true)
end
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballancee) < 10000 then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
if tonumber(coniss) > tonumber(ballancee) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي\n✧","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي مو للزواج 🤣","md",true)  
return false
end
if Redis:get(TheMero.."roog1"..(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ ابك تراك متزوج !!","md",true)
return false
end
if Redis:get(TheMero.."rooga1"..(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ ابك تراك متزوج !!","md",true)
return false
end
if Redis:get(TheMero.."roog1"..Re(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ ابعد بعيد لاتحوس وتدور حول المتزوجين","md",true)
return false
end
if Redis:get(TheMero.."rooga1"..Re(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ ابعد بعيد لاتحوس وتدور حول المتزوجين","md",true)
return false
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local zwg = bot.getUser((_bank_uid))
local zwga = bot.getUser(Re(_bank_uid))
local zwg_tag = '['..zwg.first_name.."](tg://user?id="..(_bank_uid)..")"
local zwga_tag = '['..zwga.first_name.."](tg://user?id="..Re(_bank_uid)..")"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'موافقة', data =Re(_bank_uid).."/zwag_yes/"..(_bank_uid).."/mahr/"..coniss},{text = 'غير موافقة', data = Re(_bank_uid).."/zwag_no/"..(_bank_uid)},
},
}
}
Redis:setex(TheMero.."zwag_request:"..(_bank_uid),60,true)
Redis:setex(TheMero.."zwag_request:"..Re(_bank_uid),60,true)
return send(msg.chat_id,msg.id,"⇜ الزوج : "..zwg_tag.."\n⇜ الزوجة : "..zwga_tag.."\n⇜ المهر : "..coniss.."\n⇜ شو رأيك معاكي دقيقة وينتهي الطلب ؟","md",false, false, false, false, reply_markup)
else
return send(msg.chat_id,msg.reply_to_message_id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "زواجات غش" then
if msg.ControllerBot then
  local zwag_users = Redis:smembers(TheMero.."roogg1")
  if #zwag_users == 0 then
  return send(msg.chat_id,msg.id,"⇜ مافي زواجات حاليا","md",true)
  end
  top_zwag = "⇜ توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = Redis:get(TheMero.."rahr1"..v)
  local zwga = Redis:get(TheMero.."rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
  local zwg_tag = '['..zwg_name..'](tg://user?id='..v[2]..')'
  local zwga_name = bot.getUser(v[3]).first_name or Redis:get(TheMero..v[3].."first_name:") or "لا يوجد اسم"
  local zwga_tag = '['..zwga_name..'](tg://user?id='..v[3]..')'
tt =  '['..zwg_name..'](tg://user?id='..v[2]..')'
kk = '['..zwga_name..'](tg://user?id='..v[3]..')'
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = zwag_emoji[k]
znum = znum + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_zwag = top_zwag..emo.." "..gflos.." 💵 l "..tt.." 👫 "..kk.."\n"
gg = "\n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
  end
  end
  local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_zwag,"md",false, false, false, false, reply_markup)
  end
  end
if text == "توب زواج" or text == "توب متزوجات" or text == "توب زوجات" or text == "توب زواجات" or text == "زواجات" or text == "الزواجات" then

  local zwag_users = Redis:smembers(TheMero.."roogg1")
  if #zwag_users == 0 then
  return send(msg.chat_id,msg.id,"⇜ مافي زواجات حاليا","md",true)
  end
  top_zwag = "⇜ توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = Redis:get(TheMero.."rahr1"..v)
  local zwga = Redis:get(TheMero.."rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
  local zwga_name = bot.getUser(v[3]).first_name or Redis:get(TheMero..v[3].."first_name:") or "لا يوجد اسم"
tt =  "["..zwg_name.."]("..zwg_name..")"
tt = tt:gsub("🇾🇪️",'')
tt = tt:gsub("🇹🇳",'')
tt = tt:gsub("🇸🇾",'')
tt = tt:gsub("🇸🇩",'')
tt = tt:gsub("🇸🇦",'')
tt = tt:gsub("🇶🇦",'')
tt = tt:gsub("🇵🇸",'')
tt = tt:gsub("🇴🇲",'')
tt = tt:gsub("🇲🇦",'')
tt = tt:gsub("🇱🇾",'')
tt = tt:gsub("🇱🇧",'')
tt = tt:gsub("🇰🇼️",'')
tt = tt:gsub("🇯🇴",'')
tt = tt:gsub("🇮🇶",'')
tt = tt:gsub("🇪🇬",'')
tt = tt:gsub("🇧🇭",'')
tt = tt:gsub("🇩🇿️",'')
tt = tt:gsub("🇦🇪",'')
tt = tt:gsub("@[%a%d_]+",'')
tt = tt:gsub("#[%a%d_]+",'')
kk =  "["..zwga_name.."]("..zwga_name..")"
kk = kk:gsub("🇾🇪️",'')
kk = kk:gsub("🇹🇳",'')
kk = kk:gsub("🇸🇾",'')
kk = kk:gsub("🇸🇩",'')
kk = kk:gsub("🇸🇦",'')
kk = kk:gsub("🇶🇦",'')
kk = kk:gsub("🇵🇸",'')
kk = kk:gsub("🇴🇲",'')
kk = kk:gsub("🇲🇦",'')
kk = kk:gsub("🇱🇾",'')
kk = kk:gsub("🇱🇧",'')
kk = kk:gsub("🇰🇼️",'')
kk = kk:gsub("🇯🇴",'')
kk = kk:gsub("🇮🇶",'')
kk = kk:gsub("🇪🇬",'')
kk = kk:gsub("🇧🇭",'')
kk = kk:gsub("🇩🇿️",'')
kk = kk:gsub("🇦🇪",'')
kk = kk:gsub("@[%a%d_]+",'')
kk = kk:gsub("#[%a%d_]+",'')
local doltebank = Redis:get(TheMero.."doltebank"..v[2]) or " "
local doltebankz = Redis:get(TheMero.."doltebank"..v[3]) or " "
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = zwag_emoji[k]
znum = znum + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_zwag = top_zwag..emo.." "..gflos.." 💵 l "..tt.." "..doltebank.." 👫 "..kk.." "..doltebankz.."\n"
gg = "\n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
  end
  end
  local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_zwag..gg,"md",false, false, false, false, reply_markup)
  end
if text == 'زواجي' then

if Redis:sismember(TheMero.."roogg1",(_bank_uid)) or Redis:sismember(TheMero.."roogga1",(_bank_uid)) then
local zoog = Redis:get(TheMero.."roog1"..(_bank_uid))
local zooga = Redis:get(TheMero.."rooga1"..(_bank_uid))
local mahr = Redis:get(TheMero.."rahr1"..(_bank_uid))
local convert_mony = string.format("%.0f",mahr)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد اسم"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد اسم"
end
send(msg.chat_id,msg.id, "⌯ وثيقة الزواج حقتك :\n\n⇜ الزوج "..neews.." 🤵🏻\n⇜ الزوجة "..newws.." 👰🏻‍♀️\n⇜ المهر : "..convert_mony.." درهم 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end
if text == 'زوجها' or text == "زوجته" or text == "جوزها" or text == "زوجتو" or text == "زواجه" and msg.reply_to_message_id ~= 0 then

local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if (_bank_uid) == Re(_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ اكتب `زواجي`","md",true)  
return false
end
if Redis:sismember(TheMero.."roogg1",Re(_bank_uid)) or Redis:sismember(TheMero.."roogga1",Re(_bank_uid)) then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballancee) < 100 then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي مو متزوجه ","md",true)  
return false
end
local zoog = Redis:get(TheMero.."roog1"..Re(_bank_uid))
local zooga = Redis:get(TheMero.."rooga1"..Re(_bank_uid))
local mahr = Redis:get(TheMero.."rahr1"..Re(_bank_uid))
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد اسم"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد اسم"
end
local otheka = ballancee - 100
local convert_mony = string.format("%.0f",mahr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(otheka))
send(msg.chat_id,msg.id, "⌯ وثيقة الزواج حقته :\n\n⇜ الزوج "..neews.." 🤵🏻\n⇜ الزوجة "..newws.." 👰🏻‍♀️\n⇜ المهر : "..convert_mony.." درهم 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ مسكين اعزب مو متزوج","md",true)
end
end
if text == 'طلاق' then

if Redis:sismember(TheMero.."roogg1",(_bank_uid)) or Redis:sismember(TheMero.."roogga1",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local zoog = Redis:get(TheMero.."roog1"..(_bank_uid))
local zooga = tonumber(Redis:get(TheMero.."rooga1"..(_bank_uid)))
if tonumber(zoog) == (_bank_uid) then
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد اسم"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد اسم"
end
Redis:srem(TheMero.."roogg1", (_bank_uid))
Redis:srem(TheMero.."roogga1", (_bank_uid))
Redis:del(TheMero.."roog1"..(_bank_uid))
Redis:del(TheMero.."rooga1"..(_bank_uid))
Redis:del(TheMero.."rahr1"..(_bank_uid))
Redis:del(TheMero.."rahrr1"..(_bank_uid))
Redis:srem(TheMero.."roogg1", zooga)
Redis:srem(TheMero.."roogga1", zooga)
Redis:del(TheMero.."roog1"..zooga)
Redis:del(TheMero.."rooga1"..zooga)
Redis:del(TheMero.."rahr1"..zooga)
Redis:del(TheMero.."rahrr1"..zooga)
return send(msg.chat_id,msg.id, "⇜ ابشر طلقتك من زوجتك "..newws.."","md",true)
else
send(msg.chat_id,msg.id, "⇜ الطلاق للزوج فقط","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end
if text == 'خلع' then

if Redis:sismember(TheMero.."roogg1",(_bank_uid)) or Redis:sismember(TheMero.."roogga1",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
local zoog = Redis:get(TheMero.."roog1"..(_bank_uid))
local zooga = Redis:get(TheMero.."rooga1"..(_bank_uid))
if tonumber(zooga) == (_bank_uid) then
local mahrr = Redis:get(TheMero.."rahrr1"..(_bank_uid))
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد اسم"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد اسم"
end
ballancee = Redis:get(TheMero.."boob"..zoog) or 0
kalea = ballancee + mahrr
Redis:set(TheMero.."boob"..zoog , kalea)
local convert_mony = string.format("%.0f",mahrr)
send(msg.chat_id,msg.id, "⇜ خلعت زوجك "..neews.."\n⇜ ورجعت له المهر ( "..convert_mony.." درهم 💵 )","md",true)
Redis:srem(TheMero.."roogg1", zoog)
Redis:srem(TheMero.."roogga1", zoog)
Redis:del(TheMero.."roog1"..zoog)
Redis:del(TheMero.."rooga1"..zoog)
Redis:del(TheMero.."rahr1"..zoog)
Redis:del(TheMero.."rahrr1"..zoog)
Redis:srem(TheMero.."roogg1", (_bank_uid))
Redis:srem(TheMero.."roogga1", (_bank_uid))
Redis:del(TheMero.."roog1"..(_bank_uid))
Redis:del(TheMero.."rooga1"..(_bank_uid))
Redis:del(TheMero.."rahr1"..(_bank_uid))
Redis:del(TheMero.."rahrr1"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ الخلع للزوجات فقط","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end
if text == 'مراهنه' or text == 'مراهنة' then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `مراهنه` المبلغ","md",true)
end
if text and text:match('^مراهنه (.*)$') or text and text:match('^مراهنة (.*)$') then

local UserName = text:match('^مراهنه (.*)$') or text:match('^مراهنة (.*)$')
local coniss = coin(UserName)
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) < 999 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 1000 درهم 💵\n✧","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي \n✧","md",true)
end
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
Redis:del(TheMero..'List_rhan'..msg.chat_id)  
Redis:set(TheMero.."playerrhan"..msg.chat_id,(_bank_uid))
Redis:set(TheMero.."playercoins"..msg.chat_id..(_bank_uid),coniss)
Redis:set(TheMero.."raeahkam"..msg.chat_id,(_bank_uid))
Redis:sadd(TheMero..'List_rhan'..msg.chat_id,(_bank_uid))
Redis:setex(TheMero.."Start_rhan"..msg.chat_id,3600,true)
Redis:set(TheMero.."allrhan"..msg.chat_id..12345 , coniss)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
rehan = tonumber(ballancee) - tonumber(coniss)
Redis:set(TheMero.."boob"..(_bank_uid) , rehan)
return send(msg.chat_id,msg.id,"⇜ بدينا المراهنة وسجلت اسمك \n⇜ اللي بده يشارك يرسل ( انا والمبلغ ) .","md",true)
end
if text == 'نعم' and Redis:get(TheMero.."Witting_Startrhan"..msg.chat_id) then
rarahkam = Redis:get(TheMero.."raeahkam"..msg.chat_id)
if tonumber(rarahkam) == (_bank_uid) then
local list = Redis:smembers(TheMero..'List_rhan'..msg.chat_id) 
if #list == 1 then 
return send(msg.chat_id,msg.id,"⇜ عذراً لم يشارك احد بالرهان","md",true)  
end 
local UserName = list[math.random(#list)]
local UserId_Info = bot.getUser(UserName)
if UserId_Info.username and UserId_Info.username ~= "" then
ls = '['..UserId_Info.first_name..'](tg://user?id='..UserName..')'
else
ls = '@['..UserId_Info.username..']'
end
benrahan = Redis:get(TheMero.."allrhan"..msg.chat_id..12345) or 0
local ballancee = Redis:get(TheMero.."boob"..UserName) or 0
rehane = tonumber(benrahan) / 100 * 25
rehan = tonumber(ballancee) + math.floor(rehane)
Redis:set(TheMero.."boob"..UserName , rehan)
local rhan_users = Redis:smembers(TheMero.."List_rhan"..msg.chat_id)
for k,v in pairs(rhan_users) do
Redis:del(TheMero..'playercoins'..msg.chat_id..v)
end
Redis:del(TheMero..'allrhan'..msg.chat_id..12345) 
Redis:del(TheMero..'playerrhan'..msg.chat_id) 
Redis:del(TheMero..'raeahkam'..msg.chat_id) 
Redis:del(TheMero..'List_rhan'..msg.chat_id) 
Redis:del(TheMero.."Witting_Startrhan"..msg.chat_id)
Redis:del(TheMero.."Start_rhan"..msg.chat_id)
local ballancee = Redis:get(TheMero.."boob"..UserName) or 0
local convert_mony = string.format("%.0f",rehane)
local convert_monyy = string.format("%.0f",ballancee)
return send(msg.chat_id,msg.id,'⌯ فاز '..ls..' بالرهان 🎊\n⇜ المبلغ : '..convert_mony..' درهم 💵\n⇜ خصمت 25% ضريبة \n⇜ رصيدك الان : '..convert_monyy..' درهم 💵\n✧',"md",true)
end
end
--------------------------------------------------------------------------------------------------------------
if text == 'الكره' or text == 'كرة' or text == 'نادي' or text == 'النادي' or text == 'لعبه الكره' or text == 'لعبه الكرة' then
return send(msg.chat_id,msg.id, "☆ اوامر لعبه الكره\n\n⌯ انشاء نادي + الاسم ↢ تسوي نادي وتقدر تلعب مباريات مع اصحابك\n\n⌯ مسح ناديي ↢ تمسح ناديك\n\n⌯ ناديي ↢ يطلع لك اسم ناديك ومعلومات عنه\n\n⌯ تدريب ↢ يعطيك طاقه كل 20 دقيقة\n\n⌯ مباره وديه ↢ تلعب مباره وديه مع نادي في فوز ، خساره او تعادل؜\n\n⌯ مباره ↢ بالرد تلعب مع شخص مباره في فوز ، تعادل او خساره الاقوى راح يفوز\n\n⌯ شراء لاعب ↢ تشتري لاعب لناديك\n\n⌯ بيع لاعب ↢ تبيع لاعب من ناديك\n\n⌯ تغيير لقب النادي ↢ يغير لقب ناديك\n\n⌯ توب النوادي ↢ اعلى 10 نوادي باللعبة\n✧","md",true)
end
if text == "توب نادي" or text == "توب النادي" or text == "توب النوادي" or text == "توب نوادي" then

local bank_users = Redis:smembers(TheMero.."ownernade")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد نوادي","md",true)
end
top_monyd = "⇜ توب اعلى 10 نوادي :\n\n"
mony_listd = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."nokatnade"..v) or 0
table.insert(mony_listd, {tonumber(mony) , v})
end
table.sort(mony_listd, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)"
}
for k,v in pairs(mony_listd) do
if num <= 10 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
tt = tt:gsub("🇾🇪️",'')
tt = tt:gsub("🇹🇳",'')
tt = tt:gsub("🇸🇾",'')
tt = tt:gsub("🇸🇩",'')
tt = tt:gsub("🇸🇦",'')
tt = tt:gsub("🇶🇦",'')
tt = tt:gsub("🇵🇸",'')
tt = tt:gsub("🇴🇲",'')
tt = tt:gsub("🇲🇦",'')
tt = tt:gsub("🇱🇾",'')
tt = tt:gsub("🇱🇧",'')
tt = tt:gsub("🇰🇼️",'')
tt = tt:gsub("🇯🇴",'')
tt = tt:gsub("🇮🇶",'')
tt = tt:gsub("🇪🇬",'')
tt = tt:gsub("🇧🇭",'')
tt = tt:gsub("🇩🇿️",'')
tt = tt:gsub("🇦🇪",'')
tt = tt:gsub("@[%a%d_]+",'')
tt = tt:gsub("#[%a%d_]+",'')
local kk = Redis:get(TheMero.."lkbnade"..v[2])
kk = kk:gsub("🇾🇪️",'')
kk = kk:gsub("🇹🇳",'')
kk = kk:gsub("🇸🇾",'')
kk = kk:gsub("🇸🇩",'')
kk = kk:gsub("🇸🇦",'')
kk = kk:gsub("🇶🇦",'')
kk = kk:gsub("🇵🇸",'')
kk = kk:gsub("🇴🇲",'')
kk = kk:gsub("🇲🇦",'')
kk = kk:gsub("🇱🇾",'')
kk = kk:gsub("🇱🇧",'')
kk = kk:gsub("🇰🇼️",'')
kk = kk:gsub("🇯🇴",'')
kk = kk:gsub("🇮🇶",'')
kk = kk:gsub("🇪🇬",'')
kk = kk:gsub("🇧🇭",'')
kk = kk:gsub("🇩🇿️",'')
kk = kk:gsub("🇦🇪",'')
kk = kk:gsub("@[%a%d_]+",'')
kk = kk:gsub("#[%a%d_]+",'')
local doltebank = Redis:get(TheMero.."doltebank"..v[2]) or " "
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_monyd = top_monyd..emo.." "..gflos.."  l "..kk.." ( "..tt.." "..doltebank.." ) \n"
gg = " ━━━━━━━━━\n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_monyd..gg,"md",false, false, false, false, reply_markup)
end
if text == 'انشاء نادي' or text == 'بناء نادي' then
send(msg.chat_id,msg.id, "⇜ ارسل انشاء نادي + الاسم\n⇜ مثال : انشاء نادي الفتوة\n✧","md",true)
end
if text and text:match('انشاء نادي (.*)') or text and text:match('بناء نادي (.*)') then

local Cnamed = text:match('انشاء نادي (.*)') or text:match('بناء نادي (.*)')
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if Redis:get(TheMero.."namenade"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ لديك نادي مسبقاً ","md",true)
end
if Redis:sismember(TheMero.."lkbnadesadd", Cnamed) then
return send(msg.chat_id,msg.id, "⇜ الاسم موجود مسبقاً\n⇜ اختر اسم اخر\n✧","md",true)
end
Redis:set(TheMero.."lkbnade"..(_bank_uid), Cnamed)
msgnade = '⇜ اختر النادي : ⚽️\n✧'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'ريال مدريد', data = (_bank_uid)..'/realm'},{text = 'برشلونة', data = (_bank_uid)..'/barca'},{text = 'تشيلسي', data = (_bank_uid)..'/chels'},
},
{
{text = 'مانشستر يونايتد', data = (_bank_uid)..'/manun'},{text = 'ليفربول', data = (_bank_uid)..'/livb'},{text = 'انتر ميلان', data = (_bank_uid)..'/intmi'},
},
{
{text = 'مانشستر سيتي', data = (_bank_uid)..'/manci'},{text = 'يوفنتس', data = (_bank_uid)..'/juvin'},{text = 'ارسنال', data = (_bank_uid)..'/arsi'}, 
},
{
{text = 'روبـي 🪄',url="t.me/FvvZv"}, 
},
}
}
return send(msg.chat_id,msg.id,msgnade,"md",false, false, false, false, reply_markup)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مسح نادي' or text == 'مسح النادي' or text == 'مسح ناديي' or text == 'مسح فريقي' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
namfra = Redis:get(TheMero.."lkbnade"..(_bank_uid))
Redis:del(TheMero.."namenade"..(_bank_uid))
Redis:del(TheMero.."nokatnade"..(_bank_uid))
Redis:del(TheMero.."energynade"..(_bank_uid))
Redis:del(TheMero.."traningnade"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."1"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."2"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."3"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."4"..(_bank_uid))
Redis:del(TheMero.."nameplayer".."5"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."1"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."2"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."3"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."4"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."5"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."1"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."2"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."3"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."4"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."5"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."1"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."2"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."3"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."4"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."5"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."1"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."2"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."3"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."4"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."5"..(_bank_uid))
Redis:srem(TheMero.."lkbnadesadd", namfra)
Redis:srem(TheMero.."ownernade",(_bank_uid))
Redis:del(TheMero.."lkbnade"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم مسح النادي الخاص بك","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'تدريب' or text == 'التدريب' or text == 'تدريب نادي' or text == 'تدريب ناديي' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
if Redis:ttl(TheMero.."traningnade" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."traningnade" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ تستطيع تدريب النادي الخاص بك بعد "..time.." ","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
namenade = Redis:get(TheMero.."namenade"..(_bank_uid))
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
lkbnade = Redis:get(TheMero.."lkbnade"..(_bank_uid))
namenade = Redis:get(TheMero.."namenade"..(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid))
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid))
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid))
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid))
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid))
if tonumber(energynade) < 151 then
Redis:incrby(TheMero.."energynade"..(_bank_uid),1)
end
if energyplayer1 then
if tonumber(energyplayer1) < 151 then
Redis:incrby(TheMero.."energyplayer".."1"..(_bank_uid),1)
end
end
if energyplayer2 then
if tonumber(energyplayer2) < 151 then
Redis:incrby(TheMero.."energyplayer".."2"..(_bank_uid),1)
end
end
if energyplayer3 then
if tonumber(energyplayer3) < 151 then
Redis:incrby(TheMero.."energyplayer".."3"..(_bank_uid),1)
end
end
if energyplayer4 then
if tonumber(energyplayer4) < 151 then
Redis:incrby(TheMero.."energyplayer".."4"..(_bank_uid),1)
end
end
if energyplayer5 then
if tonumber(energyplayer5) < 151 then
Redis:incrby(TheMero.."energyplayer".."5"..(_bank_uid),1)
end
end
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
Redis:setex(TheMero.."traningnade" .. (_bank_uid),1800, true)
send(msg.chat_id,msg.id, "⌯ تم تدريب النادي الخاص بك "..news.."\n⇜ اسم النادي : "..namenade.."\n⇜ لقب النادي : "..lkbnade.."\n⇜ طاقة النادي : "..energynade.."\n⇜ اكتب ( `ناديي` ) لمعرفة طاقات لاعبينك  ","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'تغير لقب النادي' or text == 'تغيير لقب النادي' or text == 'تغيير لقب نادي' or text == 'تغير لقب نادي' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballance) < tonumber(25000) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تغيير اللقب فلوسك ماتكفي","md",true)
end
Redis:setex(TheMero.."changlkbnade" .. msg.chat_id .. ":" .. (_bank_uid),60, true)
send(msg.chat_id,msg.id,"⇜ ارسل اللقب الجديد\n⇜ للالغاء ارسل ( `الغاء الامر` )\n✧","md",true)  
return false
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if Redis:get(TheMero.."changlkbnade" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."changlkbnade" .. msg.chat_id .. ":" .. (_bank_uid)) 
if text == "الغاء" or text == "الغاء الامر" then
return send(msg.chat_id,msg.id, "⇜ تم الغاء امر تغيير لقب النادي","md",true)
end
if Redis:sismember(TheMero.."lkbnadesadd", text) then
return send(msg.chat_id,msg.id, "⇜ الاسم موجود مسبقاً\n⇜ اختر اسم اخر\n✧","md",true)
end
namfra = Redis:get(TheMero.."lkbnade"..(_bank_uid))
Redis:srem(TheMero.."lkbnadesadd", namfra)
Redis:del(TheMero.."lkbnade"..(_bank_uid))
Redis:set(TheMero.."lkbnade"..(_bank_uid), text)
Redis:sadd(TheMero.."lkbnadesadd", text)
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
cccallcc = tonumber(ballance) - 25000
Redis:set(TheMero.."boob"..(_bank_uid),cccallcc)
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballance)
send(msg.chat_id,msg.id, "⇜ تم تغيير لقب ناديك\n\n⇜ اللقب الجديد : "..text.."\n⇜ سعر تغيير اللقب : 25000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
end
if text == 'عرض لاعب' or text == 'بيع لاعب' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
nameplayer1 = Redis:get(TheMero.."nameplayer".."1"..(_bank_uid))
nameplayer2 = Redis:get(TheMero.."nameplayer".."2"..(_bank_uid))
nameplayer3 = Redis:get(TheMero.."nameplayer".."3"..(_bank_uid))
nameplayer4 = Redis:get(TheMero.."nameplayer".."4"..(_bank_uid))
nameplayer5 = Redis:get(TheMero.."nameplayer".."5"..(_bank_uid))
if nameplayer1 then
mrkzplayer1 = Redis:get(TheMero.."mrkzplayer".."1"..(_bank_uid))
cityplayer1 = Redis:get(TheMero.."cityplayer".."1"..(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid))
priceplayer1 = Redis:get(TheMero.."priceplayer".."1"..(_bank_uid))
nameplayer1done = "⌯ اسم اللاعب : `"..nameplayer1.."`\n- مركزه : "..mrkzplayer1.."\n- طاقة اللاعب : "..energyplayer1.."\n- الجنسية : "..cityplayer1.."\n- السعر : "..priceplayer1.."\n\n"
else
nameplayer1done = ""
end
if nameplayer2 then
mrkzplayer2 = Redis:get(TheMero.."mrkzplayer".."2"..(_bank_uid))
cityplayer2 = Redis:get(TheMero.."cityplayer".."2"..(_bank_uid))
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid))
priceplayer2 = Redis:get(TheMero.."priceplayer".."2"..(_bank_uid))
nameplayer2done = "⌯ اسم اللاعب : `"..nameplayer2.."`\n- مركزه : "..mrkzplayer2.."\n- طاقة اللاعب : "..energyplayer2.."\n- الجنسية : "..cityplayer2.."\n- السعر : "..priceplayer2.."\n\n"
else
nameplayer2done = ""
end
if nameplayer3 then
mrkzplayer3 = Redis:get(TheMero.."mrkzplayer".."3"..(_bank_uid))
cityplayer3 = Redis:get(TheMero.."cityplayer".."3"..(_bank_uid))
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid))
priceplayer3 = Redis:get(TheMero.."priceplayer".."3"..(_bank_uid))
nameplayer3done = "⌯ اسم اللاعب : `"..nameplayer3.."`\n- مركزه : "..mrkzplayer3.."\n- طاقة اللاعب : "..energyplayer3.."\n- الجنسية : "..cityplayer3.."\n- السعر : "..priceplayer3.."\n\n"
else
nameplayer3done = ""
end
if nameplayer4 then
mrkzplayer4 = Redis:get(TheMero.."mrkzplayer".."4"..(_bank_uid))
cityplayer4 = Redis:get(TheMero.."cityplayer".."4"..(_bank_uid))
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid))
priceplayer4 = Redis:get(TheMero.."priceplayer".."4"..(_bank_uid))
nameplayer4done = "⌯ اسم اللاعب : `"..nameplayer4.."`\n- مركزه : "..mrkzplayer4.."\n- طاقة اللاعب : "..energyplayer4.."\n- الجنسية : "..cityplayer4.."\n- السعر : "..priceplayer4.."\n\n"
else
nameplayer4done = ""
end
if nameplayer5 then
mrkzplayer5 = Redis:get(TheMero.."mrkzplayer".."5"..(_bank_uid))
cityplayer5 = Redis:get(TheMero.."cityplayer".."5"..(_bank_uid))
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid))
priceplayer5 = Redis:get(TheMero.."priceplayer".."5"..(_bank_uid))
nameplayer5done = "⌯ اسم اللاعب : `"..nameplayer5.."`\n- مركزه : "..mrkzplayer5.."\n- طاقة اللاعب : "..energyplayer5.."\n- الجنسية : "..cityplayer5.."\n- السعر : "..priceplayer5.."\n\n"
else
nameplayer5done = ""
end
if not nameplayer1 and not nameplayer2 and not nameplayer3 and not nameplayer4 and not nameplayer5 then
return send(msg.chat_id,msg.id, "⇜ لا يوجد لديك لاعبين\n⇜ تستطيع شراء لاعب بالامر ( `شراء لاعب` )","md",true)
end
Redis:setex(TheMero.."shoplyname" .. msg.chat_id .. ":" .. (_bank_uid),60, true)
send(msg.chat_id,msg.id,"⇜ ارسل اسم اللاعب فقط\n\n"..nameplayer1done..""..nameplayer2done..""..nameplayer3done..""..nameplayer4done..""..nameplayer5done.."\n\n⇜ اضغط لنسخ الاسم\n⇜ للالغاء ارسل ( `الغاء الامر` )\n✧","md",true)  
return false
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if Redis:get(TheMero.."shoplyname" .. msg.chat_id .. ":" .. (_bank_uid)) then
Redis:del(TheMero.."shoplyname" .. msg.chat_id .. ":" .. (_bank_uid)) 
if text == "الغاء" or text == "الغاء الامر" then
return send(msg.chat_id,msg.id, "⇜ تم الغاء امر بيع اللاعب","md",true)
end
nameplayer1 = Redis:get(TheMero.."nameplayer".."1"..(_bank_uid))
nameplayer2 = Redis:get(TheMero.."nameplayer".."2"..(_bank_uid))
nameplayer3 = Redis:get(TheMero.."nameplayer".."3"..(_bank_uid))
nameplayer4 = Redis:get(TheMero.."nameplayer".."4"..(_bank_uid))
nameplayer5 = Redis:get(TheMero.."nameplayer".."5"..(_bank_uid))
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if text == nameplayer1 then
priceplayer1 = Redis:get(TheMero.."priceplayer".."1"..(_bank_uid))
pricetotaly = ballance + tonumber(priceplayer1)
Redis:set(TheMero.."boob"..(_bank_uid),pricetotaly)
Redis:del(TheMero.."nameplayer".."1"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."1"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."1"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."1"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."1"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم بيع اللاعب","md",true)
elseif text == nameplayer2 then
priceplayer2 = Redis:get(TheMero.."priceplayer".."2"..(_bank_uid))
pricetotaly = ballance + tonumber(priceplayer2)
Redis:set(TheMero.."boob"..(_bank_uid),pricetotaly)
Redis:del(TheMero.."nameplayer".."2"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."2"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."2"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."2"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."2"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم بيع اللاعب","md",true)
elseif text == nameplayer3 then
priceplayer3 = Redis:get(TheMero.."priceplayer".."3"..(_bank_uid))
pricetotaly = ballance + tonumber(priceplayer3)
Redis:set(TheMero.."boob"..(_bank_uid),pricetotaly)
Redis:del(TheMero.."nameplayer".."3"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."3"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."3"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."3"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."3"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم بيع اللاعب","md",true)
elseif text == nameplayer4 then
priceplayer4 = Redis:get(TheMero.."priceplayer".."4"..(_bank_uid))
pricetotaly = ballance + tonumber(priceplayer4)
Redis:set(TheMero.."boob"..(_bank_uid),pricetotaly)
Redis:del(TheMero.."nameplayer".."4"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."4"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."4"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."4"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."4"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم بيع اللاعب","md",true)
elseif text == nameplayer5 then
priceplayer5 = Redis:get(TheMero.."priceplayer".."5"..(_bank_uid))
pricetotaly = ballance + tonumber(priceplayer5)
Redis:set(TheMero.."boob"..(_bank_uid),pricetotaly)
Redis:del(TheMero.."nameplayer".."5"..(_bank_uid))
Redis:del(TheMero.."energyplayer".."5"..(_bank_uid))
Redis:del(TheMero.."mrkzplayer".."5"..(_bank_uid))
Redis:del(TheMero.."cityplayer".."5"..(_bank_uid))
Redis:del(TheMero.."priceplayer".."5"..(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم بيع اللاعب","md",true)
else
send(msg.chat_id,msg.id, "⇜ اسم اللاعب خطأ !!","md",true)
end
end
if text == 'ناديي' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n⇜ ( `انشاء نادي` ) والاسم","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
namenade = Redis:get(TheMero.."namenade"..(_bank_uid))
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
lkbnade = Redis:get(TheMero.."lkbnade"..(_bank_uid))
nokatnade = Redis:get(TheMero.."nokatnade"..(_bank_uid)) or 0
nameplayer1 = Redis:get(TheMero.."nameplayer".."1"..(_bank_uid))
nameplayer2 = Redis:get(TheMero.."nameplayer".."2"..(_bank_uid))
nameplayer3 = Redis:get(TheMero.."nameplayer".."3"..(_bank_uid))
nameplayer4 = Redis:get(TheMero.."nameplayer".."4"..(_bank_uid))
nameplayer5 = Redis:get(TheMero.."nameplayer".."5"..(_bank_uid))
if nameplayer1 then
mrkzplayer1 = Redis:get(TheMero.."mrkzplayer".."1"..(_bank_uid))
cityplayer1 = Redis:get(TheMero.."cityplayer".."1"..(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid))
nameplayer1done = "⌯ اسم اللاعب : "..nameplayer1.."\n- مركزه : "..mrkzplayer1.."\n- طاقة اللاعب : "..energyplayer1.."\n- الجنسية : "..cityplayer1.."\n\n"
else
nameplayer1done = ""
end
if nameplayer2 then
mrkzplayer2 = Redis:get(TheMero.."mrkzplayer".."2"..(_bank_uid))
cityplayer2 = Redis:get(TheMero.."cityplayer".."2"..(_bank_uid))
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid))
nameplayer2done = "⌯ اسم اللاعب : "..nameplayer2.."\n- مركزه : "..mrkzplayer2.."\n- طاقة اللاعب : "..energyplayer2.."\n- الجنسية : "..cityplayer2.."\n\n"
else
nameplayer2done = ""
end
if nameplayer3 then
mrkzplayer3 = Redis:get(TheMero.."mrkzplayer".."3"..(_bank_uid))
cityplayer3 = Redis:get(TheMero.."cityplayer".."3"..(_bank_uid))
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid))
nameplayer3done = "⌯ اسم اللاعب : "..nameplayer3.."\n- مركزه : "..mrkzplayer3.."\n- طاقة اللاعب : "..energyplayer3.."\n- الجنسية : "..cityplayer3.."\n\n"
else
nameplayer3done = ""
end
if nameplayer4 then
mrkzplayer4 = Redis:get(TheMero.."mrkzplayer".."4"..(_bank_uid))
cityplayer4 = Redis:get(TheMero.."cityplayer".."4"..(_bank_uid))
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid))
nameplayer4done = "⌯ اسم اللاعب : "..nameplayer4.."\n- مركزه : "..mrkzplayer4.."\n- طاقة اللاعب : "..energyplayer4.."\n- الجنسية : "..cityplayer4.."\n\n"
else
nameplayer4done = ""
end
if nameplayer5 then
mrkzplayer5 = Redis:get(TheMero.."mrkzplayer".."5"..(_bank_uid))
cityplayer5 = Redis:get(TheMero.."cityplayer".."5"..(_bank_uid))
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid))
nameplayer5done = "⌯ اسم اللاعب : "..nameplayer5.."\n- مركزه : "..mrkzplayer5.."\n- طاقة اللاعب : "..energyplayer5.."\n- الجنسية : "..cityplayer5.."\n\n"
else
nameplayer5done = ""
end
if not nameplayer1 and not nameplayer2 and not nameplayer3 and not nameplayer4 and not nameplayer5 then
send(msg.chat_id,msg.id, "⌯ صاحب النادي "..news.."\n⇜ اسم النادي : "..namenade.."\n⇜ لقب النادي : "..lkbnade.."\n⇜ طاقة النادي : "..energynade.."\n⇜ نقاط النادي : "..nokatnade.."\n\n⇜ لا يوجد لديك لاعبين\n━━━━━━━━━\n\n⇜ شراء لاعب بالامر ( `شراء لاعب` )\n⇜ `بيع لاعب` \n⇜ تدريب ناديك بالامر ( `تدريب` )\n⇜ مباره وديه بالامر ( `مباره وديه` )\n⇜ مباره ضد لاعب بالامر ( `مباره` بالرد )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⌯ صاحب النادي "..news.."\n⇜ اسم النادي : "..namenade.."\n⇜ لقب النادي : "..lkbnade.."\n⇜ طاقة النادي : "..energynade.."\n⇜ نقاط النادي : "..nokatnade.."\n\n⇜ لاعبين النادي :\n\n"..nameplayer1done..""..nameplayer2done..""..nameplayer3done..""..nameplayer4done..""..nameplayer5done.."\n━━━━━━━━━\n\n⇜ شراء لاعب بالامر ( `شراء لاعب` )\n⇜ تدريب ناديك بالامر ( `تدريب` )\n⇜ مباره وديه بالامر ( `مباره وديه` )\n⇜ مباره عادية بالامر ( `مباره` )\n ✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'ناديه' and tonumber(msg.reply_to_message_id) ~= 0 then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها نادي ","md",true)
return false
end
if not Redis:get(TheMero.."namenade" .. Re(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعنده نادي","md",true)
end
local ban = bot.getUser(Re(_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
namenade = Redis:get(TheMero.."namenade"..Re(_bank_uid))
energynade = Redis:get(TheMero.."energynade"..Re(_bank_uid))
lkbnade = Redis:get(TheMero.."lkbnade"..Re(_bank_uid))
nokatnade = Redis:get(TheMero.."nokatnade"..Re(_bank_uid)) or 0
nameplayer1 = Redis:get(TheMero.."nameplayer".."1"..Re(_bank_uid))
nameplayer2 = Redis:get(TheMero.."nameplayer".."2"..Re(_bank_uid))
nameplayer3 = Redis:get(TheMero.."nameplayer".."3"..Re(_bank_uid))
nameplayer4 = Redis:get(TheMero.."nameplayer".."4"..Re(_bank_uid))
nameplayer5 = Redis:get(TheMero.."nameplayer".."5"..Re(_bank_uid))
if nameplayer1 then
mrkzplayer1 = Redis:get(TheMero.."mrkzplayer".."1"..Re(_bank_uid))
cityplayer1 = Redis:get(TheMero.."cityplayer".."1"..Re(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..Re(_bank_uid))
nameplayer1done = "⌯ اسم اللاعب : "..nameplayer1.."\n- مركزه : "..mrkzplayer1.."\n- طاقة اللاعب : "..energyplayer1.."\n- الجنسية : "..cityplayer1.."\n\n"
else
nameplayer1done = ""
end
if nameplayer2 then
mrkzplayer2 = Redis:get(TheMero.."mrkzplayer".."2"..Re(_bank_uid))
cityplayer2 = Redis:get(TheMero.."cityplayer".."2"..Re(_bank_uid))
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..Re(_bank_uid))
nameplayer2done = "⌯ اسم اللاعب : "..nameplayer2.."\n- مركزه : "..mrkzplayer2.."\n- طاقة اللاعب : "..energyplayer2.."\n- الجنسية : "..cityplayer2.."\n\n"
else
nameplayer2done = ""
end
if nameplayer3 then
mrkzplayer3 = Redis:get(TheMero.."mrkzplayer".."3"..Re(_bank_uid))
cityplayer3 = Redis:get(TheMero.."cityplayer".."3"..Re(_bank_uid))
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..Re(_bank_uid))
nameplayer3done = "⌯ اسم اللاعب : "..nameplayer3.."\n- مركزه : "..mrkzplayer3.."\n- طاقة اللاعب : "..energyplayer3.."\n- الجنسية : "..cityplayer3.."\n\n"
else
nameplayer3done = ""
end
if nameplayer4 then
mrkzplayer4 = Redis:get(TheMero.."mrkzplayer".."4"..Re(_bank_uid))
cityplayer4 = Redis:get(TheMero.."cityplayer".."4"..Re(_bank_uid))
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..Re(_bank_uid))
nameplayer4done = "⌯ اسم اللاعب : "..nameplayer4.."\n- مركزه : "..mrkzplayer4.."\n- طاقة اللاعب : "..energyplayer4.."\n- الجنسية : "..cityplayer4.."\n\n"
else
nameplayer4done = ""
end
if nameplayer5 then
mrkzplayer5 = Redis:get(TheMero.."mrkzplayer".."5"..Re(_bank_uid))
cityplayer5 = Redis:get(TheMero.."cityplayer".."5"..Re(_bank_uid))
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..Re(_bank_uid))
nameplayer5done = "⌯ اسم اللاعب : "..nameplayer5.."\n- مركزه : "..mrkzplayer5.."\n- طاقة اللاعب : "..energyplayer5.."\n- الجنسية : "..cityplayer5.."\n\n"
else
nameplayer5done = ""
end
if not nameplayer1 and not nameplayer2 and not nameplayer3 and not nameplayer4 and not nameplayer5 then
send(msg.chat_id,msg.id, "⌯ صاحب النادي "..news.."\n⇜ اسم النادي : "..namenade.."\n⇜ لقب النادي : "..lkbnade.."\n⇜ طاقة النادي : "..energynade.."\n⇜ نقاط النادي : "..nokatnade.."\n\n⇜ لا يوجد لديه لاعبين\n✧","md",true)
else
send(msg.chat_id,msg.id, "⌯ صاحب النادي "..news.."\n⇜ اسم النادي : "..namenade.."\n⇜ لقب النادي : "..lkbnade.."\n⇜ طاقة النادي : "..energynade.."\n⇜ نقاط النادي : "..nokatnade.."\n\n⇜ لاعبين النادي :\n\n"..nameplayer1done..""..nameplayer2done..""..nameplayer3done..""..nameplayer4done..""..nameplayer5done.."\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مباره وديه' or text == 'مبارة ودية' or text == 'مباره ودية' or text == 'مبارة وديه' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
if Redis:ttl(TheMero.."matchode" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."matchode" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ تستطيع لعب مبارة وديه بعد "..time.." ","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
namenade = Redis:get(TheMero.."namenade"..(_bank_uid))
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid)) or 0
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid)) or 0
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid)) or 0
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid)) or 0
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid)) or 0
energymynade = tonumber(energynade) + tonumber(energyplayer1) + tonumber(energyplayer2) + tonumber(energyplayer3) + tonumber(energyplayer4) + tonumber(energyplayer5)
local energybott = {"50", "100", "150", "200", "250", "300", "350", "400", "450", "0", "25", "70", "125",}
local energybot = energybott[math.random(#energybott)]
local resultt = {"0 - 1", "0 - 2", "0 - 3", "0 - 4", "0 - 5", "1 - 2", "1 - 3", "1 - 4", "1 - 5", "2 - 3", "2 - 4", "2 - 5", "3 - 4", "3 - 5", "4 - 5", "5 - 6",}
local result = resultt[math.random(#resultt)]
local tadoll = {"0 - 0", "1 - 1", "2 - 2", "3 - 3", "4 - 4", "5 - 5",}
local tadol = tadoll[math.random(#tadoll)]
local nadebott = {"اشبيلية", "ريفر بلايت", "ريفر بلايت", "بوروسيا", "أياكس الهولندي", "ليون", "شاختار دونيتسك", "روما", "فياريال", "بوكا جونيورز", "نابولي", "بنفيكا", "فلامنجو", "ليستر سيتي", "بالمرسي", "ليل", "ريال سوسيداد", "ايندهوفن", "الأهلي المصري", "الهلال السعودي", "الاتحاد السعودي",}
local nadebot = nadebott[math.random(#nadebott)]
if energymynade > tonumber(energybot) then
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
cccallcc = tonumber(ballance) + 500000
Redis:set(TheMero.."boob"..(_bank_uid),cccallcc)
Redis:incrby(TheMero.."energynade"..(_bank_uid),1)
Redis:incrby(TheMero.."nokatnade"..(_bank_uid),1)
Redis:setex(TheMero.."matchode" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⌯ لقد فزت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..nadebot.."\n⇜ النتيجة : "..result.."\n⇜ تم زيادة نقطة لطاقة ناديك\n✧","md",true)
elseif energymynade < tonumber(energybot) then
Redis:decrby(TheMero.."energynade"..(_bank_uid),1)
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
if tonumber(energynade) < 0 then
Redis:set(TheMero.."energynade"..(_bank_uid),0)
end
Redis:decrby(TheMero.."nokatnade"..(_bank_uid),1)
nokatnade = Redis:get(TheMero.."nokatnade"..(_bank_uid))
if tonumber(nokatnade) < 0 then
Redis:set(TheMero.."nokatnade"..(_bank_uid),0)
end
Redis:setex(TheMero.."matchode" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⌯ لقد خسرت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..nadebot.."\n⇜ النتيجة : "..result.."\n⇜ خسرت نقطة من طاقة ناديك\n✧","md",true)
else
Redis:setex(TheMero.."matchode" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⌯ لقد تعادلت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..nadebot.."\n⇜ النتيجة : "..tadol.."\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مباره' or text == 'مبارة' or text == 'لعب مبارة' or text == 'لعب مباره' and tonumber(msg.reply_to_message_id) ~= 0 then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."namenade" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك نادي اصلاً\n⇜ قم بانشاء النادي الخاص بك عن طريق الامر \n( `انشاء نادي` ) والاسم","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها نادي ","md",true)
return false
end
if Re(_bank_uid) == (_bank_uid) then
send(msg.chat_id,msg.id,"\n⇜ بدك تلعب مبارة مع نفسك 🤡","md",true)  
return false
end
if not Redis:get(TheMero.."namenade" .. Re(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ خصمك ماعنده نادي ","md",true)
end
if Redis:ttl(TheMero.."matchplayer" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."matchplayer" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ تستطيع لعب مبارة بعد "..time.." ","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
namenade = Redis:get(TheMero.."namenade"..(_bank_uid))
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid)) or 0
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid)) or 0
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid)) or 0
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid)) or 0
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid)) or 0
energymynade = tonumber(energynade) + tonumber(energyplayer1) + tonumber(energyplayer2) + tonumber(energyplayer3) + tonumber(energyplayer4) + tonumber(energyplayer5)

namenadevs = Redis:get(TheMero.."namenade"..Re(_bank_uid))
energynadevs = Redis:get(TheMero.."energynade"..Re(_bank_uid))
energyplayer1vs = Redis:get(TheMero.."energyplayer".."1"..Re(_bank_uid)) or 0
energyplayer2vs = Redis:get(TheMero.."energyplayer".."2"..Re(_bank_uid)) or 0
energyplayer3vs = Redis:get(TheMero.."energyplayer".."3"..Re(_bank_uid)) or 0
energyplayer4vs = Redis:get(TheMero.."energyplayer".."4"..Re(_bank_uid)) or 0
energyplayer5vs = Redis:get(TheMero.."energyplayer".."5"..Re(_bank_uid)) or 0
energymynadevs = tonumber(energynadevs) + tonumber(energyplayer1vs) + tonumber(energyplayer2vs) + tonumber(energyplayer3vs) + tonumber(energyplayer4vs) + tonumber(energyplayer5vs)
local resultt = {"0 - 1", "0 - 2", "0 - 3", "0 - 4", "0 - 5", "1 - 2", "1 - 3", "1 - 4", "1 - 5", "2 - 3", "2 - 4", "2 - 5", "3 - 4", "3 - 5", "4 - 5", "5 - 6",}
local result = resultt[math.random(#resultt)]
local tadoll = {"0 - 0", "1 - 1", "2 - 2", "3 - 3", "4 - 4", "5 - 5",}
local tadol = tadoll[math.random(#tadoll)]
if energymynade > energymynadevs then
Redis:incrby(TheMero.."energynade"..(_bank_uid),1)
Redis:incrby(TheMero.."nokatnade"..(_bank_uid),1)
if energyplayer1 then
Redis:incrby(TheMero.."energyplayer".."1"..(_bank_uid),1)
end
if energyplayer2 then
Redis:incrby(TheMero.."energyplayer".."2"..(_bank_uid),1)
end
if energyplayer3 then
Redis:incrby(TheMero.."energyplayer".."3"..(_bank_uid),1)
end
if energyplayer4 then
Redis:incrby(TheMero.."energyplayer".."4"..(_bank_uid),1)
end
if energyplayer5 then
Redis:incrby(TheMero.."energyplayer".."5"..(_bank_uid),1)
end
Redis:decrby(TheMero.."energynade"..Re(_bank_uid),1)
energynadevs = Redis:get(TheMero.."energynade"..Re(_bank_uid))
if tonumber(energynadevs) < 0 then
Redis:set(TheMero.."energynade"..Re(_bank_uid),0)
end
if energyplayer1vs then
Redis:decrby(TheMero.."energyplayer".."1"..Re(_bank_uid),1)
end
energyplayer1vs = Redis:get(TheMero.."energyplayer".."1"..Re(_bank_uid))
if tonumber(energyplayer1vs) < 0 then
Redis:set(TheMero.."energyplayer".."1"..Re(_bank_uid),0)
end
if energyplayer2vs then
Redis:decrby(TheMero.."energyplayer".."2"..Re(_bank_uid),1)
end
energyplayer2vs = Redis:get(TheMero.."energyplayer".."2"..Re(_bank_uid))
if tonumber(energyplayer2vs) < 0 then
Redis:set(TheMero.."energyplayer".."2"..Re(_bank_uid),0)
end
if energyplayer3vs then
Redis:decrby(TheMero.."energyplayer".."3"..Re(_bank_uid),1)
end
energyplayer3vs = Redis:get(TheMero.."energyplayer".."3"..Re(_bank_uid))
if tonumber(energyplayer3vs) < 0 then
Redis:set(TheMero.."energyplayer".."3"..Re(_bank_uid),0)
end
if energyplayer4vs then
Redis:decrby(TheMero.."energyplayer".."4"..Re(_bank_uid),1)
end
energyplayer4vs = Redis:get(TheMero.."energyplayer".."4"..Re(_bank_uid))
if tonumber(energyplayer4vs) < 0 then
Redis:set(TheMero.."energyplayer".."4"..Re(_bank_uid),0)
end
if energyplayer5vs then
Redis:decrby(TheMero.."energyplayer".."5"..Re(_bank_uid),1)
end
energyplayer5vs = Redis:get(TheMero.."energyplayer".."5"..Re(_bank_uid))
if tonumber(energyplayer5vs) < 0 then
Redis:set(TheMero.."energyplayer".."5"..Re(_bank_uid),0)
end
Redis:decrby(TheMero.."nokatnade"..Re(_bank_uid),1)
nokatnadevs = Redis:get(TheMero.."nokatnade"..Re(_bank_uid))
if tonumber(nokatnadevs) < 0 then
Redis:set(TheMero.."nokatnade"..Re(_bank_uid),0)
end
Redis:setex(TheMero.."matchplayer" .. (_bank_uid),1200, true)
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
cccallcc = tonumber(ballance) + 1000000
Redis:set(TheMero.."boob"..(_bank_uid),cccallcc)
send(msg.chat_id,msg.id, "⌯ لقد فزت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..namenadevs.."\n⇜ النتيجة : "..result.."\n⇜ الجائزة : 1000000 درهم 💵\n⇜ تم زيادة طاقة ناديك ولاعبينك وانقاصها من الخصم\n✧","md",true)
elseif energymynade < energymynadevs then
Redis:incrby(TheMero.."energynade"..Re(_bank_uid),1)
Redis:incrby(TheMero.."nokatnade"..Re(_bank_uid),1)
if energyplayer1vs then
Redis:incrby(TheMero.."energyplayer".."1"..Re(_bank_uid),1)
end
if energyplayer2vs then
Redis:incrby(TheMero.."energyplayer".."2"..Re(_bank_uid),1)
end
if energyplayer3vs then
Redis:incrby(TheMero.."energyplayer".."3"..Re(_bank_uid),1)
end
if energyplayer4vs then
Redis:incrby(TheMero.."energyplayer".."4"..Re(_bank_uid),1)
end
if energyplayer5vs then
Redis:incrby(TheMero.."energyplayer".."5"..Re(_bank_uid),1)
end
Redis:decrby(TheMero.."energynade"..(_bank_uid),1)
energynade = Redis:get(TheMero.."energynade"..(_bank_uid))
if tonumber(energynade) < 0 then
Redis:set(TheMero.."energynade"..(_bank_uid),0)
end
if energyplayer1 then
Redis:decrby(TheMero.."energyplayer".."1"..(_bank_uid),1)
end
energyplayer1 = Redis:get(TheMero.."energyplayer".."1"..(_bank_uid))
if tonumber(energyplayer1) < 0 then
Redis:set(TheMero.."energyplayer".."1"..(_bank_uid),0)
end
if energyplayer2 then
Redis:decrby(TheMero.."energyplayer".."2"..(_bank_uid),1)
end
energyplayer2 = Redis:get(TheMero.."energyplayer".."2"..(_bank_uid))
if tonumber(energyplayer2) < 0 then
Redis:set(TheMero.."energyplayer".."2"..(_bank_uid),0)
end
if energyplayer3 then
Redis:decrby(TheMero.."energyplayer".."3"..(_bank_uid),1)
end
energyplayer3 = Redis:get(TheMero.."energyplayer".."3"..(_bank_uid))
if tonumber(energyplayer3) < 0 then
Redis:set(TheMero.."energyplayer".."3"..(_bank_uid),0)
end
if energyplayer4 then
Redis:decrby(TheMero.."energyplayer".."4"..(_bank_uid),1)
end
energyplayer4 = Redis:get(TheMero.."energyplayer".."4"..(_bank_uid))
if tonumber(energyplayer4) < 0 then
Redis:set(TheMero.."energyplayer".."4"..(_bank_uid),0)
end
if energyplayer5 then
Redis:decrby(TheMero.."energyplayer".."5"..(_bank_uid),1)
end
energyplayer5 = Redis:get(TheMero.."energyplayer".."5"..(_bank_uid))
if tonumber(energyplayer5) < 0 then
Redis:set(TheMero.."energyplayer".."5"..(_bank_uid),0)
end
Redis:decrby(TheMero.."nokatnade"..(_bank_uid),1)
nokatnade = Redis:get(TheMero.."nokatnade"..(_bank_uid))
if tonumber(nokatnade) < 0 then
Redis:set(TheMero.."nokatnade"..(_bank_uid),0)
end
Redis:setex(TheMero.."matchplayer" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⌯ لقد خسرت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..namenadevs.."\n⇜ النتيجة : "..result.."\n⇜ تم انقاص طاقة ناديك ولاعبينك وزيادتها لدى الخصم\n✧","md",true)
else
Redis:setex(TheMero.."matchplayer" .. (_bank_uid),1200, true)
send(msg.chat_id,msg.id, "⌯ لقد تعادلت بالمبارة "..news.." ⚽️\n⇜ اسم النادي : "..namenade.."\n⇜ نادي الخصم : "..namenadevs.."\n⇜ النتيجة : "..tadol.."\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'شراء لاعب' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if Redis:get(TheMero.."mrkzplayer".."1"..(_bank_uid)) and Redis:get(TheMero.."mrkzplayer".."2"..(_bank_uid)) and Redis:get(TheMero.."mrkzplayer".."3"..(_bank_uid)) and Redis:get(TheMero.."mrkzplayer".."4"..(_bank_uid)) and Redis:get(TheMero.."mrkzplayer".."5"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ النادي الخاص بك مكتمل\n⇜ تستطيع بيع لاعب عن طريق الامر ( بيع لاعب )  ","md",true)
end
if Redis:ttl(TheMero.."buyplayer" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."buyplayer" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ تستطيع شراء لاعب بعد "..time.." ","md",true)
end
Redis:setex(TheMero.."buyplayer" .. (_bank_uid),900, true)
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
msgplayer = "⇜ الاسم : روبي سواريز\n⇜ مركزه : مهاجم ايمن\n⇜ طاقة اللاعب : 83\n⇜ الجنسية : اوكرانيا 🇺🇦\n⇜ سعر اللاعب : 39000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/luisyes'},{text = 'لا', data = (_bank_uid)..'/luisno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "2" then
msgplayer = "⇜ الاسم : داني الفيش \n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 83\n⇜ الجنسية : البرازيل 🇧🇷 \n⇜ سعر اللاعب : 50000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/danyes'},{text = 'لا', data = (_bank_uid)..'/danno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "3" then
msgplayer = "⇜ الاسم : فيل فودن\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 70000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/fdnyes'},{text = 'لا', data = (_bank_uid)..'/fdnno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "4" then
msgplayer = "⇜ الاسم : رافيل فاران\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : فرنسا 🇫🇷\n⇜ سعر اللاعب : 40000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/rafyes'},{text = 'لا', data = (_bank_uid)..'/rafno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "5" then
msgplayer = "⇜ الاسم : خوان ماتا\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 81\n⇜ الجنسية : إسبانيا 🇪🇸\n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/kuanyes'},{text = 'لا', data = (_bank_uid)..'/kuanno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "6" then
msgplayer = "⇜ الاسم : هاري ماجواير\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 80\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 15000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/hariyes'},{text = 'لا', data = (_bank_uid)..'/harino'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "7" then
msgplayer = "⇜ الاسم : روميلو لوكاكو\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 90\n⇜ الجنسية : بلجيكا 🇧🇪 󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 100000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/romoyes'},{text = 'لا', data = (_bank_uid)..'/romono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "8" then
msgplayer = "⇜ الاسم : تياجو سيلفا \n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 81\n⇜ الجنسية : البرازيل 🇧🇷 \n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/tiagoyes'},{text = 'لا', data = (_bank_uid)..'/tiagono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "9" then
msgplayer = "⇜ الاسم : جيرارد بيكيه\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 83\n⇜ الجنسية : إسبانيا 🇪🇸\n⇜ سعر اللاعب : 30000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/gerardyes'},{text = 'لا', data = (_bank_uid)..'/gerardno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "10" then
msgplayer = "⇜ الاسم : تير شتيجن\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 91\n⇜ الجنسية :ألمانيا 🇩🇪\n⇜ سعر اللاعب : 110000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/tyryes'},{text = 'لا', data = (_bank_uid)..'/tyrno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "11" then
msgplayer = "⇜ الاسم : عثمان ديمبلي\n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : فرنسا 🇫🇷\n⇜ سعر اللاعب : 45000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/osmanyes'},{text = 'لا', data = (_bank_uid)..'/osmanno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "12" then
msgplayer = "⇜ الاسم : رودريغو \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : البرازيل 🇧🇷\n⇜ سعر اللاعب : 78000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/rodrigoyes'},{text = 'لا', data = (_bank_uid)..'/rodrigono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "13" then
msgplayer = "⇜ الاسم : ميليتاو \n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : البرازيل 🇧🇷\n⇜ سعر اللاعب : 65000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/milyes'},{text = 'لا', data = (_bank_uid)..'/milno'},

},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "14" then
msgplayer = "⇜ الاسم : ألابا\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 86\n⇜ الجنسيه : النمسا 🇦🇹\n⇜ سعر اللاعب : 73000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/albayes'},{text = 'لا', data = (_bank_uid)..'/albano'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "15" then
msgplayer = "⇜ الاسم : فينيسيوس\n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 94\n⇜ الجنسية : البرازيل 🇧🇷 \n⇜ سعر اللاعب : 180000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/fenesyes'},{text = 'لا', data = (_bank_uid)..'/fenesno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "16" then
msgplayer = "⇜ الاسم : دي ماريا\n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 85\n⇜ الجنسية : الأرجنتين 🇦🇷 \n⇜ سعر اللاعب : 55000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/demayes'},{text = 'لا', data = (_bank_uid)..'/demano'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "17" then
msgplayer = "⇜ الاسم : دانيلو\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 82\n⇜ الجنسية : البرازيل 🇧🇷 \n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/danilyes'},{text = 'لا', data = (_bank_uid)..'/danilno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "18" then
msgplayer = "⇜ الاسم :  دانييلي\n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 82\n⇜ الجنسية : إيطاليا 🇮🇹 \n⇜ سعر اللاعب : 38000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/daneleyes'},{text = 'لا', data = (_bank_uid)..'/daneleno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "19" then
msgplayer = "⇜ الاسم :  إبراهيموفتش \n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 85\n⇜ الجنسيه : السويد 🇸🇪 \n⇜ سعر اللاعب : 55000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/ibrahyes'},{text = 'لا', data = (_bank_uid)..'/ibrahno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "20" then
msgplayer = "⇜ الاسم :  دوناروما \n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 89\n⇜ الجنسيه : إيطاليا 🇮🇹\n⇜ سعر اللاعب : 99000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/donaryes'},{text = 'لا', data = (_bank_uid)..'/donarno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "21" then
msgplayer = "⇜ الاسم :  أشرف حكيمي \n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 85\n⇜ الجنسيه : المغرب 🇲🇦 \n⇜ سعر اللاعب : 55000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/ashrfyes'},{text = 'لا', data = (_bank_uid)..'/ashrfno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "22" then
msgplayer = "⇜ الاسم :  ايدن ازارد \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 86\n⇜ بلجيكا 🇧🇪 : الجنسيه \n⇜ سعر اللاعب : 59000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/idenyes'},{text = 'لا', data = (_bank_uid)..'/idenno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "23" then
msgplayer = "⇜ الاسم :  سيرجو راموس \n⇜ مركزه : مدافع\n⇜ طاقة اللاعب : 93\n⇜ اسبانيا 🇪🇸 : الجنسيه \n⇜ سعر اللاعب : 170000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/sergyes'},{text = 'لا', data = (_bank_uid)..'/sergno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "24" then
msgplayer = "⇜ الاسم : فرمينو\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 86\n⇜ الجنسية : البرازيل 🇧🇷\n⇜ سعر اللاعب : 60000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/fermyes'},{text = 'لا', data = (_bank_uid)..'/fermno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "25" then
msgplayer = "⇜ الاسم : جاك كلارك\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 81\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 19000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/jackyes'},{text = 'لا', data = (_bank_uid)..'/jackno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "26" then
msgplayer = "⇜ الاسم : انسلو فاتي\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : اسبانيا 🇪🇸\n⇜ سعر اللاعب : 53000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/ansloyes'},{text = 'لا', data = (_bank_uid)..'/anslono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "27" then
msgplayer = "⇜ الاسم : توريس\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : اسبانيا 🇪🇸\n⇜ سعر اللاعب : 41000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/toresyes'},{text = 'لا', data = (_bank_uid)..'/toresno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "28" then
msgplayer = "⇜ الاسم : توماس مولر\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : ألمانيا 🇩🇪\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/muleryes'},{text = 'لا', data = (_bank_uid)..'/mulerno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "29" then
msgplayer = "⇜ الاسم : برونو فيرنانديز\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 86\n⇜ الجنسية : البرتغال 🇵🇹\n⇜ سعر اللاعب : 74000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/brunoyes'},{text = 'لا', data = (_bank_uid)..'/brunono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "30" then
msgplayer = "⇜ الاسم : بول بوجبا\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : فرنسا 🇫🇷\n⇜ سعر اللاعب : 78000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/paulyes'},{text = 'لا', data = (_bank_uid)..'/paulno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "31" then
msgplayer = "⇜ الاسم : لوكا مودريتش\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 90\n⇜ الجنسية : كرواتيا 🇭🇷\n⇜ سعر اللاعب : 90000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/modricyes'},{text = 'لا', data = (_bank_uid)..'/modricno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "32" then
msgplayer = "⇜ الاسم : إيسكو\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : اسبانيا 🇪🇸\n⇜ سعر اللاعب : 41000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/iscoyes'},{text = 'لا', data = (_bank_uid)..'/iscnono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "33" then
msgplayer = "⇜ الاسم : فابينهو\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 81\n⇜ الجنسية : البرازيل 🇧🇷\n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/fabinyes'},{text = 'لا', data = (_bank_uid)..'/fabinno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "34" then
msgplayer = "⇜ الاسم : هيندرسون\n⇜ مركزه : وسط\n⇜ طاقة اللاعب : 86\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 70000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/hinsonyes'},{text = 'لا', data = (_bank_uid)..'/hinsonno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "35" then
msgplayer = "⇜ الاسم : جان اوبلاك\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : رومانيا 🇹🇩\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/janyes'},{text = 'لا', data = (_bank_uid)..'/janno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "36" then
msgplayer = "⇜ الاسم : كيلور نافاس\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : كوستا ريكا🇨🇷\n⇜ سعر اللاعب : 70000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/kayloryes'},{text = 'لا', data = (_bank_uid)..'/kaylorno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "37" then
msgplayer = "⇜ الاسم : يان سومر\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 87\n⇜ الجنسية : سويسرا 🇨🇭\n⇜ سعر اللاعب : 70000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/sommeryes'},{text = 'لا', data = (_bank_uid)..'/sommerno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "38" then
msgplayer = "⇜ الاسم : بيرند لينو\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 85\n⇜ الجنسية : المانيا🇩🇪\n⇜ سعر اللاعب : 52000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/brendyes'},{text = 'لا', data = (_bank_uid)..'/brendyes'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "39" then
msgplayer = "⇜ الاسم : ميندي\n⇜ مركزه : حاسر\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : غانا 🇬🇭\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/mendyyes'},{text = 'لا', data = (_bank_uid)..'/mendyno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "40" then
msgplayer = "⇜ الاسم : اندريه اونانا\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 83\n⇜ الجنسية : غانا 🇬🇭\n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/onanayes'},{text = 'لا', data = (_bank_uid)..'/onanano'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "41" then
msgplayer = "⇜ الاسم : روي باتريكو\n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : البرتغال 🇵🇹\n⇜ سعر اللاعب : 40000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/royyes'},{text = 'لا', data = (_bank_uid)..'/royno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "42" then
msgplayer = "⇜ الاسم : كاسبر \n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 84\n⇜ الجنسية : الدنمارك 🇩🇰\n⇜ سعر اللاعب : 40000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/kasperyes'},{text = 'لا', data = (_bank_uid)..'/kasperno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "43" then
msgplayer = "⇜ الاسم : دافيد \n⇜ مركزه : حارس\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : اسبانيا 🇪🇸\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/geayes'},{text = 'لا', data = (_bank_uid)..'/geano'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "44" then
msgplayer = "⇜ الاسم : جواو فليكس\n⇜ مركزه : مهاجم\n⇜ طاقة اللاعب : 82\n⇜ الجنسية : البرتغال 🇵🇹\n⇜ سعر اللاعب : 20000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/felixyes'},{text = 'لا', data = (_bank_uid)..'/felixno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "45" then
msgplayer = "⇜ الاسم : محمد صلاح\n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 91\n⇜ الجنسية : مصر 🇪🇬\n⇜ سعر اللاعب : 100000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/salahyes'},{text = 'لا', data = (_bank_uid)..'/salahno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "46" then
msgplayer = "⇜ الاسم : نيمار \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 91\n⇜ الجنسية : البرازيل 🇧🇷\n⇜ سعر اللاعب : 100000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/neymaryes'},{text = 'لا', data = (_bank_uid)..'/neymarno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "47" then
msgplayer = "⇜ الاسم : ساديو ماني \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 90\n⇜ الجنسية : السنغال 🇸🇳\n⇜ سعر اللاعب : 90000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/sadioyes'},{text = 'لا', data = (_bank_uid)..'/sadiono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "48" then
msgplayer = "⇜ الاسم : رحيم ستيرليج \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/rehimyes'},{text = 'لا', data = (_bank_uid)..'/rehimno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "49" then
msgplayer = "⇜ الاسم : يادون سانشو \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : إنجلترا 🏴󠁧󠁢󠁥󠁮󠁧󠁿\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/sanchoyes'},{text = 'لا', data = (_bank_uid)..'/sanchono'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
elseif Descriptioont == "50" then
msgplayer = "⇜ الاسم : سون  \n⇜ مركزه : جناح\n⇜ طاقة اللاعب : 88\n⇜ الجنسية : كوريه الجنوبيه 🇰🇷\n⇜ سعر اللاعب : 80000 درهم 💵\n هل ترغب بشراء اللاعب ؟\n✧"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'نعم', data = (_bank_uid)..'/sonyes'},{text = 'لا', data = (_bank_uid)..'/sonno'},
},
}
}
send(msg.chat_id,msg.id,msgplayer,"md",false, false, false, false, reply_markup)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
--------------------------------------------------------------------------------------------------------------
if text and text:match('انشاء مزرعه (.*)') or text and text:match('انشاء مزرعة (.*)') or text and text:match('بناء مزرعة (.*)') or text and text:match('بناء مزرعه (.*)') then
 
local Cnamed = text:match('انشاء مزرعه (.*)') or text:match('انشاء مزرعة (.*)') or text:match('بناء مزرعة (.*)') or text:match('بناء مزرعه (.*)')
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
namefram = Redis:get(TheMero.."namefram"..(_bank_uid))
if Redis:get(TheMero.."sizefram"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ لديك مزرعه مسبقاً ","md",true)
end
if Redis:sismember(TheMero.."farmarname", Cnamed) then
return send(msg.chat_id,msg.id, "⇜ اسم المزرعه موجود مسبقاً\n⇜ اختر اسم اخر\n✧","md",true)
end
Redis:set(TheMero.."namefram"..(_bank_uid), Cnamed)
ttshakse = '⇜ اختر مساحة المزرعة : 🛣\n✧'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '4×4', data = (_bank_uid)..'/4×4'},{text = '6×6', data = (_bank_uid)..'/6×6'},{text = '8×8', data = (_bank_uid)..'/8×8'},
},
{
{text = '12×12', data = (_bank_uid)..'/12×12'},{text = '16×16', data = (_bank_uid)..'/16×16'},{text = '32×32', data = (_bank_uid)..'/32×32'},
},
{
{text = 'روبـي 🪄',url="t.me/FvvZv"}, 
},
}
}
return send(msg.chat_id,msg.id,ttshakse,"md",false, false, false, false, reply_markup)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "توب مزارع" or text == "توب المزارع" then

local bank_users = Redis:smembers(TheMero.."ownerfram")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد مزارع","md",true)
end
top_monyd = "⇜ توب اعلى 10 مزارع :\n\n"
mony_listd = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."toplvfarm"..v) or 0
table.insert(mony_listd, {tonumber(mony) , v})
end
table.sort(mony_listd, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)"
}
for k,v in pairs(mony_listd) do
if num <= 10 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
tt = tt:gsub("🇾🇪️",'')
tt = tt:gsub("🇹🇳",'')
tt = tt:gsub("🇸🇾",'')
tt = tt:gsub("🇸🇩",'')
tt = tt:gsub("🇸🇦",'')
tt = tt:gsub("🇶🇦",'')
tt = tt:gsub("🇵🇸",'')
tt = tt:gsub("🇴🇲",'')
tt = tt:gsub("🇲🇦",'')
tt = tt:gsub("🇱🇾",'')
tt = tt:gsub("🇱🇧",'')
tt = tt:gsub("🇰🇼️",'')
tt = tt:gsub("🇯🇴",'')
tt = tt:gsub("🇮🇶",'')
tt = tt:gsub("🇪🇬",'')
tt = tt:gsub("🇧🇭",'')
tt = tt:gsub("🇩🇿️",'')
tt = tt:gsub("🇦🇪",'')
tt = tt:gsub("@[%a%d_]+",'')
tt = tt:gsub("#[%a%d_]+",'')
local kk = Redis:get(TheMero.."namefram"..v[2])
kk = kk:gsub("🇾🇪️",'')
kk = kk:gsub("🇹🇳",'')
kk = kk:gsub("🇸🇾",'')
kk = kk:gsub("🇸🇩",'')
kk = kk:gsub("🇸🇦",'')
kk = kk:gsub("🇶🇦",'')
kk = kk:gsub("🇵🇸",'')
kk = kk:gsub("🇴🇲",'')
kk = kk:gsub("🇲🇦",'')
kk = kk:gsub("🇱🇾",'')
kk = kk:gsub("🇱🇧",'')
kk = kk:gsub("🇰🇼️",'')
kk = kk:gsub("🇯🇴",'')
kk = kk:gsub("🇮🇶",'')
kk = kk:gsub("🇪🇬",'')
kk = kk:gsub("🇧🇭",'')
kk = kk:gsub("🇩🇿️",'')
kk = kk:gsub("🇦🇪",'')
kk = kk:gsub("@[%a%d_]+",'')
kk = kk:gsub("#[%a%d_]+",'')
local doltebank = Redis:get(TheMero.."doltebank"..v[2]) or " "
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_monyd = top_monyd..emo.." "..gflos.."  l "..kk.." ( "..tt.." "..doltebank.." ) \n"
gg = " ━━━━━━━━━\n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_monyd..gg,"md",false, false, false, false, reply_markup)
end
if text == 'مزرعه' or text == 'مزرعة' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⌯ اهلا فيك بمزرعة روبي :\n\n⇜ المزروعات واسعارها :\n- بطاطا : 75 درهم 💵\n- بندوره : 100 درهم 💵\n- خس : 125 درهم 💵\n- خيار : 150 درهم 💵\n- جزر : 175 درهم 💵\n- فليفله : 200 درهم 💵\n- فريز : 300 درهم 💵\n- ذره : 400 درهم 💵\n- ثوم : 500 درهم 💵\n- فطر : 800 درهم 💵\n- شجره تفاح : 1000 درهم 💵\n- شجره عنب : 1250 درهم 💵\n-شجره زيتون : 1500 درهم 💵\n- شجره موز : 2000 درهم 💵\n- شجره مانجا : 3000 درهم 💵\n\n⇜ مثال طريقة الزراعه : \n- زراعه بطاطا 10\n- زراعه شجر موز 15\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه' or text == 'زراعة' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n- زراعه بندوره والعدد\n- زراعه خيار والعدد\n- زراعه فريز والعدد\n- زراعه فليفله والعدد\n- زراعه خس والعدد\n- زراعه جزر والعدد\n- زراعه بطاطا والعدد\n- زراعه شجر تفاح والعدد\n- زراعه شجر موز والعدد\n- زراعه شجر زيتون والعدد\n- زراعه شجر عنب والعدد\n\n⇜ مثال طريقة الزراعه : \n- زراعه بطاطا 10\n- زراعه شجر موز 15\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه بطاطا' or text == 'زراعة بطاطا' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه بطاطا` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه بندوره' or text == 'زراعة بندوره' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه بندوره` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه خس' or text == 'زراعة خس' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه خس` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه خيار' or text == 'زراعة خيار' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه خيار` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه جزر' or text == 'زراعة جزر' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه جزر` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه فليفله' or text == 'زراعة فليفله' or text == 'زراعه فليفلة' or text == 'زراعة فليفلة' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه فليفله` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه فريز' or text == 'زراعة فريز' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه فريز` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه ذره' or text == 'زراعة ذرة' or text == 'زراعة ذره' or text == 'زراعه ذرة' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه ذره` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه ثوم' or text == 'زراعة ثوم' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه ثوم` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه فطر' or text == 'زراعة فطر' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه فطر` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه شجر تفاح' or text == 'زراعة شجر تفاح' or text == 'زراعه شجره تفاح' or text == 'زراعة شجرة تفاح' or text == 'زراعه تفاح' or text == 'زراعة تفاح' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه شجر تفاح` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه شجر عنب' or text == 'زراعة شجر عنب' or text == 'زراعه شجره عنب' or text == 'زراعة شجرة عنب' or text == 'زراعه عنب' or text == 'زراعة عنب' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه شجر عنب` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه شجر زيتون' or text == 'زراعة شجر زيتون' or text == 'زراعه شجره زيتون' or text == 'زراعة شجرة زيتون' or text == 'زراعه زيتون' or text == 'زراعة زيتون' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه شجر زيتون` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه شجر موز' or text == 'زراعة شجر موز' or text == 'زراعه شجره موز' or text == 'زراعة شجرة موز' or text == 'زراعه موز' or text == 'زراعة موز' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه شجر موز` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'زراعه شجر مانجا' or text == 'زراعة شجر مانجا' or text == 'زراعه شجره مانجا' or text == 'زراعة شجرة مانجا' or text == 'زراعه مانجا' or text == 'زراعة مانجا' then
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `زراعه شجر مانجا` والعدد","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مسح مزرعه' or text == 'مسح مزرعة' or text == 'مسح المزرعه' or text == 'مسح المزرعة' or text == 'مسح مزرعتي' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه اصلاً\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` ) والاسم","md",true)
end
namfra = Redis:get(TheMero.."namefram"..(_bank_uid))
Redis:del(TheMero.."toplvfarm"..(_bank_uid))
Redis:del(TheMero.."btatatime"..(_bank_uid))
Redis:del(TheMero.."btatanum"..(_bank_uid))
Redis:del(TheMero.."btataname"..(_bank_uid))
Redis:del(TheMero.."lemontime"..(_bank_uid))
Redis:del(TheMero.."lemonnum"..(_bank_uid))
Redis:del(TheMero.."lemonname"..(_bank_uid))
Redis:del(TheMero.."khesstime"..(_bank_uid))
Redis:del(TheMero.."khessnum"..(_bank_uid))
Redis:del(TheMero.."khessname"..(_bank_uid))
Redis:del(TheMero.."kheartime"..(_bank_uid))
Redis:del(TheMero.."khearnum"..(_bank_uid))
Redis:del(TheMero.."khearname"..(_bank_uid))
Redis:del(TheMero.."jzartime"..(_bank_uid))
Redis:del(TheMero.."jzarnum"..(_bank_uid))
Redis:del(TheMero.."jzarname"..(_bank_uid))
Redis:del(TheMero.."fleflatime"..(_bank_uid))
Redis:del(TheMero.."fleflanum"..(_bank_uid))
Redis:del(TheMero.."fleflaname"..(_bank_uid))
Redis:del(TheMero.."freaztime"..(_bank_uid))
Redis:del(TheMero.."freaznum"..(_bank_uid))
Redis:del(TheMero.."freazname"..(_bank_uid))
Redis:del(TheMero.."doratime"..(_bank_uid))
Redis:del(TheMero.."doranum"..(_bank_uid))
Redis:del(TheMero.."doraname"..(_bank_uid))
Redis:del(TheMero.."tomtime"..(_bank_uid))
Redis:del(TheMero.."tomnum"..(_bank_uid))
Redis:del(TheMero.."tomname"..(_bank_uid))
Redis:del(TheMero.."ftrtime"..(_bank_uid))
Redis:del(TheMero.."ftrnum"..(_bank_uid))
Redis:del(TheMero.."ftrname"..(_bank_uid))
Redis:del(TheMero.."tfahtime"..(_bank_uid))
Redis:del(TheMero.."tfahnum"..(_bank_uid))
Redis:del(TheMero.."tfahname"..(_bank_uid))
Redis:del(TheMero.."enabtime"..(_bank_uid))
Redis:del(TheMero.."enabnum"..(_bank_uid))
Redis:del(TheMero.."enabname"..(_bank_uid))
Redis:del(TheMero.."zetontime"..(_bank_uid))
Redis:del(TheMero.."zetonnum"..(_bank_uid))
Redis:del(TheMero.."zetonname"..(_bank_uid))
Redis:del(TheMero.."mozztime"..(_bank_uid))
Redis:del(TheMero.."mozznum"..(_bank_uid))
Redis:del(TheMero.."mozzname"..(_bank_uid))
Redis:del(TheMero.."mangatime"..(_bank_uid))
Redis:del(TheMero.."manganum"..(_bank_uid))
Redis:del(TheMero.."manganame"..(_bank_uid))
Redis:del(TheMero.."sizefram"..(_bank_uid))
Redis:del(TheMero.."namefram"..(_bank_uid))
Redis:del(TheMero.."mzroatsize"..(_bank_uid))
Redis:srem(TheMero.."farmarname", namfra)
Redis:srem(TheMero.."ownerfram",(_bank_uid))
send(msg.chat_id,msg.id, "⇜ تم مسح مزرعتك","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "مزرعتي" then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` ) والاسم","md",true)
end
local namefram = Redis:get(TheMero.."namefram"..(_bank_uid))
local sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
local mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
local mazofxbh = tonumber(sizefram) - tonumber(mzroatsize)
local btatahours = Redis:ttl(TheMero.."btatatime" .. (_bank_uid)) / 60
local btatatime = Redis:get(TheMero.."btatatime" .. (_bank_uid))
local btataname = Redis:get(TheMero.."btataname"..(_bank_uid))
local btatanum = Redis:get(TheMero.."btatanum"..(_bank_uid)) or 0
if btataname and btatatime then
btatanamee = "🥔 "..btataname.." : ( `"..math.floor(btatanum).."` ) الوقت المتبقي "..math.floor(btatahours).." دقيقة\n"
elseif btataname then
btatanamee = "🥔 "..btataname.." : ( `"..math.floor(btatanum).."` ) جاهزة للحصد\n"
else
btatanamee = ""
end
local lemonhours = Redis:ttl(TheMero.."lemontime" .. (_bank_uid)) / 60
local lemontime = Redis:get(TheMero.."lemontime" .. (_bank_uid))
local lemonname = Redis:get(TheMero.."lemonname"..(_bank_uid))
local lemonnum = Redis:get(TheMero.."lemonnum"..(_bank_uid)) or 0
if lemonname and lemontime then
lemonnamee = "🍅 "..lemonname.." : ( `"..math.floor(lemonnum).."` ) الوقت المتبقي "..math.floor(lemonhours).." دقيقة\n"
elseif lemonname then
lemonnamee = "🍅 "..lemonname.." : ( `"..math.floor(lemonnum).."` ) جاهزة للحصد\n"
else
lemonnamee = ""
end
local khesshours = Redis:ttl(TheMero.."khesstime" .. (_bank_uid)) / 60
local khesstime = Redis:get(TheMero.."khesstime" .. (_bank_uid))
local khessname = Redis:get(TheMero.."khessname"..(_bank_uid))
local khessnum = Redis:get(TheMero.."khessnum"..(_bank_uid)) or 0
if khessname and khesstime then
khessnamee = "🥬 "..khessname.." : ( `"..math.floor(khessnum).."` ) الوقت المتبقي "..math.floor(khesshours).." دقيقة\n"
elseif khessname then
khessnamee = "🥬 "..khessname.." : ( `"..math.floor(khessnum).."` ) جاهز للحصد\n"
else
khessnamee = ""
end
local khearhours = Redis:ttl(TheMero.."kheartime" .. (_bank_uid)) / 60
local kheartime = Redis:get(TheMero.."kheartime" .. (_bank_uid))
local khearname = Redis:get(TheMero.."khearname"..(_bank_uid))
local khearnum = Redis:get(TheMero.."khearnum"..(_bank_uid)) or 0
if khearname and kheartime then
khearnamee = "🥒 "..khearname.." : ( `"..math.floor(khearnum).."` ) الوقت المتبقي "..math.floor(khearhours).." دقيقة\n"
elseif khearname then
khearnamee = "🥒 "..khearname.." : ( `"..math.floor(khearnum).."` ) جاهز للحصد\n"
else
khearnamee = ""
end
local jzarhours = Redis:ttl(TheMero.."jzartime" .. (_bank_uid)) / 60
local jzartime = Redis:get(TheMero.."jzartime" .. (_bank_uid))
local jzarname = Redis:get(TheMero.."jzarname"..(_bank_uid))
local jzarnum = Redis:get(TheMero.."jzarnum"..(_bank_uid)) or 0
if jzarname and jzartime then
jzarnamee = "🥕 "..jzarname.." : ( `"..math.floor(jzarnum).."` ) الوقت المتبقي "..math.floor(jzarhours).." دقيقة\n"
elseif jzarname then
jzarnamee = "🥕 "..jzarname.." : ( `"..math.floor(jzarnum).."` ) جاهز للحصد\n"
else
jzarnamee = ""
end
local fleflahours = Redis:ttl(TheMero.."fleflatime" .. (_bank_uid)) / 60
local fleflatime = Redis:get(TheMero.."fleflatime" .. (_bank_uid))
local fleflaname = Redis:get(TheMero.."fleflaname"..(_bank_uid))
local fleflanum = Redis:get(TheMero.."fleflanum"..(_bank_uid)) or 0
if fleflaname and fleflatime then
fleflanamee = "🫑 "..fleflaname.." : ( `"..math.floor(fleflanum).."` ) الوقت المتبقي "..math.floor(fleflahours).." دقيقة\n"
elseif fleflaname then
fleflanamee = "🫑 "..fleflaname.." : ( `"..math.floor(fleflanum).."` ) جاهزة للحصد\n"
else
fleflanamee = ""
end
local freazhours = Redis:ttl(TheMero.."freaztime" .. (_bank_uid)) / 60
local freaztime = Redis:get(TheMero.."freaztime" .. (_bank_uid))
local freazname = Redis:get(TheMero.."freazname"..(_bank_uid))
local freaznum = Redis:get(TheMero.."freaznum"..(_bank_uid)) or 0
if freazname and freaztime then
freaznamee = "🍓 "..freazname.." : ( `"..math.floor(freaznum).."` ) الوقت المتبقي "..math.floor(freazhours).." دقيقة\n"
elseif freazname then
freaznamee = "🍓 "..freazname.." : ( `"..math.floor(freaznum).."` ) جاهز للحصد\n"
else
freaznamee = ""
end
local dorahours = Redis:ttl(TheMero.."doratime" .. (_bank_uid)) / 60
local doratime = Redis:get(TheMero.."doratime" .. (_bank_uid))
local doraname = Redis:get(TheMero.."doraname"..(_bank_uid))
local doranum = Redis:get(TheMero.."doranum"..(_bank_uid)) or 0
if doraname and doratime then
doranamee = "🌽 "..doraname.." : ( `"..math.floor(doranum).."` ) الوقت المتبقي "..math.floor(dorahours).." دقيقة\n"
elseif doraname then
doranamee = "🌽 "..doraname.." : ( `"..math.floor(doranum).."` ) جاهز للحصد\n"
else
doranamee = ""
end
local tomhours = Redis:ttl(TheMero.."tomtime" .. (_bank_uid)) / 60
local tomtime = Redis:get(TheMero.."tomtime" .. (_bank_uid))
local tomname = Redis:get(TheMero.."tomname"..(_bank_uid))
local tomnum = Redis:get(TheMero.."tomnum"..(_bank_uid)) or 0
if tomname and tomtime then
tomnamee = "🧄 "..tomname.." : ( `"..math.floor(tomnum).."` ) الوقت المتبقي "..math.floor(tomhours).." دقيقة\n"
elseif tomname then
tomnamee = "🧄 "..tomname.." : ( `"..math.floor(tomnum).."` ) جاهز للحصد\n"
else
tomnamee = ""
end
local ftrhours = Redis:ttl(TheMero.."ftrtime" .. (_bank_uid)) / 60
local ftrtime = Redis:get(TheMero.."ftrtime" .. (_bank_uid))
local ftrname = Redis:get(TheMero.."ftrname"..(_bank_uid))
local ftrnum = Redis:get(TheMero.."ftrnum"..(_bank_uid)) or 0
if ftrname and ftrtime then
ftrnamee = "🍄 "..ftrname.." : ( `"..math.floor(ftrnum).."` ) الوقت المتبقي "..math.floor(ftrhours).." دقيقة\n"
elseif ftrname then
ftrnamee = "🍄 "..ftrname.." : ( `"..math.floor(ftrnum).."` ) جاهز للحصد\n"
else
ftrnamee = ""
end
local tfahhours = Redis:ttl(TheMero.."tfahtime" .. (_bank_uid)) / 60
local tfahtime = Redis:get(TheMero.."tfahtime" .. (_bank_uid))
local tfahname = Redis:get(TheMero.."tfahname"..(_bank_uid))
local tfahnum = Redis:get(TheMero.."tfahnum"..(_bank_uid)) or 0
if tfahname and tfahtime then
tfahnamee = "🍏 "..tfahname.." : ( `"..math.floor(tfahnum).."` ) الوقت المتبقي "..math.floor(tfahhours).." دقيقة\n"
elseif tfahname then
tfahnamee = "🍏 "..tfahname.." : ( `"..math.floor(tfahnum).."` ) جاهز للحصد\n"
else
tfahnamee = ""
end
local enabhours = Redis:ttl(TheMero.."enabtime" .. (_bank_uid)) / 60
local enabtime = Redis:get(TheMero.."enabtime" .. (_bank_uid))
local enabname = Redis:get(TheMero.."enabname"..(_bank_uid))
local enabnum = Redis:get(TheMero.."enabnum"..(_bank_uid)) or 0
if enabname and enabtime then
enabnamee = "🍇 "..enabname.." : ( `"..math.floor(enabnum).."` ) الوقت المتبقي "..math.floor(enabhours).." دقيقة\n"
elseif enabname then
enabnamee = "🍇 "..enabname.." : ( `"..math.floor(enabnum).."` ) جاهز للحصد\n"
else
enabnamee = ""
end
local zetonhours = Redis:ttl(TheMero.."zetontime" .. (_bank_uid)) / 60
local zetontime = Redis:get(TheMero.."zetontime" .. (_bank_uid))
local zetonname = Redis:get(TheMero.."zetonname"..(_bank_uid))
local zetonnum = Redis:get(TheMero.."zetonnum"..(_bank_uid)) or 0
if zetonname and zetontime then
zetonnamee = "🫒 "..zetonname.." : ( `"..math.floor(zetonnum).."` ) الوقت المتبقي "..math.floor(zetonhours).." دقيقة\n"
elseif zetonname then
zetonnamee = "🫒 "..zetonname.." : ( `"..math.floor(zetonnum).."` ) جاهز للحصد\n"
else
zetonnamee = ""
end
local mozzhours = Redis:ttl(TheMero.."mozztime" .. (_bank_uid)) / 60
local mozztime = Redis:get(TheMero.."mozztime" .. (_bank_uid))
local mozzname = Redis:get(TheMero.."mozzname"..(_bank_uid))
local mozznum = Redis:get(TheMero.."mozznum"..(_bank_uid)) or 0
if mozzname and mozztime then
mozznamee = "🍌 "..mozzname.." : ( `"..math.floor(mozznum).."` ) الوقت المتبقي "..math.floor(mozzhours).." دقيقة\n"
elseif mozzname then
mozznamee = "🍌 "..mozzname.." : ( `"..math.floor(mozznum).."` ) جاهز للحصد\n"
else
mozznamee = ""
end
local mangahours = Redis:ttl(TheMero.."mangatime" .. (_bank_uid)) / 60
local mangatime = Redis:get(TheMero.."mangatime" .. (_bank_uid))
local manganame = Redis:get(TheMero.."manganame"..(_bank_uid))
local manganum = Redis:get(TheMero.."manganum"..(_bank_uid)) or 0
if manganame and mangatime then
manganamee = "🥭 "..manganame.." : ( `"..math.floor(manganum).."` ) الوقت المتبقي "..math.floor(mangahours).." دقيقة\n"
elseif manganame then
manganamee = "🥭 "..manganame.." : ( `"..math.floor(manganum).."` ) جاهز للحصد\n"
else
manganamee = ""
end
if btatanum == 0 and lemonnum == 0 and khessnum == 0 and khearnum == 0 and jzarnum == 0 and fleflanum == 0 and freaznum == 0 and doranum == 0 and tomnum == 0 and ftrnum == 0 and tfahnum == 0 and enabnum == 0 and zetonnum == 0 and mozznum == 0 and manganum == 0 then
send(msg.chat_id,msg.id, "⇜ اسم مزرعتك 🏕 : "..namefram.."\n⇜ مساحة المزرعة المتبقية : "..mazofxbh.." متر\n\n⇜ لا يوجد مزروعات\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ اسم مزرعتك 🏕 : "..namefram.."\n⇜ مساحة المزرعة المتبقية : "..mazofxbh.." متر\n\n⇜ مزروعاتك :\n"..btatanamee..""..lemonnamee..""..khessnamee..""..khearnamee..""..jzarnamee..""..fleflanamee..""..freaznamee..""..doranamee..""..tomnamee..""..ftrnamee..""..tfahnamee..""..enabnamee..""..zetonnamee..""..mozznamee..""..manganamee.."\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه بطاطا (.*)$') or text and text:match('^زراعة بطاطا (.*)$') then

local UserName = text:match('^زراعه بطاطا (.*)$') or text:match('^زراعة بطاطا (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."btatatime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."btatatime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة بطاطا قبل 🥔\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصادها\n- طريقة الحصاد بالامر : `حصد بطاطا`","md",true)
end
if Redis:get(TheMero.."btatanum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة بطاطا قبل 🥔\n⇜ قم بحصادها اولاً\n- طريقة الحصاد بالامر : `حصد بطاطا`","md",true)
end
kajwha = tonumber(coniss) * 0.7
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
btata = tonumber(coniss) * 75
if tonumber(ballance) < tonumber(btata) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."btatanum"..(_bank_uid) , coniss)
btataname = "بطاطا"
Redis:set(TheMero.."btataname"..(_bank_uid) , btataname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
btatasize = tonumber(coniss) * 0.7
btatasizee = btatasize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(btatasizee))
totalypalice = tonumber(ballance) - tonumber(btata)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."btatatime"..(_bank_uid),1220, true)
local convert_mony = string.format("%.0f",math.floor(btata))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة بطاطا 🥔\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 20 دقيقة ⏳️ ثم قم بحصادها\n- الامر ( `حصد بطاطا` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه بندوره (.*)$') or text and text:match('^زراعة بندوره (.*)$') then

local UserName = text:match('^زراعه بندوره (.*)$') or text:match('^زراعة بندوره (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."lemontime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."lemontime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة بندوره قبل 🍅\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد بندوره`","md",true)
end
if Redis:get(TheMero.."lemonnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة بندوره قبل 🍅\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد بندوره`","md",true)
end
kajwha = tonumber(coniss) * 1
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
lemon = tonumber(coniss) * 100
if tonumber(ballance) < tonumber(lemon) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."lemonnum"..(_bank_uid) , coniss)
lemonname = "بندوره"
Redis:set(TheMero.."lemonname"..(_bank_uid) , lemonname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
lemonsize = tonumber(coniss) * 1
lemonsizee = lemonsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(lemonsizee))
totalypalice = tonumber(ballance) - tonumber(lemon)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."lemontime"..(_bank_uid),1520, true)
local convert_mony = string.format("%.0f",math.floor(lemon))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة بندوره 🍅\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 25 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد بندوره` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه خس (.*)$') or text and text:match('^زراعة خس (.*)$') then

local UserName = text:match('^زراعه خس (.*)$') or text:match('^زراعة خس (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."khesstime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."khesstime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة خس قبل 🥬\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصادها\n- طريقة الحصاد بالامر : `حصد خس`","md",true)
end
if Redis:get(TheMero.."khessnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة خس قبل 🥬\n⇜ قم بحصادها اولاً\n- طريقة الحصاد بالامر : `حصد خس`","md",true)
end
kajwha = tonumber(coniss) * 1.2
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
khess = tonumber(coniss) * 125
if tonumber(ballance) < tonumber(khess) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."khessnum"..(_bank_uid) , coniss)
khessname = "خس"
Redis:set(TheMero.."khessname"..(_bank_uid) , khessname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
khesssize = tonumber(coniss) * 1.2
khesssizee = khesssize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(khesssizee))
totalypalice = tonumber(ballance) - tonumber(khess)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."khesstime"..(_bank_uid),1800, true)
local convert_mony = string.format("%.0f",math.floor(khess))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة خس 🥬\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 30 دقيقة ⏳️ ثم قم بحصادها\n- الامر ( `حصد خس` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه خيار (.*)$') or text and text:match('^زراعة خيار (.*)$') then

local UserName = text:match('^زراعه خيار (.*)$') or text:match('^زراعة خيار (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."kheartime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."kheartime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة خيار قبل 🥒\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد خيار`","md",true)
end
if Redis:get(TheMero.."khearnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة خيار قبل 🥒\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد خيار`","md",true)
end
kajwha = tonumber(coniss) * 1.5
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
khear = tonumber(coniss) * 150
if tonumber(ballance) < tonumber(khear) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."khearnum"..(_bank_uid) , coniss)
khearname = "خيار"
Redis:set(TheMero.."khearname"..(_bank_uid) , khearname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
khearsize = tonumber(coniss) * 1.5
khearsizee = khearsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(khearsizee))
totalypalice = tonumber(ballance) - tonumber(khear)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."kheartime"..(_bank_uid),2120, true)
local convert_mony = string.format("%.0f",math.floor(khear))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة خيار 🥒\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 35 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد خيار` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه جزر (.*)$') or text and text:match('^زراعة جزر (.*)$') then

local UserName = text:match('^زراعه جزر (.*)$') or text:match('^زراعة جزر (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."jzartime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."jzartime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة جزر قبل 🥕\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد جزر`","md",true)
end
if Redis:get(TheMero.."jzarnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة جزر قبل 🥕\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد جزر`","md",true)
end
kajwha = tonumber(coniss) * 1.7
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
jzar = tonumber(coniss) * 175
if tonumber(ballance) < tonumber(jzar) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."jzarnum"..(_bank_uid) , coniss)
jzarname = "جزر"
Redis:set(TheMero.."jzarname"..(_bank_uid) , jzarname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
jzarsize = tonumber(coniss) * 1.7
jzarsizee = jzarsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(jzarsizee))
totalypalice = tonumber(ballance) - tonumber(jzar)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."jzartime"..(_bank_uid),2420, true)
local convert_mony = string.format("%.0f",math.floor(jzar))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة جزر 🥕\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 40 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد جزر` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه فليفله (.*)$') or text and text:match('^زراعة فليفله (.*)$') then

local UserName = text:match('^زراعه فليفله (.*)$') or text:match('^زراعة فليفله (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."fleflatime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."fleflatime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة فليفله قبل 🫑\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصادها\n- طريقة الحصاد بالامر : `حصد فليفله`","md",true)
end
if Redis:get(TheMero.."fleflanum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة فليفله قبل 🫑\n⇜ قم بحصادها اولاً\n- طريقة الحصاد بالامر : `حصد فليفله`","md",true)
end
kajwha = tonumber(coniss) * 2
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
flefla = tonumber(coniss) * 200
if tonumber(ballance) < tonumber(flefla) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."fleflanum"..(_bank_uid) , coniss)
fleflaname = "فليفله"
Redis:set(TheMero.."fleflaname"..(_bank_uid) , fleflaname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
fleflasize = tonumber(coniss) * 2
fleflasizee = fleflasize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(fleflasizee))
totalypalice = tonumber(ballance) - tonumber(flefla)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."fleflatime"..(_bank_uid),2720, true)
local convert_mony = string.format("%.0f",math.floor(flefla))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة فليفله 🫑\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 45 دقيقة ⏳️ ثم قم بحصادها\n- الامر ( `حصد فليفله` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه فريز (.*)$') or text and text:match('^زراعة فريز (.*)$') then

local UserName = text:match('^زراعه فريز (.*)$') or text:match('^زراعة فريز (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."freaztime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."freaztime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة فريز قبل 🍓\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد فريز`","md",true)
end
if Redis:get(TheMero.."freaznum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة فريز قبل 🍓\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد فريز`","md",true)
end
kajwha = tonumber(coniss) * 3
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
freaz = tonumber(coniss) * 300
if tonumber(ballance) < tonumber(freaz) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."freaznum"..(_bank_uid) , coniss)
freazname = "فريز"
Redis:set(TheMero.."freazname"..(_bank_uid) , freazname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
freazsize = tonumber(coniss) * 3
freazsizee = freazsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(freazsizee))
totalypalice = tonumber(ballance) - tonumber(freaz)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."freaztime"..(_bank_uid),3020, true)
local convert_mony = string.format("%.0f",math.floor(freaz))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة فريز 🍓\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 50 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد فريز` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه ذره (.*)$') or text and text:match('^زراعة ذره (.*)$') or text and text:match('^زراعه ذرة (.*)$') or text and text:match('^زراعة ذرة (.*)$') then

local UserName = text:match('^زراعه ذره (.*)$') or text:match('^زراعة ذره (.*)$') or text:match('^زراعه ذرة (.*)$') or text:match('^زراعة ذرة (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."doratime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."doratime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة ذره قبل 🌽\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد ذره`","md",true)
end
if Redis:get(TheMero.."doranum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة ذره قبل 🌽\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد ذره`","md",true)
end
kajwha = tonumber(coniss) * 4
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
dora = tonumber(coniss) * 400
if tonumber(ballance) < tonumber(dora) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."doranum"..(_bank_uid) , coniss)
doraname = "ذره"
Redis:set(TheMero.."doraname"..(_bank_uid) , doraname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
dorasize = tonumber(coniss) * 4
dorasizee = dorasize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(dorasizee))
totalypalice = tonumber(ballance) - tonumber(dora)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."doratime"..(_bank_uid),3320, true)
local convert_mony = string.format("%.0f",math.floor(dora))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة ذره 🌽\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 55 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد ذره` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه ثوم (.*)$') or text and text:match('^زراعة ثوم (.*)$') then

local UserName = text:match('^زراعه ثوم (.*)$') or text:match('^زراعة ثوم (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."tomtime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."tomtime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة ثوم قبل 🧄\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد ثوم`","md",true)
end
if Redis:get(TheMero.."tomnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة ثوم قبل 🧄\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد ثوم`","md",true)
end
kajwha = tonumber(coniss) * 5
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
tom = tonumber(coniss) * 500
if tonumber(ballance) < tonumber(tom) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."tomnum"..(_bank_uid) , coniss)
tomname = "ثوم"
Redis:set(TheMero.."tomname"..(_bank_uid) , tomname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
tomsize = tonumber(coniss) * 5
tomsizee = tomsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(tomsizee))
totalypalice = tonumber(ballance) - tonumber(tom)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."tomtime"..(_bank_uid),3620, true)
local convert_mony = string.format("%.0f",math.floor(tom))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة ثوم 🧄\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 60 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد ثوم` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه فطر (.*)$') or text and text:match('^زراعة فطر (.*)$') then

local UserName = text:match('^زراعه فطر (.*)$') or text:match('^زراعة فطر (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."ftrtime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."ftrtime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة فطر قبل 🍄\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد فطر`","md",true)
end
if Redis:get(TheMero.."ftrnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة فطر قبل 🍄\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد فطر`","md",true)
end
kajwha = tonumber(coniss) * 6
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
ftr = tonumber(coniss) * 600
if tonumber(ballance) < tonumber(ftr) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."ftrnum"..(_bank_uid) , coniss)
ftrname = "فطر"
Redis:set(TheMero.."ftrname"..(_bank_uid) , ftrname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
ftrsize = tonumber(coniss) * 6
ftrsizee = ftrsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(ftrsizee))
totalypalice = tonumber(ballance) - tonumber(ftr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."ftrtime"..(_bank_uid),4220, true)
local convert_mony = string.format("%.0f",math.floor(ftr))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة فطر 🍄\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 70 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد فطر` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه شجر تفاح (.*)$') or text and text:match('^زراعة شجر تفاح (.*)$') then

local UserName = text:match('^زراعه شجر تفاح (.*)$') or text:match('^زراعة شجر تفاح (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."tfahtime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."tfahtime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة شجر تفاح قبل 🍏\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد شجر تفاح`","md",true)
end
if Redis:get(TheMero.."tfahnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة شجر تفاح قبل 🍏\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد شجر تفاح`","md",true)
end
kajwha = tonumber(coniss) * 10
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
tfah = tonumber(coniss) * 1000
if tonumber(ballance) < tonumber(tfah) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."tfahnum"..(_bank_uid) , coniss)
tfahname = "تفاح"
Redis:set(TheMero.."tfahname"..(_bank_uid) , tfahname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
tfahsize = tonumber(coniss) * 10
tfahsizee = tfahsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(tfahsizee))
totalypalice = tonumber(ballance) - tonumber(tfah)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."tfahtime"..(_bank_uid),5420, true)
local convert_mony = string.format("%.0f",math.floor(tfah))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة شجر تفاح 🍏\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 90 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد شجر تفاح` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه شجر عنب (.*)$') or text and text:match('^زراعة شجر عنب (.*)$') then

local UserName = text:match('^زراعه شجر عنب (.*)$') or text:match('^زراعة شجر عنب (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."enabtime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."enabtime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة شجر عنب قبل 🍇\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد شجر عنب`","md",true)
end
if Redis:get(TheMero.."enabnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة شجر عنب قبل 🍇\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد شجر عنب`","md",true)
end
kajwha = tonumber(coniss) * 12.5
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
enab = tonumber(coniss) * 1250
if tonumber(ballance) < tonumber(enab) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."enabnum"..(_bank_uid) , coniss)
enabname = "عنب"
Redis:set(TheMero.."enabname"..(_bank_uid) , enabname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
enabsize = tonumber(coniss) * 12.5
enabsizee = enabsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(enabsizee))
totalypalice = tonumber(ballance) - tonumber(enab)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."enabtime"..(_bank_uid),6020, true)
local convert_mony = string.format("%.0f",math.floor(enab))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة شجر عنب 🍇\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 100 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد شجر عنب` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه شجر زيتون (.*)$') or text and text:match('^زراعة شجر زيتون (.*)$') then

local UserName = text:match('^زراعه شجر زيتون (.*)$') or text:match('^زراعة شجر زيتون (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."zetontime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."zetontime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة شجر زيتون قبل 🫒\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد شجر زيتون`","md",true)
end
if Redis:get(TheMero.."zetonnum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة شجر زيتون قبل 🫒\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد شجر زيتون`","md",true)
end
kajwha = tonumber(coniss) * 15
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
zeton = tonumber(coniss) * 1500
if tonumber(ballance) < tonumber(zeton) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."zetonnum"..(_bank_uid) , coniss)
zetonname = "زيتون"
Redis:set(TheMero.."zetonname"..(_bank_uid) , zetonname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
zetonsize = tonumber(coniss) * 15
zetonsizee = zetonsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(zetonsizee))
totalypalice = tonumber(ballance) - tonumber(zeton)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."zetontime"..(_bank_uid),7220, true)
local convert_mony = string.format("%.0f",math.floor(zeton))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة شجر زيتون 🫒\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 120 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد شجر زيتون` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه شجر موز (.*)$') or text and text:match('^زراعة شجر موز (.*)$') then

local UserName = text:match('^زراعه شجر موز (.*)$') or text:match('^زراعة شجر موز (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."mozztime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."mozztime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة شجر موز قبل 🍌\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد شجر موز`","md",true)
end
if Redis:get(TheMero.."mozznum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة شجر موز قبل 🍌\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد شجر موز`","md",true)
end
kajwha = tonumber(coniss) * 20
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
mozz = tonumber(coniss) * 2000
if tonumber(ballance) < tonumber(mozz) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."mozznum"..(_bank_uid) , coniss)
mozzname = "موز"
Redis:set(TheMero.."mozzname"..(_bank_uid) , mozzname)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mozzsize = tonumber(coniss) * 20
mozzsizee = mozzsize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(mozzsizee))
totalypalice = tonumber(ballance) - tonumber(mozz)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."mozztime"..(_bank_uid),8420, true)
local convert_mony = string.format("%.0f",math.floor(mozz))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة شجر موز 🍌\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 140 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد شجر موز` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^زراعه شجر مانجا (.*)$') or text and text:match('^زراعة شجر مانجا (.*)$') then

local UserName = text:match('^زراعه شجر مانجا (.*)$') or text:match('^زراعة شجر مانجا (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if Redis:get(TheMero.."mangatime" .. (_bank_uid)) then
local hours = Redis:ttl(TheMero.."mangatime" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ زرعة شجر مانجا قبل 🥭\n⇜ استنى "..math.floor(hours).." دقيقة ⏳️ ثم قم بحصاده\n- طريقة الحصاد بالامر : `حصد شجر مانجا`","md",true)
end
if Redis:get(TheMero.."manganum" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ زرعة شجر مانجا قبل 🥭\n⇜ قم بحصاده اولاً\n- طريقة الحصاد بالامر : `حصد شجر مانجا`","md",true)
end
kajwha = tonumber(coniss) * 30
sizefram = Redis:get(TheMero.."sizefram"..(_bank_uid))
if tonumber(kajwha) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mzroatsizee = tonumber(mzroatsize) + tonumber(kajwha)
if tonumber(mzroatsizee) > tonumber(sizefram) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري مساحة ارضك ماتكفي","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
manga = tonumber(coniss) * 3000
if tonumber(ballance) < tonumber(manga) then
return send(msg.chat_id,msg.id, "⇜ مايمديك تشتري فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."manganum"..(_bank_uid) , coniss)
manganame = "مانجا"
Redis:set(TheMero.."manganame"..(_bank_uid) , manganame)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mangasize = tonumber(coniss) * 30
mangasizee = mangasize + mzroatsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(mangasizee))
totalypalice = tonumber(ballance) - tonumber(manga)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(totalypalice))
Redis:setex(TheMero.."mangatime"..(_bank_uid),10220, true)
local convert_mony = string.format("%.0f",math.floor(manga))
toplvfarm = Redis:get(TheMero.."toplvfarm"..(_bank_uid)) or 0
toplvfarmm = tonumber(toplvfarm) + tonumber(coniss)
Redis:set(TheMero.."toplvfarm"..(_bank_uid) , toplvfarmm)
send(msg.chat_id,msg.id, "⇜ زرعة شجر مانجا 🥭\n⇜ العدد : "..math.floor(coniss).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ استنى 180 دقيقة ⏳️ ثم قم بحصاده\n- الامر ( `حصد شجر مانجا` )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'حصد بطاطا' or text == 'حصاد بطاطا' or text == 'حصد البطاطا' or text == 'حصاد البطاطا' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."btatanum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات بطاطا 🥔\n⇜ تستطيع زراعتها بالامر ( `زراعه بطاطا` )\n✧","md",true)
end
if Redis:get(TheMero.."btatatime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."btatatime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم تنضج البطاطا بمزرعتك 🥔\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
btatanum = Redis:get(TheMero.."btatanum"..(_bank_uid))
btata = tonumber(btatanum) * 100
btataa = tonumber(ballance) + tonumber(btata)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(btataa))
local convert_mony = string.format("%.0f",math.floor(btata))
local convert_monyy = string.format("%.0f",math.floor(btataa))
send(msg.chat_id,msg.id, "⇜ تم حصاد البطاطا 🥔\n⇜ العدد : "..math.floor(btatanum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
btatasize = tonumber(btatanum) * 0.7
btatasizee = mzroatsize - btatasize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(btatasizee))
Redis:del(TheMero.."btatatime"..(_bank_uid))
Redis:del(TheMero.."btatanum"..(_bank_uid))
Redis:del(TheMero.."btataname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد بندوره' or text == 'حصاد بندوره' or text == 'حصد البندوره' or text == 'حصاد البندوره' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."lemonnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات بندوره 🍅\n⇜ تستطيع زراعتها بالامر ( `زراعه بندوره` )\n✧","md",true)
end
if Redis:get(TheMero.."lemontime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."lemontime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج البندوره بمزرعتك 🍅\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
lemonnum = Redis:get(TheMero.."lemonnum"..(_bank_uid))
lemon = tonumber(lemonnum) * 150
lemona = tonumber(ballance) + tonumber(lemon)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(lemona))
local convert_mony = string.format("%.0f",math.floor(lemon))
local convert_monyy = string.format("%.0f",math.floor(lemona))
send(msg.chat_id,msg.id, "⇜ تم حصاد البندوره 🍅\n⇜ العدد : "..math.floor(lemonnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
lemonsize = tonumber(lemonnum) * 1
lemonsizee = mzroatsize - lemonsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(lemonsizee))
Redis:del(TheMero.."lemontime"..(_bank_uid))
Redis:del(TheMero.."lemonnum"..(_bank_uid))
Redis:del(TheMero.."lemonname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد خس' or text == 'حصاد خس' or text == 'حصد الخس' or text == 'حصاد الخس' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."khessnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات خس 🥬\n⇜ تستطيع زراعتها بالامر ( `زراعه خس` )\n✧","md",true)
end
if Redis:get(TheMero.."khesstime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."khesstime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الخس بمزرعتك 🥬\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
khessnum = Redis:get(TheMero.."khessnum"..(_bank_uid))
khess = tonumber(khessnum) * 200
khessa = tonumber(ballance) + tonumber(khess)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(khessa))
local convert_mony = string.format("%.0f",math.floor(khess))
local convert_monyy = string.format("%.0f",math.floor(khessa))
send(msg.chat_id,msg.id, "⇜ تم حصاد الخس 🥬\n⇜ العدد : "..math.floor(khessnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
khesssize = tonumber(khessnum) * 1.2
khesssizee = mzroatsize - khesssize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(khesssizee))
Redis:del(TheMero.."khesstime"..(_bank_uid))
Redis:del(TheMero.."khessnum"..(_bank_uid))
Redis:del(TheMero.."khessname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد خيار' or text == 'حصاد خيار' or text == 'حصد الخيار' or text == 'حصاد الخيار' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."khearnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات خيار 🥒\n⇜ تستطيع زراعتها بالامر ( `زراعه خيار` )\n✧","md",true)
end
if Redis:get(TheMero.."kheartime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."kheartime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الخيار بمزرعتك 🥒\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
khearnum = Redis:get(TheMero.."khearnum"..(_bank_uid))
khear = tonumber(khearnum) * 250
kheara = tonumber(ballance) + tonumber(khear)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(kheara))
local convert_mony = string.format("%.0f",math.floor(khear))
local convert_monyy = string.format("%.0f",math.floor(kheara))
send(msg.chat_id,msg.id, "⇜ تم حصاد الخيار 🥒\n⇜ العدد : "..math.floor(khearnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
khearsize = tonumber(khearnum) * 1.5
khearsizee = mzroatsize - khearsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(khearsizee))
Redis:del(TheMero.."kheartime"..(_bank_uid))
Redis:del(TheMero.."khearnum"..(_bank_uid))
Redis:del(TheMero.."khearname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد جزر' or text == 'حصاد جزر' or text == 'حصد الجزر' or text == 'حصاد الجزر' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."jzarnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات جزر 🥕\n⇜ تستطيع زراعتها بالامر ( `زراعه جزر` )\n✧","md",true)
end
if Redis:get(TheMero.."jzartime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."jzartime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الجزر بمزرعتك 🥕\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
jzarnum = Redis:get(TheMero.."jzarnum"..(_bank_uid))
jzar = tonumber(jzarnum) * 300
jzara = tonumber(ballance) + tonumber(jzar)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(jzara))
local convert_mony = string.format("%.0f",math.floor(jzar))
local convert_monyy = string.format("%.0f",math.floor(jzara))
send(msg.chat_id,msg.id, "⇜ تم حصاد الجزر 🥕\n⇜ العدد : "..math.floor(jzarnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
jzarsize = tonumber(jzarnum) * 1.7
jzarsizee = mzroatsize - jzarsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(jzarsizee))
Redis:del(TheMero.."jzartime"..(_bank_uid))
Redis:del(TheMero.."jzarnum"..(_bank_uid))
Redis:del(TheMero.."jzarname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد فليفله' or text == 'حصاد فليفله' or text == 'حصد الفليفله' or text == 'حصاد الفليفله' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."fleflanum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات فليفله 🫑\n⇜ تستطيع زراعتها بالامر ( `زراعه فليفله` )\n✧","md",true)
end
if Redis:get(TheMero.."fleflatime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."fleflatime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم تنضج الفليفله بمزرعتك 🫑\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
fleflanum = Redis:get(TheMero.."fleflanum"..(_bank_uid))
flefla = tonumber(fleflanum) * 350
fleflaa = tonumber(ballance) + tonumber(flefla)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(fleflaa))
local convert_mony = string.format("%.0f",math.floor(flefla))
local convert_monyy = string.format("%.0f",math.floor(fleflaa))
send(msg.chat_id,msg.id, "⇜ تم حصاد الفليفله 🫑\n⇜ العدد : "..math.floor(fleflanum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
fleflasize = tonumber(fleflanum) * 2
fleflasizee = mzroatsize - fleflasize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(fleflasizee))
Redis:del(TheMero.."fleflatime"..(_bank_uid))
Redis:del(TheMero.."fleflanum"..(_bank_uid))
Redis:del(TheMero.."fleflaname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد فريز' or text == 'حصاد فريز' or text == 'حصد الفريز' or text == 'حصاد الفريز' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."freaznum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات فريز 🍓\n⇜ تستطيع زراعتها بالامر ( `زراعه فريز` )\n✧","md",true)
end
if Redis:get(TheMero.."freaztime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."freaztime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الفريز بمزرعتك 🍓\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
freaznum = Redis:get(TheMero.."freaznum"..(_bank_uid))
freaz = tonumber(freaznum) * 475
freaza = tonumber(ballance) + tonumber(freaz)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(freaza))
local convert_mony = string.format("%.0f",math.floor(freaz))
local convert_monyy = string.format("%.0f",math.floor(freaza))
send(msg.chat_id,msg.id, "⇜ تم حصاد الفريز 🍓\n⇜ العدد : "..math.floor(freaznum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
freazsize = tonumber(freaznum) * 3
freazsizee = mzroatsize - freazsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(freazsizee))
Redis:del(TheMero.."freaztime"..(_bank_uid))
Redis:del(TheMero.."freaznum"..(_bank_uid))
Redis:del(TheMero.."freazname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد ذره' or text == 'حصاد ذره' or text == 'حصد ذرة' or text == 'حصاد ذرة' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."doranum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات ذره 🌽\n⇜ تستطيع زراعتها بالامر ( `زراعه ذره` )\n✧","md",true)
end
if Redis:get(TheMero.."doratime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."doratime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الذره بمزرعتك 🌽\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
doranum = Redis:get(TheMero.."doranum"..(_bank_uid))
dora = tonumber(doranum) * 600
doraa = tonumber(ballance) + tonumber(dora)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(doraa))
local convert_mony = string.format("%.0f",math.floor(dora))
local convert_monyy = string.format("%.0f",math.floor(doraa))
send(msg.chat_id,msg.id, "⇜ تم حصاد الذره 🌽\n⇜ العدد : "..math.floor(doranum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
dorasize = tonumber(doranum) * 4
dorasizee = mzroatsize - dorasize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(dorasizee))
Redis:del(TheMero.."doratime"..(_bank_uid))
Redis:del(TheMero.."doranum"..(_bank_uid))
Redis:del(TheMero.."doraname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد ثوم' or text == 'حصاد ثوم' or text == 'حصد الثوم' or text == 'حصاد الثوم' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."tomnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات ثوم 🧄\n⇜ تستطيع زراعتها بالامر ( `زراعه ثوم` )\n✧","md",true)
end
if Redis:get(TheMero.."tomtime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."tomtime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الثوم بمزرعتك 🧄\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
tomnum = Redis:get(TheMero.."tomnum"..(_bank_uid))
tom = tonumber(tomnum) * 725
toma = tonumber(ballance) + tonumber(tom)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(toma))
local convert_mony = string.format("%.0f",math.floor(tom))
local convert_monyy = string.format("%.0f",math.floor(toma))
send(msg.chat_id,msg.id, "⇜ تم حصاد الثوم 🧄\n⇜ العدد : "..math.floor(tomnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
tomsize = tonumber(tomnum) * 5
tomsizee = mzroatsize - tomsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(tomsizee))
Redis:del(TheMero.."tomtime"..(_bank_uid))
Redis:del(TheMero.."tomnum"..(_bank_uid))
Redis:del(TheMero.."tomname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد فطر' or text == 'حصاد فطر' or text == 'حصد الفطر' or text == 'حصاد الفطر' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."ftrnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك مزروعات فطر 🍄\n⇜ تستطيع زراعتها بالامر ( `زراعه فطر` )\n✧","md",true)
end
if Redis:get(TheMero.."ftrtime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."ftrtime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الفطر بمزرعتك 🍄\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
ftrnum = Redis:get(TheMero.."ftrnum"..(_bank_uid))
ftr = tonumber(ftrnum) * 800
ftra = tonumber(ballance) + tonumber(ftr)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(ftra))
local convert_mony = string.format("%.0f",math.floor(ftr))
local convert_monyy = string.format("%.0f",math.floor(ftra))
send(msg.chat_id,msg.id, "⇜ تم حصاد الفطر 🍄\n⇜ العدد : "..math.floor(ftrnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
ftrsize = tonumber(ftrnum) * 6
ftrsizee = mzroatsize - ftrsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(ftrsizee))
Redis:del(TheMero.."ftrtime"..(_bank_uid))
Redis:del(TheMero.."ftrnum"..(_bank_uid))
Redis:del(TheMero.."ftrname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد شجر تفاح' or text == 'حصد شجر التفاح' or text == 'حصد شجره تفاح' or text == 'حصد شجره التفاح' or text == 'حصد شجرة التفاح' or text == 'حصد شجرة تفاح' or text == 'حصاد شجر تفاح' or text == 'حصاد شجر التفاح' or text == 'حصاد شجره تفاح' or text == 'حصاد شجره التفاح' or text == 'حصاد شجرة التفاح' or text == 'حصاد شجرة تفاح' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."tfahnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك شجر تفاح 🍏\n⇜ تستطيع زراعتها بالامر ( `زراعه شجر تفاح` )\n✧","md",true)
end
if Redis:get(TheMero.."tfahtime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."tfahtime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج التفاح بمزرعتك 🍏\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
tfahnum = Redis:get(TheMero.."tfahnum"..(_bank_uid))
tfah = tonumber(tfahnum) * 1200
tfaha = tonumber(ballance) + tonumber(tfah)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(tfaha))
local convert_mony = string.format("%.0f",math.floor(tfah))
local convert_monyy = string.format("%.0f",math.floor(tfaha))
send(msg.chat_id,msg.id, "⇜ تم حصاد شجر التفاح 🍏\n⇜ العدد : "..math.floor(tfahnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
tfahsize = tonumber(tfahnum) * 10
tfahsizee = mzroatsize - tfahsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(tfahsizee))
Redis:del(TheMero.."tfahtime"..(_bank_uid))
Redis:del(TheMero.."tfahnum"..(_bank_uid))
Redis:del(TheMero.."tfahname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد شجر عنب' or text == 'حصد شجر العنب' or text == 'حصد شجره عنب' or text == 'حصد شجره العنب' or text == 'حصد شجرة العنب' or text == 'حصد شجرة عنب' or text == 'حصاد شجر عنب' or text == 'حصاد شجر العنب' or text == 'حصاد شجره عنب' or text == 'حصاد شجره العنب' or text == 'حصاد شجرة العنب' or text == 'حصاد شجرة عنب' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."enabnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك شجر عنب 🍇\n⇜ تستطيع زراعتها بالامر ( `زراعه شجر عنب` )\n✧","md",true)
end
if Redis:get(TheMero.."enabtime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."enabtime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج العنب بمزرعتك 🍇\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
enabnum = Redis:get(TheMero.."enabnum"..(_bank_uid))
enab = tonumber(enabnum) * 1500
enaba = tonumber(ballance) + tonumber(enab)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(enaba))
local convert_mony = string.format("%.0f",math.floor(enab))
local convert_monyy = string.format("%.0f",math.floor(enaba))
send(msg.chat_id,msg.id, "⇜ تم حصاد شجر العنب 🍇\n⇜ العدد : "..math.floor(enabnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
enabsize = tonumber(enabnum) * 12.5
enabsizee = mzroatsize - enabsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(enabsizee))
Redis:del(TheMero.."enabtime"..(_bank_uid))
Redis:del(TheMero.."enabnum"..(_bank_uid))
Redis:del(TheMero.."enabname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد شجر زيتون' or text == 'حصد شجر الزيتون' or text == 'حصد شجره زيتون' or text == 'حصد شجره الزيتون' or text == 'حصد شجرة الزيتون' or text == 'حصد شجرة زيتون' or text == 'حصاد شجر زيتون' or text == 'حصاد شجر الزيتون' or text == 'حصاد شجره زيتون' or text == 'حصاد شجره الزيتون' or text == 'حصاد شجرة الزيتون' or text == 'حصاد شجرة زيتون' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."zetonnum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك شجر زيتون 🫒\n⇜ تستطيع زراعتها بالامر ( `زراعه شجر زيتون` )\n✧","md",true)
end
if Redis:get(TheMero.."zetontime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."zetontime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الزيتون بمزرعتك 🫒\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
zetonnum = Redis:get(TheMero.."zetonnum"..(_bank_uid))
zeton = tonumber(zetonnum) * 1800
zetona = tonumber(ballance) + tonumber(zeton)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(zetona))
local convert_mony = string.format("%.0f",math.floor(zeton))
local convert_monyy = string.format("%.0f",math.floor(zetona))
send(msg.chat_id,msg.id, "⇜ تم حصاد شجر الزيتون 🫒\n⇜ العدد : "..math.floor(zetonnum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
zetonsize = tonumber(zetonnum) * 15
zetonsizee = mzroatsize - zetonsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(zetonsizee))
Redis:del(TheMero.."zetontime"..(_bank_uid))
Redis:del(TheMero.."zetonnum"..(_bank_uid))
Redis:del(TheMero.."zetonname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد شجر موز' or text == 'حصد شجر الموز' or text == 'حصد شجره موز' or text == 'حصد شجره الموز' or text == 'حصد شجرة الموز' or text == 'حصد شجرة موز' or text == 'حصاد شجر موز' or text == 'حصاد شجر الموز' or text == 'حصاد شجره موز' or text == 'حصاد شجره الموز' or text == 'حصاد شجرة الموز' or text == 'حصاد شجرة موز' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."mozznum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك شجر موز 🍌\n⇜ تستطيع زراعتها بالامر ( `زراعه شجر موز` )\n✧","md",true)
end
if Redis:get(TheMero.."mozztime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."mozztime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج الموز بمزرعتك 🍌\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
mozznum = Redis:get(TheMero.."mozznum"..(_bank_uid))
mozz = tonumber(mozznum) * 2500
mozza = tonumber(ballance) + tonumber(mozz)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(mozza))
local convert_mony = string.format("%.0f",math.floor(mozz))
local convert_monyy = string.format("%.0f",math.floor(mozza))
send(msg.chat_id,msg.id, "⇜ تم حصاد شجر الموز 🍌\n⇜ العدد : "..math.floor(mozznum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mozzsize = tonumber(mozznum) * 20
mozzsizee = mzroatsize - mozzsize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(mozzsizee))
Redis:del(TheMero.."mozztime"..(_bank_uid))
Redis:del(TheMero.."mozznum"..(_bank_uid))
Redis:del(TheMero.."mozzname"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'حصد شجر مانجا' or text == 'حصد شجر المانجا' or text == 'حصد شجره مانجا' or text == 'حصد شجره المانجا' or text == 'حصد شجرة المانجا' or text == 'حصد شجرة مانجا' or text == 'حصاد شجر مانجا' or text == 'حصاد شجر المانجا' or text == 'حصاد شجره مانجا' or text == 'حصاد شجره المانجا' or text == 'حصاد شجرة المانجا' or text == 'حصاد شجرة مانجا' then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if not Redis:get(TheMero.."sizefram" .. (_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك مزرعه\n⇜ قم ببناء مزرعتك عن طريق الامر \n( `بناء مزرعه` )","md",true)
end
if not Redis:get(TheMero.."manganum"..(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ليس لديك شجر مانجا 🥭\n⇜ تستطيع زراعتها بالامر ( `زراعه شجر مانجا` )\n✧","md",true)
end
if Redis:get(TheMero.."mangatime"..(_bank_uid)) then
local hours = Redis:ttl(TheMero.."mangatime".. (_bank_uid)) / 60
return send(msg.chat_id,msg.id, "⇜ لم ينضج المانجا بمزرعتك 🥭\n⇜ انتظر "..math.floor(hours).." دقيقة ⏳\n✧️","md",true)
end
ballance = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
manganum = Redis:get(TheMero.."manganum"..(_bank_uid))
manga = tonumber(manganum) * 3500
mangaa = tonumber(ballance) + tonumber(manga)
Redis:set(TheMero.."boob"..(_bank_uid) , math.floor(mangaa))
local convert_mony = string.format("%.0f",math.floor(manga))
local convert_monyy = string.format("%.0f",math.floor(mangaa))
send(msg.chat_id,msg.id, "⇜ تم حصاد شجر المانجا 🥭\n⇜ العدد : "..math.floor(manganum).."\n⇜ السعر : "..convert_mony.." درهم 💵\n⇜ رصيدك الان : "..convert_monyy.." درهم 💵\n✧","md",true)
mzroatsize = Redis:get(TheMero.."mzroatsize"..(_bank_uid)) or 0
mangasize = tonumber(manganum) * 30
mangasizee = mzroatsize - mangasize
Redis:set(TheMero.."mzroatsize"..(_bank_uid) , math.floor(mangasizee))
Redis:del(TheMero.."mangatime"..(_bank_uid))
Redis:del(TheMero.."manganum"..(_bank_uid))
Redis:del(TheMero.."manganame"..(_bank_uid))
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'كنز' then
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."yiioooo" .. (_bank_uid)) >=60 then
local hours = Redis:ttl(TheMero.."yiioooo" .. (_bank_uid)) / 60
return send(msg.chat_id,msg.id,"⇜ فرصة ايجاد كنز آخر بعد "..math.floor(hours).." دقيقة","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser((_bank_uid))
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد اسم"
end
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
shkse = Redis:get(TheMero.."shkse"..(_bank_uid))
if shkse == "طيبة" then
if Descriptioont == "1" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قطعة اثرية 🗳\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "2" then
local knez = ballancee + 35000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : حجر الماسي 💎\n⇜ سعره : 35000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "3" then
local knez = ballancee + 10000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : لباس قديم 🥻\n⇜ سعره : 10000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "4" then
local knez = ballancee + 23000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : عصى سحرية 🪄\n⇜ سعره : 23000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "5" then
local knez = ballancee + 8000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جوال نوكيا 📱\n⇜ سعره : 8000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "6" then
local knez = ballancee + 27000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : صدف 🏝\n⇜ سعره : 27000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "7" then
local knez = ballancee + 18000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : ابريق صدئ ⚗️\n⇜ سعره : 18000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "8" then
local knez = ballancee + 100000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قناع فرعوني 🗿\n⇜ سعره : 100000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "9" then
local knez = ballancee + 50000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جرة ذهب 💰\n⇜ سعره : 50000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "10" then
local knez = ballancee + 36000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : مصباح فضي 🔦\n⇜ سعره : 36000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "11" then
local knez = ballancee + 29000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : لوحة نحاسية 🌇\n⇜ سعره : 29000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "12" then
local knez = ballancee + 1000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جوارب قديمة 🧦\n⇜ سعره : 1000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "13" then
local knez = ballancee + 16000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : اناء فخاري ⚱️\n⇜ سعره : 16000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "14" then
local knez = ballancee + 12000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : خوذة محارب 🪖\n⇜ سعره : 12000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "15" then
local knez = ballancee + 19000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : سيف جدي مرزوق 🗡\n⇜ سعره : 19000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "16" then
local knez = ballancee + 14000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : مكنسة جدتي رقية 🧹\n⇜ سعره : 14000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "17" then
local knez = ballancee + 26000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : فأس ارطغرل 🪓\n⇜ سعره : 26000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "18" then
local knez = ballancee + 22000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : بندقية 🔫\n⇜ سعره : 22000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "19" then
local knez = ballancee + 11000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : كبريت ناري 🪔\n⇜ سعره : 11000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "20" then
local knez = ballancee + 33000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : فرو ثعلب 🦊\n⇜ سعره : 33000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "21" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جلد تمساح 🐊\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "22" then
local knez = ballancee + 17000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : باقة ورود 💐\n⇜ سعره : 17000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "23" then
local Textinggtt = {"1", "2",}
local Descriptioontt = Textinggtt[math.random(#Textinggtt)]
if Descriptioontt == "1" then
local knez = ballancee + 17000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : باقة ورود 💐\n⇜ سعره : 17000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioontt == "2" then
local Textinggttt = {"1", "2",}
local Descriptioonttt = Textinggttt[math.random(#Textinggttt)]
if Descriptioonttt == "1" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جلد تمساح 🐊\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioonttt == "2" then
local knez = ballancee + 10000000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : حقيبة محاسب البنك 💼\n⇜ سعره : 10000000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
end
end
end
else
if Descriptioont == "1" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : كتاب سحر 📕\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "2" then
local knez = ballancee + 35000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : حقيبة ممنوعات 🎒\n⇜ سعره : 35000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "3" then
local knez = ballancee + 60000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : زئبق احمر 🩸\n⇜ سعره : 60000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "4" then
local knez = ballancee + 23000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : فيزا مسروقة 💳\n⇜ سعره : 23000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "5" then
local knez = ballancee + 20000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : ماريجوانا 🚬\n⇜ سعره : 20000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "6" then
local knez = ballancee + 27000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قطعة اثرية 🪨\n⇜ سعره : 27000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "7" then
local knez = ballancee + 18000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : سلا.ح ناري 🔫\n⇜ سعره : 18000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "8" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قطع فضة 🔗\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "9" then
local knez = ballancee + 20000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : سكين 🗡\n⇜ سعره : 20000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "10" then
local knez = ballancee + 36000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : مخطط عملية سطو 🧾\n⇜ سعره : 36000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "11" then
local knez = ballancee + 29000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : عملات مزورة 💴\n⇜ سعره : 29000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "12" then
local knez = ballancee + 200000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : سيارة مسروقة 🚙\n⇜ سعره : 200000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "13" then
local knez = ballancee + 80000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : سبيكة ذهب 🪙\n⇜ سعره : 80000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "14" then
local knez = ballancee + 75000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : الماس 💎\n⇜ سعره : 75000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "15" then
local knez = ballancee + 19000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : رشوة من تاجر 👥️️\n⇜ سعره : 19000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "16" then
local knez = ballancee + 14000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : علبة كبريت 🪔\n⇜ سعره : 14000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "17" then
local knez = ballancee + 26000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قفل 🔒\n⇜ سعره : 26000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "18" then
local knez = ballancee + 26000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قفل 🔒 \n⇜ سعره : 26000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "19" then
local knez = ballancee + 14000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : علبة كبريت 🪔\n⇜ سعره : 14000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "20" then
local knez = ballancee + 14000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : علبة كبريت 🪔\n⇜ سعره : 14000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "21" then
local knez = ballancee + 26000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : قفل 🔒 \n⇜ سعره : 26000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "22" then
local knez = ballancee + 17000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : صبار 🌵\n⇜ سعره : 17000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
elseif Descriptioont == "23" then
local knez = ballancee + 40000
Redis:set(TheMero.."boob"..(_bank_uid) , knez)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\n⇜ الكنز : جلد تمساح 🐊\n⇜ سعره : 40000 درهم 💵\n⇜ رصيدك الان : "..convert_mony.." درهم 💵\n✧","md",true)
Redis:setex(TheMero.."yiioooo" .. (_bank_uid),1800, true)
end
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'كم فلوسي' and tonumber(msg.reply_to_message_id) == 0 then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(ballancee) < 1 then
return send(msg.chat_id,msg.id, "⇜ ماعندك فلوس \n✧","md",true)
end
local convert_mony = string.format("%.0f",ballancee)
local inoi = tostring(convert_mony)
local intk = inoi:gsub("[^%d%-]",""):gsub(" ","-")
lan = "ar"
local rand = math.random(1,999)
os.execute("gtts-cli '"..intk.."' -l '"..lan.."' -o 'intk"..rand..".mp3'")
bot.sendAudio(msg.chat_id,msg.id,'./intk'..rand..'.mp3',tostring(inoi),"html",nil,tostring(inoi),"@FvvZv")
sleep(1)
os.remove("intk"..rand..".mp3")
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end

---------------
if text == "الغشاشين زرف" then
if msg.ControllerBot then
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد اسم"
end
zrfee = Redis:get(TheMero.."rrfff"..(_bank_uid)) or 0
local ty_users = Redis:smembers(TheMero.."rrfffid")
if #ty_users == 0 then
return send(chat_id,msg_id,"⇜ لا يوجد احد","md",true)
end
ty_anubis = "⇜ توب اعلى 20 شخص زرفوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = Redis:get(TheMero.."rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
ty_anubis = ty_anubis..emoo.." "..gflos.." 💵 l "..tt.." >> "..v[2].." \n"
gflous = string.format("%.0f", zrfee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ━━━━━━━━━\n• you) "..gflous.." 💵 l "..news.." \n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,ty_anubis..gg,"md",false, false, false, false, reply_markup)
end
end
if text == "توب الغش" or text == "توب الغشاشين" then
if msg.ControllerBot then
local bank_users = Redis:smembers(TheMero.."booob")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
top_mony = "⇜ توب اغنى 20 شخص :\n\n"
mony_list = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(mony_list) do
if num <= 20 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local user_tag = '['..user_name..'](tg://user?id='..v[2]..')'
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
top_mony = top_mony..emo.." "..convert_mony.." 💵 ꗝ "..tt.." >> `"..v[2].."`\n"
end
end
top_monyy = top_mony.."\n\n⇜ اي اسم مخالف او غش باللعب راح يتصفر وينحظر اللاعب"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_monyy,"md",false, false, false, false, reply_markup)
end
end
---------------
if text and text:match('^حظر حساب (.*)$') then
local UserName = text:match('^حظر حساب (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
Redis:set(TheMero.."bandid"..coniss,coniss)
send(msg.chat_id,msg.id, "⇜ تم حظر الحساب "..coniss.." من لعبة البنك\n✧","md",true)
end
end
if text and text:match('^الغاء حظر حساب (.*)$') then
local UserName = text:match('^الغاء حظر حساب (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
Redis:del(TheMero.."bandid"..coniss)
send(msg.chat_id,msg.id, "⇜ تم الغاء حظر الحساب "..coniss.." من لعبة البنك\n✧","md",true)
end
end
if text and text:match('^مراقبه (.*)$') or text and text:match('^مراقبة (.*)$') then
local UserName = text:match('^مراقبه (.*)$') or text:match('^مراقبة (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
Redis:set(TheMero.."morakba"..coniss,coniss)
local ban = bot.getUser(coniss)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
send(msg.chat_id,msg.id, "⌯ تم تشغيل وضع المراقبة \n\n⇜ اللاعب : "..news.."\n✧","md",true)
end
end
if text and text:match('^الغاء مراقبه (.*)$') or text and text:match('^الغاء مراقبة (.*)$') then
local UserName = text:match('^الغاء مراقبه (.*)$') or text:match('^الغاء مراقبة (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
Redis:del(TheMero.."morakba"..coniss)
local ban = bot.getUser(coniss)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم"
end
send(msg.chat_id,msg.id, "⌯ تم تعطيل وضع المراقبة \n\n⇜ اللاعب : "..news.."\n✧","md",true)
end
end
if text and text:match('^اضف كوبون (.*)$') then
local UserName = text:match('^اضف كوبون (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
numcobo = math.random(1000000000000,9999999999999);
local convert_mony = string.format("%.0f",coniss)
Redis:set(TheMero.."cobonum"..numcobo,numcobo)
Redis:set(TheMero.."cobon"..numcobo,coniss)
send(msg.chat_id,msg.id, "⌯ وصل كوبون \n\n⇜ المبلغ : "..convert_mony.." درهم 💵\n⇜ رقم الكوبون : `"..numcobo.."`\n\n⇜ طريقة استخدام الكوبون :\n⇜ تكتب ( كوبون + رقمه )\n⇜ مثال : كوبون 4593875\n✧","md",true)
end
end
if text == "كوبون" or text == "الكوبون" then
send(msg.chat_id,msg.id, "⌯ طريقة استخدام الكوبون :\n⇜ تكتب ( كوبون + رقمه )\n⇜ مثال : كوبون 4593875\n\n⇜ ملاحظة : الكوبون يستخدم لمرة واحدة ولشخص واحد\n✧","md",true)
end
if text and text:match('^كوبون (.*)$') then

local UserName = text:match('^كوبون (.*)$')
local coniss = coin(UserName)
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
cobnum = Redis:get(TheMero.."cobonum"..coniss)
if coniss == tonumber(cobnum) then
cobblc = Redis:get(TheMero.."cobon"..coniss)
ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
cobonplus = ballancee + cobblc
Redis:set(TheMero.."boob"..(_bank_uid) , cobonplus)
local ballancee = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballancee)
Redis:del(TheMero.."cobon"..coniss)
Redis:del(TheMero.."cobonum"..coniss)
send(msg.chat_id,msg.id, "⌯ وصل كوبون \n\n⇜ المبلغ : "..cobblc.." درهم 💵\n⇜ رقم الكوبون : `"..coniss.."`\n⇜ رصيدك الان : `"..convert_mony.."` درهم 💵\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ لا يوجد كوبون بهذا الرقم `"..coniss.."`\n✧","md",true)
end
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ","md",true)
end
end
if text and text:match("^اضف فلوس (.*)$") and msg.reply_to_message_id ~= 0 then
local UserName = text:match('^اضف فلوس (.*)$')
local coniss = coin(UserName)
if msg.ControllerBot then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعندها حساب بالبنك 🤣","md",true)  
return false
end
local ban = bot.getUser(Re(_bank_uid))
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد اسم"
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
bajiop = ballanceed + coniss
Redis:set(TheMero.."boob"..Re(_bank_uid) , bajiop)
ccccc = Redis:get(TheMero.."boobb"..Re(_bank_uid))
uuuuu = Redis:get(TheMero.."bbobb"..Re(_bank_uid))
ppppp = Redis:get(TheMero.."rrfff"..Re(_bank_uid)) or 0
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballanceed)
send(msg.chat_id,msg.id, "⇜ الاسم ↢ "..news.."\n⇜ الحساب ↢ "..ccccc.."\n⇜ بنك ↢ ( روبي )\n⇜ نوع ↢ ( "..uuuuu.." )\n⇜ الزرف ↢ ( "..ppppp.." دولار 💵 )\n⇜ صار رصيده ↢ ( "..convert_mony.." درهم 💵 )\n✧","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
end
end

if text and text:match('^اسحب (.*)$') or text and text:match('^سحب (.*)$') then

local UserName = text:match('^اسحب (.*)$') or text:match('^سحب (.*)$')
local coniss = coin(UserName)
cobnum = tonumber(Redis:get(TheMero.."bandid"..(_bank_uid)))
if cobnum == (_bank_uid) then
return send(msg.chat_id,msg.id, "⇜ حسابك محظور من لعبة البنك","md",true)
end
if Redis:sismember(TheMero.."booob",(_bank_uid)) then
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if Redis:ttl(TheMero.."iioood" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."iioood" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ من شوي عملت سحب استنى "..time.." ","md",true)
end
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) > 1000000001 then
return send(msg.chat_id,msg.id, "⇜ الحد الاعلى المسموح هو مليار درهم 💵\n✧","md",true)
end
if tonumber(coniss) < 999 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 1000 درهم 💵\n✧","md",true)
end
if tonumber(ballanceed) < tonumber(coniss) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي","md",true)
end
Redis:set(TheMero.."tdbelballance"..(_bank_uid) , coniss)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '🤑', data = (_bank_uid).."/sahb"},{text = '🤑', data = (_bank_uid).."/sahb"},{text = '🤑', data = (_bank_uid).."/sahb"},
},
{text = 'روبـي 🪄',url="t.me/FvvZv"}, 
}
}
return send(msg.chat_id,msg.id,"⇜ اختر الان :\n✧","md",false, false, false, false, reply_markup)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
-----
if text == 'كم فلوسه' and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Re(_bank_uid))
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
send(msg.chat_id,msg.id,"\n⇜ روبي ماعنده حساب بالبنك ","md",true)  
return false
end
if Redis:sismember(TheMero.."booob",Re(_bank_uid)) then
ballanceed = Redis:get(TheMero.."boob"..Re(_bank_uid)) or 0
local convert_mony = string.format("%.0f",ballanceed)
local inoi = tostring(convert_mony)
local intk = inoi:gsub("[^%d%-]",""):gsub(" ","-")
lan = "ar"
local rand = math.random(1,999)
os.execute("gtts-cli '"..intk.."' -l '"..lan.."' -o 'intk"..rand..".mp3'")
bot.sendAudio(msg.chat_id,msg.id,'./intk'..rand..'.mp3',tostring(inoi),"html",nil,tostring(inoi),"@FvvZv")
sleep(1)
os.remove("intk"..rand..".mp3")
else
send(msg.chat_id,msg.id, "⇜ ماعنده حساب بنكي ","md",true)
end
end
if text and text:match("^انطق (.*)$") or text and text:match("^انطقي (.*)$") then
local inoi = text:match("^انطق (.*)$") or text:match("^انطقي (.*)$")
inoi = tostring(inoi):sub(1, 200)
local intk = inoi:gsub("'", ""):gsub('"', ""):gsub("[;|&`$\\<>]", ""):gsub(" ","-")
if intk:match("%a") then
lan = "en"
else
lan = "ar"
end
local rand = math.random(1,999)
os.execute("gtts-cli '"..intk.."' -l '"..lan.."' -o 'intk"..rand..".mp3'")
bot.sendAudio(msg.chat_id,msg.id,'./intk'..rand..'.mp3',tostring(inoi),"html",nil,tostring(inoi),"@FvvZv")
os.remove("intk"..rand..".mp3")
end
if text == 'تبرع' then
if Redis:ttl(TheMero.."tabrotime" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."tabrotime" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ يمديك تتبرع بعد "..time.." ","md",true)
end
send(msg.chat_id,msg.id, "⇜ استعمل الامر كذا :\n\n⇜ `تبرع` المبلغ","md",true)
end
if text and text:match('^تبرع (.*)$') then
local UserName = text:match('^تبرع (.*)$')
local coniss = coin(UserName)
if not Redis:sismember(TheMero.."booob",(_bank_uid)) then
return send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
morakba = tonumber(Redis:get(TheMero.."morakba"..(_bank_uid)))
if morakba == (_bank_uid) then
send("-1001737102093",0,"⇜ الايدي : "..(_bank_uid).."\n⇜ القروب : "..msg.chat_id.."\n⇜ الرسالة : "..text.."\n✧","md",true)
end
if tonumber(coniss) > 10001 then
return send(msg.chat_id,msg.id, "⇜ الحد الاعلى المسموح به هو 10000 درهم \n✧","md",true)
end
if tonumber(coniss) < 999 then
return send(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 1000 درهم \n✧","md",true)
end
if Redis:ttl(TheMero.."tabrotime" .. (_bank_uid)) >=60 then
local time = ctime(Redis:ttl(TheMero.."tabrotime" .. (_bank_uid)))
return send(msg.chat_id,msg.id,"⇜ يمديك تتبرع بعد "..time.." ","md",true)
end
ballanceed = Redis:get(TheMero.."boob"..(_bank_uid)) or 0
if tonumber(coniss) > tonumber(ballanceed) then
return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي\n✧","md",true)
end
local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد اسم "
end
local bank_users = Redis:smembers(TheMero.."booob")
monyyy_list = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."boob"..v)
table.insert(monyyy_list, {tonumber(mony) , v})
end
table.sort(monyyy_list, function(a, b) return a[1] < b[1] end)
tabr = math.random(1,200)
winner_id = monyyy_list[tabr][2]
local user_name = bot.getUser(winner_id).first_name or Redis:get(TheMero..winner_id.."first_name:") or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
winner_mony = monyyy_list[tabr][1]
local convert_mony = string.format("%.0f",tonumber(coniss))
local tabrLock = TheMero.."lock:tabr:"..(_bank_uid)
if Redis:set(tabrLock, 1, "NX", "EX", 5) == nil then
  return send(msg.chat_id,msg.id, "⇜ عملية تبرع جارية، انتظر لحظة","md",true)
end
local new_donor = Redis:decrby(TheMero.."boob"..(_bank_uid), math.floor(tonumber(coniss)))
if tonumber(new_donor) < 0 then
  Redis:incrby(TheMero.."boob"..(_bank_uid), math.floor(tonumber(coniss)))
  Redis:del(tabrLock)
  return send(msg.chat_id,msg.id, "⇜ فلوسك ماتكفي\n✧","md",true)
end
taeswq = Redis:get(TheMero.."tabbroat"..(_bank_uid)) or 0
pokloo = tonumber(taeswq) + tonumber(coniss)
Redis:set(TheMero.."tabbroat"..(_bank_uid) , math.floor(pokloo))
Redis:incrby(TheMero.."boob"..winner_id, math.floor(tonumber(coniss)))
Redis:del(tabrLock)
ballanceeed = Redis:get(TheMero.."boob"..winner_id) or 0
Redis:sadd(TheMero.."taza",(_bank_uid))
Redis:setex(TheMero.."tabrotime" .. (_bank_uid),600, true)
local convert_monyy = string.format("%.0f",tonumber(ballanceeed))
tttt = "⌯ وصل تبرع 📄\n\n⇜ من : "..news.."\n⇜ المستفيد : "..user_name.."\n⇜ المبلغ : "..convert_mony.." درهم 💵 \n⇜ فلوس المستفيد الان : "..convert_monyy.." درهم 💵\n✧"
send(msg.chat_id,msg.id, tttt,"md",true)  
send(winner_id,0, "⌯ وصلك تبرعات من : "..news.."\n⇜ المبلغ : "..convert_mony.." درهم 💵","md",true)
end
if text == 'تبرعاتي' and tonumber(msg.reply_to_message_id) == 0 then

if Redis:sismember(TheMero.."booob",(_bank_uid)) then
ballancee = Redis:get(TheMero.."tabbroat"..(_bank_uid)) or 0
if tonumber(ballancee) < 1 then
return send(msg.chat_id,msg.id, "⇜ ماعندك تبرعات \n✧","md",true)
end
local convert_mony = string.format("%.0f",ballancee)
send(msg.chat_id,msg.id, "⇜ تبرعاتك : `"..convert_mony.."` درهم 💵","md",true)
else
send(msg.chat_id,msg.id, "⇜ ماعندك حساب بنكي ارسل ↢ ( `انشاء حساب بنكي` )","md",true)
end
end
if text == "توب التبرعات" or text == "توب المتبرعين" or text == "توب متبرعين" or text == "المتبرعين" or text == "متبرعين" then

local ban = bot.getUser((_bank_uid))
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
news = news:gsub("🇾🇪️",'')
news = news:gsub("🇹🇳",'')
news = news:gsub("🇸🇾",'')
news = news:gsub("🇸🇩",'')
news = news:gsub("🇸🇦",'')
news = news:gsub("🇶🇦",'')
news = news:gsub("🇵🇸",'')
news = news:gsub("🇴🇲",'')
news = news:gsub("🇲🇦",'')
news = news:gsub("🇱🇾",'')
news = news:gsub("🇱🇧",'')
news = news:gsub("🇰🇼️",'')
news = news:gsub("🇯🇴",'')
news = news:gsub("🇮🇶",'')
news = news:gsub("🇪🇬",'')
news = news:gsub("🇧🇭",'')
news = news:gsub("🇩🇿️",'')
news = news:gsub("🇦🇪",'')
else
news = " لا يوجد اسم"
end
ballancee = Redis:get(TheMero.."tabbroat"..(_bank_uid)) or 0
local bank_users = Redis:smembers(TheMero.."taza")
if #bank_users == 0 then
return send(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
top_mony = "⇜ توب اعلى 20 شخص بالتبرعات :\n\n"
tabr_list = {}
for k,v in pairs(bank_users) do
local mony = Redis:get(TheMero.."tabbroat"..v)
table.insert(tabr_list, {tonumber(mony) , v})
end
table.sort(tabr_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(tabr_list) do
if num <= 20 then
local _gu2 = bot.getUser(v[2]) or {}
local user_name = _gu2.first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
tt = tt:gsub("🇾🇪️",'')
tt = tt:gsub("🇹🇳",'')
tt = tt:gsub("🇸🇾",'')
tt = tt:gsub("🇸🇩",'')
tt = tt:gsub("🇸🇦",'')
tt = tt:gsub("🇶🇦",'')
tt = tt:gsub("🇵🇸",'')
tt = tt:gsub("🇴🇲",'')
tt = tt:gsub("🇲🇦",'')
tt = tt:gsub("🇱🇾",'')
tt = tt:gsub("🇱🇧",'')
tt = tt:gsub("🇰🇼️",'')
tt = tt:gsub("🇯🇴",'')
tt = tt:gsub("🇮🇶",'')
tt = tt:gsub("🇪🇬",'')
tt = tt:gsub("🇧🇭",'')
tt = tt:gsub("🇩🇿️",'')
tt = tt:gsub("🇦🇪",'')
tt = tt:gsub("@[%a%d_]+",'')
tt = tt:gsub("#[%a%d_]+",'')
local doltebank = Redis:get(TheMero.."doltebank"..v[2]) or " "
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_mony = top_mony..emo.." "..gflos.." 💵 l "..tt.." "..doltebank.." \n"
gflous = string.format("%.0f", ballancee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ━━━━━━━━━\n• you) "..gflous.." 💵 l "..news.." \n\n⇜ ملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'روبـي 🪄', url="t.me/FvvZv"},
},
}
}
return send(msg.chat_id,msg.id,top_mony..gg,"md",false, false, false, false, reply_markup)
end
end
end
return {TheMero = Runbank}