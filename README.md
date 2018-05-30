# pdfSplit
split PDFs based on student information contained in PDF

Created by Aaron Ciuffo (aaron dot ciuffo) 

Released under GPLv3 
* Available at https://www.gnu.org/licenses/gpl-3.0.html 

The reportSplit.sh script takes exactly one argument that is the path to a PDF file and creates a sub directory at the same path in the format:
/split_[original_filename]/. The script then uses pdfgrep and sejda-console to
split the original PDF into individual PDFs based on internal text boundaries.

reportSplit.sh is also packaged as an OS X Platypus appliacation under the name:
reportSplit.app - this accepts a dropped PDF and can be run via the GUI.

The script searches and splits orginal PDF for the following string:
```Student: Nelson Mandella StudentID:123456```
Whitespace inside the above pattern is ignored.

### Prerequisites
* Sejda-Console - this is included with the script
* pdfgrep - provided by homebrew on OS X 
  * In managed, non sudoer environments this can be installed by it support
```
brew install pdfgrep
```
## Getting Started
* Download the zip file: [https://github.com/txoof/pdfSplit/raw/master/ReportSplit.tgz]

### Installing
* Open the zip file and locate the ReportSplit Application
* Move the ReportSplit application to your Application or Documents folder
* Double click on the application
  * If your computer gives the message "“ReportSplit.app” is an application downloaded from the Internet. Are you sure you want to open it?" please choose "Open" or contact IT Support
* Drag a PDF to be split onto the application window. A new folder will appear in the same folder as the PDF with the split PDFs.

## Authors

* **Aaron Ciuffo** - *Initial work* - [Txoof](https://github.com/txoof)

## License

This project is licensed under the GPL V3 License
