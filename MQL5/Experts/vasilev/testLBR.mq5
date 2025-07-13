//+------------------------------------------------------------------+
//|                                                      testLBR.mq5 |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"
#property version   "1.00"

#include <vasilev\expert\LBREA.mqh>

input int xx = 22;

Expert* ea = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   EventSetTimer(1);
   
   if(ea == NULL){
      ea = new LBREA();
   }
   return(ea.OnInit());
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   EventKillTimer();
   ea.OnDeinit(reason);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   ea.OnTick();
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
   ea.OnTimer();
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   ea.OnChartEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+