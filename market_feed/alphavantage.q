p)import requests
/ replace the "demo" apikey below with your own key from https://www.alphavantage.co/support/#api-key
p)url = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=GOOG&interval=5min&apikey=OM8QWITXMQN6BV5C'
p)r = requests.get(url)
p)data = r.json()
data:.p.eval("data");
data:data`;

ohlc:flip -1#data;
datetimes:"P"$string key ohlc;
date:`date$datetimes;
time:`time$datetimes;

allVals:value each exec t from `t xcol value ohlc;
allVals:flip "F"$allVals;
open:allVals 0;
high:allVals 1;
low:allVals 2;
close:allVals 3;
size:`int$allVals 4;

metaData:1#data;
symbol:first `$value (flip metaData)[`$"2. Symbol"];



res:reverse ([] date;time;sym:symbol;open;high;low;close;size);