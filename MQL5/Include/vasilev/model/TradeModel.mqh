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

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  TradeModel : Model : Observable                          |
// +-----------------------------------------------------------+
class TradeModel : public Model{
public:
   TradeModel();
   ~TradeModel();
   
   void addTicket(const ulong);
   const CArrayLong* getTickets() const;
   inline ulong getLastTicket() const;
   
private:
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
   _orderTickets = new CArrayLong();
   _accountInfo = new CAccountInfo();
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
void TradeModel::addTicket(const ulong ticket){
   _lastTicket = ticket;
   _orderTickets.Add(ticket);
   notify();
}

// +-----------------------------------------------------------+
// |  CArrayLong* getTickets()                                 |
// +-----------------------------------------------------------+
const CArrayLong* TradeModel::getTickets() const{
   return _orderTickets;
}

ulong TradeModel::getLastTicket(void)const{
   return _lastTicket;
}