local function contains(table, val)
   for i=1,#table do
       if table[i] == val then
           return true
       end
   end
   return false
end
local validItems = {
    "minecraft:cobblestone",
    "minecraft:netherrack",
    "minecraft:end_stone",
    "minecraft:cobbled_deepslate",
}
while true do
    sleep(1)
    turtle.suck()
    if turtle.getItemCount() > 0 then
        local Item = turtle.getItemDetail()
        if contains(validItems,Item["name"]) or string.find(Item["name"],"allthecompressed:") then
            local ItemCount=Item["count"]
            local CraftCount = ItemCount/9
            CraftCount = math.floor(CraftCount)
            if CraftCount ~= 0 then
                --Some stupid hardcoded stuff
                turtle.transferTo(2,CraftCount)
                turtle.transferTo(3,CraftCount)
                turtle.transferTo(5,CraftCount)
                turtle.transferTo(6,CraftCount)
                turtle.transferTo(7,CraftCount)
                turtle.transferTo(9,CraftCount)
                turtle.transferTo(10,CraftCount)
                turtle.transferTo(11,CraftCount)
                turtle.craft(CraftCount)
            end
        end
        turtle.turnLeft()
        turtle.turnLeft()
        for i=1,16 do
            turtle.select(i)
            turtle.drop()
        end
        turtle.select(1)
        turtle.turnLeft()
        turtle.turnLeft()
    end
end
