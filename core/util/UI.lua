UI = UI or {}
--居中显示
function UI.moveCenter(obj)
    if obj ~= nil then
        local sz = obj:getBoundingBox();
        local anc = obj:getAnchorPoint();
        obj:setPosition(UI.screenSize.width/2 + sz.width * (anc.x - 0.5), UI.screenSize.height/2 + sz.height * (anc.y - 0.5));
    end
end

--切换到全屏
function UI.fullScreen(panel)
    if panel ~= nil then
        local sz = panel:getContentSize();
        if UI.screenSize.width ~= sz.width then
            panel:setScaleX(UI.screenSize.width / sz.width);
        end
        if UI.screenSize.height ~= sz.height then
            panel:setScaleY(UI.screenSize.height / sz.height);
        end
    end
end

--先裁剪后尺寸，然后切换到全屏，不改变长宽比
function UI.fullSceenFixed(panel)
    if panel ~= nil then
        local scale = nil;
        local sz = panel:getContentSize();
        if sz.width/sz.height > UI.screenSize.width/UI.screenSize.height then
            scale = 1 + (UI.screenSize.height - sz.height)/sz.height;
        else
            scale = 1 + (UI.screenSize.width - sz.width)/sz.width;
        end
        panel:setScale(scale or 1, scale or 1);
    end
end

function UI.createTextBtn(text, touchfunc, normalpath, touchpath, fontsize, fontname)
    local btnTitle = cc.Label:createWithSystemFont(text, fontname, fontsize);
    local norSprite = cc.Scale9Sprite:create(normalpath);
    local highLightSprite = cc.Scale9Sprite:create(touchpath);
    local outPutBtn = cc.ControlButton:create(btnTitle, norSprite);
    outPutBtn:setBackgroundSpriteForState(highLightSprite, cc.CONTROL_STATE_HIGH_LIGHTED);
    outPutBtn:setTitleColorForState(cc.c3b(255, 255, 255), cc.CONTROL_STATE_HIGH_LIGHTED )
    outPutBtn:registerControlEventHandler(touchfunc, cc.CONTROL_EVENTTYPE_TOUCH_DOWN)
    return outPutBtn;
end
