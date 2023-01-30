
BLOG
http://erpqueries.blogspot.com/2013/12/xml-publisher-matrix-report-cross-tab.html



Following are the tags used.

headercolumn = <?horizontal-break-table:1?>

for1 = <?for-each-group@section:G_QUOTATION;DESCRIPTION?>   <?variable@incontext:DES;DESCRIPTION?>

for2 = <?for-each-group@column:  G_QUOTATION;VENDOR_NAME?> <?end for-each-group?>

for3 = <?for-each-group@cell://G_QUOTATION;VENDOR_NAME?> <?end for-each-group?>

for4 = <?for-each-group@cell://G_QUOTATION;VENDOR_NAME?> <?end for-each-group?>

for5 = <?for-each-group@cell://G_QUOTATION;VENDOR_NAME?> <?end for-each-group?>


QPRICE = <?if:count(current-group()[DESCRIPTION=$DES])?>  <?current-group()[DESCRIPTION=$DES]/QUOTE_PRICE?>  <?end if?>                         

For6 = <?for-each-group@cell:G_QUOTATION;VENDOR_NAME?>   <?variable@incontext:VEN;VENDOR_NAME?>

                                                                                      
Sum(QPRICE) = <?if:count(current-group()[VENDOR_NAME=$VEN])?>  <?sum(current-group()[VENDOR_NAME=$VEN]/QUOTE_PRICE)?>  <?end if?> 
