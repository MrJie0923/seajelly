require "Cocos2d"
require "Cocos2dConstants"
require "extern"

-- cclog
cclog = function(...)
    print(string.format(...))
end
ccprint = ccprint or cclog
UI = UI or {};
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    -- initialize director
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    if nil == glview then
        glview = cc.GLViewImpl:createWithRect("HelloLua", cc.rect(0,0,900,640))
        director:setOpenGLView(glview)
    end
local designSize = {width = 960, height = 640}
--local fileUtils = cc.FileUtils:getInstance()
UI.screenSize = designSize;
--UI.designSize = designSize;
    local visibleSize = director:getVisibleSize()
    local origin = director:getVisibleOrigin()

    glview:setDesignResolutionSize(480, 320, cc.ResolutionPolicy.NO_BORDER)

    --turn on display FPS
    director:setDisplayStats(false)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(designSize.width, designSize.height, 0)
    math.randomseed(os.time()) 
    --引擎类
    require "core/util/Core.lua"
    require "core/util/UI.lua"
--[[
    --1 创建偷菜游戏，自带的例子场景
    cc.FileUtils:getInstance():addSearchPath("res")
    local scene = require("GameScene")
    local gameScene = scene.create()
    gameScene:playBgMusic()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
    
    --2 创建塔防游戏
    cc.FileUtils:getInstance():addSearchPath("Resources")
    cc.FileUtils:getInstance():addSearchPath("tafang_src")
    require "module/begin/BeginScene.lua"
    require "module/LoginUI.lua"
    BeginScene.show();
    --3 创建跑酷游戏
    cc.FileUtils:getInstance():addSearchPath("paoku_Resources")
    cc.FileUtils:getInstance():addSearchPath("paoku_src")
    require "module/GameScene.lua"
    GameScene.create();
]]--  
    --4 跑酷小游戏
    local sp = cc.FileUtils:getInstance():getSearchPaths()
        for k, v in pairs(sp) do
        cclog(v);
    end

    require "module/StartScene.lua"
    StartScene.create();

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
