//+------------------------------------------------------------------+
//|                                                   TradeModel.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <Arrays\ArrayLong.mqh>
#include <Trade\AccountInfo.mqh>

#include <vasilev\model\Model.mqh>

#include <vasilev\logger\logger.mqh>

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  TradeModel : Model : Observable                          |
// +-----------------------------------------------------------+

enum ENUM_TM_PAR{
   TP,
   SL,
   PRICE,
   OPEN,
   CLOSE
};

enum ENUM_TM_TRADE_TYPE{
   TM_BUY,
   TM_SELL,
   TM_BUYSTOP,
   TM_SELLSTOP,
   TM_BUYLIMIT,
   TM_SELLLIMIT,
   TM_UNKNOWN_TRADE
};

class TradeModel : public Model{
public:
   TradeModel();
   ~TradeModel();
   
   void AddTicket(const ulong);
   void SetTarget(double tp, double sl, double pr, datetime open, datetime close);

   const CArrayLong* GetTickets() const;
   inline ulong GetLastTicket() const;
   inline double GetAccountBalance() const;
   inline double GetAccountMargin() const;
   inline double GetAccountProfit() const;
   inline double GetAccountEquity() const;
   
   inline const double GetAsk() const;
   inline const double GetBid() const;
   
   inline void SetParameter(const ENUM_TM_PAR par, const double price);
   inline void SetParameter(const ENUM_TM_PAR par, const datetime time);
   
   void SetTp(const double price);
   void SetSl(const double price);
   void SetPrice(const double price);
   void SetOpenTime(const datetime time);
   void SetCloseTime(const datetime time);
   
   inline const double GetTp() const;
   inline const double GetSl() const;
   inline const double GetPrice() const;
   inline const datetime GetOpenTime() const;
   inline const datetime GetCloseTime() const;
   
   inline const ENUM_TM_TRADE_TYPE GetTradeType() const;
   
   inline void ResetParameter(const ENUM_TM_PAR par);
   
private:
   const ENUM_TM_TRADE_TYPE CheckTradeType() const;
   
private:
   ENUM_TM_TRADE_TYPE _trade_type;
   double _tp, _sl, _price;
   datetime _open, _close;
   
   ulong _lastTicket;
   CArrayLong* _orderTickets;
   CAccountInfo* _accountInfo;
};

// +-----------------------------------------------------------+
// |  DEFINITION                                               |
// +-----------------------------------------------------------+
// |  ctor                                                     |
// +-----------------------------------------------------------+
TradeModel::TradeModel(){
   DEBUG("Entering "+__FUNCTION__)
   _orderTickets = new CArrayLong();
   _accountInfo = new CAccountInfo();
   _trade_type = TM_UNKNOWN_TRADE;
}

// +-----------------------------------------------------------+
// |  dtor                                                     |
// +-----------------------------------------------------------+
TradeModel::~TradeModel(){
   if(CheckPointer(_orderTickets) == POINTER_DYNAMIC){
      delete _orderTickets;
   }
   if(CheckPointer(_accountInfo) == POINTER_DYNAMIC){
      delete _accountInfo;
   }
}

// +-----------------------------------------------------------+
// |  void addTicket(const ulong ticket)                       |
// +-----------------------------------------------------------+
void TradeModel::AddTicket(const ulong ticket){
   _lastTicket = ticket;
   _orderTickets.Add(ticket);
   
   _trade_type = CheckTradeType();
   Notify();
}

void TradeModel::SetTarget(double tp, double sl, double pr, datetime open, datetime close){
   _tp = tp;
   _sl = sl;
   _price = pr;
   _open = open;
   _close = close;
   
   _trade_type = CheckTradeType();
   Notify();
};

void TradeModel::SetParameter(const ENUM_TM_PAR par, const double price){
   switch(par){
      case(TP): SetTp(price);break;
      case(SL): SetSl(price);break;
      case(PRICE): SetPrice(price);break;
      default: FATAL("WRONG PARM: " + DoubleToString(price, Digits()))
   }
}

void TradeModel::SetParameter(const ENUM_TM_PAR par, const datetime time){
   switch(par){
      case(OPEN): SetOpenTime(time);break;
      case(CLOSE): SetCloseTime(time);break;
      default: FATAL("WRONG PARM: " + TimeToString(time))
   }
}

void TradeModel::ResetParameter(const ENUM_TM_PAR par){
   switch(par){
      case(TP): SetTp(0.0);break;
      case(SL): SetSl(0.0);break;
      case(PRICE): SetPrice(0.0);break;
      case(OPEN): SetOpenTime(0);break;
      case(CLOSE): SetCloseTime(0);break;
   }
}

const double TradeModel::GetAsk() const{
   return SymbolInfoDouble(Symbol(),SYMBOL_ASK);
}

const double TradeModel::GetBid() const{
   return SymbolInfoDouble(Symbol(),SYMBOL_BID);
}

const ENUM_TM_TRADE_TYPE TradeModel::CheckTradeType() const{
   double Ask=GetAsk(); 
   double Bid=GetBid(); 
   //1, 2)
   if(_tp == 0.0 && _sl == 0.0){
      ERROR("set a stop loss or take profit line");
      return TM_UNKNOWN_TRADE;
   }
   
   //(3, 4, 7)
   if(_price == 0.0){
      
      //РИСКА НЕТ
      //3)
      if(_sl == 0.0){
         if(_tp > Ask) return TM_BUY;
         if(_tp < Bid) return TM_SELL;
         ERROR("take profit can't be inside the spread");
         return TM_UNKNOWN_TRADE;
      }
      
      //РИСК ЕСТЬ
      //4)
      if(_tp == 0.0){
         if(_sl < Bid) return TM_BUY;
         if(_sl > Ask) return TM_SELL;
         ERROR("stop loss can't be inside the spread");
         return TM_UNKNOWN_TRADE;
      }
      
      //7
      if(_tp > Ask && _sl > Ask){
         ERROR("take profit and stop loss above the opening price")
         return TM_UNKNOWN_TRADE;
      }
      if(_tp < Bid && _sl < Bid){
         ERROR("take profit and stop loss below the opening price")
         return TM_UNKNOWN_TRADE;
      }
      if(_tp > Ask && _sl < Bid) return TM_BUY;
      if(_tp < Bid && _sl > Ask) return TM_SELL;
      ERROR("7 E")
      return TM_UNKNOWN_TRADE;
      
   }
   //(5, 6, 8)
   else{
   
      //РИСКА НЕТ
      //5
      if(_sl == 0.0){
         if(_tp > _price){
            if(_price > Ask)return TM_BUYSTOP;
            if(_price < Ask)return TM_BUYLIMIT;
            
            if(_price == Ask)return TM_BUY;
         }
         if(_tp < _price){
            if(_price < Bid)return TM_SELLSTOP;
            if(_price > Bid)return TM_SELLLIMIT;
            if(_price == Bid)return TM_SELL;
         }
         //5 D
         ERROR("take profit cannot be equal to the opening price")
         return TM_UNKNOWN_TRADE;         
      }
      
      //РИСК ЕСТЬ
      //6
      if(_tp == 0.0){
         if(_sl < _price){
            if(_price > Ask)return TM_BUYSTOP;
            if(_price < Ask)return TM_BUYLIMIT;
            if(_price == Ask)return TM_BUY;
         }
         if(_sl > _price){
            if(_price < Bid)return TM_SELLSTOP;
            if(_price > Bid)return TM_SELLLIMIT;
            if(_price == Bid)return TM_SELL;
         }
         //6 D
         ERROR("stop loss cannot be equal to the opening price")
         return TM_UNKNOWN_TRADE;
      }
      
      //8 ВСЕ ЛИНИИ НА ГРАФИКЕ
      if(_tp == _sl || _tp == _price || _sl == _price){
         ERROR("control levels cannot be equal")
         return TM_UNKNOWN_TRADE;
      }
      if(_tp > _price && _sl > _price){
         ERROR("take profit and stop loss above the opening price")
         return TM_UNKNOWN_TRADE;
      }
      if(_tp < _price && _sl < _price){
         ERROR("take profit and stop loss below the opening price")
         return TM_UNKNOWN_TRADE;
      }
      if(_tp > _price){
         if(_price > Ask)return TM_BUYSTOP;
         if(_price < Ask)return TM_BUYLIMIT;
                     return TM_BUY;
      }
      if(_tp < _price){
         if(_price > Bid)return TM_SELLLIMIT;
         if(_price < Bid)return TM_SELLSTOP;
                     return TM_SELL;
      }
   }
   return TM_UNKNOWN_TRADE;
}

inline const ENUM_TM_TRADE_TYPE TradeModel::GetTradeType()const{
   return _trade_type;
}

inline const double TradeModel::GetTp() const{
   return _tp;
};

inline const double TradeModel::GetSl() const{
   return _sl;
};

inline const double TradeModel::GetPrice() const{
   return _price;
};

inline const datetime TradeModel::GetOpenTime() const{
   return _open;
};

inline const datetime TradeModel::GetCloseTime() const{
   return _close;
};

void TradeModel::SetTp(const double price){
   _tp = price;
   _trade_type = CheckTradeType();
   Notify();
}
void TradeModel::SetSl(const double price){
   _sl = price;
   _trade_type = CheckTradeType();
   Notify();
}
void TradeModel::SetPrice(const double price){
   _price = price;
   _trade_type = CheckTradeType();
   Notify();
}
void TradeModel::SetOpenTime(const datetime time){
   _open = time;
   _trade_type = CheckTradeType();
   Notify();
}
void TradeModel::SetCloseTime(const datetime time){
   _close = time;
   _trade_type = CheckTradeType();
   Notify();
}
// +-----------------------------------------------------------+
// |  CArrayLong* getTickets()                                 |
// +-----------------------------------------------------------+
const CArrayLong* TradeModel::GetTickets() const{
   return _orderTickets;
};

ulong TradeModel::GetLastTicket(void)const{
   return _lastTicket;
};

double TradeModel::GetAccountBalance()const {
   return _accountInfo.Balance();
};

double TradeModel::GetAccountMargin() const{
   return _accountInfo.Margin();
};

double TradeModel::GetAccountProfit() const{
   return _accountInfo.Profit();
};

double TradeModel::GetAccountEquity() const{
   return _accountInfo.Equity();
};