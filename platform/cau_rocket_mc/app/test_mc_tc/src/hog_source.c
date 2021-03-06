
#include "math.h"
#include "stdbool.h"
#include "ervp_printf.h"
#include "weights_new.h"
#include "ervp_memory_util.h"
#include "core_dependent.h"
#include "ervp_tcaching.h"
#include "ervp_barrier.h"
#include "ervp_lock.h"
#include "ervp_variable_allocation.h"
#define IMG_WIDTH 64
#define IMG_HEIGHT 64
#define HOG_WIDTH 64
#define HOG_HEIGHT 64
#define CELL_SIZE_ROW 8
#define CELL_SIZE_COL 8
#define BLOCK_SIZE_ROW 2
#define BLOCK_SIZE_COL 2
#define N_CELLS_ROW HOG_HEIGHT/CELL_SIZE_ROW //4 8
#define N_CELLS_COL HOG_WIDTH/CELL_SIZE_COL //8 8
#define N_BLOCK_ROW (N_CELLS_ROW - 1) //3 7
#define N_BLOCK_COL (N_CELLS_COL - 1) //7 7
#define HISTOGRAMSIZE N_BLOCK_ROW * N_BLOCK_COL * BLOCK_SIZE_ROW * BLOCK_SIZE_COL * 9 //3*7*2*2*9
#define FEATURESIZE (HISTOGRAMSIZE)
#define TCACHE_ENABLE 1
#define TCACHE_WEIGHT_ENABLE 0

double descriptor[HISTOGRAMSIZE] BIG_DATA;
double sum_of_block[N_BLOCK_ROW*N_BLOCK_COL] BIG_DATA;

int lut0[256] BIG_DATA= {0,0,0,1,1,1,2,2,2,3,3,3,4,4,5,5,5,6,6,6,7,7,7,8,8,9,9,9,10,10,10,11,11,11,12,12,13,13,13,14,14,14,15,15,15,16,16,17,17,17,18,18,18,19,19,19,20,20,21,21,21,22,22,22,23,23,23,24,24,25,25,25,26,26,26,27,27,27,28,28,29,29,29,30,30,30,31,31,31,32,32,33,33,33,34,34,34,35,35,35,36,36,37,37,37,38,38,38,39,39,39,40,40,41,41,41,42,42,42,43,43,43,44,44,45,45,45,46,46,46,47,47,47,48,48,49,49,49,50,50,50,51,51,51,52,52,53,53,53,54,54,54,55,55,55,56,56,57,57,57,58,58,58,59,59,59,60,60,61,61,61,62,62,62,63,63,63,64,64,65,65,65,66,66,66,67,67,67,68,68,69,69,69,70,70,70,71,71,71,72,72,73,73,73,74,74,74,75,75,75,76,76,77,77,77,78,78,78,79,79,79,80,80,81,81,81,82,82,82,83,83,83,84,84,85,85,85,86,86,86,87,87,87,88,88,89,89,89,90,90,90,91,91,91,92,92};
int lut1[256] BIG_DATA= {0,0,1,2,3,4,5,5,6,7,8,9,10,10,11,12,13,14,15,15,16,17,18,19,20,20,21,22,23,24,25,26,26,27,28,29,30,31,31,32,33,34,35,36,36,37,38,39,40,41,41,42,43,44,45,46,46,47,48,49,50,51,52,52,53,54,55,56,57,57,58,59,60,61,62,62,63,64,65,66,67,67,68,69,70,71,72,72,73,74,75,76,77,78,78,79,80,81,82,83,83,84,85,86,87,88,88,89,90,91,92,93,93,94,95,96,97,98,98,99,100,101,102,103,104,104,105,106,107,108,109,109,110,111,112,113,114,114,115,116,117,118,119,119,120,121,122,123,124,124,125,126,127,128,129,130,130,131,132,133,134,135,135,136,137,138,139,140,140,141,142,143,144,145,145,146,147,148,149,150,150,151,152,153,154,155,156,156,157,158,159,160,161,161,162,163,164,165,166,166,167,168,169,170,171,171,172,173,174,175,176,177,177,178,179,180,181,182,182,183,184,185,186,187,187,188,189,190,191,192,192,193,194,195,196,197,197,198,199,200,201,202,203,203,204,205,206,207,208,208,209,210,211,212,213,213};
int lut2[256] BIG_DATA= {0,1,3,5,6,8,10,12,13,15,17,19,20,22,24,25,27,29,31,32,34,36,38,39,41,43,44,46,48,50,51,53,55,57,58,60,62,63,65,67,69,70,72,74,76,77,79,81,83,84,86,88,89,91,93,95,96,98,100,102,103,105,107,108,110,112,114,115,117,119,121,122,124,126,127,129,131,133,134,136,138,140,141,143,145,147,148,150,152,153,155,157,159,160,162,164,166,167,169,171,172,174,176,178,179,181,183,185,186,188,190,191,193,195,197,198,200,202,204,205,207,209,210,212,214,216,217,219,221,223,224,226,228,230,231,233,235,236,238,240,242,243,245,247,249,250,252,254,255,257,259,261,262,264,266,268,269,271,273,274,276,278,280,281,283,285,287,288,290,292,294,295,297,299,300,302,304,306,307,309,311,313,314,316,318,319,321,323,325,326,328,330,332,333,335,337,338,340,342,344,345,347,349,351,352,354,356,358,359,361,363,364,366,368,370,371,373,375,377,378,380,382,383,385,387,389,390,392,394,396,397,399,401,402,404,406,408,409,411,413,415,416,418,420,421,423,425,427,428,430,432,434,435,437,439,441};
int lut3[256] BIG_DATA= {0,5,11,17,22,28,34,39,45,51,56,62,68,73,79,85,90,96,102,107,113,119,124,130,136,141,147,153,158,164,170,175,181,187,192,198,204,209,215,221,226,232,238,243,249,255,260,266,272,277,283,289,294,300,306,311,317,323,328,334,340,345,351,357,362,368,374,379,385,391,396,402,408,413,419,425,430,436,442,447,453,459,464,470,476,481,487,493,498,504,510,515,521,527,532,538,544,549,555,561,566,572,578,584,589,595,601,606,612,618,623,629,635,640,646,652,657,663,669,674,680,686,691,697,703,708,714,720,725,731,737,742,748,754,759,765,771,776,782,788,793,799,805,810,816,822,827,833,839,844,850,856,861,867,873,878,884,890,895,901,907,912,918,924,929,935,941,946,952,958,963,969,975,980,986,992,997,1003,1009,1014,1020,1026,1031,1037,1043,1048,1054,1060,1065,1071,1077,1082,1088,1094,1099,1105,1111,1116,1122,1128,1133,1139,1145,1150,1156,1162,1168,1173,1179,1185,1190,1196,1202,1207,1213,1219,1224,1230,1236,1241,1247,1253,1258,1264,1270,1275,1281,1287,1292,1298,1304,1309,1315,1321,1326,1332,1338,1343,1349,1355,1360,1366,1372,1377,1383,1389,1394,1400,1406,1411,1417,1423,1428,1434,1440,1445};
double predict(double* dst){
  double dotproduct=0;
	#if TCACHE_WEIGHT_ENABLE
  flush_cache();
	double * weights_cached= (double *)tcaching_malloc(&weights[0], sizeof(double)*1764);
  for(int i = 0; i < FEATURESIZE; i++) {
  	dotproduct += dst[i] * weights_cached[i];
  }
	tcaching_free((double *)weights_cached);
#else

  for(int i = 0; i < FEATURESIZE; i++) {
  	dotproduct += dst[i] * weights[i];
  }
#endif
  double svm_output = dotproduct + unscaled_bias; 
  double proba = 1.0/(1.0+exp(-2*svm_output));
  return proba;
}

inline int approx_distance(int dx, int dy){
  int min, max; //uint
  if(dx < 0) dx = -dx;
  if(dy < 0) dy = -dy;

  if(dx < dy){
  min = dx;
  max = dy;
  }else{
  min = dy;
  max = dx;
  }
  return ((( max << 8 ) + ( max << 3 ) - ( max << 4 ) - ( max << 1 ) +
       ( min << 7 ) - ( min << 5 ) + ( min << 3 ) - ( min << 1 )) >> 8 );
}
void hog_feature(unsigned char* img, double* dst, bool approx_mode ){

#if TCACHE_ENABLE
  acquire_lock(0);
	 double * descriptor_cached= (double *)tcaching_malloc(descriptor, sizeof(double)*HISTOGRAMSIZE);
	 double * sum_of_block_cached= (double *)tcaching_malloc(sum_of_block,sizeof(double)*N_BLOCK_ROW*N_BLOCK_COL);
	 int * lut0_cached  = (int *)tcaching_malloc(lut0,sizeof(int)*256);
	 int * lut1_cached  = (int *)tcaching_malloc(lut1,sizeof(int)*256);
	 int * lut2_cached  = (int *)tcaching_malloc(lut2,sizeof(int)*256);
	 int * lut3_cached  = (int *)tcaching_malloc(lut3,sizeof(int)*256);
	release_lock(0);
	for(int i = 0; i < HISTOGRAMSIZE; i++) descriptor_cached[i] = 0.0;
	for(int i = 0; i < N_BLOCK_ROW * N_BLOCK_COL; i++) sum_of_block_cached[i] = 0.0;

	for(int y = 0; y < N_BLOCK_ROW; y++){//3
	  for(int x = 0; x < N_BLOCK_COL; x++){//7
	    for(int yy = 0; yy < CELL_SIZE_ROW*BLOCK_SIZE_ROW; yy++){//16
	      for(int xx = 0; xx < CELL_SIZE_COL*BLOCK_SIZE_COL; xx++){//16
	        int ny = CELL_SIZE_ROW * y + yy;
	        int nx = CELL_SIZE_COL * x + xx;

	        int mag = 0;
	        int bin_index;
	        if(ny == 0 || nx == 0 || ny == IMG_HEIGHT-1 || nx == IMG_WIDTH-1){
	          mag = 0;
	          bin_index = 0;
	        }else{
	          int Gx = img[ny*IMG_WIDTH+nx+1] - img[ny*IMG_WIDTH+nx-1];
	          int Gy = img[(ny+1)*IMG_WIDTH+nx] - img[(ny-1)*IMG_WIDTH+nx];
	          mag = (approx_mode ? (approx_distance(Gx, Gy)) : sqrt((double)(Gx*Gx + Gy * Gy)));
	          if((Gx >= 0 && Gy >= 0) || (Gx <= 0 && Gy <= 0)){
	            if (abs(Gy) < lut0_cached[abs(Gx)]) {bin_index = 0; }
	            else if (abs(Gy) < lut1_cached[abs(Gx)]) {bin_index = 1;}
	            else if (abs(Gy) < lut2_cached[abs(Gx)]) {bin_index = 2;}
	            else if (abs(Gy) < lut3_cached[abs(Gx)]) {bin_index = 3;}
	            else {bin_index = 4;}
	          } else{
	            if (abs(Gy) <  lut0_cached[abs(Gx)]){bin_index = 4;}
	            else if (abs(Gy) <  lut1_cached[abs(Gx)]) {bin_index = 5;}
		            else if (abs(Gy) <  lut2_cached[abs(Gx)]) {bin_index = 6;}
		            else if (abs(Gy) <  lut3_cached[abs(Gx)]) {bin_index = 7;}
	            else {bin_index = 8;}
	          }
	        }
	        int cell_index = (yy / 8) * 2 + (xx / 8);
	        int block_index = y * N_BLOCK_COL + x;
	        int descrip_index = block_index * 36 + cell_index * 9 + bin_index;
	        descriptor_cached[descrip_index] += mag;
	        sum_of_block_cached[block_index] += mag;
	      }
	    }
	  }
	}
  double allsum = 0;
  int  average;
  unsigned int blkSize = 36;
  for(int by = 0; by < N_BLOCK_ROW; by++){//3
    for(int bx = 0; bx < N_BLOCK_COL; bx++){//7
      int blkIdx = by * N_BLOCK_COL + bx;
      for (int i = 0; i < 36; i++) {
        int index = blkIdx * 36 + i;
        if(sum_of_block_cached[blkIdx] == 0){
          dst[index] = 0;
        }else{
          dst[index] = sqrt((double)descriptor_cached[index]/(double)sum_of_block_cached[blkIdx]);
        }
      }
    }
  }
  tcaching_free((int *)lut0_cached);
	tcaching_free((int *)lut1_cached);
	tcaching_free((int *)lut2_cached);
	tcaching_free((int *)lut3_cached);
  tcaching_free((double *)descriptor_cached);
	tcaching_free((double *)sum_of_block_cached);

#else
	for(int i = 0; i < HISTOGRAMSIZE; i++) descriptor[i] = 0;
	for(int i = 0; i < N_BLOCK_ROW * N_BLOCK_COL; i++) sum_of_block[i] = 0;

	for(int y = 0; y < N_BLOCK_ROW; y++){//3

	  for(int x = 0; x < N_BLOCK_COL; x++){//7
	    for(int yy = 0; yy < CELL_SIZE_ROW*BLOCK_SIZE_ROW; yy++){//16
	      for(int xx = 0; xx < CELL_SIZE_COL*BLOCK_SIZE_COL; xx++){//16
	        int ny = CELL_SIZE_ROW * y + yy;
	        int nx = CELL_SIZE_COL * x + xx;
	        //compute gradient
	        int mag = 0;
	        int bin_index;
	        if(ny == 0 || nx == 0 || ny == IMG_HEIGHT-1 || nx == IMG_WIDTH-1){
	          mag = 0;
	          bin_index = 0;
	        }else{
	          int Gx = img[ny*IMG_WIDTH+nx+1] - img[ny*IMG_WIDTH+nx-1];
	          int Gy = img[(ny+1)*IMG_WIDTH+nx] - img[(ny-1)*IMG_WIDTH+nx];
	          mag = (approx_mode ? (approx_distance(Gx, Gy)) : sqrt((double)(Gx*Gx + Gy * Gy)));
	          if((Gx >= 0 && Gy >= 0) || (Gx <= 0 && Gy <= 0)){
	            if (abs(Gy) < lut0[abs(Gx)]) {bin_index = 0; }
	            else if (abs(Gy) < lut1[abs(Gx)]) {bin_index = 1;}
	            else if (abs(Gy) < lut2[abs(Gx)]) {bin_index = 2;}
	            else if (abs(Gy) < lut3[abs(Gx)]) {bin_index = 3;}
	            else {bin_index = 4;}
	          } else{
	            if (abs(Gy) <  lut0[abs(Gx)]){bin_index = 4;}
	            else if (abs(Gy) <  lut1[abs(Gx)]) {bin_index = 5;}
	            else if (abs(Gy) <  lut2[abs(Gx)]) {bin_index = 6;}
	            else if (abs(Gy) <  lut3[abs(Gx)]) {bin_index = 7;}
	            else {bin_index = 8;}
	          }
	        }
	        int cell_index = (yy / 8) * 2 + (xx / 8);
	        int block_index = y * N_BLOCK_COL + x;
	        int descrip_index = block_index * 36 + cell_index * 9 + bin_index;
	        descriptor[descrip_index] += mag;
	        sum_of_block[block_index] += mag;
	      }
	    }
	  }
	}
  double allsum = 0;
  int  average;
  unsigned int blkSize = 36;
  for(int by = 0; by < N_BLOCK_ROW; by++){//3
    for(int bx = 0; bx < N_BLOCK_COL; bx++){//7
      int blkIdx = by * N_BLOCK_COL + bx;
      for (int i = 0; i < 36; i++) {
        int index = blkIdx * 36 + i;
        if(sum_of_block[blkIdx] == 0){
          dst[index] = 0;
        }else{
          dst[index] = sqrt((double)descriptor[index]/(double)sum_of_block[blkIdx]);
        }
   //     allsum += dst[index];
      }
    }
  }
#endif

}	
