######################################################################
##                                                                  ##
##                  Dependences configuration                       ##
##                You need the "Dialog" package                     ##
##                      for this script                             ##
##                                                                  ##
######################################################################

setcolor()
{
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"
    SETCOLOR_FAILURE="echo -en \\033[1;31m"
    SETCOLOR_NORMAL="echo -en \\033[0;39m"
}
outin_success()
{
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
}
outin_failure()
{
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
}
