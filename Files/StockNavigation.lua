function Initialize()
    local stockSymbols = SKIN:GetVariable("StockSymbols")
    symbols = {}
    for symbol in string.gmatch(stockSymbols, "([^,]+)") do
        table.insert(symbols, symbol)
    end
    totalSymbols = #symbols
    SKIN:Bang("!SetVariable", "TotalSymbols", totalSymbols)
    -- SKIN:Bang("!Log", "Initialized with " .. totalSymbols .. " symbols.", "Debug")
    UpdateSymbol(1) -- Start with the first symbol
    SKIN:Bang('!HideMeter', 'NextButton') -- We don't want it showing on first load
end

function Next()
    local currentIndex = tonumber(SKIN:GetVariable("CurrentSymbol"))
    currentIndex = (currentIndex % totalSymbols) + 1
    -- SKIN:Bang("!Log", "Navigating to next symbol. Current index: " .. currentIndex, "Debug")
    UpdateSymbol(currentIndex)
end

function Previous()
    local currentIndex = tonumber(SKIN:GetVariable("CurrentSymbol"))
    currentIndex = (currentIndex - 2 + totalSymbols) % totalSymbols + 1
    -- SKIN:Bang("!Log", "Navigating to previous symbol. Current index: " .. currentIndex, "Debug")
    UpdateSymbol(currentIndex)
end

function HandleButtonState()
    local currentIndex = tonumber(SKIN:GetVariable("CurrentSymbol"))
    -- SKIN:Bang("!Log", "Handling button state. Current index: " .. currentIndex, "Debug")
    if currentIndex <= 1 then
        SKIN:Bang('!HideMeter', 'PreviousButton')
    else
        SKIN:Bang('!ShowMeter', 'PreviousButton')
    end

    if currentIndex >= totalSymbols then
        SKIN:Bang('!HideMeter', 'NextButton')
    else
        SKIN:Bang('!ShowMeter', 'NextButton')
    end

    SKIN:Bang('!Redraw')
end

function UpdateSymbol(index)
    SKIN:Bang("!SetVariable", "CurrentSymbol", index)
    SKIN:Bang("!SetVariable", "StockSymbol", symbols[index])
    -- SKIN:Bang("!Log", "Updated StockSymbol to: " .. symbols[index], "Debug")
    HandleButtonState()
end
