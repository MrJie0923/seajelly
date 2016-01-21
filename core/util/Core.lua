core = core or {}
--打印table
function core.print(data, seg)
    if type(data)=="table" then
        if seg == nil then
            seg = "    ";
        else
            seg = seg.."    ";
        end
        for k, v in pairs(data) do
            print(seg.."k="..tostring(k).."\tv="..tostring(v));
            if type(v) == "table" then
                core.print(v, seg);
            end
        end
    elseif data == nil then
        print("core.print data is nil!!!");
        do return end
    else
        print(tostring(data));
    end
end
--截取字符串
function core.split(src, sep)
     local start = 1
     local spIndex = 1
     local spArray = {}
     while true do
          local lastIndex = string.find(src, sep, start)
          if not lastIndex then
               spArray[spIndex] = string.sub(src, start, string.len(src))
               break
          end
          spArray[spIndex] = string.sub(src, start, lastIndex - 1)
          start = lastIndex + string.len(sep)
          spIndex = spIndex + 1
     end
     return spArray
end
