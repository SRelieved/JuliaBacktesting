include("data.jl")
include("technical_indicators.jl")

function crossover(asset)
   """ creates crossover signal when the 26 moving average cross over the 52 moving average, returns either True or False """
   if asset.data[end-1].MA26 < asset.data[end-1].MA52 and asset.data[end].MA26 > asset.data[end].MA52
      return true
   else
      return false
   end
end


function crossunder(asset)
   """ creates a crossunder signal when the 26 moving average cross under the 52 moving average, return either True or False """
   if asset.data[end-1].MA26 > asset.data[end-1].MA52 and asset.data[end].MA26 < asset.data[end].MA52
      return True
   else
      return False
   end
end


function overRSI(asset)
   """ Returns True if RSI indicator is over a value of 60 """
   if asset.data[end].RSI > 60
      return true
   else
      return false
   end
end

function underRSI(asset)
   """ Returns True if RSI indicators is under a value of 40 """
   if asset.data[end].RSI < 40
      return true
   else
      return false
   end



function breaksupport(asset, support)
   """ Returns True when the last candlestick closes below a support """
   if asset.data[end].close < support
      return true
   else
      return false
   end
end


function breakresistance(asset)
   """ Returns True when the last candlestick closes above a resistance """
   if asset.data[end].close > resistance
      return true
   else
      return false
   end
end
