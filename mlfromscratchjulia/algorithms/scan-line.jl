#scan-line algorithm
maxHt = 800
maxWd = 600
maxVer = 10000
  
struct edgebucket
  ymax::Int
  xofymin::float
  slopeinverse::float
end

struct edgetabletup
	countEdgeBucket::Int
	edgebucket buckets[maxVer]
}
edgetabletup EdgeTable[maxHt], ActiveEdgeTuple;
	
function initEdgeTable()
    for (i=0; i<maxHt; i++)
    {
        EdgeTable[i].countEdgeBucket = 0;
    }
    
    ActiveEdgeTuple.countEdgeBucket = 0;	
end

function printTuple(edgetabletup *tup)
    if (tup->countEdgeBucket)
        printf("\nCount %d-----\n",tup->countEdgeBucket);
          
        for (j=0; j<tup->countEdgeBucket; j++)
        { 
            printf(" %d+%.2f+%.2f",
            tup->buckets[j].ymax, tup->buckets[j].xofymin,tup->buckets[j].slopeinverse);
        }
			
end
function printTable()
    for (i=0; i<maxHt; i++)
    {
        if (EdgeTable[i].countEdgeBucket)
            printf("\nScanline %d", i);
              
        printTuple(&EdgeTable[i]);
    } 
end
function insertionSort(edgetabletuple *ett)
{
    int i,j;
    EdgeBucket temp; 
  
    for (i = 1; i < ett->countEdgeBucket; i++) 
    {
        temp.ymax = ett->buckets[i].ymax;
        temp.xofymin = ett->buckets[i].xofymin;
        temp.slopeinverse = ett->buckets[i].slopeinverse;
        j = i - 1;
  
    while ((temp.xofymin < ett->buckets[j].xofymin) && (j >= 0)) 
    {
        ett->buckets[j + 1].ymax = ett->buckets[j].ymax;
        ett->buckets[j + 1].xofymin = ett->buckets[j].xofymin;
        ett->buckets[j + 1].slopeinverse = ett->buckets[j].slopeinverse;
        j = j - 1;
    }
    ett->buckets[j + 1].ymax = temp.ymax;
    ett->buckets[j + 1].xofymin = temp.xofymin;
    ett->buckets[j + 1].slopeinverse = temp.slopeinverse;
    }
}		