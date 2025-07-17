//+------------------------------------------------------------------+
//|                                                        trade.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Trade\Trade.mqh>

#include <vasilev\logger\logger.mqh>

class ExtendedTrade : public CTrade{
public:
   ExtendedTrade();
   ~ExtendedTrade();
   
   bool CloseTrades();
   bool DeletePendings();
   
};

ExtendedTrade::ExtendedTrade(){
   DEBUG(__FUNCTION__)
}

ExtendedTrade::~ExtendedTrade(){
   DEBUG(__FUNCTION__)
}

bool ExtendedTrade::CloseTrades(){
   DEBUG(__FUNCTION__)
   string symbol = Symbol();
//---
   if(IsHedging()){
      DEBUG("is hedging")
      int total=PositionsTotal();
      DEBUG("total positions " + IntegerToString(total))
      for(int i = total - 1; 0 <= i; --i){
         DEBUG("for " + IntegerToString(i));
         string position_symbol=PositionGetSymbol(i);
         if(position_symbol == symbol && m_magic == PositionGetInteger(POSITION_MAGIC)){
            PositionClose(PositionGetInteger(POSITION_TICKET));
         }
      }
      DEBUG("exiting for loop")
   }
   else{
      DEBUG("is not hedging")
      if(PositionSelect(symbol)){
         PositionClose(PositionGetInteger(POSITION_TICKET));
      }
   }
   DEBUG("Exiting from " +__FUNCTION__)
   return(true);
}

bool ExtendedTrade::DeletePendings(void){
   DEBUG(__FUNCTION__)
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--){
      ulong ticket = OrderGetTicket(i);
      if(OrderGetInteger(ORDER_MAGIC) == m_magic && OrderGetString(ORDER_SYMBOL) == Symbol()){
         OrderDelete(ticket);
      }
   }
   DEBUG("Exiting from " +__FUNCTION__)
   return true;
}