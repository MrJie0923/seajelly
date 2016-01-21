Coin = class("Coin",function()
    return cc.Sprite:createWithSpriteFrameName("coin0.png");
end)

function Coin.create()
    local self = Coin.new()
    return self
end

function Coin:ctor()
    self:setTag(EntityTag.coin);
    --体积
    self._volume = 1;
    --执行动作
    self:runAction(self:createAnimate());
end

function Coin:hide()
    self:setPhysicsBody(nil);
    self:setVisible(false);
end

function Coin:show()
    --绑定刚体
    self:initBody();
    self:setVisible(true);
end

function Coin:setVolume(v)
    self._volume = v
end
function Coin:getVolme()
    return self._volume;
end

function Coin:initBody()
    local phyBody = cc.PhysicsBody:createEdgeBox(self:getContentSize());
    phyBody:setCategoryBitmask(1);
    phyBody:setCollisionBitmask(1);
    phyBody:setContactTestBitmask(1);
    self:setPhysicsBody(phyBody);
end

function Coin:createAnimate()
    local frameCache = cc.SpriteFrameCache:getInstance();
    local frame = nil;
    --数组不行 要用vector
    local frameArray = {};
    --用一个列表保存所有SpriteFrame对象 
    for i = 0, 3 do
        -- 从SpriteFrame缓存池中获取CCSpriteFrame对象 
        frame = frameCache:getSpriteFrame(string.format("coin%d.png", i));
        table.insert(frameArray, frame);
    end 
    -- 使用SpriteFrame列表创建动画对象 
    local animation = cc.Animation:createWithSpriteFrames(frameArray);
    animation:setLoops(-1);
    animation:setDelayPerUnit(0.2);
    --将动画包装成一个动作 
    local action = cc.Animate:create(animation);
    return action;
end
