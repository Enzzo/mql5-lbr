//+------------------------------------------------------------------+
//|                                                        trade.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Trade\Trade.mqh>

class ExtendedTrade : public CTrade{
public:
   bool CloseTrades();
   bool DeletePendings();
   
};

bool ExtendedTrade::CloseTrades(){
   string symbol = Symbol();
//---
   if(IsHedging())
     {
      uint total=PositionsTotal();
      for(uint i = total - 1; 0 <= i; --i)
        {
         string position_symbol=PositionGetSymbol(i);
         if(position_symbol == symbol && m_magic == PositionGetInteger(POSITION_MAGIC))
           {
            PositionClose(PositionGetInteger(POSITION_TICKET));
           }
        }
     }
   else
      if(PositionSelect(symbol)){
         PositionClose(PositionGetInteger(POSITION_TICKET));
      }
//---
   return(true);
}

bool ExtendedTrade::DeletePendings(void){
   if(OrdersTotal() == 0)
      return true;
   int total = OrdersTotal();
   for(int i = total - 1; i >= 0; i--){
      ulong ticket = OrderGetTicket(i);
      if(OrderGetInteger(ORDER_MAGIC) == m_magic && OrderGetString(ORDER_SYMBOL) == Symbol()){
         OrderDelete(ticket);
      }
   }
   return true;
}