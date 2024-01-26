--I hate this script but it works

local function contains(table, val)
   for i=1,#table do
	   if table[i] == val then
		   return true
	   end
   end
   return false
end
local function compressStack(amount)
	--Some stupid hardcoded stuff
	turtle.transferTo(2,amount)
	turtle.transferTo(3,amount)
	turtle.transferTo(5,amount)
	turtle.transferTo(6,amount)
	turtle.transferTo(7,amount)
	turtle.transferTo(9,amount)
	turtle.transferTo(10,amount)
	turtle.transferTo(11,amount)
	turtle.craft(amount)
end
local function getNumber(name)
	--This is so fricking dumb
	local num = 0
	for i=1,9 do
		if string.find(name,tostring(i)) then
			num = i
		end
	end
	return num
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
		if contains(validItems,Item["name"]) or string.find(Item["name"],"allthecompressed:") and getNumber(Item["name"]) < 9 then
			local ItemCount=Item["count"]
			local CraftCount = ItemCount/9
			CraftCount = math.floor(CraftCount)
			if CraftCount ~= 0 then
				compressStack(CraftCount)
				for i=1,16 do
					turtle.select(i)
					turtle.drop()
				end
				turtle.select(1)
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
