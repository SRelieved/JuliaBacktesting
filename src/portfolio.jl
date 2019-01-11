using Random

include("orders")
include("event") 



#Initiate an empty list of portfolio/accounts

accountlist = []





mutable struct Portfolio

   """

   Class Portfolio:

   Create a portfolio object that is being used to pass order and to follow up on the equity when a strategy is being

   traded.



       Parameters

       ----------

       number: {int64}, optional, default None

           The account number that is being used to identify the account/portfolio.

       equity: {float64}, optional, default 10,000

           The amount of equity in the portfolio.



       Attributes

       ----------

       number: int64

           The account number that is being used to identify the account/portfolio.

       equity: float64

           The amount of equity in the portfolio.

       orderslist: array

           The array that will contain all the "Entry" orders created for that portfolio



   Example:

      Portfolio()

      """
   number::Int64
   equity::Float64
   orderslist::Array
   Portfolio(number = nothing, equity = 10000) = begin
      if number == nothing
         number = rand(Int, 1)
      else
         number = number
      end
      equity = equity
      orderslist = []
      newportfolio = new(number, equity, orderslist)
          push!(accountlist, newportfolio)
      end
end


 




function findentryorder(portfolio, assetname, strategy)

      """ Function for finding an "Entry" order in the portfolio orders list when a fill event is in the event queue. It

      returns the orders so that it can be deleted from the last as soon as an "Exit" order has been created """

   for i in portfolio.orderslist
      if i.assetname == assetname && i.strategy == strategy && i.type == "Entry"
            return i
            break
      else
         continue
      end
   end
end


function eventorder(portfolio, strategy)

      """ Verify the events queue for order or fill events, if one is found the portfolio creates a new Order, either

      an "Entry" one or an "Exit" one """

   for i in event.eventsqueue
      if i.type == "orderevent"
         if i.name == "BUY"
            orders.Order(i.asset, portfolio, "Entry", "Long", i.quantity * portfolio.equity, strategy)
         else:
            orders.Order(i.asset, portfolio, "Entry", "Short", i.quantity * portfolio.equity, strategy)
         end
         remove_event(i)
      elseif i.type == "fillevent"
         if i.name == "BUY"
            orders.Order(i.asset, portfolio, "Exit", "Long", i.quantity * portfolio.equity, strategy)
         else
            orders.Order(i.asset, portfolio, "Exit", "Short", i.quantity * portfolio.equity, strategy)
         end
         remove_event(i)
      end
   end
end





function gainloss(portfolio, amount)
      """ Add the profit or the loss to the portfolio equity """
   portfolio.equity = portfolio.equity + amount
end
