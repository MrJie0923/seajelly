EntityTag = {
    runner = 1,
    coin = 2,
    rock = 3,
    lolita = 4,
    bullet = 5,
    pillar = 6,
}
--每次刷新的最大水滴数量
RefreshWaterMax = 5
--水坑的最大容量值
RefreshRockMax = 5
--地板高度/奔跑着所处位置的Y坐标
GroundHight = 150 
--奔跑着所处屏幕位置 的X坐标
RunnerPositionX = UI.screenSize.width/2 --屏幕中央
--背景移动速度
BKGroundMoveSpeed = 150
--右侧萝莉移动速度
LolitaMoveSpeedR = 225
--左侧萝莉移动速度
LolitaMoveSpeedL = 75
--水滴子弹移动速度
BulletMoveSpeedR = 225
--每颗子弹耗费水量
bodychangeper = 1
--斯莱曼初始缩放比,450*300->90*60
SilaimuInitRate = 0.2 
--拉伸倍率
stretchRateX = 0.66
stretchRateY = 2
--单位水滴膨大百分比，当初始高度60时，没滴水增加15
ExpansionRatio = 0.25
--吃到水滴后，体积膨大动画播放时长(秒）
ExpansionTime = 0.3

Music_Background = "res/sound/background.mp3";
Music_Die = "res/sound/die.mp3";
Music_Fire = "res/sound/fire.mp3";
Music_Lolita = "res/sound/lolita.mp3";
Music_LolitaDie = "res/sound/lolit_die.mp3";
Music_PickupCoin = "res/sound/pickup_coin.mp3";
--刷新间隔时间
function GetRefreshInterval(score)
    local t = 1.6 - score/200;
    if t < 0.8 then
        t = 0.8;
    end
    return t;
end

function rigistKeyboardEvent(scene)
    local function onKeyReleased(keyCode, event)
        cclog("touch keyCode="..keyCode.." event=")
        local label = event:getCurrentTarget()
        if keyCode == cc.KeyCode.KEY_BACK then
            cclog("BACK clicked!")
            cc.Director:getInstance():endToLua();
        elseif keyCode == cc.KeyCode.KEY_BACKSPACE  then
            cclog("BACKSPACE clicked!")
        elseif keyCode == cc.KeyCode.KEY_MENU  then
            cclog("MENU clicked!")
        end
    end
    local kblistener = cc.EventListenerKeyboard:create()
    kblistener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = scene:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(kblistener, scene)
end