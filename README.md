# Backtesting

Backtesting is a backtesting environment for finance coded in python.

It allows its users to import external market data within the environment, to create a trading strategies and to simulate the portfolio results.

That backtest environment contains both an inner and an outer loop: Outer loop handles the creation of the new data while the inner loop handles the events management system that manages events coming into the events queue. 

## Hierarchy:

The backtesting system has two main different object classes:
- Assets: Assets objects store the name, the data, the type and the pipsvalue of a specific asset. The data is stored by timeframe so one asset object can have multiple timeseries stored in it. The supports and resistances of each timeframe are also stored within assets objects. 
- Data: Data objects store the open, close, high, low prices and related technical indicators for an observation of a specific asset. So each observation will create a new data object. During the creation of the data object, further data objects are being created for higher timeframes. For example, if a data object is being created at the daily level, a new data object will be created at the monthly level if that daily object is the last one for the current month. This way, the system keeps track of prices movements on the current timeframe and the one at highest level. 

Therefore, the user has to create an asset object before loading the data and creating the system. Then, once the asset has been initiated, the user can load the data within the backtesting engine and each event will create a new data object with specific a value for each attributes. All indicators are being created and calculated on the current bars and previos bars: This way no lookahead bias can affect the results of the backtesting engine. 

data --> create indicators value

Indicators --> create signals

Signals --> added to strategy

Strategy --> trigger orders

Orders --> are added to portfolio



Portfolio can have multiple strategy
Strategy can be traded on multiple asset

## Examples

### Creating a new asset and  loading a dataset

```python
from src import data as d
import pandas as pd, statistics as s

d.Asset("USD/JPY", "FOREX")

usdjpydataframe = con.get_candles('USD/JPY', period='D1', number=10000)

d.find_asset("USD/JPY").create_historic(usdjpydataframe, lengthofhistoric=5224, timeframe="DAILY", closecolumn = 2, opencolumn=1, highcolumn=3, lowcolumn=4, datecolumn=0)
```
