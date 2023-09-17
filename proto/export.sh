###############################################################################
# Copyright(C)   machine studio                                                #
# Author:        donney                                                       #
# Email:         donney_luck@sina.cn                                          #
# Date:          2022-02-10                                                   #
# Description:   export proto                                                 #
# Modification:  null                                                         #
###############################################################################

#!/bin/bash
#FILES=`ls *.proto`
# use fd better, must install fd
FILES=`fd -e proto`
for file in ${FILES[*]}; do
    echo "export protofile:" $file
    protoc -o ${file%.proto}.pb $file
done
