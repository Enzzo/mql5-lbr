//+------------------------------------------------------------------+
//|                                                   Observable.mqh |
//|                                                   Sergey Vasilev |
//|                                         vasilevnogliki@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Sergey Vasilev"
#property link      "vasilevnogliki@yandex.ru"

#ifndef OBSERVABLE_MQH
#define OBSERVABLE_MQH

#include <Arrays\ArrayObj.mqh>
#include <vasilev\Observer.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
class Observer;

class Observable{
public:
   Observable(){};
   virtual ~Observable(){};
   
   void addObserver(Observer* observer);
   void notify() const ;
   
private:
   inline int observersTotal() const;
   
private:
   Observer* _observer_pointers[];
};

void Observable::addObserver(Observer *observer){
   ArrayResize(_observer_pointers, observersTotal() +1);
   _observer_pointers[observersTotal() - 1] = observer;
}

int Observable::observersTotal(void) const {
   return ArraySize(_observer_pointers);
}

void Observable::notify(void) const {
   for(int i = 0; i < observersTotal(); ++i){
      _observer_pointers[i].update();
   }
}

#endif