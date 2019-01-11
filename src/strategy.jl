include("event.jl")



#Initiate an empty list to store the strategies

strategylist = []






mutable struct Strategy

   """

      Class Portfolio:

      Create a portfolio object that is being used to pass order and to follow up on the equity when a strategy is being

      traded.



          Parameters

          ----------

          name: {int64}, optional, default Unknown with number depending on the number of strategies

              The strategy name.

          leverage: {float64}, optional, default 1

              The leverage used for passing a trade.



          Attributes

          ----------

          name: int64

              The strategy name.

          leverage: float64

              The leverage used for passing a trade.

          entrylongsignals: list

              The list of signals used to entry into a long position

          exitlongsignals: list

              The list of signals used to exit a long position

          entryshortsignals: list

              The list of signals used to entry into a short position

          exitshortsignals: list

              The list of signals used to exit a short position



      Example:
         Strategy()

         """
   asset::String
   data::Array
   pipsvalue::Float64
   Strategy(name = "Unknown", leverage = 1) = begin
      if name != "Unknown"
         name = name
      else
         if strategylist != []
            count = []
            for i in strategylist
               if "Unknown" in i.name
                  push!(count, "True")
            if length(count) == 0
               name = "Unknown"
            else
               name = "Unknown" * string(length(count))
         else
            name = name
      leverage = leverage
      entrylongsignals = []
      exitlongsignals = []
      entryshortsignals = []
      exitshortsignals = []      
   newstrategy = new(name, leverage, entrylongsignals, exitlongsignals, entryshortsignals, exitshortsignals)     
      push!(strategylist, newstrategy)
   end
end






function addentrysignal(strategy, signal, type)
      """ Add a signal to enter into a trade; the signal will be added to the strategy either for "Long" or "Short" trades
      depending on the type given in input. Market has to respect all entry signals before an order is being passed """
   if type == "Long"
      push!(strategy.entrylongsignals, signal)
   elseif type == "Short"
      push!(strategy.entryshortsignals, signal)
   end
end


function addexitsignal(strategy, signal, type)
      """ Add a signal to exit a trade; the signal will be added to the strategy either for "Long" or "Short" trades

      depending on the type given in input. Market has to respect all entry signals before an order is being passed """
   if type == "Long"
      push!(strategy.exitlongsignals, signal)
   elseif type == "Short"
      push!(strategy.exitshortsignals, signal)
   end
end



function entryconditions(strategy, asset)
      """ Determine if the market respects all the entry conditions and if a new order event can be passed. If True a new
      order event is being added to the event queue """ 
   if count(i -> e.createsignalevent(asset, i)!= false, strategy.entrylongsignals) == length(strategy.entrylongsignals)
      newevent = e.OrderEvent(asset, strategy.leverage, "BUY")
      add_event(newevent)
   elseif count(i -> e.createsignalevent(asset, i)!= false, strategy.entryshortsignals) == length(strategy.entryshortsignals)
      newevent = e.OrderEvent(asset, strategy.leverage, "SELL")
      add_event(newevent)  
   end
end





function exitconditions(strategy, asset, portfolio)
      """ Determine if the market respects all the exit conditions and if a new fill event can be passed. If True a new
      fill event is being added to the event queue """

   if portfolio.orderslist != []
      if count(i -> e.createsignalevent(asset, i)!= false, strategy.exitlongsignals) == length(strategy.exitlongsignals)
         newevent = e.FillEvent(asset, strategy.leverage, "BUY")
         add_event(newevent)
      elseif count(i -> e.createsignalevent(asset, i)!= false, strategy.exitshortsignals) == length(strategy.exitshortsignals)
         newevent = e.FillEvent(asset, self.leverage, "SELL")
         add_event(newevent)
      end
   end
end
