//+------------------------------------------------------------------+
//|                                              OrderController.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#include <vasilev\trade\ExtendedTrade.mqh>
#include <vasilev\model\TradeModel.mqh>
#include <vasilev\view\LbrUI.mqh>
#include <vasilev\utils\LineProcessor.mqh>

struct CTRLParams{
   ushort hk_tp;
   ushort hk_sl;
   ushort hk_pr;
   ushort hk_op;
   ushort hk_cl;
   color l_tp;
   color l_sl;
   color l_pr;
   color l_op;
   color l_cl;
   
   CTRLParams(){}
   
   CTRLParams(const CTRLParams& other){
      this.hk_tp = other.hk_tp;
      this.hk_sl = other.hk_sl;
      this.hk_pr = other.hk_pr;
      this.hk_op = other.hk_op;
      this.hk_cl = other.hk_cl;
      this.l_tp = other.l_tp;
      this.l_sl = other.l_sl;
      this.l_pr = other.l_pr;
      this.l_op = other.l_op;
      this.l_cl = other.l_cl;
   }
   
   void CTRLParams::operator=(const CTRLParams& other){
      this.hk_tp = other.hk_tp;
      this.hk_sl = other.hk_sl;
      this.hk_pr = other.hk_pr;
      this.hk_op = other.hk_op;
      this.hk_cl = other.hk_cl;
      this.l_tp = other.l_tp;
      this.l_sl = other.l_sl;
      this.l_pr = other.l_pr;
      this.l_op = other.l_op;
      this.l_cl = other.l_cl;
   }
};

// +-----------------------------------------------------------+
// |  DECLARATION                                              |
// +-----------------------------------------------------------+
// |  OrderController : CObject                                |
// +-----------------------------------------------------------+
class OrderController : public CObject{
public:
   OrderController(TradeModel*, LbrUI*, const CTRLParams&);
   ~OrderController();
   void RemoveLines() const;
   void ProcessKeyDownEvent(const long key, const datetime time, const double price);
   void ProcessMouseMoveEvent(const datetime time, const double price);
   void ProcessClickEvent(const datetime time, const double price);
   void ProcessObjectEndEditEvent();
   
   bool Trade() const;
   ulong GetResultDeal() const;
   ulong GetResultOrder() const;
   
public:
   bool Buy() const;
   bool Sell() const;
   bool BuyStop() const;
   bool SellStop() const;
   bool BuyLimit() const;
   bool SellLimit() const;
   bool CloseAll() const;
   
   void LineCreate(const string name, const double price, const ENUM_TM_PAR tm_par, const color clr, const string text);
   void LineCreate(const string name, const datetime time, const ENUM_TM_PAR tm_par, const color clr, const string text);
   
   void OnChartEvent(const int id,
                     const long &lparam,
                     const double &dparam,
                     const string &sparam);
private:
   enum ENUM_LINE_TO_MOVE{
      TP_LINE,
      SL_LINE,
      PR_LINE,
      OP_LINE,
      CL_LINE,
      NONE
   }_line;
   
private:
   const ushort _hk_tp, _hk_sl, _hk_pr, _hk_op, _hk_cl;
   color _l_tp, _l_sl, _l_pr, _l_op, _l_cl;
   
   LineProcessor* _lp;
   ExtendedTrade* _trade;
   TradeModel* _model;
   LbrUI* _view;
};

OrderController::OrderController(TradeModel* model, LbrUI* view, const CTRLParams& params):
   _lp(new LineProcessor()),
   _trade(new ExtendedTrade()),
   _model(model),
   _view(view),
   _hk_tp (params.hk_tp),
   _hk_sl(params.hk_sl),
   _hk_pr(params.hk_pr),
   _hk_op(params.hk_op),
   _hk_cl(params.hk_cl),
   _l_tp(params.l_tp),
   _l_sl(params.l_sl),
   _l_pr(params.l_pr),
   _l_op(params.l_op),
   _l_cl(params.l_cl),
   _line(NONE){
};

OrderController::~OrderController(){
   RemoveLines();
   
   if(CheckPointer(_trade) == POINTER_DYNAMIC){
      delete(_trade);
      _trade = NULL;
   }
   
   if(CheckPointer(_lp) == POINTER_DYNAMIC){
      delete(_lp);
      _lp = NULL;
   }
}

void OrderController::RemoveLines() const{
   _lp.LineRemove("tp");
   _lp.LineRemove("sl");
   _lp.LineRemove("price");
   _lp.LineRemove("open");
   _lp.LineRemove("close");
}

void OrderController::ProcessKeyDownEvent(const long key, const datetime time, const double price){
   if(key == _hk_tp){
      _line = TP_LINE;     // тип активной линии для перемещения
      LineCreate("tp", price, TP, _l_tp, "take profit");   
   }
   else if(key == _hk_sl){
      _line = SL_LINE;     // тип активной линии для перемещения
      LineCreate("sl", price, SL, _l_sl, "stop loss");  
   }
   else if(key == _hk_pr){
      _line = PR_LINE;     // тип активной линии для перемещения
      LineCreate("price", price, PRICE, _l_pr, "price");  
   }
   else if(key == _hk_op){
      _line = OP_LINE;     // тип активной линии для перемещения
      DEBUG("TIME: " + TimeToString(time))
      LineCreate("open", time, OPEN, _l_op, "open");  
   }
   else if(key == _hk_cl){
      _line = CL_LINE;     // тип активной линии для перемещения
      DEBUG("TIME: " + TimeToString(time))
      LineCreate("close", time, CLOSE, _l_cl, "close");  
   }
   else if(key == 27){  // ESC pressed
      RemoveLines();
      CloseAll();
      _model.SetTarget(0.0, 0.0, 0.0, 0, 0);
   }
   else if(key == 32){
      Trade();
   }
};

void OrderController::ProcessMouseMoveEvent(const datetime time, const double price){
   switch(_line){
      case(TP_LINE):{
         _lp.LineMove("tp",price, 0);
         _model.SetTp(price);
      }break;
      case(SL_LINE):{
         _lp.LineMove("sl",price, 0);
         _model.SetSl(price);
      }break;
      case(PR_LINE):{
         _lp.LineMove("price",price, 0);
         _model.SetPrice(price);
      }break;
      case(OP_LINE):{
         _lp.LineMove("open",0.0, time);
         _model.SetOpenTime(time);
      }break;
      case(CL_LINE):{
         _lp.LineMove("close",0.0, time);
         _model.SetCloseTime(time);
      }break;
   }
};
void OrderController::ProcessClickEvent(const datetime time, const double price){
   _line = NONE;
   if(_view.GetTpField() > 0.00001){
      _lp.LineCreate("tp", _view.GetTpField(), _l_tp, "take profit");
      _model.SetTp(_view.GetTpField());
   }
};

void OrderController::ProcessObjectEndEditEvent(){
   if(_view.GetTpField() > 0.00001){
      _lp.LineCreate("tp", _view.GetTpField(), _l_tp, "take profit");
      _model.SetTp(_view.GetTpField());
   }
};

void OrderController::LineCreate(const string name, const double price, const ENUM_TM_PAR tm_par, const color clr, const string text){
   DEBUG("PRICE LINE: " + DoubleToString(price))
   if(ObjectFind(0, name) != -1){
      _line = NONE;
      _lp.LineRemove(name);
      _model.ResetParameter(tm_par);          
   }
   else{
      _lp.LineCreate(name, price, clr, text);
   }
};

void OrderController::LineCreate(const string name, const datetime time, const ENUM_TM_PAR tm_par, const color clr, const string text){
   DEBUG("DATE LINE")
   if(ObjectFind(0, name) != -1){
      _line = NONE;
      _lp.LineRemove(name);
      _model.ResetParameter(tm_par);          
   }
   else{
      DEBUG("CREATING DATE LINE AT " + TimeToString(time))
      _lp.LineCreate(name, (datetime)time, clr, text);
   }
};
   
void OrderController::OnChartEvent( const int id,
                              const long &lparam,
                              const double &dparam,
                              const string &sparam){
   _view.OnChartEvent(id, lparam, dparam, sparam);
   datetime time;
   static double price = 0.0;
   int window = 0;
   
   ChartXYToTimePrice(0, (int)lparam, (int)dparam, window, time, price);
   switch(id){
      case CHARTEVENT_KEYDOWN:
         ProcessKeyDownEvent(lparam, time, price);
      break;
      case CHARTEVENT_MOUSE_MOVE:
         ProcessMouseMoveEvent(time, price);
      break;
      case CHARTEVENT_CLICK:
         ProcessClickEvent(time, price);
      break;
      case CHARTEVENT_OBJECT_ENDEDIT:
         ProcessObjectEndEditEvent();
      break;
      default:;
   }
}

bool OrderController::Trade() const {
   switch(_model.GetTradeType()){
      case TM_BUY: return Buy();
      case TM_SELL: return Sell();
      case TM_BUYSTOP: return BuyStop();
      case TM_BUYLIMIT: return BuyLimit();
      case TM_SELLSTOP: return SellStop();
      case TM_SELLLIMIT: return SellLimit();
   }
   return false;
}

bool OrderController::Buy() const{
   bool result = _trade.Buy(.01, Symbol(), _model.GetAsk(), _model.GetSl(), _model.GetTp());
   return result;
}

bool OrderController::Sell() const{
   bool result = _trade.Sell(.01, Symbol(), _model.GetBid(), _model.GetSl(), _model.GetTp());
   return result;
}

bool OrderController::BuyStop() const{
   bool result = _trade.BuyStop(.01, _model.GetPrice(), Symbol(), _model.GetSl(), _model.GetTp(), ORDER_TIME_GTC);
   return result;
}

bool OrderController::SellStop() const{
   bool result = _trade.SellStop(.01, _model.GetPrice(), Symbol(), _model.GetSl(), _model.GetTp(), ORDER_TIME_GTC);
   return result;
}

bool OrderController::BuyLimit() const{
   bool result = _trade.BuyLimit(.01, _model.GetPrice(), Symbol(), _model.GetSl(), _model.GetTp(),ORDER_TIME_GTC);
   return result;
}

bool OrderController::SellLimit() const{
   bool result = _trade.SellLimit(.01, _model.GetPrice(), Symbol(), _model.GetSl(), _model.GetTp(),ORDER_TIME_GTC);
   return result;
}

bool OrderController::CloseAll(void) const{
   DEBUG(__FUNCTION__)
   bool result = _trade.CloseTrades() && _trade.DeletePendings();
   return result;
}

ulong OrderController::GetResultDeal(void) const{
   return _trade.ResultDeal();
}

ulong OrderController::GetResultOrder(void) const{
   return _trade.ResultOrder();
}