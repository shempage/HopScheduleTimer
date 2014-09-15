HopTextBox = class()

function HopTextBox:init(boxtext)
    
    self.boxtext = boxtext

    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    self.focus=false
    self.action = nil

end

function HopTextBox:draw()
    if isKeyboardShowing() == false and self.focus == true then
        self.focus=false
    end
    
    pushStyle()
    stroke(240)
    
    fill(240)
    

    local w,h
    w = 390
    h = 36
    
    posx = self.pos.x
    posy = self.pos.y
    
    if isKeyboardShowing() == true and self.focus == true then
        fill(69, 206, 14, 255)
        posy=HEIGHT/2   
    end
       if isKeyboardShowing() == true and self.focus == false then
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
        a=((posx*2)/2+textSize(self.boxtext)/2)+3
        b=posy+20
        c=posy-20
        line(a,b,a,c)
    end
    
    fill(0)
    textMode(CENTER)
    text(self.boxtext,posx+2,posy-2)
         
    popStyle()
end

function HopTextBox:hit(p)
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

function HopTextBox:touched(touch)
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

function HopTextBox:keyboard(key)
    if self.focus==true then
        if key==BACKSPACE then
            if string.len(self.boxtext)>0 then
                self.boxtext=string.sub(self.boxtext,1,string.len(self.boxtext)-1)
            end
            elseif key == RETURN then 
                hideKeyboard()
                self.focus=false
            else
            if string.len(self.boxtext)<28 then
            self.boxtext=self.boxtext .. key
                end
        end
    end
end

function blink()
    local int,fract=math.modf(ElapsedTime)
    if fract>=0.5 then return true else return false end
end

function HopTextBox:getText()
    return self.boxtext
end
