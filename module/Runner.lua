RunnerState = {
    running = 0, --正常状态
    stretch = 1, --拉伸状态
    crouch = 2,  --按压状态，蹲伏
};

Runner = class("Runner",function()
    return cc.Node:create();
end)

function Runner.create()
    local self = Runner.new()
    return self
end

function Runner:ctor()
    self:setTag(EntityTag.runner);
    self:setAnchorPoint(0.5, 0.5);
    local module = "smile";
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ani/smile/" .. module .. ".ExportJson");
    self._armature = ccs.Armature:create(module);
    self:addChild(self._armature);
    --体积,可以射出的水滴数量
    self._volume = 0;
    --self:UpdateWithPriorityLua(self:update(), 0);
    self._touchId = -1;
    self._isDie = false;
    self._armature:getAnimation():setMovementEventCallFunc(function(target, movementType, movementId)  
        if movementType == 2 then
            if movementId == "die" then
                self._armature:getAnimation():stop();
                self:setVisible(false) 
                PlayScene.showUI(GameOver)
            elseif movementId == "run_2_tall" then
                self._armature:getAnimation():stop();
                self._armature:getAnimation():play("tall_run");
            elseif movementId == "run_2_short" then
                self._armature:getAnimation():stop();
                self._armature:getAnimation():play("short_run");
            elseif movementId == "short_atk_L" or movementId == "tall_atk_L" or movementId == "atk_L" 
                or movementId == "short_atk_R" or movementId == "tall_atk_R" or movementId == "atk_R" then
                self:onAtkEnd();
            end
            if self._isDie and movementId ~= "die" then
                self:Die();
            end
            --cclog("moveEventType : "..movementId);
        end
    end)
end

function Runner:getState()
    return self.m_state;
end

function Runner:getVolume()
    return self._volume;
end

function Runner:getTouchId()
    return self._touchId;
end

function Runner:setPos(x, y)
    self._posX = x;
    self._posY = y;
    self:setPositionX(self._posX)
end

function Runner:initBody(h)
    --根据不同状态设置不同刚体大小
    local rate = (1+self._volume * ExpansionRatio) * SilaimuInitRate;
    --创建runner的刚体
    local runerBody = cc.PhysicsBody:createBox({width=450*rate*0.3, height=h});
    --设置可以碰撞检测
    runerBody:setCategoryBitmask(1);
    runerBody:setCollisionBitmask(1);
    runerBody:setContactTestBitmask(1);
    --绑定刚体
    self:setPhysicsBody(runerBody);
end

function Runner:Die()
    self._armature:getAnimation():stop();
    self._armature:getAnimation():play("die", -1, 1);
    self._isDie = true;
    local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Die)
    cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
end

function Runner:doShootL()
    self._armature:getAnimation():stop();
    if self.m_state == RunnerState.crouch then
        self._armature:getAnimation():play("short_atk_L", -1, 1);
    elseif self.m_state == RunnerState.stretch then
        self._armature:getAnimation():play("tall_atk_L", -1, 1);
    else
        self._armature:getAnimation():play("atk_L", -1, 1);
    end
    local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Fire)
    cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
end

function Runner:doShootR()
    self._armature:getAnimation():stop();
    if self.m_state == RunnerState.crouch then
        self._armature:getAnimation():play("short_atk_R", -1, 1);
    elseif self.m_state == RunnerState.stretch then
        self._armature:getAnimation():play("tall_atk_R", -1, 1);
    else
        self._armature:getAnimation():play("atk_R", -1, 1);
    end
    local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_Fire)
    cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
end

function Runner:Run(bChangeAni)
    if self._isDie == true then
        do return end
    end
    self.m_state = RunnerState.running;
    local rate = (1+self._volume * ExpansionRatio) * SilaimuInitRate;
    self:setScale(rate, rate);
    local h = 300*rate;
    self:setPositionY(self._posY + h / 2)
    if bChangeAni ~= false then
        self._armature:getAnimation():stop();
        self._armature:getAnimation():play("run");
    end
    self._armature:setPosition(0, -150)
    self:initBody(h);
end

function Runner:StretchByTouchId(id, bChangeAni)
    if self._isDie == true then
        do return end
    end
    self._touchId = id;
    self.m_state = RunnerState.stretch;
    local rate = (1+self._volume * ExpansionRatio) * SilaimuInitRate
    self:setScale(rate, rate);
    local h = 600*rate;
    cclog("h="..h.." "..self:getAnchorPoint().x.." "..self:getAnchorPoint().y);
    self:setPositionY(self._posY + h / 2)
    if bChangeAni ~= false then
        self._armature:getAnimation():stop();
        self._armature:getAnimation():play("run_2_tall", -1, 1);
    end
    self._armature:setPosition(0, -300)
    self:initBody(600 * rate);
end

function Runner:CrouchByTouchId(id, bChangeAni)
    if self._isDie == true then
        do return end
    end
    self._touchId = id;
    self.m_state = RunnerState.crouch;
    local rate = (1+self._volume * ExpansionRatio) * SilaimuInitRate;
    self:setScale(rate, rate);
    local h = 150*rate;
    cclog("h="..h.." "..self:getAnchorPoint().x.." "..self:getAnchorPoint().y);
    self:setPositionY(self._posY + h / 2);--rate/stretchRateX, rate/stretchRateY
    if bChangeAni ~= false then
        self._armature:getAnimation():stop();
        self._armature:getAnimation():play("run_2_short", -1, 1);
    end
    self._armature:setPosition(0, -75)
    self:initBody(150 * rate);
end

function Runner:BodyChange(val)
    if self._volume + val >= 0 then
        self._volume = self._volume + val;
        if self.m_state == RunnerState.running then
            self:Run(false);
        elseif self.m_state == RunnerState.stretch then
            self:StretchByTouchId(self._touchId, false);
        elseif self.m_state == RunnerState.crouch then
            self:CrouchByTouchId(self._touchId, false);
        end
     --[[   local rate = (1+self._volume * ExpansionRatio) * SilaimuInitRate;
        self:setScale(rate, rate);
        local h = 150*rate;
        cclog("h="..h.." "..self:getAnchorPoint().x.." "..self:getAnchorPoint().y);
        self:setPositionY(self._posY + h / 2);--rate/stretchRateX, rate/stretchRateY
        self:initBody(150 * rate);]]--
        return true;
    end
    return false;
end

function Runner:CrashWater()
    performWithDelay(self, self:onCrashWater(), ExpansionTime);
    --self:stopAllActions()
--self:runAction(cc.ScaleTo.create(ExpansionTime, 1, 1));
end

function Runner:onCrashWater()
    return function()
        self:BodyChange(bodychangeper);
        local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_PickupCoin)
        cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
    end
end

function Runner:update()
    return function(dt) 
    end
end

function Runner:onAtkEnd()
    self._armature:getAnimation():stop();
    if self.m_state == RunnerState.crouch then
        self._armature:getAnimation():play("short_run");
    elseif self.m_state == RunnerState.stretch then
        self._armature:getAnimation():play("tall_run");
    else
        self._armature:getAnimation():play("run");
    end
end
