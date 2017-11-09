# pdfSplit
split PDFs based on student information contained in PDF

Created by Aaron Ciuffo (aaron dot ciuffo) 

Released under GPLv3 
* Available at https://www.gnu.org/licenses/gpl-3.0.html 

The reportSplit.sh script takes exactly one argument that is the path to a PDF
file and creates a sub directory at the same path in the format:
/split_original_filename/. The script then uses pdfgrep and sejda-console to
split the original PDF into individual PDFs based on internal text boundaries.

reportSplit.sh is also packaged as an OS X Platypus appliacation under the name:
reportSplit.app - this accepts a dropped PDF and can be run via the GUI.

The script searches the orginal PDF for the following line:
Student: Nelson Mandella StudentID:123456 

Variants of the above pattern are also accepted.

Requirements:
  * a working installation of PDF Grep: https://pdfgrep.org/ 
      - on OS X this is available via HomeBrew: https://brew.sh/
  * Sejda-Console - this is included with the script
