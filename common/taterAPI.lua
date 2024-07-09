function createScene()
    local scene = {}
    --these are some placeholder functions, I'll work on them later(It's about 1 am at the time I'm writing this)
    function scene:addDropDown(x,y,contents)
        return true
    end
    function scene:addButton(x,y,width,length,backgroundColour,textColour,onClick,onRelease)
        return true
    end
    function scene:addInputBox(x,y,len,default,backgroundColour,textColour,onChar,onInput)
        return true
    end
    function scene:addLabel(x,y,width,length,backgroundColour,textColour)
        return true
    end
    function scene:addTextField(x,y,width,length,default,backgroundColour,textColour)
        return true
    end
    function scene:deleteElement(element)
        return true
    end
    return scene
end