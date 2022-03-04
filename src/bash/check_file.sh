#!/bin/bash

done_file_present=false
wait_for_done_file_availability() {
  while true; do
    if hadoop fs -test -e $1; then
      echo "[$1] exists"
      done_file_present=true
      break
    else
      echo "WAITING : [$1] doesn't exists yet"
      echo "sleeping for 5mins"
      sleep 5m
    fi
  done
}

echo "START: cbb_st_omnichannel_product_taxonomy_temp.sh"
sh ./cbb_st_omnichannel_product_taxonomy_temp.sh > cbb_st_omnichannel_product_taxonomy_temp.out 2>&1 &
pid_cbb_st_omnichannel_product_taxonomy_temp=$!

echo "START: cbb_st_omnichannel_item_dim_raw_temp.sh"
sh ./cbb_st_omnichannel_item_dim_raw_temp.sh > cbb_st_omnichannel_item_dim_raw_temp.out 2>&1 &
pid_cbb_st_omnichannel_item_dim_raw_temp=$!

echo "START: cbb_st_omnichannel_is_walmart_pay_temp.sh"
sh ./cbb_st_omnichannel_is_walmart_pay_temp.sh > cbb_st_omnichannel_is_walmart_pay_temp.out 2>&1 &
pid_cbb_st_omnichannel_is_walmart_pay_temp=$!

echo "WAITING: subprocesses pid_cbb_st_omnichannel_product_taxonomy_temp=${pid_cbb_st_omnichannel_product_taxonomy_temp} pid_cbb_st_omnichannel_item_dim_raw_temp=${pid_cbb_st_omnichannel_item_dim_raw_temp} pid_cbb_st_omnichannel_is_walmart_pay_temp=${pid_cbb_st_omnichannel_is_walmart_pay_temp} to finish"
wait ${pid_cbb_st_omnichannel_product_taxonomy_temp} ${pid_cbb_st_omnichannel_item_dim_raw_temp} ${pid_cbb_st_omnichannel_is_walmart_pay_temp}
echo "FINISHED: subprocesses pid_cbb_st_omnichannel_product_taxonomy_temp,pid_cbb_st_omnichannel_item_dim_raw_temp,pid_cbb_st_omnichannel_is_walmart_pay_temp finished"

CUST_VISIT_DONE_PATH=gs://b6fe45edf9d088d5c9420e67bffc8ab342a8a73adb27bfa9f8c444deaf8652/donefiles/us_dl_transactions_restrict/cust_visit.done
CUST_VISIT_TENDER_DONE_PATH=gs://b6fe45edf9d088d5c9420e67bffc8ab342a8a73adb27bfa9f8c444deaf8652/donefiles/us_dl_transactions_restrict/cust_visit_tender.done
CUST_SCAN_DONE_PATH=gs://b6fe45edf9d088d5c9420e67bffc8ab342a8a73adb27bfa9f8c444deaf8652/donefiles/us_dl_transactions_restrict/cust_scan.done

done_file_present=false
wait_for_done_file_availability $CUST_VISIT_DONE_PATH
if [ $done_file_present ]; then
    echo "START: cbb_st_omnichannel_cust_visit_temp.sh"
    sh ./cbb_st_omnichannel_cust_visit_temp.sh > cbb_st_omnichannel_cust_visit_temp.out 2>&1 &
    pid_cbb_st_omnichannel_cust_visit_temp=$!
fi

done_file_present=false
wait_for_done_file_availability $CUST_VISIT_TENDER_DONE_PATH
if [ $done_file_present ]; then
    echo "START: cbb_st_omnichannel_cust_visit_tender_temp.sh"
    sh ./cbb_st_omnichannel_cust_visit_tender_temp.sh > cbb_st_omnichannel_cust_visit_tender_temp.out 2>&1 &
    pid_cbb_st_omnichannel_cust_visit_tender_temp=$!
fi

done_file_present=false
wait_for_done_file_availability $CUST_SCAN_DONE_PATH
if [ $done_file_present ]; then
    echo "START: cbb_st_omnichannel_cust_scan_temp.sh"
    sh ./cbb_st_omnichannel_cust_scan_temp.sh > cbb_st_omnichannel_cust_scan_temp.out 2>&1 &
    pid_cbb_st_omnichannel_cust_scan_temp=$!
fi

echo "WAITING: pid_cbb_st_omnichannel_cust_visit_temp=${pid_cbb_st_omnichannel_cust_visit_temp} pid_cbb_st_omnichannel_cust_visit_tender_temp=${pid_cbb_st_omnichannel_cust_visit_tender_temp} pid_cbb_st_omnichannel_cust_scan_temp=${pid_cbb_st_omnichannel_cust_scan_temp} to finish"
wait pid_cbb_st_omnichannel_cust_visit_temp pid_cbb_st_omnichannel_cust_visit_tender_temp pid_cbb_st_omnichannel_cust_scan_temp
echo "FINISHED: pid_cbb_st_omnichannel_cust_visit_temp pid_cbb_st_omnichannel_cust_visit_tender_temp pid_cbb_st_omnichannel_cust_scan_temp"

echo "START: cbb_st_omnichannel_inid_luid_temp.sh"
sh ./cbb_st_omnichannel_inid_luid_temp.sh > cbb_st_omnichannel_inid_luid_temp.out 2>&1 &
pid_cbb_st_omnichannel_inid_luid_temp=$!
echo "WAITING : subprocess pid_cbb_st_omnichannel_inid_luid_temp=$cbb_st_omnichannel_inid_luid_temp to finish"
wait $cbb_st_omnichannel_inid_luid_temp
echo "FINISHED: subprocess pid_cbb_st_omnichannel_inid_luid_temp"

echo "START: cbb_omnichannel_store_l2_txn.sh"
sh ./cbb_omnichannel_store_l2_txn.sh > cbb_omnichannel_store_l2_txn.out 2>&1 &
pid_cbb_omnichannel_store_l2_txn=$!
echo "WAITING : subprocess pid_cbb_omnichannel_store_l2_txn=$pid_cbb_omnichannel_store_l2_txn to finish"
wait $pid_cbb_omnichannel_store_l2_txn
echo "FINISHED: subprocess pid_cbb_omnichannel_store_l2_txn"