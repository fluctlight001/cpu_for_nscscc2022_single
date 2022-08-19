#include <stdio.h>
int main (){
    long int n;
    // freopen("testout","w",stdout);
    while (~scanf("%ld",&n)){
        int flag = 0;
        for(long int i=1;i<=65535;i++){
            if (i*i>n){
                printf("%ld\n",i-1);
                flag = 1;
                break;
            }
            else if (i*i==n){
                printf("%ld\n",i);
                flag = 1;
                break;
            }
            // printf("%ld",i*i);
        }
        if (flag==0) {
            printf("65535\n");
        }
    }
    
    return 0;
}