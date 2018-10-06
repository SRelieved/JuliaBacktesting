include("technical_indicators.jl")

using Dates


mutable struct market
   asset::String
   data::Array
   pipsvalue::Float64
   market(asset, pipsvalue = 0.01) = begin
      asset = asset
      data = []
      if occursin("JPY", asset)
         pipsvalue = pipsvalue
      else
         pipsvalue = 0.0001
      end
   new(asset,data,pipsvalue)
   end
end


struct trades
   asset::String
   entry::Float64
   exit::Float64
   type::String
   pipsvalue::Float64
   amount::Float64
   resultpips::Float64
   profit::Float64
   trades(asset,entry,exit,type,amount) = begin
      asset = asset
      entry = entry
      exit = exit
      type = type
      pipsvalue = asset.pipsvalue
      amount = amount
      if type == "Long"
         result = exit - entry
         profit = (result/pipsvalue)*amount
      elseif type == "Short"
         result = entry - exit
         profit = (result/pipsvalue)*amount  
      else
         print("Invalid type of transaction, please enter a valid type of transaction!")
      end
   new(asset, entry, exit, type, pipsvalue, amount, resultpips, profit)
   end
end


struct data
   Assetname::String
   Date::DateTime
   Open::Float64
   Close::Float64
   TimeFrame::String
   RSI::Float64
   MA52::Float64
   MA26::Float64
   MA12::Float64
   MA9::Float64
   MACD::Float64
   data(Market::market, Close::Float64, TimeFrame::String, Date = nothing, Open = nothing) = begin
      Assetname = Market.asset
      if Date == nothing
         Date = now()
      else
         Date = Date
      end
      if Open == nothing
         len = length(Market.data)
         if len > 0
            Open = Market.data[len].Close
         else
            Open = 0.00
         end
      else
         Open = Open
      end
      Close = Close
      TimeFrame = TimeFrame
      RSIM = RSI(Market)
      MA52M = MA52(Market)
      MA26M = MA26(Market)
      MA12M = MA12(Market)
      MA9M = MA9(Market)
      MACDM =  MACD(MA26M, MA12M, MA9M)
   new(Assetname, Date, Open, Close, TimeFrame, RSIM, MA52M, MA26M, MA12M, MA9M, MACDM)
   end
end


function create_event(Market::market, Close::Float64, TimeFrame::String)
   global assets
   new_event = data(Market, Close , TimeFrame)      
   for i in assets
      if Market.asset == i
         push!(Market.data, new_event)
         break
      end
   end
end


function create_historic(Market::market, data::Array, lengthofhistoric::Int64, TimeFrame::String)
   global assets
   for i in collect(1:lengthofhistoric)
      new_value = data[i]
      create_event(Market, new_value, TimeFrame)
   end
end
