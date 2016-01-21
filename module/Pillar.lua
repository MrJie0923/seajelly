Pillar = class("Pillar",function()
    return cc.Sprite:create("res/pillar.png")
end)

function Pillar.create()
    local self = Pillar.new()
    return self
end

function Pillar:ctor()
    self:setTag(EntityTag.pillar);
    local sz = self:getBoundingBox();
    local phyBody = cc.PhysicsBody:createBox({width = sz.width*0.9, height = sz.height-14});
    phyBody:setCategoryBitmask(1);
    phyBody:setCollisionBitmask(1);
    phyBody:setContactTestBitmask(1);
    self:setPhysicsBody(phyBody);
    self._contsize = self:getBoundingBox();
end

function Pillar:hide()
    self:setVisible(false);
    self:setPosition(-200*math.random(1, 1000), -1);
end

function Pillar:show()
    self:setVisible(true);
end

function Pillar:Size()
    return self._contsize;
end