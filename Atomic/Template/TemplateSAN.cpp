

// This C++ file was created by SanEditor

#include "Atomic/Template/TemplateSAN.h"

#include <stdlib.h>
#include <iostream>

#include <math.h>


/*****************************************************************
                         TemplateSAN Constructor             
******************************************************************/


TemplateSAN::TemplateSAN(){


  Activity* InitialActionList[2]={
    &tFail, //0
    &TFail  // 1
  };

  BaseGroupClass* InitialGroupList[2]={
    (BaseGroupClass*) &(TFail), 
    (BaseGroupClass*) &(tFail)
  };

  canFail = new Place("canFail" ,1);
  NF = new Place("NF" ,0);
  BaseStateVariableClass* InitialPlaces[2]={
    canFail,  // 0
    NF   // 1
  };
  BaseStateVariableClass* InitialROPlaces[0]={
  };
  initializeSANModelNow("Template", 2, InitialPlaces, 
                        0, InitialROPlaces, 
                        2, InitialActionList, 2, InitialGroupList);


  assignPlacesToActivitiesInst();
  assignPlacesToActivitiesTimed();

  int AffectArcs[4][2]={ 
    {0,0}, {1,0}, {0,1}, {1,1}
  };
  for(int n=0;n<4;n++) {
    AddAffectArc(InitialPlaces[AffectArcs[n][0]],
                 InitialActionList[AffectArcs[n][1]]);
  }
  int EnableArcs[3][2]={ 
    {0,0}, {1,0}, {0,1}
  };
  for(int n=0;n<3;n++) {
    AddEnableArc(InitialPlaces[EnableArcs[n][0]],
                 InitialActionList[EnableArcs[n][1]]);
  }

  for(int n=0;n<2;n++) {
    InitialActionList[n]->LinkVariables();
  }
  CustomInitialization();

}

void TemplateSAN::CustomInitialization() {

}
TemplateSAN::~TemplateSAN(){
  for (int i = 0; i < NumStateVariables-NumReadOnlyPlaces; i++)
    delete LocalStateVariables[i];
};

void TemplateSAN::assignPlacesToActivitiesInst(){
  tFail.canFail = (Place*) LocalStateVariables[0];
  tFail.NF = (Place*) LocalStateVariables[1];
}
void TemplateSAN::assignPlacesToActivitiesTimed(){
  TFail.canFail = (Place*) LocalStateVariables[0];
  TFail.NF = (Place*) LocalStateVariables[1];
}
/*****************************************************************/
/*                  Activity Method Definitions                  */
/*****************************************************************/

/*======================tFailActivity========================*/


TemplateSAN::tFailActivity::tFailActivity(){
  ActivityInitialize("tFail",1,Instantaneous , RaceEnabled, 2,2, false);
}

void TemplateSAN::tFailActivity::LinkVariables(){
  canFail->Register(&canFail_Mobius_Mark);
  NF->Register(&NF_Mobius_Mark);
}

bool TemplateSAN::tFailActivity::Enabled(){
  OldEnabled=NewEnabled;
  NewEnabled=((canFail->Mark() > 0 && compare(SANDAREP::Template::NF->Deps())));
  return NewEnabled;
}

double TemplateSAN::tFailActivity::Weight(){ 
  return 1;
}

bool TemplateSAN::tFailActivity::ReactivationPredicate(){ 
  return false;
}

bool TemplateSAN::tFailActivity::ReactivationFunction(){ 
  return false;
}

double TemplateSAN::tFailActivity::SampleDistribution(){
  return 0;
}

double* TemplateSAN::tFailActivity::ReturnDistributionParameters(){
    return NULL;
}

int TemplateSAN::tFailActivity::Rank(){
  return 1;
}

BaseActionClass* TemplateSAN::tFailActivity::Fire(){
  ;
  update(SANDAREP::Template::NF->Deps());
canFail->Mark() = 0;
debug << "tFail fired in replica " << SANDAREP::Template::Index() << std::endl;
  return this;
}

/*======================TFailActivity========================*/

TemplateSAN::TFailActivity::TFailActivity(){
  TheDistributionParameters = new double[1];
  ActivityInitialize("TFail",0,Exponential, RaceEnabled, 2,1, true);
}

TemplateSAN::TFailActivity::~TFailActivity(){
  delete[] TheDistributionParameters;
}

void TemplateSAN::TFailActivity::LinkVariables(){
  canFail->Register(&canFail_Mobius_Mark);
  NF->Register(&NF_Mobius_Mark);
}

bool TemplateSAN::TFailActivity::Enabled(){
  OldEnabled=NewEnabled;
  NewEnabled=(((*(canFail_Mobius_Mark)) >=1));
  return NewEnabled;
}

double TemplateSAN::TFailActivity::Rate(){
  return singleFailureRate * (SANDAREP::Template::NF->Deps(0)->Mark() + 1);
  return 1.0;  // default rate if none is specified
}

double TemplateSAN::TFailActivity::Weight(){ 
  return 1;
}

bool TemplateSAN::TFailActivity::ReactivationPredicate(){ 
  return 1==1;
}

bool TemplateSAN::TFailActivity::ReactivationFunction(){ 
  return 1==1;
}

double TemplateSAN::TFailActivity::SampleDistribution(){
  return TheDistribution->Exponential( singleFailureRate * (SANDAREP::Template::NF->Deps(0)->Mark() + 1));
}

double* TemplateSAN::TFailActivity::ReturnDistributionParameters(){
  TheDistributionParameters[0] = Rate();
  return TheDistributionParameters;
}

int TemplateSAN::TFailActivity::Rank(){
  return 1;
}

BaseActionClass* TemplateSAN::TFailActivity::Fire(){
  (*(canFail_Mobius_Mark))--;
  update(SANDAREP::Template::NF->Deps());
canFail->Mark() = 0;
debug << "TFail fired in replica " << SANDAREP::Template::Index() << std::endl;
  return this;
}

