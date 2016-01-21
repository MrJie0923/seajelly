Bullet = class("Bullet",function()
    return cc.Sprite:createWithSpriteFrameName("bullet0.png");
    --return cc.Sprite:create("shuidi.png")
end)

function Bullet.create()
    local self = Bullet.new()
    return self
end

function Bullet:ctor()
    self:setTag(EntityTag.bullet);
    --体积
    self._volume = 1;
    --方向
    self._dir = 1; --1向右  2向左 
    --执行动作
    self:runAction(self:createAnimate());
end

function Bullet:hide()
    self:setPhysicsBody(nil);
    self:setVisible(false);
end

function Bullet:show()
    --绑定刚体
    self:initBody();
    self:setVisible(true);
end

function Bullet:toRight()
    self._dir = 1
end
function Bullet:toLift()
    self._dir = 2
end
function Bullet:isRight()
    return self._dir == 1;
end

function Bullet:createAnimate()
    local frameCache = cc.SpriteFrameCache:getInstance();
    local frame = nil;
    --数组不行 要用vector
    local frameArray = {};
    --用一个列表保存所有SpriteFrame对象 
    for i = 0, 3 do
        -- 从SpriteFrame缓存池中获取CCSpriteFrame对象 
        frame = frameCache:getSpriteFrame(string.format("bullet%d.png", i));
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

function Bullet:initBody()
    local phyBody = cc.PhysicsBody:createBox({width=30, height=20});
    phyBody:setCategoryBitmask(1);
    phyBody:setCollisionBitmask(1);
    phyBody:setContactTestBitmask(1);
    self:setPhysicsBody(phyBody);
end