require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.GradientDrawable"
import "java.io.*"
import "java.net.*"
import "android.app.ProgressDialog"
import "android.content.DialogInterface"
import "android.content.Context"
import "android.net.ConnectivityManager"
import "android.net.NetworkInfo"

-- ============================================================
-- CONFIGURATION
-- ============================================================
local GITHUB_USER = "leteciasorianosos-lab"
local GITHUB_REPO = "TestUpdator"
local GITHUB_BRANCH = "main"

local RAW_URL = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/" .. GITHUB_BRANCH .. "/"

-- ============================================================
-- FUNCTIONS
-- ============================================================
function getShape(colorHex, radius, strokeWidth, strokeColorHex)
    local gd = GradientDrawable()
    gd.setColor(Color.parseColor(colorHex))
    gd.setCornerRadius(radius)
    if strokeWidth and strokeColorHex then
        gd.setStroke(strokeWidth, Color.parseColor(strokeColorHex))
    end
    return gd
end

function StyleButton(btn, bgColor, textColor, radius)
    btn.setTextColor(Color.parseColor(textColor or "#FFFFFF"))
    btn.setAllCaps(false)
    btn.setTextSize(14)
    btn.setTypeface(nil, Typeface.BOLD)
    local bg = GradientDrawable()
    bg.setCornerRadius(radius or 25)
    bg.setColor(Color.parseColor(bgColor))
    btn.setBackground(bg)
    btn.setPadding(25,15,25,15)
end

-- ============================================================
-- CHECK INTERNET
-- ============================================================
function isNetworkAvailable()
    local cm = activity.getSystemService(Context.CONNECTIVITY_SERVICE)
    local activeNetwork = cm.getActiveNetworkInfo()
    return activeNetwork ~= nil and activeNetwork.isConnected()
end

-- ============================================================
-- DOWNLOAD MAIN.LUA FROM GITHUB
-- ============================================================
function downloadMainLua()
    local mainUrl = RAW_URL .. "main.lua"
    local filePath = activity.getFilesDir().getAbsolutePath() .. "/main_update.lua"
    
    local success, err = pcall(function()
        local url = URL(mainUrl)
        local conn = url.openConnection()
        conn.setConnectTimeout(30000)
        conn.setReadTimeout(30000)
        
        local input = BufferedInputStream(conn.getInputStream())
        local output = FileOutputStream(filePath)
        
        local buffer = byte[8192]
        local len = input.read(buffer)
        
        while len ~= -1 do
            output.write(buffer, 0, len)
            len = input.read(buffer)
        end
        
        input.close()
        output.close()
    end)
    
    if success then
        return filePath
    else
        return nil, err
    end
end

-- ============================================================
-- LOAD UPDATED SCRIPT
-- ============================================================
function loadUpdatedScript()
    local filePath = activity.getFilesDir().getAbsolutePath() .. "/main_update.lua"
    local f = io.open(filePath, "r")
    
    if f then
        local content = f:read("*a")
        f:close()
        
        if content and content ~= "" then
            local chunk, err = loadstring(content)
            if chunk then
                chunk()
                return true
            end
        end
    end
    return false
end

-- ============================================================
-- SHOW UPDATE DIALOG
-- ============================================================
function showUpdateDialog()
    local dialogView = LinearLayout(activity)
    dialogView.setOrientation(LinearLayout.VERTICAL)
    dialogView.setPadding(40,30,40,30)
    dialogView.setBackground(getShape("#1A1A1A", 20, 2, "#00FFAA"))
    
    -- Title
    local title = TextView(activity)
    title.setText("🔄 UPDATE AVAILABLE")
    title.setTextColor(Color.parseColor("#00FFAA"))
    title.setTextSize(20)
    title.setTypeface(nil, Typeface.BOLD)
    title.setGravity(Gravity.CENTER)
    title.setPadding(0,0,0,20)
    dialogView.addView(title)
    
    -- Info
    local info = TextView(activity)
    info.setText("New update is available!\n\nDownload and install now?")
    info.setTextColor(Color.parseColor("#FFFFFF"))
    info.setTextSize(14)
    info.setGravity(Gravity.CENTER)
    info.setPadding(0,0,0,25)
    dialogView.addView(info)
    
    -- Progress
    local progressLayout = LinearLayout(activity)
    progressLayout.setOrientation(LinearLayout.VERTICAL)
    progressLayout.setVisibility(View.GONE)
    progressLayout.setPadding(0,0,0,15)
    
    local progressText = TextView(activity)
    progressText.setText("Downloading... 0%")
    progressText.setTextColor(Color.parseColor("#00FFAA"))
    progressText.setTextSize(13)
    progressLayout.addView(progressText)
    
    local progressBar = ProgressBar(activity)
    progressBar.setStyle(android.R.attr.progressBarStyleHorizontal)
    progressBar.setMax(100)
    progressBar.setProgress(0)
    progressLayout.addView(progressBar)
    
    dialogView.addView(progressLayout)
    
    -- Buttons
    local btnLayout = LinearLayout(activity)
    btnLayout.setOrientation(LinearLayout.HORIZONTAL)
    btnLayout.setGravity(Gravity.CENTER)
    btnLayout.setPadding(0,10,0,0)
    
    local updateBtn = Button(activity)
    updateBtn.setText("⬇️ DOWNLOAD")
    StyleButton(updateBtn, "#00FFAA", "#0A0A0A", 25)
    updateBtn.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1))
    btnLayout.addView(updateBtn)
    
    local laterBtn = Button(activity)
    laterBtn.setText("⏰ LATER")
    StyleButton(laterBtn, "#333333", "#FFFFFF", 25)
    laterBtn.setLayoutParams(LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1))
    btnLayout.addView(laterBtn)
    
    dialogView.addView(btnLayout)
    
    local dialog = AlertDialog.Builder(activity)
        .setView(dialogView)
        .setCancelable(false)
        .create()
    dialog.show()
    
    -- Update Button Click
    updateBtn.setOnClickListener(View.OnClickListener{
        onClick=function()
            progressLayout.setVisibility(View.VISIBLE)
            updateBtn.setEnabled(false)
            updateBtn.setText("⏳ DOWNLOADING...")
            laterBtn.setEnabled(false)
            
            thread(function()
                local filePath, err = downloadMainLua()
                
                if filePath then
                    activity.runOnUiThread(function()
                        progressBar.setProgress(100)
                        progressText.setText("✅ Download complete!")
                        dialog.dismiss()
                        Toast.makeText(activity, "✅ Update downloaded! Applying...", Toast.LENGTH_SHORT).show()
                        
                        local loaded = loadUpdatedScript()
                        if not loaded then
                            Toast.makeText(activity, "Restarting app...", Toast.LENGTH_SHORT).show()
                            local intent = activity.getPackageManager().getLaunchIntentForPackage(activity.getPackageName())
                            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                            activity.startActivity(intent)
                            activity.finish()
                            os.exit()
                        end
                    end)
                else
                    activity.runOnUiThread(function()
                        progressText.setText("❌ Download failed: " .. tostring(err))
                        progressText.setTextColor(Color.parseColor("#FF4444"))
                        updateBtn.setEnabled(true)
                        updateBtn.setText("⬇️ RETRY")
                        laterBtn.setEnabled(true)
                    end)
                end
            end)
        end
    })
    
    laterBtn.setOnClickListener(View.OnClickListener{
        onClick=function()
            dialog.dismiss()
            Toast.makeText(activity, "Update skipped.", Toast.LENGTH_SHORT).show()
        end
    })
end

-- ============================================================
-- CHECK FOR AUTO UPDATE
-- ============================================================
function checkAutoUpdate()
    -- Check internet
    if not isNetworkAvailable() then
        print("⚠️ No internet connection")
        return
    end
    
    -- Check if update already downloaded
    if loadUpdatedScript() then
        print("✅ Loaded existing update!")
        return
    end
    
    -- Check if there's an update on GitHub
    thread(function()
        local success, err = pcall(function()
            local url = URL(RAW_URL .. "main.lua")
            local conn = url.openConnection()
            conn.setConnectTimeout(5000)
            conn.setRequestMethod("HEAD")
            local code = conn.getResponseCode()
            
            if code == 200 then
                -- File exists on GitHub, ask to download
                activity.runOnUiThread(function()
                    showUpdateDialog()
                end)
            else
                print("ℹ️ No update available")
            end
        end)
        
        if not success then
            print("❌ Check failed: " .. tostring(err))
        end
    end)
end

-- ============================================================
-- START
-- ============================================================
Handler().postDelayed(Runnable{run = function()
    checkAutoUpdate()
end}, 3000)