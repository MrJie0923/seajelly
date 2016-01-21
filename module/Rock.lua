Rock = class("Rock",function()
    return cc.Sprite:create("res/rock.png")
end)

function Rock.create(vol)
    local self = Rock.new(vol)
    return self
end

function Rock:ctor(vol)
    --体积
    self._volume = vol or 1;
    self._cubage = self._volume; 
    self:setTag(EntityTag.rock);
    self._wave = Wave.create();
    --self:addChild(self._wave);
   --绘制裁剪区域
    local consz = self:getContentSize();
    local shap = cc.DrawNode:create();
    --local point = {cc.p(-consz.width/2,-consz.height/2), cc.p(consz.width/2, -consz.height/2), cc.p(consz.width/2, consz.height/2), cc.p(-consz.width/2, consz.height/2)};
    local point = {cc.p(0, 0), cc.p(consz.width, 0), cc.p(consz.width, consz.height), cc.p(0, consz.height)};
    shap:drawPolygon(point, 4, cc.c4f(355, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255));
    local cliper = cc.ClippingNode:create();
    cliper:setStencil(shap);
    --cliper:setAnchorPoint(cc.p(0.5, 0.5));
    self:addChild(cliper);
--把要滚动的加入到裁剪区域
    cliper:addChild(self._wave);
end

function Rock:hide()
    self:setPhysicsBody(nil);
    self:setVisible(false);
end

function Rock:show()
    --绑定刚体
    self:initBody();
    self:setVisible(true);
    self._wave:setHeightRate(0)
end

function Rock:setVolume(vol)
    self._volume = vol;
    self._cubage = vol;
    self:setScaleX(vol/RefreshRockMax);
    self:initBody();
end

function Rock:addVolume(vol)
    self._volume = self._volume - vol;
    if self._volume <= 0 then
        self:setPhysicsBody(nil);
        self._volume = 0;
    end

    self._wave:setHeightRate((self._cubage - self._volume)/self._cubage);
end

function Rock:initBody()
    local phyBody = cc.PhysicsBody:createEdgeBox(self:getBoundingBox());
    phyBody:setCategoryBitmask(1);
    phyBody:setCollisionBitmask(1);
    phyBody:setContactTestBitmask(1);
    self:setPhysicsBody(phyBody);
end


Wave = class("Wave",function()
    return cc.Sprite:createWithSpriteFrameName("wave0.png");
end)

function Wave.create()
    local self = Wave.new()
    return self
end

function Wave:ctor()
    local frameCache = cc.SpriteFrameCache:getInstance();
    local frame = nil;
    --数组不行 要用vector
    local frameArray = {};
    --用一个列表保存所有SpriteFrame对象 
    for i = 0, 3 do
        -- 从SpriteFrame缓存池中获取CCSpriteFrame对象 
        frame = frameCache:getSpriteFrame(string.format("wave%d.png", i));
        table.insert(frameArray, frame);
    end 
    -- 使用SpriteFrame列表创建动画对象 
    local animation = cc.Animation:createWithSpriteFrames(frameArray);
    animation:setLoops(-1);
    animation:setDelayPerUnit(0.3);
    --将动画包装成一个动作 
    local action = cc.Animate:create(animation);
    self:setPosition(self:getBoundingBox().width/2-10, 0)
    self:runAction(action);

    local waveDown = cc.Sprite:createWithSpriteFrameName("waveDown.png");
    self:addChild(waveDown);
    waveDown:setPosition(waveDown:getBoundingBox().width/2+9, -waveDown:getBoundingBox().height/2+12)
    --waveDown:setScaleY(4);
end

function Wave:setHeightRate(f)
    if f < 0 then
        self:setVisible(false);
    elseif f >= 1 then
        self:setPositionY(self:getBoundingBox().height/2+50);
    else
        self:setPositionY(self:getBoundingBox().height/2+(75*f-25));-- 
    end
end
