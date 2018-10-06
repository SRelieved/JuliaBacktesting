include("data.jl")


function RSI(Market::market) 
   position = length(Market.data)
   if position < 15
      return 0.00
   else      
      data = Market.data[position-14:position]
      wins = []
      losses = []
      for i in data
         if i.Close < i.Open
            push!(losses,(i.Open-i.Close))
         elseif i.Close > i.Open
            push!(wins,(i.Close-i.Open))
         end
      end
      winssum = sum(wins)/length(wins)
      lossessum = sum(losses)/length(losses)
      firstrs = winssum/lossessum
      RSI = 100-(100/firstrs)
      return RSI
   end
end
   

function MACD(ma26::Float64,ma12::Float64,ma9::Float64)
   macdline = ma12 - ma26
   signalline = ma9
   macdhistogram = macdline - signalline
   return macdhistogram
end   


function MA9(Market::market)
   position = length(Market.data)
   if position < 10
      return 0.00
   else
      ma9 = sum(Market.data[position-9].Close:Market.data[position].Close)/9
      return ma9
   end
end


function MA12(Market::market)
   position = length(Market.data)
   if position < 13
      return 0.00
   else
      ma12 = sum(Market.data[position-12].Close:Market.data[position].Close)/12
      return ma12
   end
end


function MA26(Market::market)
   position = length(Market.data)
   if position < 27
      return 0.00
   else
      ma26 = sum(Market.data[position-26].Close:Market.data[position].Close)/26
      return ma26
   end
end


function MA52(Market::market)
   position = length(Market.data)
   if position < 53
      return 0.00
   else
      ma52 = sum(Market.data[position-52].Close:Market.data[position].Close)/52
      return ma52
   end
end

