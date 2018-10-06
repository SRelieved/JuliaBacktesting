assets = []

push!(assets, "USDJPY")
USDJPY = market("USDJPY")
push!(assets, "USDCAD")
USDCAD = market("USDCAD")

x = []
i = 1
while i < 1000
   global i
   value = rand()
   push!(x, value)
   i += 1
end

create_historic(USDJPY, x, 500, "Daily")

for i in 501:length(x)
   create_event(USDJPY, i, "Daily")
end
