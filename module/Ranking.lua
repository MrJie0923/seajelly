
Ranking = class("Ranking", function()
    return cc.Sprite:create("res/shade.png");
end)

function Ranking.create()
    local this = Ranking.new()
    return this
end

function Ranking:ctor()
    UI.moveCenter(self);
    local panel = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/Ranking.ExportJson");
    self:addChild(panel);
    panel:setAnchorPoint(0.5, 0.5);
    local sz = self:getContentSize();
    panel:setPosition(sz.width / 2, sz.height / 2)
    local bt = panel:getChildByName("BTNok");
    if bt ~= nil then
        bt:addTouchEventListener(function (sender, eventType) 
            if eventType == TOUCH_EVENT_ENDED then--ccui.Widget.TOUCH_ENDED then
                self:setVisible(false);
            end
        end);
    end

    local best = panel:getChildByName("SVinfo");
    if best ~= nil then
        --best:setAlignment(cc.TEXT_ALIGNMENT_CENTER);
        
    end

end

