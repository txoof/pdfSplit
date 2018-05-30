# pdfSplit
split PDFs based on student information contained in PDF

Created by Aaron Ciuffo (aaron dot ciuffo) 

Released under GPLv3 
* Available at https://www.gnu.org/licenses/gpl-3.0.html 

# Project Title
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
* Download the zip file: [https://github.com/txoof/pdfSplit/blob/master/ReportSplit.tgz]
* Open the zip file








### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
