// I had to define this sym.q file myself, it doesn't come with tick
// tick.q expects a sym.q file to be under the tick directory
// It should contain schemas for tables
trade:([]time:`timespan$();sym:`symbol$();price:`float$();size:`int$();ex:`symbol$());
order:([]time:`timespan$();sym:`symbol$();price:`float$();size:`int$();ex:`symbol$());
quote:([]time:`timespan$();sym:`symbol$();price:`float$();size:`int$();ex:`symbol$())