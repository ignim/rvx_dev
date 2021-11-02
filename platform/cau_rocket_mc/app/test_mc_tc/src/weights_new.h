#include "ervp_variable_allocation.h"
double weights[1764] BIG_DATA= {0.145492,-0.052193,0.092303,-0.139425,-0.140339,-0.015316,-0.108498,-0.060838,0.065648,-0.073168,0.053013,0.158941,-0.017651,0.132841,0.085758,-0.035712,0.091677,0.026329,0.090741,-0.000602,-0.074372,-0.052921,0.086143,0.021026,0.015316,0.059076,0.024197,-0.040410,0.020981,0.139480,0.142314,-0.055778,-0.070119,-0.021012,-0.065143,-0.060466,0.165675,0.039387,0.042064,0.090088,-0.057940,0.022065,-0.002020,-0.048707,-0.077546,-0.023762,0.095540,0.020990,-0.044496,0.069945,-0.106904,
0.079283,-0.008917,0.072804,0.093846,-0.127406,0.059394,-0.176470,0.114181,0.013814,0.023581,0.135839,0.148471,0.101966,0.006950,-0.078829,0.006939,-0.026078,0.079500,0.075487,0.028460,-0.043983,-0.035454,-0.073701,0.026306,0.037477,0.077063,0.040674,-0.005921,0.018453,0.022693,-0.140615,0.034081,-0.011033,0.001917,0.122807,0.023078,-0.119160,0.100380,0.055333,0.014626,-0.054928,0.020696,0.115712,0.111199,-0.108719,-0.020781,0.104960,0.141880,0.017625,0.071748,
-0.029628,0.010028,0.092967,0.143351,-0.058008,-0.033425,-0.203173,0.123872,-0.065859,-0.045592,-0.042141,-0.011609,-0.057108,0.145524,-0.037662,0.111228,-0.018634,-0.142628,-0.084451,-0.067631,0.113709,0.064943,-0.187146,0.062031,0.139926,0.047535,-0.037742,0.072149,0.060534,0.033510,-0.152702,0.051492,0.083173,0.180539,0.005952,0.048747,0.027461,0.047952,-0.027410,-0.042181,-0.019451,-0.076090,0.003752,0.131392,0.044670,0.097946,-0.000739,0.034703,0.041618,0.010841,
-0.115055,0.062961,0.005257,-0.061505,-0.135633,-0.051354,-0.017246,-0.009333,-0.065562,0.059975,0.152278,0.065141,-0.166958,0.082521,0.041819,0.054053,0.036884,-0.013975,0.191062,0.039035,-0.058731,0.009714,-0.209073,-0.069368,0.066360,0.037653,-0.080169,0.096424,0.024095,0.101257,-0.010956,0.122273,0.021892,0.018744,0.001953,-0.079981,-0.089163,0.025606,-0.032243,-0.217145,-0.134411,0.058261,0.073789,0.046988,-0.023997,0.120571,0.054914,-0.016051,0.031422,-0.038606,
0.023171,-0.119355,-0.020677,0.024395,0.004906,0.029788,0.019939,0.057263,-0.100858,0.048486,0.038123,-0.038013,-0.093552,-0.036766,0.002372,0.117147,0.279620,0.085665,-0.073155,-0.061138,-0.008788,0.122957,0.005443,-0.196836,0.088212,-0.122017,0.112720,-0.165603,-0.036624,0.134407,-0.081626,-0.063080,0.087025,-0.041714,-0.061460,0.085021,-0.074073,0.054662,0.048313,0.055094,-0.028694,0.019738,-0.012008,0.052860,0.067527,0.029207,-0.008632,-0.029309,-0.050239,0.024817,
-0.104803,0.103113,0.148419,0.019495,-0.054630,-0.101610,-0.083796,-0.051802,-0.176941,-0.079201,0.073491,0.086129,-0.027940,0.060272,-0.028263,-0.085171,0.127965,0.043573,-0.014590,0.025478,0.002245,0.035172,-0.103544,0.023460,-0.077126,-0.024561,0.074833,0.009924,0.053470,0.140845,0.045283,-0.094179,-0.043499,-0.018425,0.111499,0.049923,0.098228,0.169150,0.175610,-0.013535,-0.057591,-0.054650,0.021382,-0.064375,-0.000556,-0.105603,0.055734,0.098987,0.178006,-0.030643,
0.001736,0.046837,-0.064074,-0.094401,-0.181032,-0.039983,0.076073,0.159737,-0.015449,0.085673,0.036257,0.058203,-0.060246,-0.082825,-0.050321,-0.002191,0.067550,0.084490,-0.067789,-0.170331,-0.048217,0.023716,-0.046893,-0.127681,0.012110,-0.137530,-0.075801,0.138932,-0.092844,-0.127447,0.038603,0.103937,-0.187249,0.219753,-0.049935,-0.074777,-0.037564,-0.013428,-0.003302,0.068268,-0.054374,0.161752,0.046047,0.001819,0.073450,0.024878,0.001310,0.034674,0.081145,0.055956,
0.113194,0.107474,-0.017764,0.103010,0.061018,-0.246200,-0.132563,-0.071511,-0.111816,0.153864,-0.161749,-0.056096,-0.138477,-0.021468,-0.123476,0.024209,-0.056315,0.065993,-0.104292,0.126305,-0.153940,0.123593,0.085689,-0.112214,-0.054929,-0.151210,0.192968,0.085536,-0.028339,0.081026,-0.015421,0.128088,0.016593,0.063730,0.083711,-0.010029,-0.074717,-0.040384,-0.032564,0.007707,0.037720,-0.058449,0.016040,0.035310,-0.039601,0.037164,-0.005121,-0.144510,-0.054972,-0.000592,
0.089587,-0.021896,-0.069380,0.116143,0.029815,-0.020552,-0.070470,-0.090323,0.186307,0.057724,-0.037688,0.112731,0.141341,-0.048449,-0.038761,0.016413,0.116791,-0.050076,0.007652,0.011949,-0.044913,0.063684,-0.058296,0.007216,-0.029263,-0.146807,-0.038201,-0.069421,-0.046048,0.052129,0.005047,0.018571,0.010739,0.113649,-0.065966,0.037405,0.021083,0.004945,-0.087175,0.058528,0.010757,-0.071913,-0.067232,0.002201,0.023392,0.057474,-0.034201,0.045269,-0.083948,-0.092656,
-0.021228,0.043457,-0.012105,-0.074374,0.056334,0.059130,0.127472,0.015201,-0.034621,-0.088675,-0.006661,0.048499,-0.115991,-0.012663,0.014149,-0.036088,0.044328,0.110848,0.054458,0.023921,-0.129935,-0.134464,-0.006375,0.095202,0.093687,-0.127243,0.125322,-0.071924,-0.067577,-0.037174,0.007980,0.104675,0.110968,-0.015568,-0.005114,0.217027,0.022161,-0.086497,0.045670,0.004134,0.258510,0.000780,-0.022989,0.042143,-0.038622,0.083241,-0.052074,-0.223576,-0.081266,0.014355,
-0.021440,-0.031642,-0.034122,0.098797,0.155246,0.108347,0.043438,0.021652,0.083751,-0.050366,-0.139571,0.051819,-0.059788,-0.020278,-0.056875,-0.083788,-0.159041,-0.133926,-0.078102,-0.048381,-0.095809,0.040511,0.109332,0.179491,0.087928,-0.083629,-0.160165,-0.024135,-0.002342,-0.075816,-0.058337,0.058454,-0.031690,0.094622,0.076544,0.046362,-0.069933,0.029115,0.100510,0.076810,0.053186,0.018156,0.205649,0.031712,0.110563,-0.050122,-0.002859,-0.098925,-0.122394,-0.292649,
-0.038424,0.001523,0.030832,0.072247,-0.119356,-0.030676,0.075564,-0.088727,0.004158,0.235828,0.057168,-0.133250,-0.106035,0.008807,0.018337,0.035629,-0.200808,0.055653,0.003014,0.046774,-0.018522,-0.007111,-0.068638,-0.038555,0.040122,0.143393,0.092159,-0.004696,-0.090540,-0.002930,0.055292,0.053552,-0.020612,-0.122352,-0.100157,-0.140547,-0.146686,0.004202,-0.032795,0.144534,-0.072565,0.038944,0.075577,0.103486,0.139409,0.057588,0.026685,0.033183,0.056390,0.173976,
-0.018969,-0.098904,-0.046898,-0.133192,0.001310,0.054704,0.014863,-0.014662,-0.089751,0.061001,-0.037162,0.001085,0.097077,0.044906,0.050119,-0.038897,0.028375,-0.037859,-0.050124,0.084820,0.111383,-0.004430,0.074705,-0.136497,0.098150,0.027953,0.011271,0.016745,-0.030323,-0.141736,0.035542,-0.106021,0.157486,-0.040886,-0.100293,0.051818,-0.084083,0.097960,-0.106512,-0.064444,-0.066166,0.059511,-0.005397,0.086443,-0.039127,0.038628,-0.101081,0.043555,0.014597,0.004571,
-0.077643,0.063914,-0.070193,-0.053215,-0.096077,0.157617,0.077584,0.071154,0.042877,0.058531,0.029526,-0.081882,-0.109052,0.040913,-0.038047,-0.055664,-0.112848,-0.043879,-0.095329,-0.142160,-0.103070,-0.008690,0.136468,0.055669,-0.060274,0.052630,-0.012465,0.068036,-0.034452,-0.177477,0.075758,0.063455,0.205470,-0.033597,-0.151927,-0.135549,0.006350,0.002113,0.085379,0.045361,-0.075372,0.039866,-0.012331,-0.012839,0.154196,0.010096,0.086066,0.033588,0.084245,0.015808,
0.034705,0.066362,-0.145347,0.000969,0.021241,-0.074426,-0.041645,0.032561,0.004702,0.116990,-0.042925,-0.029325,-0.001141,-0.002230,0.056343,-0.072039,0.057990,-0.096424,-0.161159,-0.106297,0.047973,-0.087067,-0.194461,0.008359,0.024454,0.031257,0.108361,-0.134909,0.037563,-0.010400,0.110001,0.013215,0.108972,-0.016522,0.071294,0.067506,0.001768,-0.032357,-0.006012,-0.012165,-0.006491,-0.019680,-0.074408,-0.094523,0.080107,0.037977,-0.024517,-0.045587,0.003929,-0.043897,
0.000560,0.089706,0.021546,0.076012,-0.033237,0.137171,0.099126,-0.069689,-0.098802,0.053794,-0.055174,0.189050,-0.036467,-0.021721,0.094463,-0.039389,-0.006233,-0.135938,-0.067769,0.095001,-0.055658,-0.076900,-0.092800,0.135813,0.119233,0.234053,-0.034761,-0.069168,0.084059,0.041877,-0.039377,-0.042172,0.035358,0.075538,-0.016365,-0.075722,0.155979,-0.088450,-0.012228,-0.071980,0.069436,0.038811,0.057916,-0.026231,0.064763,-0.042806,0.029116,0.104763,-0.057103,0.029633,
0.133289,-0.205711,0.130905,-0.024371,0.054340,0.041431,-0.042583,0.052248,0.103926,-0.170177,-0.173731,0.032981,-0.126371,-0.136069,0.030215,-0.084681,-0.078681,0.053170,0.058603,-0.119993,-0.047792,0.037613,0.000071,0.036707,0.061936,0.110463,0.063492,0.116633,0.044939,-0.019493,-0.105223,-0.079953,-0.052406,-0.054240,0.017539,-0.064553,0.121118,0.053720,0.188428,0.015132,0.205078,0.050494,0.069916,0.017242,0.044909,0.063478,0.083047,-0.078632,-0.111913,-0.139087,
-0.116956,-0.115501,0.065105,0.137256,0.115168,-0.031784,-0.008067,0.194706,0.037189,0.102044,-0.106980,-0.082377,-0.132544,0.264409,0.001689,0.023276,-0.043543,-0.004748,-0.018144,0.182492,-0.089700,-0.025196,0.045902,0.051877,0.064721,0.032442,0.125771,0.219031,0.010190,-0.146005,-0.068367,-0.054331,0.017396,0.051965,0.023062,0.066061,-0.033768,-0.048931,-0.040607,0.027023,0.140456,0.161726,-0.109224,-0.079501,-0.036939,0.035743,-0.059164,-0.086655,0.135338,0.155299,
0.022514,-0.044421,-0.147525,0.002377,-0.140892,0.074631,0.095286,0.102201,0.077750,0.006794,0.089249,0.131355,0.110089,0.282757,-0.045722,0.049508,-0.100338,-0.135380,-0.022398,0.012620,-0.050245,0.046673,0.030004,0.045540,0.002568,-0.018489,-0.113009,-0.163484,-0.160415,0.008607,-0.050842,0.054375,-0.038691,-0.136956,0.231107,-0.067527,-0.058002,0.016801,-0.058062,0.064494,0.006151,0.045768,-0.047737,-0.023410,0.051860,0.100326,0.121618,0.065350,0.086369,0.037906,
-0.008665,-0.073889,0.024034,0.179284,0.101796,0.070610,-0.035101,0.188808,0.015361,-0.146034,-0.266259,0.039987,0.102292,-0.145183,-0.032279,-0.025885,0.073691,0.002385,-0.067544,-0.155537,-0.037132,0.018827,-0.005910,-0.104554,-0.154740,-0.116300,0.064963,0.169844,0.048989,0.168545,-0.019119,0.092397,0.057745,-0.032023,0.023572,0.218688,0.186967,-0.033984,-0.023160,-0.001008,0.001984,0.011395,0.040108,0.045515,0.022603,0.000494,0.106961,-0.115373,-0.000443,-0.027371,
0.044209,-0.128998,-0.132223,0.100722,0.048597,-0.000226,-0.207601,0.251005,-0.068582,-0.190296,0.080656,0.047496,0.019243,0.018558,0.066591,-0.169312,0.001995,0.076951,0.052660,0.009054,0.244735,-0.128612,-0.082587,-0.068937,-0.009942,0.056649,0.067071,-0.012285,0.117780,-0.064189,0.007903,-0.019435,-0.051183,-0.037942,-0.034992,0.063504,-0.026960,-0.055354,0.018328,0.086100,0.039404,0.012991,-0.084435,0.209092,0.106918,-0.096670,-0.068538,-0.144422,0.037554,0.072420,
-0.024272,-0.010927,-0.152919,0.072455,0.226830,0.010290,0.047504,0.005084,-0.070762,0.046991,0.029837,-0.082007,-0.036305,-0.024311,-0.009504,0.073225,0.030875,-0.073947,-0.001860,0.218797,-0.032067,0.048937,-0.009345,-0.116937,-0.069288,-0.033050,0.020300,0.138083,0.146532,0.026014,-0.088077,0.008405,-0.204454,0.069316,0.046732,-0.009605,-0.084370,-0.053500,-0.074933,0.050704,0.111372,0.028543,-0.024831,-0.025457,-0.002362,-0.017496,0.209312,-0.037138,-0.020753,0.062647,
-0.103657,0.147534,-0.134255,-0.042004,0.001032,-0.152558,-0.060488,-0.141652,-0.032650,-0.035512,-0.003616,0.041324,-0.164132,0.126125,0.103560,-0.006698,-0.092813,-0.083763,-0.130273,-0.003002,0.083901,0.095750,0.081926,0.036245,0.162099,-0.050742,0.112906,0.088733,-0.023006,-0.042962,-0.132151,0.033961,0.175408,-0.156306,0.143788,-0.072890,0.094027,0.043038,-0.110757,-0.087073,-0.114165,-0.023596,-0.168285,0.056763,-0.071780,-0.182575,0.073398,-0.070356,-0.076597,0.037163,
-0.011780,-0.164383,-0.054654,0.104489,-0.129327,-0.061401,0.020260,0.086959,-0.044948,-0.095286,0.074954,-0.060235,0.112955,-0.007091,-0.003347,-0.027294,0.087950,0.096288,-0.094817,0.024181,0.036887,-0.020689,0.126056,0.023067,-0.072935,0.060868,-0.094910,-0.033486,-0.066648,-0.140908,-0.104634,-0.063064,0.135728,-0.114290,0.093076,0.020642,0.119500,-0.117609,-0.018168,0.150269,-0.037773,0.080515,-0.056198,0.078769,0.085383,-0.114443,0.068781,0.027692,0.182278,0.197889,
-0.041197,-0.029103,0.118565,-0.097760,-0.068751,0.049549,0.040143,-0.160406,0.187761,-0.078082,-0.116605,0.016550,-0.065791,-0.024586,-0.007354,-0.168329,-0.004644,-0.144912,0.135000,0.051035,0.068647,-0.150533,-0.055349,-0.062832,-0.060745,-0.105239,-0.050609,-0.106876,0.012126,-0.001954,0.059372,0.010542,0.241427,0.072905,0.187815,0.033884,0.106577,0.147041,-0.045359,-0.008717,0.090870,0.059447,0.036896,0.270824,0.054930,-0.142734,-0.166930,-0.022246,-0.052018,0.011918,
0.140959,-0.274570,-0.049220,0.092236,-0.151125,-0.039630,-0.120043,0.044469,-0.158761,0.108879,-0.040703,-0.079608,-0.135143,-0.007931,0.248701,0.106225,0.211347,0.134878,0.069926,-0.112851,0.067522,-0.150726,0.004893,-0.048894,0.102004,0.055558,-0.004829,-0.036167,0.113168,0.002581,0.108793,-0.145878,-0.051703,0.016922,0.000103,0.014950,-0.066906,-0.010777,-0.091853,0.022823,0.012031,-0.063412,-0.070026,0.079301,-0.122745,0.249725,0.001706,-0.030205,-0.082415,-0.034604,
-0.156492,0.040860,-0.040574,-0.058031,-0.010312,-0.221441,-0.067470,-0.026847,0.154136,0.011811,-0.078465,-0.018417,0.131004,0.004487,0.110075,0.004534,0.024221,0.035643,0.052398,-0.141258,-0.074666,-0.102961,-0.142529,0.116351,-0.007354,0.029687,0.010627,0.004577,-0.019299,-0.152948,0.079116,0.186300,0.022659,0.018163,0.022363,-0.071173,0.063843,-0.065311,-0.081451,-0.017820,0.073451,-0.174104,0.019246,-0.123324,0.093910,0.006914,-0.011637,-0.083241,-0.007092,-0.162294,
-0.006407,-0.003825,0.014958,0.071911,-0.109942,-0.057278,-0.054502,0.056416,-0.023345,0.014273,-0.006111,-0.048340,0.044470,0.097219,-0.020014,-0.100315,0.096199,0.014755,0.018185,-0.075678,-0.095950,-0.109665,0.081175,0.098180,-0.093606,-0.048835,-0.023386,0.074597,0.127934,0.017240,0.170613,0.089889,-0.064910,-0.044079,0.061677,-0.247232,0.088733,0.023216,0.118410,-0.160181,-0.040315,0.068806,0.121403,-0.029393,-0.121782,0.130876,0.038468,0.001963,0.111154,0.031051,
-0.037997,-0.066433,-0.122975,0.067396,-0.102648,-0.157536,-0.033747,-0.129262,0.055807,0.071407,-0.004532,0.033078,0.060203,-0.103170,0.067798,-0.126619,0.202192,0.042735,-0.048604,0.108641,-0.044354,0.195438,-0.150683,-0.016317,0.100006,0.183987,-0.200760,0.019161,0.114921,0.178632,-0.004481,-0.052653,-0.095428,-0.269848,0.000318,-0.088728,0.151764,-0.128694,0.009629,0.109058,0.227038,0.056219,0.011418,-0.071834,0.094524,-0.088696,-0.003714,-0.003880,0.064234,0.012473,
-0.052971,-0.082277,0.026466,0.087445,0.055791,-0.155307,0.012894,-0.114352,-0.116596,-0.112256,-0.081062,0.086340,-0.084855,0.175882,0.007295,0.144781,-0.073122,0.107019,-0.148824,-0.069834,0.012540,0.268912,-0.009560,0.025386,0.002823,0.065121,-0.073120,-0.058754,-0.034004,-0.154456,-0.015881,-0.038299,0.104973,-0.018335,0.199453,0.154120,0.240090,0.113097,0.048696,0.053198,0.021510,-0.025133,0.011378,-0.016441,0.009441,-0.113178,-0.046716,0.021643,-0.072435,-0.076621,
0.094982,0.172753,-0.027189,-0.166857,-0.037988,-0.269855,0.126469,-0.006795,-0.040178,-0.095921,-0.228058,0.213719,-0.066848,-0.074496,0.000994,-0.051212,0.013950,0.007713,-0.166592,0.101158,0.184804,-0.095378,0.009998,-0.064236,-0.011117,-0.004278,0.072735,0.026743,0.078476,0.013367,-0.060101,0.203975,-0.057567,-0.208446,-0.002555,0.002259,-0.204568,0.186690,-0.073860,0.041686,-0.086072,-0.053505,0.029580,0.017145,0.008241,-0.034528,0.042291,-0.042408,0.010683,0.045217,
-0.067237,-0.141033,0.004582,0.063969,-0.050136,0.084570,0.150402,-0.106902,0.051455,0.029586,-0.072362,0.093792,-0.027110,0.081161,0.023638,0.029298,-0.028238,0.005367,-0.029117,-0.099410,0.051054,0.077430,-0.144532,0.074704,-0.103504,-0.093623,0.069723,-0.089318,0.117412,-0.129998,-0.011855,0.022746,0.106226,0.024663,-0.007714,-0.039647,-0.009849,-0.076793,0.056639,0.099185,0.065711,0.001682,0.050743,-0.089032,0.014684,-0.145873,0.169090,0.008245,0.039364,-0.019255,
0.031570,0.043341,0.046512,-0.004192,0.011342,-0.048970,-0.013245,-0.007584,-0.111319,0.047357,0.138958,0.112920,-0.021995,0.002836,0.034274,-0.004006,-0.072875,-0.146654,-0.004100,0.001058,0.001613,-0.048823,-0.126758,-0.012371,-0.097196,-0.108269,-0.083311,0.035897,-0.188584,0.076615,0.064756,0.064617,0.195910,0.025233,-0.011763,-0.064113,-0.106974,-0.148499,-0.077519,0.042697,-0.003222,0.021241,0.128019,0.003960,0.094344,0.097138,0.006814,0.086523,0.031689,0.023935,
0.127941,0.001249,-0.072963,-0.116299,-0.052803,0.139559,-0.185881,-0.153299,-0.125908,-0.029472,0.013867,-0.024036,-0.070711,-0.027948,0.135840,0.150504,0.120487,0.101526,0.016793,0.082538,-0.126963,-0.005856,-0.105517,-0.067659,-0.119409,-0.060912,-0.095575,0.171605,-0.057006,0.128145,-0.033047,0.088809,-0.051682,0.086322,-0.007601,-0.002020,0.057948,0.143025,0.096347,-0.163015,-0.080858,-0.012252,0.008094,-0.114140,0.061115,0.013608,0.036408,-0.019340,-0.031294,0.009532,
0.011256,-0.059260,0.207031,0.148351,0.036327,-0.002943,0.146129,-0.108183,-0.177093,0.026241,-0.058914,0.058435,0.102676,0.062233,-0.153097,0.058431,-0.085305,0.227346,-0.037296,0.025370,-0.005719,-0.093309,-0.004823,-0.007772,0.161897,-0.037723,-0.139596,0.166234,-0.119281,-0.090015,-0.034785,-0.059490,-0.106172,0.042571,0.052963,0.164753,0.039062,0.087506,0.111102,0.081878,-0.133186,-0.107158,-0.049807,0.091091,0.080548,0.053711,0.017195,0.183775,-0.038003,-0.060257,
-0.047325,-0.144310,-0.072705,0.051993,0.090649,-0.014313,-0.043958,0.141737,0.039763,-0.015970,-0.054422,0.024471,-0.138430};
double unscaled_bias = -0.32802695;