require "module/Coin.lua"
require "module/Rock.lua"
require "module/Lolita.lua"
require "module/Bullet.lua"
require "module/Pillar.lua"


GameManager = class("GameManager",function()
    return cc.Node:create()
end)

function GameManager.create(groundhight)
    local self = GameManager.new(groundhight)
    return self
end

function GameManager:ctor(groundhight)
    self.ground_hight = groundhight;
    self.m_coinArr = {} --金币/水滴  碰到后+1
    self.m_rockArr = {} --石头/地板上的障碍物 碰到后游戏结束
    self.m_pillarArr = {}--柱子/有高度的障碍物 碰到后游戏结束
    self.m_lolitaArr = {}--怪物/萝莉 跑动的障碍物 碰到后游戏结束
    self.m_bulletArr = {}--子弹 可以杀死对面跑来的怪物/萝莉
    self.m_added = 0;--增加值
    cc.SpriteFrameCache:getInstance():addSpriteFrames("res/ani/FrameAnimate0.plist","res/ani/FrameAnimate0.png");
end

function GameManager:newModule(arr, module, zorder)
    for k, v in pairs(arr) do
        if not v:isVisible() then
            do return v end
        end
    end
    local val = module.create();
    self:addChild(val, zorder or 1);
    table.insert(arr, val);
    return val;
end

function GameManager:update(dt)
    local dis = dt * BKGroundMoveSpeed;
    --金币/水滴 移动
    for k, coin in pairs(self.m_coinArr) do
        if coin:isVisible() then
            if coin:getPositionX() < -coin:getBoundingBox().width/2 then--不在屏幕
                coin:hide();
            else
                coin:setPositionX(coin:getPositionX() - dis);--让金币移动
            end
        end
    end
    --障碍物/石头移动
    for k, rock in pairs(self.m_rockArr) do
        if rock:isVisible() then
            if rock:getPositionX() < -rock:getBoundingBox().width/2 then--不在屏幕
                rock:hide();
            else
                rock:setPositionX(rock:getPositionX() - dis);--让石头移动
            end
        end
    end
    --萝莉移动
    for k, lolita in pairs(self.m_lolitaArr) do
        if lolita:isVisible() then
            if lolita:isRight() then
                if lolita:getPositionX() >= UI.screenSize.width+lolita:getBoundingBox().width/2 then
                    lolita:hide();
                else
                    lolita:setPositionX(lolita:getPositionX() + LolitaMoveSpeedL*dt);
                end
            else
                if lolita:getPositionX() <= -lolita:getBoundingBox().width/2 then
                    lolita:hide();
                else
                    lolita:setPositionX(lolita:getPositionX() - LolitaMoveSpeedR*dt);
                end
            end
        end
    end
   --子弹移动
    for k, bullet in pairs(self.m_bulletArr) do
        if bullet:isVisible() then
            if bullet:isRight() then
                if bullet:getPositionX() >= UI.screenSize.width+bullet:getBoundingBox().width/2 then
                    bullet:hide();
                else
                    bullet:setPositionX(bullet:getPositionX() + BulletMoveSpeedR*dt);
                end
            else
                if bullet:getPositionX() <= -bullet:getBoundingBox().width/2 then
                    bullet:hide();
                else
                    bullet:setPositionX(bullet:getPositionX() - BulletMoveSpeedR*dt);
                end
            end
        end
   end
    --遮挡柱子移动
    for k, pillar in pairs(self.m_pillarArr) do
        if pillar:isVisible() then
            if pillar:getPositionX() <= -pillar:Size().width/2 then
                pillar:hide();
            else
                pillar:setPositionX(pillar:getPositionX() - dis);
            end
        end
    end
end

function GameManager:doShoot(isRight, runner)
    local bullet = self:newModule(self.m_bulletArr, Bullet);
    if bullet ~= nil then
        local sz = bullet:getBoundingBox();
        local runnersize = runner:getBoundingBox();
        if isRight then
            bullet:toRight();
            bullet:setScale(1, 1);
            bullet:setPosition(runner:getPositionX() + runnersize.width/2 + sz.width/2 + 2, self.ground_hight + sz.height/2);
        else
            bullet:toLift();
            bullet:setScale(-1, 1);
            bullet:setPosition(runner:getPositionX() - runnersize.width/2 - sz.width/2 - 2, self.ground_hight + sz.height/2);
        end
        bullet:show();
    end
end

function GameManager:doRefresh()
    local rand = 0;
    if self.m_added >= 1 then
        rand = math.random(1, 4);
    else
        rand = math.random(1, 2);
    end 
    if  rand == 1 then
        local num = math.random(31, 151);
        local pillar = self:newModule(self.m_pillarArr, Pillar, 1);
        pillar:setPosition(UI.screenSize.width + pillar:Size().width/2, self.ground_hight+pillar:Size().height/2+num);
        pillar:show();
        self.m_added = math.min(self.m_added, math.floor(num/30));
    elseif rand == 2 then
        local num = math.random(1, RefreshWaterMax)
        for i=1, num do
            local coin = self:newModule(self.m_coinArr, Coin, 2);
            coin:setPosition(UI.screenSize.width + coin:getBoundingBox().width/2, self.ground_hight + coin:getBoundingBox().height*(i-0.5) + 2);
            coin:show();
        end
        self.m_added = math.min(num, 3 + math.floor(self.m_added/2));
    elseif rand == 3 then
        local num = 0;
        if self.m_added < RefreshRockMax then
            num = math.random(1, self.m_added)
        else
            num = math.random(1, RefreshRockMax)
        end
        local rock = self:newModule(self.m_rockArr, Rock, 3);
        rock:setVolume(num);
        rock:setPosition(UI.screenSize.width + rock:getBoundingBox().width/2, self.ground_hight - rock:getBoundingBox().height/2 + 30);
        rock:show();
        self.m_added = self.m_added - num;
    elseif rand == 4 then
        if math.random(1, 2) == 1 then
            local lolita = self:newModule(self.m_lolitaArr, Lolita, 4);
            lolita:toLift();
            lolita:setScale(-1, 1);
            lolita:getAnimation():play("run");
            lolita:setPosition(UI.screenSize.width + lolita:getBoundingBox().width/2, self.ground_hight + lolita:getBoundingBox().height/2);
            lolita:show();
        else
            local lolita = self:newModule(self.m_lolitaArr, Lolita, 4);
            lolita:toRight();
            lolita:setScale(1, 1);
            lolita:getAnimation():play("run");
            lolita:setPosition(-lolita:getBoundingBox().width/2, self.ground_hight + lolita:getBoundingBox().height/2);
            lolita:show();
        end
        self.m_added = self.m_added - 1;
        local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Lolita)
        cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
    end
end
