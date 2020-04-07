#ifndef CompRJ_H_
#define CompRJ_H_
#include "params/src/params.h"
#include <math.h>
#include "Cpp/Composer/Join.h"
#include "Cpp/Composer/AllStateVariableTypes.h"
#include "Atomic/TemplateSANDAREP0/TemplateSANDAREP0SAN.h"
#include "Atomic/TemplateSANDAREP1/TemplateSANDAREP1SAN.h"
#include "Atomic/TemplateSANDAREP2/TemplateSANDAREP2SAN.h"
#include "Atomic/TemplateSANDAREP3/TemplateSANDAREP3SAN.h"
#include "Atomic/TemplateSANDAREP4/TemplateSANDAREP4SAN.h"
#include "Atomic/TemplateSANDAREP5/TemplateSANDAREP5SAN.h"
#include "Atomic/TemplateSANDAREP6/TemplateSANDAREP6SAN.h"
#include "Atomic/TemplateSANDAREP7/TemplateSANDAREP7SAN.h"
#include "Atomic/TemplateSANDAREP8/TemplateSANDAREP8SAN.h"
#include "Atomic/TemplateSANDAREP9/TemplateSANDAREP9SAN.h"
#include "Atomic/TemplateSANDAREP10/TemplateSANDAREP10SAN.h"
#include "Atomic/TemplateSANDAREP11/TemplateSANDAREP11SAN.h"
#include "Atomic/TemplateSANDAREP12/TemplateSANDAREP12SAN.h"
#include "Atomic/TemplateSANDAREP13/TemplateSANDAREP13SAN.h"
#include "Atomic/TemplateSANDAREP14/TemplateSANDAREP14SAN.h"
#include "Atomic/TemplateSANDAREP15/TemplateSANDAREP15SAN.h"
#include "Atomic/TemplateSANDAREP16/TemplateSANDAREP16SAN.h"
#include "Atomic/TemplateSANDAREP17/TemplateSANDAREP17SAN.h"
#include "Atomic/TemplateSANDAREP18/TemplateSANDAREP18SAN.h"
#include "Atomic/TemplateSANDAREP19/TemplateSANDAREP19SAN.h"
#include "Atomic/TemplateSANDAREP20/TemplateSANDAREP20SAN.h"
#include "Atomic/TemplateSANDAREP21/TemplateSANDAREP21SAN.h"
#include "Atomic/TemplateSANDAREP22/TemplateSANDAREP22SAN.h"
#include "Atomic/TemplateSANDAREP23/TemplateSANDAREP23SAN.h"
#include "Atomic/TemplateSANDAREP24/TemplateSANDAREP24SAN.h"
#include "Atomic/TemplateSANDAREP25/TemplateSANDAREP25SAN.h"
#include "Atomic/TemplateSANDAREP26/TemplateSANDAREP26SAN.h"
#include "Atomic/TemplateSANDAREP27/TemplateSANDAREP27SAN.h"
#include "Atomic/TemplateSANDAREP28/TemplateSANDAREP28SAN.h"
#include "Atomic/TemplateSANDAREP29/TemplateSANDAREP29SAN.h"
#include "Atomic/TemplateSANDAREP30/TemplateSANDAREP30SAN.h"
#include "Atomic/TemplateSANDAREP31/TemplateSANDAREP31SAN.h"
#include "Atomic/TemplateSANDAREP32/TemplateSANDAREP32SAN.h"
#include "Atomic/TemplateSANDAREP33/TemplateSANDAREP33SAN.h"
#include "Atomic/TemplateSANDAREP34/TemplateSANDAREP34SAN.h"
#include "Atomic/TemplateSANDAREP35/TemplateSANDAREP35SAN.h"
#include "Atomic/TemplateSANDAREP36/TemplateSANDAREP36SAN.h"
#include "Atomic/TemplateSANDAREP37/TemplateSANDAREP37SAN.h"
#include "Atomic/TemplateSANDAREP38/TemplateSANDAREP38SAN.h"
#include "Atomic/TemplateSANDAREP39/TemplateSANDAREP39SAN.h"
#include "Atomic/TemplateSANDAREP40/TemplateSANDAREP40SAN.h"
#include "Atomic/TemplateSANDAREP41/TemplateSANDAREP41SAN.h"
#include "Atomic/TemplateSANDAREP42/TemplateSANDAREP42SAN.h"
#include "Atomic/TemplateSANDAREP43/TemplateSANDAREP43SAN.h"
#include "Atomic/TemplateSANDAREP44/TemplateSANDAREP44SAN.h"
#include "Atomic/TemplateSANDAREP45/TemplateSANDAREP45SAN.h"
#include "Atomic/TemplateSANDAREP46/TemplateSANDAREP46SAN.h"
#include "Atomic/TemplateSANDAREP47/TemplateSANDAREP47SAN.h"
#include "Atomic/TemplateSANDAREP48/TemplateSANDAREP48SAN.h"
#include "Atomic/TemplateSANDAREP49/TemplateSANDAREP49SAN.h"
#include "Atomic/TemplateSANDAREP50/TemplateSANDAREP50SAN.h"
#include "Atomic/TemplateSANDAREP51/TemplateSANDAREP51SAN.h"
#include "Atomic/TemplateSANDAREP52/TemplateSANDAREP52SAN.h"
#include "Atomic/TemplateSANDAREP53/TemplateSANDAREP53SAN.h"
#include "Atomic/TemplateSANDAREP54/TemplateSANDAREP54SAN.h"
#include "Atomic/TemplateSANDAREP55/TemplateSANDAREP55SAN.h"
#include "Atomic/TemplateSANDAREP56/TemplateSANDAREP56SAN.h"
#include "Atomic/TemplateSANDAREP57/TemplateSANDAREP57SAN.h"
#include "Atomic/TemplateSANDAREP58/TemplateSANDAREP58SAN.h"
#include "Atomic/TemplateSANDAREP59/TemplateSANDAREP59SAN.h"
#include "Atomic/TemplateSANDAREP60/TemplateSANDAREP60SAN.h"
#include "Atomic/TemplateSANDAREP61/TemplateSANDAREP61SAN.h"
#include "Atomic/TemplateSANDAREP62/TemplateSANDAREP62SAN.h"
#include "Atomic/TemplateSANDAREP63/TemplateSANDAREP63SAN.h"
#include "Atomic/TemplateSANDAREP64/TemplateSANDAREP64SAN.h"
#include "Atomic/TemplateSANDAREP65/TemplateSANDAREP65SAN.h"
#include "Atomic/TemplateSANDAREP66/TemplateSANDAREP66SAN.h"
#include "Atomic/TemplateSANDAREP67/TemplateSANDAREP67SAN.h"
#include "Atomic/TemplateSANDAREP68/TemplateSANDAREP68SAN.h"
#include "Atomic/TemplateSANDAREP69/TemplateSANDAREP69SAN.h"
#include "Atomic/TemplateSANDAREP70/TemplateSANDAREP70SAN.h"
#include "Atomic/TemplateSANDAREP71/TemplateSANDAREP71SAN.h"
#include "Atomic/TemplateSANDAREP72/TemplateSANDAREP72SAN.h"
#include "Atomic/TemplateSANDAREP73/TemplateSANDAREP73SAN.h"
#include "Atomic/TemplateSANDAREP74/TemplateSANDAREP74SAN.h"
#include "Atomic/TemplateSANDAREP75/TemplateSANDAREP75SAN.h"
#include "Atomic/TemplateSANDAREP76/TemplateSANDAREP76SAN.h"
#include "Atomic/TemplateSANDAREP77/TemplateSANDAREP77SAN.h"
#include "Atomic/TemplateSANDAREP78/TemplateSANDAREP78SAN.h"
#include "Atomic/TemplateSANDAREP79/TemplateSANDAREP79SAN.h"
#include "Atomic/TemplateSANDAREP80/TemplateSANDAREP80SAN.h"
#include "Atomic/TemplateSANDAREP81/TemplateSANDAREP81SAN.h"
#include "Atomic/TemplateSANDAREP82/TemplateSANDAREP82SAN.h"
#include "Atomic/TemplateSANDAREP83/TemplateSANDAREP83SAN.h"
#include "Atomic/TemplateSANDAREP84/TemplateSANDAREP84SAN.h"
#include "Atomic/TemplateSANDAREP85/TemplateSANDAREP85SAN.h"
#include "Atomic/TemplateSANDAREP86/TemplateSANDAREP86SAN.h"
#include "Atomic/TemplateSANDAREP87/TemplateSANDAREP87SAN.h"
#include "Atomic/TemplateSANDAREP88/TemplateSANDAREP88SAN.h"
#include "Atomic/TemplateSANDAREP89/TemplateSANDAREP89SAN.h"
#include "Atomic/TemplateSANDAREP90/TemplateSANDAREP90SAN.h"
#include "Atomic/TemplateSANDAREP91/TemplateSANDAREP91SAN.h"
#include "Atomic/TemplateSANDAREP92/TemplateSANDAREP92SAN.h"
#include "Atomic/TemplateSANDAREP93/TemplateSANDAREP93SAN.h"
#include "Atomic/TemplateSANDAREP94/TemplateSANDAREP94SAN.h"
#include "Atomic/TemplateSANDAREP95/TemplateSANDAREP95SAN.h"
#include "Atomic/TemplateSANDAREP96/TemplateSANDAREP96SAN.h"
#include "Atomic/TemplateSANDAREP97/TemplateSANDAREP97SAN.h"
#include "Atomic/TemplateSANDAREP98/TemplateSANDAREP98SAN.h"
#include "Atomic/TemplateSANDAREP99/TemplateSANDAREP99SAN.h"

//State variable headers
#include "Cpp/BaseClasses/SAN/Place.h"

class CompRJ: public Join {
 public:
  TemplateSANDAREP0SAN * TemplateSANDAREP0;
  TemplateSANDAREP1SAN * TemplateSANDAREP1;
  TemplateSANDAREP2SAN * TemplateSANDAREP2;
  TemplateSANDAREP3SAN * TemplateSANDAREP3;
  TemplateSANDAREP4SAN * TemplateSANDAREP4;
  TemplateSANDAREP5SAN * TemplateSANDAREP5;
  TemplateSANDAREP6SAN * TemplateSANDAREP6;
  TemplateSANDAREP7SAN * TemplateSANDAREP7;
  TemplateSANDAREP8SAN * TemplateSANDAREP8;
  TemplateSANDAREP9SAN * TemplateSANDAREP9;
  TemplateSANDAREP10SAN * TemplateSANDAREP10;
  TemplateSANDAREP11SAN * TemplateSANDAREP11;
  TemplateSANDAREP12SAN * TemplateSANDAREP12;
  TemplateSANDAREP13SAN * TemplateSANDAREP13;
  TemplateSANDAREP14SAN * TemplateSANDAREP14;
  TemplateSANDAREP15SAN * TemplateSANDAREP15;
  TemplateSANDAREP16SAN * TemplateSANDAREP16;
  TemplateSANDAREP17SAN * TemplateSANDAREP17;
  TemplateSANDAREP18SAN * TemplateSANDAREP18;
  TemplateSANDAREP19SAN * TemplateSANDAREP19;
  TemplateSANDAREP20SAN * TemplateSANDAREP20;
  TemplateSANDAREP21SAN * TemplateSANDAREP21;
  TemplateSANDAREP22SAN * TemplateSANDAREP22;
  TemplateSANDAREP23SAN * TemplateSANDAREP23;
  TemplateSANDAREP24SAN * TemplateSANDAREP24;
  TemplateSANDAREP25SAN * TemplateSANDAREP25;
  TemplateSANDAREP26SAN * TemplateSANDAREP26;
  TemplateSANDAREP27SAN * TemplateSANDAREP27;
  TemplateSANDAREP28SAN * TemplateSANDAREP28;
  TemplateSANDAREP29SAN * TemplateSANDAREP29;
  TemplateSANDAREP30SAN * TemplateSANDAREP30;
  TemplateSANDAREP31SAN * TemplateSANDAREP31;
  TemplateSANDAREP32SAN * TemplateSANDAREP32;
  TemplateSANDAREP33SAN * TemplateSANDAREP33;
  TemplateSANDAREP34SAN * TemplateSANDAREP34;
  TemplateSANDAREP35SAN * TemplateSANDAREP35;
  TemplateSANDAREP36SAN * TemplateSANDAREP36;
  TemplateSANDAREP37SAN * TemplateSANDAREP37;
  TemplateSANDAREP38SAN * TemplateSANDAREP38;
  TemplateSANDAREP39SAN * TemplateSANDAREP39;
  TemplateSANDAREP40SAN * TemplateSANDAREP40;
  TemplateSANDAREP41SAN * TemplateSANDAREP41;
  TemplateSANDAREP42SAN * TemplateSANDAREP42;
  TemplateSANDAREP43SAN * TemplateSANDAREP43;
  TemplateSANDAREP44SAN * TemplateSANDAREP44;
  TemplateSANDAREP45SAN * TemplateSANDAREP45;
  TemplateSANDAREP46SAN * TemplateSANDAREP46;
  TemplateSANDAREP47SAN * TemplateSANDAREP47;
  TemplateSANDAREP48SAN * TemplateSANDAREP48;
  TemplateSANDAREP49SAN * TemplateSANDAREP49;
  TemplateSANDAREP50SAN * TemplateSANDAREP50;
  TemplateSANDAREP51SAN * TemplateSANDAREP51;
  TemplateSANDAREP52SAN * TemplateSANDAREP52;
  TemplateSANDAREP53SAN * TemplateSANDAREP53;
  TemplateSANDAREP54SAN * TemplateSANDAREP54;
  TemplateSANDAREP55SAN * TemplateSANDAREP55;
  TemplateSANDAREP56SAN * TemplateSANDAREP56;
  TemplateSANDAREP57SAN * TemplateSANDAREP57;
  TemplateSANDAREP58SAN * TemplateSANDAREP58;
  TemplateSANDAREP59SAN * TemplateSANDAREP59;
  TemplateSANDAREP60SAN * TemplateSANDAREP60;
  TemplateSANDAREP61SAN * TemplateSANDAREP61;
  TemplateSANDAREP62SAN * TemplateSANDAREP62;
  TemplateSANDAREP63SAN * TemplateSANDAREP63;
  TemplateSANDAREP64SAN * TemplateSANDAREP64;
  TemplateSANDAREP65SAN * TemplateSANDAREP65;
  TemplateSANDAREP66SAN * TemplateSANDAREP66;
  TemplateSANDAREP67SAN * TemplateSANDAREP67;
  TemplateSANDAREP68SAN * TemplateSANDAREP68;
  TemplateSANDAREP69SAN * TemplateSANDAREP69;
  TemplateSANDAREP70SAN * TemplateSANDAREP70;
  TemplateSANDAREP71SAN * TemplateSANDAREP71;
  TemplateSANDAREP72SAN * TemplateSANDAREP72;
  TemplateSANDAREP73SAN * TemplateSANDAREP73;
  TemplateSANDAREP74SAN * TemplateSANDAREP74;
  TemplateSANDAREP75SAN * TemplateSANDAREP75;
  TemplateSANDAREP76SAN * TemplateSANDAREP76;
  TemplateSANDAREP77SAN * TemplateSANDAREP77;
  TemplateSANDAREP78SAN * TemplateSANDAREP78;
  TemplateSANDAREP79SAN * TemplateSANDAREP79;
  TemplateSANDAREP80SAN * TemplateSANDAREP80;
  TemplateSANDAREP81SAN * TemplateSANDAREP81;
  TemplateSANDAREP82SAN * TemplateSANDAREP82;
  TemplateSANDAREP83SAN * TemplateSANDAREP83;
  TemplateSANDAREP84SAN * TemplateSANDAREP84;
  TemplateSANDAREP85SAN * TemplateSANDAREP85;
  TemplateSANDAREP86SAN * TemplateSANDAREP86;
  TemplateSANDAREP87SAN * TemplateSANDAREP87;
  TemplateSANDAREP88SAN * TemplateSANDAREP88;
  TemplateSANDAREP89SAN * TemplateSANDAREP89;
  TemplateSANDAREP90SAN * TemplateSANDAREP90;
  TemplateSANDAREP91SAN * TemplateSANDAREP91;
  TemplateSANDAREP92SAN * TemplateSANDAREP92;
  TemplateSANDAREP93SAN * TemplateSANDAREP93;
  TemplateSANDAREP94SAN * TemplateSANDAREP94;
  TemplateSANDAREP95SAN * TemplateSANDAREP95;
  TemplateSANDAREP96SAN * TemplateSANDAREP96;
  TemplateSANDAREP97SAN * TemplateSANDAREP97;
  TemplateSANDAREP98SAN * TemplateSANDAREP98;
  TemplateSANDAREP99SAN * TemplateSANDAREP99;
  Place * NFDRSVDAREP0;
  Place * NFDRSVDAREP1;
  Place * NFDRSVDAREP2;
  Place * NFDRSVDAREP3;
  Place * NFDRSVDAREP4;
  Place * NFDRSVDAREP5;
  Place * NFDRSVDAREP6;
  Place * NFDRSVDAREP7;
  Place * NFDRSVDAREP8;
  Place * NFDRSVDAREP9;
  Place * NFDRSVDAREP10;
  Place * NFDRSVDAREP11;
  Place * NFDRSVDAREP12;
  Place * NFDRSVDAREP13;
  Place * NFDRSVDAREP14;
  Place * NFDRSVDAREP15;
  Place * NFDRSVDAREP16;
  Place * NFDRSVDAREP17;
  Place * NFDRSVDAREP18;
  Place * NFDRSVDAREP19;
  Place * NFDRSVDAREP20;
  Place * NFDRSVDAREP21;
  Place * NFDRSVDAREP22;
  Place * NFDRSVDAREP23;
  Place * NFDRSVDAREP24;
  Place * NFDRSVDAREP25;
  Place * NFDRSVDAREP26;
  Place * NFDRSVDAREP27;
  Place * NFDRSVDAREP28;
  Place * NFDRSVDAREP29;
  Place * NFDRSVDAREP30;
  Place * NFDRSVDAREP31;
  Place * NFDRSVDAREP32;
  Place * NFDRSVDAREP33;
  Place * NFDRSVDAREP34;
  Place * NFDRSVDAREP35;
  Place * NFDRSVDAREP36;
  Place * NFDRSVDAREP37;
  Place * NFDRSVDAREP38;
  Place * NFDRSVDAREP39;
  Place * NFDRSVDAREP40;
  Place * NFDRSVDAREP41;
  Place * NFDRSVDAREP42;
  Place * NFDRSVDAREP43;
  Place * NFDRSVDAREP44;
  Place * NFDRSVDAREP45;
  Place * NFDRSVDAREP46;
  Place * NFDRSVDAREP47;
  Place * NFDRSVDAREP48;
  Place * NFDRSVDAREP49;
  Place * NFDRSVDAREP50;
  Place * NFDRSVDAREP51;
  Place * NFDRSVDAREP52;
  Place * NFDRSVDAREP53;
  Place * NFDRSVDAREP54;
  Place * NFDRSVDAREP55;
  Place * NFDRSVDAREP56;
  Place * NFDRSVDAREP57;
  Place * NFDRSVDAREP58;
  Place * NFDRSVDAREP59;
  Place * NFDRSVDAREP60;
  Place * NFDRSVDAREP61;
  Place * NFDRSVDAREP62;
  Place * NFDRSVDAREP63;
  Place * NFDRSVDAREP64;
  Place * NFDRSVDAREP65;
  Place * NFDRSVDAREP66;
  Place * NFDRSVDAREP67;
  Place * NFDRSVDAREP68;
  Place * NFDRSVDAREP69;
  Place * NFDRSVDAREP70;
  Place * NFDRSVDAREP71;
  Place * NFDRSVDAREP72;
  Place * NFDRSVDAREP73;
  Place * NFDRSVDAREP74;
  Place * NFDRSVDAREP75;
  Place * NFDRSVDAREP76;
  Place * NFDRSVDAREP77;
  Place * NFDRSVDAREP78;
  Place * NFDRSVDAREP79;
  Place * NFDRSVDAREP80;
  Place * NFDRSVDAREP81;
  Place * NFDRSVDAREP82;
  Place * NFDRSVDAREP83;
  Place * NFDRSVDAREP84;
  Place * NFDRSVDAREP85;
  Place * NFDRSVDAREP86;
  Place * NFDRSVDAREP87;
  Place * NFDRSVDAREP88;
  Place * NFDRSVDAREP89;
  Place * NFDRSVDAREP90;
  Place * NFDRSVDAREP91;
  Place * NFDRSVDAREP92;
  Place * NFDRSVDAREP93;
  Place * NFDRSVDAREP94;
  Place * NFDRSVDAREP95;
  Place * NFDRSVDAREP96;
  Place * NFDRSVDAREP97;
  Place * NFDRSVDAREP98;
  Place * NFDRSVDAREP99;

  CompRJ();
  ~CompRJ();
};

#endif
