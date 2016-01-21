Lolita = class("Lolita",function()
    local module = "loli"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("res/ani/Lolita/" .. module .. ".ExportJson");
    return ccs.Armature:create(module);
end)

function Lolita.create()
    local self = Lolita.new()
    return self
end

function Lolita:ctor()
    self:setTag(EntityTag.lolita);
    --方向
    self._dir = 1; --1向右  2向左 
end

function Lolita:hide()
    self:setPhysicsBody(nil);
    self:setVisible(false);
	local musicPath = cc.FileUtils:getInstance():fullPathForFilename(Music_LolitaDie)
    cc.SimpleAudioEngine:getInstance():playEffect(musicPath, false)
end

function Lolita:show()
    --绑定刚体
    self:initBody();
    self:setVisible(true);
end

function Lolita:toRight()
    self._dir = 1
end
function Lolita:toLift()
    self._dir = 2
end
function Lolita:isRight()
    return self._dir == 1;
end

function Lolita:initBody()
    local sz = self:getBoundingBox();
    local phyBody = cc.PhysicsBody:createEdgeBox({width = sz.width*0.5, height = sz.height});
    phyBody:setCategoryBitmask(1);
    phyBody:setCollisionBitmask(1);
    phyBody:setContactTestBitmask(1);
    self:setPhysicsBody(phyBody);
end