function Initialize()
    -- print("GraphScaling.lua Initialize called")
    stockMeasure = SKIN:GetMeasure('mStockClose')
    if not stockMeasure then
        print('mStockClose measure not found')
        return
    end
    previousCloseMeasure = SKIN:GetMeasure('mStockMarketPreviousClose')
    if not previousCloseMeasure then
        print('mStockMarketPreviousClose measure not found')
    end
    -- print(stockMeasure:GetStringValue())
    scale = tonumber(SKIN:GetVariable('GraphHeight'))
    baseY = tonumber(SKIN:GetVariable('GraphBaseY'))
    spacing = tonumber(SKIN:GetVariable('GraphSpacing'))
end

function Update()
    stockMeasure = SKIN:GetMeasure('mStockClose')
    if not stockMeasure then
        print('mStockClose measure not found')
        return
    end
    previousCloseMeasure = SKIN:GetMeasure('mStockMarketPreviousClose')
    if not previousCloseMeasure then
        print('mStockMarketPreviousClose measure not found')
    end

    local previousClose = tonumber(previousCloseMeasure:GetStringValue())
    if not previousClose then
        print('Invalid value for mStockMarketPreviousClose')
    end

    scale = tonumber(SKIN:GetVariable('GraphHeight'))
    baseY = tonumber(SKIN:GetVariable('GraphBaseY'))
    spacing = tonumber(SKIN:GetVariable('GraphSpacing'))    
    -- print("Lua Update called")
    local stockData = stockMeasure:GetStringValue()
    -- print("Stock data: " .. (stockData or "nil"))

    if not stockData or stockData == "" then
        return ""
    end

    if previousClose then
        values = { previousClose } -- Start with the previous close value
    else
        values = {} -- Initialize an empty table for values
    end
    
    for value in string.gmatch(stockData, "([^,]+)") do
        local num = tonumber(value)
        if num then
            table.insert(values, num)
        end
    end
    
    if #values == 0 then return "" end
    
    minValue, maxValue = values[1], values[1]
    for i = 2, #values do
        if values[i] < minValue then minValue = values[i] end
        if values[i] > maxValue then maxValue = values[i] end
    end
    
    scale = scale / (maxValue - minValue)
    graphPath = ""
    
    for i, v in ipairs(values) do
        local x = 50 + (i - 1) * spacing
        local y = baseY - (v - minValue) * scale
        if i == 1 then
            graphPath = string.format("%d,%d", x, y)
        else
            graphPath = graphPath .. string.format(" | LineTo %d,%d", x, y)
        end
    end
    -- print("Graph path: " .. graphPath)
    return graphPath
end
