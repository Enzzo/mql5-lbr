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
#include <vasilev\view\LbrUI.mqh>

#include <vasilev\logger\logger.mqh>

input int         MAGIC       = 111087;            // magic
input string      COMMENT     = "";                // comment
input int         FONTSIZE    = 7;
input ENUM_BASE_CORNER CORNER = CORNER_LEFT_UPPER; // base corner
input int         X_OFFSET    = 20;                // X - offset
input int         Y_OFFSET    = 20;                // Y - offset
input string      HK_TP       = "T";               // hotkey for TP
input string      HK_SL       = "S";               // hotkey for SL
input string      HK_PR       = "P";               // hotkey for PRICE
input color       L_TP        = clrGreen;        // take profit line color
input color       L_SL        = clrRed;          // stop loss line color
input color       L_PR        = clrOrange;       // price open line color
input int         SLIPPAGE    = 5;                 // slippage
input double      RISK        = 1.00;              // risk
input double      COMISSION   = 0.0;               // comission

UIParams uip;

Expert* ea = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   EventSetTimer(1);
   
   DEBUG("Entering " + __FUNCTION__)
   
   uip.chart = 0;
   uip.name = "LBR";
   uip.subwin = 0;
   uip.x = X_OFFSET;
   uip.y = Y_OFFSET;
   uip.w = 110;
   uip.h = 108;
   uip.corner = CORNER;
   uip.fontSize = FONTSIZE;
   
   if(ea == NULL){
      DEBUG("Create new LBREA")
      ea = new LBREA(uip);
   }
   return(ea.OnInit());
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   EventKillTimer();
   
   ea.OnDeinit(reason);
   
   DEBUG(__FUNCTION__ + " " + IntegerToString(reason))
   
   if(reason != REASON_CHARTCHANGE){
      DEBUG("delete LBREA")
      delete(ea);
      ea = NULL;
   }
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