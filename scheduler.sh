#!/bin/bash

# ==============================
# CPU Scheduling Simulator
# Author: Om
# Description: Simulates FCFS, SJF, and Priority Scheduling
# ==============================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear

echo -e "${BLUE}========================================="
echo -e "     CPU SCHEDULING ALGORITHM SIMULATOR"
echo -e "=========================================${NC}"

input_processes() {
    read -p "Enter number of processes: " n

    for ((i=0;i<n;i++))
    do
        read -p "Enter Burst Time for Process P$i: " bt[$i]
        read -p "Enter Priority for Process P$i (lower = higher priority): " pr[$i]
    done
}

fcfs() {
    echo -e "\n${YELLOW}--- FCFS Scheduling ---${NC}"
    wt[0]=0

    for ((i=1;i<n;i++))
    do
        wt[$i]=$(( wt[$i-1] + bt[$i-1] ))
    done

    display_results
}

sjf() {
    echo -e "\n${YELLOW}--- SJF Scheduling ---${NC}"

    for ((i=0;i<n;i++))
    do
        for ((j=i+1;j<n;j++))
        do
            if [ ${bt[$i]} -gt ${bt[$j]} ]; then
                temp=${bt[$i]}
                bt[$i]=${bt[$j]}
                bt[$j]=$temp
            fi
        done
    done

    wt[0]=0
    for ((i=1;i<n;i++))
    do
        wt[$i]=$(( wt[$i-1] + bt[$i-1] ))
    done

    display_results
}

priority_sched() {
    echo -e "\n${YELLOW}--- Priority Scheduling ---${NC}"

    for ((i=0;i<n;i++))
    do
        for ((j=i+1;j<n;j++))
        do
            if [ ${pr[$i]} -gt ${pr[$j]} ]; then
                temp=${pr[$i]}
                pr[$i]=${pr[$j]}
                pr[$j]=$temp

                temp2=${bt[$i]}
                bt[$i]=${bt[$j]}
                bt[$j]=$temp2
            fi
        done
    done

    wt[0]=0
    for ((i=1;i<n;i++))
    do
        wt[$i]=$(( wt[$i-1] + bt[$i-1] ))
    done

    display_results
}

display_results() {
    total_wt=0
    total_tat=0

    echo -e "\nProcess\tBurst\tWaiting\tTurnaround"

    for ((i=0;i<n;i++))
    do
        tat[$i]=$(( wt[$i] + bt[$i] ))
        total_wt=$(( total_wt + wt[$i] ))
        total_tat=$(( total_tat + tat[$i] ))

        echo -e "P$i\t${bt[$i]}\t${wt[$i]}\t${tat[$i]}"
    done

    avg_wt=$(echo "scale=2; $total_wt/$n" | bc)
    avg_tat=$(echo "scale=2; $total_tat/$n" | bc)

    echo -e "\n${GREEN}Average Waiting Time: $avg_wt${NC}"
    echo -e "${GREEN}Average Turnaround Time: $avg_tat${NC}"
}

input_processes

echo -e "\nChoose Scheduling Algorithm:"
echo "1. FCFS"
echo "2. SJF"
echo "3. Priority"

read -p "Enter choice: " choice

case $choice in
    1) fcfs ;;
    2) sjf ;;
    3) priority_sched ;;
    *) echo -e "${RED}Invalid Choice!${NC}"
esac
