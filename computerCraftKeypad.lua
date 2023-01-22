local function save(list,name)
    local file = fs.open(name,"w")
    file.write(textutils.serialize(list))
    file.close()
end
function load(name)
    local file = fs.open(name,"r")
    local data = file.readAll()
    file.close()
    return textutils.unserialize(data)
end
local monitor = peripheral.find("monitor")
local function write(x,y,text)
    monitor.setCursorPos(x,y)
    monitor.write(text)
end
local function clear()
    monitor.clear()
end
local function writePad(offset)
    write(offset[1],offset[2],"7 8 9")
    write(offset[1],offset[2]+1,"4 5 6")
    write(offset[1],offset[2]+2,"1 2 3")
    write(offset[1]+2,offset[2]+3,"0")
end
local function writeCyan(x,y,text)
    monitor.setCursorPos(x,y)
    local tempStr = ""
    local tempStr0 = ""
    for i=1,#text do
        tempStr = tempStr.."9"
        tempStr0 = tempStr0.."0"
    end
    monitor.blit(text,tempStr0,tempStr)
end
local function writeRed(x,y,text)
    monitor.setCursorPos(x,y)
    local tempStr = ""
    local tempStr0 = ""
    for i=1,#text do
        tempStr = tempStr.."e"
        tempStr0 = tempStr0.."0"
    end
    monitor.blit(text,tempStr0,tempStr)
end
print("Load config/create new? (y/n)")
local doneChoosing = false
local loadOrSave = false
repeat
    local temp = string.lower(io.read())
    if temp == "y" then
        loadOrSave = true
        doneChoosing = true
    elseif temp == "n" then
        loadOrSave = false
        doneChoosing = true
    end
until doneChoosing
clear()
local redstoneSides = {}
if loadOrSave then
    local config = load("keypadConf.txt")
    redstoneSides = config[1]
else
    print("What sides do you want redstone on? \n(Do y when done)")
    doneChoosing = false
    repeat
        local temp = string.lower(io.read())
        if temp == "y" then
            doneChoosing = true
        else
            redstoneSides[#redstoneSides+1]=temp
        end
    until doneChoosing
end
term.clear()
local sound = false
if loadOrSave then
    local config = load("keypadConf.txt")
    sound = config[3]
else
    print("Sound? (Requires speaker)\n(y/n)")
    doneChoosing = false
    repeat
    local temp = string.lower(io.read())
        if temp == "y" then
            sound = true
            doneChoosing = true
        elseif temp == "n" then
            sound = false
            doneChoosing = true
        end
    until doneChoosing
end
term.clear()
local padPos = {2,2}
local padDict = {}
local function addToDict(dict,x,y,num)
    dict[tostring(x)..' '..tostring(y)] = num
end
local function grabDict(dict,x,y)
    return dict[tostring(x)..' '..tostring(y)]
end
local function padRow(dict,row,pos,start)
    addToDict(dict,pos[1],pos[2]+row,start)
    addToDict(dict,pos[1]+2,pos[2]+row,start+1)
    addToDict(dict,pos[1]+4,pos[2]+row,start+2)
end
addToDict(padDict,padPos[1]+2,padPos[2]+3,0)
padRow(padDict,2,padPos,1)
padRow(padDict,1,padPos,4)
padRow(padDict,0,padPos,7)
local currentPin = ""
local correctPin = ""
print("What do you want the pin to be? (length of 4)")
if loadOrSave then
    local config = load("keypadConf.txt")
    correctPin = config[2]
else
    doneChoosing = false
    repeat
        local temp = io.read()
        if #temp == 4 then
            if tonumber(temp,10) then
                doneChoosing=true
                correctPin = temp
            end
        end
    until doneChoosing
end
term.clear()
save({redstoneSides,correctPin,sound},"keypadConf.txt")
local speaker=nil
if sound then
    speaker = peripheral.find("speaker")
end
while true do
    clear()
    writePad(padPos)
    write(padPos[1],padPos[2]-1,currentPin)
    monitorEvent = {os.pullEvent("monitor_touch")}
    touchX=monitorEvent[3]
    touchY=monitorEvent[4]
    local curInput = grabDict(padDict,touchX,touchY)
    if curInput then
        currentPin = currentPin..tostring(curInput)
        writeCyan(touchX,touchY,tostring(curInput))
        write(padPos[1],padPos[2]-1,currentPin)
        if speaker then
            speaker.playNote("bit",2,12)
        end
        if #currentPin == #correctPin then
            if currentPin == correctPin then
                clear()
                writePad(padPos)
                writeCyan(padPos[1],padPos[2]-1,currentPin)
                if speaker then
                    speaker.playNote("bit",2,24)
                end
                os.sleep(.15)
                clear()
                writePad(padPos)
                write(padPos[1],padPos[2]-1,currentPin)
                os.sleep(.15)
                clear()
                writePad(padPos)
                writeCyan(padPos[1],padPos[2]-1,currentPin)
                if speaker then
                    speaker.playNote("bit",2,24)
                end
                os.sleep(.15)
                currentPin = ""
                clear()
                writePad(padPos)
                for i,v in pairs(redstoneSides) do
                    redstone.setAnalogOutput(v,15)
                end
                os.sleep(3)
                for i,v in pairs(redstoneSides) do
                    redstone.setAnalogOutput(v,0)
                end
            else
                clear()
                writePad(padPos)
                writeRed(padPos[1],padPos[2]-1,currentPin)
                if speaker then
                    speaker.playNote("bit",2,1)
                end
                os.sleep(.15)
                clear()
                writePad(padPos)
                write(padPos[1],padPos[2]-1,currentPin)
                os.sleep(.15)
                writePad(padPos)
                writeRed(padPos[1],padPos[2]-1,currentPin)
                if speaker then
                    speaker.playNote("bit",2,1)
                end
                os.sleep(.15)
                currentPin=""
                clear()
                writePad(padPos)
            end
        end
    end
    os.sleep(.15)
end
