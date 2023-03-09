function ListX4(lst)
    local newLst = {}
    for i=1, 4 do
        for idx, val in ipairs(lst) do
            table.insert(newLst, val)
        end
    end
    return newLst
end


function StringSplit(str, sp)
    local result = {}
    local idx = 0
    while true do
        idx, _ = string.find(str, sp)
        if idx == nil then
            table.insert(result, str)
            break
        else
            table.insert(result, string.sub(str, 1, idx-1))
            str = string.sub(str, idx+string.len(sp), string.len(str))
        end
    end
    return result
end

function ListJoinToString(lst, sp)
    local result = ""
    for idx, item in ipairs(lst) do
        if idx>1 then
            result = result..sp..item
        else
            result = result..item
        end
    end
    return result
end

function ListIndex (lst, val)
    for idx, v in ipairs(lst) do
        if v == val then
            return idx
        end
    end
    return -1
end

function AListAllInBList(aLst, bLst)
    for _, aVal in ipairs(aLst) do
        if ListIndex(bLst, aVal) < 0 then
            return false
        end
    end
    return true
end


function AListInBListLen(aLst, bLst)
    local counter = 0
    for _, aVal in ipairs(aLst) do
        if ListIndex(bLst, aVal) > 0 then
            counter = counter + 1
        end
    end
    return counter
end


function ListExtend(aLst, bLst)
    local newLst = {}
    for _, val in ipairs(aLst) do
        table.insert(newLst, val)
    end
    for _, val in ipairs(bLst) do
        table.insert(newLst, val)
    end
    return newLst
end
