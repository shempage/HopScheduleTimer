--
-- hop schedule timer
--
supportedOrientations(LANDSCAPE_ANY)
function startTimer()
    if timerRunning then
        return
    end
    timerRunning = true
    startTimerTime=os.time()
    createLocalNotification()
end

-- Calls native code in addons to create local notification for
-- all hop times excluding the first hop start as that happens as soon as they start time
-- do include a boil complete notification
-- also, dont have duplicate notifications for the same time
function createLocalNotification()
    local uniqueStartTimeTable={}
    for i,v in ipairs(indexedTableOfAll) do
        if(v.time ~= boilTime) then
            uniqueStartTimeTable[boilTime-v.time] = 1 -- unique insertion for when insert notification should fire
        else
            uniqueStartTimeTable[boilTime] = 1 -- unique insertion for when final notification should fire
        end
    end

    if _createLocalNotification ~= nill then
        for i,v in pairs(uniqueStartTimeTable) do
            _createLocalNotification(i)
        end
	end
end

-- Calls native code in addons to clear all notifications
function clearAllLocalNotifications()
    if _clearAllLocalNotifications ~= nill then
        _clearAllLocalNotifications()
    end
end

function resetTimer()
    if timerRunning then
        timerRunning = false
        setAlarmRecordsToZero()
        clearAllLocalNotifications()
    end
end

function clearAlarm()
    showClearAlarmButton = false
    for i =1, hopCount do
        if isAlarming[i] == true then
            isAlarming[i] = false
            colourHopAlarmed = colourHopAlarmed-1
            hopPastAlarmingCount = hopPastAlarmingCount + 1
        end
    end
end

function drawTimerButton()
    font(bntFont)
    toggledButton.pos = vec2(WIDTH/2 ,toggledButton.size.y)
    toggledButton:draw()
end

function drawclearAlarmButton()
    font(bntFont)
    clearalarmbutton.pos = vec2(WIDTH -(toggledButton.size.x/2), clearalarmbutton.size.y)
    clearalarmbutton:draw()
end

function touched(touch)
    clearalarmbutton:touched(touch)
    toggledButton:touched(touch)
    areYouSureChecker:touched(touch)

    for i,r in pairs(hoptextrow) do
        r.box:touched(touch)
        numbox = hopnumber[i]
        numbox.box:touched(touch)
        delhoprow=delhoprowbutton[i]
        delhoprow.btn:touched(touch)
    end
    addhopbutton:touched(touch)
end

function keyboard(key)
    for i,r in pairs(hoptextrow) do
        r.box:keyboard(key)
        numbox = hopnumber[i]
        -- Dont send max value to first Number box
        if i == 1 then
            numbox.box:keyboard(key)
            boilTime = tonumber(hopnumber[1].box:getText()) --Update boiltime from first row
        else
            numbox.box:keyboard(key, boilTime)
        end
    end
end

function toggleTimerButton()
    loadHopsFromInput()
    sortHopsInTimeOrder()
    font(bntFont)
    fontSize(inputFontSize)
    if timerRunning then
            displayAreYouSureChecker = true  --Let the pop up deal with results  
    else
        setAlarmRecordsToZero()
        startTimer()
        toggledButton.displayName = "Stop Timer and Reset"
    end
end

function drawAreYouSureChecker()
    areYouSureChecker.pos = vec2(WIDTH/2 ,HEIGHT/2)
    areYouSureChecker:draw()
end

function confirmResetTimer()
    resetTimer()
    toggledButton.displayName = "Start Timer"
    displayAreYouSureChecker = false
end

function declineResetTimer()
    displayAreYouSureChecker = false
end



function loadHopsFromInput()
    --Clean out all hop entries
    for i =0, hopCount do
        _G["hopName_"..i] = nil
        _G["startTime_"..i] = nil   
    end
    local hopEntryIndex = 0
    
    for inputFormIndex=1, alwaysInc do
        r = hoptextrow[inputFormIndex]
        if  r ~= nil then
            _G["hopName_"..hopEntryIndex] = r.box:getText()
            local boxNum = tonumber(hopnumber[inputFormIndex].box:getText())
                --Protect against empty inputs
                if boxNum == nil then boxNum = 0 end
                -- Dont allow input larger than boil Time
            if boxNum > boilTime then 
                boxNum = boilTime  
                alert("", "A Hop Time exceeds Max boil time, and has been reduced. Check your schedule") 
            end 
            _G["startTime_"..hopEntryIndex] = boxNum
            hopEntryIndex = hopEntryIndex+1
        end
    end
    --Boil time is the first entry.
    boilTime = tonumber(hopnumber[1].box:getText())
end

function setAlarmRecordsToZero()
    for i =0, hopCount do
        hasAlarmed[i] = false
        isAlarming[i]= false
    end
    hopPastAlarmingCount = 0 
    showClearAlarmButton = false
end


function     disableSleep()
    if _disableScreenTimer ~= nill then
        _disableScreenTimer()
    end
end

function setup()
    disableSleep()
 --displayMode(FULLSCREEN)
    displayMode(FULLSCREEN_NO_BUTTONS)
    img = readImage("Documents:wall")
    
    timerFont = "Copperplate-Bold"
    inputFont= "Courier"
    bntFont  = "AmericanTypewriter"
    remainingTimeFont="Optima-ExtraBlack"
    listHopsFont ="AmericanTypewriter"
    inputFontSize = 22
    textLabelColor = color(150, 173, 168, 255)
    
    timerRunning = false
    timerRadius = 200
    timerFontSize = 45
    listHopsFontSize = 39
     
    tx, ty = WIDTH -(timerRadius*1.25), HEIGHT / 2  
    
    boilTime = 60
    hopCount = 0
    endAngle = 0
    hopPastAlarmingCount = 0
    hopTimePast={}
    hasAlarmed = {}
    isAlarming = {}
    showClearAlarmButton = false
    
    
    -- input form setup
    setupInputForm()
    
    setAlarmRecordsToZero()

    hopColour = {
    color(0, 0, 255, 120),
    color(255, 0, 0, 114),
    color(255, 255, 0, 111),
    color(255, 255, 255, 118),
    color(0, 255, 0, 121),
    color(0, 255, 255, 125),
    color(254, 0, 255, 118),
    color(192, 192, 192, 128),
    color(103, 79, 79, 132),
    color(241, 255, 0, 131),
    color(93, 127, 124, 120)
    }
    overlayColour = color(113, 141, 141, 60)
       alarmOverlayColour= color(255, 0, 0, 60)
        
    
    -- set up timer start stop button
    toggledButton = Button("Start Timer")
    toggledButton.action = function () toggleTimerButton() end
    
    clearalarmbutton = Button("Clear Alarms")
    clearalarmbutton.action = function () clearAlarm() end
    
    displayAreYouSureChecker = false
    areYouSureChecker = MakeChoice(" This doesn't pause the timer.\n This stops the timer and resets to zero.\n Do you wish to reset the timer?",
        function () declineResetTimer() end,
        function () confirmResetTimer() end)
  --  areYouSureChecker.postiveAction = function () confirmResetTimer() end
    
     
end
function onHopCountChange()
    colourWidth = timerRadius/hopCount
    strokeWidth(colourWidth)
    -- get all hops starttimes into a table with hopname parameter for reference
    sortHopsInTimeOrder() 
end

    
function setupInputForm()
    alwaysInc = 1
    rowLimit=10

    hint = "Hop"
    hoptextrow = {}
    hopnumber = {}
    delhoprowbutton={}
 
    hoptextrow[alwaysInc]={rowname=alwaysInc,box=HopTextBox(hint) }
    hopnumber[alwaysInc]={rowname=alwaysInc, box=HopNumberBox(boilTime)}
    delhoprowbutton[alwaysInc]={rowname=alwaysInc, btn=Button("we never see this button")}
    _G["startTime_"..hopCount] = boilTime
    _G["hopName_"..hopCount]=hint
    hopCount = hopCount +1
    onHopCountChange()

    
    font(inputFont)
    fontSize(inputFontSize)
    
    -- set up button for adding new hop row
    addhopbutton = Button("Add hop", function () addhopRow() end)

end

function sortHopsInTimeOrder()
    indexedTableOfAll={}
    for i=0, hopCount-1 do
        hopSelect = i +1
        local timerfraction, startTime = getHopBoilTimerDetails(i)
        table.insert(indexedTableOfAll, {indexedName="hopName_"..i, time=startTime})
    end
    comp = function(a,b) return (a.time>b.time) end
    table.sort(indexedTableOfAll,comp)
end

function draw()
    background(64)
    sprite(img, WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)

    drawTimerButton()
    if showClearAlarmButton then
        drawclearAlarmButton()
    end
    
   
        
    if timerRunning then
        drawArcsAndTimesInTimeOrder()
        -- draw the timer wedge, and the time remaining
        local timerAngle, timeRemaining = drawTimerOverlay()
        local timeRemaining = math.floor(timeRemaining+1) -- plus 1 to get back the -1 for hack on draw
        -- dont show time more or less than 0
        if timeRemaining>boilTime then timeRemaining=boilTime end
        if timeRemaining<0 then timeRemaining=0 end
        drawRemainingTime(timerAngle, timeRemaining, stroke())
        checkAlarmTimes()
        listHopsInTimeOrder()
    else
        drawDummyTimer()
        drawHopTitleBar()
        drawHopRow()
        drawaddhopButton()
    end
    
     if displayAreYouSureChecker then
        drawAreYouSureChecker()
    end

end
function drawDummyTimer()
    strokeWidth(colourWidth)
    stroke(hopColour[1])
    arc(tx, ty, timerRadius, 0, 0)
end

function drawHopTitleBar() 
    textMode(CORNER)
    fill(textLabelColor)
    font(inputFont)
    fontSize(inputFontSize)
    text("  Hop details, eg name.",30, HEIGHT-(25))
    text("|Boil", 390, HEIGHT-25)
end

function drawArcsAndTimesInTimeOrder()
    strokeWidth(colourWidth)
    for i,v in ipairs(indexedTableOfAll) do
        myIndexTable={}
        for s in string.gmatch(v.indexedName, '([^_]+)') do
            table.insert(myIndexTable,s)
        end
        hopTableIndex = tonumber(myIndexTable[2])
        timerfraction, startTime = getHopBoilTimerDetails(hopTableIndex)
        --dont draw flameout hops, only starttimes not 0
        if startTime ~= 0 then
            stroke(hopColour[hopTableIndex+1])
            hopStartAngle = getHopStartAngle(hopTableIndex)
            arc(tx, ty, timerRadius-(colourWidth*(i-1)), hopStartAngle, endAngle)
            drawTimes(timerfraction, startTime, hopColour[hopTableIndex+1])
        end
        myIndexTable=nil --think i need this for gc
    end
end

-- Retrieve global variable table the value for the time the hops goes in
-- Return offset angle from boilTime +ve for leftside of timer, -ve for right
function getHopStartAngle(i)
    local hopBoilTimerFraction, hopStartTime = getHopBoilTimerDetails(i)
    
    if hopBoilTimerFraction >= 180 then
        hopStartAngle= 360 - hopBoilTimerFraction
        else
        hopStartAngle = 0 - hopBoilTimerFraction
    end
    return hopStartAngle
end

function getHopBoilTimerDetails(i)
    local hopStartTime = _G["startTime_"..i]
    local  hopBoilFraction = hopStartTime/boilTime
    local  hopBoilTimerFraction = 360*hopBoilFraction
    return hopBoilTimerFraction, hopStartTime
    
end

-- sourced from http://codea.io/talk/discussion/1156/drawing-an-arc/p1
-- modified to stop leak
-- Allow for fullRadius flag which indicates the arc will not be a thin
-- band drawn for hops, but is a full wedge for the over laying timer
function arc(x, y, radius, a1, a2, fullRadius)
    local m = mesh()
    m:addRect(x, y, radius * 2, radius * 2, math.rad(90))
    m.shader = shader("Patterns:Arc")
    if fullRadius then
        -- noop
        else
        m.shader.size = (1 - strokeWidth()/radius) * 0.5
    end
    m.shader.color = color(stroke())
    m.shader.a1 = math.rad(a1)
    m.shader.a2 = math.rad(a2)
    m:draw()
    -- Suggestion from forum to GC discarded meshes
    m = nil
    collectgarbage()
end

-- Enter Time Text around the outsize of timer
function drawTimes(fraction, timeText, colour)
    textMode(CENTER)
    font(timerFont)
    fontSize(timerFontSize)
    fill(colour)
    local r = timerRadius+(timerFontSize/2)
    local x = tx
    local y = ty
    text(timeText, degsToTimer(fraction,r,x,y))
end

function degsToTimer(degree, r, x, y)
    local degree = 90 - degree
    if x == nil then x = tx end
    if y == nil then y = ty end
    if r == nil then r = 200 end
    local mx = x + r * math.cos(math.rad(degree))
    local  my = y + r * math.sin(math.rad(degree))
    return mx, my
end

-- Overlay a full wedge arc on top of hop schedule of time elapsed since start
function drawTimerOverlay()

    local timeRemaining = boilTime - getMinsElapsed()
    local timerAngle = 0 -- Default to 0 which fills the whole timer i.e no time left
    stroke(overlayColour)
    
    if timeRemaining > 0 then -- Only find new angle to draw if there is time remaining
        local  timeRemainingBoilFraction = timeRemaining/boilTime
        local  timeRemainingBoilTimerFraction = 360*timeRemainingBoilFraction
        
        if timeRemainingBoilTimerFraction >= 180 then
            timerAngle = 360 - timeRemainingBoilTimerFraction --left side fill
            
            -- Fudge to stop the timer starting looking like it is finished
            if timerAngle < 1 then timerAngle= 1 end
            
            else
            timerAngle = 0 - timeRemainingBoilTimerFraction -- right side fill
        end
    end
    
    -- draw time elapsed
    arc(tx, ty, timerRadius+timerFontSize,0,timerAngle, true)
    return timerAngle, timeRemaining
end

function getMinsElapsed()
      local now = os.time()
 
    local secondsPast= os.difftime(now,startTimerTime)
    local minutesPast = secondsPast/60
    return minutesPast
end

function drawRemainingTime(fraction, timeText, colour)
    local degree = 90 - fraction
    textMode(CENTER)

    font(remainingTimeFont)
    fontSize(timerFontSize)
    fill(colour)
    local r = timerRadius+(timerFontSize*1.5)
    local x = tx
    local y = ty
    
    local mx = x -r * math.cos(math.rad(degree))
    local  my = y + r * math.sin(math.rad(degree))
    
    text(timeText, mx,my)
end


--for all the hop times, check if they need to trigger an alarm
--once alarmed, mark them so the on screen list can colour them
function checkAlarmTimes()
    for i,v in ipairs(indexedTableOfAll) do
        if getMinsElapsed() > (boilTime - v.time) then
            if hasAlarmed[i] == false then
                hasAlarmed[i] =true
                triggerAlarm(i)
            end
        end
    end
    -- Check for time ending
    if getMinsElapsed() > boilTime then
        if hasAlarmed[0] == false then
                hasAlarmed[0] =true
                triggerAlarm(0)
        end
    end 
end


--god damn what a mission
--we want to print out the hop details in time order, with text colours mathing the hoptimer
--we do want to include flame out hops in printout
--BUT......
--if we want to order our table we loose the position number, and we need the position number
--to cross reference the hop name, hop time and colour.
--so we have to make tables of tables,
--indexedTableOfAll stores the gobal parameter hopname, and time
--we can now sort indexedTableOfAll
--then cut up the gobal parameter name because it has the original index in it
--i.e string format is hopName_1
--grab the number after the _ and now we can retrieve the colour
--
--also, draw grey out box over hopslist already past time
function listHopsInTimeOrder()
    textIndent = 20
    textLength = 500
    colourHopAlarmed = 0
    sortHopsInTimeOrder() -- testing only, must remove
    textMode(CORNER)
    font(listHopsFont)
    fontSize(listHopsFontSize)

    for i,v in ipairs(indexedTableOfAll) do
        myIndexTable={}
        for s in string.gmatch(v.indexedName, '([^_]+)') do
            table.insert(myIndexTable,s)
        end
        hopTableIndex = tonumber(myIndexTable[2])
        local hopName = _G["hopName_"..hopTableIndex]
        fill(hopColour[hopTableIndex+1])
        if v.time == 0 then timeString=":flame out" else timeString=":"..tostring(v.time).." mins" end
        
        text(hopName.." "..timeString,listHopsFontSize, HEIGHT-(50+(listHopsFontSize*i)))
        myIndexTable=nil --think i need this for gc
        -- set for alarm colour over list
        if isAlarming[i] then
            colourHopAlarmed = colourHopAlarmed+1
        end
    end
    
    --coloured boxs over list if past alarm time or current alarm
    if timerRunning then
        rectMode(CORNERS)
        fill(overlayColour)
        strokeWidth(1)
        offset = 50
        rect(textIndent,
            HEIGHT-offset, 
            textLength, 
            HEIGHT-(offset+(listHopsFontSize*hopPastAlarmingCount)))
        
        if colourHopAlarmed > 0 then
            fill(alarmOverlayColour)
            rect(textIndent, 
                HEIGHT-(offset+(listHopsFontSize*hopPastAlarmingCount)),
                textLength,
                HEIGHT-(offset+(listHopsFontSize*hopPastAlarmingCount)+(listHopsFontSize*colourHopAlarmed)))
        end
    end  
end

function triggerAlarm(i)
    isAlarming[i] = true
    showClearAlarmButton = true
    sound("Game Sounds One:Wrong")
end

function addhopRow()

    local rowcount =0

    for _ in pairs(hoptextrow) do rowcount = rowcount +1 end

    if rowcount<=rowLimit then
        alwaysInc = alwaysInc + 1
        local rowToDelete=alwaysInc
        hoptextrow[alwaysInc]={rowname=alwaysInc,box=HopTextBox(hint) }
        hopnumber[alwaysInc]={rowname=alwaysInc, box=HopNumberBox(0)}
        delhoprowbutton[alwaysInc]={rowname=alwaysInc, btn=Button("del", function() delhop(rowToDelete) end)}
        --These entries will be overriden once the start timer button is hit, but loading them now helps with UI
        _G["startTime_"..hopCount] = boilTime
        _G["hopName_"..hopCount]=hint
        hopCount = hopCount +1
    
        onHopCountChange()
        else
        alert("","Hop schedule is full.")
    end
    
end

function drawaddhopButton()
    addhopbutton.pos = vec2(120,addhopbutton.size.y)
    addhopbutton:draw()
end

function delhop(thisrow)
    
    hoptextrow[thisrow] = nil
    delhoprowbutton[thisrow] = nil
    hopnumber[thisrow] = nil
    hopCount = hopCount -1
    onHopCountChange()

end

function tableRemoveByKey(tablename, keyv)
    local element =tablename[keyv]
    tablename[keyv] = nil
    return element
end

    
function drawHopRow()
    pushStyle()
    local top = HEIGHT - 50
    local left = 200
    -- slow if user has added alot and deleted lots, 
    -- but i had to so the are displayed in order of creation
    for i=1, alwaysInc do
        r = hoptextrow[i]
        if  r ~= nil then
        r.box.pos = vec2(left,top)
        r.box:draw()
        numbox = hopnumber[i]
        numbox.box.pos = vec2(left+220, top)
        numbox.box:draw()
        
        if i==1 then
                textMode(CENTER)
                fill(textLabelColor)
                font(inputFont)
                fontSize(inputFontSize)
                text("- Max Boil Time.",left+370, top)            
        else
            delhopbutton = delhoprowbutton[i]
            delhopbutton.btn.pos = vec2(left+290, top)
            delhopbutton.btn:draw()
        end
        top = top - r.box.size.y - 20
            end
    end
    popStyle()
end

