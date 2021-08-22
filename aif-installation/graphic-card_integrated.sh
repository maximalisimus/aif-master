#!/bin/zsh
GRAPHIC_CARD=$(lspci | grep -Ei "3d|vga" | sed 's/.*://' | sed 's/(.*//' | sed 's/^[ \t]*//')
Integrated_Intel=$(lscpu | grep -Ei "intel|lenovo" | sed 's/.*://' | sed 's/(.*//' | sed 's/^[ \t]*//' | grep -vi "genuine" | grep -Eoi "intel|lenovo" | uniq -di | awk '!/^$/{print $0}')
Integrated_AMD=$(lscpu | grep -Ei "ati|amd" | sed 's/.*://' | sed 's/(.*//' | sed 's/^[ \t]*//' | grep -vi "genuine" | grep -Eoi "ati|amd" | uniq -di | awk '!/^$/{print $0}')
echo "Graphic Card."
echo "ATI / AMD:"
echo "${GRAPHIC_CARD}" | grep -Ei 'ati|amd' | awk '/ATI|AMD/' RS=" "
echo ""
echo "Intel / Lenovo:"
echo "${GRAPHIC_CARD}" | grep -Ei 'intel|lenovo' | awk '/Intel|Lenovo/' RS=" "
echo ""
echo "VIA:"
echo "${GRAPHIC_CARD}" | grep -Ei 'via' | awk '/VIA/' RS=" "
echo ""
echo "VirtualBox:"
echo "${GRAPHIC_CARD}" | grep -Ei 'virtualbox' | awk '/VirtualBox/' RS=" "
echo ""
echo "VMWARE:"
echo "${GRAPHIC_CARD}" | grep -Ei 'vmware' | awk '/VMware/' RS=" "
echo ""
echo "Integrated."
echo "${Integrated_Intel}"
echo "${Integrated_AMD}"
echo ""
exit 0
