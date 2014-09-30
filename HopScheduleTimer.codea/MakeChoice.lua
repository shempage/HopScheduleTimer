MakeChoice = class()

function MakeChoice:init(choiceText, negativeAction, positiveAction)
    -- you can accept and set parameters here
    self.choiceText = choiceText
    self.fontsize = 22
        self.color = color(190, 65, 69, 255)

    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    
    yesButton = Button("Yes")
    yesButton.action = positiveAction
    noButton = Button("No")
    noButton.action = negativeAction


end

function MakeChoice:draw()
    fontSize(self.fontsize)
    
   pushStyle()
   fill(self.color)
    
    -- use name for size
    local w,h = textSize(self.choiceText)
    w = w + 20
    h = self.fontsize + 30
    
    roundRect(self.pos.x - w/2, self.pos.y-(h),w,h,60)
            
    self.size = vec2(w,h)
            
    textMode(CENTER)
    fill(54, 65, 96, 255)
    text(self.choiceText,self.pos.x+2,self.pos.y-2)
    fill(255, 255, 255, 255)
    text(self.choiceText,WIDTH/2,HEIGHT/2)
    
    yesButton.pos = vec2(WIDTH/2+80 ,self.pos.y-80)
    yesButton:draw()
    noButton.pos = vec2(WIDTH/2-80 ,self.pos.y-80)
    noButton:draw()
    
    
    popStyle()
end


function MakeChoice:touched(touch)
    noButton:touched(touch)
    yesButton:touched(touch)

end

