
GameOver = class("GameOver", function()
    return cc.Sprite:create("res/shade.png");
end)

function GameOver.create()
    local this = GameOver.new()
    return this
end

function GameOver:ctor()
    UI.moveCenter(self);
    local panel = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/GameOver.ExportJson");
    self:addChild(panel);
    panel:setAnchorPoint(0.5, 0.5);
    local sz = self:getContentSize();
    panel:setPosition(sz.width / 2, sz.height / 2)
    
    local obtainScore = PlayScene.getScore();
        
    local bt = panel:getChildByName("BTNok");
    if bt ~= nil then
        bt:addTouchEventListener(function (sender, eventType) 
            if eventType == TOUCH_EVENT_ENDED then--ccui.Widget.TOUCH_ENDED then
                --self:hide();
                StartScene.create()
            end
        end);
    end
    local btlogin = panel:getChildByName("BTNshare");
    if btlogin ~= nil then
        btlogin:addTouchEventListener(function(obj, ty) 
            if ty == TOUCH_EVENT_ENDED then
                cclog("btn share");
                --PlayScene.showUI(Ranking);
                local content = string.format("我的小软足足跑了%d分都没被妹子抓住，很给力哦~去appstore下载《SlimeRun！》试下吧~", obtainScore);
				platform.share(0, content, "")
            end
        end);
    end

    local bestscore = self:readScore();
    local score = panel:getChildByName("ALscore");
    if score ~= nil then
        --cclog("score:"..score:getDescription())
        --score:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER);
        score:setString(tostring(obtainScore));
        --cclog(bestscore);
        --cclog(obtainScore);
        if obtainScore > bestscore then
            self:saveScore(obtainScore)
            bestscore = obtainScore;
        end
    end
    local best = panel:getChildByName("ALbest");
    if best ~= nil then
        --best:setAlignment(cc.TEXT_ALIGNMENT_CENTER);
        best:setString(tostring(bestscore));
    end
    local medal = panel:getChildByName("IMGmedal");
    if medal ~= nil then
    end
end

function GameOver:saveScore(score)
    local writepath = cc.FileUtils:getInstance():getWritablePath() .. "score";
    --createDownloadDir("tmpdir");
    local file = io.open(writepath, 'w');
    if file ~= nil then
        file:write(tostring(score));
        file:close();
    else
        cclog("saveScore error, open file fail, path="..writepath);
    end
end

function GameOver:readScore()
    local res = 0;
    local writepath = cc.FileUtils:getInstance():getWritablePath() .. "score";
    local file = io.open(writepath, 'r');
    if file ~= nil then
        local data = file:read("*a"); -- 读取所有内容
        res = tonumber(data);
        if res == nil then
            res = 0;
        end
        file:close();
    else
        cclog("readScore error, open file fail, path="..writepath);
    end
    return res;
end