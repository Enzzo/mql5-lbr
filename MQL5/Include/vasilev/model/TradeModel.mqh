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
class TradeModel : public Model{
public:
   TradeModel();
   ~TradeModel();
   
   void AddTicket(const ulong);
   const CArrayLong* GetTickets() const;
   inline ulong GetLastTicket() const;
   
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
   DEBUG("Entering "+__FUNCTION__)
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
void TradeModel::AddTicket(const ulong ticket){
   _lastTicket = ticket;
   _orderTickets.Add(ticket);
   Notify();
}

// +-----------------------------------------------------------+
// |  CArrayLong* getTickets()                                 |
// +-----------------------------------------------------------+
const CArrayLong* TradeModel::GetTickets() const{
   return _orderTickets;
}

ulong TradeModel::GetLastTicket(void)const{
   return _lastTicket;
}