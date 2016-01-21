require "Cocos2d"
require "Cocos2dConstants"
require "module/PlayScene.lua"
require "module/Common.lua"
require "module/Ranking.lua"
StartScene = class("StartScene",function()
    return  cc.Scene:create();
end)

function StartScene.create()
    local scene = StartScene.new()
    return scene
end

function StartScene:ctor()
    self._layerui = cc.Layer:create();
    self:addChild(self._layerui); 

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(self)
    else
        cc.Director:getInstance():runWithScene(self)
    end
    self:preLoadMusic();
    self:createBG();
    local panel = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/GameStart.ExportJson");
    UI.moveCenter(panel);
    self._layerui:addChild(panel);
    local btstart = panel:getChildByName("BTNplay");
    if btstart ~= nil then
        btstart:addTouchEventListener(function (sender, eventType) 
            if eventType == TOUCH_EVENT_ENDED then--ccui.Widget.TOUCH_ENDED then
                PlayScene.show();
            end
        end);
    end
    local btscore = panel:getChildByName("BTNscore");
    if btscore ~= nil then
        btscore:setEnabled(false);
        btscore:addTouchEventListener(function (sender, eventType) 
            if eventType == TOUCH_EVENT_ENDED then--ccui.Widget.TOUCH_ENDED then
                cclog("open score list !");
            end
        end);
    end
    rigistKeyboardEvent(self);
end

function StartScene:preLoadMusic()
    local audioEngin = cc.SimpleAudioEngine:getInstance();
    local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Background)
    audioEngin:preloadMusic(musicPath);
    musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Die)
    audioEngin:preloadEffect(musicPath);
    musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Fire)
    audioEngin:preloadEffect(musicPath);
    musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Lolita)
    audioEngin:preloadEffect(musicPath);
    musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_LolitaDie)
    audioEngin:preloadEffect(musicPath);
    musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_PickupCoin)
    audioEngin:preloadEffect(musicPath);
end

function StartScene:createBG()
    --背景1
    local spriteBg1 = cc.Sprite:create("res/scene/bk1.png");
    spriteBg1:setAnchorPoint(0, 0.5);
    spriteBg1:setPosition(0, UI.screenSize.height/2);
    --背景2
    local spriteBg2 = cc.Sprite:create("res/scene/bk2.png");
    spriteBg2:setAnchorPoint(0, 0.5);
    spriteBg2:setPosition(640, UI.screenSize.height/2);

    self._layerui:addChild(spriteBg1);
    self._layerui:addChild(spriteBg2);
    local shade = cc.Sprite:create("res/shade.png");
    self._layerui:addChild(shade);
    shade:setPosition(UI.screenSize.width / 2, UI.screenSize.height / 2)
end
