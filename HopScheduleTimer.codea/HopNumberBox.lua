HopNumberBox = class()

function HopNumberBox:init(boxnumber)
    -- you can accept and set parameters here
    
    self.boxnumber = boxnumber
    
    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    self.focus=false
    self.action = nil
end

function HopNumberBox:draw()
    if isKeyboardShowing() == false and self.focus == true then
        self.focus=false
    end
    
    pushStyle()
    stroke(240)
    fill(240)

    local w,h
    w = 50
    h = 36
    
    posx = self.pos.x
    posy = self.pos.y
    -- move stuff about so keyboard doesnt cover
    if isKeyboardShowing() == true and self.focus == true then
        --highlight and center box under edit
        fill(69, 206, 14, 255)
        posx=200
        posy=HEIGHT/2        
    end
    if isKeyboardShowing() == true and self.focus == false then
        -- grey out and move away box not under edit
        fill(145, 156, 141, 255)
        if posy-50<HEIGHT/2 then
            posy=0
        end
    end
    
    
    roundRect(posx - w/2,
    posy - h/2,
    w,h,20)
    
    self.size = vec2(w,h)
    stroke(0,10,255,255)
    strokeWidth(3)
    lineCapMode(SQUARE)
    
    if blink() and self.focus==true then
        a=((posx*2)/2+textSize(self.boxnumber)/2)+3
        b=posy+20
        c=posy-20
        line(a,b,a,c)
    end
    
    textMode(CENTER)
    fill(0)
    text(self.boxnumber,posx+2,posy-2)
      
    popStyle()
end

function HopNumberBox:hit(p)
    local l = self.pos.x - self.size.x/2
    local r = self.pos.x + self.size.x/2
    local t = self.pos.y + self.size.y/2
    local b = self.pos.y - self.size.y/2
    if p.x > l and p.x < r and
    p.y > b and p.y < t then
        return true
    end
    
    return false
end

function HopNumberBox:touched(touch)

    -- Codea does not automatically call this method
    if touch.state == ENDED and self:hit(vec2(touch.x,touch.y)) then

        self.focus=true
        showKeyboard()
        if self.action then
            self.action()
        end
        else
        self.focus=false
        -- hideKeyboard()
    end
end

function HopNumberBox:keyboard(key, maxNumber)
    if maxNumber == nil then
        maxNumber = 999
    end
    
    if self.focus==true then
        if key==BACKSPACE then
            if string.len(self.boxnumber)>0 then
                self.boxnumber=string.sub(self.boxnumber,1,string.len(self.boxnumber)-1)
            end
            elseif key == RETURN then 
                hideKeyboard()
                self.focus=false
            
            end
        
        if type(tonumber(key))=="number" then
            local oldNumber = self.boxnumber
            if string.len(self.boxnumber)<3 then
                local possibleboxnumber=oldNumber .. key
                if tonumber(possibleboxnumber) <= tonumber(maxNumber) then
                    self.boxnumber = possibleboxnumber
                else
                    alert("", "This hops boil time should be less than "..maxNumber)
                end
            end
            
        end
    end
    
end

function blink()
    local int,fract=math.modf(ElapsedTime)
    if fract>=0.5 then return true else return false end
end

function HopNumberBox:getText()
    return self.boxnumber
end
