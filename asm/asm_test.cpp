#include <stdio.h>

long int mid(long int v0, long int l,long int r){
    long int m = (l+r) >> 1;
    printf("%d %d %d\n",m,l,r);
    if (v0 == l*l) return l;
    else if (v0 == r*r) return r;
    else if (v0==m*m) return m;
    else if (r-l==1) return l;
    else if (v0 > m*m)   return mid(v0,m,r);
    else if (v0 < m*m) return mid (v0,l,m);
    
}
long int test(long int v0, long int l, long int r){
    long int m;
    while(1){
        m = (l+r)>>1;
        printf("%d %d %d\n",m,l,r);
        if (v0 == l*l) {
            return l;
        }
        else if (v0 == r*r) return r;
        else if (v0==m*m) return m;
        else if (r-l==1) return l;
        else if (v0 > m*m) 
        {
            // return mid(v0,m,r);
            l = m;
            continue;
        }  
        else if (v0 < m*m){
            // return mid (v0,l,m);
            r = m;
        } 
    }
    
}
int main (){
    long int v0;
    // freopen("testout","w",stdout);
    while (~scanf("%lx",&v0)){
        if (v0>0xFFFE0001){
            printf("%lx\n",0xffff);
        }
        else {
            printf("%lx\n",test(v0,0,65535));
        }
    }
    
    return 0;
}