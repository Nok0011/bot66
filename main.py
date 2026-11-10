import os
import asyncio
import re
from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command
from telethon import TelegramClient, events, Button
from telethon.sessions import StringSession
from telethon.errors import FloodWaitError, ChatAdminRequiredError
from telethon.tl.functions.account import UpdateProfileRequest
from telethon.tl.types import (
    MessageEntityStrike,
    MessageEntityUnderline,
    MessageEntityItalic,
    MessageEntityBold,
    MessageEntitySpoiler,
)
from datetime import datetime
from pytz import timezone

# ---------------- إعدادات -----------------
BOT_TOKEN = '8618914941:AAF5nSLlEbVa4erRQPOM8nM9_Th2IzKCKFw'
OWNER_ID = 1431354829

SOURCE_NAME = "Source Mix"
SOURCE_LINK = "https://t.me/Source_Mix"
DEVELOPER_NAME = "Mix"
DEVELOPER_LINK = "https://t.me/b_s_k"

# مكان حفظ جلسات telethon على القرص (غيّره لو مكانك مختلف)
SESSIONS_DIR = "./sessions"

bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

# ----------------- حالة المصنع -----------------
factory_open = True

# ----------------- تخزين الجلسات والحالة -----------------
INSTALL_SESSIONS = {}
ACTIVE_POSTING_TASKS = {}  # {session_name: {task_id: task}}
ACTIVE_CLOCK_TASKS = {}    # {user_id: task}
ACTIVE_ACCOUNTS = {}       # {user_id: {'client': client, 'session_name': str, 'original_name': str}}

# ----------------- تعريف الأزرار -----------------
BASE_KEYBOARD_INLINE = types.InlineKeyboardMarkup(inline_keyboard=[
    [
        types.InlineKeyboardButton(text=f"👨‍💻 {DEVELOPER_NAME}", url=DEVELOPER_LINK),
        types.InlineKeyboardButton(text=f"📡 {SOURCE_NAME}", url=SOURCE_LINK)
    ],
    [
        types.InlineKeyboardButton(text="🟢 ابدأ التنصيب الآن", callback_data="quick_install")
    ]
])

OWNER_CONTROL_BUTTONS = [
    [types.InlineKeyboardButton(text="🔒 قفل المصنع", callback_data="owner_close")],
    [types.InlineKeyboardButton(text="🔓 فتح المصنع", callback_data="owner_open")],
    [types.InlineKeyboardButton(text="🤖 إدارة البوتات المنصبة", callback_data="owner_manage_bots")]
]

KEYBOARD_MARKUP_FOR_COMMANDS = [
    [
        Button.url(f"{DEVELOPER_NAME}", DEVELOPER_LINK),
        Button.url(f"{SOURCE_NAME}", SOURCE_LINK)
    ]
]

# ----------------- قائمة الأوامر -----------------
COMMANDS_LIST_TEXT = (
    "📜 قائمة الأوامر المتاحة:\n\n"
    "⚠️ يجب إرسال الكليشة (النص/الصورة) مع التنسيق المطلوب في الرسائل المحفوظة والرد عليها بالأمر المناسب.\n\n"
    "⚙️ الأوامر الفردية (بالرد على الكليشة):\n"
    "<code>.نشر <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_باقتباس <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_مشطوب <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_تسطير <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_مائل <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_عريض <ثواني> <مُعرف_الكروب></code>\n"
    "<code>.نشر_تشويش <ثواني> <مُعرف_الكروب></code>\n\n"
    "🌍 الأوامر الجماعية:\n"
    "<code>.نشر_بالكل <ثواني></code>\n"
    "<code>.نشر_بالكل_اقتباس <ثواني></code>\n"
    "<code>.نشر_بالكل_مشطوب <ثواني></code>\n"
    "<code>.نشر_بالكل_تسطير <ثواني></code>\n"
    "<code>.نشر_بالكل_مائل <ثواني></code>\n"
    "<code>.نشر_بالكل_عريض <ثواني></code>\n"
    "<code>.نشر_بالكل_تشويش <ثواني></code>\n\n"
    "💬 النشر الخاص\n"
    "<code>.نشر_خاص</code>\n"
    "ينشر في جميع الشاتات الخاصة (نص، صورة، فيديو، صوت)\n\n"
    "🌟 مميزات خاصة\n"
    "⏱️ ساعة الاسم\n"
    "<code>.فتح_الساعه</code>\n"
    "يضيف ساعة بجانب اسم الحساب\n"
    "<code>.قفل_الساعه</code>\n"
    "يرجع الاسم مثل الأول\n\n"
    "🕹️ التحكم:\n"
    "<code>.وقف_نشر</code>\n"
    "<code>.اوامر</code>\n\n"
    f"Dev: <a href='{DEVELOPER_LINK}'>{DEVELOPER_NAME}</a> | Source: <a href='{SOURCE_LINK}'>{SOURCE_NAME}</a>"
)

# ----------------- وظائف مساعدة -----------------
def make_session_name(index):
    return f"user_acc_{index}"

def get_formatting_entities(text: str, style: str):
    if not text: return None
    length = len(text)
    start = 0
    if style == 'مشطوب': return [MessageEntityStrike(offset=start, length=length)]
    elif style == 'تسطير': return [MessageEntityUnderline(offset=start, length=length)]
    elif style == 'مائل': return [MessageEntityItalic(offset=start, length=length)]
    elif style == 'عريض': return [MessageEntityBold(offset=start, length=length)]
    elif style == 'تشويش': return [MessageEntitySpoiler(offset=start, length=length)]
    return None

async def start_user_client(session_str, api_id, api_hash):
    client = TelegramClient(StringSession(session_str), int(api_id), api_hash)
    return client

async def get_all_postable_chats(client: TelegramClient):
    chats = []
    try:
        async for dialog in client.iter_dialogs(limit=None):
            entity = dialog.entity
            if (hasattr(entity, 'megagroup') and entity.megagroup) or \
               (hasattr(entity, 'channel') and getattr(entity, 'broadcast', False) is False):
                chats.append(dialog.id)
        return list(set(chats))
    except Exception:
        return []

async def post_message_to_chats(client: TelegramClient, chat_ids: list, message_to_post, interval: int, quote_msg_id: int = None, style: str = None):
    message_text = getattr(message_to_post, "text", None) or getattr(message_to_post, "message", None)
    is_text_or_caption = message_text is not None and len(message_text) > 0
    entities = get_formatting_entities(message_text, style) if style and is_text_or_caption else None

    while True:
        for chat_id in chat_ids:
            try:
                if is_text_or_caption and entities:
                    file_to_send = getattr(message_to_post, "media", None)
                    await client.send_message(chat_id, message=message_text, file=file_to_send, entities=entities, reply_to=quote_msg_id, link_preview=False)
                else:
                    try:
                        await client.send_message(chat_id, message_to_post, reply_to=quote_msg_id, link_preview=False)
                    except TypeError:
                        await client.send_message(chat_id, message_to_post, reply_to=quote_msg_id)
            except FloodWaitError as e:
                await asyncio.sleep(e.seconds)
            except ChatAdminRequiredError:
                continue
            except Exception as e:
                if "unexpected keyword argument 'entities'" in str(e):
                    try:
                        await client.send_message(chat_id, message_to_post, reply_to=quote_msg_id, link_preview=False)
                    except Exception:
                        pass
                else:
                    # طباعة الخطأ للمراجعة
                    print(f"خطأ في النشر لـ {chat_id}: {e}")
        await asyncio.sleep(interval)

async def stop_all_posting_jobs(client_name: str):
    tasks = list(ACTIVE_POSTING_TASKS.get(client_name, {}).values())
    for t in tasks:
        t.cancel()
    ACTIVE_POSTING_TASKS.get(client_name, {}).clear()
    return len(tasks)

async def clock_loop(client: TelegramClient, user_id: int):
    original_name = ACTIVE_ACCOUNTS.get(user_id, {}).get('original_name', 'User')
    while True:
        try:
            now = datetime.now(timezone('Africa/Cairo')).strftime('%H:%M')
            await client(UpdateProfileRequest(first_name=f"{original_name} [{now}]"))
            await asyncio.sleep(60)
        except asyncio.CancelledError:
            try:
                await client(UpdateProfileRequest(first_name=original_name))
            except Exception:
                pass
            break
        except Exception as e:
            print(f"خطأ في مهمة الساعة لـ {user_id}: {e}")
            if isinstance(e, FloodWaitError):
                await asyncio.sleep(e.seconds + 5)
            else:
                await asyncio.sleep(10)

# ----------------- مهمة النشر الخاص (مستقلة قابلة لإعادة الاستخدام) -----------------
async def bulk_private_posting_task(client: TelegramClient, message_to_post, chat_ids: list, message_to_edit):
    for chat_id in chat_ids:
        try:
            await client.send_message(chat_id, message_to_post, link_preview=False)
            await asyncio.sleep(0.5)
        except asyncio.CancelledError:
            try:
                await message_to_edit.edit("⚠️ تم إلغاء مهمة النشر الخاص بواسطة المستخدم.")
            except Exception:
                pass
            raise
        except FloodWaitError as e:
            await asyncio.sleep(e.seconds)
        except Exception as e:
            print(f"خطأ في النشر الخاص لـ {chat_id}: {e}")

    try:
        await message_to_edit.edit(f"✅ تم نشر الكليشة بنجاح في {len(chat_ids)} شات خاص.")
    except Exception:
        pass

# ----------------- مراقب الرسائل المحفوظة (مكمّل) -----------------
def create_saved_messages_monitor(client: TelegramClient, client_name: str, user_id: int):
    """
    يربط معالج الرسائل المحفوظة على client ليعرض أوامر النشر والساعة والنشر الخاص.
    تأكد من استدعاء هذه الدالة بعد أن يبدأ client أو قبل run_until_disconnected.
    """

    @client.on(events.NewMessage(chats='me', outgoing=True))
    async def handler(event):
        message = event.message
        text = (message.text or "").strip()
        message_to_post = None
        if message.reply_to:
            try:
                message_to_post = await event.get_reply_message()
            except Exception:
                message_to_post = None

        # الأوامر المساعدة
        if text.lower() in [".اوامر", ".مساعدة", ".help"]:
            try:
                await client.send_message('me', COMMANDS_LIST_TEXT, parse_mode='html', buttons=KEYBOARD_MARKUP_FOR_COMMANDS, link_preview=False)
            except Exception:
                try:
                    await client.send_message('me', COMMANDS_LIST_TEXT, parse_mode='html', link_preview=False)
                except Exception:
                    pass
            try:
                await message.delete()
            except Exception:
                pass
            return

        # وقف النشر
        if text == ".وقف_نشر":
            stopped_count = await stop_all_posting_jobs(client_name)
            try:
                if stopped_count > 0:
                    await message.edit(f"✅ تم إيقاف جميع مهام النشر! ({stopped_count} مهمة ألغيت).")
                else:
                    await message.edit(f"❌ لا توجد مهام نشر جارية حالياً.")
            except Exception:
                pass
            return

        # فتح الساعة
        if text == ".فتح_الساعه":
            if user_id in ACTIVE_CLOCK_TASKS and not ACTIVE_CLOCK_TASKS[user_id].done():
                try:
                    await message.edit("⚠️ مهمة الساعة جارية بالفعل.")
                except Exception:
                    pass
                return
            task = asyncio.create_task(clock_loop(client, user_id))
            ACTIVE_CLOCK_TASKS[user_id] = task
            try:
                await message.edit("✅ تم تفعيل ساعة الاسم بنجاح.")
            except Exception:
                pass
            return

        # قفل الساعة
        if text == ".قفل_الساعه":
            if user_id not in ACTIVE_CLOCK_TASKS or ACTIVE_CLOCK_TASKS[user_id].done():
                try:
                    await message.edit("❌ لا توجد مهمة ساعة جارية لإيقافها.")
                except Exception:
                    pass
                return
            try:
                ACTIVE_CLOCK_TASKS[user_id].cancel()
            except Exception:
                pass
            ACTIVE_CLOCK_TASKS.pop(user_id, None)
            try:
                await message.edit("✅ تم إيقاف ساعة الاسم وإرجاع الاسم الأصلي.")
            except Exception:
                pass
            return

        # النشر الخاص
        if text == ".نشر_خاص":
            if not message_to_post:
                try:
                    await message.edit("❌ يجب الرد على الكليشة (نص/صورة/فيديو/صوت) للنشر الخاص.")
                except Exception:
                    pass
                return

            task_id = "private_post_bulk"
            if task_id in ACTIVE_POSTING_TASKS.get(client_name, {}):
                try:
                    await message.edit("⚠️ مهمة النشر الخاص جارية بالفعل. استخدم `.وقف_نشر` لإلغائها أولاً.")
                except Exception:
                    pass
                return

            try:
                await message.edit("⏳ جاري جلب جميع الشاتات الخاصة...")
            except Exception:
                pass

            private_chats = []
            try:
                async for dialog in client.iter_dialogs():
                    if dialog.is_user and not getattr(dialog.entity, "bot", False):
                        private_chats.append(dialog.id)
            except Exception:
                private_chats = []

            if not private_chats:
                try:
                    await message.edit("❌ لم يتم العثور على أي شاتات خاصة غير الروبوتات.")
                except Exception:
                    pass
                return

            task = asyncio.create_task(bulk_private_posting_task(client, message_to_post, private_chats, message))
            ACTIVE_POSTING_TASKS.setdefault(client_name, {})[task_id] = task
            try:
                await message.edit(f"✅ بدأ النشر الخاص في {len(private_chats)} شات. استخدم `.وقف_نشر` للإلغاء.")
            except Exception:
                pass
            return

        # أوامر النشر الجماعي/الفردي (بناءً على الرد على الكليشة)
        STYLES = {'مشطوب', 'تسطير', 'مائل', 'عريض', 'تشويش', 'اقتباس', 'copy'}
        STYLE_REGEX = "|".join(STYLES)

        if message_to_post:
            # نشر بالكل
            match_post_all = re.match(r"^\.نشر_بالكل(?:_(" + STYLE_REGEX + r"))?\s+(\d+)$", text)
            if match_post_all:
                style_key = match_post_all.group(1)
                interval = int(match_post_all.group(2))
                interval = max(interval, 5)
                quote_mode = (style_key == 'اقتباس')
                style = style_key if style_key and not quote_mode else None

                try:
                    await message.edit("⏳ جاري جلب الجروبات...")
                except Exception:
                    pass

                all_chats = await get_all_postable_chats(client)
                if not all_chats:
                    try:
                        await message.edit("❌ لم يتم العثور على أي جروبات للنشر.")
                    except Exception:
                        pass
                    return

                task_type = style_key if style_key else "copy"
                task_id = f"multi_{task_type}_{interval}"

                if task_id in ACTIVE_POSTING_TASKS.get(client_name, {}):
                    try:
                        await message.edit(f"⚠️ مهمة النشر هذه جارية بالفعل.")
                    except Exception:
                        pass
                    return

                quote_id = message_to_post.id if quote_mode else None
                task = asyncio.create_task(post_message_to_chats(client, all_chats, message_to_post, interval, quote_id, style))
                ACTIVE_POSTING_TASKS.setdefault(client_name, {})[task_id] = task
                try:
                    await message.edit(f"✅ بدأ النشر الجماعي ({len(all_chats)} كروب) بفاصل {interval} ثانية. (نمط: {style_key if style_key else 'نسخ عادي'})")
                except Exception:
                    pass
                return

            # نشر لمجموعة واحدة
            match_post_single = re.match(r"^\.نشر(?:_(" + STYLE_REGEX + r"))?\s+(\d+)\s+(-?\d+)$", text)
            if match_post_single:
                style_key = match_post_single.group(1)
                interval = int(match_post_single.group(2))
                chat_id = int(match_post_single.group(3))
                interval = max(interval, 5)
                quote_mode = (style_key == 'اقتباس')
                style = style_key if style_key and not quote_mode else None

                task_type = style_key if style_key else "copy"
                task_id = f"single_{chat_id}_{task_type}_{interval}"

                if task_id in ACTIVE_POSTING_TASKS.get(client_name, {}):
                    try:
                        await message.edit(f"⚠️ مهمة النشر لهذه المجموعة جارية بالفعل.")
                    except Exception:
                        pass
                    return

                quote_id = message_to_post.id if quote_mode else None
                task = asyncio.create_task(post_message_to_chats(client, [chat_id], message_to_post, interval, quote_id, style))
                ACTIVE_POSTING_TASKS.setdefault(client_name, {})[task_id] = task
                try:
                    await message.edit(f"✅ بدأ النشر في الكروب **{chat_id}** بفاصل {interval} ثانية. (نمط: {style_key if style_key else 'نسخ عادي'})")
                except Exception:
                    pass
                return

# ----------------- وظائف إدارة البوتات للمالك -----------------
async def owner_list_bots(q: types.CallbackQuery):
    if q.from_user.id != OWNER_ID:
        return
    users_list = []
    keyboard = []

    for user_id, data in ACTIVE_ACCOUNTS.items():
        try:
            user_details = await data['client'].get_me()
            name = user_details.first_name
        except Exception:
            name = f"حساب غير متاح ({user_id})"

        users_list.append(f"• ID: <code>{user_id}</code> | Name: {name}")
        keyboard.append([types.InlineKeyboardButton(text=f"🗑️ طرد {name}", callback_data=f"owner_kick_{user_id}")])

    if not users_list:
        text = "❌ لا توجد أي بوتات منصبة حالياً."
    else:
        text = "✅ قائمة البوتات المنصبة حالياً:\n\n" + "\n".join(users_list)
        keyboard.append([types.InlineKeyboardButton(text="💣 مسح جميع البوتات", callback_data="owner_kick_all")])

    keyboard.append([types.InlineKeyboardButton(text="🔙 لوحة التحكم", callback_data="owner_panel")])
    await q.message.edit_text(text, parse_mode='html', reply_markup=types.InlineKeyboardMarkup(inline_keyboard=keyboard))
    await q.answer()

async def owner_kick_bot(q: types.CallbackQuery):
    if q.from_user.id != OWNER_ID:
        return

    # data like: owner_kick_<user_id>  OR owner_kick_all
    parts = q.data.split('_')
    if len(parts) >= 3 and parts[1] == 'kick' and parts[2] == 'all':
        # طرد الكل
        await q.answer("⏳ جاري مسح جميع البوتات...", show_alert=True)
        kicked_count = 0
        for uid in list(ACTIVE_ACCOUNTS.keys()):
            try:
                client_data = ACTIVE_ACCOUNTS.pop(uid)
                # إيقاف الساعة والمهمات
                if uid in ACTIVE_CLOCK_TASKS:
                    try:
                        ACTIVE_CLOCK_TASKS.pop(uid).cancel()
                    except Exception:
                        pass
                try:
                    await client_data['client'].disconnect()
                except Exception:
                    pass
                try:
                    await stop_all_posting_jobs(client_data['session_name'])
                except Exception:
                    pass
                # حذف ملفات الجلسة
                for suffix in ["", ".session", ".session-journal", ".session.lock"]:
                    fname = os.path.join(SESSIONS_DIR, client_data.get('session_name', '') + suffix)
                    try:
                        if os.path.exists(fname):
                            os.remove(fname)
                    except Exception:
                        pass
                kicked_count += 1
            except Exception:
                pass

        await q.message.edit_text(f"💣 تم مسح جميع البوتات بنجاح! ({kicked_count} بوت تم طرده).", reply_markup=types.InlineKeyboardMarkup(inline_keyboard=[[types.InlineKeyboardButton(text="🔙 لوحة التحكم", callback_data="owner_panel")]]))
        return

    # طرد بوت مفرد
    try:
        user_id = int(parts[-1])
    except Exception:
        await q.answer("❌ خطأ في مُعرف المستخدم.", show_alert=True)
        return

    if user_id in ACTIVE_ACCOUNTS:
        client_data = ACTIVE_ACCOUNTS.pop(user_id)
        if user_id in ACTIVE_CLOCK_TASKS:
            try:
                ACTIVE_CLOCK_TASKS.pop(user_id).cancel()
            except Exception:
                pass
        try:
            await client_data['client'].disconnect()
        except Exception:
            pass
        try:
            await stop_all_posting_jobs(client_data['session_name'])
        except Exception:
            pass

        # حذف ملفات الجلسة المتعلقة
        for suffix in ["", ".session", ".session-journal", ".session.lock"]:
            fname = os.path.join(SESSIONS_DIR, client_data.get('session_name', '') + suffix)
            try:
                if os.path.exists(fname):
                    os.remove(fname)
            except Exception:
                pass

        await q.answer(f"✅ تم طرد البوت {user_id}", show_alert=True)
        await owner_list_bots(q)
    else:
        await q.answer("❌ هذا البوت غير موجود أو غير نشط.", show_alert=True)

# ----------------- البوت المصنع (معالجات الكولباك) -----------------
@dp.callback_query(lambda c: c.data == "owner_panel")
async def owner_panel_cb(q: types.CallbackQuery):
    if q.from_user.id != OWNER_ID:
        return
    start_message = "👋 مرحباً بك في مصنع الـ Userbot.\n\n🛠️ أنت المالك."
    kb = types.InlineKeyboardMarkup(inline_keyboard=BASE_KEYBOARD_INLINE.inline_keyboard + OWNER_CONTROL_BUTTONS)
    await q.message.edit_text(start_message, reply_markup=kb, parse_mode='html', disable_web_page_preview=True)
    await q.answer()

@dp.callback_query(lambda c: c.data == "owner_manage_bots")
async def owner_manage_bots_cb(q: types.CallbackQuery):
    await owner_list_bots(q)

@dp.callback_query(lambda c: c.data.startswith("owner_kick_"))
async def owner_kick_handler_cb(q: types.CallbackQuery):
    await owner_kick_bot(q)

@dp.callback_query(lambda c: c.data == "owner_open")
async def owner_open_cb(q: types.CallbackQuery):
    global factory_open
    if q.from_user.id != OWNER_ID:
        return await q.answer("غير مصرح", show_alert=True)
    factory_open = True
    await q.answer("✅ تم فتح المصنع")
    await owner_panel_cb(q)

@dp.callback_query(lambda c: c.data == "owner_close")
async def owner_close_cb(q: types.CallbackQuery):
    global factory_open
    if q.from_user.id != OWNER_ID:
        return await q.answer("غير مصرح", show_alert=True)
    factory_open = False
    await q.answer("⛔ تم قفل المصنع")
    await owner_panel_cb(q)

# ----------------- رسالة البداية والتنصيب -----------------
@dp.message(Command("start"))
async def start_handler(message: types.Message):
    user_id = message.from_user.id
    start_message = "👋 مرحباً بك في مصنع الـ Userbot.\n\n"
    if user_id == OWNER_ID:
        start_message += "🛠️ أنت المالك."
        kb = types.InlineKeyboardMarkup(inline_keyboard=BASE_KEYBOARD_INLINE.inline_keyboard + OWNER_CONTROL_BUTTONS)
    else:
        if not factory_open:
            start_message += "⚠️ المصنع مقفل حالياً."
            kb = BASE_KEYBOARD_INLINE
        else:
            start_message += "📥 اضغط زر 'ابدأ التنصيب الآن' للبدء فوراً."
            kb = BASE_KEYBOARD_INLINE
    await message.reply(start_message, parse_mode='html', reply_markup=kb, disable_web_page_preview=True)

@dp.message(lambda m: (m.text and m.text.strip().lower() == ".تنصيب") or (m.html_text and "<code>.تنصيب</code>" in m.html_text.lower()))
async def install_start(message: types.Message):
    if not factory_open and message.from_user.id != OWNER_ID:
        await message.reply("⚠️ المصنع مقفل حالياً.")
        return
    INSTALL_SESSIONS[message.from_user.id] = {'step': 'api_id'}
    await message.reply("📥 ارسل الآن API_ID للحساب:")

@dp.callback_query(lambda c: c.data == "quick_install")
async def quick_install_cb(q: types.CallbackQuery):
    user_id = q.from_user.id
    if not factory_open and user_id != OWNER_ID:
        await q.answer("⚠️ المصنع مقفل حالياً.", show_alert=True)
        return
    INSTALL_SESSIONS[user_id] = {'step': 'api_id'}
    await q.answer("✨ جاري البدء: ارسل الآن API_ID في نفس المحادثة.")
    try:
        await q.message.reply("📥 ارسل الآن API_ID للحساب:")
    except Exception:
        pass

@dp.message()
async def install_steps(message: types.Message):
    user_id = message.from_user.id
    if user_id not in INSTALL_SESSIONS:
        return
    sess = INSTALL_SESSIONS[user_id]
    step = sess['step']
    text = (message.text or '').strip()

    if step == 'api_id':
        if not text.isdigit():
            await message.reply("⚠️ API_ID يجب أن يكون رقم.")
            return
        sess['api_id'] = text
        sess['step'] = 'api_hash'
        await message.reply("📥 ارسل الآن API_HASH:")
        return

    if step == 'api_hash':
        sess['api_hash'] = text
        sess['step'] = 'string_session'
        await message.reply("📥 ارسل الآن STRING_SESSION:")
        return

    if step == 'string_session':
        sess['string_session'] = text
        await message.reply("⏳ جارٍ تنصيب الحساب...")
        client = None
        try:
            session_name = make_session_name(user_id)
            # تأكد أن مجلد الجلسات موجود (لو هتسجل ملفات جلسة لاحقاً)
            if not os.path.exists(SESSIONS_DIR):
                try:
                    os.makedirs(SESSIONS_DIR, exist_ok=True)
                except Exception:
                    pass

            client = await start_user_client(sess['string_session'], sess['api_id'], sess['api_hash'])
            await client.start()
            user_details = await client.get_me()
            ACTIVE_ACCOUNTS[user_id] = {
                'client': client,
                'session_name': session_name,
                'original_name': user_details.first_name,
            }

            # ربط مراقب الرسائل المحفوظة
            create_saved_messages_monitor(client, session_name, user_id)

            # شغّل العميل في مهمة منفصلة
            asyncio.create_task(client.run_until_disconnected())

            await message.reply(f"✅ تم تنصيب الحساب بنجاح! أرسل <code>.اوامر</code> في الرسائل المحفوظة.", parse_mode='html', disable_web_page_preview=True)
        except Exception as e:
            if client:
                try:
                    await client.disconnect()
                except Exception:
                    pass
            await message.reply(f"❌ فشل التنصيب: {type(e).__name__} - {e}")
        finally:
            INSTALL_SESSIONS.pop(user_id, None)

# ----------------- تشغيل البوت -----------------
async def main():
    print("Factory bot starting...")
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
