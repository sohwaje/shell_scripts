#!/bin/bash                               

set -- -abc hello world      # 파라미터를 위치 매개 변수에 설정                  

echo $OPTIND                                  

getopts abc opt                                  
echo $opt, $OPTIND                             

getopts abc opt                                  
echo $opt, $OPTIND                              

getopts abc opt                                  
echo $opt, $OPTIND                             

shift $(( OPTIND - 1 ))                         
echo "$@"      
                
# 1         (index 1 은 -abc 를 가리킴
# a, 1      (index 1 은 -abc 를 가리킴
# b, 1      (index 1 은 -abc 를 가리킴
# c, 2      (index 2 는 hello 를 가리킴
# hello world 