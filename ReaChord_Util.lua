--@noindex
--NoIndex: true

function ListX4(lst)
    local newLst = {}
    for i=1, 4 do
        for idx, val in ipairs(lst) do
            table.insert(newLst, val)
        end
    end
    return newLst
end

function StringTrim(s)
    return string.gsub(s, "%s+", "")
end


function StringSplit(str, sp)
    local result = {}
    local idx
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


function ListAddUniqValue(lst, val)
    for idx, item in ipairs(lst) do
        if item == val then
            return lst
        end
    end
    table.insert(lst, val)
    return lst
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

function ListIndex(lst, val)
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

function ListUniqExtend(aLst, bLst)
    local newLst = {}
    for _, val in ipairs(aLst) do
        newLst =ListAddUniqValue(newLst, val)
    end
    for _, val in ipairs(bLst) do
        newLst =ListAddUniqValue(newLst, val)
    end
    return newLst
end

function ListDeleteIndex(lst, index)
    local new_lst = {}
    for idx, item in ipairs(lst) do
        if idx ~= index then
            table.insert(new_lst, item)
        end
    end
    return new_lst
end

function SplitListAtIndex(lst, index)
    local l, r = {}, {}
    for idx, item in ipairs(lst) do
        if idx <=index then
            table.insert(l, item)
        else
            table.insert(r, item)
        end
    end
    return l, r
end

function DeepCopyList(lst)
    local ret = {}
    for i, v in ipairs(lst) do
        table.insert(ret, v)
    end
    return ret
end

function PermuteList(lst)
    local ret = {}
    local length = #lst
    local function backtrack(first) 
        if first == length then
            table.insert(ret, DeepCopyList(lst))
        end

        for i=first,length do
            lst[first], lst[i] = lst[i], lst[first]
            backtrack(first+1)
            lst[first], lst[i] = lst[i], lst[first]
        end
    end
    backtrack(1)
    return ret
end

function PrintList(lst) 
    for _, v in ipairs(lst) do
        print(v.."\n")
    end
end

function PrintNumListInLine(lst) 
    for _, v in ipairs(lst) do
        print(tostring(v).." ")
    end
    print("\n")
end