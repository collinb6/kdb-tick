/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];

upd:insert;

/ get the ticker plant and history ports, defaults are 5010,5012
//// the rdb creates .u.x, which is the ports to the ticker plant, and the history??
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{.debug.rep:(x;y);(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};

//// .u.rep is the replay function
//// it defines the table schemas, and then replays the tickerplant log file, so the rdb is up to date

//// First statement in the .u.rep function: (.[;();:;].)each x
    //// Here x is a list of table names & values, it looks like this:
    /`order +`time`sym`price`size`ex!(`timespan$();`g#`symbol$();`float$();`int$()..
    /`quote +`time`sym`price`size`ex!(`timespan$();`g#`symbol$();`float$();`int$()..
    //// .[;();:;] <- This structure is an Amend Entire of the form .[d; (); v; y]
    //// d is an atom, the table name `order, y is the value of the table, and v is the assign :
    //// .[d;();v;y]   <=>   v[d;y]
    //// this just amounts to assigning the table schema to the name `order
    //// the last complication here is that the arguments d and y are left blank, 
    //// rather they are passed in using an apply of the form:
    //// v . vx    - evaluates value v on the  arguments listed in vx
    //// .[;();:;] . (`order;+`time`sym`price`s....)
    //// If thats not clear, a more explicit way to write it would be
    //// {[x;y] .[x;();:;y]} . (`order;+`time`sym`price`s....)

//// Second statement of .u.rep: if[null first y;:()]
    //// here y is a list (.u.i;.u.L), msg count in log file and tp log filename
    //// if .u.i (first y) is null, then there is no log to replay, and the function exits

//// Third statement of .u.rep: -11!y
    //// this is a streaming execution of the log file
    //// -11!(.u.i;.u.L)

/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
//// This line is very tersely written. I comment it out, and break up into steps
/.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";
//// opens a handle to the ticket plant
tickerplant_handle:(hopen `$":",.u.x 0);
//// subscribes to all tables all syms, and retrieves .u.i (msg count in log file) and .u.L (tp log filename)
table_schemas:tickerplant_handle"(.u.sub[`;`];`.u `i`L)";
//// Subscriber processes must open a connection to the publisher and call .u.sub[tablename;list_of_symbols_to_subscribe_to].
//// Specifying ` for either parameter of .u.sub means all 

//// .u.sub can be called synchronously or asynchronously. If .u.sub is called synchronously, the table schema is returned to the client
//// because .u.sub is called synchronously here, the list of table schemas is returned
//// now .u.rep is called for each table schema, using the apply function .
//// Apply - Apply v to list vx of arguments
//// .[v;vx]
//// v . vs 
.u.rep . table_schemas;

