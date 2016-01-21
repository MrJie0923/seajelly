local m_runner = nil
local m_gameMgr = nil
local m_groundMgr = nil

require "module/GroundManager.lua"
require "module/GameManager.lua"
require "module/Runner.lua"
require "module/Common.lua"
require "module/GameOver.lua"
require "module/Ranking.lua"
PlayScene = {
    _mainscene = nil,
    _layermap = nil,
    _layerui = nil,
    _layermenu = nil,
    _touchsEffect = {},
}
function PlayScene.show()
    if PlayScene._mainscene == nil then
        --创建带有物理的Scene
        local scene = cc.Scene:createWithPhysics();
        PlayScene._mainscene = scene;
        PlayScene._layermap = cc.Layer:create();
        scene:addChild(PlayScene._layermap);
        PlayScene._layerui = cc.Layer:create();
        scene:addChild(PlayScene._layerui);
        PlayScene._layermenu = cc.Layer:create();
        scene:addChild(PlayScene._layermenu); 

        if cc.Director:getInstance():getRunningScene() then
            cc.Director:getInstance():replaceScene(scene)
        else
            cc.Director:getInstance():runWithScene(scene)
        end
        
        if cc.SimpleAudioEngine:getInstance():isMusicPlaying() == false then
            cc.SimpleAudioEngine:getInstance():playMusic(Music_Background, true);
        end
        --开启调试,将物理世界描绘出来，使得其可见
        local debug = false
        scene:getPhysicsWorld():setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
        PlayScene.initPhysicWorld();
        scene:getPhysicsWorld():setGravity(cc.p(0, 0));--重力G
        --创建背景
        m_groundMgr = GroundManager.create();
        PlayScene.addUI(m_groundMgr);
        --创建场景各种物件
        m_gameMgr = GameManager.create(GroundHight);
        PlayScene.addUI(m_gameMgr);
        --创建奔跑着
        m_runner = Runner.create();
        m_runner:setPos(RunnerPositionX, GroundHight);
        m_runner:Run();
        PlayScene.addUI(m_runner);
        --积分
        PlayScene.initScore();
        --开启update
        scene:scheduleUpdateWithPriorityLua(PlayScene.update, 0);
        --碰撞事件
        local contactListener = cc.EventListenerPhysicsContact:create();
        contactListener:registerScriptHandler(PlayScene.onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN);
        local eventDispatcher = scene:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, scene);
        --触摸事件
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(false);--设置是否向下传递触摸  
        listener:registerScriptHandler(PlayScene.ontouchbegin, cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(PlayScene.ontouchended, cc.Handler.EVENT_TOUCH_ENDED )
        listener:registerScriptHandler(PlayScene.ontouchmoved, cc.Handler.EVENT_TOUCH_MOVED )
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, PlayScene._layermap);
        --键盘事件
        rigistKeyboardEvent(scene);
        --iad
        platform.showAd(1);
    end
end

function PlayScene.addUI(panel, zorder)
    if panel ~= nil then
        PlayScene._layerui:addChild(panel, zorder or 1);
    end
end

function PlayScene.showUI(modu, zorder)
    local panel = modu.create();
    PlayScene.addUI(panel, zorder);
end
--[[
function PlayScene.addMenu(panel, zorder)
    if panel ~= nil then
        PlayScene._layermenu:addChild(panel, zorder or 1);
    end
end

function PlayScene.addMap(panel, zorder)
    if panel ~= nil then
        PlayScene._layermap:addChild(panel, zorder or 1);
    end
end]]--

function PlayScene.showGameOver(modu, zorder)
    --if PlayScene.gameoverPanel == nil then
        PlayScene.gameoverPanel = modu.create();
        PlayScene.addUI(PlayScene.gameoverPanel, zorder);
    --else
    --    PlayScene.gameoverPanel:setVisible(true);
   -- end
end

function PlayScene.initPhysicWorld()
    local visibleSize = cc.Director:getInstance():getVisibleSize();
    local origin = cc.Director:getInstance():getVisibleOrigin();
    --创建一个地板边界 的刚体
    local boundBody = cc.PhysicsBody:createEdgeSegment(origin, cc.p(visibleSize.width,0))
    --用一个Node 关联物理刚体
    local boundNode = cc.Node:create();
    boundNode:setPhysicsBody(boundBody);
    boundNode:setPosition(0, GroundHight);
    --PlayScene.addUI(boundNode);
end

function PlayScene.initScore()
    local label = cc.Label:createWithTTF("0", "res/fonts/Marker Felt.ttf", 32)
    PlayScene.addUI(label, 1)
    label:setPosition( cc.p(UI.screenSize.width/2, UI.screenSize.height - 100) )
    PlayScene._scorelabel = label;
    PlayScene._score = 0; 
end

function PlayScene.addScore(val)
    PlayScene._score = PlayScene._score + val;
    PlayScene._scorelabel:setString(tostring(PlayScene._score));
end

function PlayScene.getScore()
    return PlayScene._score
end

function PlayScene.update(dt)
    m_gameMgr:update(dt);
    m_groundMgr:update(dt);
    local interval = GetRefreshInterval(PlayScene._score); 
    if refresh_interval == nil or refresh_interval > interval then
        m_gameMgr:doRefresh();
        refresh_interval = 0;
        PlayScene.addScore(m_runner:getVolume()*2);
    else
        refresh_interval = refresh_interval + dt;
    end 
end

function PlayScene.crouchUp(pSender, event)
    --否则，在跳起来的时候，点击crouch 松开之后，状态就会变成running
    if m_runner:getState() == RunnerState.crouch then
        m_runner:stopAllActions();
        m_runner:Run();
    end
end

function PlayScene.onContactBegin(contact)
    local body_1 = contact:getShapeA():getBody():getNode();
    local body_2 = contact:getShapeB():getBody():getNode();
    if body_1 == nil or body_2 == nil then
        do return end
    end
    local tag1 = body_1:getTag();
    local tag2 = body_2:getTag();
    if tag1 == EntityTag.runner or tag2 == EntityTag.runner then
       if tag2 == EntityTag.runner then
            local temp = body_1;
            body_1 = body_2;
            body_2 = temp;
            tag2 = tag1;
        end
        --史莱姆和岩石（水坑）,萝莉，柱子相撞
        if tag2 == EntityTag.rock or tag2 == EntityTag.lolita or tag2 == EntityTag.pillar then
            PlayScene.GameOver();
        elseif tag2 == EntityTag.coin then
            body_2:hide(false);
            body_1:CrashWater();
            PlayScene.addScore(1);
        end
    elseif tag1 == EntityTag.bullet or tag2 == EntityTag.bullet then --水滴子弹
        if tag1 == EntityTag.lolita then--水滴子弹碰到萝莉
            body_2:hide();
            body_1:hide();
        elseif tag2 == EntityTag.lolita then
            body_1:hide();
            body_2:hide();
        elseif tag1 == EntityTag.rock then--水滴子弹碰到坑
            body_2:hide();
            body_1:addVolume(1);
        elseif tag2 == EntityTag.rock then
            body_1:hide();
            body_2:addVolume(1);
        end
    elseif tag1 == EntityTag.pillar or tag2 == EntityTag.pillar then --柱子
        if tag1 == EntityTag.lolita then--柱子碰到萝莉，萝莉死亡
            body_1:hide();
        elseif tag2 == EntityTag.lolita then
            body_2:hide();
        end
    elseif tag1 == EntityTag.rock or tag2 == EntityTag.rock then --坑
        if tag1 == EntityTag.lolita then--坑碰到萝莉，萝莉或跳或死亡
            body_1:hide();
        elseif tag2 == EntityTag.lolita then
            body_2:hide();
        end
    else
        do return false end
    end 
    return true;
end

function PlayScene.GameOver()
    cclog("gameover")
    if PlayScene._mainscene ~= nil then
        PlayScene._mainscene:unscheduleUpdate();
        PlayScene._mainscene = nil;
        --PlayScene.showUI(GameOver)
        m_runner:Die();
        m_gameMgr:setVisible(false);
        PlayScene._scorelabel:setVisible(false);
        cc.SimpleAudioEngine:getInstance():stopMusic();
    end
end


function PlayScene.ontouchbegin(touch, event)
    --上下左右，简单识别
    --获取触摸的X轴和Y轴    
    --local touchPoint = touch:getLocation(); --获取OpenGL坐标（即cocos2d-x坐标，原点在左下角）    
    --touch:getLocationInView();
    PlayScene._touchsEffect[touch:getId()] = true;
    return true;
end

function PlayScene.ontouchended(touch, event)
    if m_runner:getTouchId() == touch:getId() then
        m_runner:Run();
    end
end

function PlayScene.ontouchmoved(touch, event)
    --上下左右，简单识别
    --获取X轴和Y轴的移动范围    
    local touchId = touch:getId();
    if not PlayScene._touchsEffect[touchId] then
        do return end
    end
    local touchPoint = touch:getLocation(); --获取OpenGL坐标（即cocos2d-x坐标，原点在左下角）    
    local startPoint = touch:getStartLocation();
    local endX = startPoint.x - touchPoint.x;
    local endY = startPoint.y - touchPoint.y;
    if  math.abs(endX) > 100 or math.abs(endY) > 100 then--移动至少100个像素
        --判断X轴和Y轴的移动距离，如果X轴的绝对值大，则向左右滑动，如果Y轴的绝对值大，则向上下滑动    
        if  math.abs(endX) > math.abs(endY) then
            --手势向左右    
            if m_runner:BodyChange(-bodychangeper) then
                --判断向左还是向右    
                if endX + 5 > 0 then
                    ccprint("向左\n");
                    m_gameMgr:doShoot(false, m_runner);
                    m_runner:doShootL();
                else
                    ccprint("向右\n");
                    m_gameMgr:doShoot(true, m_runner);
                    m_runner:doShootR();
                end
            else    
                ccprint("无水")
            end
        else
            --手势向上下    
            --判断手势向上还是向下    
            if endY + 5 > 0 then
                ccprint("向下\n");
                m_runner:CrouchByTouchId(touchId);
            else
                ccprint("向上\n");
                m_runner:StretchByTouchId(touchId);
            end
        end
        PlayScene._touchsEffect[touchId] = false;
    end
    return true;
end