
local bkwidth = 640-1;
local offsetX = 0;
GroundManager = class("GroundManager",function()
    return cc.Node:create()
end)

function GroundManager.create()
    local self = GroundManager.new()
    return self
end

function GroundManager:ctor()
    --背景1
    self._bgSprite1 = cc.Sprite:create("res/scene/bk1.png");
    self._bgSprite1:setAnchorPoint(0, 0.5);
    self._bgSprite1:setPosition(0, UI.screenSize.height/2);
    self:addChild(self._bgSprite1);
    --背景2
    self._bgSprite2 = cc.Sprite:create("res/scene/bk2.png");
    self._bgSprite2:setAnchorPoint(0, 0.5);
    self._bgSprite2:setPosition(bkwidth-1,UI.screenSize.height/2);
    self:addChild(self._bgSprite2);
    --背景3
    self._bgSprite3 = cc.Sprite:create("res/scene/bk1.png");
    self._bgSprite3:setAnchorPoint(0, 0.5);
    self._bgSprite3:setPosition(bkwidth*2, UI.screenSize.height/2);
    self:addChild(self._bgSprite3);
    --背景4
    self._bgSprite4 = cc.Sprite:create("res/scene/bk2.png");
    self._bgSprite4:setAnchorPoint(0, 0.5);
    self._bgSprite4:setPosition(bkwidth*3, UI.screenSize.height/2);
    self:addChild(self._bgSprite4);

    --地面1
    self._groundSprite1 = cc.Sprite:create("res/scene/gd1.png");
    self._groundSprite1:setAnchorPoint(0, 1);
    self._groundSprite1:setPosition(0, GroundHight+30);
    self:addChild(self._groundSprite1);
    --地面2
    self._groundSprite2 = cc.Sprite:create("res/scene/gd2.png");
    self._groundSprite2:setAnchorPoint(0, 1);
    self._groundSprite2:setPosition(bkwidth, GroundHight+30);
    self:addChild(self._groundSprite2);
    --地面3
    self._groundSprite3 = cc.Sprite:create("res/scene/gd1.png");
    self._groundSprite3:setAnchorPoint(0, 1);
    self._groundSprite3:setPosition(bkwidth*2, GroundHight+30);
    self:addChild(self._groundSprite3);
    --地面4
    self._groundSprite4 = cc.Sprite:create("res/scene/gd2.png");
    self._groundSprite4:setAnchorPoint(0, 1);
    self._groundSprite4:setPosition(bkwidth*3, GroundHight+30);
    self:addChild(self._groundSprite4);
    offsetX = 0;
end

function GroundManager:update(dt)
    local posX1 = self._bgSprite1:getPositionX() - dt * BKGroundMoveSpeed;
    local posX2 = self._bgSprite2:getPositionX() - dt * BKGroundMoveSpeed;
    local posX3 = self._bgSprite3:getPositionX() - dt * BKGroundMoveSpeed;
    local posX4 = self._bgSprite4:getPositionX() - dt * BKGroundMoveSpeed;
    
    if posX1 <= -bkwidth then
        posX1 = posX1 + bkwidth*4;
    end
    if posX2 <= -bkwidth then
        posX2 = posX2 + bkwidth*4;
    end
    if posX3 <= -bkwidth then
        posX3 = posX3 + bkwidth*4;
    end
    if posX4 <= -bkwidth then
        posX4 = posX4 + bkwidth*4;
    end
    self._bgSprite1:setPositionX(posX1);
    self._bgSprite2:setPositionX(posX2);
    self._bgSprite3:setPositionX(posX3);
    self._bgSprite4:setPositionX(posX4);
    self._groundSprite1:setPositionX(posX1);
    self._groundSprite2:setPositionX(posX2);
    self._groundSprite3:setPositionX(posX3);
    self._groundSprite4:setPositionX(posX4);
end