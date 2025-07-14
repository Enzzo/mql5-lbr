//+------------------------------------------------------------------+
//|                                                      testLBR.mq5 |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"
#property version   "1.00"

#define INFO_LOG
#define DEBUG_LOG
#define WARN_LOG
#define ERROR_LOG
#define FATAL_LOG

#include <vasilev\expert\LBREA.mqh>

#include <vasilev\logger\logger.mqh>

input int xx = 22;

Expert* ea = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   EventSetTimer(1);
   
   DEBUG("Entering " + __FUNCTION__)
   
   if(ea == NULL){
      DEBUG("Create new LBREA")
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